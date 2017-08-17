*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}multibella_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}uad_keywords.robot

Library             config_parser

Suite Setup         Open Browser And Go To Login Page
Suite Teardown      Close All Browsers

#Test Setup          Login to Salesforce
Test Teardown       Close Tabs And Logout
Force Tags          sales

*** Variables ***
${TEST_ACCOUNT}                             Gavetec Oy
${OPPO_TEST_ACCOUNT}                        Gavetec Oy
${MUBE_CUSTOMER_ID}                         2140131-3   # Putki Pasi
${TEST_ACCOUNT_CUSTOMER_ID}                 0750491-4   # Gavetec Oy
${CONTACT_PERSON_CRM_ID_FOR_UPDATE_TEST}    ${EMPTY}    # 1916290
${CONTACT_PERSON_NAME}                      ${EMPTY}    # Test Contact Person 77590434
${PRODUCT}                                  ${EMPTY}    # required for creating Opportunities
${TEST_PASSIVE_ACCOUNT}                     T. E. Roos Oy

*** Test Cases ***

Contact: Add new contact (valid data)
    [Tags]    add_new_contact    BQA-1
    [Setup]    Login to Salesforce And Close All Tabs
    Go to Account    ${TEST_ACCOUNT}
    Open Details and choose New Contact from More tab
    Enter mandatory information and save new contact
    Check that contact has been saved and can be found under proper Account
    [Teardown]    Logout From Salesforce

Contact: Add new contact (invalid data)
    [Tags]    add_new_contact_invalid    BQA-1
    [Setup]    Login to Salesforce And Close All Tabs
    Go to Account    ${TEST_ACCOUNT}
    Open Details and choose New Contact from More tab
    Enter mandatory (invalid) information and verify cp was not saved
    [Teardown]    Logout From Salesforce

Create Contact Person In MultiBella And Verify It Appears In MIT And Salesforce
    [Tags]      add_new_contact     BQA-53      BQA-1835    smoke
    [Documentation]     Entry Conditions: MultiBella userIntegrations are open
    MUBE Open Browser And Login As CM User
    MUBE Create New Contact Person For Business Customer    ${MUBE_CUSTOMER_ID}
    MUBE Logout CRM
    UAD Go to Main Page
    Contact Person Should Be Found In MIT UAD
    Close Browser
    Open Browser And Go To Login Page
    Login to Salesforce And Close All Tabs
    Wait Until Account Is In Salesforce And Go To Account
    Click Contact Person Details
    Verify That Contact Person Information Is Correct
    Set Suite Variable    ${CONTACT_PERSON_CRM_ID_FOR_UPDATE_TEST}    ${CONTACT_PERSON_CRM_ID}
    Set Suite Variable    ${CONTACT_PERSON_NAME}    Test ${TEST_CONTACT_PERSON_LAST_NAME}
    [Teardown]    Logout From All Systems

Sales Admin: Change Account owner
    [Tags]      BQA-8
    [Setup]     Login to Salesforce and Close All Tabs      Sales Admin User
    [Documentation]     Change the owner of ${TEST_ACCOUNT} to Sales admin. Then revert the changes.
    Go To Account   ${TEST_ACCOUNT}
    Change Account Owner    Sales Admin
    Verify that Owner Has Changed   Sales Admin
    [Teardown]  Run Keywords    Revert Account Owner Back To GESB Integration   AND
    ...                         Logout From Salesforce

Update Contact Person in SalesForce
    [Tags]      BQA-117    wip
    [Setup]    Login to Salesforce and Close All Tabs      Sales Admin User
    Check If Contact Person Exists And Create New One If Not    ${CONTACT_PERSON_CRM_ID_FOR_UPDATE_TEST}
    Go to Account    ${CONTACT_PERSON_NAME}
    Click Contact Person Details
    Verify That Contact Person Information is Correct
    Update Contact Person Email And Phone
    MUBE Open Browser And Login As CM User
    MUBE Verify That Contact Person Email And Phone Are Updated
    [Teardown]    Logout From All Systems

Sales Process: Create opportunity from Account
    [Tags]      BQA-27
    [Setup]     Login to Salesforce and Close All Tabs
    Go To Account   ${TEST_ACCOUNT}
    Create New Opportunity For Customer
    Verify That Opportunity Creation Succeeded
    Verify That Opportunity Is Found In Todays Page
    Verify That Opportunity Is Found With Search
    Verify That Opportunity Is Found From My Opportunities

Opportunity: Closing active opportunity as cancelled
    [Tags]      BQA-42
    [Documentation]     Entry conditions: Sales user is logged in to Salesforce
    [Setup]     Login to Salesforce and Close All Tabs
    [Template]      Close active opportunity
    Cancelled    Cancelled
    [Teardown]  Close Tabs And Logout

