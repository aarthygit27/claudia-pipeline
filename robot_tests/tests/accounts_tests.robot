*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot

Suite Setup         Open Browser And Go To Login Page
Suite Teardown      Close Browser

Test Setup          Setup For Account Tests
Test Teardown       Close Tabs And Logout

*** Test Cases ***
# Create a New Account
#     [Tags]      account
#     Open Accounts
#     Create New Account
#     Select Account Type         Billing
#     Type Account Name           Some Billing Account
#     Save New Account
#     Account Should Be Open      Some Billing Account
