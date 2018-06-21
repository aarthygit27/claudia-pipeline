# -*- coding: utf-8 -*-
import xml.etree.ElementTree as ET
import sys, os

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
CONFIG_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "..", "config"))
sys.path.append(PROJECT_ROOT)
sys.path.append(CONFIG_PATH)

import config_parser
from config_parser import ConfigSectionMap
config_parser.setup("endpoints")

endpoints = None    # initialise empty variable

def change_endpoint(path, rs_location, element_type, endpoint):
    parsed_file = ET.parse(path)
    root = parsed_file.getroot()
    a = find_url(root, element_type)
    a.text = endpoint
    print_change(rs_location, element_type, endpoint)
    parsed_file.write(path)

def find_url(tree, element_type):
    return tree.find("{http://soap.sforce.com/2006/04/metadata}" + element_type)

def print_change(rs_location, element_type, endpoint):
    print "Changed " + rs_location + " <" + element_type + ">" + endpoint + "</"+ element_type + ">"


def main(env):
    if env in ["preprod", "int"]:
        endpoints = ConfigSectionMap(env)
    else:
        endpoints = ConfigSectionMap("dev")

    ET.register_namespace("", "http://soap.sforce.com/2006/04/metadata")
    element_type = "url"

    ################################
    ##### REMOTE SITE SETTINGS #####
    ################################

    print "Remote site settings"

    # Contact outbound message
    rs_location = "endpoint_for_contact_outbound_message.remoteSite"
    path = os.path.join(PROJECT_ROOT, "endpoints", "remoteSiteSettings", rs_location)
    change_endpoint(path, rs_location, element_type, endpoints["contact_outbound_message_remotesite"])

    # GESB_AC
    rs_location = "GESB_AC.remoteSite"
    path = os.path.join(PROJECT_ROOT, "endpoints", "remoteSiteSettings", rs_location)
    change_endpoint(path, rs_location, element_type, endpoints["gesb_ac_remotesite"])

    # GESB_AV
    rs_location = "GESB_AV.remoteSite"
    path = os.path.join(PROJECT_ROOT, "endpoints", "remoteSiteSettings", rs_location)
    change_endpoint(path, rs_location, element_type, endpoints["gesb_av_remotesite"])

    #############################
    ##### OUTBOUND MESSAGES #####
    #############################

    print ""
    print "Outbound Messages"

    # Contact Workflow
    # The endpoint is under "outboundMessages" so cannot call `change_endpoint` directly
    rs_location = "Contact.workflow"
    element_type = "endpointUrl"
    path = os.path.join(PROJECT_ROOT, "endpoints", "workflows", rs_location)
    parsed_file = ET.parse(path)
    root = parsed_file.getroot()
    a = find_url(find_url(root, "outboundMessages"), element_type)
    a.text = endpoints["contact_workflow"]
    print_change(rs_location, element_type, endpoints["contact_workflow"])
    parsed_file.write(path)

    element_type = "active"
    a = find_url(find_url(root, "rules"), element_type)
    a.text = str(env in ["preprod", "int"]).lower() # true/false instead of True/False
    print_change(rs_location, element_type, str(env in ["preprod", "int"]).lower())
    parsed_file.write(path)


    #############################
    ##### NAMED CREDENTIALS #####
    #############################

    print ""
    print "Named Credentials"

    # AddressValidation
    rs_location = "AddressValidation.namedCredential"
    element_type = "endpoint"
    path = os.path.join(PROJECT_ROOT, "endpoints", "namedCredentials", rs_location)
    change_endpoint(path, rs_location, element_type, endpoints["addressvalidation_named_credential"])
    change_endpoint(path, rs_location, "username", "salesforce")

    # AvailabilityCheck
    rs_location = "AvailabilityCheck.namedCredential"
    path = os.path.join(PROJECT_ROOT, "endpoints", "namedCredentials", rs_location)
    change_endpoint(path, rs_location, element_type, endpoints["availabilitycheck_named_credential"])
    change_endpoint(path, rs_location, "username", "salesforce")

    # Casemanagement
    rs_location = "CaseManagement.namedCredential"
    path = os.path.join(PROJECT_ROOT, "endpoints", "namedCredentials", rs_location)
    change_endpoint(path, rs_location, element_type, endpoints["casemanagement_named_credential"])
    change_endpoint(path, rs_location, "username", "b2bselfcare")

    ##########################
    #### AUTH. PROVIDERS #####
    ##########################

    print ""
    print "Auth. Providers"

    auth_providers = ["Avail_CheckB2O", "Billing_Account", "Billing_Account_Service", 
                        "CreateBPNIntegration", "CreateUserToULM", "Credit_Scoring", "Customer",
                        "ECMIntegration", "GetBPNIntegration", "Manual_Availability_B2O",
                        "OMBillingCallout", "OMFulfilmentCallout", "SendOrderToSAP"]

    element_type = "authorizeUrl"
    for ap in auth_providers:
        rs_location = ap + ".authprovider"
        x = ap.replace("_", "").lower() + "_auth_provider"
        path = os.path.join(PROJECT_ROOT, "endpoints", "authproviders", rs_location)
        change_endpoint(path, rs_location, element_type, endpoints[x])

        parsed_file = ET.parse(path)
        root = parsed_file.getroot()
        a = find_url(root, "consumerSecret")
        try:
            root.remove(a)
            parsed_file.write(path)
        except ValueError:
            pass




if __name__ == '__main__':
    main(sys.argv[1].lower())