# Structure
```
├───config
├───robot_tests
│   ├───libs
│   ├───resources
│   └───tests
└───salesforce_configs
    ├───metadata_configurations
    │   └───endpoints
    │       ├───remoteSiteSettings
    │       └───workflows
    └───user_management
        └───libs
```

## config
Config files for Salesforce sandboxes and `config_parser.py` for automatically parsing the config files.

## robot_tests
Robot Framework tests. Folder available in following branches:
- Preprod
- Int

## salesforce_configs
Different configuration files required to run after Salesforce sandbox refreshes.

## jira_to_influx.py
Send JIRA data to InfluxDB.