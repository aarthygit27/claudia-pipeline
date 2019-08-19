*** Settings ***
Library           Collections
Resource          ..${/}resources${/}common.robot
Resource          ..${/}resources${/}cpq_keywords.robot
Resource          ..${/}resources${/}sales_app_light_variables.robot
Resource          ..${/}resources${/}multibella_keywords.robot

*** Keywords ***
Go To Salesforce
    [Documentation]    Go to SalesForce and verify the login page is displayed.
    Go To    ${LOGIN_PAGE}
    Login Page Should Be Open

Go to Sales App
    [Documentation]    Go to SalesForce and switch to salesapp menu.
    ${IsElementVisible}=    Run Keyword And Return Status    element should not be visible    ${SALES_APP_NAME}
    Run Keyword If    ${IsElementVisible}    Switch to SalesApp

Switch to SalesApp
    [Documentation]    Go to App launcher and click on SalesApp
    Click Element    ${APP_LAUNCHER}
    Wait until Page Contains Element    ${SALES_APP_LINK}    60s
    Click Element    ${SALES_APP_LINK}
    Wait Until Element is Visible    ${SALES_APP_NAME}    60s

Login Page Should Be Open
    [Documentation]    To Validate the elements in Login page
    Wait Until Keyword Succeeds    60s    1 second    Location Should Be    ${LOGIN_PAGE}
    Wait Until Element Is Visible    id=username    60s
    Wait Until Element Is Visible    id=password    60s

Go To Salesforce and Login into Lightning
    [Arguments]    ${user}=DigiSales Lightning User
    [Documentation]    Go to Salesforce and then Login as DigiSales Lightning User, then switch to Sales App
    ...    and then select the Home Tab in Menu
    Go to Salesforce
    Sleep    20s
    Run Keyword    Login to Salesforce as ${user}
    Go to Sales App
    Reset to Home
    Click Clear All Notifications
    Sleep    30s
    ${error}=    Run Keyword And Return Status    Element Should Be Visible    //div[@class()='modal-container slds-modal__container']
    Run Keyword If    ${error}    click button    //button[@title='OK']

Go To Salesforce and Login into Admin User
    [Arguments]    ${user}=DigiSales Admin User
    [Documentation]    Go to Salesforce and then Login as DigiSales Admin User, then switch to Sales App
    ...    and then select the Home Tab in Menu
    Go to Salesforce
    Run Keyword    Login to Salesforce as ${user}
    Go to Sales App
    Reset to Home

Login to Salesforce as DigiSales Admin User
    Login To Salesforce Lightning    ${SALES_ADMIN_APP_USER}    ${PASSWORD-SALESADMIN}

Login to Salesforce as DigiSales Lightning User
    [Arguments]    ${username}=${B2B_DIGISALES_LIGHT_USER}    ${password}=${Password_merge}
    Login To Salesforce Lightning    ${username}    ${password}

Login to Salesforce as DigiSales B2O User
    [Arguments]    ${username}=${B2O_DIGISALES_LIGHT_USER}    ${password}=${B2O_DIGISALES_LIGHT_PASSWORD}
    Login To Salesforce Lightning    ${username}    ${password}

Login to Salesforce Lightning
    [Arguments]    ${username}    ${password}
    #log to console    ${password}
    Wait Until Page Contains Element    id=username    240s
    Input Text    id=username    ${username}
    Sleep    5s
    Input text    id=password    ${password}
    Click Element    id=Login
    Sleep    60s
    ${infoAvailable}=    Run Keyword And Return Status    element should be visible    //a[text()='Remind Me Later']
    Run Keyword If    ${infoAvailable}    force click element    //a[text()='Remind Me Later']
    run keyword and ignore error    Check For Lightning Force
    ${buttonNotAvailable}=    Run Keyword And Return Status    element should not be visible    ${LIGHTNING_ICON}
    Run Keyword If    ${buttonNotAvailable}    reload page
    Wait Until Page Contains Element    xpath=${LIGHTNING_ICON}    60 seconds

Check For Lightning Force
    Sleep    20s
    ${url}=    Get Location
    ${contains}=    Evaluate    'lightning' in '${url}'
    Run Keyword Unless    ${contains}    Switch to Lightning

Switch to Lightning
    Sleep    10s
    Click Element    xpath=${CLASSIC_MENU}
    Page Should Contain Element    xpath=${SWITCH_TO_LIGHTNING}    60s
    Click Element    xpath=${SWITCH_TO_LIGHTNING}

Reset to Home
    [Arguments]    ${timeout}=60s
    Wait Until Element is Visible    ${SALES_APP_HOME}    60s
    Click Element    ${SALES_APP_HOME}
    Sleep    10s

Go to Entity
    [Arguments]    ${target}    ${type}=${EMPTY}
    ${present}=    Run Keyword And Return Status    Element Should Be Visible    ${CLOSE_NOTIFICATION}
    Run Keyword If    ${present}    Close All Notifications
    Log    Going to '${target}'
    Wait Until Keyword Succeeds    8 mins    40s    Search And Select the Entity    ${target}    ${type}
    Sleep    10s    The page might load too quickly and it can appear as the search tab would be closed even though it isn't

Search And Select the Entity
    [Arguments]    ${target}    ${type}=${EMPTY}
    Reload page
    Search Salesforce    ${target}
    Select Entity    ${target}    ${type}

Search Salesforce
    [Arguments]    ${item}
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}    ${item}
    Sleep    2s
    Press Enter On    ${SEARCH_SALESFORCE}
    #Press Key    xpath=${SEARCH_SALESFORCE}    \\13
    Sleep    2s
    ${IsVisible}=    Run Keyword And Return Status    Element Should Be Visible    ${SEARCH_RESULTS}    60s
    run keyword unless    ${IsVisible}    Press Enter On    ${SEARCH_SALESFORCE}
    ${IsNotVisible}=    Run Keyword And Return Status    Element Should Be Visible    ${SEARCH_RESULTS}    60s
    run keyword unless    ${IsNotVisible}    Search Salesforce    ${item}
    ${NoResultFound}=    Run Keyword And Return Status    Element Should Be Visible    //div[contains(@class, 'noResultsMessage')]    60s
    run keyword if    ${NoResultFound}    Search And Select the Entity    ${item}

Select Entity
    [Arguments]    ${target_name}    ${type}
    ${element_catenate} =    set variable    [@title='${target_name}']
    #Sleep    15s
    #${status}=  Run Keyword And Return Status  Element Should Be Visible   ${Select task}    100s
    #Run Keyword If   ${status}   Click Visible Element    ${TABLE_HEADERForEvent}${element_catenate}
    #Run Keyword unless   ${status}    Click Visible Element    ${TABLE_HEADER}${element_catenate}
    Wait Until Page Contains element    ${TABLE_HEADER}${element_catenate}    120s
    Sleep    15s
    Click Element    ${TABLE_HEADER}${element_catenate}
    Sleep    15s
    Wait Until Page Contains element    //h1//span[text()='${target_name}']    400s
    ${ISOpen}=    Run Keyword And Return Status    Entity Should Be Open    //h1//span[text()='${target_name}']
    run keyword Unless    ${ISOpen}    Search And Select the Entity    ${target_name}    ${type}

Entity Should Be Open
    [Arguments]    ${target_name}
    Sleep    5s
    Wait Until Page Contains element    ${target_name}    30s
    #${Case} ---- ActiveStatus or PassiveStatus of Account

Create New Opportunity For Customer
    [Arguments]    ${Case}    ${opport_name}=${EMPTY}    ${stage}=Analyse Prospect    ${days}=1    ${expect_error}=${FALSE}
    Click New Item For Account    New Opportunity
    Fill Mandatory Opportunity Information    ${stage}    ${days}
    Fill Mandatory Classification
    Click Save Button
    Sleep    10s
    Run Keyword If    '${Case}'== 'PASSIVEACCOUNT'    Validate Opportunity cannot be created    PASSIVEACCOUNT
    ...    ELSE    Run Keyword Unless    ${expect_error}    Verify That Opportunity Creation Succeeded

Click New Item For Account
    [Arguments]    ${type}
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    //a[@title='${type}']
    Run Keyword If    ${status}    Run Keyword With Delay    0.10s    Click Element    xpath=//a[@title='${type}']
    Wait Until Page Contains Element    ${NEW_ITEM_POPUP}    60s

Fill Mandatory Opportunity Information
    [Arguments]    ${stage}=Analyse Prospect    ${days}=1
    ${opport_name}=    Run Keyword    Create Unique Name    TestOpportunity
    Set Test Variable    ${OPPORTUNITY_NAME}    ${opport_name}
    ${date}=    Get Date From Future    ${days}
    Set Test Variable    ${OPPORTUNITY_CLOSE_DATE}    ${date}
    Sleep    5s
    Input Quick Action Value For Attribute    Opportunity Name    ${OPPORTUNITY_NAME}
    Sleep    5s
    Select Quick Action Value For Attribute    Stage    ${stage}
    Sleep    5s
    Input Quick Action Value For Attribute    Close Date    ${OPPORTUNITY_CLOSE_DATE}

Input Quick Action Value For Attribute
    [Arguments]    ${field}    ${value}
    Wait Until Element Is Visible    ${NEW_ITEM_POPUP}//label//*[contains(text(),'${field}')]    60s
    Input Text    xpath=${NEW_ITEM_POPUP}//label//*[contains(text(),'${field}')]//following::input    ${value}

Select Quick Action Value For Attribute
    [Arguments]    ${field}    ${value}
    Wait Until Element Is Visible    ${NEW_ITEM_POPUP}//span[contains(text(),'${field}')]//following::div//a[@class='select']    60s
    Force Click Element    ${NEW_ITEM_POPUP}//span[contains(text(),'${field}')]//following::div//a[@class='select']
    Wait Until Element Is Visible    //div[@class='select-options']//li//a[contains(text(),'${value}')]  60s
    Force Click Element    //div[@class='select-options']//li//a[contains(text(),'${value}')]

Fill Mandatory Classification
    [Arguments]    ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    Set Test Variable    ${OPPO_DESCRIPTION}    Test Automation opportunity description
    Input Text    xpath=//label//span[contains(text(),'Description')]//following::textarea    ${OPPO_DESCRIPTION}

Click Save Button
    Click Element    ${SAVE_OPPORTUNITY}

Verify That Opportunity Creation Succeeded
    Sleep    10s
    Wait Until Element Is Visible    ${ACCOUNT_RELATED}    60s
    Force click element    ${ACCOUNT_RELATED}
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    //span[@title='Account Team Members']
    Run Keyword If    ${status}    Run Keyword With Delay    0.10s    Click Element    xpath=${ACCOUNT_RELATED}
    Sleep    15s
    ScrollUntillFound    //span[text()='Opportunities']/../../span/../../../a
    #Scroll element into view    xpath=//span[text()='Opportunities']/../../span/../../../a
    Run Keyword And Continue On Failure    Scroll Page To Element    //span[text()='Opportunities']/../../span/../../../a
    ${element_xpath}=    Replace String    //span[text()='Opportunities']/../../span/../../../a    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    #Click Visible Element    //span[text()='Opportunities']/../../span/../../../a
    Verify That Opportunity Is Saved And Data Is Correct    ${RELATED_OPPORTUNITY}

Scroll Page To Location
    [Arguments]    ${x_location}    ${y_location}
    Execute JavaScript    window.scrollTo(${x_location},${y_location})
    Sleep    10s

ScrollUntillFound
    [Arguments]    ${element}
    #Run Keyword Unless    ${status}    Execsute JavaScript    window.scrollTo(0,100)
    : FOR    ${i}    IN RANGE    9999
    \    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
    \    Sleep    5s
    \    Execute JavaScript    window.scrollTo(0,${i}*200)
    \    Exit For Loop If    ${status}

Verify That Opportunity Is Saved And Data Is Correct
    [Arguments]    ${element}    ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    ${oppo_name}=    Set Variable    //*[text()='${OPPORTUNITY_NAME}']
    ${account_name}=    Set Variable    //*[@title='Account Name']//following-sibling::div//*[text()='${LIGHTNING_TEST_ACCOUNT}']
    ${oppo_date}=    Set Variable    //*[@title='Close Date']//following-sibling::div//*[text()='${OPPORTUNITY_CLOSE_DATE}']
    ScrollUntillFound    ${element}${oppo_name}
    Run Keyword And Continue On Failure    Scroll Page To Element    ${element}${oppo_name}
    Wait Until Page Contains Element    ${element}${oppo_name}    60s
    Run keyword and ignore error    Click element    ${element}${oppo_name}
    Sleep    10s
    Wait Until Page Contains Element    ${oppo_name}    60s
    Wait Until Page Contains Element    ${account_name}    60s
    Wait Until Page Contains Element    ${oppo_date}    60s

Verify That Opportunity Is Found With Search And Go To Opportunity
    [Arguments]    ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    Go to Entity    ${OPPORTUNITY_NAME}
    Wait until Page Contains Element    ${OPPORTUNITY_PAGE}//*[text()='${OPPORTUNITY_NAME}']    60s
    Verify That Opportunity Is Saved And Data Is Correct    ${OPPORTUNITY_PAGE}

Verify That Opportunity is Found From My All Open Opportunities
    [Arguments]    ${account_name}=${LIGHTNING_TEST_ACCOUNT}    ${days}=1
    ${date}=    Get Date From Future    ${days}
    #${oppo_name}=    Set variable    TestOpportunity 20181228-103642
    ${oppo_name}=    Set Variable    //*[text()='${OPPORTUNITY_NAME}']
    ${account_name}=    Set Variable    //*[@title='Account Name']//following-sibling::div//*[text()='${LIGHTNING_TEST_ACCOUNT}']
    ${oppo_date}=    Set Variable    //*[@title='Close Date']//following-sibling::div//*[text()='${date}']
    Open Tab    Opportunities
    Select Correct View Type    My All Open Opportunities
    Filter Opportunities By    Opportunity Name    ${OPPORTUNITY_NAME}
    Sleep    10s
    Wait Until Page Contains Element    ${OPPORTUNITY_PAGE}${oppo_name}    60s
    Wait Until Page Contains Element    ${account_name}    60s
    Wait Until Page Contains Element    ${oppo_date}    60s

Open tab
    [Arguments]    ${tabName}    ${timeout}=60s
    Wait Until Element is Visible    //a[@title='${tabName}']    60s
    Click Element    //a[@title='${tabName}']
    Sleep    10s

Select Correct View Type
    [Arguments]    ${type}
    Sleep    10s
    #click element    //span[contains(@class,'selectedListView')]
    #Wait Until Page Contains Element    //span[@class=' virtualAutocompleteOptionText' and text()='${type}']    60s
    #Click Element    //span[@class=' virtualAutocompleteOptionText' and text()='${type}']//parent::a
    Select option from Dropdown with Force Click Element    //span[contains(@class,'selectedListView')]    //span[@class=' virtualAutocompleteOptionText' and text()='${type}']//parent::a
    Sleep    10s

Filter Opportunities By
    [Arguments]    ${field}    ${value}
    #${Count}=    get element count    ${RESULTS_TABLE}
    Click Element    //input[contains(@name,'search-input')]
    Wait Until Page Contains Element    ${SEARCH_INPUT}    60s
    Input Text    xpath=${SEARCH_INPUT}    ${value}
    Press Key    xpath=${SEARCH_INPUT}    \\13
    Sleep    10s
    #get_all_links
    Force click element    //table[contains(@class,'uiVirtualDataTable')]//tbody//tr//th//a[contains(@class,'forceOutputLookup') and (@title='${value}')]
    #Run Keyword If    ${Count} > 1    click visible element    xpath=${RESULTS_TABLE}[contains(@class,'forceOutputLookup') and (@title='${value}')]

Go to More tab and select option
    [Arguments]    ${option}
    Click Visible Element    //span[text()='More']
    Sleep    5s
    Wait Until Page Contains element    //*[@class='overflowNavItem slds-dropdown__item']//span[text()='${option}']/../..
    Force click element    //*[@class='overflowNavItem slds-dropdown__item']//span[text()='${option}']/../..
    Sleep    5s
    Wait Until Page Contains Element    //span[text()='${option}']

Go to Contacts
    ${isContactTabVisible}=    Run Keyword And Return Status    Element Should Be Visible    ${CONTACTS_TAB}
    run keyword unless    ${isContactTabVisible}    Go to More tab and select option    Contacts
    Click Visible Element    ${CONTACTS_TAB}
    Sleep    30s
    ${isVisible}=    Run Keyword And Return Status    Element Should Be Visible    //*[@title='Close this window']
    Run Keyword If    ${isVisible}    Go to Contacts
    Wait Until Page Contains element    ${CONTACTS_ICON}    240s

Create New Master Contact
    ${first_name}=    Run Keyword    Create Unique Name    ${EMPTY}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${mobile_num}=    Run Keyword    Create Unique Mobile Number
    ${present}=    Run Keyword And Return Status    Element Should Be Visible    ${CLOSE_NOTIFICATION}
    Run Keyword If    ${present}    Close All Notifications
    wait until keyword succeeds    2mins    5s    Go to Contacts
    Set Test Variable    ${MASTER_FIRST_NAME}    Master ${first_name}
    Set Test Variable    ${MASTER_LAST_NAME}    Test ${first_name}
    Set Test Variable    ${MASTER_PRIMARY_EMAIL}    ${email_id}
    Set Test Variable    ${MASTER_MOBILE_NUM}    ${mobile_num}
    Click Visible Element    ${NEW_BUTTON}
    Click Visible Element    ${MASTER}
    click Element    ${NEXT}
    Wait Until Element is Visible    ${CONTACT_INFO}    60s
    Input Text    ${MOBILE_NUM_FIELD}    ${MASTER_MOBILE_NUM}
    Input Text    ${FIRST_NAME_FIELD}    ${MASTER_FIRST_NAME}
    Input Text    ${LAST_NAME_FIELD}    ${MASTER_LAST_NAME}
    Input Text    ${MASTER_PHONE_NUM_FIELD}    ${MASTER_PHONE_NUM}
    Input Text    ${MASTER_PRIMARY_EMAIL_FIELD}    ${MASTER_PRIMARY_EMAIL}
    Input Text    ${MASTER_EMAIL_FIELD}    ${MASTER_EMAIL}
    Select from search List   ${ACCOUNT_NAME_FIELD}    ${MASTER_ACCOUNT_NAME}
    Click Element    ${SAVE_BUTTON}
    Sleep    10s
    #Validate Master Contact Details    ${CONTACT_DETAILS}

Select from search List
    [Arguments]    ${field}    ${value}
    Input Text    ${field}    ${value}
    Sleep    10s
    Press Enter On   ${field}
    Click Visible Element    //div[@data-aura-class="forceSearchResultsGridView"]//a[@title='${value}']
    Sleep    2s
Select from Autopopulate List
    [Arguments]    ${field}    ${value}
    Input Text    ${field}    ${value}
    Sleep    20s
    Click element    //div[@title='${value}']/../../../a

Validate Master Contact Details
    ${contact_name}=    Set Variable    //span[text()='Name']//following::span//span[text()='${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']//following::a[text()='${MASTER_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']//following::span//span[text()='${MASTER_MOBILE_NUM}']
    ${phone_number}=    Set Variable    //span[text()='Phone']//following::span//span[text()='${MASTER_PHONE_NUM}']
    ${primary_email}=    Set Variable    //span[text()='Primary eMail']//following::a[text()='${MASTER_PRIMARY_EMAIL}']
    ${email}=    Set Variable           //span[text()='Email']//following::a[text()='${MASTER_EMAIL}']
    Go to Entity    ${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}
    Click Visible element    ${DETAILS_TAB}
    Validate Contact Details    ${CONTACT_DETAILS}    ${contact_name}    ${account_name}    ${mobile_number}    ${primary_email}    ${email}
    #Wait Until Page Contains Element    ${element}${phone_number}
    #Wait Until Page Contains Element    ${element}${email}

Validate Contact Details
    [Arguments]    ${element}    ${contact_name}    ${account_name}    ${mobile_number}   ${primary_email}  ${email}
    Wait Until Page Contains Element    ${element}${contact_name}    240s
    Wait Until Page Contains Element    ${element}${account_name}    240s
    Wait Until Page Contains Element    ${element}${mobile_number}    240s
    Wait Until Page Contains Element    ${element}${primary_email}    240s
    Wait Until Page Contains Element    ${element}${email}            240s

Create New NP Contact
    ${first_name}=    Run Keyword    Create Unique Name    ${EMPTY}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${mobile_num}=    Run Keyword    Create Unique Mobile Number
    wait until keyword succeeds    2mins    5s    Go to Contacts
    Set Test Variable    ${NP_FIRST_NAME}    NP ${first_name}
    Set Test Variable    ${NP_LAST_NAME}    Test ${first_name}
    Set Test Variable    ${NP_EMAIL}    ${email_id}
    Set Test Variable    ${NP_MOBILE_NUM}    ${mobile_num}
    Click Visible Element    ${NEW_BUTTON}
    Click Visible Element    ${NON-PERSON}
    click Element    ${NEXT}
    Wait Until Element is Visible    ${CONTACT_INFO}    60s
    Input Text    ${MOBILE_NUM_FIELD}    ${NP_MOBILE_NUM}
    Input Text    ${FIRST_NAME_FIELD}    ${NP_FIRST_NAME}
    Input Text    ${LAST_NAME_FIELD}    ${NP_LAST_NAME}
    Input Text    ${NP_EMAIL_FIELD}    ${NP_EMAIL}
    #Select from Autopopulate List    ${ACCOUNT_NAME_FIELD}    ${NP_ACCOUNT_NAME}
    Input Text    ${ACCOUNT_NAME_FIELD}    ${NP_ACCOUNT_NAME}
    Sleep    2s
    Press Enter On    ${ACCOUNT_NAME_FIELD}
    Click Visible Element    //div[@data-aura-class="forceSearchResultsGridView"]//a[@title='${NP_ACCOUNT_NAME}']
    Press Enter On    ${SAVE_BUTTON}
    Sleep    2s

Validate NP Contact Details
    ${contact_name}=    Set Variable    //span[text()='Name']//following::span//span[text()='Non-person ${NP_FIRST_NAME} ${NP_LAST_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']//following::a[text()='${NP_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']//following::span//span[text()='${NP_MOBILE_NUM}']
    ${email}=    Set Variable    //span[text()='Email']//following::a[text()='${NP_EMAIL}']
    Go to Entity    Non-person ${NP_FIRST_NAME} ${NP_LAST_NAME}
    Click Visible Element    ${DETAILS_TAB}
    Validate Contact Details    ${CONTACT_DETAILS}    ${contact_name}    ${account_name}    ${mobile_number}    ${email}

