*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}multibella_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}uad_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}tellu_keywords.robot

Library             config_parser

# Suite Setup         Open Browser And Go To Login Page
Suite Teardown      Close All Browsers

Test Setup          Open Browser And Go To Login Page
Test Teardown       Logout From All Systems and Close Browser
Force Tags          sales

*** Variables ***
${MUBE_CUSTOMER_ID}                         2030101-1   # Juleco
${CONTACT_PERSON_CRM_ID_FOR_UPDATE_TEST}    ${EMPTY}    # 1916290
${CONTACT_PERSON_NAME}                      ${EMPTY}    # Test Contact Person 77590434
${PRODUCT}                                  ${EMPTY}    # required for creating Opportunities
${TEST_PASSIVE_ACCOUNT}                     T. E. Roos Oy
${TEST_EVENT_SUBJECT_FOR_UPDATE_TEST}       ${EMPTY}

*** Test Cases ***

Contact: Add new contact (valid data)
    [Tags]    add_new_contact    BQA-1
    Go To Salesforce and Login
    Create New Contact Person For Customer
    Check that contact has been saved and can be found under proper Account

# Contact: Add new contact (invalid data)
#     [Tags]    add_new_contact_invalid    BQA-1
#     Go To Salesforce and Login
#     Go to Account    ${DEFAULT_TEST_ACCOUNT}
#     Open Details and choose New Contact from More tab
#     Enter mandatory (invalid) information and verify cp was not saved

Create Contact Person In MultiBella And Verify It Appears In MIT And Salesforce
    [Tags]      add_new_contact     BQA-53      BQA-108      BQA-1835    smoke
    [Documentation]     Entry Conditions: MultiBella userIntegrations are open
    MUBE Open Browser And Login As CM User
    MUBE Create New Contact Person For Business Customer    ${MUBE_CUSTOMER_ID}
    MUBE Logout CRM
    UAD Open Browser And Go To Login Page
    UAD Go to Page And Log in
    Contact Person Should Be Found In MIT UAD
    Close Browser
    Open Browser And Go To Login Page
    Login to Salesforce And Close All Tabs
    Wait Until Account Is In Salesforce And Go To Account
    Click Contact Person Details
    Verify That Contact Person Information Is Correct
    Set Suite Variable    ${CONTACT_PERSON_CRM_ID_FOR_UPDATE_TEST}    ${CONTACT_PERSON_CRM_ID}
    Set Suite Variable    ${CONTACT_PERSON_NAME}    Test ${TEST_CONTACT_PERSON_LAST_NAME}
    Set Suite Variable    ${TEST_CONTACT_PERSON_LAST_NAME}

Sales Admin: Change Account owner
    [Tags]      BQA-8
    [Documentation]     Change the owner of ${DEFAULT_TEST_ACCOUNT} to Sales admin. Then revert the changes.
    Go To Salesforce and Login      Sales Admin User
    Go To Account   ${DEFAULT_TEST_ACCOUNT}
    Change Account Owner    Sales Admin
    Verify that Owner Has Changed   Sales Admin
    [Teardown]  Run Keywords    Revert Account Owner Back To GESB Integration   AND
    ...                         Logout From All Systems and Close Browser

Update Contact Person in SalesForce
    [Tags]      BQA-117     BQA-109
    [Setup]     Run Keywords    Open Browser And Go To Login Page   AND
    ...         Check If Contact Person Exists And Create New One If Not    ${CONTACT_PERSON_CRM_ID_FOR_UPDATE_TEST}    AND
    ...         Close Tabs And Logout
    Go To Salesforce and Login
    Go to Account    ${CONTACT_PERSON_NAME}
    Click Contact Person Details
    Verify That Contact Person Information is Correct
    Update Contact Person in Salesforce
    Close Tabs And Logout
    Close Browser
    MUBE Open Browser And Login As CM User
    MUBE Verify That Contact Person Information Is Updated
    TellU Go to Login Page And Login
    TellU Open Contact Person Editor
    TellU Search Contact Person By Attribute    Last Name   ${TEST_CONTACT_PERSON_LAST_NAME}
    TellU Verify That Contact Person Is Updated

