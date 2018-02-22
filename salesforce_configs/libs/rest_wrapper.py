# -*- coding: utf-8 -*-

import re, json, copy

from http_adapter import TLS1_2HttpAdapter
import requests
import xml.etree.ElementTree as ET
from send_email import send_notification_email

class RestWrapper(object):

    def __init__(self, session_id="", server="", env=""):
        self._session_id = session_id
        self._server = self._parse_server_name(server)
        if env == "dev":
            self._url = "https://{0}.salesforce.com".format(self._server)
        else:
            self._url = "https://telia-claudia--{0}.{1}.my.salesforce.com".format(env, self._server)
        self._headers = {"Authorization" : "Bearer {0}".format(self._session_id),
                        "Content-Type": "application/json; charset=UTF-8"}

        self._rest_base = self._url + "/services/data/v41.0"
        self._bulk_base = self._url + "/services/async/41.0"

        # Salesforce requires TLS>=1.1
        self._session = requests.Session()
        self._session.mount(self._url, TLS1_2HttpAdapter())

    def _parse_server_name(self, server_url):
        if server_url:
            return re.search("https:\/\/(.*?)\.salesforce", server_url).group(1)
        return ""

    def _parse_users_from_wiki_output(self, output, first, last):
        # first and last are line numbers, NOT indexes
        try:
            m = re.findall("CDATA\[(.*?)\]", output)
            lines = m[-1].split("\\n")
            lines = lines[1:]   # Remove the header line
            
            first = 1 if first < 1 else first   # Set "first" to be 1 at minimum
            if (last <= 0) or (last > len(lines)):  # Error prevention
                last = len(lines)
            step = 1 if first <= last else -1

            wiki_users = {}
            for i in range(first-1, last, step):
                line = lines[i].strip()
                try:
                    firstname, lastname, alias, email, profile, parent_role, role, manager, aboutme = [x.strip() for x in line.split(",")]
                    json_data = {"FirstName" : firstname,
                                "LastName": lastname,
                                "Alias": alias,
                                "Email": email,
                                "Profile": profile,
                                "ParentRole": parent_role,
                                "Role": role,
                                "Manager": manager,
                                "AboutMe": aboutme
                                }
                    wiki_users[alias] = json_data
                except ValueError:
                    print "Unable to split line number {0}: \'{1}\'. Ignoring the line.".format(i+1, line)
            return wiki_users
        except ValueError:  # Unable to retrieve anything from wiki
            raise ValueError(output)

    def _get_all_user_ids(self, output):
        ids = {}
        for u in output["records"]:
            i = u["Id"]
            alias = u["Alias"]
            ids[alias] = i
        return ids

    def _generate_new_user_data(self, user_info, profile_id, role_id, manager, environment):
        '''
        Create a json object to be used as the REST call body when creating a new user
        '''
        username = self.generate_new_username(user_info["Alias"], environment)

        new_user = {}
        new_user["FirstName"] = user_info["FirstName"]
        new_user["LastName"] = user_info["LastName"]
        new_user["Alias"] = user_info["Alias"]
        new_user["Email"] = user_info["Email"]
        new_user["Username"] = username   # [alias]@teliacompany.com.[environment]
        new_user["AboutMe"] = user_info["AboutMe"]
        if role_id:
            new_user["UserRoleId"] = role_id
        if manager:
            new_user["ManagerId"] = manager

        # Other required fields
        new_user["EmailEncodingKey"] = "ISO-8859-1"
        new_user["TimeZoneSidKey"] = "Europe/Helsinki"
        new_user["LocaleSidKey"] = "fi_FI_EURO"
        new_user["LanguageLocaleKey"] = "en_US"
        new_user["ProfileId"] = profile_id
        new_user["telia_user_ID__c"] = user_info["Alias"]
        
        # Other fields
        self.add_other_fields_to_user(new_user)

        return json.dumps(new_user)

    def _get_permission_set_id(self):
        url ="/query/?q=select+Id,name+from+permissionset+where+name+=+'Sales_Console'"
        r = self._session.get(self._rest_base + url, headers=self._headers)
        permissionsetid = r.json()["records"][0]["Id"]
        return permissionsetid

    def _add_permission_set(self, user_id):
        permissionsetid = self._get_permission_set_id()
        body = {"PermissionSetId": permissionsetid, "AssigneeId": user_id}
        r = self._session.post(self._rest_base + "/sobjects/PermissionSetAssignment", headers=self._headers, data=json.dumps(body))
        return r

    def _add_permission_set_license(self, user_id):
        url = "/query/?q=SELECT+Id,PermissionSetLicenseKey+From+PermissionSetLicense+Where+PermissionSetLicenseKey+=+'SalesConsoleUser'"
        r = self._session.get(self._rest_base + url, headers=self._headers)
        license_id = r.json()["records"][0]["Id"]
        body = {"PermissionSetLicenseId": license_id, "AssigneeId": user_id}
        r = self._session.post(self._rest_base + "/sobjects/PermissionSetLicenseAssign", headers=self._headers, data=json.dumps(body))
        return r

    def add_other_fields_to_user(self, user):
        user["UserPreferencesLightningExperiencePreferred"] = 0     # Change away from lightning view as default
        user["UserPermissionsSupportUser"] = 1  # Change the top banner to be Telia purple instead of blue

    def get_all_users_from_salesforce(self):
        r = self._session.get(self._rest_base + "/query/?q=SELECT+Name,Id,Alias+FROM+User", headers=self._headers)
        return r.json()
        
    def get_user_info_from_salesforce(self, user_id):
        '''
        Get data from a specific user
        '''
        r = self._session.get(self._rest_base + "/sobjects/User/{0}".format(user_id), headers=self._headers)
        return r.json()

    def get_profile_id_from_salesforce(self, name):
        name =  name.strip().replace(" ", "+")
        r = self._session.get(self._rest_base + "/query/?q=SELECT+Id+From+Profile+WHERE+Name+=+'{0}'".format(name), headers=self._headers)
        if len(r.json()["records"]) < 1:    # Default the users to "Standard User" if the specific profile does not exist
            r = self._session.get(self._rest_base + "/query/?q=SELECT+Id+From+Profile+WHERE+Name+=+'Standard+User'", headers=self._headers)
        return r.json()["records"][0]["Id"]

    def get_user_role_id_from_salesforce(self, name, parent_role_id):
        '''
        This method should only be called when the "role" is filled in the Wiki list
        '''
        name =  name.strip().replace(" ", "+")
        query = "/query/?q=SELECT+Id+From+UserRole+WHERE+Name+=+'{0}'".format(name)
        if parent_role_id:
            query += "+AND+("
            for role in parent_role_id:
                query += "ParentRoleId='{0}'+OR+".format(role)
            query = query[:-4] + ")"  # strip the last OR and add a ')'
        r = self._session.get(self._rest_base + query, headers=self._headers)
        try:
            return r.json()["records"][0]["Id"]
        except:
            return None

    def get_user_id_from_salesforce(self, alias):
        r = self._session.get(self._rest_base + "/query/?q=SELECT+Id+From+User+WHERE+Alias+=+'{0}'".format(alias), headers=self._headers)
        try:
            return r.json()["records"][0]["Id"]
        except:
            return None

    def update_user(self, user_id, data):
        # headers["X-SFDC-Session"] = self._session_id  # Bulk API needs the session id in the header
        r = self._session.patch(self._rest_base + "/sobjects/user/{0}".format(user_id), headers=self._headers, data=json.dumps(data))

    def create_new_user_to_salesforce(self, user_info, profile_id, role_id, manager, environment):
        user = self._generate_new_user_data(user_info, profile_id, role_id, manager, environment)
        r = self._session.post(self._rest_base + "/sobjects/User", headers=self._headers, data=user)
        if r.status_code != 201:
            print "Failed to create new user {0} ({1} {2}): {3}".format(user_info["Alias"], user_info["FirstName"], user_info["LastName"], r.text)
        else:
            print "Created new user to Salesforce: {0} ({1} {2})".format(user_info["Alias"], user_info["FirstName"], user_info["LastName"])
            id = self.get_user_id_from_salesforce(user_info["Alias"])
            if user_info["Profile"] not in ["Chatter Free User", "Chatter External User"]:
                self.set_permission_set_rights(user_info["Alias"], id)
            # Creating a user with REST API doesn't send account creation email immediately. Reset password to send email
            self.reset_user_password(id)
        return r

    def get_all_user_info_from_salesforce(self, output):
        '''
        @param: output: a JSON object from get_all_users_from_salesforce()
        '''
        info = self._get_all_user_ids(output)
        users = {}
        for i in info:  # i = alias, info[i] = correct Salesforce user ID
            users[i.encode("utf-8")] = self.get_user_info_from_salesforce(info[i])
        return users
 
    def get_users_from_wiki(self, username, password, correct_list, first=0, last=0):
        r = self._session.get("http://wiki.intra.sonera.fi/rest/api/content/{0}?expand=body.storage".format(correct_list), auth=(username, password))
        if r.status_code != 200:
            raise RuntimeError("Failed to get users from Wiki. Status code: {0}. Output: {1}".format(r.status_code, r.text.encode("utf-8")))
        return self._parse_users_from_wiki_output(r.text.encode("utf-8"), first, last)

    def generate_new_username(self, alias, environment):
        return alias + "@teliacompany.com." + environment

    def user_data_updated(self, first, second):
        ignored_fields = ["LastViewedDate", "LastReferencedDate", "SystemModstamp", "LastModifiedDate", "LastModifiedById"]
        changed = False
        for u in first:
            if first[u] != second[u] and u not in ignored_fields:
                print "  Field changed:", u
                changed = True
        return changed

    def check_permission_set(self, user_id):
        '''
        Checks whether the user has the Sales_Console permission set
        '''
        permissionsetid = self._get_permission_set_id()
        url = "/query/?q=SELECT+PermissionSetId+FROM+PermissionSetAssignment+WHERE+AssigneeId='{0}'".format(user_id)
        r = self._session.get(self._rest_base + url, headers=self._headers)
        for record in r.json()["records"]:
            if record["PermissionSetId"].encode("utf-8") == permissionsetid:
                return True
        return False

    def set_permission_set_rights(self, user, id):
        r = self._add_permission_set_license(id)   # Add Sales Console User permission license set
        r2 = r.status_code
        if r.status_code != 201:
            # If status_code == 201 it does not have "errorCode" field, which gives an error.
            if r.json()[0]["errorCode"] != "DUPLICATE_VALUE":
                raise RuntimeError("Failed to assign permission set license to " + user + ": " + str(r.json()))

        r = self._add_permission_set(id)   # Add Sales Console User permission set
        r1 = r.status_code
        if r.status_code != 201:
            # If status_code == 201 it does not have "errorCode" field, which gives an error.
            if r.json()[0]["errorCode"] != "DUPLICATE_VALUE":
                raise RuntimeError("Failed to assign permission set to " + user + ": " + str(r.json()) + " " + str(r.status_code))
        if r1 == 201 or r2 == 201:
            print "  Added Sales Console User rights for user:", user
            return True
        return False

    def reset_user_password(self, user_id):
        r = self._session.delete(self._rest_base + "/sobjects/User/{0}/password".format(user_id) , headers=self._headers)
        return r

    def get_parent_role_id(self, parent_role):
        if not parent_role:
            return None
        parent_role =  parent_role.strip().replace(" ", "+")
        r = self._session.get(self._rest_base + "/query/?q=SELECT+Id+FROM+UserRole+WHERE+Name='{0}'".format(parent_role), headers=self._headers)
        return [x["Id"] for x in r.json()["records"]]

    def activate_existing_user(self, user_info, salesforce_id, profile_id, role_id, manager, environment, instance):
        username = self.generate_new_username(user_info["Alias"], environment)
        data = {"IsActive" : 1,
                "ProfileId" : profile_id,
                "FirstName" : user_info["FirstName"],
                "LastName" : user_info["LastName"],
                "Username": username,
                "Email" : user_info["Email"],
                "telia_user_ID__c": user_info["Alias"],
                "ManagerId": manager,
                "UserRoleId": role_id
                }

        self.add_other_fields_to_user(data)

        # Store old info for future use. Update user data
        old_info = self.get_user_info_from_salesforce(salesforce_id)
        self.update_user(salesforce_id, data)
        new_info = self.get_user_info_from_salesforce(salesforce_id)

        if old_info["IsActive"] != new_info["IsActive"]:
            send_notification_email(username, user_info["Email"], instance)

        if not new_info["IsActive"]:
            print "User '{0}' ({1} {2}) was supposed be activated, but was deactive".format(user_info["Alias"], user_info["FirstName"], user_info["LastName"])
            return

        # Check whether anything has been changed from the users
        print "User {0} ({1} {2}) activated.".format(user_info["Alias"], user_info["FirstName"], user_info["LastName"])
        if user_info["Profile"] not in ["Chatter Free User", "Chatter External User"]:
            rights_changed = self.set_permission_set_rights(user_info["Alias"], salesforce_id)
        else:
            rights_changed = False
        changed = "UPDATED" if (self.user_data_updated(old_info, new_info) or rights_changed) else "UNCHANGED"
        print "...", changed
        # Return True if user was updated, False otherwise
        return changed == "UPDATED"


    def get_auth_providers(self):
        r = self._session.get(self._rest_base + "/query/?q=SELECT+Id,FriendlyName+FROM+authprovider", headers=self._headers)
        providers = {}
        for provider in r.json()["records"]:
            providers[provider["FriendlyName"]] = provider["Id"]
        return providers

    def set_authorization_url(self, provider, url):
        data = {"AuthorizeUrl" : url}
        r = self._session.patch(self._rest_base + "/sobjects/AuthProvider/" + provider, headers=self._headers, data=json.dumps(data))
        return r

    def set_static_auth_provider_attributes(self, provider, url):
        # These are same for each auth. provider. If some of these change to be different in some auth. providers
        # it needs to be called separately.
        self._set_token_url(provider, url)
        self._set_consumer_key(provider)
        # self._set_consumer_secret(provider)   # Cannot be set with REST API

    def _set_token_url(self, provider, url):
        x = "https://api-garden{0}.teliacompany.com/oauth/client_credential/accesstoken".format(url)
        data = {"TokenUrl": x}
        r = self._session.patch(self._rest_base + "/sobjects/AuthProvider/" + provider, headers=self._headers, data=json.dumps(data))
        return r

    def _set_consumer_key(self, provider):
        # TODO: The consumer key is not the same for each auth. provider. The required auth. provider should be get first from somewhere
        data = {"ConsumerKey": "GYLrGvMFl20HuozAfEv0A2RA77pLcAyr"}
        r = self._session.patch(self._rest_base + "/sobjects/AuthProvider/" + provider, headers=self._headers, data=json.dumps(data))
        return r

    def _set_consumer_secret(self, provider):
        data = {"ConsumerSecret": "xyz"}
        r = self._session.patch(self._rest_base + "/sobjects/AuthProvider/" + provider, headers=self._headers, data=json.dumps(data))
        return r

    # def _parse_integrations_from_wiki_output(self, output):
    #     '''
    #     Parses the XML from the integration setup page. Returns a
    #     dictionary with the alias as the key and a dictionary with
    #     all the fields as the value (with the header as the key)
    #     e.g. {"AvailabilityCheck SIT" : {"Alias": "AC SIT",
    #                     "Integration name (official)": "AvailabilityCheck",
    #                     ...},
    #             "AC UAT": {...}, ...}
    #     '''
    #     table = re.search("<table>(.*?)<\/table>", output).group()
    #     table = str(table).replace("&nbsp;", "")
    #     root = ET.fromstring(table)
    #     headings = root.findall(".//tr")[0].findall("th")
    #     trs = root.findall(".//tr")[1:]     # The first <tr> is the header row
    #     setup = {}
    #     # Alias, Integration name (official), GESB environment, URL, BE environment, Auth, Note
    #     for tr in trs:
    #         alias, integration, gesb, url, be, auth, note = tr.findall("td")

    #         try:
    #             integration = integration.find("p").text.strip()
    #         except AttributeError:
    #             integration = integration.text.strip()

    #         try:
    #             url = url.find(".//a").text.strip()
    #         except AttributeError:
    #             url = ""

    #         if gesb.text != None:
    #             current = {headings[0].text.strip(): alias.text,
    #                         headings[1].text.strip(): integration,
    #                         headings[2].text.strip(): gesb.text,
    #                         headings[3].text.strip(): url,
    #                         headings[4].text.strip(): be.text,
    #                         headings[5].text.strip(): auth.text,
    #                         headings[6].text.strip(): note.text}
    #             setup[integration + " " + gesb.text.strip()] = current
    #     return setup

    # def change_named_credential(self, original, new):
    #     rest_url = original["attributes"]["url"]
    #     data = {"Endpoint": new["URL"]}
    #     r = self._session.patch(self._url + rest_url, headers=self._headers, data=json.dumps(data))

    #     print r.status_code, r.text

    # def get_integration_setup_from_wiki(self, username, password):
    #     r = self._session.get("http://wiki.intra.sonera.fi/rest/api/content/63445308?expand=body.storage", auth=(username, password))
    #     if r.status_code != 200:
    #         raise RuntimeError("Failed to get integrations from Wiki. Status code: {0}. Output: {1}".format(r.status_code, r.text.encode("utf-8")))
    #     return self._parse_integrations_from_wiki_output(r.json()["body"]["storage"]["value"])

    # def get_named_credentials(self):
    #     r = self._session.get(self._rest_base + "/query/?q=SELECT+Id,Endpoint,DeveloperName+FROM+NamedCredential", headers=self._headers)
    #     return r.json()


    ##############################################
    #### BULK API
    ##############################################

    def open_bulk_job(self):
        headers = copy.deepcopy(self._headers)
        headers["X-SFDC-Session"] = self._session_id  # Bulk API needs the session id in the header
        body = { "operation" : "update", "object" : "user", "contentType" : "JSON" }
        r = self._session.post(self._bulk_base + "/job", headers=headers, data=json.dumps(body))
        return r.json()["id"]

    def add_batch(self, job_id, body):
        headers = copy.deepcopy(self._headers)
        headers["X-SFDC-Session"] = self._session_id  # Bulk API needs the session id in the header
        r = self._session.post(self._bulk_base + "/job/{0}/batch".format(job_id), headers=headers, data=json.dumps(body))

    def close_bulk_job(self, job_id):
        headers = copy.deepcopy(self._headers)
        headers["X-SFDC-Session"] = self._session_id  # Bulk API needs the session id in the header
        body = { "state" : "Closed" }
        r = self._session.post(self._bulk_base + "/job/{0}".format(job_id), headers=headers, data=json.dumps(body))

    def get_bulk_info(self, job_id):
        headers = copy.deepcopy(self._headers)
        headers["X-SFDC-Session"] = self._session_id  # Bulk API needs the session id in the header
        r = self._session.get(self._bulk_base + "/job/{0}/batch".format(job_id), headers=headers)
        return r.json()