Create New Contact for Account
    ${first_name}=    Run Keyword    Create Unique Name    ${EMPTY}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${mobile_num}=    Run Keyword    Create Unique Mobile Number
    Set Test Variable    ${AP_FIRST_NAME}    AP ${first_name}
    Set Test Variable    ${AP_LAST_NAME}    Test ${first_name}
    Set Test Variable    ${AP_EMAIL}    ${email_id}
    Set Test Variable    ${AP_MOBILE_NUM}    ${mobile_num}
    Set Test Variable    ${Ap_mail}        kasibhotla.sreeramachandramurthy@teliacompany.com
    click element    ${AP_NEW_CONTACT}
    #Sleep    2s
    Click Visible Element    ${AP_MOBILE_FIELD}
    Input Text    ${AP_MOBILE_FIELD}    ${AP_MOBILE_NUM}
    Input Text    ${FIRST_NAME_FIELD}    ${AP_FIRST_NAME}
    Input Text    ${LAST_NAME_FIELD}    ${AP_LAST_NAME}
    Input Text    ${MASTER_PRIMARY_EMAIL_FIELD}    ${AP_EMAIL}
    Input Text    ${MASTER_EMAIL_FIELD}     ${Ap_mail}
    Click Element    ${AP_SAVE_BUTTON}
    Sleep    2s
    [Return]    ${AP_FIRST_NAME}${AP_LAST_NAME}
Validate AP Contact Details
    Go To Entity    ${AP_FIRST_NAME} ${AP_LAST_NAME}    ${SEARCH_SALESFORCE}
    ${contact_name}=    Set Variable    //span[text()='Name']//following::span//span[text()='${AP_FIRST_NAME} ${AP_LAST_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']//following::a[text()='${AP_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']//following::span//span[@class="uiOutputPhone" and text()='${AP_MOBILE_NUM}']
    ${Primary email}=    Set Variable    //span[text()='Primary eMail']//following::a[text()='${AP_EMAIL}']
    ${mail}=             Set Variable    //span[text()='Primary eMail']//following::a[text()='${Ap_mail}']
    #Click Visible Element    //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    Validate Contact Details    ${CONTACT_DETAILS}    ${contact_name}    ${account_name}    ${mobile_number}    ${Primary email}   ${mail}

Navigate to create new contact
    Wait element to load and click    //a[@title='New']
    Wait until page contains element    //button/span[text()='Next']    30s
    Click element    //button/span[text()='Next']

Open edit contact form
    Click element    //a[@title='Edit']

Close contact form
    Click element    //button[@title='Cancel']

Validate external contact data can not be modified
    ${external_phone}    Set Variable    xpath=//span[text()='External Phone']/../..//span[contains(@class, 'is-read-only')]
    ${external_title}    Set Variable    xpath=//span[text()='External Title']/../..//span[contains(@class, 'is-read-only')]
    ${external_eMail}    Set Variable    xpath=//span[text()='External eMail']/../..//span[contains(@class, 'is-read-only')]
    ${external_status}    Set Variable    xpath=//span[text()='External Status']/../..//span[contains(@class, 'is-read-only')]
    ${external_office_name}    Set Variable    xpath=//span[text()='External Office Name']/../..//span[contains(@class, 'is-read-only')]
    ${external_address}    Set Variable    xpath=//span[text()='External Address']/../..//span[contains(@class, 'is-read-only')]
    ${contact_id}    Set Variable    //span[text()='Contact ID']/../..//span[contains(@class, 'is-read-only')]
    ${ulm_id}    Set Variable    //span[text()='ULM id']/../..//span[contains(@class, 'is-read-only')]
    ${external_id}    Set Variable    xpath=//span[text()='External_id']/../..//span[contains(@class, 'is-read-only')]
    Wait until page contains element    ${external_phone}    30s
    Wait until page contains element    ${external_title}    30s
    Wait until page contains element    ${external_eMail}    30s
    Wait until page contains element    ${external_status}    30s
    Wait until page contains element    ${external_office_name}    30s
    Wait until page contains element    ${external_address}    30s
    Wait until page contains element    ${contact_id}    30s
    Wait until page contains element    ${external_id}    30s
    Wait until page contains element    ${ulm_id}    30s
    sleep    10s

Click view contact relationship
    Wait element to load and click    //span[@title='Related Accounts']/../../a
    sleep    10s
    Click element    ${table_row}
    Wait until page contains element    //a[@title='View Relationship']
    Click element    //a[@title='View Relationship']

Create Unique Mobile Number
    #${numbers}=    Generate Random String    6    [NUMBERS]
    #[Return]    +358888${numbers}
    [Return]    +358888888888

Validate Opportunity cannot be created
    [Arguments]    ${case}
    Run Keyword If    '${Case}'== 'PASSIVEACCOUNT'    Wait Until Element is Visible    ${NEW_ITEM_POPUP}//*[text()='Account is either not a Business Account or Legal Status is not Active! Please review the Account information.']
    ...    ELSE    element should not be visible    //a[@title='New Opportunity' or @title='New']

Cancel Opportunity and Validate
    [Arguments]    ${opportunity}    ${stage}
    Go to Entity    ${opportunity}
    click visible element    ${EDIT_STAGE_BUTTON}
    sleep    5s
    Select option from Dropdown    //div[@class="uiInput uiInput--default"]//a[@class="select"]    ${stage}
    #click visible element    //div[@class="uiInput uiInput--default"]//a[@class="select"]
    #Press Key    //div[@class="uiInput uiInput--default"]//a[@class="select"]    ${stage}
    #Click Element    //a[@title="${stage}"]
    Sleep  30s
    Click element   //span[text()='Products With Manual Pricing']//following::span[text()='Save']
    Validate error message
    Cancel and save
    Validate Closed Opportunity Details    ${opportunity}    ${stage}
    Verify That Opportunity is Not Found under My All Open Opportunities    ${opportunity}

Validate Closed Opportunity Details
    [Arguments]    ${opportunity_name}    ${stage}
    #${current_date}=    Get Current Date    result_format=%d.%m.%Y
    ${current_ts}=    Get Current Date
    ${c_date} =    Convert Date    ${current_ts}    datetime
    ${oppo_close_date}=    Set Variable    //span[@title='Close Date']//following-sibling::div//span[text()='${c_date.day}.${c_date.month}.${c_date.year}']
    Go to Entity    ${opportunity_name}
    Scroll Page To Element    ${oppo_close_date}
    Wait Until Page Contains Element    ${oppo_close_date}    60s
    #Scroll Page To Element    ${OPPORTUNITY_CLOSE_DATE}
    #Wait Until Page Contains Element    ${OPPORTUNITY_CLOSE_DATE}    60s
    Wait Until Page Contains Element    //span[text()='Edit Stage']/../preceding::span[text()='${stage}']    60s
    ${oppo_status}=    set variable if    '${stage}'== 'Closed Lost'    Lost    Cancelled
    ${buttonNotAvailable}=    Run Keyword And Return Status    element should not be visible    ${EDIT_STAGE_BUTTON}
    Run Keyword If    ${buttonNotAvailable}    reload page
    Click Visible Element    ${EDIT_STAGE_BUTTON}
    Select option from Dropdown    //div[@class="uiInput uiInput--default"]//a[@class="select"]    Closed Won
    Save
    Wait Until Page Contains Element    //span[text()='Review the following errors']    60s
    Click element   //button[@title="Close"]
    Sleep  10s
    #Press ESC On    //span[text()='Review the following errors']
    #click element    //*[@title='Cancel']
     Click element   //div[@class="riseTransitionEnabled test-id__inline-edit-record-layout-container risen"]//div[@class="actionsContainer"]//*[contains(text(),"Cancel")]
Save
    click element    //button[@title='Save']
    sleep    2s

Validate error message
    wait until element is visible    //a[@data-field-name="telia_Close_Comment__c"]    15s
    wait until element is visible    //a[@data-field-name="telia_Close_Reason__c"]    15s
    #element should be visible    //a[contains(text(),"Close Comment")]
    #element should be visible    //a[contains(text(),"Close Reason")]
    #element should be visible    //div[@data-aura-class="forcePageError"]

Cancel and save
    Scroll Page To Location    0    3000
    Click element    //a[contains(text(),"Close Comment")]
    Input Text    //label//span[contains(text(),"Close Comment")]/../following::textarea    Cancelling the opportunity
    Click Element    //span[text()='Close Reason']//parent::span//parent::div//div[@class='uiPopupTrigger']//a
    Click Element    //a[@title="09 Customer Postponed"]
    Sleep  10s
    Click element  //span[text()='Products With Manual Pricing']//following::span[text()='Save']
    Sleep    2s

Edit Opportunity
    [Arguments]    ${opportunity}
    Go to Entity    ${opportunity}

Select option from Dropdown
    [Arguments]    ${list}    ${item}
    #Select From List By Value    //div[@class="uiInput uiInput--default"]//a[@class="select"]    ${item}
    #Scroll Page To Element    ${list}
    #${element_position}    Get Vertical Position    ${list}
    #${scroll_position}=    Evaluate    ${element_position}+ 5
    #Log To Console    ${scroll_position}
    #Scroll Page To Location    0    ${scroll_position}
    #click visible element    ${list}
    ScrollUntillFound  ${list}
    force click element   ${list}
    Press Key    ${list}    ${item}
    Sleep    3s
    force click element    //a[@title='${item}']
    sleep  20s

Select option from Dropdown if not able to edit the element from the list
    [Arguments]    ${list}    ${item}   ${element}
    ScrollUntillFound  //button[text()="View all dependencies"]//following::span[text()="Opportunity Complete"]
    Sleep   20s
    Wait Until Page Contains Element    //div[@class="slds-form-element__control"]//span[text()="Create Continuation Sales Opportunity?"]//following::button[text()="View all dependencies"]    60s
    force click element    //div[@class="slds-form-element__control"]//span[text()="Create Continuation Sales Opportunity?"]//following::button[text()="View all dependencies"]
    sleep  20s
    Click Element   //label[text()="Stage"]//following::input[@name="StageName"]
    sleep  10s
    Press Key    //label[text()="Stage"]//following::input[@name="StageName"]    ${element}
    Sleep    10s
    force click element    //a[@title='${element}']
    Sleep  20s
    Click Element   //span[text()="Apply"]

Verify That Opportunity is Not Found under My All Open Opportunities
    [Arguments]    ${opportunity}
    ${oppo_name}=    Set Variable    //*[text()='${opportunity}']    #${OPPORTUNITY_NAME}
    Open Tab    Opportunities
    Select Correct View Type    My All Open Opportunities
    Wait Until Page Contains Element    ${SEARCH_INPUT}    60s
    Input Text    ${SEARCH_INPUT}    ${opportunity}
    Press Key    ${SEARCH_INPUT}    \\13
    Sleep    10s
    Page should contain element    //*[text()='No items to display.']

Create a Task
    ${unique_subject_task}=    run keyword    Create Unique Task Subject
    Click Clear All Notifications
    click Task Link on Page
    Enter Mandatory Info on Task Form    ${unique_subject_task}
    Save Task and click on Suucess Message
    Search And Select the Entity    ${unique_subject_task}    ${EMPTY}
    Validate Created Task    ${unique_subject_task}

click Task Link on Page
    click element    ${NEW_TASK_LABEL}
    Sleep    10s
    wait until page contains element    xpath=${task_subject_input}    40s

Enter Mandatory Info on Task Form
    [Arguments]    ${task_subject}
    input text    xpath=${task_subject_input}    ${task_subject}
    sleep    10s
    ${a}=    run keyword    Enter Task Due Date
    Enter and Select Contact

Enter Task Due Date
    ${date}=    Get Date From Future    7
    Set Test Variable    ${task_due_DATE}    ${date}
    Input Text    xpath=//*[text()='Due Date']/../../div/input    ${task_due_DATE}
    [Return]    ${task_due_DATE}

Enter and Select Contact
    Set Test Variable    ${name_input}    ${AP_FIRST_NAME} ${AP_LAST_NAME}
    Force click element    ${name_input_task}
    Input text    ${name_input_task}    ${name_input}
    Wait Until Page Contains Element    //*[@title='${name_input}']/../..    60s
    Force click element    //*[@title='${name_input}']/../..
    sleep    10s

Save Task and click on Suucess Message
    force click element    ${save_task_button}
    sleep    30s
    #force click element    ${suucess_msg_task_anchor}
    #sleep    40s

Validate Created Task
    [Arguments]    ${unique_subject_task_form}
    ${name_form}    get text    ${contact_name_form}    #helina kejiyu comoare
    #${related_to_form}    get text    ${related_to}    #aacon Oy ${save_opportunity}
    #log to console    ${name_form}
    ${date_due}=    Get Date From Future    7
    page should contain element    //span[@class='uiOutputDate' and text()='${date_due}']
    page should contain element    //span[@class='test-id__field-value slds-form-element__static slds-grow ']/span[@class='uiOutputText' and text()='${unique_subject_task_form}']

Enter and Select Contact Meeting
    Set Test Variable    ${name_input}    ${AP_FIRST_NAME} ${AP_LAST_NAME}
    Scroll Page To Element    ${save_button_create}
    Force click element    ${contact_name_input}
    #click element    ${contact_name_input}
    input text    ${contact_name_input}    ${name_input}
    Wait Until Page Contains Element    //*[@title='${name_input}']/../..    60s
    Sleep    15s
    click element    //div[@title='${name_input}']/../..
    sleep    5s

Create a Meeting
    ${unique_subject_task}=    run keyword    Create Unique Task Subject
    Click Clear All Notifications
    click Meeting Link on Page
    Enter Mandatory Info on Meeting Form    ${unique_subject_task}
    Save Meeting and click on Suucess Message
    Search And Select the Entity    ${unique_subject_task}    ${EMPTY}
    Validate Created Meeting
    Modify Meeting Outcome
    Validate the Modified Outcome

Create Unique Task Subject
    ${random_string}    generate random string    8
    [Return]    Task-${random_string}

click Meeting Link on Page
    click Element    ${NEW_EVENT_LABEL}
    #Sleep    10s
    Wait Until Page Contains element    xpath=${SUBJECT_INPUT}    100s

Enter Mandatory Info on Meeting Form
    [Arguments]    ${task_subject}
    sleep    5s
    input text    xpath=${SUBJECT_INPUT}    ${task_subject}
    sleep    5s
    click element    xpath=${EVENT_TYPE}
    Click Visible Element   xpath=${meeting_select_dropdown}
    sleep    5s
    Select option from Dropdown with Force Click Element    ${reason_select_dropdown}    ${reason_select_dropdown_value}
    #click element    xpath=${reason_select_dropdown}
    #click element    xpath=${reason_select_dropdown_value}
    Enter Meeting Start and End Date
    sleep    5s
    Input Text    ${city_input}    ${DEFAULT_CITY}
    sleep    5s
    Enter and Select Contact Meeting
    sleep    10s

Enter Meeting Start and End Date
    ${date}=    Get Date From Future    1
    Set Test Variable    ${meeting_start_DATE}    ${date}
    #log to console    ${meeting_start_DATE}
    Clear Element Text   ${meeting_start_date_input}
    sleep  3s
    Input Text    ${meeting_start_date_input}    ${meeting_start_DATE}
    Click Element     ${meeting_start_time_input}
    clear element text    ${meeting_start_time_input}
    input text    ${meeting_start_time_input}    ${meeting_start_time}
    ${date}=    Get Date From Future    2
    Set Test Variable    ${meeting_end_DATE}    ${date}
    Input Text    ${meeting_end_date_input}    ${meeting_end_DATE}
    Click Element    ${meeting_end_time_input}
    sleep  3s
    clear element text    ${meeting_end_time_input}
    input text    ${meeting_end_time_input}    ${meeting_end_time}

Save Meeting and click on Suucess Message
    #click element    ${save_button_create}
    Force click element    ${save_button_create}
    sleep    30s
    #click element    ${success_message_anchor}
    click visible element  ${success_message_anchor}
    sleep    10s

Validate Created Meeting
    sleep    10s
    ${date}=    Get Date From Future    1
    Set Test Variable    ${meeting_start_DATE}    ${date}
    ${date}=    Get Date From Future    2
    Set Test Variable    ${meeting_end_DATE}    ${date}
    ${start_date_form}    get text    xpath=${start_date_form_span}
    ${end_date_from}    get text    xpath=${end_date_form_span}
    ${location_form}    get text    xpath=${location_form_span}
    # log to console    ${location_form}.this is form data
    #log to console    ${DEFAULT_CITY}.this is inputdata from variables
    should be equal as strings    ${location_form}    ${DEFAULT_CITY}
    #log to console    ${start_date_form}.this is form start date
    #log to console    ${meeting_start_DATE} ${meeting_start time}.this user entered start date
    should be equal as strings    ${start_date_form}    ${meeting_start_DATE} ${meeting_start time}
    should be equal as strings    ${end_date_from}    ${meeting_end_DATE} ${meeting_end_time}

Modify Meeting Outcome
    Click element    //div[@title='Edit']/..
    wait until page contains element    //*[contains(text(),'Edit Task')]    30s
    Sleep    5s
    Select Quick Action Value For Attribute    Meeting Outcome    Positive
    Sleep    5s
    Select Quick Action Value For Attribute    Meeting Status    Done
    input text    xpath=${description_textarea}    ${name_input}.Edited.${Meeting}
    click element    ${save_button_editform}
    sleep    20s

Validate the Modified Outcome
    #${description_form}    get text    ${description_span}
    #should be equal as strings    ${name_input}.Edited.${Meeting}    ${description_form}
    ${meeting_outcome_form}    get text    ${meeting_outocme_span}
    should be equal as strings    ${meeting_outcome_form}    Positive

Create a Call
    ${unique_subject_task}=    run keyword    Create Unique Task Subject
    Click Clear All Notifications
    click Meeting Link on Page
    Enter Mandatory Info on Call Form    ${unique_subject_task}
    Save Meeting and click on Suucess Message
    Search And Select the Entity    ${unique_subject_task}    ${EMPTY}
    Validate Created Meeting
    Modify Meeting Outcome
    Validate the Modified Outcome

Enter Mandatory Info on Call Form
    [Arguments]    ${task_subject}
    sleep    10s
    input text    xpath=${SUBJECT_INPUT}    ${task_subject}
    click element    xpath=${EVENT_TYPE}
    click element    xpath=${subject_call_type}
    select option from dropdown with force click element    ${reason_select_dropdown}    ${reason_select_dropdown_value}
    #click element    xpath=${reason_select_dropdown}
    #click element    xpath=${reason_select_dropdown_value}
    Enter Meeting Start and End Date
    Sleep    10s
    input text    ${city_input}    ${DEFAULT_CITY}
    sleep    10s
    Enter and Select Contact Meeting
    sleep    10s

Verify That Business Account Attributes Are Named Right
    Verify That Record Contains Attribute    Account ID
    Verify That Record Contains Attribute    Account Record Type
    Verify That Record Contains Attribute    Account Owner
    Verify That Record Contains Attribute    Business ID
    Verify That Record Contains Attribute    Account Name
    Verify That Record Contains Attribute    Telia Customer ID
    Verify That Record Contains Attribute    Marketing Name
    Verify That Record Contains Attribute    AIDA ID
    Verify That Record Contains Attribute    Phone
    Verify That Record Contains Attribute    VAT Code
    Verify That Record Contains Attribute    Website
    Verify That Record Contains Attribute    Registered Association ID
    Verify That Record Contains Attribute    Contact Preferences
    Verify That Record Contains Attribute    Group Name
    Verify That Record Contains Attribute    Next Opportunity Due
    Verify That Record Contains Attribute    Group ID
    Verify That Record Contains Attribute    Opportunities Open
    Verify That Record Contains Attribute    Parent Account
    Verify That Record Contains Attribute    Last Contacted Date
    Verify That Record Contains Attribute    Days Uncontacted
    Verify That Record Contains Attribute    Marketing Restriction
    Verify That Record Contains Attribute    Company Form
    Verify That Record Contains Attribute    Legal Status
    Verify That Record Contains Attribute    Tax Activity
    Verify That Record Contains Attribute    Status Reason
    Verify That Record Contains Attribute    Bankruptcy Process Status
    Verify That Record Contains Attribute    Business Segment
    Verify That Record Contains Attribute    Street Address
    Verify That Record Contains Attribute    Postal Code
    Verify That Record Contains Attribute    City
    Verify That Record Contains Attribute    Country
    Verify That Record Contains Attribute    Main Mailing Address
    Verify That Record Contains Attribute    Visiting Address
    Verify That Record Contains Attribute    Multibella System ID
    Verify That Record Contains Attribute    Billing System ID
    Verify That Record Contains Attribute    AccountNumber
    Verify That Record Contains Attribute    BS ID

Verify That Record Contains Attribute
    [Arguments]    ${attribute}
    Wait Until Page Contains Element    //span[contains(@class,'test-id__field-label') and (text()='${attribute}')]    240s    10s

Create New Master Contact With All Details
    ${first_name}=    Run Keyword    Create Unique Name    ${EMPTY}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${mobile_num}=    Set Variable    +358968372101
    Set Test Variable    ${MASTER_FIRST_NAME}    Mas ${first_name}
    Sleep    3s
    Set Test Variable    ${MASTER_LAST_NAME}    Test ${first_name}
    Set Test Variable    ${MASTER_PRIMARY_EMAIL}    ${email_id}
    Set Test Variable    ${MASTER_MOBILE_NUM}    ${mobile_num}
    Click Visible Element    ${NEW_BUTTON}
    Click Visible Element    ${MASTER}
    click Element    ${NEXT}
    Wait Until Element is Visible    ${CONTACT_INFO}    10s
    sleep    5s
    Input Text    ${MASTER_MOBILE_NUM_FIELD}    ${MASTER_PHONE_NUM}
    Input Text    ${FIRST_NAME_FIELD}    ${MASTER_FIRST_NAME}
    Input Text    ${LAST_NAME_FIELD}    ${MASTER_LAST_NAME}
    Input Text    ${MASTER_PHONE_NUM_FIELD}    ${MASTER_PHONE_NUM}
    Input Text    ${MASTER_PRIMARY_EMAIL_FIELD}    ${MASTER_PRIMARY_EMAIL}
    Input Text    ${EMAIL_ID_FIELD}    ${MASTER_PRIMARY_EMAIL}
    Select from search List   ${ACCOUNT_NAME_FIELD}    ${MASTER_ACCOUNT_NAME}
    Input Text    ${BUSINESS_CARD_FIELD}    ${BUSINESS_CARD}
    Select option from Dropdown with Force Click Element    ${STATUS}    ${STATUS_ACTIVE}
    Select option from Dropdown with Force Click Element    ${PREFERRED_CONTACT_CHANNEL}    ${PREFERRED_CONTACT_CHANNEL_LETTER}
    Select option from Dropdown with Force Click Element    ${GENDER}    ${GENDER_MALE}
    Select option from Dropdown with Force Click Element    ${COMMUNICATION_LANGUAGE}    ${COMMUNICATION_LANG_ENGLISH}
    Select Date From DATEPICKER    ${DATE_PICKER}
    ${last_contact_date}    Get Text    ${LAST_CONTACTED_DATE}
    Set Test Variable    ${contacted_date_text}    ${last contact_date}
    Select option from Dropdown with Force Click Element    ${SALES_ROLE}    ${SALES_ROLE_BUSINESS_CONTACT}
    Select option from Dropdown with Force Click Element    ${JOB_TITLE_CODE}    ${JOB_TITLE_CODE_NAME}
    Input Text    ${OFFICE_NAME_FIELD}    ${OFFICE_NAME}
    Click Element    ${SAVE_BUTTON}
    Sleep    10s

