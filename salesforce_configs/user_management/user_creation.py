import os, sys

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
CONFIG_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "..", "config"))
LIBS_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "libs"))
sys.path.append(PROJECT_ROOT)
sys.path.append(CONFIG_PATH)
sys.path.append(LIBS_PATH)

from login import get_sessionId_and_serverUrl
from rest_wrapper import RestWrapper
from send_email import send_notification_email

import config_parser
from config_parser import ConfigSectionMap

if __name__ == "__main__":
    if len(sys.argv) != 4: sys.exit("Usage: python user_creation.py <environment> test/development/int [firstrow]-[lastrow]")
    env = sys.argv[1].lower()
    l = sys.argv[2].lower()
    if l == "test":
        correct_list = 62789322 # list of test users
    elif l == "development":
        correct_list = 64292580 # list of development users
    elif l == "int":
        correct_list = 68715658 # list of INT users
    elif l == "common":
        correct_list = 68723261 # list of common users
    else:
        sys.exit("Invalid list of users. Use one of the following: 'test', 'development', 'int', or 'common'")

    first, last = sys.argv[3].split("-")
    first = int(first) if first else 1
    last = int(last) if last else 0     # value 0 will get defaulted to the length of the wiki_users list once the output is parsed

    salesforce = ConfigSectionMap(env)
    wiki = ConfigSectionMap("wiki")

    session_id, server_url = get_sessionId_and_serverUrl(salesforce["instance"], LIBS_PATH, salesforce["username"], salesforce["password"] + salesforce["token"])

    rw = RestWrapper(session_id, server_url, env)
    wiki_users = rw.get_users_from_wiki(wiki["username"], wiki["password"], correct_list, first, last)
    output = rw.get_all_users_from_salesforce()
    salesforce_users = rw.get_all_user_info_from_salesforce(output)

    if len(wiki_users) == 0:
        sys.exit("Unable to parse any users. Aborting")

    current_users = map(lambda x: x.lower(), salesforce_users.keys())


    for u in sorted(wiki_users):
        # Never update the test automation user with scripts
        if u.lower() == "fbl11955":
            continue
        profile_id = rw.get_profile_id_from_salesforce(wiki_users[u]["Profile"])
        # Find the user's manager if possible
        if wiki_users[u]["Manager"]:
            manager = rw.get_user_id_from_salesforce(wiki_users[u]["Manager"])
        else:
            manager = None
        # Find the user's role if possible
        if wiki_users[u]["Role"]:
            parent_role_id = rw.get_parent_role_id(wiki_users[u]["ParentRole"])
            role_id = rw.get_user_role_id_from_salesforce(wiki_users[u]["Role"], parent_role_id)
        else:
            role_id = None

        if u.lower() not in current_users:
            # If the user is in Wiki, but not in Salesforce, create the user
            r = rw.create_new_user_to_salesforce(wiki_users[u], profile_id, role_id, manager, env)
        else:
            # If the user is also in salesforce, ensure their account is activated
            rw.activate_existing_user(wiki_users[u], salesforce_users[u]["Id"], profile_id, role_id, manager, env, salesforce["instance"])