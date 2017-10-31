# -*- coding: utf-8 -*-
import sys, os

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
sys.path.append(PROJECT_ROOT)


########## REPLACE OPPORTUNITY BUTTON URL ENDPOINTS ###############
oppo = "Opportunity.object"
fileToUpdate = os.path.join(PROJECT_ROOT, "endpoints", "objects", oppo)
textToSearch = "http://glock.stadi.sonera.fi"
textToReplace = "http://emily.stadi.sonera.fi"


f = open(fileToUpdate,'r')
filedata = f.read()
f.close()

newdata = filedata.replace(textToSearch, textToReplace)

f = open(fileToUpdate,'w')
f.write(newdata)
f.close()
#------------------------------------------------------------#


########## REPLACE ORDER BUTTON URL ENDPOINTS ###############
order = "Order.object"
fileToUpdate = os.path.join(PROJECT_ROOT, "endpoints", "objects", order)
textToSearch = "http://glock.stadi.sonera.fi"
textToReplace = "http://emily.stadi.sonera.fi"


f = open(fileToUpdate,'r')
filedata = f.read()
f.close()

newdata = filedata.replace(textToSearch, textToReplace)

f = open(fileToUpdate,'w')
f.write(newdata)
f.close()
#------------------------------------------------------------#