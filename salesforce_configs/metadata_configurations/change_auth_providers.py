import os, sys

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
CONFIG_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "..", "config"))
LIBS_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "libs"))
sys.path.append(PROJECT_ROOT)
sys.path.append(CONFIG_PATH)
sys.path.append(LIBS_PATH)

from login import get_sessionId_and_serverUrl
from rest_wrapper import RestWrapper
import config_parser
from config_parser import ConfigSectionMap

URLS = {"preprod": "-uat", "test": "-test", "dev": "-test", "prod": "", "int": "-test", "upg": "-test"}

def main(env):
    salesforce = ConfigSectionMap(env)

    session_id, server_url = get_sessionId_and_serverUrl(salesforce["instance"], LIBS_PATH, salesforce["username"], salesforce["password"] + salesforce["token"])
    rw = RestWrapper(session_id, server_url, env)
    providers = rw.get_auth_providers()
    url = URLS[env]

    u = "https://api-garden{0}.teliacompany.com/v1/finland/resourceavailability/availabilityofall".format(url)
    rw.set_authorization_url(providers["ManualAvailabilityB2O"], u)
    rw.set_static_auth_provider_attributes(providers["ManualAvailabilityB2O"], url)

    u = "https://api-garden{0}.teliacompany.com/v1/finland/productorder".format(url)
    rw.set_authorization_url(providers["SendOrderToSAP"], u)
    rw.set_static_auth_provider_attributes(providers["SendOrderToSAP"], url)

    u = "https://api-garden{0}.teliacompany.com/v1/finland/resourceavailability/availabilityofall".format(url)
    rw.set_authorization_url(providers["AvailabilityCheckB2O"], u)
    rw.set_static_auth_provider_attributes(providers["AvailabilityCheckB2O"], url)

    u = "https://api-garden{0}.teliacompany.com/v1/finland/creditscore".format(url)
    rw.set_authorization_url(providers["CreditScoring"], u)
    rw.set_static_auth_provider_attributes(providers["CreditScoring"], url)

if __name__ == '__main__':
    main(sys.argv[1].lower())