Sales Process: Create opportunity from Account
    [Tags]      BQA-27
    Go To Salesforce and Login
    Go To Account   ${DEFAULT_TEST_ACCOUNT}
    Create New Opportunity For Customer
    Verify That Opportunity Is Found In Todays Page
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Verify That Opportunity is Found From My All Open Opportunities

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
    [Tags]      BQA-45      BQA-46
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
    Create New Contact Person For Customer
    Check that contact has been saved and can be found under proper Account
    MUBE Open Browser And Login As CM User
    MUBE Open Customers Page
    MUBE Search and Select Customer With Name    ${DEFAULT_TEST_ACCOUNT}
    Wait Until Contact Person Is Found In MultiBella
    UAD Open Browser And Go To Login Page
    UAD Go to Page And Log In
    Contact Person Should Be Found In MIT UAD   ${DEFAULT_TEST_ACCOUNT_BUSINESS_ID}

Sales Process: Create/update Sales Plan
    [Tags]      BQA-24      wip
    Go to Salesforce and Login
    Go to Account    ${DEFAULT_TEST_ACCOUNT}
    Open Sales Plan Tab At Account View
    Create New Sales Plan If Inactive
    Update Description, Customer Business Goals, and Customer Business Challenges fields and press Save
    Add Solution Area and update Solution Sub Area data
    Go to other view and then back to Sales Plan
    Verify that updated values are visible in Sales Plan
    # Todo: Verify when testing starts in PREPROD whether things not showing in Sales Plan is a bug or just missing
    # functionality in PREPROD.

Contact: Update contact
    [Tags]      BQA-23
    [Setup]     Run Keywords    Open Browser And Go To Login Page   AND
    ...         Check If Contact Person Exists And Create New One If Not    ${CONTACT_PERSON_CRM_ID_FOR_UPDATE_TEST}    AND
    ...         Close Tabs And Logout
    Go To Salesforce and Login
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
    Go to Account       ${DEFAULT_TEST_ACCOUNT}
    Open Details Tab At Account View
    Click New Item For Account    New Event
    Fill Event data     type=Meeting    reason=New Customer
    Click Create Event Button
    Verify That Event Is Created
    Go To Event
    Edit Event Description and WIG Areas
    Verify That Event Has Correct Data
    Verify That Description And WIG Areas Are Correct
    Set Suite Variable      ${TEST_EVENT_SUBJECT_FOR_UPDATE_TEST}       ${TEST_EVENT_SUBJECT}

Quick actions: create Opportunity from Account (Feed) by Customer Care user
    [Tags]      BQA-19
    Go To Salesforce and Login      Customer Care User
    Go to Account    ${DEFAULT_TEST_ACCOUNT}
    Create New Opportunity For Customer
    # todo: 4. Close date is automatically give two days ahead.
    Opportunity Should be Unassigned

Quick actions: create Customer Call
    [Tags]      BQA-18
    Go To Salesforce and Login
    Go to Account       ${DEFAULT_TEST_ACCOUNT}
    Open Details Tab At Account View
    Click New Item For Account    New Event
    Fill Event Data     type=Customer Call    reason=Booking
    Click Create Event Button
    Verify That Event Is Created
    Go To Event
    Edit Event Description and WIG Areas
    Verify That Event Has Correct Data      Customer Call
    Verify That Description And WIG Areas Are Correct
    Set Suite Variable      ${TEST_EVENT_SUBJECT_FOR_UPDATE_TEST}       ${TEST_EVENT_SUBJECT}

Meeting/Customer Call: Update meeting to Done
    [Tags]      BQA-21
    Go To Salesforce and Login
    Go to Account       ${DEFAULT_TEST_ACCOUNT}
    Create New Event If Necessary
    Go To Event
    Update meeting status to Done and Save
    Add Meeting Outcome and Save
    Verify That Event Has Correct Data

# Contact persons added address can not saved without City populated
#     [Tags]      BQA-1809    wip
#     Go To Salesforce and Login
#     Go to Account    ${DEFAULT_TEST_ACCOUNT}
#     Open Details and choose New Contact from More tab
#     Enter mandatory information and save new contact    salutation=--None--
#     Check that contact has been saved and can be found under proper Account
#     # Basically BQA-1 until this point
#     Go To Account    Test ${TEST_CONTACT_PERSON_LAST_NAME}
#     Edit Contact Person's Added Address
#     # Todo: test once address is editable

