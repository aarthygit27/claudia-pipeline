*** Settings ***
Documentation       Suite description
Resource            ../resources/sales_app_light_keywords.robot


Test Setup          Open Browser And Go To Login Page
#Test Teardown       Logout From All Systems and Close Browser

*** Test Cases ***

Lightning: Create opportunity from Account
    [Tags]
    Go To Salesforce and Login into Lightning
    Go To Entity   ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Verify That Opportunity is Found From My All Open Opportunities

Lightning: Add new contact - Master
    [Tags]  BQA-8396
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New Master Contact
    Validate Master Contact Details     ${CONTACT_DETAILS}

Lightning: Add new contact - Non person
    [Tags]  BQA-8395
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New NP Contact
    Validate NP Contact Details         ${CONTACT_DETAILS}

Lightning: Add new contact from Accounts Page
    [Tags]  BQA-8394
    Go To Salesforce and Login into Lightning
    Go to Entity  ${AP_ACCOUNT_NAME}
    Create New Contact for Account
    Validate AP Contact Details         ${CONTACT_DETAILS}