Validate Master Contact Details In Contact Page
    [Arguments]    ${element}
    ${contact_name}=    Set Variable    //span[text()='Name']//following::span//span[text()='${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}']
    ${business_card_text}=    Set Variable    //span[text()='Business Card Title']//following::span//span[text()='${BUSINESS_CARD}']
    ${gender_selection}=    Set Variable    //span[text()='Gender']//following::span//span[text()='${gender}']
    ${account_name}=    Set Variable    //span[text()='Account Name']//following::a[text()='${MASTER_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']//following::span//span[text()='${MASTER_MOBILE_NUM}']
    ${phone_number}=    Set Variable    //span[text()='Phone']//following::span//span[text()='${MASTER_PHONE_NUM}']
    ${primary_email}=    Set Variable    //span[text()='Primary eMail']//following::a[text()='${MASTER_PRIMARY_EMAIL}']
    ${email}=    Set Variable    //span[text()='Email']//following::a[text()='${MASTER_PRIMARY_EMAIL}']
    ${status}=    Set Variable    //span[text()='Status']//following::span//span[text()='${STATUS_TEXT}']
    ${preferred_contact}=    Set Variable    //span[text()='Preferred Contact Channel']//following::span//span[text()='${PREFERRED_CONTACT}']
    ${comm_lang}=    Set Variable    //span[text()='Communication Language']//following::span//span[text()='${COMMUNICATION_LANG}']
    ${birth_date}=    Set Variable    //span[text()='Birthdate']//following::span//span[text()='${day}.${month_digit}.${year}']
    ${last_contact_date}=    Set Variable    //span[text()='Last Contacted Date']//following::span//span[text()='${contacted_date_text}']
    ${sales_role}=    Set Variable    //span[text()='Sales Role']//following::span//span[text()='${sales_role_text}']
    ${job_title}=    Set Variable    //span[text()='Job Title Code']//following::span//span[text()='${job_title_text}']
    ${office_name_text}=    Set Variable    //span[text()='Office Name']//following::span//span[text()='${OFFICE_NAME}']
    Go to Entity    ${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}
    Sleep    5s
    Click Visible element    ${DETAILS_TAB}
    Sleep    5s
    Validate Contact Details In Contact Page    ${element}    ${contact_name}    ${account_name}    ${mobile_number}    ${primary_email}    ${email}
    ...    ${status}    ${preferred_contact}    ${comm_lang}    ${birth_date}    ${last_contact_date}    ${sales_role}
    ...    ${job_title}    ${office_name_text}
    #Wait Until Page Contains Element    ${element}${phone_number}
    #Wait Until Page Contains Element    ${element}${email}

Select Date From DATEPICKER
    [Arguments]    ${dateElement}
    ${select_year}=    Set Variable    //option[text()='${year}']
    ${element_xpath}=    Replace String    ${dateElement}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    : FOR    ${INDEX}    IN RANGE    1    12
    \    sleep    2s
    \    ${month}=    Get Text    ${MONTH_TEXT}
    \    Run Keyword If    "${month}" != "${to_select_month}"    click element    ${NEXT_BUTTON_MONTH}
    \    Exit For Loop If    "${month}" == "${to_select_month}"
    click element    ${YEAR_DROPDOWN}
    sleep    2s
    wait until element is visible    ${select_year}
    click element    ${select_year}
    Pick Date

Pick Date
    ${select_day}=    Set Variable    //span[@data-aura-class='uiDayInMonthCell--default' and text()='${day}']
    click element    ${select_day}

Validate Contact Details In Contact Page
    [Arguments]    ${element}    ${contact_name}    ${account_name}    ${mobile_number}    ${primary_email}    ${email}
    ...    ${status}    ${preferred_contact}    ${comm_lang}    ${birth_date}    ${last_contact_date}    ${sales_role}
    ...    ${job_title}    ${office_name_text}
    Wait Until Page Contains Element    ${element}${contact_name}    240s
    Wait Until Page Contains Element    ${element}${account_name}    240s
    Wait Until Page Contains Element    ${element}${mobile_number}    240s
    Wait Until Page Contains Element    ${element}${primary_email}    240s
    Wait Until Page Contains Element    ${element}${email}    240s
    Wait Until Page Contains Element    ${element}${status}    240s
    Wait Until Page Contains Element    ${element}${preferred_contact}    240s
    Wait Until Page Contains Element    ${element}${comm_lang}    240s
    Wait Until Page Contains Element    ${element}${birth_date}    240s
    Wait Until Page Contains Element    ${element}${last_contact_date}    240s
    Wait Until Page Contains Element    ${element}${sales_role}    240s
    Wait Until Page Contains Element    ${element}${job_title}    240s
    Wait Until Page Contains Element    ${element}${office_name_text}    240s

Validate That Contact Person Attributes Are Named Right
    ${business_card_title}=    Set Variable    //button[@title='Edit Business Card Title']/../..//span[text()='Business Card Title']
    ${name}=    Set Variable    //span[@class='uiOutputText']/../../..//span[text()='Name']
    ${contact_ID}=    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//*[text()='Contact ID']
    ${account_name}=    Set Variable    //button[@title='Edit Account Name']/../..//span[text()='Account Name']
    ${mobile_number}=    Set Variable    //button[@title='Edit Mobile']/../..//span[text()='Mobile']
    ${phone_number}=    Set Variable    //button[@title='Edit Phone']/../..//span[text()='Phone']
    ${primary_email}=    Set Variable    //button[@title='Edit Primary eMail']/../..//span[text()='Primary eMail']
    ${email}=    Set Variable    //button[@title='Edit Email']/../..//span[text()='Email']
    ${status}=    Set Variable    //button[@title='Edit Status']/../..//span[text()='Status']
    ${preferred_contact_title}=    Set Variable    //button[@title='Edit Preferred Contact Channel']/../..//span[text()='Preferred Contact Channel']
    ${comm_lang}=    Set Variable    //button[@title='Edit Communication Language']/../..//span[text()='Communication Language']
    ${birth_date}=    Set Variable    //button[@title='Edit Birthdate']/../..//span[text()='Birthdate']
    ${sales_role}=    Set Variable    //button[@title='Edit Sales Role']/../..//span[text()='Sales Role']
    ${office_name_text}=    Set Variable    //button[@title='Edit Office Name']/../..//span[text()='Office Name']
    ${gender_text}=    Set Variable    //button[@title='Edit Gender']/../..//span[text()='Gender']
    ${Address}=    Set Variable    //div[contains(@class,'windowViewMode-normal')]//div[contains(@class,'test-id__section slds-section')]//span[text()='Address']
    ${External_address}=    Set Variable    //div[contains(@class,'windowViewMode-normal')]//div[contains(@class,'test-id__section slds-section')]//span[text()='External Address']
    ${3rd_Party_Contact}=    Set Variable    //button[@title='Edit 3rd Party Contact']/../..//span[text()='3rd Party Contact']
    ${external_phone}=    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//section[@class='tabs__content active uiTab']//div[contains(@class,'test-id__section slds-section')]//button[@title='Edit Phone']//parent::div/../../../../div/div/div/div/span[text()='External Phone']
    Wait Until Page Contains Element    ${business_card_title}    240s
    Wait Until Page Contains Element    ${name}    240s
    Wait Until Page Contains Element    ${contact_ID}    240s
    Wait Until Page Contains Element    ${account_name}    240s
    Wait Until Page Contains Element    ${mobile_number}    240s
    Wait Until Page Contains Element    ${phone_number}    240s
    Wait Until Page Contains Element    ${primary_email}    240s
    Wait Until Page Contains Element    ${email}    240s
    Wait Until Page Contains Element    ${status}    240s
    Scroll Page To Location    0    200
    Wait Until Page Contains Element    ${preferred_contact_title}    240s
    Wait Until Page Contains Element    ${comm_lang}    240s
    Wait Until Page Contains Element    ${birth_date}    240s
    Scroll Page To Location    0    500
    Wait Until Page Contains Element    ${sales_role}    240s
    Wait Until Page Contains Element    ${office_name_text}    240s
    Wait Until Page Contains Element    ${gender_text}    240s
    Wait Until Page Contains Element    ${Address}    240s
    Wait Until Page Contains Element    ${External_address}    240s
    Wait Until Page Contains Element    ${3rd_Party_Contact}    240s
    Wait Until Page Contains Element    ${external_phone}    240s

Go To Accounts
    ${element_xpath}=    Replace String    ${ACCOUNTS_LINK}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep    2s
    #Click on Account Name
    #    sleep    5s
    ## Log To Console    Count:${count}
    #click element    ${ACCOUNT_NAME}[1]

Force click element
    [Arguments]    ${elementToClick}
    ${element_xpath}=    Replace String    ${elementToClick}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep    2s

Select option from Dropdown with Force Click Element
    [Arguments]    ${list}    ${item}
    #Select From List By Value    //div[@class="uiInput uiInput--default"]//a[@class="select"]    ${item}
    ${element_xpath}=    Replace String    ${list}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep    2s
    force click element    ${item}

Click Clear All Notifications
    ${notifi_present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//*[text()='Clear All']/..
    Run Keyword If    ${notifi_present}    Clear Notifications
    ${present}=    Run Keyword And Return Status    Element Should Be Visible    ${CLOSE_NOTIFICATION}
    Run Keyword If    ${present}    Close All Notifications

Clear Notifications
    click element    xpath=//*[text()='Clear All']/..

Close All Notifications
    @{locators}=    Get Webelements    xpath=${CLOSE_NOTIFICATION}
    ${original}=    Create List
    : FOR    ${locator}    IN    @{locators}
    \    Run Keyword and Ignore Error    Close Notification

Close Notification
    ${visible}=    run keyword and return status    element should be visible    ${CLOSE_NOTIFICATION}
    run keyword if    ${visible}    Click Element    xpath=${CLOSE_NOTIFICATION}

Change to original owner
    [Documentation]    We are changing the account owner to Sales Admin in case the account owner is GESB Integration
    #Change account owner to  ${ACCOUNT_OWNER}
     Wait Until Element Is Visible    //*[@data-key="change_owner"]  30s
     Click element   //*[@data-key="change_owner"]
     sleep    8s
     Element Should Be Enabled    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]
     Wait Until Page Contains Element    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]    60s
    #Input Text    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]   ${ACCOUNT_OWNER}
     Select from Autopopulate List    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]   ${ACCOUNT_OWNER}
     Click Element   //*[text()="Change Account Owner"]//following::span[text()="Change Owner"]
     : FOR    ${i}    IN RANGE    10
     \   ${new_owner}=   Get Text    ${ownername}
     \   ${status}=    Run Keyword And Return Status    Should Be Equal As Strings  ${REMOVE_ACCOUNT}   ${new_owner}
     \   Run Keyword If   ${status} == False      reload page
     \   Wait Until Page Contains Element   ${ownername}   120s
     \   Exit For Loop If    ${status}
     log to console   ${new_owner}
     sleep  120s


Remove change account owner
    ${ACCOUNT_OWNER}    Get Text    ${ownername}
    ${status}=    Run Keyword And Return Status    Should Not Be Equal As Strings    ${ACCOUNT_OWNER}    ${REMOVE_ACCOUNT}
    Run Keyword If    ${status} == False    Change to original owner
    Wait Until Element Is Visible   //button[@title='Change Owner']//*[@class="slds-button__icon"]  10s
    click element     //div[@class="slds-form-element__control slds-grid itemBody"]//button[@title='Change Owner']
    sleep   8s
    Element Should Be Enabled     //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]
    Wait Until Page Contains Element    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]    60s
    Input Text    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]   ${REMOVE_ACCOUNT}
    Select from Autopopulate List    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]   ${REMOVE_ACCOUNT}
    sleep  30s
    Click Element   //*[text()="Change Account Owner"]//following::span[text()="Change Owner"]
    : FOR    ${i}    IN RANGE    10
    \   ${new_owner}=    Get Text    ${ownername}
    \   ${status}=    Run Keyword And Return Status    Should Be Equal As Strings  ${REMOVE_ACCOUNT}   ${new_owner}
    \   Run Keyword If   ${status} == False      reload page
    \   Wait Until Page Contains Element   ${ownername}   120s
    \   Exit For Loop If    ${status}
    Should Be Equal As Strings    ${REMOVE_ACCOUNT}    ${new_owner}
    Capture Page Screenshot


Check original account owner and change if necessary
    Wait Until Element Is Visible    //div[@class='ownerName']//a    30s
    ${account_owner}=    Get Text    //div[@class='ownerName']//a
    log to console    ${account_owner}
    ${user_is_already_owner}=    Run Keyword And Return Status    Should Be Equal As Strings    ${account_owner}    Maris Steinbergs
    Run Keyword If    ${user_is_already_owner}    Set Test Variable     ${NEW_OWNER}    B2B Lightning
    ...     ELSE    Set Test Variable   ${NEW_OWNER}    Maris Steinbergs
    Change account owner to     ${NEW_OWNER}

Validate that account owner was changed successfully
    [Documentation]     Validates that account owner change was successfull. Takes the name of the new owner as parameter.
    [Arguments]     ${validated_owner}
    Compare owner names  ${validated_owner}

Compare owner names
    [Arguments]     ${validated_owner}
    Wait until page contains element   //div[@class='ownerName']//a    30s
    ${new_owner}=       Get Text    //div[@class='ownerName']//a
    log to console      ${new_owner}
    Should Be Equal As Strings    ${validated_owner}    ${new_owner}

Validate that account owner has changed in Account Hierarchy
    [Documentation]     View account hierarchy and check that new owner is copied down in hierarchy
    Wait element to load and click  //button[@title='View Account Hierarchy']
    Wait element to load and click  //button[@title='Expand']
    Wait until page contains element    //table/tbody/tr[1]/td[4]/span[text()='${NEW_OWNER}']   30s
    Wait until page contains element    //table/tbody/tr[2]/td[4]/span[text()='${NEW_OWNER}']   30s
    Wait until page contains element    //table/tbody/tr[3]/td[4]/span[text()='${NEW_OWNER}']   30s

Change Account Owner
    ${CurrentOwnerName}=    Get Text    ${OWNER_NAME}
    Click Element    ${CHANGE_OWNER}
    Wait until Page Contains Element    ${SEARCH_OWNER}    240s
    Sleep    10s
    #Click Element    ${SEARCH_OWNER}
    #sleep    5s
    #Clear Element Text    ${SEARCH_OWNER}
    ${NewOwner}=    set variable if    '${CurrentOwnerName}'== 'Sales Admin'    B2B DigiSales    Sales Admin
    Select from Autopopulate List    ${SEARCH_OWNER}     ${NewOwner}
    #Input Text    xpath=${SEARCH_OWNER}    ${NewOwner}
    #Sleep    2s
    #Press Enter On    ${SEARCH_OWNER}
    #Sleep    5s
    #Wait Until Page Contains element    //a[@title='${NewOwner}']    120s
    #Click Visible Element     //a[text()='${NewOwner}']
    #Wait Until Page Contains Element    ${NEW_OWNER_SELECTED}    10s
    #Select option from Dropdown with Force Click Element    ${SEARCH_OWNER}    //*[@title='${NewOwner}']
    Click Visible Element    ${CHANGE_OWNER_BUTTON}
    Sleep    20s
    : FOR    ${i}    IN RANGE    10
    \   ${NEW_OWNER_REFLECTED}=    Get Text    ${OWNER_NAME}
    \   ${status}=    Run Keyword And Return Status    Should Be Equal As Strings  ${NEW_OWNER_REFLECTED}    ${NewOwner}
    \   Run Keyword If   ${status} == False      reload page
    \   Wait Until Page Contains Element   ${OWNER_NAME}   120s
    \   Exit For Loop If    ${status}
    Should Be Equal As Strings    ${NEW_OWNER_REFLECTED}    ${NewOwner}    #${OWNER_OPTIONS}=    Set Variable    (//a[@role='option' and not(contains(., '${CurrentOwnerName}'))])    #${Count}=
    ...    # get element count    ${OWNER_OPTIONS}    #Log To Console    No of options available as new owner:${Count}    #${SELECT_NEW_OWNER}=    catenate
    ...    # ${OWNER_OPTIONS}    [1]    #Run Keyword If    ${Count}!=0    Click Element    ${SELECT_NEW_OWNER}
    ...    #...    # ELSE    Log to console    No Option available
    #    Wait Until Page Contains Element    ${NEW_OWNER_SELECTED}    10s
    #    ${NEW_OWNER_NAME}=    Get Text    ${NEW_OWNER_SELECTED}
    #    Log To Console    New Owner selected:${NEW_OWNER_NAME}
    #    click element    ${CHANGE_OWNER_BUTTON}
    #    sleep    15s
    #    ${NEW_OWNER_REFLECTED}=    Get Text    ${OWNER_NAME}
    #    Sleep    20s
    #    Should Be Equal As Strings    ${NEW_OWNER_REFLECTED}    ${NEW_OWNER_NAME}
    #    Log to Console    Owner changed for the account

Click on a given account
    [Arguments]    ${acc_name}
    sleep    5s
    ${present}=    Run Keyword And Return Status    Element Should Be Visible    //th[@scope='row' and contains(@class,'slds-cell-edit')]//a[@title='${acc_name}']
    Run Keyword If    ${present}    Click specific element    //th[@scope='row' and contains(@class,'slds-cell-edit')]//a[@title='${acc_name}']
    ...    ELSE    Log To Console    No account name available    #${count}=    Get Element Count    ${ACCOUNT_NAME}
    ...    #${elementUsed}=    Set Variable    //th[@scope='row' and contains(@class,'slds-cell-edit')]//a[@title='${acc_name}']    #Run Keyword if    ${count}!=0    click element
    ...    # ${elementUsed}    #...    # ELSE    Log To Console    No account name available
    sleep    10s

Click specific element
    [Arguments]    ${element}
    @{locators}=    Get Webelements    xpath=${element}
    ${original}=    Create List
    : FOR    ${locator}    IN    @{locators}
    Click Element    xpath=${element}

Click on Account Name
    sleep    5s
    ${count}=    Get Element Count    ${ACCOUNT_NAME}
    ${elementUsed}=    Catenate    ${ACCOUNT_NAME}    [1]
    Run Keyword if    ${count}!=0    click element    ${elementUsed}
    ...    ELSE    Log To Console    No account name available
    sleep    10s
    ####HDC Keywords Sreeram
    #################################################################################the below keywords are for hdc on jan 11 and after recent pulling

CreateAContactFromAccount_HDC
    log to console    this is to create a account from contact for HDC flow
    ${a}    create unique name    Contact_
    force click element    //li/a/div[text()='New Contact']
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='firstName compoundBorderBottom form-element__row input']    60s
    #click element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='form-element__group ']/div[@class='uiInput uiInputSelect forceInputPicklist uiInput--default uiInput--select']/div/div/div/div/a
    #sleep    3s
    #set focus to element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='firstName compoundBorderBottom form-element__row input']
    clear element text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='firstName compoundBorderBottom form-element__row input']
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='firstName compoundBorderBottom form-element__row input']    Testing
    #sleep    5s
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='lastName compoundBLRadius compoundBRRadius form-element__row input']    30s
    clear element text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='lastName compoundBLRadius compoundBRRadius form-element__row input']
    #set focus to element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='lastName compoundBLRadius compoundBRRadius form-element__row input']
    force click element    //Span[text()='Name']//following::input[@placeholder="Last Name"]
    input text    //Span[text()='Name']//following::input[@placeholder="Last Name"]    ${a}
    sleep    2s
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Primary eMail']//following::input[1]    30s
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Primary eMail']//following::input[1]    kasibhotla.sreeramachandramurthy@teliacompany.com
    Sleep  10s
    clear element text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]  30s
    input text   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]       kasibhotla.sreeramachandramurthy@teliacompany.com
    sleep    5s
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='modal-footer slds-modal__footer']/button/span[text()='Save']    30s
    force click element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='modal-footer slds-modal__footer']/button/span[text()='Save']
    ${IsErrorVisible}=    Run Keyword And Return Status    element should be visible    //span[text()='Review the errors on this page.']
    Sleep  30s
    log to console    ${IsErrorVisible}
    Run Keyword If    ${IsErrorVisible}    reEnterContactData    ${a}
    [Return]    Testing ${a}

reEnterContactData
    [Arguments]    ${random_name}
    #set focus to element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='firstName compoundBorderBottom form-element__row input']
    clear element text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='firstName compoundBorderBottom form-element__row input']
    force click element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='firstName compoundBorderBottom form-element__row input']
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='firstName compoundBorderBottom form-element__row input']    Testing
    sleep    5s
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='lastName compoundBLRadius compoundBRRadius form-element__row input']    30s
    clear element text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='lastName compoundBLRadius compoundBRRadius form-element__row input']
    #set focus to element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='lastName compoundBLRadius compoundBRRadius form-element__row input']
    force click element    //Span[text()='Name']//following::input[@placeholder="Last Name"]
    input text    //Span[text()='Name']//following::input[@placeholder="Last Name"]    ${random_name}
    sleep    2s
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Primary eMail']//following::input[1]    kasibhotla.sreeramachandramurthy@teliacompany.com
    sleep    2s
    clear element text   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]  30s
    input text   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]       kasibhotla.sreeramachandramurthy@teliacompany.com
    Sleep  2s
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='modal-footer slds-modal__footer']/button/span[text()='Save']    30s
    force click element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='modal-footer slds-modal__footer']/button/span[text()='Save']
    sleep    5s
    ${IsErrorVisible}=    Run Keyword And Return Status    element should be visible    //span[text()='Review the errors on this page.']
    Sleep  30s
    log to console    ${IsErrorVisible}
    Run Keyword If    ${IsErrorVisible}    reEnterContactData    ${random_name}
    #sleep    10s

