# #!/usr/bin/env python
# # -*- coding: utf-8 -*-
from __future__ import absolute_import
import os, sys, re, time, platform

import requests
from requests.auth import HTTPBasicAuth

from datetime import datetime, timedelta
from robot.api import ExecutionResult, ResultVisitor
from robot.result.model import TestCase

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
CONFIG_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "config"))
sys.path.append(PROJECT_ROOT)
sys.path.append(CONFIG_PATH)

import config_parser
from config_parser import ConfigSectionMap
config_parser.setup("influxdb")
influxdb = ConfigSectionMap("influxdb")

influx_user = influxdb["username"]
influx_passwd = influxdb["password"]
influx_url = influxdb["url"]
influx_write = influx_url + '/write?db=verso'

system = platform.system()

class KeywordTimes(ResultVisitor):
    """ Counts the time used in execution of a keyword and send the data to InfluxDB by using InfluxDBExporter class.

    Keyword execution data is collected from robot framework test output file (usually output.xml).

    Indented to be run as python script in the root of the project in a following way:

    python libs\result_exporter\KeywordTimes.py    robot_framework_output.xml    keyword name/pattern

    Example:

    python libs\result_exporter\KeywordTimes.py output.xml "Customer Search Is Complete"

    Code is based on https://gist.github.com/Tattoo/6208942.

    """

    VAR_PATTERN = re.compile(r'^(\$|\@)\{[^\}]+\}(, \$\{[^\}]+\})* = ')
    COUNT = 1

    def __init__(self, robot_file, target_kw_name):
        self.robot_output_file = robot_file
        self.target_keyword_name = target_kw_name
        self.keywords = {}

    def end_keyword(self, keyword):
        name = self._get_name(keyword)
        if self.target_keyword_name in name:
            new_name = name + ' ' + str(self.COUNT)
            (dt, msecs) = keyword.endtime.strip().split(".")
            dt = datetime(*time.strptime(dt, "%Y%m%d %H:%M:%S")[0:6])
            mseconds = timedelta(microseconds=int(msecs))
            fulldatetime = dt + mseconds
            test_case =  self._get_test_case(keyword)
            self.keywords[new_name] = [new_name, 0, 0, keyword.status, test_case]
            self.keywords[new_name][1] = keyword.elapsedtime
            self.keywords[new_name][2] = time.mktime(fulldatetime.timetuple())
            self.COUNT += 1


    def _get_name(self, keyword):
        name = keyword.name
        m = self.VAR_PATTERN.search(name)
        if m:
            return name[m.end():]
        return name

    def _get_test_case(self, keyword):
        if type(keyword) == TestCase:
            return keyword
        else:
            return self._get_test_case(keyword.parent)


def process(output_file, keyword_name, measurement, env, dryrun=False):
    """ Process robot report and fetch following data related to keyword:
    total time (ms) | Unix timestamp | Keyword name

    After prosessing send data to InfluxDB using InfluxDBExporter.

    :param output_file: robot test report xml.
    :param keyword_name: robot keyword which data is parsed from report
    :return: 505 |   1432552546.0 | "customers_keywords.Customer Search Is Complete 1"
    """
    result = ExecutionResult(output_file)
    times = KeywordTimes(output_file, keyword_name)
    result.visit(times)
    s = sorted(times.keywords.values(), lambda a, b: b[1] - a[1])
    for k, d, ut, stat, tc in s:
        print str(d).rjust(15) + ' | ' + str(ut).rjust(14) + ' | ' + stat.rjust(6) + ' | "%s"' % k + " / {0}".format(str(tc))
        # Skip data export when running tests etc.
        if not dryrun:
            requests.post(influx_write,
                    data= measurement + ",keyword=\"" + keyword_name.replace(" ", "\ ") + "\" keyword=\"" + keyword_name + "\",elapsedTime=" + str(d) + ",startTime=" + str(ut) + ",status=\"" + stat + "\",sandbox=\"" + env + "\",platform=\"" + system + "\",testCase=\"" + str(tc) + "\"",
                    auth=HTTPBasicAuth(influx_user, influx_passwd))
            time.sleep(0.1)     # Ensure we get a different timestamp
    return s


if __name__ == '__main__' and __package__ is None:
    try:
        i = sys.argv.index("-k")
        configs = sys.argv[1:i]
        keywords = sys.argv[i+1:]   # skip "-k"
    except ValueError:
        sys.exit("Usage: python keyword_monitor.py <output.xml> <environment> [measurement] -k \"<keyword>\" ...")
    robot_output_file = configs[0]
    env = configs[1]
    measurement = "keyword_monitor"
    try:
        measurement += "_" + configs[2]
    except IndexError:
        pass

    print 'Total time (ms) | Unix timestamp | Status | Keyword name / Test Case'
    for target_keyword_name in keywords:
        process(robot_output_file, target_keyword_name, measurement, env)
