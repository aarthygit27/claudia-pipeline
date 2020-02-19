*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ..${/}resources${/}sales_app_light_keywords.robot
Resource          ..${/}resources${/}common.robot
Resource          ..${/}resources${/}multibella_keywords.robot
#Library             test123.py


*** Test Cases ***

Automatic availability check B2B-Account
    [Tags]    BQA-10225    AUTOLIGHTNING        AvailabilityCheck
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Navigate to Availability check
    Validate Address details
    select product available for the address and create an opportunity
    Check the CPQ-cart contains the wanted products    Telia Yritysinternet

Automatic availability check B2O-Account
    [Tags]    BQA-10225    AUTOLIGHTNING        AvailabilityCheck
    Go To Salesforce and Login into Lightning    B2O User
    Go to Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer      ACTIVEACCOUNT
    Go to Entity    ${LIGHTNING_TEST_ACCOUNT}
    Navigate to Availability check
    Validate point to point address details
    Select B2O product available and connect existing opportunity
    Check the CPQ-cart contains the wanted products     MetroEthernet Kapasiteetti