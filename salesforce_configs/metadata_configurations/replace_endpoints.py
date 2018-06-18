# -*- coding: utf-8 -*-
import xml.etree.ElementTree as ET
import sys, os

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
sys.path.append(PROJECT_ROOT)

def change_endpoint(path, rs_location, endpoint):
    parsed_file = ET.parse(path)
    root = parsed_file.getroot()
    a = find_url(root, element_type)
    a.text = endpoint
    print_change(rs_location, element_type, endpoint)
    parsed_file.write(path)

def find_url(tree, element_type):
    return tree.find("{http://soap.sforce.com/2006/04/metadata}" + element_type)

def print_change(rs_location, element_type, endpoint):
    print "\nChanged " + rs_location + " <" + element_type + ">" + endpoint + "</"+ element_type + ">"


def main(env):
    ET.register_namespace("", "http://soap.sforce.com/2006/04/metadata")
    element_type = "url"
    no_endpoint = "https://ENDPOINT.REMOVED"

    if env == "preprod":
        endpoint_for_contact_outbound_message_remotesite = "https://emily.extra.sonera.fi:62100"
        endpoint_for_gesb_ac_remotesite = "https://emily.extra.sonera.fi:62503"
        endpoint_for_gesb_av_remotesite = "https://emily.extra.sonera.fi:62502"
        contact_workflow = "https://emily.extra.sonera.fi:62100/SFOutboundContactService"
    elif env == "int":
        endpoint_for_contact_outbound_message_remotesite = "https://artan.extra.sonera.fi:61100"
        endpoint_for_gesb_ac_remotesite = "https://artan.extra.sonera.fi:61503"
        endpoint_for_gesb_av_remotesite = "https://artan.extra.sonera.fi:61502"
        contact_workflow = "https://artan.extra.sonera.fi:61100/SFOutboundContactService"
    else:   # All dev sandboxes
        endpoint_for_contact_outbound_message_remotesite = no_endpoint
        endpoint_for_gesb_ac_remotesite = no_endpoint
        endpoint_for_gesb_av_remotesite = no_endpoint
        contact_workflow = no_endpoint


    # Contact outbound message
    rs_location = "endpoint_for_contact_outbound_message.remoteSite"
    path = os.path.join(PROJECT_ROOT, "endpoints", "remoteSiteSettings", rs_location)
    change_endpoint(path, rs_location, endpoint_for_contact_outbound_message_remotesite)

    # GESB_AC
    rs_location = "GESB_AC.remoteSite"
    path = os.path.join(PROJECT_ROOT, "endpoints", "remoteSiteSettings", rs_location)
    change_endpoint(path, rs_location, endpoint_for_gesb_ac_remotesite)

    # GESB_AV
    rs_location = "GESB_AV.remoteSite"
    path = os.path.join(PROJECT_ROOT, "endpoints", "remoteSiteSettings", rs_location)
    change_endpoint(path, rs_location, endpoint_for_gesb_av_remotesite)

    # Contact Workflow
    rs_location = "Contact.workflow"
    element_type = "endpointUrl"
    path = os.path.join(PROJECT_ROOT, "endpoints", "workflows", rs_location)
    parsed_file = ET.parse(path)
    root = parsed_file.getroot()
    a = find_url(find_url(root, "outboundMessages"), element_type)
    a.text = contact_workflow
    print_change(rs_location, element_type, contact_workflow)
    parsed_file.write(path)



if __name__ == '__main__':
    main(sys.argv[1].lower())