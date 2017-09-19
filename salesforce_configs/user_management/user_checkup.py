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
    env = sys.argv[1].lower()
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

