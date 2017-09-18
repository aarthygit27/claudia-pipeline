*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}multibella_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}uad_keywords.robot

Library             config_parser

# Suite Setup         Open Browser And Go To Login Page
Suite Teardown      Close All Browsers

Test Setup          Open Browser And Go To Login Page
Test Teardown       Logout From All Systems and Close Browser
Force Tags          sales

*** Variables ***
${TEST_ACCOUNT}                             Juleco
# ${OPPO_TEST_ACCOUNT}                        Juleco
${MUBE_CUSTOMER_ID}                         2030101-1   # Juleco
${TEST_ACCOUNT_CUSTOMER_ID}                 2030101-1   # Juleco
${CONTACT_PERSON_CRM_ID_FOR_UPDATE_TEST}    ${EMPTY}    # 1916290
${CONTACT_PERSON_NAME}                      ${EMPTY}    # Test Contact Person 77590434
${PRODUCT}                                  ${EMPTY}    # required for creating Opportunities
${TEST_PASSIVE_ACCOUNT}                     T. E. Roos Oy
${TEST_EVENT_SUBJECT_FOR_UPDATE_TEST}       ${EMPTY}

*** Test Cases ***

Contact: Add new contact (valid data)
    [Tags]    add_new_contact    BQA-1
    Go To Salesforce and Login
    Go to Account    ${TEST_ACCOUNT}
    Open Details and choose New Contact from More tab
    Enter mandatory information and save new contact
    Check that contact has been saved and can be found under proper Account

Contact: Add new contact (invalid data)
    [Tags]    add_new_contact_invalid    BQA-1
    Go To Salesforce and Login
    Go to Account    ${TEST_ACCOUNT}
    Open Details and choose New Contact from More tab
    Enter mandatory (invalid) information and verify cp was not saved

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

Sales Admin: Change Account owner
    [Tags]      BQA-8
    [Documentation]     Change the owner of ${TEST_ACCOUNT} to Sales admin. Then revert the changes.
    Go To Salesforce and Login      Sales Admin User
    Go To Account   ${TEST_ACCOUNT}
    Change Account Owner    Sales Admin
    Verify that Owner Has Changed   Sales Admin
    [Teardown]  Run Keywords    Revert Account Owner Back To GESB Integration   AND
    ...                         Logout From All Systems and Close Browser

Update Contact Person in SalesForce
    [Tags]      BQA-117    wip
    Go To Salesforce and Login      Sales Admin User
    Check If Contact Person Exists And Create New One If Not    ${CONTACT_PERSON_CRM_ID_FOR_UPDATE_TEST}
    Go to Account    ${CONTACT_PERSON_NAME}
    Click Contact Person Details
    Verify That Contact Person Information is Correct
    Update Contact Person in Salesforce
    MUBE Open Browser And Login As CM User
    MUBE Verify That Contact Person Information Is Updated
    # Todo: check this works after integrations are open

Sales Process: Create opportunity from Account
    [Tags]      BQA-27
    Go To Salesforce and Login
    Go To Account   ${TEST_ACCOUNT}
    Create New Opportunity For Customer
    Verify That Opportunity Creation Succeeded
    Verify That Opportunity Is Found In Todays Page
    Verify That Opportunity Is Found With Search
    Verify That Opportunity Is Found From My Opportunities

Opportunity: Closing active opportunity as cancelled
    [Tags]      BQA-42
    [Documentation]     Entry conditions: Sales user is logged in to Salesforce
    [Template]      Close active opportunity
    Cancelled    Cancelled

Opportunity: Closing active opportunity as lost
    [Tags]      BQA-43
    [Documentation]     Entry conditions: Sales user is logged in to Salesforce
    [Template]      Close active opportunity
    Closed Lost    Lost

Opportunity: Closing active opportunity as not won
    [Tags]      BQA-44
    [Documentation]     Entry conditions: Sales user is logged in to Salesforce
    [Template]      Close active opportunity
    Closed Not Won    Not Won

Opportunity: Closing active opportunity as won
    [Tags]      BQA-45
    [Documentation]     Entry conditions: Sales user is logged in to Salesforce
    [Template]      Close active opportunity
    Closed Won    Won    Negotiate and Close

Sales Admin: Change Account owner for Group Account
    [Tags]      BQA-5    wip
    Create Test Account With Admin User     Group
    Go To Salesforce and Login      Sales Admin User
    Go to Account   ${TEST_GROUP_ACCOUNT_NAME}
    Change Account Owner    Sales Admin
    Verify that Owner Has Changed   Sales Admin
    Go to Account   ${TEST_ACCOUNT_NAME}
    Verify that Owner Has Changed   Sales Admin
    [Teardown]      Pause Execution

Sales Admin: Remove Account owner
    [Tags]      BQA-7   wip
    Create Test Account With Admin User     Billing
    Go To Salesforce and Login      Sales Admin User
    Go to Account   ${TEST_ACCOUNT_NAME}
    # TODO

Sales Admin: Add new owner for Group Account
    [Tags]      BQA-9    wip
    Create Test Account With Admin User     Group
    Go To Salesforce and Login      Sales Admin User
    Go to Account   ${TEST_GROUP_ACCOUNT_NAME}
    Change Account Owner    Sales Admin
    Verify that Owner Has Changed   Sales Admin
    Go to Account   ${TEST_ACCOUNT_NAME}
    Verify that Owner Has Changed   Sales Admin
    # TODO: voiko accountilla olla yksi owner?
    [Teardown]      Pause Execution

