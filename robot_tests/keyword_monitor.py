#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys
import requests
from requests.auth import HTTPBasicAuth

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
CONFIG_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "config"))
sys.path.append(PROJECT_ROOT)
sys.path.append(CONFIG_PATH)

OUTPUT_FILE = os.path.join(PROJECT_ROOT, "testOutput", "tmp", "output.xml")

import xml.etree.ElementTree as ET

import config_parser
from config_parser import ConfigSectionMap
config_parser.setup("influxdb")
influxdb = ConfigSectionMap("influxdb")

influx_user = influxdb["username"]
influx_passwd = influxdb["password"]
influx_url = influxdb["url"]
influx_write = influx_url + '/write?db=verso'


def change_to_seconds(time):
    time = time.split()[1].split(":")
    seconds = float(time[0]) * 3600 + float(time[1]) * 60 + float(time[2])
    return seconds

if __name__ == "__main__":
    tree = ET.parse(OUTPUT_FILE)
    root = tree.getroot()
    keyword = root.find(".//kw[@name='Search And Add Product To Cart (CPQ)']")
    kw_name =  keyword.get("name")
    status = keyword.find("status")
    kw_status = status.get("status")
    start =  change_to_seconds(status.get("starttime"))
    end = change_to_seconds(status.get("endtime"))
    elapsed = end - start

    requests.post(influx_write,
                    data="keyword_monitor,keyword=" + kw_name.replace(" ", "\ ") + ",status=" + kw_status.replace(" ", "\ ") + " keyword=" + kw_name.replace(" ", "\ ") + ",elapsedTime=" + str(elapsed) + ",status=" + kw_status.replace(" ", "\ "),
                    auth=HTTPBasicAuth(influx_user, influx_passwd))

