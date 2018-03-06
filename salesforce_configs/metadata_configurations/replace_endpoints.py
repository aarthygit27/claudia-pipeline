# -*- coding: utf-8 -*-
import xml.etree.ElementTree as ET
import sys, os

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
sys.path.append(PROJECT_ROOT)

ET.register_namespace("", "http://soap.sforce.com/2006/04/metadata")
element_type = "url"

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


rs_location = "endpoint_for_contact_outbound_message.remoteSite"
endpoint_for_contact_outbound_message_remotesite = "https://emily.extra.sonera.fi:62100"
path = os.path.join(PROJECT_ROOT, "endpoints", "remoteSiteSettings", rs_location)
change_endpoint(path, rs_location, endpoint_for_contact_outbound_message_remotesite)


rs_location = "GESB_AC.remoteSite"
endpoint_for_gesb_ac_remotesite = "https://emily.extra.sonera.fi:62503"
path = os.path.join(PROJECT_ROOT, "endpoints", "remoteSiteSettings", rs_location)
change_endpoint(path, rs_location, endpoint_for_gesb_ac_remotesite)


rs_location = "GESB_AV.remoteSite"
endpoint_for_gesb_av_remotesite = "https://emily.extra.sonera.fi:62502"
path = os.path.join(PROJECT_ROOT, "endpoints", "remoteSiteSettings", rs_location)
change_endpoint(path, rs_location, endpoint_for_gesb_av_remotesite)

rs_location = "Contact.workflow"
contact_workflow = "https://emily.extra.sonera.fi:62100/SFOutboundContactService"
element_type = "endpointUrl"
path = os.path.join(PROJECT_ROOT, "endpoints", "workflows", rs_location)

parsed_file = ET.parse(path)
root = parsed_file.getroot()
a = find_url(find_url(root, "outboundMessages"), element_type)
a.text = contact_workflow
print_change(rs_location, element_type, contact_workflow)
parsed_file.write(path)