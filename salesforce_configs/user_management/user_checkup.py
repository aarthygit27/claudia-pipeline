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
from send_email import send_notification_email
>>>>>>> master

import config_parser
from config_parser import ConfigSectionMap

<<<<<<< HEAD

def switch_key(dic, key):
    new_dic = {}
    for i in dic:
        new_dic[dic[i][key].encode("utf-8")] = dic[i]
    return new_dic

if __name__ == "__main__":
    '''
    Check the data of a single user
    '''
    if len(sys.argv) != 3: sys.exit("Usage: python user_transfer.py <environment> <tcad>")
    env = sys.argv[1]
    tcad = sys.argv[2]
    salesforce = ConfigSectionMap(env)
    wiki = ConfigSectionMap("wiki")

    session_id, server_url = get_sessionId_and_serverUrl(salesforce["instance"], PROJECT_ROOT, salesforce["username"], salesforce["password"] + salesforce["token"])
    rw = RestWrapper(session_id, server_url, env)

    output = rw.get_all_users_from_salesforce()
    salesforce_users = rw.get_all_user_info_from_salesforce(output)
    wiki_users = rw.get_users_from_wiki(wiki["username"], wiki["password"])

    if len(wiki_users) == 0:
        sys.exit("Unable to parse any users. Arboting")

    wiki_users = switch_key(wiki_users, "Alias")
    salesforce_users = switch_key(salesforce_users, "Alias")

    if tcad not in wiki_users.keys():
        print tcad, "was not found from the Wiki list."
        sys.exit(0)

    if tcad in salesforce_users.keys():
        print "==== Salesforce status for user", tcad, "===="
        print "Firstname:     ", salesforce_users[tcad]["FirstName"]
        print "Lastname:      ", salesforce_users[tcad]["LastName"]
        print "Username:      ", salesforce_users[tcad]["Username"]
        print "Email:         ", salesforce_users[tcad]["Email"]
        print "Alias:         ", salesforce_users[tcad]["Alias"]
        print "User is active:", salesforce_users[tcad]["IsActive"]
        print "User has Sales Console user rights:", rw.check_permission_set(salesforce_users[tcad]["Id"])
    else:
        print "User", tcad, "is not in Salesforce", env, "sandbox."

=======
def generate_user_info_dictionary(firstname,lastname,tcad,email,profile):
    user_info = {}
    user_info["FirstName"] = firstname
    user_info["LastName"] = lastname
    user_info["Alias"] = tcad
    user_info["Email"] = email
    user_info["AboutMe"] = ""
    user_info["Profile"] = profile
    return user_info

if __name__ == "__main__":
    '''
    Update or create a single user
    '''
    if not (7 <= len(sys.argv) <= 9): sys.exit("Usage: python user_checkup.py <environment> <tcad> <firstname> <lastname> <email> <profile[-role]> [parent_role] [manager]")
    env = sys.argv[1].lower()
    tcad = sys.argv[2]
    firstname = sys.argv[3]
    lastname = sys.argv[4]
    email = sys.argv[5]

    salesforce = ConfigSectionMap(env)
    session_id, server_url = get_sessionId_and_serverUrl(salesforce["instance"], LIBS_PATH, salesforce["username"], salesforce["password"] + salesforce["token"])
    rw = RestWrapper(session_id, server_url, env)

    try:
        profile, role = sys.argv[6].split("-")
    except ValueError:
        profile = sys.argv[6]
        role = None

    if role:
        try:
            parent_role = sys.argv[7]
            parent_role_id = rw.get_parent_role_id(parent_role)
        except (ValueError,IndexError):
            parent_role_id = None
        role_id = rw.get_user_role_id_from_salesforce(role, parent_role_id)
    else:
        role_id = None

    try:
        manager = rw.get_user_id_from_salesforce(sys.argv[8])
    except:
        manager = None

    output = rw.get_all_users_from_salesforce()
    salesforce_users = rw.get_all_user_info_from_salesforce(output)

    profile_id = rw.get_profile_id_from_salesforce(profile)

    user_info = generate_user_info_dictionary(firstname, lastname, tcad, email, profile)

    # User data update
    if tcad in salesforce_users.keys():
        rw.activate_existing_user(user_info, salesforce_users[tcad]["Id"], profile_id, role_id, manager, env, salesforce["instance"])
    # Create new user
    else:
        rw.create_new_user_to_salesforce(user_info, profile_id, role_id, manager, env)
>>>>>>> master
