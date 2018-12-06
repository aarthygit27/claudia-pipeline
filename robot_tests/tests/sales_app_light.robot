*** Settings ***
Documentation       Suite description
Resource            ../resources/sales_app_light_keywords.robot


Test Setup          Open Browser And Go To Login Page
Test Teardown       Logout From All Systems and Close Browser

*** Test Cases ***

Lightning: Create opportunity from Account
    [Tags]
    Go To Salesforce and Login into Lightning
    Go To Account   ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Verify That Opportunity is Found From My All Open Opportunities


Lightning: Add new contact - Master
    [Tags]
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New Master Contact and Validate