CreateAOppoFromAccount_HDC
    [Arguments]    ${b}=${contact_name}
    log to console    this is to create a Oppo from contact for HDC flow.${b}.contact
    ${oppo_name}    create unique name    Test Robot Order_
    wait until page contains element    //li/a/div[text()='New Opportunity']    60s
    force click element    //li/a/div[text()='New Opportunity']
    sleep    30s
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[1]    40s
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[1]    ${oppo_name}
    sleep    3s
    ${close_date}    get date from future    10
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[2]    ${close_date}
    sleep    10s
    click element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[3]
    Capture Page Screenshot
    Select from search List   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[3]    ${b}
    #input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[3]    ${b}
    #wait until page contains element    //*[@title='${b}']/../../..    10s
    #press enter on  //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[3]
    #click element   //h2[contains(text(),"Contact Results")]//following::*[@title='Testing Contact_ 20190731-171453']/../../..
    #click element    //*[@title='${b}']/../../..
    sleep    2s
    input text    //textarea    ${oppo_name}.${close_date}.Description Testing
    click element    //button[@data-aura-class="uiButton"]/span[text()='Save']
    sleep    60s
    [Return]    ${oppo_name}

Edit Opportunity values
    [Arguments]    ${field}      ${value}
    ${fieldProperty}=    Set Variable        //button[@title='Edit ${field}']
    ${price_list_old}=     get text        //span[text()='Price List']//following::a
    Log to console          ${price_list_old}
    ${B2B_Price_list_delete_icon}=    Set Variable    //span[@class='pillText'][contains(text(),'${price_list_old}')]/following::span[@class='deleteIcon'][1]
    ScrollUntillFound       ${fieldProperty}
    click element       ${fieldProperty}
    Sleep       2s
    ${status}    Run Keyword And Return Status    element should be visible      ${B2B_Price_list_delete_icon}
    Run Keyword If    ${status} == True         click element           ${B2B_Price_list_delete_icon}
    sleep    3s
    input text    //input[contains(@title,'Search ${field}')]    ${value}
    sleep    3s
    click element    //*[@title='${value}']/../../..
    Sleep  10s
    click element    //span[text()='Products With Manual Pricing']//following::span[text()='Save']
    Sleep  10s

ChangeThePriceBookToHDC
    [Arguments]    ${price_book}
    ${B2B_Price_list_delete_icon}=    Set Variable    //span[@class='pillText'][contains(text(),'B2B Pricebook')]/following::span[@class='deleteIcon']
    log to console    this is to change the prioebook to HDCB2B
    sleep    30s
    #Execute JavaScript    window.scrollTo(0,600)
    #scroll page to element    //button[@title="Edit Price Book"]
    ScrollUntillFound    //button[@title="Edit Price Book"]
    click element    //button[@title="Edit Price Book"]
    sleep    10s
    click element    ${B2B_Price_list_delete_icon}
    sleep    3s
    input text    //input[@title='Search Price Books']    ${price_book}
    sleep    3s
    click element    //*[@title='${price_book}']/../../..
    click element    //button[@title='Save']
    sleep    10s
    execute javascript    window.scrollTo(0,0)
    sleep    5s


Update Pricelist in Opportunity
    [Arguments]    ${price_lists}
    ${Price List}    set variable    //span[contains(text(),'Price List')]/../../button
    ${price_list_old}=     get text    //span[text()='Price List']//following::a
    ${B2B_Price_list_delete_icon}=    Set Variable    //span[@class='pillText'][contains(text(),'${price_list_old}')]/following::span[@class='deleteIcon'][1]
    ${edit pricelist}    Set Variable    //button[@title='Edit Price List']
    Log To Console    Change Price list
    ScrollUntillFound   ${edit pricelist}
    click element      ${edit pricelist}
    ScrollUntillFound   ${B2B_Price_list_delete_icon}
    Log to console  Delete Action element found
    #click element   ${B2B_Price_list_delete_icon}
    log to console    ${price_lists}
    ${elementToClick}=  set variable   //span[text()='${price_lists}']//following::a[1]
    ${element_xpath}=    Replace String    ${elementToClick}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep    2s
    Log to console  Clicked
    input text    //input[@title='Search Price Lists']    ${price_lists}
    sleep    3s
    click element    //*[@title='${price_lists}']/../../..
    click element    //button[@title='Save']

ClickingOnCPQ
    [Arguments]    ${b}=${oppo_name}
    ##clcking on CPQ
    log to console    ClickingOnCPQ
    Wait until keyword succeeds     30s     5s      click element    xpath=//a[@title='CPQ']
    #wait until page contains element    xpath=//h1[text()='${b}']    30s
    sleep    40s

validateCreatedOppoForFYR
    [Arguments]    ${fyr_value_oppo}= ${fyr_value}
    wait until page contains element    //span[@title='Revenue Total']/../div[@class='slds-form-element__control']/Div/span[text()='${fyr_value_oppo},00 €']    60s
    page should contain element    //span[@title='Revenue Total']/../div[@class='slds-form-element__control']/Div/span[text()='${fyr_value_oppo},00 €']
    page should contain element    //span[@title='FYR Total']/../div[@class='slds-form-element__control']/Div/span[text()='${fyr_value_oppo},00 €']
    ScrollUntillFound    //span[text()='Revenue Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span
    sleep    5s
    page should contain element    //span[text()='Revenue Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span[normalize-space(.)='${fyr_value_oppo},00 €']
    page should contain element    //span[text()='FYR Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span[normalize-space(.)='${fyr_value_oppo},00 €']
    ${monthly_charge_total}=    evaluate    (${RC}*${product_quantity})
    #${mrc_form}=    get text    //span[@title='Revenue Total']/../div[@class='slds-form-element__control']/div/span
    #should be equal as strings    ${monthly_charge_total}    ${mrc_form}
    page should contain element    //span[text()='Monthly Charge Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span[normalize-space(.)='${monthly_charge_total},00 €']
    ${one_time_total}=    evaluate    (${NRC}*${product_quantity})
    #${nrc_form}=    get text    //span[@title='FYR Total']/../div[@class='slds-form-element__control']/div/span
    #should be equal as strings    ${one_time_total}    ${nrc_form}
    page should contain element    //span[text()='One Time Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span[normalize-space(.)='${one_time_total},00 €']
    click element    //span[text()='Related']
    sleep    5s
    log to console    related clicked
    ScrollUntillFound    //a[text()='${product_name}']
    page should contain element    //a[text()='${product_name}']
    page should contain element    //span[text()='New Money - New Services']
    page should contain element    //span[text()='New Money - New Services']/..//following-sibling::td/span[text()='${product_quantity},00']

AddProductToCart
    [Arguments]   ${pname}=${product_name}
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    sleep   5s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    wait until page contains element  //div[@class='cpq-item-product']/div[@class='cpq-item-base-product']//following::div[@class='cpq-item-no-children']/span[normalize-space(.)='${pname}']   60s
    scrolluntillfound  //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    validateThePricesInTheCart   ${pname}
    click element   //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    unselect frame
    sleep  60s

validateThePricesInTheCart
    [Arguments]    ${product}
    #${OTC} =  get text  //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,"product-title")]//following::div[contains(@class,"currency-value")][2]/div/div/span/span
    #${RC} =   get text   //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,"product-title")]//following::div[contains(@class,"currency-value")][1]/div/div/span/span
    wait until page contains element    //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,'base-product')]//div[3]//span[@class='cpq-underline']       45s
    ${rc}=  get text  //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,'base-product')]//div[3]//span[@class='cpq-underline']
    ${nrc}=  get text  //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,'base-product')]//div[4]//span[@class='cpq-underline']
    page should contain element  //div[normalize-space(.)='Recurring Total']/..//div[@class='slds-text-heading--medium'][normalize-space(.)='${rc}']
    page should contain element  //div[normalize-space(.)='OneTime Total']/..//div[@class='slds-text-heading--medium'][normalize-space(.)='${nrc}']
    #log to console  ${OTC}.this is OTC--${RC}.this is RC


AddingProductToCartAndClickNextButton
    [Arguments]    ${product}
    ##enter searcing product and click on add to cart and click on next button
    wait until page contains element    //div[@data-product-id='01u58000005pgZ8AAI']/div/div/div/div/div/button    60s    #xpath=//p[normalize-space(.) = '${product}']/../../../div[@class='slds-tile__detail']/div/div/button
    sleep    10s
    click element    //div[@data-product-id='01u58000005pgZ8AAI']/div/div/div/div/div/button
    Capture Page Screenshot

UpdateAndAddSalesType
    [Arguments]    ${products}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_list}=    Set Variable    //td[normalize-space(.)='${products}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    log to console    UpdateAndAddSalesType
    sleep    30s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    wait until page contains element    ${update_order}    60s
    log to console    selected new frame
    wait until page contains element    ${product_list}    70s
    click element    ${product_list} //following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_list}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    click element    ${next_button}
    unselect frame
    sleep    60s

UpdateAndAddSalesTypeB2O
    [Arguments]    ${pname}=${product_name}
    ${spinner}    Set Variable    //div[@class='center-block spinner']
    ${status}=    Run Keyword And Return Status    wait until page contains element    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    log to console    UpdateAndAddSalesTypeB2O
    run keyword if    ${status} == False    Reload Page
    wait until page contains element    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Wait Until Element Is Not Visible    ${spinner}    60s
    #wait until page contains element    xpath=//h1[normalize-space(.) = 'Update Products']    60s
    sleep    10s
    wait until page contains element    xpath=//td[normalize-space(.)='${pname}']    70s
    click element    xpath=//td[normalize-space(.)='${pname}']//following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    xpath=//td[normalize-space(.)='${pname}']//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    Wait Until Element Is Visible    xpath=//button[normalize-space(.)='Next']    60s
    click element    xpath=//button[normalize-space(.)='Next']
    unselect frame
    sleep    60s


View Open Quote

    ${open_quote}=    Set Variable    //button[@id='Open Quote']    #//button[@id='Open Quote']
    ${view_quote}    Set Variable    //button[@id='View Quote']
    ${quote}    Set Variable    //button[contains(@id,'Quote')]
    ${central_spinner}    Set Variable    //div[@class='center-block spinner']
    wait until element is not visible    ${central_spinner}    120s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    log to console    selected Create Quotation frame
    Wait Until Element Is Visible    ${quote}    120s
    ${quote_text}    get text    ${quote}
    ${open}    Run Keyword And Return Status    Should Be Equal As Strings    ${quote_text}    Open Quote
    ${view}    Run Keyword And Return Status    Should Be Equal As Strings    ${quote_text}    View Quote
    Run Keyword If    ${open} == True    click element    ${open_quote}
    Run Keyword If    ${view} == True    click element    ${view_quote}
    unselect frame
    sleep    20s



OpenQuoteButtonPage
    #${open_quote}=    Set Variable    //*[@id="View Quote"]
    #${approval}=    Set variable    //div[@class='vlc-validation-warning ng-scope']/small[contains(text(),'Quote')]
    #Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    log to console    selected final page frame
    #${button_present}=    run keyword and return status    element should be visible    //*[@id="View Quote"]
    #run keyword if    ${button_present}=='True'    force click element    ${button_present}
    #log to console    ${button_present}
    #${open_button_present}=    run keyword and return status    element should be visible    //*[@id="Open Quote"]
    #log to console    ${open_button_present}
    #run keyword if    ${button_present}=='True'    force click element    ${open_button_present}
    #click element    //*[@id="Open Quote"]
    #wait until page contains element    //*[@id="View Quote"]    60s
    #log to console    wait completed before open quote click
    #wait until element is visible    //*[@id="View Quote"]    30s
    #wait until element is enabled    //*[@id="View Quote"]    20s
    #log to console    element visible next step
    #click element    //*[@id="View Quote"]
    scrolluntillfound    //*[@id="Open Quote"]
    sleep    2s
    click element    //*[@id="Open Quote"]
    unselect frame
    sleep    20s

CreditScoreApproving
    ${details}=    set variable    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    ${edit_approval}=    Set Variable    //button[@title='Edit Approval Status']
    sleep    30s
    log to console    CreditScoreApproving
    #credit score approval and go to home page again
    click element    ${details}
    #wait until page contains element    //span[@class='test-id__field-label' and text()='Quote Number']    10s
    sleep    20s
    ScrollUntillFound    ${edit_approval}
    Execute Javascript    window.location.reload(true)
    sleep    40s
    click element    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    sleep    10s
    ScrollUntillFound    ${edit_approval}
    #scroll page to element    //button[@title='Edit Approval Status']
    #sleep    10s
    #Execute JavaScript    window.scrollTo(0, 1300)
    #Execute Javascript    window.location.reload(true)
    sleep    20s
    wait until page contains element    //button[@title='Edit Approval Status']    45s
    click element    //button[@title='Edit Approval Status']
    sleep    20s
    wait until page contains element    //div[@class='uiMenu']/div[@class='uiPopupTrigger']/div/div/a[text()='Not Approved'][1]    45s
    wait until element is enabled    //div[@class='uiMenu']/div[@class='uiPopupTrigger']/div/div/a[text()='Not Approved'][1]    45s
    Set Focus To Element    //div[@class='uiMenu']/div[@class='uiPopupTrigger']/div/div/a[text()='Not Approved'][1]
    capture page screenshot
    force click element    //div[@class='uiMenu']/div[@class='uiPopupTrigger']/div/div/a[text()='Not Approved'][1]
    Execute Javascript    window.location.reload(true)
    sleep    50s
    click element    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    sleep    10s
    ScrollUntillFound    //button[@title='Edit Approval Status']
    #Execute JavaScript    window.scrollTo(0,1900)
    sleep    50s
    click element    //button[@title='Edit Approval Status']
    sleep    10s
    click element    //div[@class='uiMenu']/div[@class='uiPopupTrigger']/div/div/a[text()='Not Approved'][1]
    sleep    5s
    force click element    //a[@title='Approved']
    sleep    2s
    #//div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved'][1]
    sleep    50s
    #Execute Javascript    window.location.reload(true)
    #sleep    40s
    #click element    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    #sleep    5s
    #Execute JavaScript    window.scrollTo(0,2000)
    #sleep    10s
    #    click element    //button[@title='Edit Approval Status']
    #    sleep    5s
    #    wait until page contains element    //div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved']    30s
    #    wait until element is enabled    //div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved']    30s
    #    Set Focus To Element    //div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved']
    # force click element    //div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved']
    #double click element
    #wait until page contains element    //div[@class='uiPopupTrigger']/div/div/a[@class='select' and @role='button'and text()='Not Approved']/..    30s
    #wait until element is visible    //div[@class='uiPopupTrigger']/div/div/a[@class='select' and @role='button'and text()='Not Approved']/..    30s
    #wait until element is enabled    //div[@class='uiPopupTrigger']/div/div/a[@class='select' and @role='button'and text()='Not Approved']/..    20
    #Set Focus To Element    //a[@class='select' and @role='button'and text()='Not Approved']/..
    #force click element    //a[@class='select' and @role='button'and text()='Not Approved']/..
    #//div[@class='uiPopupTrigger']/div/div/a[@class='select' and @role='button'and text()='Not Approved']/..
    #Press key    ${TABLE_HEADER}[@title='${target_name}']    //13
    #Press Key    //a[@class='select' and @role='button'and text()='Not Approved']/..    //13
    #sleep    5s
    #force click element    //a[@title='Approved']
    sleep    2s
    click element    //button[@title='Save']
    sleep    20s
    Execute JavaScript    window.scrollTo(0,0)
    sleep    10s

ClickonCreateOrderButton
    log to console    ClickonCreateOrderButton
    #clicking on CPQ after credit score approval and click create order button this cpq not able to click so work on hold
    #click element    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    #sleep    10s
    wait until page contains element    //li/span[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']    30s
    #//a[@title='CPQ']    30s
    ##${expiry} =    get text    //*[text()='Expiration Date']
    ##log to console    ${expiry}
    force click element    //li/span[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']
    #//a[@title='CPQ']
    sleep    30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    Log to console      Inside frame
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Create Order']/..    Create Order
    Log to console      ${status}
    wait until page contains element    //span[text()='Create Order']/..    60s
    click element    //span[text()='Create Order']/..
    Sleep  30s
    unselect frame
    Sleep  60s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    Sleep  60s
    ${status}=  Run Keyword And Return Status  Element Should Be Visible    //p[text()="Order Products must have a unit price."]    100s
    Run Keyword If   ${status}   Order Products must have a unit price
    sleep    30s
    unselect frame
Order Products must have a unit price
    Sleep  30s
    wait until page contains element    //button[text()="Continue"]  60s
    click element   //button[text()="Continue"]
    Sleep  60s
    unselect frame
NextButtonOnOrderPage
    log to console    NextButtonOnOrderPage
    sleep  30s
    #click on the next button from the cart
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    Log to console      Inside frame
    sleep  30s
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    Log to console      ${status}
    wait until page contains element    //span[text()='Next']/..    60s
    click element    //span[text()='Next']/..
    unselect frame
    sleep    30s

OrderNextStepsPage
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    //*[contains(text(),'close this window')]    60s
    wait until page contains element    //*[@id="Close"]    60s
    click element    //*[@id="Close"]
    unselect frame
    sleep    45s

getOrderStatusBeforeSubmitting
    wait until page contains element    //span[@class='title' and text()='Details']    60s
    : FOR    ${i}    IN RANGE    10
    \   ${status}=    Run Keyword And Return Status   wait until page contains element  //span[@class='title' and text()='Details']    60s
    \   Run Keyword If   ${status} == False      reload page
    \   Exit For Loop If    ${status}
    click element    //span[text()="Processed"]//following::li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    #click element   //span[text()="Mark Status as Complete"]/following::span[@class='title' and text()='Details']
    #//li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    wait until page contains element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Status']/../following-sibling::div/span/span[text()='Draft']    60s
    wait until page contains element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Fulfilment Status']/../following-sibling::div/span/span[text()='Draft']    60s

clickOnSubmitOrder
    wait until page contains element  //a[@title='Submit Order']   60s
    click element  //a[@title='Submit Order']
    sleep   20s
    execute javascript   window.location.reload(true)
    sleep   20s

getOrderStatusAfterSubmitting
    wait until page contains element    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']   60s
    click element     //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    wait until page contains element  //span[text()='Fulfilment Status']/../following-sibling::div/span/span  60s
    ${fulfilment_status} =  get text  //span[text()='Fulfilment Status']/../following-sibling::div/span/span
    wait until page contains element    //span[text()='Status']/../following-sibling::div/span/span   60s
    ${status} =  get text  //span[text()='Status']/../following-sibling::div/span/span
    should not be equal as strings  ${fulfilment_status}  Error
    should not be equal as strings  ${status}  Error
    ${order_no}   get text   //div[contains(@class,'-flexi-truncate')]//following::span[text()='Order Number']/../following-sibling::div/span/span
    log to console  ${order_no}.this is getorderstatusafgtersubmirting function
    click element     //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Related']
    [Return]   ${order_no}

SearchAndSelectBillingAccount
    execute javascript    window.location.reload(true)
    sleep    60s
    log to console    SearchAndSelectBillingAccount
    #Selecting the billingAC FLow chart page
    #log to console    entering billingAC page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until element is visible    //*[@id="ExtractAccount"]    30s
    click element    //*[@id="ExtractAccount"]
    wait until element is visible    //label[normalize-space(.)='Select Account']    30s
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until element is visible    //div[text()='${vLocUpg_TEST_ACCOUNT}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']    30s
    force click element    //div[text()='${vLocUpg_TEST_ACCOUNT}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    sleep    2s
    click element    //*[@id="SearchAccount_nextBtn"]
    log to console    Exiting billingAC page
    unselect frame
    sleep    30s


select order contacts- HDC
    [Arguments]    ${d}= ${contact_technical}
    #${contact_search_title}=    Set Variable    //h3[text()='Contact Search']
    ${Technical_contact_search}=  set variable    //input[@id='TechnicalContactTA']
    ${contact_search}=    Set Variable    //input[@id='OrderContactTA']
    ${contact_next_button}=    Set Variable    //div[@id='SelectOrderLevelContacts_nextBtn']
    ${updateContactDR}=    Set Variable    //button[@class='slds-button slds-button--neutral ng-binding ng-scope'][@ng-click='nextRepeater(child.nextIndex, child.indexInParent)']
    #Wait Until Element Is Visible    ${contact_search_title}    120s
    #Reload page
    #sleep   15s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    log to console    entering Technical COntact page
    Wait Until Element Is Visible    ${contact_search}    120s
    Input Text    ${contact_search}   ${d}
    sleep    15s
    Wait until element is visible   css=.typeahead .ng-binding   30s
    Click element   css=.typeahead .ng-binding
    sleep   10s
    Wait until element is visible  //input[@id='OCEmail']   30s
    Input Text   //input[@id='OCEmail']   primaryemail@noemail.com
    #Wait until element is visible    xpath=//ng-form[@id='OrderContactTA-Block']/div/div/div/child/div/ng-form/div[2]/div/ul/li/a    30s
    #Click Element    xpath=//ng-form[@id='OrderContactTA-Block']/div/div/div/child/div/ng-form/div[2]/div/ul/li/a
    Sleep    5s
    Execute JavaScript    window.scrollTo(0,200)
    Wait Until element is visible   ${Technical_contact_search}     30s
    Input text   ${Technical_contact_search}  ${d}
    sleep  10s
    Wait until element is visible   css=.typeahead .ng-binding  30s
    Click element   css=.typeahead .ng-binding
    sleep  10s
    Wait until element is visible  //input[@id='TCEmail']   30s
    Input Text   //input[@id='TCEmail']   primaryemail@noemail.com
    Execute JavaScript    window.scrollTo(0,200)
    #Wait until element is visible       xpath=//ng-form[@id='TechnicalContactTA-Block']/div/div/div/child/div/ng-form/div[2]/div/ul/li/a    30s
    #click element   xpath=//ng-form[@id='TechnicalContactTA-Block']/div/div/div/child/div/ng-form/div[2]/div/ul/li/a
    sleep  10s
    #${order_name}    set variable    //input[@id='OrderContactDetailsTypeAhead']
    #${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${order_name}    5s
    #run keyword if    ${status} == True    update order details
    Click Element    ${contact_next_button}
    unselect frame
    sleep   10s

