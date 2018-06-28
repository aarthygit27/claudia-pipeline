import os, sys

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
CONFIG_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "..", "config"))
LIBS_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "libs"))
sys.path.append(PROJECT_ROOT)
sys.path.append(CONFIG_PATH)
sys.path.append(LIBS_PATH)

from login import get_sessionId_and_serverUrl
from rest_wrapper import RestWrapper
from send_email import send_password_clarification_email

import config_parser
from config_parser import ConfigSectionMap

def main(env, users):
    # Initialize
    salesforce = ConfigSectionMap(env)
    session_id, server_url = get_sessionId_and_serverUrl(salesforce["instance"], LIBS_PATH, salesforce["username"], salesforce["password"] + salesforce["token"])
    rw = RestWrapper(session_id, server_url, env)
    output = rw.get_all_users_from_salesforce()
    salesforce_users = rw.get_all_user_info_from_salesforce(output)

    # Failsafe
    skip_users = ["fbl11955", " siprora1", "sec", "integ"]

    for alias in users:
        if alias not in skip_users:
            try:
                id = salesforce_users[alias]["Id"]
                data = {"IsActive" : 0}
                rw.update_user(id, data)
                if rw.get_user_info_from_salesforce(id)["IsActive"]:
                    print "User '{0}' ({1}) was supposed be deactivated, but was active".format(alias, salesforce_users[alias]["Name"].encode("utf-8"))
                    continue
                print "User {0} ({1}) deactivated.".format(alias, salesforce_users[alias]["Name"].encode("utf-8"))
            except KeyError:
                print "User {0} not found in {1} envinronment.".format(alias, env.upper())


if __name__ == '__main__':
    main(sys.argv[1].lower(), sys.argv[2:])