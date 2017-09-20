import os, sys

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
CONFIG_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "..", "config"))
sys.path.append(PROJECT_ROOT)
sys.path.append(CONFIG_PATH)

from libs.login import get_sessionId_and_serverUrl
from libs.rest_wrapper import RestWrapper
from libs.send_email import send_notification_email

import config_parser
from config_parser import ConfigSectionMap


if __name__ == "__main__":
    '''
    Update or create a single user
    '''
    if len(sys.argv) != 7: sys.exit("Usage: python user_transfer.py <environment> <tcad> <email> <profile[-role]>")
    env = sys.argv[1].lower()
    tcad = sys.argv[2]
    firstname = sys.argv[3]
    lastname = sys.argv[4]
    email = sys.argv[5]

    salesforce = ConfigSectionMap(env)
    session_id, server_url = get_sessionId_and_serverUrl(salesforce["instance"], PROJECT_ROOT, salesforce["username"], salesforce["password"] + salesforce["token"])
    rw = RestWrapper(session_id, server_url, env)

    try:
        profile, role = sys.argv[6].split("-")
        role_id = rw.get_user_role_id_from_salesforce(role)
    except ValueError:
        profile = sys.argv[6]
        role_id = None


    output = rw.get_all_users_from_salesforce()
    salesforce_users = rw.get_all_user_info_from_salesforce(output)

    profile_id = rw.get_profile_id_from_salesforce(profile)

    # User data update
    if tcad in salesforce_users.keys():
        
        username = rw.generate_new_username(tcad, env)
        id = salesforce_users[tcad]["Id"]

        data = {"IsActive" : 1,
                "FirstName" : firstname,
                "LastName" : lastname,
                "Username": username,
                "Email" : email,
                "telia_user_ID__c": tcad}

        if profile != "System Administrator":
            data["ProfileId"] = profile_id

        if role_id:
            data["UserRoleId"] = role_id

        # Store old info for future use. Update user data
        old_info = rw.get_user_info_from_salesforce(id)
        rw.update_user(id, data)
        new_info = rw.get_user_info_from_salesforce(id)

        if old_info["IsActive"] != new_info["IsActive"]:
            send_notification_email(username, email, salesforce["instance"])

        print "User {0} ({1} {2}) activated.".format(tcad, firstname, lastname)
        if profile not in ["Chatter Free User", "Chatter External User"]:
            rights_changed = rw.set_permission_set_rights(tcad, id)
        else:
            rights_changed = False
        changed = "UPDATED" if (rw.user_data_updated(old_info, new_info) or rights_changed) else "UNCHANGED"
        print "...", changed
    # Create new user
    else:
        new_user = {}
        new_user["FirstName"] = firstname
        new_user["LastName"] = lastname
        new_user["Alias"] = tcad
        new_user["Email"] = email
        new_user["AboutMe"] = ""
        new_user["Profile"] = profile

        rw.create_new_user_to_salesforce(new_user, profile_id, role_id, env)

