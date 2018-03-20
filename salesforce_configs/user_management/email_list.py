# -*- coding: utf-8 -*-

import sys, os, requests

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
CONFIG_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "..", "config"))
sys.path.append(PROJECT_ROOT)
sys.path.append(CONFIG_PATH)

from libs.users import UserData
import config_parser
from config_parser import ConfigSectionMap

if __name__ == "__main__":
    wiki = ConfigSectionMap("wiki")
    ud = UserData()
    # r = requests.get("http://wiki.intra.sonera.fi/rest/api/content/62789322?expand=body.storage", auth=(wiki["username"], wiki["password"]))
    wiki_users = ud.get_users_from_wiki(wiki["username"], wiki["password"])

    print ";".join(map(lambda x: wiki_users[x]["Email"], wiki_users))
