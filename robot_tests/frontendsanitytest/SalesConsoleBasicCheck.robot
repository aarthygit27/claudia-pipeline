*** Settings ***

Documentation     Suite description
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ..${/}resources${/}sales_cons_light_keywords.robot
Resource          ..${/}resources${/}sales_cons_light_variables.robot

*** Test Cases ***
Console: Create opportunity from Account
    [Tags]    BQA-8272     AUTOLIGHTNING      ContactsManagement
    [Documentation]    Create new opportunity and validate in accounts related tab search in salesforce
    ...    and then in My all open Opportunities section.
    Go To Salesforce and Login into Lightning
    Go To Account    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer
    Verify That Opportunity Is Found With Search And Go To Opportunity
    #Verify That Opportunity is Found From My All Open Opportunities

Console: Add new contact - Master
    [Tags]    BQA-8262    AUTOLIGHTNING     ContactsManagement
    [Documentation]    Go to SalesForce Lightning. Create new master contact and validate the details
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New Master Contact and Validate

Console: Add new contact - Non Person
    [Tags]    BQA-8263    AUTOLIGHTNING      ContactsManagement
    [Documentation]    Go to SalesForce Lightning. Create new non master contact and validate the details.
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New NP Contact and Validate

Console: Add new contact from accounts page
    [Tags]    BQA-8265    AUTOLIGHTNING      ContactsManagement
    [Documentation]    Go to SalesForce Lightning. Create new contact for account and validate the details.
    Go To Salesforce and Login into Lightning
    Go To Account    ${AP_CONTACT_ACCOUNTNAME}
    Create New Contact for Account and Validate