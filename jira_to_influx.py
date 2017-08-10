# -*- coding: utf-8 -*-
import os, sys

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
sys.path.append(PROJECT_ROOT)


import json
import requests
from requests.auth import HTTPBasicAuth
import urllib
import sys
import datetime

import config.config_parser
from config.config_parser import ConfigSectionMap
config.config_parser.setup("influxdb")
 
date = datetime.datetime.now()

project = sys.argv[1]
issue_type = sys.argv[2]

jira = ConfigSectionMap("jira")
influxdb = ConfigSectionMap("influxdb")

jira_user = jira["username"]
jira_passwd = jira["password"]
jira_url = jira["url"]

influx_user = influxdb["username"]
influx_passwd = influxdb["password"]
influx_url = influxdb["url"]
influx_write = influx_url + '/write?db=verso'

def store_json(data):
    with open("output", "w") as f:
        f.write(json.dumps(data, sort_keys=True, indent=4,separators=(',',':')))

def get_sprint_id(json_data):
    return json_data["sprintsData"]["sprints"][0]["id"]

def count_subtask_completion_rate(data):
    completion = []
    for subtask in data:
        if subtask["fields"]["status"]["name"] == "Rejected":
            continue
        if subtask["fields"]["status"]["statusCategory"]["name"] in ["Closed", "Done"]:
            completion.append(1)
        else:
            completion.append(0)
    try:
        return float(completion.count(1))/len(completion)
    except ZeroDivisionError:
        return 0

defect_classes = ["1. Low", "2. Medium", "3. High", "4. Critical"]

print "*******************\n" + "beginning run at: " + str(date) + "\n"
try:
    #########################################
    # Feature Progress
    #########################################
    try:
        # Get all active sprint names from current KanBan board
        r = requests.get(jira_url + "/rest/greenhopper/1.0/xboard/work/allData.json?rapidViewId=14&selectedProjectKey=BIM",
                        auth=HTTPBasicAuth(jira_user, jira_passwd))
        sprints = []
        for sprint in r.json()["sprintsData"]["sprints"]:
            sprints.append("'" + sprint["name"] + "'")

        # Get all features in previously obtained sprints
        string = urllib.urlencode({"jql": "issueFunction in linkedIssuesOf(\"sprint in ({0})\", \"Belongs in Feature\")".format(",".join(sprints))})
        r = requests.get(jira_url + "/rest/api/2/search?" + string + "&maxResults=1000", auth=HTTPBasicAuth(jira_user, jira_passwd))
        features = {}
        for f in r.json()["issues"]:
            key = f["key"]
            status = f["fields"]["status"]["name"]
            features[key] = {"status" : status, "progress" : []}
            # Get all user stories and bugs linked to the feature
            string = urllib.urlencode({"jql": "issueFunction in linkedIssuesOf('issue={0}','Is Feature Of')".format(key)})
            r2 = requests.get(jira_url + "/rest/api/2/search?" + string + "&maxResults=1000", auth=HTTPBasicAuth(jira_user, jira_passwd))
            if len(r2.json()["issues"]) > 0:    # Ignore features which have 0 user stories or bugs
                for issue in r2.json()["issues"]:
                    try:
                        if issue["fields"]["resolution"]["name"] in ["Closed", "Done", "Rejected"]:
                            complete = 1
                    except TypeError:   # User Story is not finished
                        try:
                            complete = count_subtask_completion_rate(issue["fields"]["subtasks"])
                        except KeyError:    # no subtasks
                            complete = 0
                    features[key]["progress"].append(complete)
            else:   # Features with no user stories get progress set to 0
                features[key]["progress"].append(0)

        for feature in sorted(features):
            # Print and write feature data to InfluxDB
            progress = float(sum(features[feature]["progress"]))/len(features[feature]["progress"]) * 100
            status = features[feature]["status"]
            print feature, progress, status
            requests.post(influx_write,
                        data="feature_progress,featureKey=" + feature.replace(" ", "\ ") + " progress="+str(progress) + ",status=\"" + status + "\",feature=\""+feature+"\"",
                        auth=HTTPBasicAuth(influx_user, influx_passwd))
    except KeyError:
        print "Failed to get feature progress: status code: 500, response json: " + str(r.json())

    #########################################
    # The amount of Issues
    #########################################
    total = 0
    for defect in defect_classes:
        string = urllib.urlencode({"jql": "project = {0} and issuetype = {1} and 'Defect Class' = '{2}' and status not in (Closed, Resolved, Rejected)".format(project, issue_type, defect)})
        r = requests.get(jira_url + "/rest/api/2/search?" + string + "&maxResults=0", auth=HTTPBasicAuth(jira_user, jira_passwd))
        print defect, r.json()['total']
        total += r.json()['total']
        requests.post(influx_write,
                    data="jira_bugs,project=" + project + ",defectClass=" + defect.replace(" ", "\ ") + " openIssues="+str(r.json()['total']),
                    auth=HTTPBasicAuth(influx_user, influx_passwd))
    print "Total:", total

    #########################################
    # Remaining time estimate
    #########################################
    r = requests.get(jira_url + "/rest/greenhopper/1.0/xboard/work/allData.json?rapidViewId=14&selectedProjectKey=BIM",
                    auth=HTTPBasicAuth(jira_user, jira_passwd))

    time_estimate = 0
    time_spent = 0
    for issue in sorted(r.json()["issuesData"]["issues"]):
        try:
            time_estimate += issue["trackingStatistic"]["statFieldValue"]["value"]

            # Time spent
            try:
                tmp = issue["parentKey"]
                if issue["extraFields"][2]["html"]:
                    fields = issue["extraFields"][2]["html"].split()
                    days = hours = "00"
                    if len(fields) > 1:
                        days, hours = fields
                    else:
                        if fields[0].endswith('d'):
                            days = fields[0]
                        else:
                            hours = fields[0]
                    days = days[:-1]
                    hours = hours[:-1]
                    time_spent += (float(days) * 7.5 + float(hours)) * 3600
            except KeyError:
                ''' Task is not a sub-task '''
        except KeyError:
            continue


    print "Remaining time estimate", time_estimate
    print "Time spent", time_spent
    r = requests.post(influx_write,
                data="time_estimate,project=" + project + " remainingTimeEstimate=" + str(int(time_estimate)) + "\n" + 
                     "time_estimate,project=" + project + " timeSpent=" + str(int(time_spent)),
                auth=HTTPBasicAuth(influx_user, influx_passwd))
except requests.exceptions.RequestException as e:
    print e