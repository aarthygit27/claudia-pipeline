# -*- coding: utf-8 -*-

import os, sys

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
CONFIG_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "..", "config"))
<<<<<<< HEAD
sys.path.append(PROJECT_ROOT)
sys.path.append(CONFIG_PATH)

from libs.login import get_sessionId_and_serverUrl
from libs.rest_wrapper import RestWrapper
from libs.send_email import send_notification_email
=======
LIBS_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "libs"))
sys.path.append(PROJECT_ROOT)
sys.path.append(CONFIG_PATH)
sys.path.append(LIBS_PATH)

from login import get_sessionId_and_serverUrl
from rest_wrapper import RestWrapper
from send_email import send_password_clarification_email
>>>>>>> master

import config_parser
from config_parser import ConfigSectionMap

if __name__ == "__main__":
<<<<<<< HEAD
    if len(sys.argv) != 2: sys.exit("Usage: python user_transfer.py <environment>")
    env = sys.argv[1]
    salesforce = ConfigSectionMap(env)
    wiki = ConfigSectionMap("wiki")

    session_id, server_url = get_sessionId_and_serverUrl(salesforce["instance"], PROJECT_ROOT, salesforce["username"], salesforce["password"] + salesforce["token"])

    rw = RestWrapper(session_id, server_url, env)
    wiki_users = rw.get_users_from_wiki(wiki["username"], wiki["password"])
    output = rw.get_all_users_from_salesforce()
    salesforce_users = rw.get_all_user_info_from_salesforce(output, wiki_users)

    if len(wiki_users) == 0:
        sys.exit("Unable to parse any users. Arboting")

    # These users cannot be changed via REST API. Test Automation user is skipped to ensure we always have one usable account to use
    # Rainer Sipronius is default user
    # Tom Sjöberg is portal admin
    # skip_users = ["Integration User", "Security User", "Chatter Expert", "Test Automation", "Rainer Sipronius", "Tom Sjöberg", "Anna Vierinen"]
    # Test automation, Rainer Sipronius, Anna Vierinen, Security User, Integration User
    skip_users = ["fbl11955", " siprora1", "vierian1", "sec", "integ"]
=======
    if len(sys.argv) != 3: sys.exit("Usage: python user_transfer.py <environment> test/development/int/common")
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
    salesforce = ConfigSectionMap(env)
    wiki = ConfigSectionMap("wiki")

    session_id, server_url = get_sessionId_and_serverUrl(salesforce["instance"], LIBS_PATH, salesforce["username"], salesforce["password"] + salesforce["token"])

    rw = RestWrapper(session_id, server_url, env)
    wiki_users = rw.get_users_from_wiki(wiki["username"], wiki["password"], correct_list)
    output = rw.get_all_users_from_salesforce()
    salesforce_users = rw.get_all_user_info_from_salesforce(output)

    if len(wiki_users) == 0:
        sys.exit("Unable to parse any users. Aborting")

    # These users cannot be changed via REST API. Test Automation user is skipped to ensure we always have one usable account to use
    # Test automation, Rainer Sipronius, Security User, Integration User
    skip_users = ["fbl11955", " siprora1", "sec", "integ"]
>>>>>>> master
    
    # Add the users from Wiki to skipped users. Transform all users to lower case to avoid typos in names in either list
    skip_users = skip_users + wiki_users.keys()
    skip_users = map(lambda x: x.lower(), skip_users)

<<<<<<< HEAD
    for u in sorted(salesforce_users):
        if u.lower() not in skip_users:
            # If the user is in Salesforce, but not in Wiki, deactivate the user
            id = salesforce_users[u]["Id"]
            data = {"IsActive" : 0,
                    "Username" : salesforce_users[u]["Username"] + ".deactivated"}
            rw.update_user(id, data)
            if rw.get_user_info_from_salesforce(id)["IsActive"]:
                print "User '{0}' ({1}) was supposed be deactivated, but was active".format(u, salesforce_users[u]["Name"])
                continue
            print "User", u, "({0}) deactivated.".format(salesforce_users[u]["Name"].encode("utf-8"))

    # Create a list with all Salesforce users in lower case to prevent typo errors
    current_users = map(lambda x: x.lower(), salesforce_users.keys())

    for u in sorted(wiki_users):
        profile_id = rw.get_profile_id_from_salesforce(wiki_users[u]["Profile"])
        if wiki_users[u]["Role"]:
            role_id = rw.get_user_role_id_from_salesforce(wiki_users[u]["Role"])
        else:
            role_id = None
        if u.lower() not in current_users:
            # If the user is in Wiki, but not in Salesforce, create the user
            r = rw.create_new_user_to_salesforce(wiki_users[u], profile_id, role_id, env)
            if r.status_code != 201:
                print "Failed to create new user {0} ({1} {2}): {3} ".format(u, wiki_users[u]["FirstName"], wiki_users[u]["LastName"], r.text)
                continue
            print "Created new user to Salesforce:", u, "({0} {1})".format(wiki_users[u]["FirstName"], wiki_users[u]["LastName"])
            id = rw.get_user_id_from_salesforce(wiki_users[u]["Alias"])
            if wiki_users[u]["Profile"] not in ["Chatter Free User", "Chatter External User"]:
                rw.set_permission_set_rights(u, id)
            # Creating a user with REST API doesn't send account creation email immediately. Reset password to send email
            rw.reset_user_password(id)
        else:
            # If the user is also in salesforce, ensure their account is activated
            id = salesforce_users[u]["Id"]
            username = rw.generate_new_username(wiki_users[u], env)
            data = {"IsActive" : 1,
                    "ProfileId" : profile_id,
                    "FirstName" : wiki_users[u]["FirstName"],
                    "LastName" : wiki_users[u]["LastName"],
                    "Username": username,
                    "Email" : wiki_users[u]["Email"],
                    "telia_user_ID__c": wiki_users[u]["Alias"]}

            if role_id:
                data["UserRoleId"] = role_id

            # Store old info for future use. Update user data
            old_info = rw.get_user_info_from_salesforce(id)
            rw.update_user(id, data)
            new_info = rw.get_user_info_from_salesforce(id)

            if old_info["IsActive"] != new_info["IsActive"]:
                send_notification_email(username, wiki_users[u]["Email"], salesforce["instance"])

            if not new_info["IsActive"]:
                print "User '{0}' ({1} {2}) was supposed be activated, but was deactive".format(u, wiki_users[u]["FirstName"], wiki_users[u]["LastName"])
                continue

            # Check whether anything has been changed from the users
            print "User", u, "({0} {1})".format(wiki_users[u]["FirstName"], wiki_users[u]["LastName"]), "activated."
            if wiki_users[u]["Profile"] not in ["Chatter Free User", "Chatter External User"]:
                rights_changed = rw.set_permission_set_rights(u, id)
            else:
                rights_changed = False
            changed = "UPDATED" if (rw.user_data_updated(old_info, new_info) or rights_changed) else "UNCHANGED"
            print "...", changed
=======
    # Never deactivate users if the common test user list is run
    if l != "common":
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
>>>>>>> master
