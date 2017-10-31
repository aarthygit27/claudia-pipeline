import os, sys

PROJECT_ROOT = os.path.dirname(os.path.realpath(__file__))
CONFIG_PATH = os.path.realpath(os.path.join(PROJECT_ROOT, "..", "..", "config"))
sys.path.append(PROJECT_ROOT)
sys.path.append(CONFIG_PATH)


import config_parser
from config_parser import ConfigSectionMap

env = sys.argv[1].lower()

conf = ConfigSectionMap(env)

build_properties = os.path.join(PROJECT_ROOT, "build.properties")
print build_properties

with open(build_properties, 'w') as f:
    f.write("sf.username = {0}\n".format(conf["username"]))
    f.write("sf.password = {0}{1}\n".format(conf["password"], conf["token"]))
    f.write("sf.serverurl = https://test.salesforce.com\n")
    f.write("sf.maxPoll = 20000\n")