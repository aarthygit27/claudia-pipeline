*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Login.robot
Resource          ../../frontendsanity/resources/Variables.robot
#Library             test123.py


*** Test Cases ***

Delete All the Oppotunities in Account
    [Tags]       Lightning
    [Documentation]    Delete Opportunities in the Account
    Go To Salesforce and Login into Lightning       System Admin
    Go to Entity   Affecto Oy
    Delete all entities from Accounts Related tab       Opportunities

Delete all the contacts in Account
    [Tags]       Lightning
    [Documentation]    Delete Contacts in the Account
    Go To Salesforce and Login into Lightning       System Admin
    Search Salesforce    Aacon Oy
    Delete all entries from Search list     Contacts