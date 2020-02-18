*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
#Library             test123.py


*** Test Cases ***

Add new contact - Master
    [Documentation]    Go to SalesForce Lightning. Create new master contact and validate the details
    [Tags]    BQA-8396  AUTOLIGHTNING   ContactsManagement
    Go To Salesforce and Login into Lightning
    Create New Master Contact
    Validate Master Contact Details

Add new contact - Non person
    [Documentation]    Go to SalesForce Lightning. Create new non master contact and validate the details.
    [Tags]    BQA-8395  AUTOLIGHTNING   ContactsManagement
    Go To Salesforce and Login into Lightning
    Create New NP Contact
    Validate NP Contact

Add new contact from Accounts Page
    [Documentation]    Go to SalesForce Lightning. Create new contact for account and validate the details.
    [Tags]    BQA-8394  AUTOLIGHTNING   ContactsManagement
    Go To Salesforce and Login into Lightning
    Go to Entity    ${AP_ACCOUNT_NAME}
    Create New Contact for Account
    Validate AP Contact Details

Check Attributes/Contact Person are named right
    [Documentation]    To Verify the Contact Person Attributes and values Are Named Right after adding the contact
    [Tags]    BQA-8483    AUTOLIGHTNING     ContactsManagement
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New Master Contact With All Details
    Validate Master Contact Details In Contact Page    ${CONTACT_DETAILS}
    Validate That Contact Person Attributes Are Named Right

Negative: Check external data is not editable when creating new contact
    [Tags]      BQA-10945    AUTOLIGHTNING      ContactsManagement
    [Documentation]     Log in as B2B-sales user and try to create new contact. External data fields in the form shouldn't be editable.
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Navigate to create new contact
    Validate external contact data can not be modified
    Close contact form

Negative: Check external data is not editable with existing contact
    [Tags]       BQA-10946     AUTOLIGHTNING        ContactsManagement
    [Documentation]     Search contact with external data. Click edit and chect that external data fields are read-only.
    Login to Salesforce as System Admin
    Create new contact with external data
    Go To Salesforce and Login into Lightning
    Go to Entity    ${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}
    Open edit contact form
    Validate external contact data can not be modified
    Close contact form

Negative: Check external data is not editable from account contact relationship view
    [Tags]      BQA-10947     AUTOLIGHTNING     ContactsManagement
    [Documentation]     Search contact with external data. Go to related tab and click view relationship from related accounts. Check external data is not editable.
    Login to Salesforce as System Admin
    Create new contact with external data
    Go To Salesforce and Login into Lightning
    Go to Entity    ${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}
    Navigate to related tab
    Click view contact relationship
    Validate external contact data can not be modified