Opportunity: Closing active opportunity as lost
    [Tags]      BQA-43
    [Documentation]     Entry conditions: Sales user is logged in to Salesforce
    [Setup]     Login to Salesforce and Close All Tabs
    [Template]      Close active opportunity
    Closed Lost    Lost
    [Teardown]  Close Tabs And Logout

Opportunity: Closing active opportunity as not won
    [Tags]      BQA-44
    [Documentation]     Entry conditions: Sales user is logged in to Salesforce
    [Setup]     Login to Salesforce and Close All Tabs
    [Template]      Close active opportunity
    Closed Not Won    Not Won
    [Teardown]  Close Tabs And Logout

Opportunity: Closing active opportunity as won
    [Tags]      BQA-45
    [Documentation]     Entry conditions: Sales user is logged in to Salesforce
    [Setup]     Login to Salesforce and Close All Tabs
    [Template]      Close active opportunity
    Closed Won    Won    Negotiate and Close
    [Teardown]  Close Tabs And Logout

Sales Admin: Change Account owner for Group Account
    [Tags]      BQA-5    wip
    [Setup]     Create Test Account With Admin User     Group
    Login to Salesforce and Close All Tabs      Sales Admin User
    Go to Account   ${TEST_GROUP_ACCOUNT_NAME}
    Change Account Owner    Sales Admin
    Verify that Owner Has Changed   Sales Admin
    Go to Account   ${TEST_ACCOUNT_NAME}
    [Teardown]  Close Tabs And Logout

Sales Admin: Remove Account owner
    [Tags]      BQA-7   wip
    [Setup]     Create Test Account With Admin User     Billing
    Login to Salesforce and Close All Tabs      Sales Admin User
    Go to Account   ${TEST_ACCOUNT_NAME}
    # TODO
    [Teardown]  Close Tabs And Logout

Add New Contact In Salesforce And Verify It Appears In MUBE And MIT
    [Tags]    BQA-1840      smoke
    [Setup]    Go To Salesforce and Login
    [Documentation]     The beginning of the test is the same as Contact: Add new contact (valid data) test case (BQA-1)
    Go to Account    ${TEST_ACCOUNT}
    Open Details and choose New Contact from More tab
    Enter mandatory information and save new contact
    Check that contact has been saved and can be found under proper Account
    MUBE Open Browser And Login As CM User
    MUBE Open Customers Page
    MUBE Search and Select Customer With Name    ${TEST_ACCOUNT}
    Wait Until Contact Person Is Found In MultiBella
    UAD Go to Main Page
    Contact Person Should Be Found In MIT UAD   ${TEST_ACCOUNT_CUSTOMER_ID}
    [Teardown]    Logout From All Systems

Sales Process: Create/update Sales Plan
    [Tags]      BQA-24      wip
    [Setup]     Go to Salesforce and Login
    Go to Account    ${TEST_ACCOUNT}
    Open Sales Plan Tab At Account View
    Create New Sales Plan
    Update Description, Customer Business Goals, and Customer Business Challenges fields and press Save
    Add Solution Area and update Solution Sub Area data
    Go to other view and then back to Sales Plan
    Verify that updated values are visible in Sales Plan
    [Teardown]  Close Tabs And Logout

Contact: Update contact
    [Tags]      BQA-23
    [Setup]     Login to Salesforce and Close All Tabs
    Check If Contact Person Exists And Create New One If Not    ${CONTACT_PERSON_CRM_ID_FOR_UPDATE_TEST}
    Go to Account    ${CONTACT_PERSON_NAME}
    Click Contact Person Details
    Verify That Contact Person Information is Correct
    Click Edit Contact Person
    Update Contact Person Sales Role        Business Contact
    Verify That Sales Role Is Updated       Business Contact
    MUBE Open Browser And Login As CM User
    MUBE Verify That Contact Person Sales Role Is Updated
    [Teardown]  Logout From All Systems

Opportunity: Check that opportunity cannot be created for a Group Account
    [Tags]      BQA-40
    [Setup]     Create Test Account With Admin User     Group
    Login to Salesforce and Close All Tabs
    Go To Account   ${TEST_GROUP_ACCOUNT_NAME}
    Verify That User Cannot Create New Opportunity
    [Teardown]  Close Tabs And Logout

Opportunity: Check that opportunity cannot be created for Account with passive legal status
    [Tags]      BQA-41
    [Setup]     Login to Salesforce and Close All Tabs
    Go to Account       ${TEST_PASSIVE_ACCOUNT}
    Try To Create New Opportunity And It Should Fail

Sales Admin: Update closed opportunity
    [Tags]      BQA-70      wip
    [Template]      Update Closed Opportunity Test Case
    Cancelled           Cancelled
    # Closed Lost         Lost
    # Closed Not Won      Not Won
    # Closed Won          Won         Negotiate and Close

