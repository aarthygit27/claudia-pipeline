*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
#Library             test123.py


*** Test Cases ***

Delete All the Oppotunities in Account
    [Tags]       Lightning
    [Documentation]    Delete Opportunities in the Account
    Go To Salesforce and Login into Admin User
    Go to Entity   Affecto Oy
    Delete all entities from Accounts Related tab       Opportunities

Delete all the contacts in Account
    [Tags]       Lightning
    [Documentation]    Delete Contacts in the Account
    Login to Salesforce as System Admin
    Search Salesforce    Aacon Oy
    Delete all entries from Search list     Contacts