Sales Process: E2E opportunity process incl. modelled and unmodelled products & Quote & SA & Order
    [Tags]      BQA-33      wip
    Go To Salesforce and Login
    Go to Account    ${DEFAULT_TEST_ACCOUNT}
    Create New Opportunity For Customer
    Open just created opportunity and update Win probability, add Competitor and Partner
    Add Solution Area With Quick Action
    Verify That Values Are Visible In Opportunity Layout
    Open Details View At Opportunity
    Click CPQ At Opportunity View
    Add modelled product and unmodelled product to cart (CPQ)
    Update Sales Type and Prices For unmodelled Product (CPQ)
    Click View Quote (CPQ)
    Press Review Record and add Contact and Quote email text
    # Click Create Order (CPQ)
    # 11. Preview Quote via Preview button and then Submit Quote to customer by pressing Send Quote Email buttons. Quote email is sent to Contact visible in Quote.
    Send Quote Email To Customer
    # 12. Check that Quote status has been automatically updated to Submitted. Go to Opportunity and check that its stage is automatically updated to Negotiate & Close and opportunity status is Offer Sent. Check that values from Quote have been updated to opportunity.
    Verify That Quote Status Is Updated to      Submitted
    Go To Account   ${OPPORTUNITY_NAME}
    Verify That Opportunity Status Has Been Changed     Negotiate & Close   Offer Sent
    # 13. Go to Account (via link in Quote) and Create new contract (Service Agreement). Set contract status as Signed and save. Contract will appear in Account record.
    Go To Account   ${DEFAULT_TEST_ACCOUNT}
    Create New Contract For Customer
    # 14. Go to Quote and open CPQ. Press Create Order button and then View Record.
    Go to Account   ${OPPORTUNITY_NAME}     Quote
    Click CPQ At Opportunity View       # Todo: Check this works when going from a quote instead of opportunity
    Click Create Order (CPQ)
    # Click View Record (CPQ)
    # todo: 15. Press Preview order summary button to check order summary pdf. Close preview and send order summary to customer by pressing Send Order Summary Email.
    Log     Todo: 15. Press Preview order summary button to check order summary pdf. Close preview and send order summary to customer by pressing Send Order Summary Email.
    # 16. Send order to delivery by pressing Submit Order to Delivery button. Check that order status has been automatically updated from Draft into In Progress. Check that order can be found from Multibella Case Management.
    Submit Order To Delivery (CPQ)
    Verify That Order Status Is Updated to      In Progress
    Verify That Order Can Be Found From Multibella
    # 17. Go to opportunity and close it as Won. Check that mandatory data is needed (win probability is updated automatically to 100%, Close Reason and Close Comment are mandatory).
    Go To Account   ${OPPORTUNITY_NAME}
    Set Opportunity Stage And Save      Closed Won
    Verify That Error Messages Are Shown
    Fill Close Reason And Comment And Save
    Verify That Opportunity Status Has Been Changed      Closed Won    Won
    Verify That Win Probability Is      100%
    # 18. Check that opportunity cannot be updated after status has been set to Won.
    Verify That Opportunity Cannot Be Updated
    # todo: 19. Check that Continuation opportunity is created based on rules and is visible in My Opportunities.
    Log     Todo: 19. Check that Continuation opportunity is created based on rules and is visible in My Opportunities.

# Opportunity: Check that Account can be changed for an active opportunity
#     [Tags]      BQA-39      wip
#     # 1. Go to open opportunity
#     # 2. Change Account for this opportunity and save. Opportunity is now linked to new Account.
#     # 3. Go to Opportunity - My Opportunities and check that updated opportunity is linked with new Account.
#     Go To Salesforce and Login
#     Go to Account    ${DEFAULT_TEST_ACCOUNT}
#     Create New Opportunity For Customer
#     # Todo: This requires lookup search and probably won't finish this
#     [Teardown]      Pause Execution

Create in SalesForce and in MultiBella a new Contact Person
    [Tags]      BQA-118
    Go To Salesforce and Login
    Create New Contact Person For Customer
    Set Test Variable   ${FIRST_CONTACT_PERSON}     ${TEST_CONTACT_PERSON_LAST_NAME}
    Close Browser
    MUBE Open Browser And Login As CM User
    MUBE Create New Contact Person For Business Customer    ${MUBE_CUSTOMER_ID}
    MUBE Logout CRM
    Set Test Variable   ${SECOND_CONTACT_PERSON}    ${TEST_CONTACT_PERSON_LAST_NAME}
    Contact Persons Should Be Visible in TellU