SelectingTechnicalContact
    [Arguments]    ${d}= ${contact_technical}
    log to console    Selecting the Techincal COntact FLow chart page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    log to console    entering Technical COntact    page
    wait until page contains element    //*[@id="ContactName"]    30s
    #execute javascript    window.location.reload(true)
    #reload page
    #sleep    10s
    wait until page contains element    //*[@id="ContactName"]    30s
    input text    //*[@id="ContactName"]    Testing ${d}
    click element    //*[@id="SearchContactByName"]
    wait until page contains element    //div[text()='Testing ${d}']/..//preceding-sibling::td[2]    30s
    click element    //div[text()='Testing ${d}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    sleep    5s
    click element    //*[@id="Select Contact_nextBtn"]
    log to console    Exiting    technical    page
    unselect frame
    sleep    30s

RequestActionDate
    log to console    selecting Requested Action Date FLow chart page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    log to console    entering Requested action date page
    wait until page contains element    //*[@id="RequestedActionDate"]    30s
    click element    //*[@id="RequestedActionDate"]
    ${date_requested}=    Get Current Date    result_format=%m-%d-%Y
    #log to console    ${d}
    input text    //*[@id="RequestedActionDate"]    ${date_requested}
    sleep  10s
    click element    //*[@id="Additional data_nextBtn"]
    unselect frame
    log to console    Exiting    Requested Action Date page
    sleep    30s

SelectOwnerAccountInfo
    [Arguments]    ${e}= ${billing_account}
    log to console    Select Owner Account FLow Chart Page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    log to console    entering Owner Account page
    Scroll Page To Element   //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    wait until element is visible    //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']    30s
    Log to console      Selecting Billing account
    sleep   10s
    force click element   //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    sleep  10s
    unselect frame
    Scroll Page To Element       //*[@id="BuyerIsPayer"]//following-sibling::span
    sleep  10s
    select frame   xpath=//div[contains(@class,'slds')]/iframe
    Wait until element is visible    //*[@id="BuyerIsPayer"]//following-sibling::span
    Log to console   Click BIP
    force click element  //*[@id="BuyerIsPayer"]//following-sibling::span
    click element    //*[@id="SelectedBuyerAccount_nextBtn"]
    unselect frame
    log to console    Exiting owner Account page
    sleep    30s

ReviewPage
    log to console    Review Page FLow chart Page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    log to console    entering Review page
    wait until page contains element    //*[@id="SubmitInstruction"]/div/p/h3/strong[contains(text(),'successfully')]    30s
    click element    //span[text()='Yes']
    unselect frame
    log to console    Exiting Review page
    sleep    30s

#ValidateTheOrchestrationPlan
#    #${order_number}    get text    //span[text()='Order']//following::div[@class="slds-page-header__title slds-m-right--small slds-truncate slds-align-middle"]/span[@data-aura-class="uiOutputText"]
#    #log to console    ${order_number}.this is order numner
#    scrolluntillfound    //th[@title='Orchestration Plan Name']//following::div[@class='outputLookupContainer forceOutputLookupWithPreview']/a
#    #execute javascript    window.scrollTo(0,2000)
#    #sleep    10s
#    log to console    plan validation
#    wait until page contains element    //th[@title='Orchestration Plan Name']//following::div[@class='outputLookupContainer forceOutputLookupWithPreview']/a    30s
#    click element    //th[@title='Orchestration Plan Name']//following::div[@class='outputLookupContainer forceOutputLookupWithPreview']/a
#    sleep    10s
#    select frame    xpath=//*[@title='Orchestration Plan View']/div/iframe[1]
#    sleep    20s
#    page should contain element    //a[text()='Start']
#    page should contain element    //a[text()='Assetize Order']
#    page should contain element    //a[text()='Deliver Service']
#    page should contain element    //a[text()='Order Events Update']
#    page should contain element    //a[text()='Activate Billing']
#    #go back
#    sleep    3s
#    #click element    //th/div[@data-aura-class="forceOutputLookupWithPreview"]/a[@data-special-link="true" and text()='Telia Colocation']
#    unselect frame

CreateABillingAccount
    # go to particular account and create a billing accouint from there
    wait until page contains element    //li/a/div[@title='Billing Account']    45s
    force click element    //li/a/div[@title='Billing Account']
    #sleep    20s
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    #wait until page contains element    //*[@id="RemoteAction1"]    30s
    #click element    //*[@id="RemoteAction1"]
    #unselect frame
    #sleep    10s
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    #wait until page contains element    //*[@id="Customer_nextBtn"]    30s
    #click element    //*[@id="Customer_nextBtn"]
    #unselect frame
    sleep    20s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]    30s
    ${account_name_get}=    get text    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]
    ${numbers}=    Generate Random String    4    [NUMBERS]
    input text    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]    Billing_${LIGHTNING_TEST_ACCOUNT}_${numbers}
    Execute JavaScript    window.scrollTo(0,700)
    #scroll page to element    //*[@id="billing_country"]
    click element    //*[@id="billing_country"]
    click element    //*[@id="billing_country"]/option[@value='FI']
    click element    //*[@id="Invoice_Delivery_Method"]
    click element    //*[@id="Invoice_Delivery_Method"]/option[@value='Paper Invoice']
    input text    //*[@id="payment_term"]    10
    click element    //*[@id="create_billing_account"]/p[text()='Create Billing Account']
    sleep    10s
    execute javascript    window.scrollTo(0,2100)
    #scroll page to element    //*[@id="Create Billing account_nextBtn"]/p[text()='Next']
    sleep    5s
    wait until page contains element    //*[@id="billing_account_creation_result"]/div/p[text()='Billing account added succesfully to Claudia']    30s
    force click element    //*[@id="Create Billing account_nextBtn"]/p[text()='Next']
    unselect frame
    sleep    30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    sleep    20s
    force click element    //*[@id="return_billing_account"]
    sleep    10s
    unselect frame
    [Return]    Billing_${LIGHTNING_TEST_ACCOUNT}_${numbers}

Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
    [Arguments]        ${username}= ${B2B_DIGISALES_LIGHT_USER}   ${password}= ${Password_merge}  #${username}=mmw9007@teliacompany.com.release    #${password}=Sriram@234
    Login To Salesforce Lightning    ${username}    ${password}

Login to Salesforce as DigiSales Admin User Release
    Login To Salesforce Lightning    ${SALES_ADMIN_USER_RELEASE}    ${PASSWORD-SALESADMIN}

Updating Setting Telia Colocation
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    xpath=//div[@class='cpq-item-product']/div[@class='cpq-item-base-product']/div/div/button[1]/span[@class='cpq-product-name' and text()='Telia Colocation']    60s
    wait until page contains element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-actions slds-text-align_right']/button    60s
    click element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-actions slds-text-align_right']/button
    #wait until page contains element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-string cpq-item-text-value']/div[text()='Add']    60s
    ##page should contain element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-string cpq-item-text-value']/div[text()='Add']
    ##wait until page contains element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-string cpq-item-text-value']/div[text()='Add']    60s
    #wait until page contains element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']    60s
    #execute javascript    window.scrollTo(0,200)
    ##scroll page to element    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    scrolluntillfound    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    sleep    10s
    wait until page contains element    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']    60s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    log to console    before teardiwn
    Unselect Frame
    sleep    60s

search products
    [Arguments]    ${product}
    log to console    AddingProductToCartAndClickNextButton
    sleep    15s
    Wait Until Element Is Enabled    //div[contains(@class,'slds')]/iframe    60s
    Select Frame    //div[contains(@class,'slds')]/iframe
    wait until page contains element    //div[contains(@class,'cpq-searchbox')]//input[contains(@class,'ng-valid')]    60s
    sleep    10s
    input text    //div[contains(@class,'cpq-searchbox')]//input[contains(@class,'ng-valid')]    ${product}


Adding Telia Colocation
    [Arguments]   ${pname}=${product_name}
    Log to console      adding product
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    sleep   5s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    unselect frame
    #wait until page contains element  //div[@class='cpq-item-product']/div[@class='cpq-item-base-product']//following::div[@class='cpq-item-no-children']/span[normalize-space(.)='${pname}']   60s


Adding Telia Taloushallinto XXL-paketti
    ${productid}=    Set Variable    01u58000005pgbPAAQ
    ${product}=    Set Variable    //div[@data-product-id='${productid}']/div/div/div/div/div/button
    ${next_button}=    set variable    //span[contains(text(),'Next')]
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    Wait Until Element Is Visible    ${product}    60s
    Click Element    ${product}
    sleep    20s
    Click Element    ${next_button}

UpdateAndAddSalesTypewith quantity
    [Arguments]    ${products}    ${quantity_value}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${reporting_products}=    Set Variable    //h1[contains(text(),'Suggested Reporting Products')]
    ${product_list}=    Set Variable    //td[normalize-space(.)='${products}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Previous')]/../..//button[contains(@class,'form-control')][contains(text(),'Next')]
    ${contract_length}=    Set Variable    ${product_list}//following-sibling::td/select[contains(@ng-model,'p.ContractLength')]
    ${quantity}=    Set Variable    ${product_list}//following-sibling::td/input[@ng-model='p.Quantity']
    log to console    UpdateAndAddSalesType with quantity
    sleep    30s
    #${reporting}    Run Keyword And Return Status    Wait Until Page Contains    Suggested Reporting Products    60s
    #Run Keyword If    ${reporting} == True    Reporting Products
    Reporting Products
    #${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    #Run Keyword If    ${status} == False    Reload Page
    sleep    20s
    Wait Until Element Is Not Visible    //div[@class='center-block spinner']    120s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    wait until page contains element    ${update_order}    60s
    log to console    selected new frame
    wait untilpage contains element    ${quantity}    60s
    Clear Element Text    ${quantity}
    Input Text    ${quantity}    ${quantity_value}
    wait until page contains element    ${product_list}    70s
    click element    ${product_list} //following-sibling::td/select[contains(@class,'required')]
    click element    ${product_list}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    sleep    2s
    click element    ${contract_length}
    click element    ${contract_length}/option[@value='60']
    Execute Javascript    window.scrollTo(0,400)
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    sleep    2s
    unselect frame
    sleep    60s

OpenQuoteButtonPage_release
    ${Viwe_quote}=    Set Variable    //button[@title="View Quote"]
    ${open_quote}=    Set Variable   //button[@title="Open Quote"]
    ${approval}=    Set variable    //div[@class='vlc-validation-warning ng-scope']/small[contains(text(),'Quote')]
    log to console    OpenQuoteButtonPage
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    log to console    selected final page frame
    log to console    wait completed before view quote click
    sleep  60s
    ${status}=  Run Keyword And Return Status  Element Should Be Visible   ${Viwe_quote}    100s
    Run Keyword If   ${status}   Click Visible Element    ${Viwe_quote}
    Run Keyword unless   ${status}    Click Visible Element   ${open_quote}
    #wait until element is visible    ${open_quote}    30s
    #wait until element is enabled    ${open_quote}    20s
    #log to console    element visible next step
    #click element    ${open_quote}
    unselect frame
    sleep    60s

Closing the opportunity
    [Arguments]    ${continuation}
    #${stage_complete}=    set variable    //span[text()='Mark Stage as Complete']
    ${current_stage}=    set variable    //div[contains(@class,'test-id__field')]/span[contains(text(),'Stage')]/../../div/span[contains(@class,'field-value')]
    ${edit_stage}=    set variable    //button[@title='Edit Stage']
    #Wait Until Element Is Visible    ${stage_complete}    60s
    ${stage}=    Get Text    ${current_stage}
    Log To Console    The current stage is ${stage}
    Capture Page Screenshot
    click element    ${EDIT_STAGE_BUTTON}
    Sleep  30s
    Select option from Dropdown    //div[@class="uiInput uiInput--default"]//a[@class="select"]    Closed Won
    Execute Javascript    window.scrollTo(0,600)
    Select option from Dropdown if not able to edit the element from the list    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Create Continuation Sales Opportunity?')]/../../div/div/div/div/a    ${continuation}   Closed Won
    Select option from Dropdown   //span[contains(@class,'label inputLabel')]/span[contains(text(),'Create Continuation Sales Opportunity?')]/../../div/div/div/div/a    ${continuation}
    Wait Until Page Contains Element    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Close Reason')]/../../div/div/div/div/a    60s
    Execute Javascript    window.scrollTo(0,9000)
    #Get Text    //span[contains(text(),'Service Address Street')]/../../span
    Select option from Dropdown    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Close Reason')]/../../div/div/div/div/a    08 Other
    input text    //span[text()='Close Comment']/../../textarea    this is a test opportunity to closed won
    sleep  30s
    click element    //span[text()='Products With Manual Pricing']//following::span[text()='Save']

Update closing dependencies
    ${stage_name}=    set variable    //input[@name='StageName']
    Click Element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']
    click element    ${stage_name}
    sleep    4s
    click element    ${stage_name}    Closed Won

searching and adding Telia Viestintäpalvelu VIP (24 kk)
    [Arguments]    ${product_name}
    search products    Telia Viestintäpalvelu VIP (24 kk)
    ${product}=    Set Variable    //span[@title='${product_name}']/../../..//button
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    Wait Until Element Is Visible    ${product}    60s
    Click Element    ${product}

updating settings Telia Viestintäpalvelu VIP (24 kk)
    ${SETTINGS}=    Set Variable    //button[@title='Settings']
    ${Toimitustapa}=    set variable    //select[@name='productconfig_field_0_0']
    ${X_BUTTON}=    Set Variable    //button[@class='slds-button slds-button--icon']
    ${Next_Button}=    Set Variable    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    Wait Until Element Is Visible    ${SETTINGS}    60s
    click element    ${SETTINGS}
    sleep    4s
    Select From List By Value    ${Toimitustapa}    Vakiotoimitus
    sleep    5s
    click element    ${X_BUTTON}
    Wait Until Element Is Visible    ${Next_Button}    60s
    Click Element    ${Next_Button}

Reporting Products
    ${next_button}=    Set Variable    //div[@class='vlc-cancel pull-left col-md-1 col-xs-12 ng-scope']//following::div[1]/button[1]
    Reload Page
    sleep  20s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Log To Console    Reporting Products
    Run Keyword If    ${status} == False    execute javascript    browser.runtime.reload()
    #Run Keyword If    ${status} == False    Reload Page
    execute javascript    window.stop();
    sleep    20s
    #Wait Until Element Is Visible    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Wait Until Element Is Visible    ${next_button}    60s
    Force click element    ${next_button}
    #click element    ${next_button}
    unselect frame

Closing Opportunity as Won with FYR
    [Arguments]    ${quantity}    ${continuation}
    ${FYR}=    set variable    //span[@title='FYR Total']/../div
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact_name}.this is name
    sleep    10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    #${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    Chetan
    #${oppo_name}    set variable    Test Robot Order_ 20190730-114111
    Log to console    ${oppo_name}
    Go To Entity    ${oppo_name}
    ClickingOnCPQ   ${oppo_name}
    searching and adding Telia Viestintäpalvelu VIP (24 kk)    Telia Viestintäpalvelu VIP (24 kk)
    updating settings Telia Viestintäpalvelu VIP (24 kk)
    #search products    Telia Taloushallinto XXL-paketti
    #Adding Telia Taloushallinto XXL-paketti
    UpdateAndAddSalesTypewith quantity    Telia Viestintäpalvelu VIP (24 kk)    ${quantity}
    OpenQuoteButtonPage_release
    Go To Entity    ${oppo_name}
    #Closing the opportunity    ${continuation}
    sleep    15s
    Capture Page Screenshot
    ${FYR_value}=    get text    ${FYR}
    Log to console    The FYR value is ${FYR_value}

Editing Win prob
    [Arguments]    ${save}
    [Documentation]    This is to edit the winning probability of a opportunity
    ...
    ...    ${save}--> yes if there is nothing else to edit
    ...    no --> if there are other fields to edit
    ${win_prob_edit}=    Set Variable    //span[contains(text(),'Win Probability %')]/../../button
    ${win_prob}    set variable    //span[contains(text(),'Win Probability %')]/../../div/div/div/div
    ${save_button}    set variable    //span[text()='Save']
    click element    ${win_prob_edit}
    Wait Until Element Is Visible    ${win_prob}    60s
    Execute Javascript    window.scrollTo(0,200)
    click element    ${win_prob}
    sleep  10s
    click element    //li/a[@title='10%']
    #run keyword if    ${save} == yes    click element    ${save_button}

Adding partner and competitor
    [Documentation]    Used to add partner and competitor for a existing opportunity
    ${save_button}    set variable      //span[text()='Products With Manual Pricing']//following::span[text()='Save']
    ${competitor_list}    set variable    //ul[contains(@id,'source-list')]/li/div/span/span[text()='Accenture']
    ${partner_list}=    set variable    //ul[contains(@id,'source-list')]/li/div/span/span[text()='Accenture Oy']
    ${competitor_list_add}    set variable    //div[text()='Competitor']/../div/div/div/lightning-button-icon/button[@title='Move selection to Chosen']
    ${partner_list_add}    set variable    //div[text()='Partner']/../div/div/div/lightning-button-icon/button[@title='Move selection to Chosen']
    Execute Javascript    window.scrollTo(0,1700)
    Sleep  10s
    click element    ${competitor_list}
    click element    ${competitor_list_add}
    Capture Page Screenshot
    Execute Javascript    window.scrollTo(0,1900)
    Sleep  10s
    click element    ${partner_list}
    click element    ${partner_list_add}
    Capture Page Screenshot
    click element    ${save_button}
    Capture Page Screenshot

Adding Yritysinternet Plus
    [Arguments]    ${Yritysinternet_Plus}
    #${product}=    Set Variable    //div[@data-product-id='${Yritysinternet_Plus}']/div/div/div/div/div/button
    ${product}=    Set Variable    //span[@title='${Yritysinternet_Plus}']/../../..//button
    ${SETTINGS}=    Set Variable    //button[@title='Settings']
    ${Liittymän_nopeus}    Set Variable    //select[@name='productconfig_field_0_0']
    ${Palvelutaso}    Set Variable    //select[@name='productconfig_field_0_1']
    ${X_BUTTON}=    Set Variable    //button[@class='slds-button slds-button--icon']
    Wait Until Element Is Visible    ${product}    60s
    Click Element    ${product}
    Sleep  30s
    Wait Until Element Is Visible    ${SETTINGS}    60s
    click element    ${SETTINGS}
    Wait Until Element Is Visible    ${Liittymän_nopeus}    60s
    Select From List By Value    ${Liittymän_nopeus}    2 Mbit/s/1 Mbit/s
    sleep    3s
    Select From List By Value    ${Palvelutaso}    A24h
    sleep    3s
    click element    ${X_BUTTON}
    Sleep  30s
    unselect frame

Adding DataNet Multi
    [Arguments]    ${DataNet_Multi}
    #${product}=    Set Variable    //span[@title='${DataNet_Multi}']/../../..//button
    ${product}=    Set Variable  //div[@class="slds-col slds-small-size_4-of-12 slds-medium-size_5-of-12 slds-large-size_4-of-12 slds-text-align_right cpq-product-actions"]//following::span[@title='${DataNet_Multi}']/../../..//button/..
    ${next_button}=    set variable    //span[contains(text(),'Next')]
    Wait Until Element Is Visible    ${product}    60s
    Click Element    ${product}
    sleep    30s
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    Log to console      ${status}
    wait until page contains element    //span[text()='Next']/..    60s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    #Click Visible Element   ${next_button}

UpdateAndAddSalesType for 2 products
    [Arguments]    ${product1}    ${product2}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_1}=    Set Variable    //td[normalize-space(.)='${product1}']
    ${product_2}=    Set Variable    //td[normalize-space(.)='${product2}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    log to console    UpdateAndAddSalesType for 2 products
    sleep    30s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Run Keyword If    ${status} == False    Reload Page
    sleep    60s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    wait until page contains element    ${update_order}    60s
    log to console    selected new frame
    wait until page contains element    ${product_1}    70s
    click element    ${product_1}//following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_1}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    sleep    5s
    wait until page contains element    ${product_2}    70s
    click element    ${product_2}//following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_2}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    Unselect Frame
    sleep    20s

