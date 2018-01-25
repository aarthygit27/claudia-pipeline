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