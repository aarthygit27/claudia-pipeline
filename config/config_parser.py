import ConfigParser
import os

def setup(env="salesforce"):
    global CONF
    script_dir = os.path.dirname(__file__)

    conf_file_path = os.path.join(script_dir, env)

    CONF = ConfigParser.ConfigParser()
    CONF.read(conf_file_path)

setup()

def ConfigSectionMap(section):
    dict1 = {}
    options = CONF.options(section)
    for opt in options:
        try:
            dict1[opt] = CONF.get(section, opt)
        except:
            dict1[opt] = None
    return dict1