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

ADDRESS_VALIDATION = "https://emily.extra.sonera.fi:62502/Adapters/Global/AddressValidation/Service/ValidateAddressService.serviceagent/ValidateAddressPortTypeEndpoint1"
AVAILABILITY_CHECK = "https://emily.extra.sonera.fi:62503/Adapters/Global/AvailabilityCheck/Service/AvailabilityCheckService.serviceagent/AvailabilityCheckPortTypeEndpoint1"
CASE_MANAGEMENT = "https://emily.extra.sonera.fi:62501/Adapters/B2BSelfcare/CRMCaseManagementCommon-service0.serviceagent/CRMCaseManagementCommonEndpoint0"

def main(env):
    salesforce = ConfigSectionMap(env)

    session_id, server_url = get_sessionId_and_serverUrl(salesforce["instance"], LIBS_PATH, salesforce["username"], salesforce["password"] + salesforce["token"])
    rw = RestWrapper(session_id, server_url, env)

    named_credentials = rw.get_named_credentials()
    print rw.set_named_credential(named_credentials["AddressValidation"], ADDRESS_VALIDATION).json()
    print rw.set_named_credential(named_credentials["AvailabilityCheck"], AVAILABILITY_CHECK).json()
    print rw.set_named_credential(named_credentials["CaseManagement"], CASE_MANAGEMENT).json()

if __name__ == '__main__':
    main(sys.argv[1].lower())