Try to create Opportunity/Contact Person/or activity linked to Group in SalesForce
    [Tags]      BQA-107
    Create Test Account With Admin User     Group
    Go To Salesforce and Login
    Go To Account   ${TEST_GROUP_ACCOUNT_NAME}
    Verify That Activity Cannot Be Linked to Group Account

Sales Process: Update Sales Plan of an Account which you are not owner
    [Tags]      BQA-25
    Go to Salesforce and Login
    Go to Account    ${DEFAULT_TEST_ACCOUNT}
    Open Sales Plan Tab At Account View
    Update Description, Customer Business Goals, and Customer Business Challenges fields and press Save
    Open Active Sales Plan
    Verify That Sales Plan Update History Is Correct

# CP's added address can be removed and change
#     [Tags]      BQA-1810    wip
#     Check If Contact Person Exists And Create New One If Not    ${CONTACT_PERSON_CRM_ID_FOR_UPDATE_TEST}
#     Go to Salesforce and Login
#     Go to Account    ${CONTACT_PERSON_NAME}
#     # Todo: editable address (same as BQA-1809)

Create/Update new Contact Person in TellU
    [Tags]      BQA-119
    Create And Update Contact Person In TellU
    Contact Person Should Be Updated In MultiBella
    Close Browser
    Contact Person Should Be Updated In Salesforce

Test Contact person double check works ok in Claudia
    [Tags]      BQA-2335
    Go to Salesforce and Login
    Try to create a new contact person with a same name to     ${DEFAULT_TEST_ACCOUNT}
    User sees a list of Contact Persons and can save with the same name

Opportunity Cards
    [Tags]      BQA-2194    wip
    Go to Salesforce and Login
    Go to Account    ${DEFAULT_TEST_ACCOUNT}
    Create New Opportunity For Customer
    Open Open Opportunities Tab At Account View
    Correct Quick Actions Should Be Visible
    # todo: 5: Update the record through Update quick action.
    # todo: 6: Create a new event through the quick action
    # todo: 7: Create a new task through the quick action
    # todo: 8: Close the opportunity through the quick action.

Opportunity: Pick opportunity from queue
    [Tags]      BQA-37
    [Setup]     Run Keywords    Open Browser And Go To Login Page       AND
    ...         Go To Salesforce and Login      Customer Care User      AND
    ...         Go to Account    ${DEFAULT_TEST_ACCOUNT}                AND
    ...         Create New Opportunity For Customer                     AND
    ...         Logout From Salesforce
    Go To Salesforce and Login
    Go to Today page and check that there is link to team's opportunity queue
    Open Opportunities
    Select Correct View Type    B2B DigiSales
    Select Opportunity    ${OPPORTUNITY_NAME}
    Open Details View At Opportunity
    Assign Opportunity To Me
    Set Opportunity Stage And Save      Prepare Solution Proposal
    Verify That Opportunity is Found From My All Open Opportunities

Create a Contact Person in SalesForce with the same name as new to same Customer
    [Tags]      BQA-52
    Go To Salesforce and Login
    Create New Contact Person For Customer
    Create New Contact Person For Customer      last_name=${TEST_CONTACT_PERSON_LAST_NAME}
    Close Tabs And Logout
    Close Browser
    MUBE Open Browser And Login As CM User
    MUBE Open Customers Page
    MUBE Search and Select Customer With Name    ${DEFAULT_TEST_ACCOUNT}
    Wait Until Contact Person Is Found In MultiBella    2

Enable Sales Person to rate Opportunity and Task Source Data Quality
    [Tags]      BQA-2182    wip
    # [Setup]     Run Keywords    Open Browser And Go To Login Page       AND
    # ...         Go To Salesforce and Login      Customer Care User      AND
    # ...         Go to Account    ${DEFAULT_TEST_ACCOUNT}                AND
    # ...         Create New Opportunity For Customer                     AND
    # ...         Create New Task For Customer                            AND
    # ...         Assign Task To B2B Digisales                            AND
    # ...         Logout From Salesforce
    # 15. Set the status to closed. Save.
    # 16. Set a random quality rating. Save.
    # 17. Create own task and check that there is no Quality rating visible
    # 18. Close own task without setting rating value
    Set Test Variable   ${OPPORTUNITY_NAME}     Opportunity 62852916
    Set Test Variable   ${TASK_NAME}    Task 19997940
    Go To Salesforce and Login
    Go To Account   ${OPPORTUNITY_NAME}
    Click Details Button
    Verify That Quality Rating Field Exists
    # Assign Opportunity To Me
    Verify That Quality Rating Has Correct Values
    Rate Opportunity    Excellent
    Rate Opportunity    --None--
    Set Opportunity Stage And Save      Negotiate and Close
    Try to save opportunity as Closed Won / Closed Lost / Closed Not Won
    Rate Opportunity    Excellent
    Go to Account    ${DEFAULT_TEST_ACCOUNT}
    Create New Opportunity For Customer
    Go To Account   ${OPPORTUNITY_NAME}
    Set Opportunity Stage And Save      Negotiate and Close
    Go To Account   ${TASK_NAME}
    Verify That Quality Rating Field Exists


