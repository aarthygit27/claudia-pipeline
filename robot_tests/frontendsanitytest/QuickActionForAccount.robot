*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
#Library             test123.py


*** Test Cases ***

Lightning: Create Meeting from Account
    [Documentation]    To create meeting for a account
    [Tags]    BQA-7948    AUTOLIGHTNING     QuickActionsForAccount
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go To Entity    ${TEST_CONTACT}
    sleep    20s
    Check original account owner and change if necessary for event
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${TEST_CONTACT}
    Create New Contact for Account
    Go to Entity   ${TEST_CONTACT}
    Create a Meeting

Lightning: Create Call from Account
    [Documentation]    To create call for a account
    [Tags]    BQA-8085    AUTOLIGHTNING     QuickActionsForAccount
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${TEST_CONTACT}
    Create New Contact for Account
    Go to Entity    ${TEST_CONTACT}
    Create a Call


Lightning: Create Task from Account
    [Documentation]    To create task for a account
    [Tags]    BQA-8463    AUTOLIGHTNING     QuickActionsForAccount
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${TEST_CONTACT}
    Create New Contact for Account
    Go To Entity    ${TEST_CONTACT}
    Create a Task


