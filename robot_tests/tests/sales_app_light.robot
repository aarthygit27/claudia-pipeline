*** Settings ***
Documentation       Suite description
Resource            ../resources/sales_app_light_keywords.robot

Test Setup          Open Browser And Go To Login Page
Test Teardown       Logout From All Systems and Close Browser

*** Test Cases ***

Lightning: Add new contact - Master
    [Tags]  BQA-8396
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New Master Contact
    Validate Master Contact Details

Lightning: Add new contact - Non person
    [Tags]  BQA-8395
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New NP Contact
    Validate NP Contact Details

Lightning: Add new contact from Accounts Page
    [Tags]  BQA-8394
    Go To Salesforce and Login into Lightning
    Go to Entity  ${AP_ACCOUNT_NAME}
    Create New Contact for Account
    Validate AP Contact Details

Lightning: Create opportunity from Account
    [Tags]
    Go To Salesforce and Login into Lightning
    Go To Entity   ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer     ACTIVEACCOUNT
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Verify That Opportunity is Found From My All Open Opportunities

Negative - Validate Opportunity cannot be created for Passive account
    [Tags]
    Go To Salesforce and Login into Lightning
    Go To Entity   ${PASSIVE_TEST_ACCOUNT}
    Create New Opportunity For Customer         PASSIVEACCOUNT

Negative - Validate Opportunity cannot be created for Group account
    [Tags]
    Go To Salesforce and Login into Lightning
    Go To Entity   ${GROUP_TEST_ACCOUNT}
    Validate Opportunity cannot be created     GROUPACCOUNT


*** comment  ***
Closing active opportunity as cancelled
    [Tags]  BQA-8465
    Go To Salesforce and Login into Lightning
    Go To Entity   ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer     ACTIVEACCOUNT
    Cancel Opportunity and Validate   ${OPPORTUNITY_NAME}   Cancelled
    #Validate Closed Opportunity Details  ${OPPORTUNITY_NAME}
Closing active opportunity as lost
    [Tags]  BQA-8466
    Go To Salesforce and Login into Lightning
    #Go To Entity   ${LIGHTNING_TEST_ACCOUNT}
    #Create New Opportunity For Customer     ACTIVEACCOUNT
    #Cancel Opportunity and Validate   ${OPPORTUNITY_NAME}   Closed Lost
    #Validate Closed Opportunity Details  TestOpportunity 20181214-122845  Closed Lost
    Validate Closed Opportunity Details  TestOpportunity 20181214-142344  Closed Lost
    #Verify That Opportunity is Not Found under My All Open Opportunities
