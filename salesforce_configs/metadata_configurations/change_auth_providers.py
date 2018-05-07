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

URLS = {"preprod": "-uat", "test": "-test", "dev": "-test", "prod": "", "int": "-test"}

def main(env):
    salesforce = ConfigSectionMap(env)

    session_id, server_url = get_sessionId_and_serverUrl(salesforce["instance"], LIBS_PATH, salesforce["username"], salesforce["password"] + salesforce["token"])
    rw = RestWrapper(session_id, server_url, env)
    providers = rw.get_auth_providers()
    url = URLS[env]
    url_base = "https://api-garden{0}.teliacompany.com/v1/finland".format(url)

    u = url_base + "/resourceavailability/availabilityofall"
    rw.set_authorization_url(providers["AvailabilityCheckB2O"], u)
    rw.set_static_auth_provider_attributes(providers["AvailabilityCheckB2O"], url)

    u = url_base + "/billingaccountmanagement/billingaccount"
    rw.set_authorization_url(providers["BillingAccount"], u)
    rw.set_static_auth_provider_attributes(providers["BillingAccount"], url)

    u = url_base + "/billingAccountService"
    rw.set_authorization_url(providers["BillingAccountService"], u)
    rw.set_static_auth_provider_attributes(providers["BillingAccountService"], url)

    u = url_base + "/BPNAccountManagement/createBPN"
    rw.set_authorization_url(providers["CreateBPNIntegration"], u)
    rw.set_static_auth_provider_attributes(providers["CreateBPNIntegration"], url)

    u = url_base + "/ULMUserManagement/createCompanyUser"
    rw.set_authorization_url(providers["CreateUserToULM"], u)
    rw.set_static_auth_provider_attributes(providers["CreateUserToULM"], url)

    u = url_base + "/creditscore"
    rw.set_authorization_url(providers["CreditScoring"], u)
    rw.set_static_auth_provider_attributes(providers["CreditScoring"], url)

    u = url_base + "/customeraccountmanagement/customer"
    rw.set_authorization_url(providers["Customer"], u)
    rw.set_static_auth_provider_attributes(providers["Customer"], url)

    u = url_base + "/ecmdocument/document"
    rw.set_authorization_url(providers["ECMIntegration"], u)
    rw.set_static_auth_provider_attributes(providers["ECMIntegration"], url)

    u = url_base + "/BPNAccountManagement/getCustomer"
    rw.set_authorization_url(providers["GetBPNIntegration"], u)
    rw.set_static_auth_provider_attributes(providers["GetBPNIntegration"], url)

    u = url_base + "/manualavailabilitycheck/availabilitycheck"
    rw.set_authorization_url(providers["ManualAvailabilityB2O"], u)
    rw.set_static_auth_provider_attributes(providers["ManualAvailabilityB2O"], url)

    u = url_base + "/service/billing"
    rw.set_authorization_url(providers["OMBillingCallout"], u)
    rw.set_static_auth_provider_attributes(providers["OMBillingCallout"], url)

    u = url_base + "/service/order"
    rw.set_authorization_url(providers["OMFulfilmentCallout"], u)
    rw.set_static_auth_provider_attributes(providers["OMFulfilmentCallout"], url)

    u = url_base + "/productorder"
    rw.set_authorization_url(providers["SendOrderToSAP"], u)
    rw.set_static_auth_provider_attributes(providers["SendOrderToSAP"], url)


if __name__ == '__main__':
    main(sys.argv[1].lower())