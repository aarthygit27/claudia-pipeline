*** Settings ***
Documentation       Suite description
Resource            ../resources/sales_app_light_keywords.robot
Resource            ../resources/common.robot
Test Setup          Open Browser And Go To Login Page
Test Teardown       Logout From All Systems and Close Browser

*** Test Cases ***

Add new contact - Master
    [Tags]  BQA-8396    Lightning
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New Master Contact
    Validate Master Contact Details

Add new contact - Non person
    [Tags]  BQA-8395    Lightning
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New NP Contact
    Validate NP Contact Details

Add new contact from Accounts Page
    [Tags]  BQA-8394       Lightning
    Go To Salesforce and Login into Lightning
    Go to Entity  ${AP_ACCOUNT_NAME}
    Create New Contact for Account
    Validate AP Contact Details

Create opportunity from Account
    [Tags]  BQA-8393        Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity   ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer     ACTIVEACCOUNT
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Verify That Opportunity is Found From My All Open Opportunities

Negative - Validate Opportunity cannot be created for Passive account
    [Tags]  BQA-8457        Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity   ${PASSIVE_TEST_ACCOUNT}
    Create New Opportunity For Customer         PASSIVEACCOUNT

Negative - Validate Opportunity cannot be created for Group account
    [Tags]  BQA-8464        Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity   ${GROUP_TEST_ACCOUNT}
    Validate Opportunity cannot be created     GROUPACCOUNT

Closing active opportunity as cancelled
    [Tags]  BQA-8465        Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity   ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer     ACTIVEACCOUNT
    Cancel Opportunity and Validate   ${OPPORTUNITY_NAME}   Cancelled

Closing active opportunity as lost
    [Tags]  BQA-8466        Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity   ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer     ACTIVEACCOUNT
    Cancel Opportunity and Validate   ${OPPORTUNITY_NAME}   Closed Lost

Check Attributes/Business Account are named right in Sales Force UI
    [Tags]    BQA-8484    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    Verify That Business Account Attributes Are Named Right

Check Attributes/Contact Person are named right
    [Tags]      BQA-8483  Lightning
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New Master Contact With All Details
    Validate Master Contact Details In Contact Page    ${CONTACT_DETAILS}
    Validate That Contact Person Attributes Are Named Right

Lightning: Create Meeting from Account
    [Tags]   BQA-7948       Lightning1
    Go To Salesforce and Login into Lightning
    Go To Entity        ${TEST_ACCOUNT_CONTACT}
    Create a Meeting

Lightning: Create Call from Account
    [Tags]   BQA-8085       Lightning1
    Go To Salesforce and Login into Lightning
    Go To Entity        ${TEST_ACCOUNT_CONTACT}
    Create a Call

Lightning: Create Task from Account
    [Tags]   BQA-8463       Lightning1
    Go To Salesforce and Login into Lightning
    Go To Entity        ${TEST_ACCOUNT_CONTACT}
    Create a Task




#Create opportunity from Account for HDCFlow
 #   [Tags]  BQA-HDCOppo        Lightning
  #  Go To Salesforce and Login into Lightning
  #  Go To Entity   ${LIGHTNING_TEST_ACCOUNT}
   # Create New Opportunity For Customer     ACTIVEACCOUNT
    #Verify That Opportunity Is Found With Search And Go To Opportunity
    #Verify That Opportunity is Found From My All Open Opportunities