Quick actions: create Meeting
    [Tags]      BQA-17
    [Setup]     Login to Salesforce and Close All Tabs
    Go to Account       ${TEST_ACCOUNT}
    Open Details Tab At Account View
    Click New Event
    Fill Event Data
    Click Create Event Button
    Go To Account       ${TEST_EVENT_SUBJECT}
    Edit Event Description and WIG Areas
    Verify That Event Has Correct Data

*** Keywords ***

Check If Contact Person Exists And Create New One If Not
    [Arguments]    ${contact_person}
    ${cp_exists}=    Run Keyword And Return Status    Should Not Be Empty    ${contact_person}
    Run Keyword If    ${cp_exists}    Return From Keyword
    Close Browser
    MUBE Open Browser And Login As CM User
    MUBE Create New Contact Person For Business Customer    ${MUBE_CUSTOMER_ID}
    MUBE Logout CRM
    Close Browser
    Open Browser And Go To Login Page
    Login to Salesforce And Close All Tabs
    Wait Until Account Is In Salesforce And Go To Account
    Click Contact Person Details
    Verify That Contact Person Information Is Correct
    Set Suite Variable    ${CONTACT_PERSON_CRM_ID_FOR_UPDATE_TEST}    ${CONTACT_PERSON_CRM_ID}
    Set Suite Variable    ${CONTACT_PERSON_NAME}    Test ${TEST_CONTACT_PERSON_LAST_NAME}

Enter mandatory information and save new contact
    Add Mandatory Contact Data
    Click Create Contact Person Button
    Verify That Create Contact Person Button Is Not Visible
    Verify That Error Message Is Not Displayed

Enter mandatory (invalid) information and verify cp was not saved
    Add Mandatory Contact Data    Test    Invalid Contact    noreply@teliasonera.com    12notNumbers
    Click Create Contact Person Button
    Verify That Error Message Is Displayed

Open Details and choose New Contact from More tab
    Open Details Tab At Account View
    Click Feed Button
    Click Add New Contact

Wait Until Account Is In Salesforce And Go To Account
    Wait Until Keyword Succeeds     15 minutes   15 seconds      Run Keywords
    ...         Run Keyword And Ignore Error    Close All Tabs      AND
    ...         Go To Account       Test ${TEST_CONTACT_PERSON_LAST_NAME}

Revert Account Owner Back To GESB Integration
    Close All Tabs
    Go To Account   ${TEST_ACCOUNT}
    Change Account Owner    GESB Integration

Close active opportunity
    [Documentation]     Template for BQA-42 - BQA-45, and BQA-70 tests
    [Arguments]     ${stage}    ${status}   ${original_stage}=Analyse Prospect
    Go to Account   ${TEST_ACCOUNT}
    Create New Opportunity For Customer   days=5    stage=${original_stage}
    Verify That Opportunity Is Found With Search
    Set Opportunity Stage And Save      ${stage}
    Verify That Error Messages Are Shown
    Fill Close Reason And Comment And Save
    Verify That Opportunity Status Has Been Changed      ${stage}    ${status}
    Verify That Opportunity Is Not Found From Open Opportunities

Create Test Account With Admin User
    [Arguments]     ${type}
    ${credentials}=     Config Section Map    preprod
    Go To Salesforce
    Login To Salesforce     &{credentials}[username]     &{credentials}[password]
    Go To Sales Application And Close All Tabs
    Open Accounts
    Create New Account      Group   Test Group Account
    Run Keyword If     '${type}'=='Group'    Set Test Variable   ${TEST_GROUP_ACCOUNT_NAME}    ${TEST_ACCOUNT_NAME}
    Run Keyword If     '${type}'=='Group'    Create Child Account
    Close Tabs And Logout

Create Child Account
    Close All Tabs
    Open Accounts
    Sleep   2       The page needs a moment to catch its breath
    Create New Account      Billing     Test Account    ${TEST_GROUP_ACCOUNT_NAME}

Contact Person Should Be Found In MIT UAD
    [Arguments]     ${customer_id}=${MUBE_CUSTOMER_ID}
    Wait Until Keyword Succeeds     5m     10s      UAD Verify That Contact Person Is Found For Customer        ${customer_id}

Wait Until Contact Person Is Found In MultiBella
    Wait Until Keyword Succeeds     15 minutes   15 seconds
    ...     MUBE Select Contact Person      ${TEST_CONTACT_PERSON_LAST_NAME}

Update Closed Opportunity Test Case
    [Arguments]     ${stage}    ${status}   ${original_stage}=Analyse Prospect
    Log to Console    ${status}
    Login to Salesforce and Close All Tabs
    Close active Opportunity    ${stage}    ${status}       ${original_stage}
    Close Tabs And Logout
    Login to Salesforce and Close All Tabs      Sales Admin User
    Go To Account   ${OPPORTUNITY_NAME}
    Update Opportunity Close Date And Close Reason