preview and submit quote
    [Arguments]    ${oppo_FOR}
    ${preview_quote}    Set Variable    //div[@title='Preview Quote']
    ${send_quote}    Set Variable    //div[@title='Send Quote Email']
    ${quote_n}    Set Variable    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div
    ${send_mail}    Set Variable    //p[text()='Send Email']
    ${submitted}    Set Variable    //a[@aria-selected='true'][@title='Submitted']
    sleep    10s
    ${quote_number}    get text    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span
    Log To Console    preview and submit quote
    Log to console    ${quote_number}
    click element    ${preview_quote}
    sleep    10s
    Capture Page Screenshot
    Execute Javascript    window.scrollTo(0,200)
    Capture Page Screenshot
    Sleep  10s
    Go Back
    Click Element    ${send_quote}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    Run Keyword If    ${status} == False    Reload Page
    sleep    20s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Capture Page Screenshot
    Sleep  30s
    ${status}=  Run Keyword And Return Status  Element Should Be Visible   ${send_mail}    100s
    Run Keyword If   ${status}   Click Visible Element    ${send_mail}
    Run Keyword unless   ${status}  approve the quote   ${oppo_FOR}
    #Click Element    ${send_mail}
    Unselect Frame
    sleep    10s
    ${Quote_Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${submitted}    60s
    Log To Console    Quote is submitted: \ \ ${Quote_Status}
    [Return]    ${quote_number}

approve the quote
    [Arguments]    ${oppo_FOR}
    logoutAsUser   DigiSales Lightning User
    sleep  60s
    login to salesforce as digisales admin user
    swithchtouser    B2B DigiSales
    : FOR    ${i}    IN RANGE    10
    \   ${status}=  Run Keyword And Return Status   Element Should Be Visible    //a[@href="/lightning/o/Quote/home"]/span/span[contains(text(),"Quotes")]    100s
    \   Run Keyword If   ${status}   Click Visible Element    //a[@href="/lightning/o/Quote/home"]/span/span[contains(text(),"Quotes")]
    \   Run Keyword unless   ${status}  Click Visible Element  //one-app-nav-bar-menu-button/a/span[contains(text(),"Show More")]
    \   Sleep  30s
    \   Exit For Loop If    ${status}
	Sleep  20s
    Input Text    //input[@name="Quote-search-input"]
    Click Element   //a[contains(text(),"${oppo_FOR}")]
    creditscoreapproving
    logoutAsUser  B2B DigiSales
    login to salesforce as digisales Lightning User
Sending quote as email
    ${spinner}    Set Variable    //div[contains(@class,'slds-spinner--large')]
    ${send_mail}    Set Variable    //p[text()='Send Email']
    ${iframe}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Sleep  40s
    ${status}    Wait Until Element Is Enabled    ${iframe}    60s
    Run Keyword If    ${status} == False    Reload Page
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    Sleep  30s
    Wait Until Element Is Visible    ${send_mail}    60s
    Capture Page Screenshot
    Click Element    ${send_mail}
    Unselect Frame

verifying quote and opportunity status
    [Arguments]    ${oppo_name}
    ${quote_status}    Set Variable    //a[@title='Submitted'][@aria-selected='true']
    ${oppo_status}    Set Variable    //a[@title='Negotiate and Close'][@aria-selected='true']
    sleep    7s
    ${quote_s}    Run Keyword And Return Status    Page Should Contain Element    ${quote_status}
    Run Keyword If    ${quote_s} == True    Log To Console    The status of quote is Submitted
    Go To Entity    ${oppo_name}
    Reload Page
    sleep    7s
    ${oppo_s}    Run Keyword And Return Status    Page Should Contain Element    ${oppo_status}
    Run Keyword If    ${oppo_s} == True    Log To Console    The status of opportunity is Negotiate and Close

Create contract
    [Arguments]    ${account}    ${oppo_name}
    ${related}    Set Variable    //span[contains(text(),'Related')]
    ${new_contract}    Set Variable    //span[@title='Contracts']/../../../../../div
    ${record_type}    Set Variable    //legend[text()='Select a record type']
    ${agreement}    Set Variable    //span[text()='Service Agreement']
    ${next}    Set Variable    //button/span[text()='Next']
    ${name}    Set Variable    //label/span[text()='Name']/../../input
    ${contract_term}    Set Variable    //span[text()='Contract Term (months)']/../../input
    ${contract_start_date}    Set Variable    //label/span[text()='Contract Start Date']/../../div/input
    ${today}    Set Variable    //span[contains(@class,'text')][text()='Today']
    ${contract_status}    Set Variable    //span[text()='Status']/../../div/div/div/div/a[contains(text(),'None')]
    ${signed}    Set Variable    //*[text()='Signed']
    ${save}    Set Variable    //button/span[text()='Save']
    ${spinner}    Set Variable    //div[@class='forceDotsSpinner']
    Go to Entity    ${account}
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    ${related}    60s
    Run Keyword If    ${status_page} == False    Reload Page
    sleep    20s
    Wait Until Element Is Visible    ${related}    60s
    click element    ${related}
    Scroll Page To Element    ${new_contract}
    Click Element    ${new_contract}
    Wait Until Element Is Visible    ${record_type}    60s
    Click Element    ${agreement}
    Click Element    ${next}
    Wait Until Element Is Visible    ${contract_start_date}    60s
    #Input Text    ${name}    ${oppo_name}
    #input text    ${contract_term}    12
    sleep    3s
    click element    ${contract_start_date}
    click element    ${today}
    sleep    3s
    click element    ${contract_status}
    click element    ${signed}
    sleep    3s
    input text    ${contract_term}    12
    sleep    3s
    Capture Page Screenshot
    click element    ${save}
    Capture Page Screenshot
    Wait Until Element Is Not Visible    ${spinner}    60s

Create Order from quote
    [Arguments]    ${quote_number}    ${oppo_name}
    ${CPQ}    Set Variable    //div[@title='CPQ']
    ${frame}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${create_order}    Set Variable    //button/span[text()='Create Order']
    ${view_button}    Set Variable    //button[@title='View']
    sleep    10s
    Search Salesforce    ${quote_number}
    Select Entity    ${oppo_name}    ${EMPTY}
    Wait Until Element Is Visible    ${CPQ}    60s
    click element    ${CPQ}
    sleep    10s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    ${frame}
    Run Keyword If    ${status} == False    Reload Page
    sleep    20s
    Wait Until Element Is Enabled    ${frame}    60s
    select frame    ${frame}
    Wait Until Element Is Visible    ${create_order}    60s
    click element    ${create_order}
    Unselect Frame
    sleep  60s
    select frame    ${frame}
    Wait Until Element Is Visible    //button[contains(text(),"Open Order")]    60s
    Click Element    //button[contains(text(),"Open Order")]
    Sleep   20s
    Unselect Frame
Opportunity status
    ${oppo_status}    Set Variable    //a[@aria-selected='true'][@title='Negotiate and Close']
    sleep    10s
    Reload Page
    ${Oppo_Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${oppo_status}    60s
    Log To Console    The status of opportunity is Negotiate and Close : ${Oppo_Status}

View order and send summary
    ${frame}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${view_button}    Set Variable    //div[@class="slds-button-group"]//button[@title="View"]
    ${preview_order}    Set Variable    //a/div[@title='Preview Order Summary']
    ${send_order_summary}    Set Variable    //a/div[@title='Send Order Summary Email']
    ${submit_order}    Set Variable    //a/div[@title='Submit Order']
    ${order_progress}    Set Variable    //a[@title='In Progress'][@aria-selected='true']
    Sleep  30s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    ${frame}
    Run Keyword If    ${status} == False    Reload Page
    Wait Until Element Is Enabled    ${frame}    60s
    Sleep  30s
    select frame    ${frame}
    Log to console      Inside frame
    ${status}   set variable    Run Keyword and return status    Frame should contain    ${view_button}    View
    Log to console      ${status}
    Sleep  100s
    Wait Until Element Is Visible       ${view_button}     60s
    click element   ${view_button}
    Unselect Frame
    #sleep  40s
    #Wait Until Element Is Visible    //div[@id="Close"]   60s
    #click element   //div[@id="Close"]
    #Unselect Frame
    sleep    20s
    wait until element is visible    ${preview_order}    120s
    click element    ${preview_order}
    sleep    7s
    Capture Page Screenshot
    Go Back
    Wait Until Element Is Visible    ${send_order_summary}    60s
    click element    ${send_order_summary}
    Sending quote as email
    Sleep  40s
    Wait Until Element Is Visible    ${submit_order}    60s
    click element    ${submit_order}
    sleep    30s
    Wait Until Element Is Visible    ${order_progress}    60s
    Capture Page Screenshot

Adding Products
    [Arguments]    ${product-id}
    ${product}=    Set Variable    //span[normalize-space(.)= '${product-id}']/../../../div[@class='slds-tile__detail']/div/div/button
    Wait Until Element Is Visible    ${product}    60s
    Click Element    ${product}
    unselect frame

Updating sales type multiple products
    [Arguments]    @{products}
    [Documentation]    This is used to Update sales type for multiple products
    ...
    ...    The input for this keyword is \ list of products
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    ${frame}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${prod}    create list    @{products}
    ${count}    Get Length    ${prod}
    Sleep  20s
    log to console    Updating sales type multiple products
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    ${frame}    60s
    Run Keyword If    ${status} == False    Reload Page
    sleep    20s
    Wait Until Element Is Enabled    ${frame}    60s
    select frame    ${frame}
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > ${count}-1
    \    ${product_name}    Set Variable    @{products}[${i}]
    \    ${product_list}    Set Variable    //td[normalize-space(.)='${product_name}']
    \    wait until page contains element    ${update_order}    60s
    \    log to console    selected new frame
    \    Wait Until Element Is Visible    ${product_list}//following-sibling::td/select[contains(@class,'required')]    120s
    \    click element    ${product_list} //following-sibling::td/select[contains(@class,'required')]
    \    sleep    2s
    \    click element    ${product_list}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    log    Completed updating the sales type
    sleep    5s
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    Capture Page Screenshot
    Unselect Frame
    sleep    5s

Searching and adding multiple products
    [Arguments]    @{products}
    [Documentation]    This is used to search and add multiple products
    ...
    ...    In order to add the product we are using the product-id
    ...
    ...    the tag used to extract the product-id is "data-product-id"
    ${iframe}    Set Variable    //div[contains(@class,'slds')]/iframe
    ${next_button}    set variable    //span[contains(text(),'Next')]
    ${prod}    Create List    @{products}
    ${count}    Get Length    ${prod}
    Log To Console    ${count}
    Log To Console    Searching and adding multiple products
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > ${count}-1
    \    ${product_name}    Set Variable    @{products}[${i}]
    \    ${product_id}    Set Variable    ${product_name}
    \    Log To Console    product name ${product_name}
    \    search products    ${product_name}
    \    Log To Console    Product id ${product_id}
    \    Adding Products    ${product_id}
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    Scroll Page To Location    0    100
    Click Element    ${next_button}
    #${status}    Run Keyword And Return Status    Wait Until Element Is Not Visible    ${next_button}    60s
    #Run Keyword If    ${status} == True    click element    ${next_button}
    Unselect Frame
    Sleep  60s

Preview order summary and verify order
    [Arguments]    @{products}
    ${preview_order_summary}    Set Variable    //div[@title='Preview Order Summary']
    ${frame}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${prod}    Create List    @{products}
    ${count}    Get Length    ${prod}
    Wait Until Element Is Visible    ${preview_order_summary}    120s
    Click Element    ${preview_order_summary}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    ${frame}
    Run Keyword If    ${status} == False    Reload Page
    sleep    20s
    Wait Until Element Is Enabled    ${frame}    60s
    select frame    ${frame}
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > ${count}-1
    \    ${product_name}    Set Variable    @{products}[${i}]
    \    ${status}    Run Keyword And Return Status    ${product_name}
    \    Log    ${product_name} is present in order summary ${status}
    unselect frame

Get Multibella id
    ${multibella_guiId}    Set Variable    //span[text()='MultibellaCaseGuiId']/../../div/span/span
    Wait Until Element Is Visible    ${DETAILS_TAB}    60s
    Click Element    ${DETAILS_TAB}
    sleep    5s
    wait until element is visible    ${multibella_guiId}    60s
    ${multibella_value}    get text    ${multibella_guiId}
    [Return]    ${multibella_value}

verifying Multibella order case
    [Arguments]    ${multibella_caseid}    @{products}
    ${history}    set variable    //a[text()='History']
    ${title}    Set Variable    //span[text()='Title']/../../td[3]
    MUBE Open Browser And Go To CRM Login Page
    MUBE Log In CRM    ${MUBE_ADMIN_USERNAME}    ${MUBE_ADMIN_PASSWORD}
    MUBE Verify That Case Exists in MuBe    ${multibella_caseid}
    Wait Until Element Is Visible    ${history}    60s
    click element    ${history}
    wait until element is visible    ${title}
    ${listed_products}    get text    ${title}
    @{list_products}    Split String    ${listed_products}    ,${SPACE}
    ${list_P}    Create List    @{list_products}
    ${count}    Get Length    ${list_P}
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > ${count}-1
    \    ${list_product}    Set Variable    @{list_products}[i]
    \    ${product}    Set Variable    @{products}[i]
    \    ${present}    Run Keyword And Return Status    Should Be Equal As Strings    ${list_product}    ${product}
    \    log    @{list_products} is present ${present}

Update Contact and Pricelist in Opportunity
    [Arguments]    ${pricelist}
    [Documentation]    To update the contact and Pricelist values in existing opportunity
    ${oppo_name}=    Set Variable    //*[text()='${OPPORTUNITY_NAME}']

Navigate to Availability check
    [Documentation]    In B2B account page click 360-view and availability check buttons
    ${iframe}    Set Variable    //section[@class='tabs__content active uiTab']//div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Click Element    ${360_VIEW}
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    Wait until page contains element    ${AVAILABILITY_CHECK_BUTTON}    60s
    Click Button    ${AVAILABILITY_CHECK_BUTTON}
    ${status}=    Run Keyword and return status    Wait until element is not visible    ${AVAILABILITY_CHECK_BUTTON}
    Run Keyword if    ${status} == False    Click Button    ${AVAILABILITY_CHECK_BUTTON}
    unselect frame

Validate Address details
    [Documentation]    Validate address in availability check
    ${iframe}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${postal_code_field}    Set Variable    xpath=//input[@id="postalCodeCityForAddressA"]
    ${address_field}    Set Variable    //input[@id='AddressA']
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    ${status}=    Run Keyword and return status    Wait until element is visible    ${postal_code_field}    20s
    Run Keyword If    ${status} == False    Execute Javascript    window.location.reload(false);
    Run Keyword If    ${status} == False    Wait until element is visible    ${postal_code_field}    20s
    Wait until keyword succeeds    30s    2s    Input Text    ${postal_code_field}    43500
    Wait until keyword succeeds    30s    2s    Input Text    ${address_field}    ${DEFAULT_ADDRESS}
    Wait element to load and click    ${ADDRESS_VALIDATION_DROPDOWN}
    Click Element    //div[@id='Address Details_nextBtn']
    unselect frame

Validate point to point address details
    [Documentation]    Validates point to point address details in B2O-account availability check
    ${iframe}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${postal_code_field_A}    Set Variable    //input[@id="postalCodeCityForAddressA"]
    ${address_field_A}    Set Variable    //input[@id='AddressA']
    ${postal_code_field_B}    Set Variable    //input[@id="postalCodeCityForAddressB"]
    ${address_field_B}    Set Variable    //input[@id='AddressB']
    ${street_address}    Set Variable    Teollisuuskatu 1
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    ${iframe}    60s
    Run Keyword If    ${status} == False    execute javascript    window.location.reload(false);
    select frame    ${iframe}
    Wait element to load and click    xpath=//input[@id="pointToPointInput"]
    Wait until element is visible    //input[@id="postalCodeCityForAddressA"]    60s
    Input Text    ${postal_code_field_A}    ${DEFAULT_POSTAL_CODE}
    Input Text    ${address_field_A}    ${street_address}
    Wait element to load and click    //ul[@class='typeahead dropdown-menu ng-scope am-fade bottom-left']/li/a[text()='${street_address}']
    Input Text    ${postal_code_field_B}    ${DEFAULT_POSTAL_CODE}
    ${street_address}    Set Variable    Teollisuuskatu 23
    Input Text    ${address_field_B}    ${street_address}
    Wait element to load and click    //ul[@class='typeahead dropdown-menu ng-scope am-fade bottom-left']/li/a[text()='${street_address}']
    Click Element    //div[@id='Address Details_nextBtn']
    unselect frame

Select B2O product available and connect existing opportunity
    ${iframe}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    ScrollUntillFound    ${B2O_PRODUCT_CHECKBOX}
    Wait until keyword succeeds    30s    2s    Click element    ${B2O_PRODUCT_CHECKBOX}
    Click element    //div[@id='ListofProductsAvailable_nextBtn']
    Wait element to load and click    ${EXISTING_OPPORTUNITY_RADIOBUTTON}
    Click element    //div[@id='CreateOrUpdateOpp_nextBtn']
    Wait until page contains element    ${EXISTING_OPPORTUNITY_TEXT_FIELD}
    Wait until keyword succeeds    30s    2s    Input text    ${EXISTING_OPPORTUNITY_TEXT_FIELD}    ${OPPORTUNITY_NAME}
    sleep    5s
    Wait element to load and click    //*[@id="OpportunityResultList"]/div/ng-include/div/table/tbody/tr/td[1]/label/input
    Click element    //div[@id='UpdateOpportunity_nextBtn']
    unselect frame
    Wait until page contains element    xpath=//a[@title='CPQ']    60s

Select product available for the address and create an opportunity
    ${iframe}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${days}    Set Variable    7
    ${opport_name}=    Run Keyword    Create Unique Name    TestOpportunity
    ${date}=    Get Date With Dashes    ${days}
    Set Test Variable    ${OPPORTUNITY_CLOSE_DATE}    ${date}
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    Wait element to load and click    ${PRODUCT_CHECKBOX}
    Click element    //div[@id='ListofProductsAvailable_nextBtn']
    Wait element to load and click    ${NEW_OPPORTUNITY_RADIOBUTTON}
    Click element    //div[@id='CreateOrUpdateOpp_nextBtn']
    Wait until page contains element    //input[@id='Name']    30s
    input text    //input[@id='Name']    ${opport_name}
    Wait until page contains element    //textarea[@id='Description']    30s
    input text    //textarea[@id='Description']    Testopportunity description
    Wait until page contains element    //input[@id='CloseDate']    30s
    input text    //input[@id='CloseDate']    ${OPPORTUNITY_CLOSE_DATE}
    Click element    //div[@id='CreateB2BOpportunity_nextBtn']
    sleep    30s
    ${isVisible}    Run Keyword and return status    Wait until page contains element    //div[@id='HTTPCreateOpportunityLineItems']/div/p/button[text()='Continue']    30s
    Run Keyword If    ${isVisible}    Click element    //div[@id='HTTPCreateOpportunityLineItems']/div/p/button[text()='Continue']
    unselect frame
    Wait until page contains element    xpath=//a[@title='CPQ']    60s

Check the CPQ-cart contains the wanted products
    [Arguments]    ${product_name}
    ${iframe}    Set Variable    xpath=//div[contains(@class,'slds')]/iframe
    Wait until element is enabled    ${iframe}    30s
    Wait until keyword succeeds    30s    2s    select frame    ${iframe}
    Wait until keyword succeeds    3x    30s    Wait until page contains element    //button/span[text()='${product_name}']    30s
    unselect frame

Wait element to load and click
    [Arguments]    ${element}
    ${status}=    Run Keyword and return status    Wait until page contains element    ${element}    30s
    Run Keyword If    ${status} == False    Execute Javascript    window.location.reload(false);
    Run Keyword If    ${status} == False    Wait until page contains element    ${element}    30s
    Wait until keyword succeeds    30s    2s    Click Element    ${element}

Verify that warning banner is displayed on opportunity page
    [Documentation]    After creating opportunity without service contract make sure warning banner is displayed on the opportunity page
    Wait until element is visible    ${OPPORTUNITY_WARNING_BANNER}

Add product to cart (CPQ)
    [Documentation]     In the CPQ cart search for the wanted product and add it to the cart
    [Arguments]    ${pname}=${product_name}
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    ${CPQ_SEARCH_FIELD}    60s
    input text    ${CPQ_SEARCH_FIELD}    ${pname}
    Wait element to load and click  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    wait until page contains element    //button/span[text()='${pname}']   60s
    scrolluntillfound    ${CPQ_CART_NEXT_BUTTON}
    click element    ${CPQ_CART_NEXT_BUTTON}
    unselect frame
    sleep    20s

Update products
    [Documentation]     Create Quote in draft status in the post-CPQ omniscript
    ${iframe}   Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Wait Until Element Is Enabled   ${iframe}   60s
    select frame    ${iframe}
    Wait until page contains element    ${SERVICE_CONTRACT_WARNING}     30s
    Wait element to load and click      ${SALES_TYPE_DROPDOWN}
    Click element   ${NEW_MONEY_NEW_SERVICES}
    Wait element to load and click  //form[@id="a1q0E000000i2dBQAQ-12"]/div/div/button
    sleep   20s
    Wait element to load and click  //button[@id="View Quote"]
    unselect frame
    Wait until page contains element    //h1/div[@title='${OPPORTUNITY_NAME}']  30s

Update products OTC and RC
    ${iframe}   Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Wait Until Element Is Enabled   ${iframe}   60s
    select frame    ${iframe}
    Input Text  //div[@id="OpportunityLineItems"]/ng-include/div/table/tbody/tr[3]/td[4]/input      200
    Input Text  //div[@id="OpportunityLineItems"]/ng-include/div/table/tbody/tr[3]/td[5]/input      200
    Wait element to load and click      //div[@id="OpportunityLineItems"]/ng-include/div/table/tbody/tr[3]/td[8]/select
    Click element   //table[@class='tg']/tbody//tr[3]/td[8]/select/option[@value='New Money-New Services']
    Wait element to load and click  //form[@id="a1q4E000002zpz1QAA-12"]/div/div/button
    sleep   20s
    Wait element to load and click  //button[@id="View Quote"]
    unselect frame
    sleep   10s

Check prices are correct in quote line items
    sleep   10s
    Wait until page contains element   //a/span[text()='Quote Line Items']      30s
    Force click element   //a/span[text()='Quote Line Items']
    Wait until element is visible   //table/tbody/tr/td[5]/span/span[text()='200,00 €']     30s
    Wait until element is visible   //table/tbody/tr/td[6]/span/span[text()='200,00 €']     30s

Check opportunity value is correct
    ScrollUntillFound    //h3/button/span[text()='Opportunity Value and FYR']
    Wait until page contains element    //span[text()='OneTime Total']/../../../div/div[2]/span/span[text()='200,00 €']     30s
    Wait until page contains element    //span[text()='Recurring Total']/../../../div/div[2]/span/span[text()='200,00 €']   30s

Check service contract is on Draft Status
    [Documentation]    On account page check service contracts and verify that created one is on draft status
    Wait element to load and click    ${ACCOUNT_RELATED}
    Wait element to load and click    //h2/a/span[text()='Contracts']
    Wait until page contains element    //table/tbody/tr[2]/td[3]/span/span[text()='Service Contract']    30s
    Wait until page contains element    //table/tbody/tr[2]/td[4]/span/a[text()='Telia Verkkotunnuspalvelu']    30s
    Wait until page contains element    //table/tbody/tr[2]/td[5]/span/span[text()='Draft']    30s

Select rows to delete the contract
    [Documentation]    Used to delete all the existing contracts for the business account
    #ScrollUntillFound    //span[text()='Contracts']/../../span/../../../a
    #Force Click element    //span[@title='Contracts']//following::div/span[text()='View All']
    log to console    bad
    Force Click element    //span[text()='View All']/span[text()='Contracts']
    Sleep    10s
    Wait Until Element Is Visible    ${table_row}    60s
    ${count}=    get element count    ${table_row}
    log to console    ${count}
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > ${count}-1
    \    Delete all Contracts    ${table_row}

Delete all existing contracts from Accounts Related tab
    wait until element is visible    ${ACCOUNT_RELATED}    60s
    Force click element    ${ACCOUNT_RELATED}
    ${status}=    run keyword and return status    Element Should Be Visible    //span[@title='Contracts']
    run keyword if    ${status}    Run Keyword With Delay    0.10s    Click Element    xpath=${ACCOUNT_RELATED}
    Sleep    15s
    ${display}=    run keyword and return status    Element Should Be Visible    //span[text()='View All']/span[text()='Contracts']
    run keyword if    ${display}    Select rows to delete the contract

Delete all Contracts
    [Arguments]    ${table_row}
    ${IsVisible}=    Run Keyword And Return Status    element should be visible    ${table_row}
    Run Keyword if    ${IsVisible}    Delete row items    ${table_row}

Delete row items
    [Arguments]    ${table_row}
    [Documentation]    Used to delete the individual row
    Force Click element    ${table_row}
    wait until element is visible    //a[@title='Delete']
    Force Click element    //a[@title='Delete']
    wait until element is visible    //button[@title='Delete']    60s
    Click element    //button[@title='Delete']
    Sleep    20s

Add relationship for the contact person
    Set Test Variable    ${contact_name}    ${AP_FIRST_NAME} ${AP_LAST_NAME}
    sleep    20s
    Wait element to load and click    ${ACCOUNT_RELATED}
    Wait element to load and click    //a[@title='Add Relationship']
    Wait until element is visible    //input[@title='Search Contacts']    30s
    Input text    //input[@title='Search Contacts']    ${contact_name}
    Wait element to load and click    //a[@role='option']/div/div[@title='${contact_name}']
    Wait element to load and click    //span[text()='Account']/../..//div//li//a[@class='deleteAction']
    Wait until keyword succeeds    30s    2s    Input text    //input[@title='Search Accounts']    Aacon Oy
    Wait element to load and click    //input[@title='Search Accounts']/..//a[@role='option']/div/div[@title='Aacon Oy']
    Wait until keyword succeeds    30s    2s    Click element    //button[@title='Save']

Validate contact relationship
    log to console    Validating contact relationship
    Execute Javascript    window.location.reload(false);
    Wait element to load and click    //a[@title='Related']
    ScrollUntillFound    //h2/a/span[text()='Related Accounts']
    Click element    //h2/a/span[text()='Related Accounts']
    Wait until page contains element    //table/tbody/tr/th/span/a[text()='Aacon Oy']    20s
    Wait until page contains element    //table/tbody/tr/th/span/a[text()='Aarsleff Oy']    20s
    Wait until page contains element    //table/tbody/tr[2]/td[2]/span/span/img[@class='slds-truncate checked']    20s

Navigate to related tab
    Wait element to load and click    ${ACCOUNT_RELATED}

Add account owner to account team
    ${account_owner}=    Get Text    //div[@class='ownerName']//a
    Navigate to view    Account Team Members
    Add new team member  ${account_owner}

Validate that account owner can not be added to account team
    Wait until page contains element    //ul[@class='errorsList']/li[text()='Cannot add account owner to account team']     30s
    Wait until element is visible   //ul[@class='errorsList']/li[text()='Cannot add account owner to account team']     30s

Add new team member
    [Documentation]     Add new team member to account
    [Arguments]     ${new_team_member}      ${role}=--None--
    sleep   10s
    Wait until page contains element    //ul/li/a[@title='New']     30s
    Force click element  //ul/li/a[@title='New']
    Wait until page contains element    //input[@title='Search People']
    Input text  //input[@title='Search People']     ${new_team_member}
    Wait element to load and click  //a[@role='option']/div/div[@title='${new_team_member}']
    Wait element to load and click  //a[text()='--None--']
    Click element  //ul/li/a[@title='${role}']
    Click element   //button[@title='Save']
    sleep   10s

Validate that team member is created succesfully
    [Arguments]     ${name}=Sales,Admin     ${role}=
    Wait until page contains element   //table/tbody/tr/th/span/span[text()='${name}']     30s
    Wait until page contains element    //table/tbody/tr/th/span/span[text()='${name}']/../../../td[2]/span/span[text()='${role}']

Navigate to view
    [Arguments]     ${title}
    ScrollUntillFound  //span[text()='${title}']
    Click element   //span[text()='${title}']

Try to add same team member twice
    [Documentation]     Tries to add same user twice as a team member for business account.
    [Arguments]     ${user}
    Add new team member  ${user}
    Add new team member  ${user}
    
Validate that same user can not be added twice to account team
    Wait until page contains element    //ul[@class='errorsList']/li[text()='Cannot create a duplicate entry']     30s
    Wait until element is visible   //ul[@class='errorsList']/li[text()='Cannot create a duplicate entry']     30s
    Click element   //button[@title='Cancel']

Delete team member from account
    :FOR    ${i}    IN RANGE    999
    \   ${no_team_members}=     Run keyword and return status   Wait until page contains element    //div[@class='emptyContent']//p[text()='No items to display.']      10s
    \   Exit For Loop If    ${no_team_members}
    \   Wait until page contains element    ${table_row}    30s
    \   Delete row items    ${table_row}

Change team member role from account
    Wait until page contains element    ${table_row}
    Force Click element    ${table_row}
    Wait until element is visible    //a[@title='Edit']
    Click element    //a[@title='Edit']
    Wait element to load and click    //a[text()='--None--']
    Wait element to load and click    //ul/li[2]/a[text()='Account Manager']
    Click element    //button[@title='Save']
    Wait until page contains element    //table/tbody/tr/td[2]/span/span[text()='Account Manager']    30s
    sleep    10s

Change account owner to
    [Arguments]    ${new_owner}
    [Documentation]    Checks if account given as a parameter is already account owner and if not proceeds to change the account owner
    ${isAccountOwner}=    Run keyword and return status    Wait until page contains element    //div[@class='ownerName']/div/a[text()='${new_owner}']    30s
    Run Keyword if    ${isAccountOwner} == False    Open change owner view and fill the form    ${new_owner}

Open change owner view and fill the form
    [Arguments]    ${username}
    Wait element to load and click    //button[@title='Change Owner']
    Wait until page contains element    //input[@title='Search People']
    Input text      //input[@title='Search People']     ${username}
    Wait element to load and click  //a[@role='option']/div/div[@title='${username}']
    Click element   //div[@class='modal-footer slds-modal__footer']//button[@title='Change Owner']
    sleep   40s

Validate that account owner cannot be different from the group account owner
    Wait until page contains element    //span[text()='Owner ID: Account Owner cannot be different from the Group Account owner']   30s
    Click element   //button[@title='Cancel']

Navigate to Account History
    ScrollUntillFound  //a/span[text()='Account History']
    Click element   //a/span[text()='Account History']

Validate that Account history contains record
    [Arguments]     ${user}
    Wait until page contains element    //table/tbody/tr[1]/td[5]//span[text()='${user}']

Validate that Tellu login page opens
    [Documentation]     Validate that Tellu login page opens in new window.
    sleep   10s
    Select Window   NEW
    Maximize browser window
    Execute Javascript    window.location.reload(false);
    # Title should be     Teamworks Process Server Console
    Wait until page contains element    //form[@name='login']       30s

Enter Random Data to Lead Web Form
    [Arguments]    ${fname}    ${lname}    ${email}    ${mobile}    ${title}    ${desc}
    wait until page contains element    //*[@id="00N1i000001wmJE"]    20s
    input text    //*[@id="00N1i000001wmJE"]    ${lead_business_id}
    input text    //*[@id="first_name"]    ${fname}
    input text    //*[@id="last_name"]    ${lname}
    input text    //*[@id="mobile"]    ${mobile}
    input text    //*[@id="email"]    ${email}
    input text    //*[@id="title"]    ${title}
    input text    //textarea[@name='description']    ${desc}
    input text    //*[@id="00N1i000001wmJH"]    ${email}
    click element    //*[@id="lead_source"]
    sleep    2s
    click element    //option[@value='Customer Service']
    click element    //input[@type='submit']
    sleep    3s
    #Location Should Contain    https://www.telia.fi/

Open_Todays_Leads
    sleep    3s
    wait until page contains element    //button[@class='slds-button']    30s
    click element    //button[@class='slds-button']
    wait until page contains element    //input[@placeholder="Search apps or items..."]    30s
    input text    //input[@placeholder="Search apps or items..."]    Leads
    wait until page contains element    //li/a[@title='Leads']    30s
    force click element    //li/a[@title='Leads']
    wait until page contains element    //li/span[text()='Leads']    30s
    force click element    //span[text()='Recently Viewed' and @data-aura-class='uiOutputText']
    #//a[@title="Select List View"]
    wait until page contains element    //span[text()="Today's Leads"]/..    30s
    force click element    //span[text()="Today's Leads"]/..
    wait until page contains element    //div/span[text()="Today's Leads"]    30s
    sleep    3s

validate_Created_Lead
    [Arguments]    ${fname}    ${lname}    ${email}    ${mobile}    ${title}    ${desc}
    reload page
    wait until page contains element    //span[@class='title' and text()='Details']    30s
    wait until element is enabled    //span[@class='title' and text()='Details']    30s
    click element    //span[@class='title' and text()='Details']
    #force click element    //a[@title='${fname} ${lname}']
    #wait until page contains element    //span[text()='${fname} ${lname}']    30s
    #sleep    10s
    wait until element is enabled    //span[@class='title' and text()='Details']    30s
    click element    //span[@class='title' and text()='Details']
    wait until page contains element    //span[text()='${fname} ${lname}']    30s
    page should contain element    //span[text()='Lead Owner']//ancestor::div[contains(@class,'form-element')]//span[text()='Lead Validation for Customer Service']
    page should contain element    //span[text()='Lead Status']//ancestor::div[contains(@class,'form-element')]//span[text()='Validate']
    page should contain element    //span[text()='Name']//ancestor::div[contains(@class,'form-element')]//span[text()='${fname} ${lname}']
    page should contain element    //span[text()='Mobile']//ancestor::div[contains(@class,'form-element')]//span[text()='${mobile}']
    page should contain element    //span[text()='Email']//ancestor::div[contains(@class,'form-element')]//span[contains(@class,'test-id')]//a[text()='${email}']
    page should contain element    //span[text()='Business ID']//ancestor::div[contains(@class,'form-element')]//span[text()='2733621-7']
    page should contain element    //span[text()='Company']//ancestor::div[contains(@class,'form-element')]//span[@class='test-id__field-value slds-form-element__static slds-grow ']/span[text()='Academic Work HR Services Oy']
    page should contain element    //span[text()='Description']//ancestor::div[contains(@class,'form-element')]//span[text()='${desc}']
    page should contain element    //span[text()='Lead Reporter Email']//ancestor::div[contains(@class,'form-element')]//span[contains(@class,'test-id')]//a[text()='${email}']

validate_lead_after_conversion
    [Arguments]    ${fname}    ${lname}    ${email}    ${mobile}    ${title}    ${desc}
    page should contain element    //span[text()='Opportunity']//ancestor::div[@class="slds-box"]//a[text()='Lead_${fname}_${lname}']
    page should contain element    //span[text()='Opportunity']//ancestor::div[@class="slds-box"]//p[text()='Lead_${fname}_${lname}']
    page should contain element    //span[text()='Opportunity']//ancestor::div[@class="slds-box"]//*[text()='${close_date}']
    page should contain element    //span[text()='Contact']//ancestor::div[@class="slds-box"]//a[text()='Lead Contact']
    page should contain element    //span[text()='Contact']//ancestor::div[@class="slds-box"]//p[text()='${mobile}']
    page should contain element    //span[text()='Contact']//ancestor::div[@class="slds-box"]//p[text()='${lead_email}']
    page should contain element    //span[text()='Account']//ancestor::div[@class="slds-box"]//a[text()='${lead_account_name}']

Edit_and_Select_Contact
    [Arguments]    ${contact_name}
    scrolluntillfound    //button[@title='Edit Contact']
    click element    //button[@title='Edit Contact']
    wait until page contains element    //input[@placeholder='Search Contacts...']    30s
    input text    //input[@title='Search Contacts']    ${contact_name}
    wait until page contains element    //div[text()='${contact_name}']//ancestor::a    30s
    click element    //div[text()='${contact_name}']//ancestor::a
    click element    //button[@title="Save"]
    sleep    2s

UpdateAndAddSalesTypeandClickDirectOrder
    [Arguments]    ${products}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_list}=    Set Variable    //td[normalize-space(.)='${products}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    log to console    UpdateAndAddSalesType
    #sleep    30s
    #Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    wait until page contains element    ${update_order}    60s
    log to console    selected new frame
    wait until page contains element    ${product_list}    70s
    click element    ${product_list} //following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_list}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    click element    //label[normalize-space(.)='Direct Order' and @class='vlc-check-label ng-binding']/..//input
    sleep    2s
    click element    //button[normalize-space(.)='Next']
    unselect frame
    sleep    60s

openOrderFromDirecrOrder
    #select frame  //div[contains(@class,'iframe')]/iframe
    select frame   //div[@class="windowViewMode-normal oneContent active lafPageHost"]/div[@class="oneAlohaPage"]/force-aloha-page/div[contains(@class,'iframe')]/iframe
    #wait until page contains element   //span[text()='Click View Quote button to close this process & navigate to the Quote Screen.']    60s
    page should contain element  //button[@title='View Order']
    Click Visible Element  //button[@title='View Order']
    Sleep   20s
    unselect frame

OpenOrderPage
    Log to console      Open Order
    Reload page
    sleep   10s
    select frame    //iframe[@title='accessibility title'][@scrolling='yes']

    #${status}   set variable    Run Keyword and return status    Frame should contain    //button[contains(text(),'Open Order')]    Open Order
    Current frame should contain  Open Order
    set focus to element    //button[contains(text(),'Open Order')]
    wait until element is visible   //button[contains(text(),'Open Order')]    60s
    click element    //button[contains(text(),'Open Order')]
    unselect frame


getMultibellaCaseGUIID
    [Arguments]  ${order_no}
    go to entity  ${order_no}
    wait until page contains element    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']   60s
    click element     //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    wait until page contains element  //span[text()='Fulfilment Status']/../following-sibling::div/span/span  60s
    ${case_GUI_id}  get text  //span[text()='MultibellaCaseGuiId']/../..//span[@class='uiOutputText']
    ${case_id}  get text  //span[text()='MultibellaCaseId']/../..//span[@class='uiOutputText']
    should not be equal as strings  ${case_GUI_id}  ${EMPTY}
    should not be equal as strings  ${case_id}  ${EMPTY}
    log to console  ${case_GUI_id}.this is GUIId
    log to console  ${case_id} .this is case id
    [return]  ${case_GUI_id}


SwithchToUser
    [Arguments]  ${user}
    log to console   ${user}.this is user
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}    ${user}
    sleep  3s
    press key   xpath=${SEARCH_SALESFORCE}    \\13
    wait until page contains element    //a[text()='${user}']     45s
    #wait until page contains element  //span[@title='${user}']//following::div[text()='User']   30s
    #click element  //span[@title='${user}']//following::div[text()='User']
    click element  //a[text()='${user}']
    wait until page contains element  //div[@class='primaryFieldAndActions truncate primaryField highlightsH1 slds-m-right--small']//span[text()='${user}']  60s
    wait until page contains element  //div[text()='User Detail']   60s
    click element  //div[text()='User Detail']
    wait until page contains element  //div[@id="setupComponent"]   60s
    Wait until element is visible  //div[contains(@class,'iframe')]/iframe  60s
    select frame  //div[contains(@class,'iframe')]/iframe
    wait until page contains element  //td[@class="pbButton"]/input[@title='Login']   60s
    force click element  //td[@class="pbButton"]/input[@title='Login']
    sleep  2s
    unselect frame
    Reload page
    Execute Javascript    window.location.reload(true)
    #reload page
    wait until page contains element  //a[text()='Log out as ${user}']   60s
    page should contain element  //a[text()='Log out as ${user}']

