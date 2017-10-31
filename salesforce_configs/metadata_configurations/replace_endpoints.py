# -*- coding: utf-8 -*-
import xml.etree.ElementTree as ET
import sys, os

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
sys.path.append(PROJECT_ROOT)

ET.register_namespace("", "http://soap.sforce.com/2006/04/metadata")

rs_location = "endpoint_for_contact_outbound_message.remoteSite"
endpoint_for_contact_outbound_message_remotesite = "https://emily.extra.sonera.fi:62100"

path = os.path.join(PROJECT_ROOT, "endpoints", "remoteSiteSettings", rs_location)
parsed_file = ET.parse(path)
root = parsed_file.getroot()
a = root.find("{http://soap.sforce.com/2006/04/metadata}" + "url")
a.text = endpoint_for_contact_outbound_message_remotesite
print "\nChanged " + rs_location + " <url>" + endpoint_for_contact_outbound_message_remotesite + "</url>"
parsed_file.write(path)


rs_location = "GESB_AC.remoteSite"
endpoint_for_gesb_ac_remotesite = "https://emily.extra.sonera.fi:62503"
element_type = "url"

path = os.path.join(PROJECT_ROOT, "endpoints", "remoteSiteSettings", rs_location)
parsed_file = ET.parse(path)
root = parsed_file.getroot()
a = root.find("{http://soap.sforce.com/2006/04/metadata}" + element_type)
a.text = endpoint_for_gesb_ac_remotesite
print "\nChanged " + rs_location + " <" + element_type + ">" + endpoint_for_gesb_ac_remotesite + "</"+ element_type + ">"
parsed_file.write(path)


rs_location = "GESB_AV.remoteSite"
endpoint_for_gesb_av_remotesite = "https://emily.extra.sonera.fi:62502"
element_type = "url"

path = os.path.join(PROJECT_ROOT, "endpoints", "remoteSiteSettings", rs_location)
parsed_file = ET.parse(path)
root = parsed_file.getroot()
a = root.find("{http://soap.sforce.com/2006/04/metadata}" + element_type)
a.text = endpoint_for_gesb_av_remotesite
print "\nChanged " + rs_location + " <" + element_type + ">" + endpoint_for_gesb_av_remotesite + "</"+ element_type + ">"
parsed_file.write(path)


rs_location = "Contact.workflow"
contact_workflow = "https://emily.extra.sonera.fi:62100/SFOutboundContactService"
element_type = "endpointUrl"

path = os.path.join(PROJECT_ROOT, "endpoints", "workflows", rs_location)
parsed_file = ET.parse(path)
root = parsed_file.getroot()
a = root.find("{http://soap.sforce.com/2006/04/metadata}outboundMessages").find('{http://soap.sforce.com/2006/04/metadata}endpointUrl')
a.text = contact_workflow
print "\nChanged " + rs_location + " <" + element_type + ">" + contact_workflow + "</"+ element_type + ">"
parsed_file.write(path)