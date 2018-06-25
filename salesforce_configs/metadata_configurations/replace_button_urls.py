# -*- coding: utf-8 -*-
import sys, os

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
sys.path.append(PROJECT_ROOT)


BUTTON_URLS = {"prod": "http://glock.stadi.sonera.fi:8081",
                "prod2": "http://control.stadi.sonera.fi",
                "int": "http://kovalainen.stadi.sonera.fi:8081",
                "preprod": "http://kovalainen.stadi.sonera.fi:8081",
                "devbase": "http://sutil.stadi.sonera.fi:8081"}

def main(env):

    if env not in BUTTON_URLS.keys():
        env = "devbase"

    text_to_replace = BUTTON_URLS[env]

    ########## REPLACE OPPORTUNITY BUTTON URL ENDPOINTS ###############
    oppo = "Opportunity.object"
    fileToUpdate = os.path.join(PROJECT_ROOT, "endpoints", "objects", oppo)

    with open(fileToUpdate,'r') as f:
        filedata = f.read()

    for key in BUTTON_URLS.keys():
        filedata = filedata.replace(BUTTON_URLS[key], text_to_replace)

    with open(fileToUpdate,'w') as f:
        f.write(filedata)

    #------------------------------------------------------------#


    ########## REPLACE ORDER BUTTON URL ENDPOINTS ###############
    order = "Order.object"
    fileToUpdate = os.path.join(PROJECT_ROOT, "endpoints", "objects", order)

    with open(fileToUpdate,'r') as f:
        filedata = f.read()

    for key in BUTTON_URLS.keys():
        filedata = filedata.replace(BUTTON_URLS[key], text_to_replace)

    with open(fileToUpdate,'w') as f:
        f.write(filedata)
    #------------------------------------------------------------#

if __name__ == '__main__':
    main(sys.argv[1].lower())