*** Keywords ***

Check If Contact Person Exists And Create New One If Not
    [Arguments]    ${contact_person}
    ${cp_exists}=    Run Keyword And Return Status    Should Not Be Empty    ${contact_person}
    # We need to ensure the contact person has the default data, because the next keyword (after this)
    # checks if the CP has default data
    Run Keyword If      ${cp_exists}    Ensure Contact Person Information Is Reset To Default
    Run Keyword If      ${cp_exists}    Return From Keyword
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
    Set Suite Variable    ${TEST_CONTACT_PERSON_LAST_NAME}

Wait Until Account Is In Salesforce And Go To Account
    Wait Until Keyword Succeeds     25 minutes   15 seconds      Run Keywords
    ...         Run Keyword And Ignore Error    Close All Tabs      AND
    ...         Go To Account       Test ${TEST_CONTACT_PERSON_LAST_NAME}

Revert Account Owner Back To GESB Integration
    Close All Tabs
    Go To Account   ${DEFAULT_TEST_ACCOUNT}
    Change Account Owner    GESB Integration

Close active opportunity
    [Documentation]     Template for BQA-42 - BQA-45, and BQA-70 tests
    [Arguments]     ${stage}    ${status}   ${original_stage}=Analyse Prospect
    Open Browser And Go To Login Page
    Login to Salesforce
    Go to Account   ${DEFAULT_TEST_ACCOUNT}
    Create New Opportunity For Customer   days=5    stage=${original_stage}
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Add Product To Opportunity
    Set Opportunity Stage And Save      ${stage}    expect_error=${TRUE}
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

Ensure Contact Person Information Is Reset To Default
    Open Browser And Go To Login Page
    Login to Salesforce And Close All Tabs
    Go To Account       ${CONTACT_PERSON_NAME}
    Click Contact Person Details
    Update Contact Person in Salesforce     ${DEFAULT_PHONE}      ${DEFAULT_BUSINESS_CARD_TITLE}
    Close Browser

Create Child Account
    Close All Tabs
    Open Accounts
    Sleep   5       The page needs a moment to catch its breath
    Capture Page Screenshot
    Create New Account      Billing     Test Account    ${TEST_GROUP_ACCOUNT_NAME}

Contact Person Should Be Found In MIT UAD
    [Arguments]     ${customer_id}=${MUBE_CUSTOMER_ID}
    Wait Until Keyword Succeeds     10m     10s      UAD Verify That Contact Person Is Found For Customer        ${customer_id}

Wait Until Contact Person Is Found In MultiBella
    [Documentation]     The parameter indicates how many contact persons with the same last name should be in MUBE.
    [Arguments]     ${times}=1
    Wait Until Keyword Succeeds     15 minutes   15 seconds
    ...     MUBE Contact Person Should Be Found X Times      ${TEST_CONTACT_PERSON_LAST_NAME}   ${times}

Update Closed Opportunity Test Case
    [Arguments]     ${stage}    ${status}   ${original_stage}=Analyse Prospect
    Log to Console    ${status}
    ${passed}=     Set Variable      FAILED
    ${new_close_reason}=        Set Variable If         '${status}'=='Won'
    ...     01 Relationship     09 Customer Postponed
    Close active Opportunity    ${stage}    ${status}       ${original_stage}
    Close Tabs And Logout
    Login to Salesforce and Close All Tabs      Sales Admin User
    Go To Account   ${OPPORTUNITY_NAME}
    Update Opportunity Close Date And Close Reason      reason=${new_close_reason}
    Verify That opportunity Close Reason And Date Has Been Changed      2     ${new_close_reason}
    ${passed}=      Set Variable        PASSED
    [Teardown]      Run Keywords        Log to Console      ${passed}   AND     Logout From All Systems And Close Browser