Add New Contact In Salesforce And Verify It Appears In MUBE And MIT
    [Tags]    BQA-1840      smoke
    [Documentation]     The beginning of the test is the same as Contact: Add new contact (valid data) test case (BQA-1)
    Go To Salesforce and Login
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

Sales Process: Create/update Sales Plan
    [Tags]      BQA-24      wip
    Go to Salesforce and Login
    Go to Account    ${TEST_ACCOUNT}
    Open Sales Plan Tab At Account View
    Create New Sales Plan If Inactive
    Update Description, Customer Business Goals, and Customer Business Challenges fields and press Save
    Add Solution Area and update Solution Sub Area data
    Go to other view and then back to Sales Plan
    Verify that updated values are visible in Sales Plan
    [Teardown]      Pause Execution

Contact: Update contact
    [Tags]      BQA-23
    Go To Salesforce and Login
    Check If Contact Person Exists And Create New One If Not    ${CONTACT_PERSON_CRM_ID_FOR_UPDATE_TEST}
    Go to Account    ${CONTACT_PERSON_NAME}
    Click Contact Person Details
    Verify That Contact Person Information is Correct
    Click Edit Contact Person
    Update Contact Person Sales Role        Business Contact
    Verify That Sales Role Is Updated       Business Contact
    MUBE Open Browser And Login As CM User
    MUBE Verify That Contact Person Sales Role Is Updated

Opportunity: Check that opportunity cannot be created for a Group Account
    [Tags]      BQA-40
    Create Test Account With Admin User     Group
    Go To Salesforce and Login
    Go To Account   ${TEST_GROUP_ACCOUNT_NAME}
    Verify That User Cannot Create New Opportunity

Opportunity: Check that opportunity cannot be created for Account with passive legal status
    [Tags]      BQA-41
    Go To Salesforce and Login
    Go to Account       ${TEST_PASSIVE_ACCOUNT}
    Try To Create New Opportunity And It Should Fail

Sales Admin: Update closed opportunity
    [Tags]      BQA-70
    [Setup]     No Operation
    [Template]      Update Closed Opportunity Test Case
    Cancelled           Cancelled
    Closed Lost         Lost
    Closed Not Won      Not Won
    Closed Won          Won         Negotiate and Close

Quick actions: create Meeting
    [Tags]      BQA-17
    Go To Salesforce and Login
    Go to Account       ${TEST_ACCOUNT}
    Open Details Tab At Account View
    Click New Event
    Fill Event data     type=Meeting    reason=New Customer
    Click Create Event Button
    Verify That Event Is Created
    Go To Event
    Edit Event Description and WIG Areas
    Verify That Event Has Correct Data
    Verify That Description And WIG Areas Are Correct
    Set Suite Variable      ${TEST_EVENT_SUBJECT_FOR_UPDATE_TEST}       ${TEST_EVENT_SUBJECT}

Quick actions: create Opportunity from Account (Feed) by Customer Care user
    [Tags]      BQA-19      wip
    Go To Salesforce and Login      Customer Care User
    Go to Account    ${TEST_ACCOUNT}
    Create New Opportunity For Customer
    # todo: 5. Opportunity is either assigned to AM (assigned accounts) or it can found from opportunity queue (unassigned account).

Quick actions: create Customer Call
    [Tags]      BQA-18
    Go To Salesforce and Login
    Go to Account       ${TEST_ACCOUNT}
    Open Details Tab At Account View
    Click New Event
    Fill Event Data     type=Customer Call    reason=Booking
    Click Create Event Button
    Verify That Event Is Created
    Go To Event
    Edit Event Description and WIG Areas
    Verify That Event Has Correct Data
    Verify That Description And WIG Areas Are Correct
    Set Suite Variable      ${TEST_EVENT_SUBJECT_FOR_UPDATE_TEST}       ${TEST_EVENT_SUBJECT}

Meeting/Customer Call: Update meeting to Done
    [Tags]      BQA-21
    Go To Salesforce and Login
    Go to Account       ${TEST_ACCOUNT}
    Create New Event If Necessary
    Go To Event
    Update meeting status to Done and Save
    Add Meeting Outcome and Save
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
    Open Browser And Go To Login Page
    Login to Salesforce
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
    ${new_close_reason}=        Set Variable If         '${status}'=='Won'
    ...     01 Relationship     09 Customer Postponed
    Close active Opportunity    ${stage}    ${status}       ${original_stage}
    Close Tabs And Logout
    Login to Salesforce and Close All Tabs      Sales Admin User
    Go To Account   ${OPPORTUNITY_NAME}
    Update Opportunity Close Date And Close Reason      reason=${new_close_reason}
    Verify That opportunity Close Reason And Date Has Been Changed      2     ${new_close_reason}
    [Teardown]      Logout From All Systems And Close Browser

Create New Event If Necessary
    ${event_exists}=    Run Keyword And Return Status    Should Not Be Empty    ${TEST_EVENT_SUBJECT_FOR_UPDATE_TEST}
    Run Keyword If    ${event_exists}    Set Test Variable       ${TEST_EVENT_SUBJECT}   ${TEST_EVENT_SUBJECT_FOR_UPDATE_TEST}
    Run Keyword If    ${event_exists}    Return From Keyword
    Open Details Tab At Account View
    Click New Event
    Fill Event Data     type=Customer Call    reason=Booking
    Click Create Event Button
    Verify That Event Is Created