logoutAsUser
    [Arguments]  ${user}
    [Documentation]     Logout through seetings button as direct logout is not available in some pages.
    ${setting_lighting}    Set Variable    //button[contains(@class,'userProfile-button')]
    sleep  20s
    #wait until page contains element  //a[text()='Log out as ${user}']   60s
    #${visible}   set variable   Run Keyword and return status   Wait Until Element Is Visible  //a[text()='Log out as ${user}']   30s
    #Log to console     status is  ${visible}
    #Run Keyword if   ${status}  force click element  //a[text()='Log out as ${user}']
    ${count}  set variable  Get Element Count   ${setting_lighting}
    Log to console  ${count}
    force click element   ${setting_lighting}
    wait until element is visible   //a[text()='Log Out']  60s
    click element  //a[text()='Log Out']
    sleep  10s



ChangeThePriceList
    [Arguments]    ${price_list_old}  ${price_list_new}
    ${B2B_Price_list_delete_icon}=    Set Variable    //span[@class='pillText'][contains(text(),'Standard Pricebook')]/following::span[@class='deleteIcon']
    log to console    this is to change the PriceList
    #sleep    30s
    #Execute JavaScript    window.scrollTo(0,600)
    #scroll page to element    //button[@title="Edit Price Book"]
    ScrollUntillFound    //button[@title="Edit Price List"]
    page should contain element  //span[text()='Price Book']//following::a[text()='Standard Price Book']
    click element    //button[@title="Edit Price List"]
    #sleep    10s
    wait until page contains element  //span[@class='pillText'][contains(text(),'${price_list_old}')]/following::span[@class='deleteIcon'][1]   20s
    click element    //span[@class='pillText'][contains(text(),'${price_list_old}')]/following::span[@class='deleteIcon'][1]
    sleep    3s
    input text    //input[@title='Search Price Lists']    ${price_list_new}
    sleep    3s
    click element    //*[@title='${price_list_new}']/../../..
    click element    //button[@title='Save']
    sleep    3s
    execute javascript    window.scrollTo(0,0)
    page should contain element  //span[@class='test-id__field-label' and text()='Price List']/../..//a[text()='${price_list_new}']
    sleep    3s


AddOppoTeamMember
    [Arguments]   ${oppo_name}      ${team_mem_1}
    #login to salesforce as digisales lightning user vlocupgsandbox
    #swithchtouser  Sales Admin
    #go to entity  ${vlocupg_test_account}
    #${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    #${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    #log to console    ${oppo_name}.this is opportunity
    go to entity  ${oppo_name}
    wait until page contains element  //span[@class='title' and text()='Related']  30s
    click element  //span[@class='title' and text()='Related']
    scrolluntillfound  //div[text()='Add Opportunity Team Members']
    wait until page contains element  //span[text()='Opportunity Team']   30s
    wait until page contains element  //div[text()='Add Opportunity Team Members']  30s
    force click element  //div[text()='Add Opportunity Team Members']
    wait until page contains element  //h2[text()='Add Opportunity Team Members']   30s
    wait until page contains element   //span[text()='Edit Team Role: Item 1']/..   30s
    force click element  //span[text()='Edit Team Role: Item 1']/..
    wait until page contains element  //a[@class='select' and text()='--None--']  30s
    force click element   //a[@class='select' and text()='--None--']
    wait until page contains element   //a[@title='Account Owner']   30s
    force click element  //a[@title='Account Owner']
    wait until page contains element  //span[text()='Edit User: Item 1']/..   30s
    force click element  //span[text()='Edit User: Item 1']/..
    sleep  3s
    wait until page contains element    //input[@title='Search People']   30s
    input text  //input[@title='Search People']   ${team_mem_1}
    sleep  3s
    wait until page contains element   //div[@title='${team_mem_1}']   30s
    force click element  //div[@title='${team_mem_1}']
    wait until page contains element   //span[text()='Edit Opportunity Access: Item 1']/..  30s
    force click element  //span[text()='Edit Opportunity Access: Item 1']/..
    sleep  3s
    wait until page contains element   //a[@class='select' and text()='Read Only']   30s
    force click element   //a[@class='select' and text()='Read Only']
    wait until page contains element   //a[@title='Read/Write']   30s
    force click element  //a[@title='Read/Write']
    wait until page contains element  //button[@title="Save"]  30s
    force click element  //button[@title="Save"]
    wait until page contains element   //a[@title='${team_mem_1}']   30s
    page should contain element   //a[@title='${team_mem_1}']
    #logoutAsUser  Sales Admin
    #login to salesforce as digisales lightning user vlocupgsandbox
    #swithchtouser  B2B DigiSales


clickingOnSolutionValueEstimate
    [Arguments]    ${c}=${oppo_name}
    log to console    ClickingOnSVE
    click element    xpath=//a[@title='Solution Value Estimate']
    #wait until page contains element    xpath=//h1[text()='${b}']    30s
    sleep    40s


addProductsViaSVE
     [Arguments]    ${pname_sve}=${product_name}
     log to console  ${pname_sve}.this is added via SVE
     select frame  xpath=//div[contains(@class,'slds')]/iframe
     force click element  //div[@class='btn custom-button btn-primary pull-right']
     sleep  5s
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@class='form-control ng-pristine ng-untouched ng-valid ng-empty']
     input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@class='form-control ng-pristine ng-untouched ng-valid ng-empty']    ${pname_sve}
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@type='number']
     input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@type='number']   ${product_quantity}
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model='p.OneTimeTotalt']
     input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model='p.OneTimeTotalt']   ${NRC}
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model='p.RecurringTotalt']
     input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model='p.RecurringTotalt']  ${RC}
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/select[@ng-model='p.SalesType']
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/select[@ng-model='p.SalesType']/option[@value='${sales_type_value}']
     #click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/select[@ng-model='p.ContractLength']/option[@value='${contract_lenght}']
     #click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/select[@ng-model='p.ContractLength']/option[@value='${contract_lenght}']
     ${fyr_value}=      evaluate  ((${RC}*${contract_lenght})+ ${NRC}) * ${product_quantity}
     ${revenue_value}=  evaluate  ((${RC}*${contract_lenght})+ ${NRC}) * ${product_quantity}
     page should contain element  //th[normalize-space(.)='FYR']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model="p.RecurringTotalt"]/../following-sibling::td[normalize-space(.)='${fyr_value}.00'][1]
     page should contain element  //th[normalize-space(.)='FYR']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model="p.RecurringTotalt"]/../following-sibling::td[normalize-space(.)='${revenue_value}.00'][2]
     click element  //button[normalize-space(.)='Save Changes']
     unselect frame
     sleep   30s
     [Return]   ${fyr_value}


ApproveB2BGTMRequest
    [Arguments]  ${Approver_name}  ${oppo_name}
    swithchtouser  ${Approver_name}
    Log to console  ${Approver_name} has to approve
    scrolluntillfound  //span[text()='Items to Approve']
    click element  //span[text()='Items to Approve']/ancestor::div[contains(@class,'card__header')]//following::a[text()='${oppo_name}']
    wait until page contains element   //span[text()='Opportunity Approval']  60s
    wait until element is visible  //div[text()='Approve']  60s
    click element  //div[text()='Approve']
    wait until page contains element  //h2[text()='Approve Opportunity']   30s
    wait until element is visible  //span[text()='Comments']/../following::textarea   30s
    #input text  //span[text()='Comments']/../following::textarea   1st level Approval Done By Leila
    input text  //span[text()='Comments']/../following::textarea   Approved
    click element  //span[text()='Approve']
    Log to console      approved
    logoutAsUser  ${Approver_name}
    sleep  10s
    login to salesforce as digisales lightning user vlocupgsandbox