Create New Event If Necessary
    ${event_exists}=    Run Keyword And Return Status    Should Not Be Empty    ${TEST_EVENT_SUBJECT_FOR_UPDATE_TEST}
    Run Keyword If    ${event_exists}    Set Test Variable       ${TEST_EVENT_SUBJECT}   ${TEST_EVENT_SUBJECT_FOR_UPDATE_TEST}
    Run Keyword If    ${event_exists}    Return From Keyword
    Open Details Tab At Account View
    Click New Item For Account    New Event
    Fill Event Data     type=Customer Call    reason=Booking
    Click Create Event Button
    Verify That Event Is Created

Press Review Record and add Contact and Quote email text
    Add Contact Person To Product Order    ${DEFAULT_TEST_CONTACT}
    Add Quote Email Text To Product Order

Verify That Order Can Be Found From Multibella
    Wait Until Keyword Succeeds    60 s    5 s    Extract MuBe CaseID From Opportunity
    # Todo: Do I need to go to MUBE?

Contact Persons Should Be Visible in TellU
    TellU Go to Login Page And Login
    TellU Open Contact Person Editor
    TellU Search Contact Person By Attribute    Customer Name    ${DEFAULT_TEST_ACCOUNT}
    TellU Show All Contact Person In Search Results
    Wait Until Keyword Succeeds     10min    5s      Contact Persons Should Appear In TellU

Contact Persons Should Appear In TellU
    TellU Page Should Contain Contact Person Last Name    ${FIRST_CONTACT_PERSON}
    TellU Page Should Contain Contact Person Last Name    ${SECOND_CONTACT_PERSON}
    [Teardown]      TellU Refresh Search

Create And Update Contact Person In TellU
    TellU Go to Login Page And Login
    TellU Create New Contact Person
    Go To   ${TELLU_SERVER}
    Set Test Variable   ${OLD_EMAIL}    ${TEST_CONTACT_PERSON_EMAIL}
    TellU Select Contact Person     ${TEST_CONTACT_PERSON_LAST_NAME}
    TellU Edit Contact Person
    Set Test Variable   ${NEW_EMAIL}    ${TEST_CONTACT_PERSON_EMAIL}

Contact Person Should Be Updated In MultiBella
    MUBE Go To CRM Login Page And Login As CM User
    MUBE Verify That Contact Person From TellU Is Updated

Contact Person Should Be Updated In Salesforce
    Open Browser And Go To Login page
    Go To Salesforce and Login
    Wait Until Contact Person Is Found In Salesforce    Test123 ${TEST_CONTACT_PERSON_LAST_NAME}
    Go To Account   Test123 ${TEST_CONTACT_PERSON_LAST_NAME}
    Click Contact Person Details
    Verify That Contact Person Information is Correct
    ...     name=Test123 ${TEST_CONTACT_PERSON_LAST_NAME}
    ...     email=${TEST_CONTACT_PERSON_EMAIL}
    ...     language=${DEFAULT_LANGUAGE_UPDATED}
    ...     street_name=${EMPTY}
    ...     street_number=${EMPTY}
    ...     staircase=${EMPTY}
    ...     apartment_door=${DEFAULT_PO_BOX}
    ...     postal_code=${DEFAULT_POSTAL_CODE_UPDATED}
    ...     city=${DEFAULT_CITY_UPDATED}

Try to create a new contact person with a same name to
    [Arguments]     ${account}
    Open Contacts
    Click To Create New Contact From Main Page
    Add Mandatory Contact Data      Paavo   Pesusieni   12345678noreply@teliacompany.com    location=Main Page
    Add Account For Contact Person  ${account}
    Save New Contact Person And Expect Error    duplicate record

User sees a list of Contact Persons and can save with the same name
    Contact Person List Should Have     ${DEFAULT_TEST_CONTACT}     ${DEFAULT_TEST_CONTACT_EMAIL}
    Save (Ignore Alert) Button Should Be Visible

Try to save opportunity as Closed Won / Closed Lost / Closed Not Won
    Edit Opportunity
    Change Stage To     Closed Won
    Try To Save Opportunity And Expect Errors
    Change Stage To     Closed Lost
    Try To Save Opportunity And Expect Errors
    Change Stage To     Closed Not Won
    Try To Save Opportunity And Expect Errors
    Cancel Edit