import ConfigParser
import os

script_dir = os.path.dirname(__file__)

relative_path = "../config/salesforce"
conf_file_path = os.path.join(script_dir, relative_path)

CONF = ConfigParser.ConfigParser()
CONF.read(conf_file_path)

def ConfigSectionMap(section):
    dict1 = {}
    options = CONF.options(section)
    for opt in options:
        try:
            dict1[opt] = CONF.get(section, opt)
        except:
            dict1[opt] = None
    return dict1