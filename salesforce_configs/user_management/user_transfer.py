# -*- coding: utf-8 -*-

import os, sys

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
CONFIG_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "..", "config"))
sys.path.append(PROJECT_ROOT)
sys.path.append(CONFIG_PATH)

from libs.login import get_sessionId_and_serverUrl
from libs.rest_wrapper import RestWrapper
from libs.send_email import send_password_clarification_email

import config_parser
from config_parser import ConfigSectionMap

if __name__ == "__main__":
    if len(sys.argv) != 3: sys.exit("Usage: python user_transfer.py <environment> test/development")
    env = sys.argv[1].lower()
    if sys.argv[2].lower() == "test":
        correct_list = 62789322 # list of test users
    elif sys.argv[2].lower() == "development":
        correct_list = 64292580 # list of development users
    elif sys.argv[2].lower() == "int":
        correct_list = 68715658 # list of INT users
    else:
        sys.exit("Invalid list of users. Use one of the following: 'test', 'development' or 'int'")
    salesforce = ConfigSectionMap(env)
    wiki = ConfigSectionMap("wiki")

    session_id, server_url = get_sessionId_and_serverUrl(salesforce["instance"], PROJECT_ROOT, salesforce["username"], salesforce["password"] + salesforce["token"])

    rw = RestWrapper(session_id, server_url, env)
    wiki_users = rw.get_users_from_wiki(wiki["username"], wiki["password"], correct_list)
    output = rw.get_all_users_from_salesforce()
    salesforce_users = rw.get_all_user_info_from_salesforce(output)

    if len(wiki_users) == 0:
        sys.exit("Unable to parse any users. Aborting")

    # These users cannot be changed via REST API. Test Automation user is skipped to ensure we always have one usable account to use
    # Test automation, Rainer Sipronius, Security User, Integration User
    skip_users = ["fbl11955", " siprora1", "sec", "integ"]
    
    # Add the users from Wiki to skipped users. Transform all users to lower case to avoid typos in names in either list
    skip_users = skip_users + wiki_users.keys()
    skip_users = map(lambda x: x.lower(), skip_users)

    for u in sorted(salesforce_users):
        if u.lower() not in skip_users:
            # If the user is in Salesforce, but not in Wiki, deactivate the user
            id = salesforce_users[u]["Id"]
            tmp = salesforce_users[u]["Username"]
            username = tmp if u.endswith(".deactivated") else tmp + ".deactivated"
            data = {"IsActive" : 0,
                    "Username" : username}
            rw.update_user(id, data)
            if rw.get_user_info_from_salesforce(id)["IsActive"]:
                print "User '{0}' ({1}) was supposed be deactivated, but was active".format(u, salesforce_users[u]["Name"].encode("utf-8"))
                continue
            print "User {0} ({1}) deactivated.".format(u, salesforce_users[u]["Name"].encode("utf-8"))

    # Create a list with all Salesforce users in lower case to prevent typo errors
    current_users = map(lambda x: x.lower(), salesforce_users.keys())
    updated_users = []

    for u in sorted(wiki_users):
        # Never update the test automation user with a script
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
            updated = r.status_code == 201
        else:
            # If the user is also in salesforce, ensure their account is activated
            updated = rw.activate_existing_user(wiki_users[u], salesforce_users[u]["Id"], profile_id, role_id, manager, env, salesforce["instance"])
        # If the user was created or changed, append the email for the list if the email is not in the list already
        if updated and wiki_users[u]["Email"] not in updated_users:
            updated_users.append(wiki_users[u]["Email"])

    send_password_clarification_email(updated_users, env, sys.argv[2])