openQuoteFromOppoRelated
    [Arguments]  ${oppo_no}  ${quote_no}
    go to entity  ${oppo_no}
    wait until page contains element  //span[@class='title' and text()='Related']  30s
    click element  //span[@class='title' and text()='Related']
    wait until page contains element  //span[text()='Opportunity Team']   30s
    scrolluntillfound  //a[text()='${quote_no}']
    click element  //a[text()='${quote_no}']
    #wait until page contains element  //span[text()='${quote_no}']/..//span[@class="uiOutputText"]   60s
    #page should contain element  //span[text()='${quote_no}']/..//span[@class="uiOutputText"]

SalesProjectOppurtunity

    [Arguments]  ${case_number}

    sleep  15s
    click element  //span[text()='${case_number}']//following::button[@title='Edit Subject']
    #wait until element is visible  //a[@class='select' and text()='New']   30
    #click element  //a[@class='select' and text()='New']
    #sleep  3s
    #click element  //a[@title="In Case Assessment"]
    ${date}  get date from future  7
    input text   //span[text()='Offer Date']/../following-sibling::div/input   ${date}
    force click element  //span[text()='Sales Project']/..//following-sibling::input[@type="checkbox"]
    Scroll Page To Location    0    1400
    wait until element is visible   //a[@class='select' and text()='--None--']
    force click element  //a[@class='select' and text()='--None--']
    click element  //a[@title='Sales Project']
    click element  //button[@title='Save']/span
    Log to console      Case Saved
    Scroll Page To Location    0    0
    wait until page contains element  //span[text()='Assign Support Resource' and @class="title"]   30s
    force click element  //span[text()='Assign Support Resource' and @class='title']
    wait until page contains element  //span[text()='Assigned Resource']  30s
    input text   //span[text()='Assigned Resource']/../following::input[@title="Search People"]   B2B DigiSales
    sleep  10s
    click element  //div[@title="B2B DigiSales"]
    #wait until element is visible  //a[@class='select' and text()='Solution Design']   20s
    #click element  //a[@class='select' and text()='Solution Design']
    sleep   10s
    #wait until element is visible   //div[@class='select-options']//ul//li[5]/a  60s
    #force click element  //div[@class='select-options']//ul//li[5]/a
    Select option from Dropdown with Force Click Element    //a[@class='select']   //div[@class='select-options']//ul//li[6]/a[@title='Sales Project']
    log to console      dropdown selected
    sleep  5s

    click element  //span[text()='Sales Support Case Lead']/../following::input[@type="checkbox"]
    scroll page to location  0  200
    wait until page contains element  //div[@class='bottomBarRight slds-col--bump-left']//span[text()="Save"][1]/..  20s
    wait until element is visible  //div[@class='bottomBarRight slds-col--bump-left']//span[text()="Save"][1]/..  20s
    click element  //div[@class='bottomBarRight slds-col--bump-left']//span[text()="Save"][1]/..
    capture page screenshot
    Log to console      enter comments
    sleep   10s
    Force click element     //span[text()='Comment']
    Input Text      //textarea[@class=' textarea']      Test Comments
    Log to console      save comments
    sleep   10s
    Force click element  //button[@class='slds-button slds-button--brand cuf-publisherShareButton MEDIUM uiButton']/span
    sleep   10s
    Wait until element is visible   //span[text()='Commit Decision']    60s
    Force click element  //span[text()='Commit Decision']
    sleep   15s
    Wait until element is visible   //button[@title='Next']     30s
    force click element  //button[@title='Next']

ContractStateMessaging
    log to console    NextButtonOnOrderPage
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    Log to console      Inside frame

    wait until page contains element   //button[@class="form-control btn btn-primary ng-binding" and normalize-space(.)='Open Order']
    Log to console      Element found
    click element  //button[@class="form-control btn btn-primary ng-binding" and normalize-space(.)='Open Order']
    unselect frame
    sleep    30s

openAssetviaOppoProductRelated
    [Arguments]    ${account_name}
    scrolluntillfound    //div[@data-aura-class="forceOutputLookupWithPreview"]/a[text()='Telia Colocation']
    click element    //div[@data-aura-class="forceOutputLookupWithPreview"]/a[text()='Telia Colocation']
    sleep    10s
    #wait until page contains element    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Related']    60s
    click element    //Span[text()='Offering ID']/ancestor::div[contains(@class,'uiTabset flexipageTabset')]//following::span[text()='Related']
    sleep    3s
    click element    //a[text()='Telia Colocation']//following::td[2]/a[@title='${account_name}']/../../th
    wait until page contains element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Asset Name']/../following-sibling::div/span/span    60s
    page should contain element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Asset Name']/../following-sibling::div/span/span
    page should contain element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Product']/../following-sibling::div/span/div/a[text()='Telia Colocation']
    click element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Status']/../..//following::button[@title='Edit Status']
    sleep    10s
    click element    //Span[text()='Status']//following::div[@class="uiMenu"]/div[@data-aura-class="uiPopupTrigger"]/div/div/a[@class='select' and text()='Inactive']
    click element    //a[@title='Active']
    click element    //span[text()='Save']/..
    sleep    5s
    scrolluntillfound    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Commercial ID']/../following-sibling::div/span/span
    ${commercial_id}    get text    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Commercial ID']/../following-sibling::div/span/span
    [Return]    ${commercial_id}

clickChangeToOrderViaAccount
    [Arguments]    ${cid}
    log to console    ${cid}.cid receioved
    execute javascript    window.scrollTo(0,2700)
    #scrolluntillfound    //span[text()='Asset History']
    select frame    xpath=//force-aloha-page[@title="AssetHistoryAndMACD"]/div/iframe
    wait until page contains element    //div[@class="p-name"]/a[text()='Telia Colocation']/ancestor::div[@class="asset ng-scope"]//following::div[@class="p-info ng-scope"]/div[@class="p-name"]/a[text()='Telia Colocation']/ancestor::div[@class="p-asset ng-scope"]//following::div[@ng-repeat="column in cols"]/div[@data-title="${cid}"]/ancestor::div[@class="asset ng-scope"]//following::div[@class="p-asset ng-scope"]/div[text()='Active']/ancestor::div[@class="asset ng-scope"]/div[@class="p-check"]    60s
    click element    //div[@class="p-name"]/a[text()='Telia Colocation']/ancestor::div[@class="asset ng-scope"]//following::div[@class="p-info ng-scope"]/div[@class="p-name"]/a[text()='Telia Colocation']/ancestor::div[@class="p-asset ng-scope"]//following::div[@ng-repeat="column in cols"]/div[@data-title="${cid}"]/ancestor::div[@class="asset ng-scope"]//following::div[@class="p-asset ng-scope"]/div[text()='Active']/ancestor::div[@class="asset ng-scope"]/div[@class="p-check"]
    click element    //button[@type='submit']
    sleep    60s
    unselect frame

ChangeOrderSelectTechnicalContact
    [Arguments]    ${c}
    Execute Javascript    window.location.reload(true)
    sleep    20s
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    input text    //*[@id="ContactName"]    ${c}
    click element    //*[@id="SearchContactByName"]
    sleep    2s
    click element    //*[@id="ContactList"]/div/ng-include/div/table/tbody/tr/td[1]
    sleep    2s
    click element    //*[@id="OrderContact"]/div/ng-include/div/table/tbody/tr/td[1]
    #//*[@id="ContactList"]//following::label[normalize-space(.)='Enter Order Contact Details']//following::tbody/tr/td[@data-label="Type"]/div[text()='${c}']/../ancestor::tr[@class="ng-scope"]/td/label/input/following-sibling::span
    click element    //*[@id="Select Contact_nextBtn"]
    sleep    20s
    #unselect frame

ChangeOrderRequestActionDate
    log to console    selecting Request Date FLow chart page
    wait until page contains element    //*[@id="RequestDate"]    30s
    click element    //*[@id="RequestDate"]
    ${date_requested}=    GetDateinMMDDYYYY    7
    input text    //*[@id="RequestDate"]    ${date_requested}
    sleep    5s
    click element    //*[@id="Request Date_nextBtn"]

GetDateinMMDDYYYY
    [Arguments]    ${y}
    ${date}=    Get Current Date
    ${date_in_future}=    Add Time To Date    ${date}    ${y} days
    ${converted_date}=    Convert Date    ${date_in_future}    result_format=%m-%d-%Y
    [Return]    ${converted_date}

ChangeOrderRequestActionDateAdditionalData
    sleep    10s
    Execute Javascript    window.location.reload(true)
    sleep    20s
    #select frame    //div[contains(@class,'slds')]/iframe
    #wait until page contains element    //*[@id="RequestedActionDate"]    30s
    click element    //*[@id="RequestedActionDate"]
    ${date_requested}=    GetDateinMMDDYYYY    8
    input text    //*[@id="RequestedActionDate"]    ${date_requested}
    sleep    3s
    click element    //*[@id="Additional data_nextBtn"]
    #unselect frame

AddandRemoveProductsfromCart
    sleep    20s
    #wait until page contains element    //div[normalize-space(.) = 'Telia Colocation']/ancestor::div[@class="cpq-item-base-product"]/div[4]/div[text()='Existing']    20s
    #select frame    //div[contains(@class,'slds')]/iframe
    page should contain element    //div[normalize-space(.) = 'Telia Colocation']/ancestor::div[@class="cpq-item-base-product"]/div[4]/div[text()='Existing']
    log to console    a
    click element    //div[normalize-space(.) = 'Additional PDU for 52 RU']/ancestor::div[@class="cpq-item-base-product"]/div[contains(@class,"slds-text-align_right")]/button[normalize-space(.)='Add to Cart']
    log to console    aa
    sleep    10s
    wait until page contains element    //div[normalize-space(.) = 'Additional PDU for 52 RU']/ancestor::div[@class="cpq-item-base-product"]/div[4]/div[text()='Add']    30s
    log to console    aaa
    sleep    10s
    click element    //span[text()='Next']
    sleep    30s
    #unselect frame
    log to console    this is addand removing prod close here.
    #force click element    //div[normalize-space(.) = 'Dedicated data hall']/ancestor::div[@class="cpq-item-base-product"]/div[@class='cpq-item-base-product-actions slds-text-align_right']/div/button[@title='Delete Item']
    #log to console    aaabbb
    #sleep    10s
    #wait until page contains element    //button[text()='Delete']
    #log to console    aaa
    #sleep    10s
    #click element    //button[text()='Delete']
    #log to console    aaa
    #sleep    10s
    #wait until page contains element    //div[normalize-space(.) = 'Dedicated data hall']/ancestor::div[@class="cpq-item-base-product"]/div[4]/div[text()='Disconnect']    30s

ChangeOrderSearchandSelectAccount
    [Arguments]    ${search_acc}
    click element    //*[@id="ExtractAccount"]
    wait until page contains element    //div[text()='${search_acc}']/ancestor::tr/td[@data-label='Select']/label/input    30s
    click element    //div[text()='${search_acc}']/ancestor::tr/td[@data-label='Select']/label/input
    click element    //*[@id="SearchAccount_nextBtn"]
    sleep    30s

ChangeOrderSelectOwnerAccountInfo
    [Arguments]    ${o}
    wait until page contains element    //div[text()='${o}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']    30s
    click element    //div[text()='${o}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    click element    //*[@id="BuyerIsPayer"]//following-sibling::span
    click element    //*[@id="SelectedBuyerAccount_nextBtn"]

ChangeOrderReviewPage
    wait until page contains element    //*[@id="SubmitInstruction"]/div/p/h3/strong[contains(text(),'successfully')]    30s
    click element    //*[@id="DecomposeOrder"]
    log to console    Exiting Review page

ValidateTheOrchestrationPlan
    ${order_number}   get text  //div[@class='slds-page-header__title slds-m-right--small slds-align-middle fade-text']/span
    log to console  ${order_number}.this is order numner
    scrolluntillfound    //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]
    #execute javascript    window.scrollTo(0,2000)
    #sleep    10s
    log to console    plan validation
    wait until page contains element     //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]    30s
    click element     //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]
    sleep    10s
    select frame    xpath=//*[@title='Orchestration Plan View']/div/iframe[1]
    sleep    20s
    Element should be visible    //a[text()='Start']
    Element should be visible    //a[text()='Assetize Order']
    Element should be visible    //a[text()='Deliver Service']
    Element should be visible    //a[text()='Order Events Update']
    Element should be visible   //a[text()='Activate Billing']
    #go back
    sleep   3s
    #click element  //th/div[@data-aura-class="forceOutputLookupWithPreview"]/a[@data-special-link="true" and text()='Telia Colocation']
    [Return]  ${order_number}
    unselect frame

CreateBusinessAccount
    wait until page contains element    //a[@title='Accounts']    60s
    force click element    //a[@title='Accounts']
    wait until page contains element    //a[@title='Import']/../../li/a/div[text()='New']    30s
    #Execute javascript    document.querySelector("//div[@data-scoped-scroll='true']").scrollTop=500;
    click element    //a[@title='Import']/../../li/a/div[text()='New']
    wait until page contains element    //label[@class="slds-radio"]/div/span[@class='slds-radio--faux']//following::div/span[text()='Billing']/..    30s
    Execute JavaScript    window.document.getElementsByClassName('modal-body scrollable slds-modal__content slds-p-around--medium')[0].scrollTop += 250
    wait until page contains element    //label[@class="slds-radio"]/div/span[@class='slds-radio--faux']//following::div/span[text()='Business']/..    30s
    click element    //label[@class="slds-radio"]/div/span[@class='slds-radio--faux']//following::div/span[text()='Business']/..
    click element    //button/span[text()='Next']
    wait until page contains element    //label/span[text()='Business ID']/../..//input    30s
    ${a}=    Generate Random String    7    [NUMBERS]
    ${b}=    Generate Random String    1    [NUMBERS]
    input text    //label/span[text()='Business ID']/../..//input    ${a}-${b}
    ${business_acc_name}    create unique name    Business_
    input text    //label/span[text()='Account Name']/../..//input    ${business_acc_name}
    ${telia_cust_id}=    Generate Random String    10    [NUMBERS]
    input text    //label/span[text()='Telia Customer ID']/../..//input    ${telia_cust_id}
    ${aida_id}=    Generate Random String    7    [NUMBERS]
    input text    //label/span[text()='AIDA ID']/../..//input    ${aida_id}
    input text    //label/span[text()='Phone']/../..//input    +35819346440
    input text    //label/span[text()='Marketing Name']/../..//input    TestBusiness_${business_acc_name}
    scrolluntillfound    //span[@data-aura-class="uiPicklistLabel"]/span[text()='Legal Status']/../../div/div[@data-aura-class="uiPopupTrigger"]/div/div/a
    click element    //span[@data-aura-class="uiPicklistLabel"]/span[text()='Legal Status']/../../div/div[@data-aura-class="uiPopupTrigger"]/div/div/a
    click element    //a[@title="Active"]
    click element    //button[@title='Save']/span[text()='Save']
    [Return]    ${business_acc_name}

openOnlinePortal
    [Arguments]    ${username}=b2o-purchaser@mailinator.com    ${password}=PaSsw0rd321
    Go To    https://ui.int.id.telia.fi/mytelia/wholesale
    Wait Until Keyword Succeeds    60s    1 second    Location Should Be    https://www.dev.telia.fi/mytelia/login
    wait until element is visible    //span[text()='Credentials']    60s
    click element    //span[text()='Credentials']
    Wait Until Element Is Visible    id=email-input    60s
    Wait Until Element Is Visible    //input[@type='password']    60s
    input text    id=email-input    ${username}
    input text    //input[@type='password']    ${password}
    wait until element is enabled    //button[@type='submit']    20s
    click element    //button[@type='submit']
    wait until page contains element    //h1[text()='Welcome to Shop For Operators']    60s

clickOnOfferingTab
    wait until page contains element    //span[text()='Offering']    30s
    click element    //span[text()='Offering']
    wait until page contains element    //h1[text()='Telia Offering']    30s

Create case from more actions

    wait until page contains element  //a[contains(@title, 'more actions')][1]   30s
    force click element  //a[contains(@title, 'more actions')][1]
    capture page screenshot
    wait until element is visible   //div/div[@role="menu"]//a[@title="B2B Sales Expert Request"][1]/..   30s
    #page should contain element   //div/div[@role="menu"]//a[@title="B2B Sales Expert Request"][1]/..
    force click element   //a[@title="B2B Sales Expert Request"]/div
    wait until page contains element  //span[text()='Subject']/../following-sibling::input   60s
    ${case_number}=    Generate Random String    7    [NUMBERS]
    input text  //span[text()='Subject']/../following-sibling::input   ${case_number}
    Force click element  //span[text()='Subscriptions and Networks']/../following::input[1]
    ${date}=    Get Date From Future    7
    input text   //span[text()='Offer Date']/../following::div[@class='form-element']/input   ${date}
    scroll element into view  //span[text()='Type of Support Requested']/../following::textarea
    input text  //span[text()='Type of Support Requested']/../following::textarea   Dummy Text
    Scroll Page To Location  0  200
    #scroll element into view  //span[text()='Sales Project']/../following::input[1]
    click element  //span[text()='Sales Project']/../following::input[1]
    wait until element is visible   //button[@class='slds-button slds-button_brand cuf-publisherShareButton undefined uiButton']//span[text()='Save']   60s
    click element  //button[@class='slds-button slds-button_brand cuf-publisherShareButton undefined uiButton']//span[text()='Save']
    [Return]    ${case_number}

createACaseFromMore
    [Arguments]    ${oppo_name}   ${case_type}

    log to console   ${case_type}.this is case type..${oppo_name}
    Click element   //span[text()='More']
    sleep   30s
    ${status}  set variable     run keyword and return status   page should contain  //a[@href="/lightning/o/Case/home"][@role='menuitemcheckbox']
    log to console      ${status}
    force Click Element   //a[@href="/lightning/o/Case/home"][@role='menuitemcheckbox']
    sleep  3s
    Click Element   //div[text()='New']
    wait until page contains element  //h2[text()='New Case']   60s
    force click element  //span[text()='${case_type}']/../preceding-sibling::div
    click element  //span[text()='Next']/..
    wait until page contains element  //h2[text()='New Case: B2B Sales Expert Request']   60s
    ${case_number}=    Generate Random String    7    [NUMBERS]
    wait until page contains element  //span[text()='Subject']/../following-sibling::input   60s
    input text  //span[text()='Subject']/../following-sibling::input   ${case_number}
    click element   //input[@title='Search Opportunities']
    Input Text  //input[@title='Search Opportunities']   ${oppo_name}
    sleep   10s
    Wait until page contains element    //div[@title='${oppo_name}'][@class='primaryLabel slds-truncate slds-lookup__result-text']  60s
    scroll element into view    //div[@title='${oppo_name}'][@class='primaryLabel slds-truncate slds-lookup__result-text']
    Set focus to element    //div[@title='${oppo_name}'][@class='primaryLabel slds-truncate slds-lookup__result-text']
    Wait until element is visible  //div[@title='${oppo_name}'][@class='primaryLabel slds-truncate slds-lookup__result-text']   30s
    ${count}  set variable  Get Element Count   //div[@title='${oppo_name}'][@class='primaryLabel slds-truncate slds-lookup__result-text']
    Log to console  ${count}
    force click element   //div[@title='${oppo_name}'][@class='primaryLabel slds-truncate slds-lookup__result-text']
    #scrolluntillfound  //label/span[text()='Type of Support Requested']
    #Execute JavaScript  window.document.getElementsByClassName('modal-body scrollable slds-modal__content slds-p-around--medium')[0].scrollTop += 250
    #scroll element into view  //label/span[text()='Type of Support Requested']
    input text   //span[text()='Opportunity Value Estimate (€)']/../following-sibling::input   532
    input text   //span[text()='Opportunity Description']/../following-sibling::textarea  Testing Description
    input text   //span[text()='Type of Support Requested']/../following::textarea   Dummy Text
    Log to console  to save
    click element  //button[@title='Save']
    [Return]    ${case_number}


createACaseFromOppoRelated
    [Arguments]    ${oppo_name}   ${case_type}
    log to console   ${case_type}.this is case type..${oppo_name}
    go to entity  ${oppo_name}
    reload page
    sleep  2s
    wait until page contains element  //a[@title='Related']   60s
    force click element  //a[@title='Related']
    #wait until page contains element  //span[text()='Test Reporting Products']   60s
    scrolluntillfound  //span[text()='Cases']//ancestor::div[contains(@class,'slds-card')]//following::div[@class='slds-truncate'][1]
    click element  //span[text()='Cases']//ancestor::div[contains(@class,'slds-card')]//following::div[@class='slds-truncate'][1]
    wait until page contains element  //h2[text()='New Case']   60s
    force click element  //span[text()='${case_type}']/../preceding-sibling::div
    click element  //span[text()='Next']/..
    wait until page contains element  //h2[text()='New Case: B2B Sales Expert Request']   60s
    ${case_number}=    Generate Random String    7    [NUMBERS]
    wait until page contains element  //span[text()='Subject']/../following-sibling::input   60s
    input text  //span[text()='Subject']/../following-sibling::input   ${case_number}
    click element   //input[@title='Search Opportunities']
    wait until page contains element    //div[@title='${oppo_name}']
    click element   //div[@title='${oppo_name}']
    #scrolluntillfound  //label/span[text()='Type of Support Requested']
    #Execute JavaScript  window.document.getElementsByClassName('modal-body scrollable slds-modal__content slds-p-around--medium')[0].scrollTop += 250
    #scroll element into view  //label/span[text()='Type of Support Requested']
    input text   //span[text()='Opportunity Value Estimate (€)']/../following-sibling::input   532
    input text   //span[text()='Opportunity Description']/../following-sibling::textarea  Testing Description
    input text   //span[text()='Type of Support Requested']/../following::textarea   Dummy Text
    #scroll element into view  //span[text()='Sales Project']/../following-sibling::input
    #click element   //span[text()='Sales Project']/../following-sibling::input
    click element  //span[text()='Save']/..scroll page to location
    [Return]    ${case_number}


click on more actions
    wait until page contains element  //a[contains(@title, 'more actions')][1]   30s
    force click element  //a[contains(@title, 'more actions')][1]
    capture page screenshot
