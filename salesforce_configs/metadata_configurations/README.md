# Replace Endpoints

1. create a build file
`python create_build_properties.py <environment>`
2. Run the `retrieveEndpoints` target to get the current endpoints from Salesforce to local machine
`ant -verbose retrieveEndpoints`
3. Replace endpoints of the local metadata files
`python replace_endpoints.py <environment>`
4. Replace buttons of the local metadata files
`python replace_button_urls.py`
5. Deploy the changed endpoints to Salesforce
`ant deployEndpoints`

# Change auth. providers

1. Run `python change_auth_providers.py <environment>`

Script changes authorization url, token url, and consumer key. However, consumer key needs to be changed still manually (situation 5.3.2018).

2. Change consumer key + consumer secret (https://deveo.verso.sonera.fi/TS/projects/b2x-digisales/wiki/Integrations)

# Named credentials

Named credentials **cannot** be changed with REST API, so Robot Framework implementation required. `config_parser` and `robot_tests` must be appended to
pythonpath before running.

1. Run `robot -P ../../robot_tests -P ../../config named_credentials.robot`
2. Check the final screenshot to see if the named credentials are set correctly.