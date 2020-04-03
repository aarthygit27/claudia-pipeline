*** Settings ***
Library           Collections
Resource          ..${/}resources${/}common.robot
Resource          ..${/}resources${/}cpq_keywords.robot
Resource          ..${/}resources${/}sales_app_light_variables.robot
Resource          ..${/}resources${/}multibella_keywords.robot
Library             ../resources/customPythonKeywords.py

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
    sleep  20s
    wait until page contains element   ${APP_SEARCH}   60s
    input text      ${APP_SEARCH}       Sales
    press enter on    ${APP_SEARCH}
    sleep  30s
    Wait Until Element is Visible    ${SALES_APP_NAME}    60s

Login Page Should Be Open
    [Documentation]    To Validate the elements in Login page
    Wait Until Keyword Succeeds    60s    1 second    Location Should Be    ${LOGIN_PAGE}
    Wait Until Element Is Visible    id=username    60s
    Wait Until Element Is Visible    id=password    60s

Go To Salesforce and Login into Lightning
    [Arguments]    ${user}
    [Documentation]    Go to Salesforce and then Login as DigiSales Lightning User, then switch to Sales App
    ...    and then select the Home Tab in Menu
    Go to Salesforce
    Sleep    20s
    Run Keyword    Login to Salesforce as ${user}
    Go to Sales App
    Reset to Home
    Click Clear All Notifications
    Sleep    30s
    ${error}=    Run Keyword And Return Status    Element Should Be Visible    ${errorpopup}
    Run Keyword If    ${error}    click button      ${errorok}

Login to Salesforce as B2B DigiSales
    [Arguments]    ${username}=${B2B_DIGISALES_LIGHT_USER}    ${password}=${Password_merge}
    Login To Salesforce Lightning    ${username}    ${password}

Login to Salesforce as System Admin
    [Arguments]        ${username}= ${SYSTEM_ADMIN_USER}   ${password}= ${SYSTEM_ADMIN_PWD}  #${username}=mmw9007@teliacompany.com.release    #${password}=Sriram@234
    Login To Salesforce Lightning    ${username}    ${password}

Login to Salesforce as DigiSales Admin
    Login To Salesforce Lightning    ${SALES_ADMIN_APP_USER}   ${PASSWORD-SALESADMIN}

Login to Salesforce as Pricing Manager
    Login To Salesforce Lightning    ${PM_User}  ${PM_PW}

Login to Salesforce as B2O User
    [Arguments]    ${username}= ${B2O_DIGISALES_LIGHT_USER}    ${password}= ${B2O_DIGISALES_LIGHT_PASSWORD}
    Login To Salesforce Lightning    ${username}    ${password}

Login to Salesforce Lightning
    [Arguments]    ${username}    ${password}
    #log to console    ${password}
    Wait Until Page Contains Element    id=username    240s
    Input Text    id=username    ${username}
    Sleep    5s
    Input text    id=password    ${password}
    Click Element    id=Login
    #${homepage}=    Run Keyword And Return Status    Wait Until Page Contains Element    //a//span[text()="Home"]    60s
    #Run Keyword unless    ${homepage}    reload page
    #Run Keyword unless    ${homepage}    sleep  30s
    sleep  45s
    ${infoAvailable}=    Run Keyword And Return Status    element should be visible    ${remindmelater}
    Run Keyword If    ${infoAvailable}    force click element    ${remindmelater}
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
    sleep       20s
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
    Click Element   ${TABLE_HEADER}${element_catenate}
    #force click element  //div[@class="scroller actionBarPlugin"]//a[text()="${target_name}"]
    Sleep    25s
    Wait Until Page Contains element    //h1//*[text()='${target_name}']    60s
    ${ISOpen}=    Run Keyword And Return Status    Entity Should Be Open    //h1//*[text()='${target_name}']
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
    \    Exit For Loop If    ${status}
    \    Execute JavaScript    window.scrollTo(0,${i}*200)

Verify That Opportunity Is Saved And Data Is Correct
    [Arguments]    ${element}    ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    ${oppo_name}=    Set Variable    //*[text()='${OPPORTUNITY_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']/../..//a[text()='${LIGHTNING_TEST_ACCOUNT}']
    ${oppo_date}=    Set Variable    //span[text()='Close Date']/../..//lightning-formatted-text[text()='${OPPORTUNITY_CLOSE_DATE}']
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
    ${account_name}=    Set Variable    //span[text()='Account Name']/../..//a[text()='${LIGHTNING_TEST_ACCOUNT}']
    ${oppo_date}=    Set Variable    //span[text()='Close Date']/../..//lightning-formatted-text[text()='${date}']
    Open Tab    Opportunities
    Select Correct View Type    My All Open Opportunities
    Filter Opportunities By    Opportunity Name    ${OPPORTUNITY_NAME}
    Sleep    10s
    Wait Until Page Contains Element    ${OPPORTUNITY_PAGE}${oppo_name}    60s
    Wait Until Page Contains Element    ${account_name}    60s
    Wait Until Page Contains Element    ${oppo_date}    60s


Verify That Opportunity is Found From My All Opportunities
    [Arguments]    ${OPPORTUNITY_NAME}
    Open Tab    Opportunities
    Select Correct View Type  All Opportunities
    Filter Opportunities By    Opportunity Name    ${OPPORTUNITY_NAME}

Open tab
    [Arguments]    ${tabName}    ${timeout}=60s
    Wait Until Element is Visible    //a[@title='${tabName}']    60s
    Click Element    //a[@title='${tabName}']
    Sleep    10s

Select Correct View Type
    [Arguments]    ${type}
    Sleep    20s
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
    click element  //div[@role="listbox"]//div[@role="option"]/lightning-icon//lightning-primitive-icon/*[@data-key="search"]
    ${count}=    Get Element Count      //*[text()='Sorry to interrupt']
    ${IsErrorVisible}=    Run Keyword And Return Status        element should not be visible      //*[text()='Sorry to interrupt']
    Sleep   2s
    #log to console          ${IsErrorVisible}
    Run Keyword unless  ${IsErrorVisible}    Click Element       //button[@title='OK']
    #Press Enter On   ${field}
    Sleep   5s
    Click Visible Element    //div[@data-aura-class="forceSearchResultsGridView"]//a[@title='${value}']
    Sleep    2s

Select from Autopopulate List
    [Arguments]    ${field}    ${value}
    Input Text    ${field}    ${value}
    Sleep    20s
    Click element    //div[@title='${value}']/../../../a

Validate Master Contact Details
    ${contact_name}=    Set Variable    //span[text()='Name']/../..//span//*[text()='${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']/../..//a[text()='${MASTER_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']/../..//span//*[text()='${MASTER_MOBILE_NUM}']
    ${phone_number}=    Set Variable    //span[text()='Phone']//following::span//*[text()='${MASTER_PHONE_NUM}']
    ${primary_email}=    Set Variable    //span[text()='Primary eMail']/../..//a[text()='${MASTER_PRIMARY_EMAIL}']
    ${email}=    Set Variable           //span[text()='Email']/../..//a[text()='${MASTER_EMAIL}']
    Go to Entity    ${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}
    Click Visible element    ${DETAILS_TAB}
    Validate Contact Details    ${CONTACT_DETAILS}    ${contact_name}    ${account_name}    ${mobile_number}    ${primary_email}    ${email}
    #Wait Until Page Contains Element    ${element}${phone_number}
    #Wait Until Page Contains Element    ${element}${email}

Validate Contact Details
    [Arguments]    ${element}    ${contact_name}    ${account_name}    ${mobile_number}   ${primary_email}  ${email}
    Wait Until Page Contains Element    ${contact_name}    240s
    Wait Until Page Contains Element    ${account_name}    240s
    Wait Until Page Contains Element    ${mobile_number}    240s
    Wait Until Page Contains Element    ${primary_email}    240s
    Wait Until Page Contains Element    ${email}            240s

Validate NP Contact Details
    [Arguments]    ${element}    ${contact_name}    ${account_name}    ${mobile_number}   ${email}
    Wait Until Page Contains Element    ${contact_name}    240s
    Wait Until Page Contains Element    ${account_name}    240s
    Wait Until Page Contains Element    ${mobile_number}    240s
    Wait Until Page Contains Element    ${email}            240s

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

Validate NP Contact
    ${contact_name}=    Set Variable    //span[text()='Name']/../..//*[text()='Non-person ${NP_FIRST_NAME} ${NP_LAST_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']/../..//a[text()='${NP_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']/../..//span//*[text()='${NP_MOBILE_NUM}']
    ${email}=    Set Variable    //span[text()='Email']/../..//a[text()='${NP_EMAIL}']
    Go to Entity    Non-person ${NP_FIRST_NAME} ${NP_LAST_NAME}
    Click Visible Element    ${DETAILS_TAB}
    Validate NP Contact Details    ${CONTACT_DETAILS}    ${contact_name}    ${account_name}    ${mobile_number}     ${email}

Create New Contact for Account
    ${first_name}=    Run Keyword    Create Unique Name    ${EMPTY}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${mobile_num}=    Run Keyword    Create Unique Mobile Number
    Set Test Variable    ${AP_FIRST_NAME}    AP ${first_name}
    Set Test Variable    ${AP_LAST_NAME}    Test ${first_name}
    Set Test Variable    ${AP_EMAIL}    ${email_id}
    Set Test Variable    ${AP_MOBILE_NUM}    ${mobile_num}
    Set Test Variable    ${Ap_mail}     ${email_id}
    Wait Until Page Contains element    xpath=${AP_NEW_CONTACT}    60s
    click element    ${AP_NEW_CONTACT}
    #Sleep    2s
    Wait Until Page Contains element    xpath=${AP_MOBILE_FIELD}    60s
    Click Visible Element    ${AP_MOBILE_FIELD}
    Input Text    ${AP_MOBILE_FIELD}    ${AP_MOBILE_NUM}
    Input Text    ${FIRST_NAME_FIELD}    ${AP_FIRST_NAME}
    Input Text    ${LAST_NAME_FIELD}    ${AP_LAST_NAME}
    Input Text    ${MASTER_PRIMARY_EMAIL_FIELD}    ${AP_EMAIL}
    Input Text    ${MASTER_EMAIL_FIELD}     ${Ap_mail}
    Click Element    ${AP_SAVE_BUTTON}
    Sleep    5s
    [Return]    ${AP_FIRST_NAME} ${AP_LAST_NAME}

Validate AP Contact Details
    Go To Entity    ${AP_FIRST_NAME} ${AP_LAST_NAME}    ${SEARCH_SALESFORCE}
    ${contact_name}=    Set Variable    //span[text()="Name"]/../../div[2]//*[text()='${AP_FIRST_NAME} ${AP_LAST_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']/../..//a[text()='${AP_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']/../..//span//*[text()='${AP_MOBILE_NUM}']
    ${Primary email}=    Set Variable    //span[text()='Primary eMail']/../..//a[text()='${AP_EMAIL}']
    ${mail}=             Set Variable    //span[text()='Email']/../..//a[text()='${Ap_mail}']
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
    #Input Text    ${external_phone}         ${externalphoneno}
    wait until page contains element        ${external_phone}       5s
    wait until page contains element        ${external_title}       5s
    wait until page contains element        ${external_eMail}       5s
    wait until page contains element        ${external_status}       5s
    wait until page contains element        ${external_office_name}       5s
    wait until page contains element        ${external_address}       5s
    wait until page contains element        ${contact_id}       5s
    wait until page contains element        ${ulm_id}       5s
    wait until page contains element        ${external_id}       5s
    sleep       10s

Create new contact with external data
    ${first_name}=    Run Keyword    Create Unique Name    ${EMPTY}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${mobile_num}=    Run Keyword    Create Unique Mobile Number
    ${present}=    Run Keyword And Return Status    Element Should Be Visible    ${CLOSE_NOTIFICATION}
    ${external_phone_field}    Set Variable    xpath=//span[text()='External Phone']/../../input
    ${external_title_field}    Set Variable    xpath=//span[text()='External Title']/../../input
    ${external_eMail_field}    Set Variable    xpath=//span[text()='External eMail']/../../input
    ${external_status_field}    Set Variable    xpath=//span[text()='External Status']//following::a
    ${external_office_name_field}    Set Variable    xpath=//span[text()='External Office Name']/../../input
    ${ulm_id_field}    Set Variable    xpath=//span[text()='ULM id']/../../input
    ${external_id_field}    Set Variable    xpath=//span[text()='External_id']/../../input
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
    Input text          ${external_phone_field}           ${externalphoneno}
    Input text      ${external_title_field}       ${externaltitle}
    Input text      ${external_eMail_field}       ${externaleMail}
    #Select option from Dropdown     ${external_status_field}     Active
    Input text     ${external_office_name_field}       ${externalofficename}
    Input text      ${ulm_id_field}     ${ulmid}
    Input text          ${external_id_field}       ${externalid}
    Click Element       ${SAVE_BUTTON}
    Sleep    10s


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
    ...    ELSE    element should not be visible   //a[@title='New Opportunity']

Cancel Opportunity and Validate
    [Arguments]    ${opportunity}    ${stage}
    Go to Entity    ${opportunity}
#    Input Text    xpath=${SEARCH_SALESFORCE}    ${opportunity}
#    Sleep    2s
#    Press Enter On    ${SEARCH_SALESFORCE}
#    Sleep       60s
#    Wait Until Page Contains element    //h1//span[text()='${opportunity}']    400s
#    Entity Should Be Open    //h1//span[text()='${opportunity}']
    click visible element    ${EDIT_STAGE_BUTTON}
    sleep    5s
    Select option from Dropdown    //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   ${stage}
    #click visible element    //div[@class="uiInput uiInput--default"]//a[@class="select"]
    #Press Key    //div[@class="uiInput uiInput--default"]//a[@class="select"]    ${stage}
    #Click Element    //a[@title="${stage}"]
    Sleep  30s
    Click element   //button[@title="Save"]
    Sleep  10s
    Validate error message
    Cancel and save
    Validate Closed Opportunity Details    ${opportunity}    ${stage}
    Verify That Opportunity is Not Found under My All Open Opportunities    ${opportunity}

Move the Opportunity to next stage
    [Arguments]    ${opportunity}    ${stage1}  ${stage2}
    ${current_stage}=    set variable    //div[contains(@class,'test-id__field')]/span[contains(text(),'Stage')]/../../div/span[contains(@class,'field-value')]
    Go to Entity    ${opportunity}
    ${stage}=    Get Text    ${current_stage}
    log to console   ${stage}
    log to console   Move tha opportunity from ${stage} to ${stage1}
    click visible element    ${EDIT_STAGE_BUTTON}
    Sleep  10s
    Select option from Dropdown    //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div    ${stage1}
    Sleep  10s
    Click element   //button[text()="Save"]
    sleep  5s
    ${stage}=    Get Text    ${current_stage}
    log to console   ${stage}
    log to console   Move tha opportunity from ${stage1} to ${stage2}
    click visible element    ${EDIT_STAGE_BUTTON}
    Select option from Dropdown    //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   ${stage2}
    Sleep  10s
    Click element   //button[text()="Save"]
    Sleep  10s
Validate Closed Opportunity Details
    [Arguments]    ${opportunity_name}    ${stage}
    #${current_date}=    Get Current Date    result_format=%d.%m.%Y
    ${current_ts}=    Get Current Date
    ${c_date} =    Convert Date    ${current_ts}    datetime
    ${oppo_close_date}=    Set Variable    //div//span[text()='Close Date']/../../div[2]/span//lightning-formatted-text[text()='${c_date.day}.${c_date.month}.${c_date.year}']
    Go to Entity    ${opportunity_name}
    Scroll Page To Element    ${oppo_close_date}
    Wait Until Page Contains Element    ${oppo_close_date}    60s
    #Scroll Page To Element    ${OPPORTUNITY_CLOSE_DATE}
    #Wait Until Page Contains Element    ${OPPORTUNITY_CLOSE_DATE}    60s
    Wait Until Page Contains Element    //div//div/span[text()="Stage"]/../../div[2]/span//lightning-formatted-text[text()="${stage}"]    60s
    ${oppo_status}=    set variable if    '${stage}'== 'Closed Lost'    Lost    Cancelled
    ${buttonNotAvailable}=    Run Keyword And Return Status    element should not be visible    ${EDIT_STAGE_BUTTON}
    Run Keyword If    ${buttonNotAvailable}    reload page
    Click Visible Element    ${EDIT_STAGE_BUTTON}
    Select option from Dropdown     //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   Closed Won
    Save
    Wait Until Page Contains Element   //div/strong[text()='Review the following fields']    60s
    Click element   //button[@title="Close error dialog"]//*[@data-key="close"]
    Sleep  10s
    #Press ESC On    //span[text()='Review the following errors']
    click element   //button[@title="Cancel"]
     #Click element   //div[@class="riseTransitionEnabled test-id__inline-edit-record-layout-container risen"]//div[@class="actionsContainer"]//*[contains(text(),"Cancel")]

Save
    click element    //button[@title='Save']
    sleep    2s

Validate error message
    wait until element is visible    //li//a[text()="Close Comment"]    60s
    wait until element is visible   //li//a[text()="Close Reason"]    15s
    #element should be visible    //a[contains(text(),"Close Comment")]
    #element should be visible    //a[contains(text(),"Close Reason")]
    #element should be visible    //div[@data-aura-class="forcePageError"]

Cancel and save
    Scroll Page To Location    0    3000
    Click element    //lightning-textarea//label[text()="Close Comment"]/../div/textarea
    Input Text    //lightning-textarea//label[text()="Close Comment"]/../div/textarea    Cancelling the opportunity
    click element    //li//a[text()="Close Reason"]
    Scroll Page To Location     0  1400
    Sleep   10s
    Select option from Dropdown  //lightning-combobox//label[text()="Close Reason"]/..//div/*[@class="slds-combobox_container"]/div     09 Customer Postponed
    #sleep  3s
    #click element    //a[@title="09 Customer Postponed"]
    Sleep  10s
    Click element  //button[@title="Save"]
    Sleep    10s

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
    sleep  10s
    wait until page contains element   ${list}/div[2]/lightning-base-combobox-item[@data-value="${item}"]  60s
    #Select From List By Value   //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div/div[2]  ${item}
    #click visible element  //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div/div[2]/lightning-base-combobox-item[7]
    #Press Key    ${list}    ${item}
    click visible element  ${list}/div[2]/lightning-base-combobox-item[@data-value="${item}"]
    sleep  10s

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
    Sleep  20s
    Search Salesforce   ${unique_subject_task}
    ${element_catenate} =    set variable    [@title='${unique_subject_task}']
    Wait Until Page Contains element    ${TABLE_HEADERForEvent}${element_catenate}  60s
    Click Visible Element    ${TABLE_HEADERForEvent}${element_catenate}
    Wait Until Page Contains element    //h1//span[text()='${unique_subject_task}']    400s
    #Search And Select the Entity    ${unique_subject_task}    ${EMPTY}
    Sleep  30s
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
    #Check original account owner and change if necessary for event
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
    force click element  ${NEW_EVENT_LABEL}
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
    : FOR    ${i}    IN RANGE    10
    \    sleep  10s
    \    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${success_message_anchor}
    \    Sleep    5s
    \    Run Keyword Unless   ${status}   Click element   //button[text()="View More"]
    \    Exit For Loop If    ${status}
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
    Set Test Variable    ${EDIT_EVENT_POPUP}    //div[@class="slds-form-element slds-hint-parent"]
    Click element    //div[@title='Edit']/..
    wait until page contains element    //*[contains(text(),'Edit Task')]    30s
    Sleep    5s
    Select Quick Action Value For Attribute    Meeting Outcome    Positive
    Sleep    5s
    Select Quick Action Value For Attribute    Meeting Status    Done
    Wait Until Element Is Visible    ${EDIT_EVENT_POPUP}//label//*[contains(text(),'Description')]    60s
    Input Text    xpath=${EDIT_EVENT_POPUP}//label//*[contains(text(),'Description')]//following::span/../textarea    ${name_input}.Edited.${Meeting}
#    Input Quick Action Value For Attribute    Description       ${name_input}.Edited.${Meeting}
#    Force click element  //button[@title='Insert quick text']/../../textarea[@class="textarea textarea uiInput uiInputTextArea uiInput--default uiInput--textarea"]
#    wait until page contains element //label//span[contains(text(),'Description')]//following::span[@id="quickTextKeyboardTip"]/../textarea  60s
#    page should contain element  //button[@title='Insert quick text']/../../textarea[@class="textarea textarea uiInput uiInputTextArea uiInput--default uiInput--textarea"]
#    input text    xpath= //button[@title='Insert quick text']/../../textarea[@class="textarea textarea uiInput uiInputTextArea uiInput--default uiInput--textarea"]    ${name_input}.Edited.${Meeting}
    #log to console    ${name_input}.Edited.${Meeting}
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
    Sleep   5s
    Click Visible Element    ${MASTER}
    Sleep  2s
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
    ${contact_name}=    Set Variable    //span[text()='Name']//following::span//lightning-formatted-name[text()='${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}']
    ${business_card_text}=    Set Variable    //span[text()='Business Card Title']//following::span//lightning-formatted-text[text()='${BUSINESS_CARD}']
    ${gender_selection}=    Set Variable    //span[text()='Gender']//following::span/lightning-formatted-text[text()='${gender}']
    ${account_name}=    Set Variable    //span[text()='Account Name']//following::a[text()='${MASTER_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']/../..//lightning-formatted-phone/a[text()='${MASTER_MOBILE_NUM}']
    ${phone_number}=    Set Variable    //span[text()='Phone']/../..//lightning-formatted-phone/a[text()='${MASTER_PHONE_NUM}']
    ${primary_email}=    Set Variable    //span[text()='Primary eMail']/../..//a[text()='${MASTER_PRIMARY_EMAIL}']
    ${email}=    Set Variable    //span[text()='Email']/../..//a[text()='${MASTER_PRIMARY_EMAIL}']
    ${status}=    Set Variable    //span[text()='Status']//following::span//lightning-formatted-text[text()='${STATUS_TEXT}']
    ${preferred_contact}=    Set Variable    //span[text()='Preferred Contact Channel']//following::span//lightning-formatted-text[text()='${PREFERRED_CONTACT}']
    ${comm_lang}=    Set Variable    //span[text()='Communication Language']//following::span//lightning-formatted-text[text()='${COMMUNICATION_LANG}']
    ${birth_date}=    Set Variable    //span[text()='Birthdate']//following::span//lightning-formatted-text[text()='${day}.${month_digit}.${year}']
    ${last_contact_date}=    Set Variable   //span[text()='Last Contacted Date']/../../div[2]/span//lightning-formatted-text
    #${last_contact_date}=    Set Variable    //span[text()='Last Contacted Date']//following::span//span[text()='${contacted_date_text}']
    ${sales_role}=    Set Variable    //span[text()='Sales Role']//following::span//lightning-formatted-text[text()='${sales_role_text}']
    ${job_title}=    Set Variable    //span[text()='Job Title Code']//following::span//lightning-formatted-text[text()='${job_title_text}']
    ${office_name_text}=    Set Variable    //span[text()='Office Name']//following::span//lightning-formatted-text[text()='${OFFICE_NAME}']
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
    Wait Until Page Contains Element    ${contact_name}    240s
    Wait Until Page Contains Element    ${account_name}    240s
    Wait Until Page Contains Element    ${mobile_number}    240s
    Wait Until Page Contains Element    ${primary_email}    240s
    Wait Until Page Contains Element    ${email}    240s
    Wait Until Page Contains Element    ${status}    240s
    Wait Until Page Contains Element    ${preferred_contact}    240s
    Wait Until Page Contains Element    ${comm_lang}    240s
    Wait Until Page Contains Element    ${birth_date}    240s
    Wait Until Page Contains Element    ${last_contact_date}    240s
    ${last_contact_date}    Get text    ${last_contact_date}
    Should Be Equal As Strings   ${last_contact_date}  ${EMPTY}
    Wait Until Page Contains Element    ${sales_role}    240s
    Wait Until Page Contains Element    ${job_title}    240s
    Wait Until Page Contains Element    ${office_name_text}    240s

Validate That Contact Person Attributes Are Named Right
    ${business_card_title}=    Set Variable    //button[@title='Edit Business Card Title']/../..//span[text()='Business Card Title']
    ${name}=    Set Variable     //span[text()="Edit Name"]/./../../..//span[text()='Name']
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
    ${Address}=    Set Variable    //div[@class="slds-form"]//span[text()='Address']
    ${External_address}=    Set Variable    //div[@class="slds-form"]//span[text()='External Address']
    ${3rd_Party_Contact}=    Set Variable    //button[@title='Edit 3rd Party Contact']/../..//div/span[text()='3rd Party Contact']
    ${external_phone}=    Set Variable    //span[text()='External Phone']
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
    Sleep    5s
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
     \   ${status}=    Run Keyword And Return Status    Should Not Be Equal As Strings  ${REMOVE_ACCOUNT}   ${new_owner}
     \   Run Keyword If   ${status} == False      reload page
     \   Wait Until Page Contains Element   ${ownername}   120s
     \   Exit For Loop If    ${status}
     #log to console   ${new_owner}
     sleep  120s


Remove change account owner
    ${ACCOUNT_OWNER}    Get Text    ${ownername}
    ${status}=    Run Keyword And Return Status    Should Not Be Equal As Strings    ${ACCOUNT_OWNER}    ${REMOVE_ACCOUNT}
    Run Keyword If    ${status} == False    Change to original owner
    Wait Until Element Is Visible   //button[@title='Change Owner']  10s
    click element     //button[@title='Change Owner']
    sleep   8s
    Element Should Be Enabled     //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]
    Wait Until Page Contains Element    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]    60s
    Input Text    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]   ${REMOVE_ACCOUNT}
    sleep  5s
    press enter on  //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]
    Sleep  15s
    click element     //a[text()="Full Name"]//following::a[text()='${REMOVE_ACCOUNT}']
    #Select from Autopopulate List    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]   ${REMOVE_ACCOUNT}
    sleep  15s
    Click element   //button[text()='Change Owner']
    Sleep  15s
    : FOR    ${i}    IN RANGE    10
    \   ${new_owner}=    Get Text    ${ownername}
    \   ${status}=    Run Keyword And Return Status    Should Be Equal As Strings  ${REMOVE_ACCOUNT}   ${new_owner}
    \   Run Keyword If   ${status} == False      reload page
    \   sleep  15s
    \   Wait Until Page Contains Element   ${ownername}   120s
    \   Exit For Loop If    ${status}
    Should Be Equal As Strings    ${REMOVE_ACCOUNT}    ${new_owner}
    Capture Page Screenshot


Check original account owner and change if necessary
    Wait Until Element Is Visible     //div//p[text()="Account Owner"]/..//a    30s
    ${account_owner}=    Get Text     //div//p[text()="Account Owner"]/..//a
    #log to console    ${account_owner}
    ${user_is_already_owner}=    Run Keyword And Return Status    Should Be Equal As Strings    ${account_owner}    Maris Steinbergs
    Run Keyword If    ${user_is_already_owner}    Set Test Variable     ${NEW_OWNER}    B2B Lightning
    ...     ELSE    Set Test Variable   ${NEW_OWNER}    Maris Steinbergs
    Change account owner to     ${NEW_OWNER}

Check original account owner and change if necessary for event
#    Wait Until Element Is Visible    //div[@class='ownerName']//a    30s
    Wait Until Element Is Visible     //div//p[text()="Account Owner"]/..//a     30s
    ${account_owner}=    Get Text     //div//p[text()="Account Owner"]/..//a
    Set Test Variable     ${NEW_OWNER}    B2B Lightning
    #log to console    ${account_owner}
    #log to console    ${NEW_OWNER}
    ${user_is_already_owner}=    Run Keyword And Return Status    Should Be Equal As Strings    ${account_owner}    B2B Lightning
    #log to console    ${user_is_already_owner}
    #log to console     ${account_owner}
    #Run Keyword unless    ${user_is_already_owner}
    Run Keyword unless  ${user_is_already_owner}  Change account owner to     ${NEW_OWNER}

Validate that account owner was changed successfully
    [Documentation]     Validates that account owner change was successfull. Takes the name of the new owner as parameter.
    [Arguments]     ${validated_owner}
    Compare owner names  ${validated_owner}

#Compare owner names
#    [Arguments]     ${validated_owner}
#    Wait until page contains element   //div[@class='ownerName']//a    30s
#    ${new_owner}=       Get Text    //div[@class='ownerName']//a
#    log to console      ${new_owner}
#    Should Be Equal As Strings    ${validated_owner}    ${new_owner}


Compare owner names
    [Arguments]     ${validated_owner}
    : FOR    ${i}    IN RANGE    10
    \   ${new_owner}=    Get Text    //div//p[text()="Account Owner"]/..//a
    \   ${status}=    Run Keyword And Return Status    Should Be Equal As Strings  ${validated_owner}   ${new_owner}
    \   Run Keyword If   ${status} == False      reload page
    \   Sleep  20s
    \   Wait Until Page Contains Element    //div//p[text()="Account Owner"]/..//a    120s
    \   Exit For Loop If    ${status}
    #Wait until page contains element   //div[@class='ownerName']//a    30s
    #${new_owner}=       Get Text    //div[@class='ownerName']//a
    #log to console      ${new_owner}
    Should Be Equal As Strings    ${validated_owner}    ${new_owner}

Validate that account owner has changed in Account Hierarchy
    [Documentation]     View account hierarchy and check that new owner is copied down in hierarchy
    Wait element to load and click  //button[@title='View Account Hierarchy']
    Wait element to load and click  //button[@title='Expand']
    Wait until page contains element    //table/tbody/tr[1]/td[4]/span[text()='${NEW_OWNER}']   30s
    #Wait until page contains element    //table/tbody/tr[2]/td[4]/span[text()='${NEW_OWNER}']   30s
    #Wait until page contains element    //table/tbody/tr[3]/td[4]/span[text()='${NEW_OWNER}']   30s

Change Account Owner
    ${CurrentOwnerName}=    Get Text    ${OWNER_NAME}
#    Click Element    ${CHANGE_OWNER}
    Click Element  //span[text()='Account Owner']/../..//button[@title='Change Owner']
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
    Sleep    60s
    : FOR    ${i}    IN RANGE    10
    \   ${NEW_OWNER_REFLECTED}=    Get Text    ${OWNER_NAME}
    \   ${status}=    Run Keyword And Return Status    Should Be Equal As Strings  ${NEW_OWNER_REFLECTED}    ${NewOwner}
    \   Run Keyword If   ${status} == False      reload page
    \   Wait Until Page Contains Element   ${OWNER_NAME}   120s
    \   Exit For Loop If    ${status}
    Should Be Equal As Strings    ${NEW_OWNER_REFLECTED}    ${NewOwner}

Click on a given account
    [Arguments]    ${acc_name}
    sleep    5s
    ${present}=    Run Keyword And Return Status    Element Should Be Visible    //th[@scope='row' and contains(@class,'slds-cell-edit')]//a[@title='${acc_name}']
    Run Keyword If    ${present}    Click specific element    //th[@scope='row' and contains(@class,'slds-cell-edit')]//a[@title='${acc_name}']
    ...    ELSE    Log To Console    No account name available
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
    #log to console    this is to create a account from contact for HDC flow
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
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Primary eMail']//following::input[1]    ${a}@teliacompany.com
    Sleep  10s
    clear element text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]  30s
    input text   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]       ${a}@teliacompany.com
    sleep    10s
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='modal-footer slds-modal__footer']/button/span[text()='Save']    30s
    force click element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='modal-footer slds-modal__footer']/button/span[text()='Save']
    ${IsErrorVisible}=    Run Keyword And Return Status    element should be visible    //span[text()='Review the errors on this page.']
    Sleep  30s
    #log to console    ${IsErrorVisible}
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
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Primary eMail']//following::input[1]    ${random_name}@teliacompany.com
    sleep    2s
    clear element text   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]  30s
    input text   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]       ${random_name}@teliacompany.com
    Sleep  2s
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='modal-footer slds-modal__footer']/button/span[text()='Save']    30s
    force click element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='modal-footer slds-modal__footer']/button/span[text()='Save']
    sleep    5s
    ${IsErrorVisible}=    Run Keyword And Return Status    element should be visible    //span[text()='Review the errors on this page.']
    Sleep  30s
    #log to console    ${IsErrorVisible}
    Run Keyword If    ${IsErrorVisible}    reEnterContactData    ${random_name}
    #sleep    10s

CreateAOppoFromAccount_HDC
    [Arguments]    ${b}=${contact_name}
    #log to console    this is to create a Oppo from contact for HDC flow.${b}.contact
    Sleep  10s
    ${oppo_name}    create unique name    Test Robot Order_
    wait until page contains element    //li/a[@title="New Opportunity"]   60s
    #force click element    //li/a/div[text()='New Opportunity']
    click element    //li/a[@title="New Opportunity"]
    #sleep    30s
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[1]    60s
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
    sleep    30s
    [Return]    ${oppo_name}

Edit Opportunity values
    [Arguments]    ${field}      ${value}
    ${fieldProperty}=    Set Variable        //button[@title='Edit ${field}']
    ${price_list_old}=     get text        //span[text()='Price List']//following::a
    #Log to console          ${price_list_old}
    ${B2B_Price_list_delete_icon}=    Set Variable    //span[@class='pillText'][contains(text(),'${price_list_old}')]/following::span[@class='deleteIcon'][1]
    ScrollUntillFound       ${fieldProperty}
    click element       ${fieldProperty}
    Sleep       2s
    ${status}    Run Keyword And Return Status    element should be visible      ${B2B_Price_list_delete_icon}
    Run Keyword If    ${status} == True         click element           ${B2B_Price_list_delete_icon}
    sleep    10s
    wait until page contains element     //input[contains(@title,'Search ${field}')]  60s
    input text    //input[contains(@title,'Search ${field}')]    ${value}
    sleep    3s
    click element    //*[@title='${value}']/../../..
    Sleep  10s
    click element    //div[@class="footer active"]//button[@title="Save"]
    Sleep  10s

ChangeThePriceBookToHDC
    [Arguments]    ${price_book}
    ${B2B_Price_list_delete_icon}=    Set Variable    //span[@class='pillText'][contains(text(),'B2B Pricebook')]/following::span[@class='deleteIcon']
    #log to console    this is to change the prioebook to HDCB2B
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
    #Log To Console    Change Price list
    ScrollUntillFound   ${edit pricelist}
    click element      ${edit pricelist}
    ScrollUntillFound   ${B2B_Price_list_delete_icon}
    #Log to console  Delete Action element found
    #click element   ${B2B_Price_list_delete_icon}
    #log to console    ${price_lists}
    ${elementToClick}=  set variable   //span[text()='${price_lists}']//following::a[1]
    ${element_xpath}=    Replace String    ${elementToClick}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep    2s
    #Log to console  Clicked
    input text    //input[@title='Search Price Lists']    ${price_lists}
    sleep    3s
    click element    //*[@title='${price_lists}']/../../..
    click element    //button[@title='Save']

ClickingOnCPQ
    [Arguments]    ${b}=${oppo_name}
    ##clcking on CPQ
    #log to console    ClickingOnCPQ
    Wait until keyword succeeds     30s     5s      click element    xpath=//a[@title='CPQ']
    #wait until page contains element    xpath=//h1[text()='${b}']    30s
    sleep    30s

#validateCreatedOppoForFYR
#    [Arguments]    ${fyr_value_oppo}= ${fyr_value}
#    wait until page contains element    //span[@title='Revenue Total']/../div[@class='slds-form-element__control']/Div/span[text()='${fyr_value_oppo},00 €']    60s
#    page should contain element    //span[@title='Revenue Total']/../div[@class='slds-form-element__control']/Div/span[text()='${fyr_value_oppo},00 €']
#    page should contain element    //span[@title='FYR Total']/../div[@class='slds-form-element__control']/Div/span[text()='${fyr_value_oppo},00 €']
#    ScrollUntillFound    //span[text()='Revenue Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span
#    sleep    5s
#    page should contain element    //span[text()='Revenue Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span[normalize-space(.)='${fyr_value_oppo},00 €']
#    page should contain element    //span[text()='FYR Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span[normalize-space(.)='${fyr_value_oppo},00 €']
#    ${monthly_charge_total}=    evaluate    (${RC}*${product_quantity})
#    #${mrc_form}=    get text    //span[@title='Revenue Total']/../div[@class='slds-form-element__control']/div/span
#    #should be equal as strings    ${monthly_charge_total}    ${mrc_form}
#    page should contain element    //span[text()='Monthly Charge Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span[normalize-space(.)='${monthly_charge_total},00 €']
#    ${one_time_total}=    evaluate    (${NRC}*${product_quantity})
#    #${nrc_form}=    get text    //span[@title='FYR Total']/../div[@class='slds-form-element__control']/div/span
#    #should be equal as strings    ${one_time_total}    ${nrc_form}
#    page should contain element    //span[text()='One Time Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span[normalize-space(.)='${one_time_total},00 €']
#    click element    //span[text()='Related']
#    sleep    5s
#    log to console    related clicked
#    ScrollUntillFound    //a[text()='${product_name}']
#    page should contain element    //a[text()='${product_name}']
#    page should contain element    //span[text()='New Money - New Services']
#    page should contain element    //span[text()='New Money - New Services']/..//following-sibling::td/span[text()='${product_quantity},00']



validateCreatedOppoForFYR
    [Arguments]   ${product_name}  ${fyr_value_oppo}= ${fyr_value}
    #wait until page contains element    //span[@title='Revenue Total']/../div[@class='slds-form-element__control']/Div/span[text()='${fyr_value_oppo},00 €']    60s
    wait until page contains element    //p[text()="Revenue Total"]/../..//lightning-formatted-text[text()=normalize-space(.)="${fyr_value_oppo},00 €"]  60s
    page should contain element    //p[text()="Revenue Total"]/../..//lightning-formatted-text[text()=normalize-space(.)="${fyr_value_oppo},00 €"]
    page should contain element    //p[text()="FYR Total"]/../..//lightning-formatted-text[text()=normalize-space(.)="${fyr_value_oppo},00 €"]
    ScrollUntillFound    //*[text()='Revenue Total' and @class='test-id__field-label']/../..
    sleep    5s
    page should contain element    //*[text()='Revenue Total' and @class='test-id__field-label']/../..//lightning-formatted-text[text()=normalize-space(.)="${fyr_value_oppo},00 €"]
    page should contain element    //*[text()='FYR Total' and @class='test-id__field-label']/../..//lightning-formatted-text[text()=normalize-space(.)="${fyr_value_oppo},00 €"]
    ${monthly_charge_total}=    evaluate    (${RC}*${product_quantity})
    #${mrc_form}=    get text    //span[@title='Revenue Total']/../div[@class='slds-form-element__control']/div/span
    #should be equal as strings    ${monthly_charge_total}    ${mrc_form}
    page should contain element    //*[text()='Monthly Recurring Total' and @class='test-id__field-label']/../..//lightning-formatted-text[text()=normalize-space(.)="${monthly_charge_total},00 €"]
    ${one_time_total}=    evaluate    (${NRC}*${product_quantity})
    #${nrc_form}=    get text    //span[@title='FYR Total']/../div[@class='slds-form-element__control']/div/span
    #should be equal as strings    ${one_time_total}    ${nrc_form}
    page should contain element    //*[text()='OneTime Total' and @class='test-id__field-label']/../..//lightning-formatted-text[text()=normalize-space(.)="${one_time_total},00 €"]
    ${status}=    Run Keyword And Return Status    wait until page contains element    //li//a[text()='Related']     60s
    run keyword if    ${status} == False    Reload Page
    run keyword if    ${status} == False    sleep  30s
    click element    //li//a[text()='Related']
    sleep    10s
    ScrollUntillFound    //a[text()='${product_name}']
    page should contain element    //a[text()='${product_name}']
    page should contain element    //span[text()='New Money - New Services']
    page should contain element    //span[text()='New Money - New Services']//following::span[@class="slds-truncate uiOutputNumber"][text()="${product_quantity},00"]


AddProductToCart
    [Arguments]   ${pname}=${product_name}
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div[2]   60s
    sleep   5s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div[2]
    sleep  20s
    wait until page contains element  //div[@class='cpq-item-product']/div[@class='cpq-item-base-product']//following::div[@class='cpq-item-no-children']/span[normalize-space(.)='${pname}']   60s
    scrolluntillfound  //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    validateThePricesInTheCart   ${pname}
    click element   //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    unselect frame
    sleep  40s

validateThePricesInTheCart
    [Arguments]    ${product}
    #${OTC} =  get text  //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,"product-title")]//following::div[contains(@class,"currency-value")][2]/div/div/span/span
    #${RC} =   get text   //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,"product-title")]//following::div[contains(@class,"currency-value")][1]/div/div/span/span
    wait until page contains element    //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,'base-product')]//div[3]//span[@class='cpq-underline']       45s
    ${rc}=  get text  //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,'base-product')]//div[3]//span[@class='cpq-underline']
    ${nrc}=  get text  //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,'base-product')]//div[5]//span[@class='cpq-underline']
    page should contain element  //div[normalize-space(.)='Monthly Recurring Total']/..//div[@class='slds-text-heading--medium'][normalize-space(.)='${rc}']
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
    #log to console    UpdateAndAddSalesType
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    wait until page contains element    ${update_order}    60s
    #log to console    selected new frame
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
    #log to console    UpdateAndAddSalesTypeB2O
    run keyword if    ${status} == False    Reload Page
    wait until page contains element    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Wait Until Element Is Not Visible    ${spinner}    60s
    wait until page contains element    xpath=//h1[normalize-space(.) = 'Update Products']    60s
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
    #log to console    selected Create Quotation frame
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
    #log to console    selected final page frame
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
    Sleep    60s
    scrolluntillfound    //*[@id="Open Quote"]
    sleep    2s
    click element    //*[@id="Open Quote"]
    unselect frame
    sleep    20s

CreditScoreApproving
    ${details}=    set variable    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    ${edit_approval}=    Set Variable    //button[@title='Edit Approval Status']
    sleep    30s
    #log to console    CreditScoreApproving
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

    wait until page contains element        //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']       120s
    sleep  10s
    force click element    //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']
    #force click element       //a[@title='CPQ']
    sleep    30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #Log to console      Inside frame
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Create Order']/..    Create Order
    #Log to console      ${status}
    wait until page contains element    //span[text()='Create Order']/..    60s
    click element    //span[text()='Create Order']/..
    #Sleep  30s
    unselect frame
    Sleep  60s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #Sleep  60s
    ${status}=  Run Keyword And Return Status  wait until page contains element    //p[text()="Order Products must have a unit price."]    60s
    Run Keyword If   ${status}   Order Products must have a unit price
    #sleep    30s
    unselect frame
    Sleep  10s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${status}=  Run Keyword And Return Status  wait until page contains element    //div//button[contains(text(),"Open Order")]    60s
    Run Keyword If   ${status}   click button      //div//button[contains(text(),"Open Order")]
    unselect frame
    Sleep  30s
clickonopenorderbutton
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    //div//button[contains(text(),"Open Order")]    60s
    click button      //div//button[contains(text(),"Open Order")]
    unselect frame
    Sleep  30s

Order Products must have a unit price
    Sleep  30s
    wait until page contains element    //button[text()="Continue"]  60s
    click element   //button[text()="Continue"]
    Sleep  60s
    unselect frame

NextButtonOnOrderPage
    #log to console    NextButtonOnOrderPage
    sleep  30s
    #click on the next button from the cart
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${status}    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    Log to console      ${status}
    wait until page contains element    //span[text()='Next']/..    120s
    click element    //span[text()='Next']/..
    unselect frame
    sleep    30s

OrderNextStepsPage
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    //*[contains(text(),'close this window')]    60s
    wait until page contains element    //*[@id="Close"]    60s
    click element    //*[@id="Close"]
    unselect frame
    sleep    20s

getOrderStatusBeforeSubmitting
    wait until page contains element    //span[@class='title' and text()='Details']    100s
    : FOR    ${i}    IN RANGE    10
    \   ${status}=    Run Keyword And Return Status   wait until page contains element  //span[@class='title' and text()='Details']    60s
    \   Run Keyword If   ${status} == False      reload page
    \   Exit For Loop If    ${status}
    #click element    //span[text()="Processed"]//following::li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    #click element   //span[text()="Mark Status as Complete"]/following::span[@class='title' and text()='Details']
    #//li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    Wait Until Element Is Enabled   //a[@title='Details']   60s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //a[@title='Details']   60s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
    click element  //a[@title='Details']
    #sleep  30s
    wait until page contains element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Status']/../following-sibling::div/span/span[text()='Draft']    90s
    wait until page contains element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Fulfilment Status']/../following-sibling::div/span/span[text()='Draft']    60s

clickOnSubmitOrder
    wait until page contains element  //a[@title='Submit Order']   120s
    click element  //a[@title='Submit Order']
    sleep   20s
    click element   //button[text()='Submit']
    Sleep       20s
    execute javascript   window.location.reload(true)
    sleep   40s

getOrderStatusAfterSubmitting
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //a[@title='Details']   60s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
    click element  //a[@title='Details']
    #Sleep  20s
    wait until page contains element  //span[text()='Fulfilment Status']/../following-sibling::div/span/span  80s
    ${fulfilment_status} =  get text  //span[text()='Fulfilment Status']/../following-sibling::div/span/span
    wait until page contains element    //span[text()='Status']/../following-sibling::div/span/span   60s
    ${status} =  get text  //span[text()='Status']/../following-sibling::div/span/span
    should not be equal as strings  ${fulfilment_status}  Error
    should not be equal as strings  ${status}  Error
    ${order_no}   get text   //div[contains(@class,'-flexi-truncate')]//following::span[text()='Order Number']/../following-sibling::div/span/span
    #log to console  ${order_no}.this is getorderstatusafgtersubmirting function
    Sleep  20s
    wait until page contains element    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Related']  60s
    click element     //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Related']
    [Return]   ${order_no}

#SearchAndSelectBillingAccount
#    [Arguments]   ${vLocUpg_TEST_ACCOUNT}
#    execute javascript    window.location.reload(true)
#    sleep    30s
#    #log to console    SearchAndSelectBillingAccount
#    #Selecting the billingAC FLow chart page
#    #log to console    entering billingAC page
#    Wait until element is visible    //div[contains(@class,'slds')]/iframe   60s
#    select frame    xpath=//div[contains(@class,'slds')]/iframe
#    wait until element is visible    //*[@id="ExtractAccount"]    30s
#    click element    //*[@id="ExtractAccount"]
#    wait until element is visible    //label[normalize-space(.)='Select Account']    30s
#    #select frame    xpath=//div[contains(@class,'slds')]/iframe
#    wait until element is visible    //div[text()='${vLocUpg_TEST_ACCOUNT}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']    30s
#    force click element    //div[text()='${vLocUpg_TEST_ACCOUNT}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
#    sleep    2s
#    click element    //*[@id="SearchAccount_nextBtn"]
#    #log to console    Exiting billingAC page
#    unselect frame
#    sleep    30s


select order contacts- HDC
    [Arguments]    ${d}= ${contact_technical}
    #${contact_search_title}=    Set Variable    //h3[text()='Contact Search']
    ${Technical_contact_search}=  set variable    //input[@id='TechnicalContactTA']
    ${contact_search}=    Set Variable    //input[@id='OrderContactTA']
    ${contact_next_button}=    Set Variable    //div[@id='SelectOrderLevelContacts_nextBtn']
    ${updateContactDR}=    Set Variable    //button[@class='slds-button slds-button--neutral ng-binding ng-scope'][@ng-click='nextRepeater(child.nextIndex, child.indexInParent)']
    ${primary_email}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    #Wait Until Element Is Visible    ${contact_search_title}    120s
    #Reload page
    #sleep   15s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #log to console    entering Technical COntact page
    Wait Until Element Is Visible    ${contact_search}    120s
    Input Text    ${contact_search}   ${d}
    sleep    15s
    Wait until element is visible   css=.typeahead .ng-binding   30s
    Click element   css=.typeahead .ng-binding
    sleep   10s
    Wait until element is visible  //input[@id='OCEmail']   30s
    Input Text   //input[@id='OCEmail']   ${primary_email}
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
    Input Text   //input[@id='TCEmail']   ${primary_email}
    Execute JavaScript    window.scrollTo(0,200)
    #Wait until element is visible       xpath=//ng-form[@id='TechnicalContactTA-Block']/div/div/div/child/div/ng-form/div[2]/div/ul/li/a    30s
    #click element   xpath=//ng-form[@id='TechnicalContactTA-Block']/div/div/div/child/div/ng-form/div[2]/div/ul/li/a
    sleep  10s
    #${order_name}    set variable    //input[@id='OrderContactDetailsTypeAhead']
    #${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${order_name}    5s
    #run keyword if    ${status} == True    update order details
    Click Element    ${contact_next_button}
    unselect frame
    sleep   30s

SelectingTechnicalContact
    [Arguments]    ${d}= ${contact_technical}
    #log to console    Selecting the Techincal COntact FLow chart page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #log to console    entering Technical COntact    page
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
    #log to console    Exiting    technical    page
    unselect frame
    sleep    30s

RequestActionDate
    #log to console    selecting Requested Action Date FLow chart page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #log to console    entering Requested action date page
    wait until page contains element    //*[@id="RequestedActionDateSelection"]     30s
    click element   //*[@id="RequestedActionDateSelection"]
    ${date_requested}=    Get Current Date    result_format=%d-%m-%Y
    #${date_requested}=  Get Date From Future        1
    #log to console    ${d}
    input text    //*[@id="RequestedActionDateSelection"]     ${date_requested}
    sleep  10s
    #click element    //*[@id="Additional data_nextBtn"]
    Click element       //*[@id="SelectRequestActionDate_nextBtn"]
    unselect frame
    #log to console    Exiting    Requested Action Date page
    sleep    30s

SelectOwnerAccountInfo
    [Arguments]    ${e}= ${billing_account}
    #log to console    Select Owner Account FLow Chart Page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #log to console    entering Owner Account page
    Scrolluntillfound   //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
#    wait until element is visible    //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']    30s
    sleep   10s
    force click element   //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    sleep  10s
#    unselect frame
    Scroll Page To Element       //*[@id="BuyerIsPayer"]//following-sibling::span
    sleep  10s
#    select frame   xpath=//div[contains(@class,'slds')]/iframe
    Wait until element is visible   //*[@id="BuyerIsPayer"]//following-sibling::span   30s
    #Log to console   Click BIP
    force click element  //*[@id="BuyerIsPayer"]//following-sibling::span
    ScrollUntillFound       //*[@id="SelectedBuyerAccount_nextBtn"]
    click element    //*[@id="SelectedBuyerAccount_nextBtn"]
    unselect frame
    sleep    30s

SelectOwnerAccountInfo select different buyer and payer validation
    [Arguments]    ${e}= ${billing_account}
    #log to console    Select Owner Account FLow Chart Page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #log to console    entering Owner Account page
    Scroll Page To Element   //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    wait until element is visible    //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']    30s
    #Log to console      Selecting Billing account
    sleep   10s
    force click element   //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    sleep  10s
    ScrollUntillFound       //*[@id="SelectedBuyerAccount_nextBtn"]
    click element    //*[@id="SelectedBuyerAccount_nextBtn"]
    unselect frame
    sleep  10s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //label[@for="PayerAccount"]
    wait until element is visible    //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']    30s
    sleep   10s
    force click element   //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    sleep  10s
    ScrollUntillFound       //*[@id="SelectedBuyerAccount_nextBtn"]
    click element    //*[@id="SelectedBuyerAccount_nextBtn"]
    unselect frame
    sleep  10s

ReviewPage
    #log to console    Review Page FLow chart Page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #log to console    entering Review page
    wait until page contains element    //*[@id="SubmitInstruction"]/div/p/h3/strong[contains(text(),'successfully')]    30s
    click element    //span[text()='Yes']
    unselect frame
    #log to console    Exiting Review page
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
    [Arguments]    ${LIGHTNING_TEST_ACCOUNT}
    # go to particular account and create a billing accouint from there
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible     //li/a/div[@title='Billing Account']   60s
    #Run Keyword If    ${status_page} == True    force click element    //li/a/div[@title='Billing Account']
    Run Keyword If    ${status_page} == False   force click element     //a[@title="Show 2 more actions"]
    sleep  20s
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
    ${account_name_get}=    get value    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]
    ${numbers}=    Generate Random String    4    [NUMBERS]
    sleep  30s
    clear element text  //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]
    input text    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]    Billing_${LIGHTNING_TEST_ACCOUNT}_${numbers}
    Execute JavaScript    window.scrollTo(0,700)
    #scroll page to element    //*[@id="billing_country"]
    click element    //*[@id="billing_country"]
    sleep  2s
    click element    //*[@id="billing_country"]/option[@value='FI']
    sleep  2s
    click element    //*[@id="Invoice_Delivery_Method"]
    sleep  2s
    click element    //*[@id="Invoice_Delivery_Method"]/option[@value='Paper Invoice']
    sleep  2s
    input text    //*[@id="payment_term"]    10
    sleep  2s
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

Login to Salesforce as DigiSales Admin User Release
    Login To Salesforce Lightning    ${SALES_ADMIN_USER_RELEASE}    ${PASSWORD-SALESADMIN}

Updating Setting Telia Colocation
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    xpath=//div[@class='cpq-item-product']/div[@class='cpq-item-base-product']/div/div/button[1]/span[@class='cpq-product-name' and text()='Telia Colocation']    60s
    click element    xpath=//span[@class='cpq-product-name' and text()='Telia Colocation']/..
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
    #log to console    before teardiwn
    Unselect Frame
    sleep    60s

Updating Setting Telia Colocation without Next

    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    xpath=//div[@class='cpq-item-product']/div[@class='cpq-item-base-product']/div/div/button[1]/span[@class='cpq-product-name' and text()='Telia Colocation']    60s
    click element    xpath=//span[@class='cpq-product-name' and text()='Telia Colocation']/..
    wait until page contains element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-actions slds-text-align_right']/button    60s
    click element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-actions slds-text-align_right']/button
    unselect frame

updating setting Telia Cid
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${SETTINGS}=    Set Variable    //button[@title='Settings']
    ${X_BUTTON}=    Set Variable    //button[@class='slds-button slds-button--icon']
    wait until page contains element    xpath=//div[@class='cpq-item-product']/div[@class='cpq-item-base-product']/div/div/button[1]/span[@class='cpq-product-name' and text()='Telia Cid']     60s
    Wait Until Element Is Visible    ${SETTINGS}    60s
    click element    ${SETTINGS}
    wait until page contains element    //form[@name="productconfig"]//div[2]//input    60s
    input text  //form[@name="productconfig"]//div[2]//input      1
    click element    ${X_BUTTON}
    wait until element is not visible  //span[contains(text(),"Required attribute missing for Telia Cid.")]   60s
    unselect frame
    Wait Until Element Is Enabled    //div[contains(@class,'slds')]/iframe    60s
    Select Frame    //div[contains(@class,'slds')]/iframe
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    Log to console      ${status}
    Wait Until Element Is Visible    //span[text()='Next']/..    60s
    click element    //span[contains(text(),'Next')]
    #Wait Until Element Is Visible    ${Next_Button}    60s
    unselect frame
    sleep  40s

search products
    [Arguments]    ${product}
    #log to console    AddingProductToCartAndClickNextButton
    sleep    15s
    Wait Until Element Is Enabled    //div[contains(@class,'slds')]/iframe    60s
    Select Frame    //div[contains(@class,'slds')]/iframe
    wait until page contains element    //div[contains(@class,'cpq-searchbox')]//input[contains(@class,'ng-valid')]    60s
    #sleep    10s
    input text    //div[contains(@class,'cpq-searchbox')]//input[contains(@class,'ng-valid')]    ${product}


Adding Telia Colocation
    [Arguments]   ${pname}=${product_name}
    #Log to console      adding product
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    sleep   20s
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
    ${contract_length}=    Set Variable    ${product_list}/../td[9]/input
    ${quantity}=    Set Variable    ${product_list}//following-sibling::td/input[@ng-model='p.Quantity']
    #log to console    UpdateAndAddSalesType with quantity
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
    #log to console    selected new frame
    wait until page contains element   ${quantity}    60s
    Clear Element Text    ${quantity}
    Input Text    ${quantity}    ${quantity_value}
    wait until page contains element    ${product_list}    70s
    click element    ${product_list} //following-sibling::td/select[contains(@class,'required')]
    click element    ${product_list}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    sleep    2s
    click element    ${contract_length}
    clear element text   ${contract_length}
    input text   ${contract_length}  60
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
    #log to console    OpenQuoteButtonPage
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    #log to console    selected final page frame
    #log to console    wait completed before view quote click
    sleep  60s
    ${status}=  Run Keyword And Return Status  Element Should Be Visible   ${Viwe_quote}    100s
    Run Keyword If   ${status}   Click Visible Element    ${Viwe_quote}
    Run Keyword unless   ${status}    Click Visible Element   ${open_quote}
    #wait until element is visible    ${open_quote}    30s
    #wait until element is enabled    ${open_quote}    20s
    #log to console    element visible next step
    #click element    ${open_quote}
    unselect frame

Closing the opportunity
    [Arguments]    ${continuation}
    #${stage_complete}=    set variable    //span[text()='Mark Stage as Complete']
    ${current_stage}=    set variable    //div[contains(@class,'test-id__field')]/span[contains(text(),'Stage')]/../../div/span[contains(@class,'field-value')]
    ${edit_stage}=    set variable    //button[@title='Edit Stage']
    #Wait Until Element Is Visible    ${stage_complete}    60s
    ${stage}=    Get Text    ${current_stage}
    #Log To Console    The current stage is ${stage}
    Capture Page Screenshot
    click element    ${EDIT_STAGE_BUTTON}
    Sleep  30s
    Select option from Dropdown    //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div    Closed Won
    Execute Javascript    window.scrollTo(0,600)
    Select option from Dropdown if not able to edit the element from the list    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Create Continuation Sales Opportunity?')]/../../div/div/div/div/a    ${continuation}   Closed Won
    Select option from Dropdown   //span[contains(@class,'label inputLabel')]/span[contains(text(),'Create Continuation Sales Opportunity?')]/../../div/div/div/div/a    ${continuation}
    Wait Until Page Contains Element    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Close Reason')]/../../div/div/div/div/a    60s
    Execute Javascript    window.scrollTo(0,9000)
    #Get Text    //span[contains(text(),'Service Address Street')]/../../span
    Select option from Dropdown    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Close Reason')]/../../div/div/div/div/a    08 Other
    input text    //span[text()='Close Comment']/../../textarea    this is a test opportunity to closed won
    #sleep  30s
    Wait Until Page Contains Element     //button[@title="Save"]   60s
    click element   //button[@title="Save"]

Closing the opportunity with reason
    [Arguments]    ${stage1}
    #${stage_complete}=    set variable    //span[text()='Mark Stage as Complete']
    ${current_stage}=    set variable    //div[contains(@class,'test-id__field')]/span[contains(text(),'Stage')]/../../div/span[contains(@class,'field-value')]
    ${edit_stage}=    set variable    //button[@title='Edit Stage']
    #Wait Until Element Is Visible    ${stage_complete}    60s
    ${stage}=    Get Text    ${current_stage}
    Log To Console    The current stage is ${stage}
    Capture Page Screenshot
    click element    ${EDIT_STAGE_BUTTON}
    Sleep  30s
    Select option from Dropdown    //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   ${stage1}
    Execute Javascript    window.scrollTo(0,7000)
    Wait Until Page Contains Element    //lightning-combobox//label[text()="Close Reason"]/..//div/*[@class="slds-combobox_container"]/div   60s
    #Get Text    //span[contains(text(),'Service Address Street')]/../../span
    Select option from Dropdown    //lightning-combobox//label[text()="Close Reason"]/..//div/*[@class="slds-combobox_container"]/div    08 Other
    Scroll Page To Location    0    3000
    Click element    //lightning-textarea//label[text()="Close Comment"]/../div/textarea
    Input Text    //lightning-textarea//label[text()="Close Comment"]/../div/textarea    this is a test opportunity to closed won
    #sleep  30s
    Wait Until Page Contains Element     //button[@title="Save"]   60s
    click element   //button[@title="Save"]
    sleep  30s
    log to console   Check that opportunity cannot be updated after status has been set to Won.
    Scroll Page To Location    0   0
    wait until page contains element   ${EDIT_STAGE_BUTTON}    60s
    click element    ${EDIT_STAGE_BUTTON}
    Select option from Dropdown   //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   ${stage1}
    Wait Until Page Contains Element     //button[@title="Save"]   60s
    click element  //button[@title="Save"]
    Wait Until Page Contains Element   //div/strong[text()='Review the errors on this page.']    60s
    Click element   //button[@title="Close error dialog"]//*[@data-key="close"]
    Sleep  10s
    #Press ESC On    //span[text()='Review the following errors']
    click element   //button[@title="Cancel"]
    sleep  30s
    wait until page contains element  //*[text()="Create Continuation Sales Opportunity?"]   30s
    Page Should Contain Element   //*[text()="Create Continuation Sales Opportunity?"]
    log to console   Create Continuation Sales Opportunity is visible

Closing the opportunity and check Continuation
    [Arguments]    ${stage1}
    #${stage_complete}=    set variable    //span[text()='Mark Stage as Complete']
    ${current_stage}=    set variable    //div[contains(@class,'test-id__field')]/span[contains(text(),'Stage')]/../../div/span[contains(@class,'field-value')]
    ${edit_stage}=    set variable    //button[@title='Edit Stage']
    #Wait Until Element Is Visible    ${stage_complete}    60s
    ${stage}=    Get Text    ${current_stage}
    Log To Console    The current stage is ${stage}
    Capture Page Screenshot
    click element    ${EDIT_STAGE_BUTTON}
    Sleep  30s
    Select option from Dropdown   //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   ${stage1}
    #Wait Until Page Contains Element    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Close Reason')]/../../div/div/div/div/a    60s
    Execute Javascript    window.scrollTo(0,7000)
    #Get Text    //span[contains(text(),'Service Address Street')]/../../span
    Select option from Dropdown    //lightning-combobox//label[text()="Close Reason"]/..//div/*[@class="slds-combobox_container"]/div    08 Other
    Scroll Page To Location    0    3000
    Click element    //lightning-textarea//label[text()="Close Comment"]/../div/textarea
    Input Text    //lightning-textarea//label[text()="Close Comment"]/../div/textarea    this is a test opportunity to closed won
    #sleep  30s
    Wait Until Page Contains Element     //button[@title="Save"]   60s
    click element    //button[@title="Save"]
    sleep  30s
    wait until page contains element  //*[text()="Create Continuation Sales Opportunity?"]   30s
    Page Should Contain Element   //*[text()="Create Continuation Sales Opportunity?"]
    log to console   Create Continuation Sales Opportunity is visible


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
    ${status}    Run Keyword And Return Status      Wait Until Element Is Visible    ${product}    60s    80s
    Run Keyword If    ${status} == False    Reload Page
    Run Keyword If    ${status} == False    Sleep  60s
    Run Keyword If    ${status} == False    clear element text    //div[contains(@class,'cpq-searchbox')]//input[contains(@class,'ng-valid')]
    Run Keyword If    ${status} == False    search products    Telia Viestintäpalvelu VIP (24 kk)
    Click Element    ${product}

updating settings Telia Viestintäpalvelu VIP (24 kk)
    ${SETTINGS}=    Set Variable    //button[@title='Settings']
    ${Toimitustapa}=    set variable     //select[@name='productconfig_field_0_2']
    ${X_BUTTON}=    Set Variable    //button[@class='slds-button slds-button--icon']
    ${Next_Button}=    Set Variable    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    Wait Until Element Is Visible    ${SETTINGS}    60s
    click element    ${SETTINGS}
    sleep    4s
    Select From List By Value   //select[@name="productconfig_field_0_0"]   Paperilasku
    sleep  2s
    input text  //input[@name="productconfig_field_0_1"]   1
    sleep  2s
    Select From List By Value    ${Toimitustapa}    Vakiotoimitus
    sleep    5s
    click element    ${X_BUTTON}
    Wait Until Element Is Visible    ${Next_Button}    60s
    Click Element    ${Next_Button}
    sleep  30s
    unselect frame
Reporting Products
    ${next_button}=    Set Variable    //div[@class='vlc-cancel pull-left col-md-1 col-xs-12 ng-scope']//following::div[1]/button[1]
    #${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe       60s
    #Log To Console    Reporting Products
    #Run Keyword If    ${status} == False    execute javascript    browser.runtime.reload()
    #Run Keyword If    ${status} == False    Reload Page
    Reload Page
    sleep  20s
    execute javascript    window.stop();
    #go to   https://telia-fi--release.lightning.force.com/one/one.app#eyJjb21wb25lbnREZWYiOiJvbmU6YWxvaGFQYWdlIiwiYXR0cmlidXRlcyI6eyJhZGRyZXNzIjoiaHR0cHM6Ly90ZWxpYS1maS0tcmVsZWFzZS5saWdodG5pbmcuZm9yY2UuY29tL2FwZXgvdmxvY2l0eV9jbXRfX09tbmlTY3JpcHRVbml2ZXJzYWxQYWdlP2lkPTAwNjZFMDAwMDA4U3VmNFFBQyZ0cmFja0tleT0xNTc1NTU1NzM2NDAxIy9PbW5pU2NyaXB0VHlwZS9PcHBvcnR1bml0eSUyMFByb2R1Y3QvT21uaVNjcmlwdFN1YlR5cGUvT0xJJTIwRmllbGRzL09tbmlTY3JpcHRMYW5nL0VuZ2xpc2gvQ29udGV4dElkLzAwNjZFMDAwMDA4U3VmNFFBQy9QcmVmaWxsRGF0YVJhcHRvckJ1bmRsZS8vdHJ1ZSJ9LCJzdGF0ZSI6e319
    #reload page
    sleep    30s
    #Wait Until Element Is Visible    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    #Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    sleep  30s
    #click element    ${next_button}
    unselect frame

Closing Opportunity as Won with FYR
    [Arguments]    ${quantity}    ${continuation}
    ${FYR}=    set variable    //p[@title='FYR Total']/..//lightning-formatted-text
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    sleep    10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    #${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    Chetan
    #${oppo_name}    set variable    Test Robot Order_ 20191205-162925
    #Log to console    ${oppo_name}
    Go To Entity    ${oppo_name}
    ClickingOnCPQ   ${oppo_name}
    #go to  https://telia-fi--release.lightning.force.com/one/one.app#eyJjb21wb25lbnREZWYiOiJvbmU6YWxvaGFQYWdlIiwiYXR0cmlidXRlcyI6eyJhZGRyZXNzIjoiaHR0cHM6Ly90ZWxpYS1maS0tcmVsZWFzZS5saWdodG5pbmcuZm9yY2UuY29tL2FwZXgvdmxvY2l0eV9jbXRfX09tbmlTY3JpcHRVbml2ZXJzYWxQYWdlP2lkPTAwNjZFMDAwMDA4VE5UNlFBTyZ0cmFja0tleT0xNTc1NjM1NjQ0OTA5Iy9PbW5pU2NyaXB0VHlwZS9PcHBvcnR1bml0eSUyMFByb2R1Y3QvT21uaVNjcmlwdFN1YlR5cGUvT0xJJTIwRmllbGRzL09tbmlTY3JpcHRMYW5nL0VuZ2xpc2gvQ29udGV4dElkLzAwNjZFMDAwMDA4VE5UNlFBTy9QcmVmaWxsRGF0YVJhcHRvckJ1bmRsZS8vdHJ1ZSJ9LCJzdGF0ZSI6e319
    searching and adding Telia Viestintäpalvelu VIP (24 kk)    Telia Viestintäpalvelu VIP (24 kk)
    updating settings Telia Viestintäpalvelu VIP (24 kk)
    #search products    Telia Taloushallinto XXL-paketti
    #Adding Telia Taloushallinto XXL-paketti
    UpdateAndAddSalesTypewith quantity    Telia Viestintäpalvelu VIP (24 kk)    ${quantity}
    #OpenQuoteButtonPage_release
    Go To Entity    ${oppo_name}
    #Closing the opportunity    ${continuation}
    sleep    15s
    Capture Page Screenshot
    ${FYR_value}=    get text    ${FYR}
    #Log to console    The FYR value is ${FYR_value}

Editing Win prob
    [Arguments]    ${save}
    [Documentation]    This is to edit the winning probability of a opportunity
    ...
    ...    ${save}--> yes if there is nothing else to edit
    ...    no --> if there are other fields to edit
    ${win_prob_edit}=    Set Variable    //span[contains(text(),'Win Probability %')]/../../button
    ${win_prob}    set variable    //label[text()='Win Probability %']
    ${save_button}    set variable    //span[text()='Save']
    sleep       20s
    ScrollUntillFound       ${win_prob_edit}
    click element    ${win_prob_edit}
    #Wait Until Element Is Visible    ${win_prob}    60s
    #ScrollUntillFound       ${win_prob}
    Select option from Dropdown  //lightning-combobox//label[text()="Win Probability %"]/..//div/*[@class="slds-combobox_container"]/div    10%
    #Force click element    ${win_prob}
    #Wait Until Element Is Visible         //li/a[@title='10%']      60s
    #click element    //li/a[@title='10%']
    #run keyword if    ${save} == yes    click element    ${save_button}

Adding partner and competitor
    [Documentation]    Used to add partner and competitor for a existing opportunity
    ${save_button}    set variable      //button[@title="Save"]
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
    Sleep  30s
    Capture Page Screenshot

Adding Yritysinternet Plus
    [Arguments]    ${Yritysinternet_Plus}
    #${product}=    Set Variable    //div[@data-product-id='${Yritysinternet_Plus}']/div/div/div/div/div/button
    ${product}=    Set Variable    //span[@title='${Yritysinternet_Plus}']/../../..//button
    ${SETTINGS}=    Set Variable    //button[@title='Settings']
    ${Liittymän_nopeus}    Set Variable   //select[@name='productconfig_field_0_1']
    ${Palvelutaso}    Set Variable    //select[@name='productconfig_field_0_2']
    ${X_BUTTON}=    Set Variable    //button[@class='slds-button slds-button--icon']
    Wait Until Element Is Visible    ${product}    60s
    Click Element    ${product}
    Sleep  30s
    Wait Until Element Is Visible    ${SETTINGS}    60s
    click element    ${SETTINGS}
    wait until element is visible  //select[@name='productconfig_field_0_0']  60s
    Select From List By Value     //select[@name='productconfig_field_0_0']     EXTRA ETHERNET
    Wait Until Element Is Visible    ${Liittymän_nopeus}    60s
    Select From List By Value    ${Liittymän_nopeus}    2 Mbit/s / 1 Mbit/s
    wait until element is visible  //select[@name='productconfig_field_0_3']  60s
    Select From List By Value     //select[@name='productconfig_field_0_3']    4
    wait until element is visible  //select[@name='productconfig_field_0_4']  60s
    Select From List By Value     //select[@name='productconfig_field_0_4']     Saatavuustieto tarkistettu järjestelmästä
    sleep    3s
    wait until element is visible  //input[@name="productconfig_field_0_6"]   60s
    input text  //input[@name="productconfig_field_0_6"]   L1.robotframework
    sleep  2s
    wait until element is visible  //input[@name="productconfig_field_0_7"]  60s
    input text  //input[@name="productconfig_field_0_7"]  L2.robotframework
    wait until element is visible  //input[@name="productconfig_field_0_8"]  60s
    input text  //input[@name="productconfig_field_0_8"]  L3.robotframework
    Select From List By Value    ${Palvelutaso}    A24h
    sleep    3s
    click element    ${X_BUTTON}
    Sleep  30s
    unselect frame

Adding DataNet Multi
    [Arguments]    ${DataNet_Multi}
    #${product}=    Set Variable    //span[@title='${DataNet_Multi}']/../../..//button
    ${product}=    Set Variable  //span[text()="HUOM! Pilotointiryhmän käyttöön DataNet Multi tilauslomake (nk. Kevytmallinnettu)"]//following::span[3][@title='${DataNet_Multi}']/../../..//button
    ${next_button}=    set variable    //span[contains(text(),'Next')]
    Wait Until Element Is Visible    ${product}    60s
    Click Element    ${product}
    sleep    30s
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    #Log to console      ${status}
    wait until page contains element    //span[text()='Next']/..    60s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    #Click Visible Element   ${next_button}
    unselect frame

UpdateAndAddSalesType for 2 products
    [Arguments]    ${product1}    ${product2}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_1}=    Set Variable    //td[normalize-space(.)='${product1}']
    ${product_2}=    Set Variable    //td[normalize-space(.)='${product2}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    #log to console    UpdateAndAddSalesType for 2 products
    sleep    30s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe   60s
    Run Keyword If    ${status} == False    Reload Page
    sleep    60s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    wait until page contains element    ${update_order}    60s
    #log to console    selected new frame
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

UpdateAndAddSalesType for 3 products and check contract
    [Arguments]    ${product1}    ${product2}   ${product3}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_1}=    Set Variable    //td[normalize-space(.)='${product1}']
    ${product_2}=    Set Variable    //td[normalize-space(.)='${product2}']
    ${product_3}=    Set Variable    //td[normalize-space(.)='${product3}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    log to console    UpdateAndAddSalesType for 3 products
    sleep    30s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe   60s
    Run Keyword If    ${status} == False    Reload Page
    #sleep    60s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe

    wait until element is visible    ${update_order}    60s
    log to console    selected new frame
    wait until element is visible   ${product_1}    70s
    click element    ${product_1} //following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_1}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    sleep    5s
    wait until element is visible    ${product_2}    70s
    click element    ${product_2} //following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_2}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    sleep  5s
    wait until element is visible    ${product_3}    70s
    click element    ${product_3} //following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_3}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    Unselect Frame
    sleep    5s

UpdateAndAddSalesType for 2 products and check contract
    [Arguments]    ${product1}    ${product2}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_1}=    Set Variable    //td[normalize-space(.)='${product1}']
    ${product_2}=    Set Variable    //td[normalize-space(.)='${product2}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    #log to console    UpdateAndAddSalesType for 2 products
    sleep    30s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe   60s
    Run Keyword If    ${status} == False    Reload Page
    Run Keyword If    ${status} == False    sleep    60s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${status}    Run Keyword And Return Status      Wait until page contains element    ${SERVICE_CONTRACT_WARNING}     30s
    Run Keyword If     ${status}    Reload Page
    Run Keyword If     ${status}    Sleep  60s
    Run Keyword If     ${status}   log    ${SERVICE_CONTRACT_WARNING}
    Run Keyword unless  ${status}    log to console    service contract already created
    wait until page contains element    ${update_order}    60s
    #log to console    selected new frame
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
    ${quote_n}    Set Variable    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span
    ${send_mail}    Set Variable    //p[text()='Send Email']
    ${submitted}    Set Variable    //a[@aria-selected='true'][@title='Submitted']
    #${status}    Run Keyword And Return Status      Wait until page contains element    ${quote_n}     80s
    #Run Keyword If    ${status} == False    Reload Page
    #Run Keyword If    ${status} == False    Sleep  60s
    wait until page contains element    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span   60s
    ${quote_number}    get text    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span
    #Log To Console    preview and submit quote
    ${path}=  get location
    ${status}    Run Keyword And Return Status    Wait Until page contains element     ${preview_quote}    60s
    Run Keyword If    ${status} == True    Reload Page
    Run Keyword If    ${status} == True    Sleep  50s
    click element    ${preview_quote}
    sleep    10s
    Capture Page Screenshot
    #log to console  to view the quote
    Execute Javascript    window.scrollTo(0,400)
    sleep  5s
    Capture Page Screenshot
    #log to console  clicked
    Sleep  10
    #Go Back
    go to   ${path}
    wait until page contains element    ${send_quote}   60s
    Click Element    ${send_quote}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    Run Keyword If    ${status} == False    Reload Page
    sleep    10s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Capture Page Screenshot
    #Sleep  30s
    ${status}=  Run Keyword And Return Status  Wait until page contains element   ${send_mail}    100s
    Run Keyword If   ${status}   Click Visible Element    ${send_mail}
    Run Keyword unless   ${status}  approve the quote   ${oppo_FOR}
    #Click Element    ${send_mail}
    Unselect Frame
    sleep    10s
    ${Quote_Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${submitted}    60s
    #Log To Console    Quote is submitted: \ \ ${Quote_Status}
    [Return]    ${quote_number}

approve the quote
    [Arguments]    ${oppo_FOR}
    ${page}=  get location
    click visible element   //div/p[text()="Next"]
    unselect frame
    reload page
    sleep  60s
    logoutAsUser    ${B2B_DIGISALES_LIGHT_USER}
    sleep  30s
    Login To Salesforce Lightning   ${SYSTEM_ADMIN_USER}    ${SYSTEM_ADMIN_PWD}
    sleep  20s
    #swithchtouser    B2B DigiSales
    #: FOR    ${i}    IN RANGE    10
    #\   ${status}=  Run Keyword And Return Status   Element Should Be Visible    //a[@href="/lightning/o/Quote/home"]/span/span[contains(text(),"Quotes")]    100s
    #\   Run Keyword If   ${status}   Click Visible Element    //a[@href="/lightning/o/Quote/home"]/span/span[contains(text(),"Quotes")]
    #\   Run Keyword unless   ${status}  Click Visible Element  //one-app-nav-bar-menu-button/a/span[contains(text(),"Show More")]
    #\   Sleep  30s
    #\   Exit For Loop If    ${status}
	#Sleep  20s
	Search Salesforce    ${oppo_FOR}
    #Input Text    //input[@name="Quote-search-input"]
    Wait Until Element Is Visible       //a[contains(text(),"Quote")]//following::a[text()="${oppo_FOR}"]       60s
    Click Element   //a[contains(text(),"Quote")]//following::a[text()="${oppo_FOR}"]
    sleep  10s
    creditscoreapproving
    logoutAsUser  ${SYSTEM_ADMIN_USER}
    Login to Salesforce as B2B DigiSales
    sleep  30s
    go to   ${page}
    Sending quote as email

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
    ${oppo_stage}    Set Variable    //a[@title='Negotiate and Close'][@aria-selected='true']
    ${oppo_status}  Set Variable   //section[@class="tabs__content active uiTab"]//div[@class="slds-form-element__control slds-grid itemBody"]//span[text()="Offer Sent"]
    sleep    7s
    ${quote_s}    Run Keyword And Return Status    Page Should Contain Element    ${quote_status}
    Run Keyword If    ${quote_s} == True    Log To Console    The status of quote is Submitted
    Go To Entity    ${oppo_name}
    Reload Page
    sleep    7s
    ${oppo_s}    Run Keyword And Return Status    Page Should Contain Element    ${oppo_stage}
    Run Keyword If    ${oppo_s} == True    Log To Console    The status of opportunity is Negotiate and Close
    ${oppo_sent}   Run Keyword And Return Status    Page Should Contain Element    ${oppo_status}
    Run Keyword If    ${oppo_s} == True    Log To Console    The status of opportunity is opportunity sent

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
    ${status}    Run Keyword And Return Status      Wait Until Element Is Visible    //button[contains(text(),"Open Order")]    60s
    Run Keyword If    ${status} == True    Click Element    //button[contains(text(),"Open Order")]
    Sleep   20s
    Unselect Frame
Opportunity status
    ${oppo_status}    Set Variable    //a[@aria-selected='true'][@title='Negotiate and Close']
    sleep    10s
    Reload Page
    ${Oppo_Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${oppo_status}    60s
    #Log To Console    The status of opportunity is Negotiate and Close : ${Oppo_Status}

View order and send summary
    ${frame}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${view_button}    Set Variable    //div[@class="slds-button-group"]//button[@title="View"]
    ${preview_order}    Set Variable    //a/div[@title='Preview Order Summary']
    ${send_order_summary}    Set Variable    //a/div[@title='Send Order Summary Email']
    ${submit_order}    Set Variable    //a/div[@title='Submit Order']
    ${order_progress}    Set Variable    //a[@title='In Progress']/span[2]
    Sleep  30s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    ${frame}
    Run Keyword If    ${status} == False    Reload Page
    Wait Until Element Is Enabled    ${frame}    60s
    #Sleep  30s
    select frame    ${frame}
    #Log to console      Inside frame
    ${status}   set variable    Run Keyword and return status    Frame should contain    ${view_button}    View
    #Log to console      ${status}
    #Sleep  100s
    wait until page contains element    ${view_button}     120s
    click element   ${view_button}
    Unselect Frame
    #sleep  40s
    #Wait Until Element Is Visible    //div[@id="Close"]   60s
    #click element   //div[@id="Close"]
    #Unselect Frame
    #sleep    20s
    Wait Until Element Is Enabled   ${preview_order}    120s
    ${page}=  get location
    click element    ${preview_order}
    sleep    7s
    Capture Page Screenshot
    #log to console  order page
    sleep  10s
    go to  ${page}
    #Go Back
    Wait Until Element Is Visible    ${send_order_summary}    60s
    click element    ${send_order_summary}
    Sending quote as email
    Sleep  20s
    Wait Until Element Is Enabled    ${submit_order}    60s
    click element    ${submit_order}
    Sleep  20s
    Wait Until Element Is Visible     //div/p[text()="Are you sure you want to submit this order?"]/..//button[text()="Submit"]     60s
    #Sleep  20s
    click element   //div/p[text()="Are you sure you want to submit this order?"]/..//button[text()="Submit"]
    #sleep    40s
    wait until page contains element    ${order_progress}    80s
    Capture Page Screenshot

Adding Products
    [Arguments]    ${product-id}
    ${product}=    Set Variable    //div[@class="cpq-product-list"]//div[@class="slds-tile cpq-product-item"]//span[normalize-space(.)="${product-id}"]/../../..//button
    wait until page contains element    ${product}    60s
    Click Element    ${product}
    unselect frame

Adding Products for Telia Sopiva Pro N
    [Arguments]    ${product-id}
    ${SETTINGS}=    Set Variable    //button[@title='Settings']
    ${X_BUTTON}=    Set Variable    //button[@class='slds-button slds-button--icon']
    ${Numeron siirto}=   Set Variable    //div[@class="slds-grid slds-grid--align-end"]/../..//div[13]/../fieldset//label[contains(text(),"Numeron siirto")]
    ${product}=    Set Variable    //span[normalize-space(.)= '${product-id}']/../../../div[@class='slds-tile__detail']/div/div/button
    Wait Until Element Is Visible    ${product}    60s
    Click Element    ${product}
    Wait Until Element Is Visible    ${SETTINGS}    100s
    click element    ${SETTINGS}
    scrolluntillfound  ${Numeron siirto}
    Wait Until Element Is Visible    ${Numeron siirto}    60s
    click element   //div[@class="slds-grid slds-grid--align-end"]/../..//div[13]/../fieldset//label//input[@value="Yes"]/../span
    sleep    3s
    click element    ${X_BUTTON}
    Sleep  5s
    Wait Until Element Is Visible    //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product-id}")]/../../../.././div[3]//span/span  30s
    click element       //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product-id}")]/../../../.././div[3]//span/span
    Sleep  5s
    Wait Until Element Is Visible   //div[text()="Recurring Charge"]/..//input[@type="number"]   20s
    Input Text       //div[text()="Recurring Charge"]/..//input[@type="number"]     50
    Wait Until Element Is Visible       //button[contains(text(),"Apply")]      10s
    click element   //button[contains(text(),"Apply")]
    Sleep  25s
    Wait Until Element Is Enabled       //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product-id}")]/../../../.././div[5]//div/span/span   60s
    click element                       //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product-id}")]/../../../.././div[5]//div/span/span
    Sleep  5s
    Wait Until Element Is Visible       //div[text()="One Time Charge"]/..//input[@type="number"]   20s
    Input Text       //div[text()="One Time Charge"]/..//input[@type="number"]     10
    Wait Until Element Is Visible       //button[contains(text(),"Apply")]      10s
    click element   //button[contains(text(),"Apply")]
    Sleep  20s

Adding Products for Telia Sopiva Pro N child products
    [Arguments]    ${product1}  ${product2}
    ${addproduct1}=     Set Variable    //div[contains(text(),"${product1}")]/../../../..//div[7]//button
    ${addproduct2}=     Set Variable    //div[contains(text(),"${product2}")]/../../../div[@class="cpq-item-base-product-actions slds-text-align_right"]/button
    Click Element     //div[@class="cpq-item-base-product"]//button
    Wait Until Element Is Enabled    ${addproduct1}    60s
    Click Element    ${addproduct1}
    Sleep  20s
    Wait Until Element Is Enabled   ${addproduct2}     60s
    click element    ${addproduct2}
    Wait Until Element Is Enabled     //div[contains(text(),"${product2}")]/../../..//span[@class="cpq-underline"]/span       60s
    click element     //div[contains(text(),"${product2}")]/../../..//span[@class="cpq-underline"]/following::span[1]/span
    Sleep  5s
    Wait Until Element Is Visible   //div[text()="One Time Charge"]/..//input[@type="number"]   20s
    Input Text  //div[text()="One Time Charge"]/..//input[@type="number"]     10
    Wait Until Element Is Visible       //button[contains(text(),"Apply")]      30s
    click element   //button[contains(text(),"Apply")]
    Sleep  15s
    Wait Until Element Is Enabled   //div[contains(text(),"${product2}")]/../../..//span[@class="cpq-underline"]/span     60s
    click element   //div[contains(text(),"${product2}")]/../../..//span[@class="cpq-underline"]/span
    sleep  10s
    Wait Until Element Is Visible   //div[text()="Recurring Charge"]/..//input[@type="number"]  10s
    Input Text      //div[text()="Recurring Charge"]/..//input[@type="number"]       30
    Wait Until Element Is Visible       //button[contains(text(),"Apply")]      10s
    click element   //button[contains(text(),"Apply")]
    Sleep  20s
    log  display the cpq page for verfication
    Capture Page Screenshot
Validate the MRC and OTC and Opportunity total in CPQ
     [Arguments]    ${product1}  ${product2}  ${product3}
     Wait Until Element Is Enabled      //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product1}")]/../../../.././div[3]//span/span     60s
     ${mrc1}        get text    //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product1}")]/../../../.././div[3]//span/span
     ${mrc2}        get text   //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product2}")]/../../../.././div[3]//span/span
     ${mrc3}        get text   //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product3}")]/../../../.././div[3]//span/span
     ${otc1}        get text   //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product1}")]/../../../.././div[4]//div/span/span
     ${otc2}        get text   //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product2}")]/../../../.././div[4]//div/span/span
     ${otc3}        get text   //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product3}")]/../../../.././div[4]//div/span/span
     ${rctotal}     get text   //div[@class="cpq-total-bar slds-col slds-no-flex"]/div//div//div[contains(text(),"Recurring Total")]/../div[2]
     ${otctotal}    get text   //div[@class="cpq-total-bar slds-col slds-no-flex"]/div//div//div[contains(text(),"OneTime Total")]/../div[2]
     ${oppo_total}  get text   //div[@class="cpq-total-bar slds-col slds-no-flex"]/div//div//div[contains(text(),"Opportunity Total")]/../div[2]
     #@{elements}    Set Variable    ${mrc1}    ${mrc2}    ${mrc3}    ${otc1}     ${otc2}     ${otc3}     ${rctotal}  ${otctotal}
     #${mrctotlacalculated_pratical}     remove string and convert to number    @{elements}
     ${mrc1} =  remove string  ${mrc1}  €
     ${mrc2} =  remove string  ${mrc2}  €
     ${mrc3} =  remove string  ${mrc3}  €
     ${otc1} =  remove string  ${otc1}  €
     ${otc2} =  remove string  ${otc2}  €
     ${otc3} =  remove string  ${otc3}  €
     ${rctotal} =  remove string  ${rctotal}  €
     ${otctotal} =  remove string  ${otctotal}  €
     ${oppo_total} =  remove string  ${oppo_total}  €
     ${otc1} =  convert to number   ${otc1}
     ${mrc1} =  convert to number   ${mrc1}
     ${mrc2} =  convert to number   ${mrc2}
     ${mrctotlacalculated_pratical} =  Evaluate   ${mrc1}+${mrc2}+${mrc3}
     #log to console     ${mrctotlacalculated_pratical}
     Should be equal as numbers     ${rctotal}      ${mrctotlacalculated_pratical}
     ${otctotalcalculated_pratical}=  evaluate  ${otc1} + ${otc2} + ${otc3}
     #log to console     ${otctotalcalculated_pratical}
     Should be equal as numbers     ${otctotal}      ${otctotalcalculated_pratical}
     ${oppototalcalculated_pratical} =  evaluate  ${mrctotlacalculated_pratical}+${otctotalcalculated_pratical}
     #log to console  ${oppototalcalculated_pratical}
     Should be equal as numbers     ${oppo_total}   ${oppototalcalculated_pratical}
     sleep  5s
     ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
     #Log to console      ${status}
     wait until page contains element    //span[text()='Next']/..    60s
     click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
     unselect frame
     Sleep  40s
     #${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe   60s
     #Run Keyword If    ${status} == False
     Reload Page
     sleep    40s
     Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
     select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
     page should contain element      //tr//td[contains(text(),"${product1}")]/../td[6]/span[contains(text(),"${otc1}")]
     page should contain element      //tr//td[contains(text(),"${product1}")]/../td[7]/span[contains(text(),"${mrc1}")]
     page should contain element     //tr//td[contains(text(),"${product2}")]/../td[7]/span[contains(text(),"${mrc2}")]
     #log to console  validation sucessful

UpdateAndAddSalesType for B2b products
    [Arguments]    ${product1}    ${product2}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_1}=    Set Variable    //td[normalize-space(.)='${product1}']
    ${product_2}=    Set Variable    //td[normalize-space(.)='${product2}']
    ${Viwe_quote}=    Set Variable    //button[@title="View Quote"]
    ${open_quote}=    Set Variable   //button[@title="Open Quote"]
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    #log to console    UpdateAndAddSalesType for 2 products
    sleep    10s
    wait until page contains element    ${update_order}    60s
    #log to console    selected new frame
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
    sleep    60s
    #Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    #select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    #${status}=  Run Keyword And Return Status  Element Should Be Visible   ${Viwe_quote}    60s
    #Run Keyword If   ${status}   click visible element    ${Viwe_quote}
    #Run Keyword unless   ${status}    click visible element   ${open_quote}
    #log to console  quote created
    #Unselect frame

validate createdOPPO for products
    [Arguments]    ${opportunity_product}
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible   //li[@title="Related"]//a[text()="Related"]   60s
    Run Keyword If    ${status_page} == False    Reload Page
    wait until page contains element    //li[@title="Related"]//a[text()="Related"]    60s
    click element    //li[@title="Related"]//a[text()="Related"]
    sleep  20s
    ScrollUntillFound    //div[@class="container rlvm forceRelatedListSingleContainer"]/../div[3]//div[@class="slds-card__footer"]/span
    page should contain element    //div[@class="container rlvm forceRelatedListSingleContainer"]/../div[3]//div[@class="slds-card__footer"]/span
    ${pageurl} =  get location
    click element       //div[@class="container rlvm forceRelatedListSingleContainer"]/../div[3]//div[@class="slds-card__footer"]/span
    wait until page contains element    //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr1}"]      60s
    page should contain element     //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr1}"]
    page should contain element      //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr2}"]
    page should contain element     //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr3}"]
    ${otc1} =    get text  //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr1}"]//following::td[4]/span/span
    ${otc2}=     get text  //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr2}"]//following::td[4]/span/span
    ${otc3}=     get text  //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr3}"]//following::td[4]/span/span
    ${rc1}=      get text  //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr1}"]//following::td[5]/span/span
    ${rc2}=      get text  //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr2}"]//following::td[5]/span/span
    ${rc3}       get text  //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr3}"]//following::td[5]/span/span
    ${otc1}=  remove string  ${otc1}  €
    ${otc2}=  remove string  ${otc2}  €
    ${otc3}=  remove string  ${otc3}  €
    ${rc1} =  remove string  ${rc1}  €
    ${rc2} =  remove string  ${rc2}  €
    ${rc3} =  remove string  ${rc3}  €
    ${otc1}=  replace string  ${otc1}  ,  .
    ${otc2}=  replace string  ${otc2}  ,  .
    ${otc3}=  replace string  ${otc3}  ,  .
    ${rc1}=  replace string  ${rc1}  ,  .
    ${rc2}=  replace string  ${rc2}  ,  .
    ${rc3}=  replace string  ${rc3}  ,  .
    ${otc1}=  convert to number   ${otc1}
    #${otc2}=  convert to integer   ${otc2}
    ${otc3}=  convert to number   ${otc3}
    ${rc1} =  convert to number   ${rc1}
    ${rc2} =  convert to number   ${rc2}
    ${rc3} =  convert to number   ${rc3}
    ${fyr1m}=  evaluate  ${fixed_charge for_Telia Sopiva Pro N}*${contract_lenght}
    ${fyr1ma} =  evaluate  ${fyr1m}+${otc1}
    ${fyr1}=  evaluate  ${fyr1ma}*${product_quantity}
    ${fyr2m}=  evaluate  ${rc2}*${contract_lenght}
    ${fyr2ma} =  evaluate  ${fyr2m}+${otc2}
    ${fyr2}=  evaluate  ${fyr2ma}*${product_quantity}
    ${lineitem1m} =   evaluate  ${rc1}* ${contract_lenght}+ ${otc1}
    ${lineitem1}=  evaluate  ${lineitem1m}*${product_quantity}
    ${lineitem2m} =   evaluate  ${rc2}* ${contract_lenght}+ ${otc2}
    ${lineitem2}=  evaluate  ${lineitem2m}*${product_quantity}
    ${lineitem3m} =   evaluate  ${rc3}* ${contract_lenght}+ ${otc3}
    ${lineitem3}=  evaluate  ${lineitem3m}*${product_quantity}
    ${lineitem_total}=  evaluate  ${lineitem1}+ ${lineitem2} +${lineitem3}
    ${fyr_total} =   evaluate  ${fyr1}+ ${fyr2}
    Capture Page Screenshot
    sleep  10s
    go to  ${pageurl}
    Sleep  40s
    log to console  1
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible   ${DETAILS_TAB}   40s
    Run Keyword If    ${status_page} == False    Reload Page
    sleep    60s
    click element  ${DETAILS_TAB}
    scrolluntillfound  //*[text()='Revenue Total' and @class='test-id__field-label']/../..
    #${lineitem_totalt}   get text  //span[text()='Revenue Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span
    ${fyr_totalt}    get text     //*[text()='FYR Total' and @class='test-id__field-label']/../..//lightning-formatted-text
    #${lineitem_totalt}=  remove string  ${lineitem_totalt}  €
    ${fyr_totalt}=  remove string  ${fyr_totalt}  €
    #${lineitem_totalt}=  replace string  ${lineitem_totalt}  ' '  ''
    #${lineitem_totalt}=  replace string  ${lineitem_totalt}  ,  .
    ${fyr_totalt}=  replace string  ${fyr_totalt}  ,  .
    ${fyr_totalt}=  convert to number  ${fyr_totalt}
    #Should be equal as strings  ${lineitem_totalt}  ${lineitem_total}
    page should contain element     //*[text()='Revenue Total' and @class='test-id__field-label']/../..//lightning-formatted-text[text()=normalize-space(.)="${lineitem_total}€"]
    Should be equal as strings  ${fyr_totalt}    ${fyr_total}
    log to console  2
    [Return]  ${lineitem_total}  ${fyr_total}

validate createOPPO values against quote value
    [Arguments]    ${opportunity_quote}
    ${Revenue_Total} =  get text        //*[text()='Revenue Total' and @class='test-id__field-label']/../..//lightning-formatted-text
    ${fyr_total} =  get text           //*[text()='FYR Total' and @class='test-id__field-label']/../..//lightning-formatted-text
    ${onetime_total} =  get text         //*[text()='OneTime Total' and @class='test-id__field-label']/../..//lightning-formatted-text
    ${recurring_total} =  get text     //*[text()='Recurring Total' and @class='test-id__field-label']/../..//lightning-formatted-text
    ${opportunity_total} =  get text     //*[text()='Opportunity Total' and @class='test-id__field-label']/../..//lightning-formatted-text
    #log to console  open quote
    search salesforce    ${opportunity_quote}
    wait until page contains element  //div[@class="listViewContainer safari-workaround"]//div[@class="slds-cell-fixed"]//span[@title="Quote Name"]/../../../../../..//a[@title="${opportunity_quote}"]
    click element		//div[@class="listViewContainer safari-workaround"]//div[@class="slds-cell-fixed"]//span[@title="Quote Name"]/../../../../../..//a[@title="${opportunity_quote}"]
    sleep  15s
    wait until page contains element            //ul//span[@title="Quote Number"]
    Wait Until Element Is Visible       //div[contains(@class,'active')]//span[text()='Related']/../../../li[2]/a//span[@class="title"]     60s
    click element        //div[contains(@class,'active')]//span[text()='Related']/../../../li[2]/a//span[@class="title"]
    Sleep  10s
    scrolluntillfound   //span[text()="Quote Value and FYR"]//following::span[text()='Revenue Total' and @class='test-id__field-label']/../../div[2]/span/span
    wait until page contains element    //span[text()="Quote Value and FYR"]//following::span[text()='Revenue Total' and @class='test-id__field-label']/../../div[2]/span/span
    Element text should be  //span[text()="Quote Value and FYR"]//following::span[text()='Revenue Total' and @class='test-id__field-label']/../../div[2]/span/span      ${Revenue_Total}
    Element text should be  //span[text()="Quote Value and FYR"]//following::span[text()='FYR Total' and @class='test-id__field-label']/../../div[2]/span/span          ${fyr_total}
    Element text should be  //span[text()="Quote Value and FYR"]//following::span[text()='OneTime Total' and @class='test-id__field-label']/../../div[2]/span/span      ${onetime_total}
    Element text should be  //span[text()="Quote Value and FYR"]//following::span[text()='Recurring Total' and @class='test-id__field-label']/../../div[2]/span/span    ${recurring_total}
    Element text should be  //span[text()="Quote Value and FYR"]//following::span[text()='Quote Total' and @class='test-id__field-label']/../../div[2]/span/span        ${opportunity_total}
    [Return]    ${Revenue_Total}    ${fyr_total}

validate lineitem totals in quote
    [Arguments]     ${oppo_name}    ${lineitem_total}  ${fyr_total}
    click element  //div[contains(@class,'active')]//span[text()='Related']
    wait until page contains element     //span[@title="Quote Line Items"]
    click visible element  //span[@title="Quote Line Items"]//following::span[text()="View All"]
    Sleep  10s
    wait until page contains element    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr1}"]/../../..//td[9]/span/span
    ${fyr1}     get text    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr1}"]/../../..//td[9]/span/span
    ${fyr2}     get text    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr2}"]/../../..//td[9]/span/span
    #${fyr3}     get text    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr3}"]/../../..//td[9]/span/span
    ${lineitem1}    get text    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr1}"]/../../..//td[10]/span/span
    ${lineitem3}  get text    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr3}"]/../../..//td[10]/span/span
    ${lineitem2}    get text    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr2}"]/../../..//td[10]/span/span
    ${fyr1} =  remove string  ${fyr1}  €
    ${fyr2} =  remove string  ${fyr2}  €
    #${fyr3} =  remove string  ${fyr3}  €
    ${lineitem1}=  remove string  ${lineitem1}  €
    ${lineitem2}=  remove string  ${lineitem2}  €
    ${lineitem3}=  remove string  ${lineitem3}  €
    ${lineitem1}=  replace string  ${lineitem1}  ,  .
    ${lineitem2}=  replace string  ${lineitem2}  ,  .
    ${lineitem3}=  replace string  ${lineitem3}  ,  .
    ${fyr1} =  replace string  ${fyr1}  ,  .
    ${fyr2} =  replace string  ${fyr2}  ,  .
    #${lineitem_total}=  remove string  ${lineitem_total}  €
    #${lineitem_total}=  replace string  ${lineitem_total}  ,  .
    #${fyr_total}=  remove string  ${fyr_total}  €
    #${fyr_total}=  replace string  ${fyr_total}  ,  .
    ${fyr1} =  convert to number   ${fyr1}
    ${fyr2} =  convert to number   ${fyr2}
    ${lineitem1} =  convert to number   ${lineitem1}
    ${lineitem2} =  convert to number   ${lineitem2}
    ${lineitem3} =  convert to number   ${lineitem3}
    ${lineitem_total1}=  evaluate  ${lineitem1}+ ${lineitem2} +${lineitem3}
    #${lineitem_total1}  Set Variable    ${lineitem_total1}€
    ${fyr_total1} =   evaluate  ${fyr1}+ ${fyr2}
    #${fyr_total1} =  Set Variable  ${fyr_total1}€
    Should be equal as strings  ${lineitem_total1}  ${lineitem_total}
    Should be equal as strings  ${fyr_total1}   ${fyr_total}
    #log to console  line item total verfied sucessfully
    click element  //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]
    sleep  60s
#    wait until page contains element        //div//div[@class="slds-grid primaryFieldRow"]//ul[@class="branding-actions slds-button-group slds-m-left--xx-small oneActionsRibbon forceActionsContainer"]/li[3]/a[@title="CPQ"]/div
#    force click element   //div//div[@class="slds-grid primaryFieldRow"]//ul[@class="branding-actions slds-button-group slds-m-left--xx-small oneActionsRibbon forceActionsContainer"]/li[3]/a[@title="CPQ"]/div
#    sleep    30s
#    select frame    xpath=//div[contains(@class,'slds')]/iframe
#    Log to console      Inside frame
#    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Create Order']/..    Create Order
#    Log to console      ${status}
#    wait until page contains element    //span[text()='Create Order']/..    60s
#    click element    //span[text()='Create Order']/..
#    Sleep  30s
#    unselect frame

validatation on order page
    [Arguments]  ${fyr_total}    ${Revenue_Total}
    scrolluntillfound  //div[@class="container forceRelatedListSingleContainer"]//span[@title="Order Products"]//following::a[11]//span[text()="View All"]
    page should contain element     //div[@class="container forceRelatedListSingleContainer"]//span[@title="Order Products"]//following::a[text()="${B2bproductfyr1}"]
    page should contain element     //div[@class="container forceRelatedListSingleContainer"]//span[@title="Order Products"]//following::a[text()="${B2bproductfyr2}"]
    page should contain element     //div[@class="container forceRelatedListSingleContainer"]//span[@title="Order Products"]//following::a[text()="${B2bproductfyr3}"]
    sleep  20s
    Wait Until Element Is Enabled   //a[@title='Details']   60s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //a[@title='Details']   60s
    Run Keyword If    ${status_page} == False    Reload Page
    sleep    60s
    click element   //a[@title='Details']
    sleep  5s
    #${fyr_total1} =  Set Variable  ${fyr_total}€
    scrolluntillfound  //span[text()='FYR Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span
    Element text should be  //span[text()='FYR Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span  ${fyr_total}
    Element text should be  //span[text()='Revenue Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span    ${Revenue_Total}
    #log to console  validatation sucessfull on order page

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
    #Sleep  20s
    #log to console    Updating sales type multiple products
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
    #Log To Console    ${count}
    #Log To Console    Searching and adding multiple products
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
    ${page} =  get location
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
    sleep  10s
    go to  ${page}
    sleep  30s
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
    ${iframe}    Set Variable    //div[@class="oneAlohaPage"]//iframe[@title="accessibility title"]
    Click Element    ${360_VIEW}
    sleep  120s
    wait until page contains element  //div//h2//span[text()="Dashboard"]   60s
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    ${status}   set variable    Run Keyword and return status    Frame should contain    ${AVAILABILITY_CHECK_BUTTON}    Availability check
    #Current Frame Should Contain    //button[text()="Availability check"]
    Wait until page contains element  //button[text()="Availability check"]    60s
    Click Button   //button[text()="Availability check"]
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
    Sleep  60s
    Wait Until Element Is Enabled  xpath=//input[@id="pointToPointInput"]/../span      60s
    Wait until page contains element    xpath=//input[@id="pointToPointInput"]      60s
    click element     xpath=//input[@id="pointToPointInput"]/../span
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
    sleep    30s
    ${isVisible}    Run Keyword and return status    Wait until page contains element    //button[contains(text(),"Continue")]  30s
    Run Keyword If    ${isVisible}    Click element    //button[contains(text(),"Continue")]
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
    sleep  5s
    Wait until page contains element    //input[@id='Name']    30s
    input text    //input[@id='Name']    ${opport_name}
    Sleep  2s
    Wait until page contains element    //textarea[@id='Description']    30s
    input text    //textarea[@id='Description']    Testopportunity description
    sleep  2s
    Wait until page contains element    //input[@id='CloseDate']    30s
    input text    //input[@id='CloseDate']    ${OPPORTUNITY_CLOSE_DATE}
    sleep  5s
    Click element    //div[@id='CreateB2BOpportunity_nextBtn']
    sleep    30s
    ${isVisible}    Run Keyword and return status    Wait until page contains element    //button[contains(text(),"Continue")]  30s
    Run Keyword If    ${isVisible}    Click element    //button[contains(text(),"Continue")]
    unselect frame
    #Sleep  60s
    wait until page contains element    //a[@title='CPQ']   60s
    Click element    //a[@title='CPQ']
Check the CPQ-cart contains the wanted products
    [Arguments]    ${product_name}
    ${iframe}    Set Variable    xpath=//div[contains(@class,'slds')]/iframe
    Sleep  30s
    Wait until element is enabled    ${iframe}    60s
    Wait until keyword succeeds    30s    2s    select frame    ${iframe}
    #Adding Yritysinternet Plus      Telia Yritysinternet Plus
    #Sleep  10s
    #${status}=    Run Keyword and return status    Wait until page contains element    //button/span[text()='${product_name}']   30s
    #Run Keyword If    ${status} == False    reload page
    #Sleep  100s
    Wait until page contains element    //button/span[text()='${product_name}']    60s
    ${value} =   get text    //button/span[text()='${product_name}']
    #log to console  ${value}
    unselect frame

Wait element to load and click
    [Arguments]    ${element}
    ${status}=    Run Keyword and return status    Wait until page contains element    ${element}    30s
    Run Keyword If    ${status} == False    Execute Javascript    window.location.reload(false);
    Run Keyword If    ${status} == False    Wait until page contains element    ${element}    30s
    Wait until keyword succeeds    30s    2s    Click Element    ${element}

creation of the another one quote to verify the service contract
    [Arguments]    ${oppo_name}
    #Go To Entity    ${oppo_name}
    wait until page contains element    //a[@title='CPQ']   60s
    force click element    //a[@title='CPQ']
    sleep  30s
    ${iframe}    Set Variable     xpath=//div[contains(@class,'slds')]/iframe
    Wait Until Element Is Enabled   ${iframe}   80s
    select frame    ${iframe}
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    Log to console      ${status}
    wait until page contains element    //span[text()='Next']/..    60s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    Sleep  40s
    unselect frame

creation of the quote without service contract
    [Arguments]    ${oppo_name}
    wait until page contains element    //a[@title='CPQ']   60s
    Click element    //a[@title='CPQ']
    sleep  30s
    ${iframe}    Set Variable     xpath=//div[contains(@class,'slds')]/iframe
    Wait Until Element Is Enabled   ${iframe}   80s
    select frame    ${iframe}
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    Log to console      ${status}
    wait until page contains element    //span[text()='Next']/..    60s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    Sleep  40s
    unselect frame

Verify that warning banner is displayed on opportunity page
    [Arguments]    ${OPPORTUNITY_NAME}
    [Documentation]    After creating opportunity without service contract make sure warning banner is displayed on the opportunity page
    Go To Entity   ${OPPORTUNITY_NAME}
    #Wait until element is visible    ${OPPORTUNITY_WARNING_BANNER}  30s

Verify that warning banner is displayed on opportunity page sevice contract
    [Arguments]    ${OPPORTUNITY_NAME}
    [Documentation]    After creating opportunity without service contract make sure warning banner is displayed on the opportunity page
    Go To Entity   ${OPPORTUNITY_NAME}
    Wait until element is visible    ${SERVICE_CONTRACT_WARNING_oppo}  30s


Verify that warning banner is not displayed on opportunity page
    [Arguments]    ${oppo_name}
    [Documentation]    After creating oppotunity which has an active cutomer ship contract, the banner should not be available
    Go To Entity    ${oppo_name}
    Wait until element is visible   //div[@class='entityNameTitle slds-line-height_reset'][text()='Opportunity']   30s
    Page should not contain element    ${OPPORTUNITY_WARNING_BANNER}

Verify Warning banner about existing of duplicate contract
    [Arguments]    ${oppo_name}
    [Documentation]  This warning should be visible when multiple customer ship contract are available for the oppo
    Go To Entity    ${oppo_name}
    Wait until element is visible   //div[@class='entityNameTitle slds-line-height_reset'][text()='Opportunity']   30s
    Page should contain element     //div[@class="slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_info cContractStatusToasts"]//h2[text()='Note! Selected Account has multiple active customership contracts, please confirm that the pre-populated customership contract is valid for this opportunity.']

Verify Warning banner about Manual selection of contract

    [Arguments]    ${oppo_name}
    [Documentation]  This warning should be visible when multiple customer ship contract are available for the oppo
    Go To Entity    ${oppo_name}
    Wait until element is visible   //div[@class='entityNameTitle slds-line-height_reset'][text()='Opportunity']   30s
    Page should contain element     //div[@class="slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_info cContractStatusToasts"]//h2[text()='Note! Selected Account has multiple active customership contracts, please select the preferred customership contract manually on the record.']


Add product to cart (CPQ)
    [Documentation]     In the CPQ cart search for the wanted product and add it to the cart
    [Arguments]    ${pname}=${product_name}
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    ${CPQ_SEARCH_FIELD}    60s
    input text    ${CPQ_SEARCH_FIELD}    ${pname}
    Wait element to load and click  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    wait until page contains element    //button/span[text()='${pname}']   60s
    #scrolluntillfound    ${CPQ_CART_NEXT_BUTTON}
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    #Log to console      ${status}
    wait until page contains element    //span[text()='Next']/..    100s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    #click element    ${CPQ_CART_NEXT_BUTTON}
    unselect frame
    sleep    30s

Update products
    [Documentation]     Create Quote in draft status in the post-CPQ omniscript
    ${iframe}   Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    ${Viwe_quote}=    Set Variable    //button[@title="View Quote"]
    ${open_quote}=    Set Variable   //button[@title="Open Quote"]
    Wait Until Element Is Enabled   ${iframe}   80s
    select frame    ${iframe}
    #Wait until page contains element    ${SERVICE_CONTRACT_WARNING}     60s
    Wait element to load and click      ${SALES_TYPE_DROPDOWN}
    Click element   ${NEW_MONEY_NEW_SERVICES}
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    #Wait element to load and click  //form[@id="a1q0E000000i2dBQAQ-12"]/div/div/button
    sleep   50s
    #Wait until page contains element    ${SERVICE_CONTRACT_WARNING}     30s
    #${status}=  Run Keyword And Return Status  Element Should Be Visible   ${open_quote}    100s
    #Run Keyword If   ${status}   Click element    ${open_quote}
    #Run Keyword unless   ${status}    Click element   ${Viwe_quote}
    #Wait element to load and click  //button[@id="Open Quote"]
    unselect frame
    Wait until page contains element    //h1/div[@title='${OPPORTUNITY_NAME}']  30s

Update products OTC and RC
    ${iframe}   Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${Viwe_quote}=    Set Variable    //button[@title="View Quote"]
    ${open_quote}=    Set Variable   //button[@title="Open Quote"]
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    Wait Until Element Is Enabled   ${iframe}   80s
    select frame    ${iframe}
    Wait until page contains element    //div[@id="OpportunityLineItems"]/ng-include/div/table/tbody/tr[3]/td[4]/input  60s
    Input Text  //div[@id="OpportunityLineItems"]/ng-include/div/table/tbody/tr[3]/td[4]/input      200
    Input Text  //div[@id="OpportunityLineItems"]/ng-include/div/table/tbody/tr[3]/td[5]//input      200
    Wait element to load and click      //div[@id="OpportunityLineItems"]/ng-include/div/table/tbody/tr[3]/td[8]/select
    Click element   //table[@class='tg']/tbody//tr[3]/td[8]/select/option[@value='New Money-New Services']
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    Unselect Frame
    sleep    80s
    #Reload Page
    #Wait element to load and click  //form[@id="a1q4E000002zpz1QAA-12"]/div/div/button
#    select frame    ${iframe}
#    Sleep  2s
#    ${status}=  Run Keyword And Return Status  Element Should Be Visible   ${open_quote}    100s
#    Run Keyword If   ${status}   Click element    ${open_quote}
#    Run Keyword unless   ${status}    Click element   ${Viwe_quote}
#    #Wait element to load and click  //button[@id="View Quote"]
#    unselect frame
#    sleep   10s

Check prices are correct in quote line items
    sleep   10s
    Wait until page contains element   //a/span[text()='Quote Line Items']      30s
    Force click element   //a/span[text()='Quote Line Items']
    Wait until element is visible   //table/tbody/tr/td[5]/span/span[text()='200,00 €']     30s
    Wait until element is visible   //table/tbody/tr/td[6]/span/span[text()='200,00 €']     30s

Check opportunity value is correct
    ScrollUntillFound    //h3/button/span[text()='Opportunity Value and FYR']
    Wait until page contains element    //span[text()='OneTime Total']/../../../div/div[2]/span//lightning-formatted-text[text()='200,00 €']    30s
    Wait until page contains element    //span[text()='Monthly Recurring Total']/../../../div/div[2]/span//lightning-formatted-text[text()='200,00 €']   30s

Check service contract is on Draft Status
    [Documentation]    On account page check service contracts and verify that created one is on draft status
    Wait element to load and click    ${ACCOUNT_RELATED}
    Wait element to load and click    //h2/a/span[text()='Contracts']
    Wait until page contains element    //table/tbody/tr[2]/td[2]/span/span[@title="Service Contract"]    30s
    Wait until page contains element    //table/tbody/tr[2]/td[4]/span/a[text()='Telia Verkkotunnuspalvelu']    30s
    Wait until page contains element    //table/tbody/tr[2]/td[5]/span/span[text()='Draft']    30s

Select rows to delete the entities
    [Arguments]         ${entities}
    [Documentation]    Used to delete all the existing contracts for the business account
    #Force Click element    //span[text()='View All']/span[text()='${entities}']
    Force click element    //span[contains(text(),"${entities}")]/../../span[text()='View All']
    Sleep    10s
    wait until element is visible           //h1[@title='${entities}']
    #Wait Until Element Is Visible    ${table_row}    60s
    ${count}=    get element count    ${table_row}
    #log to console       ${count}
    : FOR    ${i}    IN RANGE    1000
    \   Exit For Loop If    ${i} > ${count}-1
    \   Wait Until Element Is Visible    ${table_row}    60s
    \   Delete all entities    ${table_row}
    ${count}=    get element count    ${table_row}
    Run Keyword Unless   '${count}'=='0'  Select rows to delete the entities   ${entities}

Select rows to delete the contract
    [Documentation]    Used to delete all the existing contracts for the business account

    ${count}=    get element count    ${table_row}
    #log to console    ${count}
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > ${count}-1
    \    Delete all Contracts    ${table_row}
    ${count}=    get element count    ${table_row}
    Run Keyword Unless   '${count}'=='0'  Select rows to delete the contract


Select rows to delete the entities for service contract
    [Arguments]         ${entities}
    [Documentation]    Used to delete all the existing contracts for the business account
    #Force Click element    //span[text()='View All']/span[text()='${entities}']
    Force click element    //span[contains(text(),"${entities}")]/../../span[text()='View All']
    Sleep    10s
    wait until element is visible           //h1[@title='${entities}']
    ${status}=  Run Keyword And Return Status  Element Should Be Visible   //button[@title="Show quick filters"]   100s
    #Run Keyword If   ${status}   Click element    //button[@title="Show quick filters"]
    Run Keyword unless   ${status}    reload page
    sleep  40s
    Click element    //button[@title="Show quick filters"]
    Sleep  20s
    Wait Until Element Is Visible    //h2[text()="Filters"]    60s
    #${count}=    get element count    ${table_row}
    Click element   //legend[text()="Agreement Type"]/..//div/span[2]/label/span
    sleep  3s
    click element    //button[@title="Apply"]
    click element   //button[@title="Close Filters"]
    reload page
    Sleep  60s
    ${status}=  Run Keyword And Return Status  Element Should Be Visible   //*[contains(text(),"No items to display.")]   60s
    Run Keyword If   ${status}      check the customer contract available or not
    Run Keyword unless   ${status}  delete the service contract displayed in account page

delete the service contract displayed in account page
    : FOR    ${i}    IN RANGE    1000
    #\    Exit For Loop If    ${i} > ${count}-1
    \   Wait Until Element Is Visible    ${table_row}    60s
    \   ${count}=    get element count    ${table_row}
    \   log to console       ${count}
    \    exit for loop if       ${count}==0
    \    Delete all entities    ${table_row}

check the customer contract available or not

    Click element    //button[@title="Show quick filters"]
    Sleep  20s
    Wait Until Element Is Visible    //h2[text()="Filters"]    60s
    #${count}=    get element count    ${table_row}
    Click element   //legend[text()="Agreement Type"]/..//div/span[1]/label/span
    sleep  3s
    click element    //button[@title="Apply"]
    click element   //button[@title="Close Filters"]
    reload page
    Sleep  60s
    ${status}=  Run Keyword And Return Status  Element Should Be Visible   //*[contains(text(),"No items to display.")] 60s
    Run Keyword If   ${status}      Create contract Agreement  Customership
    Run Keyword unless  ${status}    delete if the customership contract currently available more than one

delete if the customership contract currently available more than one
    [Documentation]    Used to delete the customership contract  for the business account if more than one

    ${count}=    get element count    ${table_row}
    #log to console    ${count}
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > ${count}
    \    Delete all Contracts    ${table_row}
    ${count}=    get element count    ${table_row}
    Run Keyword Unless   '${count}'=='0'  Select rows to delete the contract

Delete all entities from Accounts Related tab
    [Arguments]     ${entities}
    wait until element is visible    ${ACCOUNT_RELATED}    60s
    Force click element    ${ACCOUNT_RELATED}
    ${status}=    run keyword and return status    Element Should Be Visible    //span[@title='${entities}']
    Run keyword Unless    ${status}    Run Keyword With Delay    0.10s    Click Element    xpath=${ACCOUNT_RELATED}
    Sleep    30s
    ScrollUntillFound    //span[text()='${entities}']/../../a/span[@title="${entities}"]
    Execute Javascript    window.scrollTo(0,800)
    Sleep  30s
    ${visible}=    run keyword and return status    Element Should Be Visible    //span[text()='View All']/span[text()='${entities}']
    run keyword if    ${visible}    ScrollUntillFound    //span[text()='View All']/span[contains(text(),'${entities}')]
    #//span[contains(text(),'${entities}')]/../../span/../../../a
    ${display}=    run keyword and return status    Element Should Be Visible    //span[text()='View All']/span[contains(text(),'${entities}')]
    run keyword if    ${display}    Select rows to delete the entities     ${entities}



Delete all existing contracts from Accounts Related tab
    wait until element is visible    ${ACCOUNT_RELATED}    60s
    Force click element    ${ACCOUNT_RELATED}
    #${status}=    run keyword and return status    Element Should Be Visible    //span[@title='Contracts']
    #run keyword if    ${status}    Run Keyword With Delay    0.10s    Click Element    xpath=${ACCOUNT_RELATED}
    #Sleep    15s
    ScrollUntillFound  //span[text()='View All']/span[text()='Opportunities']
    #Log to console   found element
    sleep  5s
    ${Status}   Run keyword and return status   Page should contain element  //span[text()='View All']/span[text()='Contracts']
    #Log to console  ${Status}
    Return From Keyword if  '${Status}' == 'False'
    Capture Page Screenshot
    ScrollUntillFound   //span[text()='View All']/span[text()='Contracts']
    ${display}=    run keyword and return status    Element Should Be Visible    //span[text()='View All']/span[text()='Contracts']
    run keyword if    ${display}    Force Click element    //span[text()='View All']/span[text()='Contracts']
    Sleep    10s
    Wait Until Element Is Visible    ${table_row}    60s
    Select rows to delete the contract

Delete all assets
    ${Accounts_More}  set variable   //div[@class="slds-tabs_default"]//li[6]//button
#     //div[contains(@class,'tabset slds-tabs_card uiTabset')]/div[@role='tablist']/ul/li[8]/div/div/div/div/a

    wait until element is visible  ${Accounts_More}  60s
    Click element  ${Accounts_More}
    Click element   //div[@class="slds-tabs_default"]//li[6]//a//span[contains(text(),"Assets")]
    Wait until element is visible  //span[@title='Assets']  60s
    Click element  //span[@title='Assets']
    Wait until element is visible  //h1[@title='Assets']  60s
    sleep  10s
    Select rows to delete the contract


Delete all entities existing service contract from Accounts Related tab
    [Arguments]     ${entities}
    wait until element is visible    ${ACCOUNT_RELATED}    60s
    Force click element    ${ACCOUNT_RELATED}
    ${status}=    run keyword and return status    Element Should Be Visible    //span[@title='${entities}']
    Run keyword Unless    ${status}    Run Keyword With Delay    0.10s    Click Element    xpath=${ACCOUNT_RELATED}
    Sleep    15s
    Sleep    15s
    ScrollUntillFound    //span[contains(text(),'${entities}')]/../../a/span[@title="${entities}"]
    #//span[contains(text(),'${entities}')]/../../span/../../../a
    ${display}=    run keyword and return status    Element Should Be Visible    //span[text()='View All']/span[contains(text(),'${entities}')]
    run keyword if    ${display}    Select rows to delete the contract    ${entities}
    Create contract Agreement  Customership

Delete all entries from Search list
    [Arguments]     ${entities}
    Element Should Be Visible    //a[@title='View more ${entities} search results']//span[text()='View More']
    click element  //a[@title='View more ${entities} search results']//span[text()='View More']
    Sleep    10s
    wait until element is visible           //div[text()='Contacts']
    #Wait Until Element Is Visible    ${table_row}    60s
    #${count}=    get element count    ${table_row}
    : FOR    ${i}    IN RANGE    1000
    #\    Exit For Loop If    ${i} > ${count}-1
    \   Wait Until Element Is Visible    ${table_row}    60s
    \   ${count}=    get element count    ${table_row}
    \   log to console       ${count}
    \    exit for loop if       ${count}==0
    \    Delete all entities    ${table_row}

Delete all entities
    [Arguments]    ${table_row}
    ${IsVisible}=    Run Keyword And Return Status    element should be visible    ${table_row}
    Run Keyword if    ${IsVisible}    Delete row items    ${table_row}


Delete all Contracts
    [Arguments]    ${table_row}
    ${IsVisible}=    Run Keyword And Return Status    element should be visible    ${table_row}
    Run Keyword if    ${IsVisible}    Delete row items    ${table_row}

Delete row items
    [Arguments]    ${table_row}
    [Documentation]    Used to delete the individual row
    Force Click element    ${table_row}
    wait until element is visible    //a[@title='Delete']   60s
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
    #log to console    Validating contact relationship
    Execute Javascript    window.location.reload(false);
    Wait element to load and click    ${ACCOUNT_RELATED}
    ScrollUntillFound    //h2/a/span[text()='Related Accounts']
    Click element    //h2/a/span[text()='Related Accounts']
    Wait until page contains element    //table/tbody/tr/th/span/a[text()='Aacon Oy']    20s
    Wait until page contains element    //table/tbody/tr/th/span/a[text()='${LIGHTNING_TEST_ACCOUNT}']    20s
    Wait until page contains element    //table/tbody/tr[2]/td[2]/span/span/img[@class='slds-truncate checked']    20s

Navigate to related tab
    Wait Until Element Is Visible    ${ACCOUNT_RELATED}    60s
    Force click element    ${ACCOUNT_RELATED}

Add account owner to account team
    ${account_owner}=    Get Text   //div//p[text()="Account Owner"]/..//a
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
    Wait until page contains element    //input[@title='Search People']     60s
    Input text  //input[@title='Search People']     ${new_team_member}
    Wait element to load and click  //a[@role='option']/div//div[@title='${new_team_member}']
    Wait element to load and click  //a[text()='--None--']
    force click element  //div[@class="select-options"]//ul/li/a[@title="${role}"]
    Sleep  10s
    Click element   //button[@title='Save']
    sleep   30s
#    ${IsVisible}=    Run Keyword And Return Status    element should be visible    //ul//li[text()="Cannot create a duplicate entry"]
#    Run Keyword if    ${IsVisible}    Click element     //div[@class="pageError hideEl"]/..//button//span[text()="Cancel"]
#    Run Keyword if    ${IsVisible}    Delete team member from account
#    Run Keyword if    ${IsVisible}    Add new team member   ${account_owner}
Validate that team member is created succesfully
    [Arguments]     ${name}=Sales,Admin     ${role}=
    reload page
    Wait until page contains element   //table/tbody/tr/th/span/span[text()='${name}']     120s
    Wait until page contains element    //table/tbody/tr/th/span/span[text()='${name}']/../../../td[2]/span/span[text()='${role}']  30s

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
    \   Wait until page contains element    ${table_row}   30s
    \   Delete row items    ${table_row}

Change team member role from account
    Wait until page contains element    ${table_row}
    Force Click element    ${table_row}
    Sleep  20s
    ${isAccountOwner}=    Run keyword and return status    Wait until page contains element    //a[@title='Edit']    30s
    Run Keyword if    ${isAccountOwner} == False    reload page
    Run Keyword if    ${isAccountOwner} == False    Wait until page contains element    ${table_row}        60s
    Run Keyword if    ${isAccountOwner} == False    Force Click element    ${table_row}
    Wait until page contains element    //a[@title='Edit']  60s
    Force Click element  //a[@title='Edit']
    Wait element to load and click    //a[text()='--None--']
    Wait element to load and click    //ul/li[2]/a[text()='Account Manager']
    Click element    //button[@title='Save']
    Wait until page contains element    //table/tbody/tr/td[2]/span/span[text()='Account Manager']    30s
    sleep    10s

Change account owner to
    [Arguments]    ${new_owner}
    [Documentation]    Checks if account given as a parameter is already account owner and if not proceeds to change the account owner
    ${isAccountOwner}=    Run keyword and return status    Wait until page contains element    //div//p[text()="Account Owner"]/..//a[text()="${new_owner}']    30s
    Run Keyword if    ${isAccountOwner} == False    Open change owner view and fill the form    ${new_owner}

Open change owner view and fill the form
    [Arguments]    ${username}
    #Wait element to load and click    //button[@title='Change Owner']
    #Wait until page contains element    //input[@title='Search People']
#    Wait element to load and click      //div[@class="slds-form-element__control slds-grid itemBody"]//button[@title='Change Owner']
    Wait element to load and click      //button[@title='Change Owner']
    Wait until page contains element    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]  60s
    input text     //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]    ${username}
    Sleep  10s
    Press Enter On   //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]
    Sleep    10s
    Click element   //a[text()="Full Name"]//following::a[text()='${username}']
    #Click element    //a[text()='${username}']
    sleep  10s
    #Wait element to load and click  //a[@role='option']/div/div[@title='${username}']
#   Click element   //div[@class='modal-footer slds-modal__footer']//button[@title='Change Owner']
    Click element  //button[text()='Change Owner']
    sleep   40s


Validate that account owner cannot be different from the group account owner
    Wait until page contains element    //span[text()='Owner ID: Account Owner cannot be different from the Group Account owner']   30s
    Click button  //button[text()='Cancel']

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
    #log to console    UpdateAndAddSalesType
    #sleep    30s
    #Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    wait until page contains element    ${update_order}    60s
    #log to console    selected new frame
    wait until page contains element    ${product_list}    70s
    click element    ${product_list} //following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_list}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    sleep  5s
    click element    //label[normalize-space(.)='Direct Order' and @class='vlc-check-label ng-binding']/..//input
    sleep    2s
    click element    //button[normalize-space(.)='Next']
    unselect frame
    sleep    60s

openOrderFromDirecrOrder
    #select frame  //div[contains(@class,'iframe')]/iframe
    Sleep  20s
    select frame   //div[@class="windowViewMode-normal oneContent active lafPageHost"]/div[@class="oneAlohaPage"]/force-aloha-page/div[contains(@class,'iframe')]/iframe
    #wait until page contains element   //span[text()='Click View Quote button to close this process & navigate to the Quote Screen.']    60s
    page should contain element  //button[@title='View Order']
    Click Visible Element  //button[@title='View Order']
    Sleep   20s
    unselect frame

OpenOrderPage
    #Log to console      Open Order
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
    #go to entity  ${order_no}
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //span[text()='Details']  60s
    Run Keyword If    ${status_page} == False    Reload Page
    sleep    60s
    click element  //span[text()='Details']
    wait until page contains element  //span[text()='Fulfilment Status']/../following-sibling::div/span/span  60s
    Sleep  10s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible   //span[text()='MultibellaCaseGuiId']/../..//span[@class='uiOutputText']  60s
    Run Keyword If    ${status_page} == False    Reload Page
    sleep    60s
    ${case_GUI_id}  get text  //span[text()='MultibellaCaseGuiId']/../..//span[@class='uiOutputText']
    ${case_id}  get text  //span[text()='MultibellaCaseId']/../..//span[@class='uiOutputText']
    should not be equal as strings  ${case_GUI_id}  ${EMPTY}
    should not be equal as strings  ${case_id}  ${EMPTY}
    #log to console  ${case_GUI_id}.this is GUIId
    #log to console  ${case_id} .this is case id
    [return]  ${case_GUI_id}


SwithchToUser
    [Arguments]  ${user}
    #log to console   ${user}.this is user
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}    ${user}
    sleep  30s
    press key   xpath=${SEARCH_SALESFORCE}    \\13
    wait until page contains element    //a[text()='${user}']     45s
    #wait until page contains element  //span[@title='${user}']//following::div[text()='User']   30s
    #click element  //span[@title='${user}']//following::div[text()='User']
    click element  //a[text()='${user}']
    sleep  90s
    wait until page contains element  //div[@class='primaryFieldAndActions truncate primaryField highlightsH1 slds-m-right--small']//span[text()='${user}']  60s
    wait until page contains element  //div[text()='User Detail']   60s
    click element  //div[text()='User Detail']
    wait until page contains element  //div[@id="setupComponent"]   60s
    Wait until element is visible  //div[contains(@class,'iframe')]/iframe  60s
    select frame  //div[contains(@class,'iframe')]/iframe
    wait until page contains element  //td[@class="pbButton"]/input[@title='Login']   60s
    force click element  //td[@class="pbButton"]/input[@title='Login']
    sleep  20s
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
    #Log to console  ${count}
    click element   ${setting_lighting}
    sleep  2s
    wait until page contains element   //a[text()='Log Out']  60s
    click element  //a[text()='Log Out']
    sleep  10s


ChangeThePriceList
    [Arguments]      ${price_list_new}
    ${price_list_old}=     get text        //span[text()='Price List']//following::a
    ${B2B_Price_list_delete_icon}=    Set Variable    //span[contains(text(),'PriceList__c')]/following::button[@title='Clear Selection'][1]
    #${B2B_Price_list_delete_icon}=    Set Variable    //span[@class='pillText'][contains(text(),'${price_list_old}')]/following::span[@class='deleteIcon'][1]
    #log to console    this is to change the PriceList
    #sleep    30s
    #Execute JavaScript    window.scrollTo(0,600)
    #scroll page to element    //button[@title="Edit Price Book"]
    ScrollUntillFound    //button[@title="Edit Price List"]
    Execute JavaScript    window.scrollTo(0,200)
    page should contain element  //span[text()='Price Book']//following::a[text()='Standard Price Book']
    wait until page contains element    //button[@title="Edit Price List"]  60s
    click element    //button[@title="Edit Price List"]
    wait until page contains element  ${B2B_Price_list_delete_icon}   20s
    scroll page to element  ${B2B_Price_list_delete_icon}
    force click element    ${B2B_Price_list_delete_icon}
    wait until page contains element    //input[@placeholder='Search Price Lists...']    60s
    input text    //input[@placeholder='Search Price Lists...']    ${price_list_new}
    sleep    3s
    click element    //*[@title='${price_list_new}']/../../..
    sleep  5s
    Wait until element is visible  //label[text()='Price Book']//following::button[@title="Save"]  30s
    click element   //label[text()='Price Book']//following::button[@title="Save"]
    #click element       //span[text()='Products With Manual Pricing']//following::span[text()='Save']
    sleep    3s
    execute javascript    window.scrollTo(0,0)
    wait until page contains element  //span[@class='test-id__field-label' and text()='Price List']/../..//a[text()='${price_list_new}']  60s
    page should contain element  //span[@class='test-id__field-label' and text()='Price List']/../..//a[text()='${price_list_new}']
    sleep    5s


#ChangeThePriceList
#    [Arguments]    ${price_list_old}  ${price_list_new}
#    ${B2B_Price_list_delete_icon}=    Set Variable    //span[@class='pillText'][contains(text(),'Standard Pricebook')]/following::span[@class='deleteIcon']
#    log to console    this is to change the PriceList
#    #sleep    30s
#    #Execute JavaScript    window.scrollTo(0,600)
#    #scroll page to element    //button[@title="Edit Price Book"]
#    ScrollUntillFound    //button[@title="Edit Price List"]
#    page should contain element  //span[text()='Price Book']//following::a[text()='Standard Price Book']
#    click element    //button[@title="Edit Price List"]
#    #sleep    10s
#    wait until page contains element  //span[@class='pillText'][contains(text(),'${price_list_old}')]/following::span[@class='deleteIcon'][1]   20s
#    click element    //span[@class='pillText'][contains(text(),'${price_list_old}')]/following::span[@class='deleteIcon'][1]
#    sleep    3s
#    input text    //input[@title='Search Price Lists']    ${price_list_new}
#    sleep    3s
#    click element    //*[@title='${price_list_new}']/../../..
#    #click element    //button[@title='Save']
#    click element       //span[text()='Products With Manual Pricing']//following::span[text()='Save']
#    sleep    3s
#    execute javascript    window.scrollTo(0,0)
#    page should contain element  //span[@class='test-id__field-label' and text()='Price List']/../..//a[text()='${price_list_new}']
#    sleep    3s


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
    wait until page contains element  //li[@title="Related"]//a[text()="Related"]  30s
    click element  //li[@title="Related"]//a[text()="Related"]
    scrolluntillfound  //div[text()='Add Opportunity Team Members']
    wait until page contains element  //a/span[text()='Opportunity Team']  30s
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
    wait until page contains element  //div[@class="modal-footer slds-modal__footer"]//button[@title="Save"]  30s
    force click element  //div[@class="modal-footer slds-modal__footer"]//button[@title="Save"]
    Sleep  20s
    #click element   //div//span[text()="View All"]
    ${status_page}    Run Keyword And Return Status    wait until page contains element   //a[text()='${team_mem_1}']   60s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False   wait until page contains element    //span[@class='title' and text()='Related']    60s
    Run Keyword If    ${status_page} == False   click element  //span[@class='title' and text()='Related']
    wait until page contains element    //a[text()='${team_mem_1}']   30s
    page should contain element   //a[@title='${team_mem_1}']
    #logoutAsUser  Sales Admin
    #login to salesforce as digisales lightning user vlocupgsandbox
    #swithchtouser  B2B DigiSales


clickingOnSolutionValueEstimate
    [Arguments]    ${c}=${oppo_name}
    #log to console    ClickingOnSVE
    click element    xpath=//a[@title='Solution Value Estimate']
    #wait until page contains element    xpath=//h1[text()='${b}']    30s
    sleep    40s


addProductsViaSVE
     [Arguments]    ${pname_sve}=${product_name}
     #log to console  ${pname_sve}.this is added via SVE
     select frame  xpath=//div[contains(@class,'slds')]/iframe
     #force click element  //div[@class='btn custom-button btn-primary pull-right']
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
     sleep  2s
     click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/select[@ng-model='p.SalesType']/option[@value='${sales_type_value}']
     sleep  5s
     click element  //input[@type="number"][@ng-model="p.ContractLength"]
     input text   //input[@type="number"][@ng-model="p.ContractLength"]   ${contract_lenght}
     #click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][1]/td/select[@ng-model='p.ContractLength']/option[@value='${contract_lenght}']
     ${fyr_value}=      evaluate  ((${RC}*${contract_lenght})+ ${NRC}) * ${product_quantity}
     ${revenue_value}=  evaluate  ((${RC}*${contract_lenght})+ ${NRC}) * ${product_quantity}
     page should contain element  //th[normalize-space(.)='FYR']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model="p.RecurringTotalt"]/../following-sibling::td[normalize-space(.)='${fyr_value}.00'][1]
     page should contain element  //th[normalize-space(.)='FYR']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model="p.RecurringTotalt"]/../following-sibling::td[normalize-space(.)='${revenue_value}.00'][2]
     wait until page contains element  //button[contains(text(),"Save")]   60s
     click element  //button[contains(text(),"Save")]
     unselect frame
     sleep   30s
     [Return]   ${fyr_value}


ApproveB2BGTMRequest
    [Arguments]  ${Approver_name}  ${oppo_name}
    swithchtouser  ${Approver_name}
    #Log to console  ${Approver_name} has to approve
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
    #Log to console      approved
    logoutAsUser  ${Approver_name}
    sleep  10s
    Login to Salesforce as System Admin


openQuoteFromOppoRelated
    [Arguments]  ${oppo_no}  ${quote_no}
    go to entity  ${oppo_no}
    wait until page contains element  ${ACCOUNT_RELATED}   30s
    click element  ${ACCOUNT_RELATED}
    wait until page contains element   //a//span[@title='Opportunity Team']   30s
    scrolluntillfound  //a[text()='${quote_no}']
    click element  //a[text()='${quote_no}']
    #wait until page contains element  //span[text()='${quote_no}']/..//span[@class="uiOutputText"]   60s
    #page should contain element  //span[text()='${quote_no}']/..//span[@class="uiOutputText"]

SalesProjectOppurtunity
    [Arguments]  ${case_number}
    reload page
    sleep  25s
    click element  ${DETAILS_TAB}
    wait until page contains element  //button[@title='Edit Subject']     60s
    click element  //button[@title='Edit Subject']
    #wait until element is visible  //a[@class='select' and text()='New']   30
    #click element  //a[@class='select' and text()='New']
    #sleep  3s
    #click element  //a[@title="In Case Assessment"]
    ${date}  get date from future  7
    Wait Until Element Is Visible    //div//label[text()='Offer Date']/..//following-sibling::div/input    60s
    Input Text    //div//label[text()='Offer Date']/..//following-sibling::div/input    ${date}
    #Input Quick Action Value For Attribute    Offer Date    ${date}
    #input text   //span[text()='Offer Date']/../following-sibling::div/input   ${date}
    Scroll Page To Location    0    2500
    select checkbox  //input[@name="telia_support_functions_sales_project__c"]
    Scroll Page To Location    0    1400
    select option from dropdown  //lightning-combobox//label[text()="Case Assessment Outcome"]/..//div/*[@class="slds-combobox_container"]/div  Sales Project
    #force click element  //a[@class='select' and text()='--None--']
    #click element   //a[@title='Sales Project']
    Sleep   10s
    force click element     //button[@title='Save']
    #Log to console      Case Saved
    Scroll Page To Location    0    0
    force click element  //a[text()="Feed"]
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
    #log to console      dropdown selected
    sleep  5s
    click element  //span[text()='Sales Support Case Lead']/../..//input[@type="checkbox"]
    scroll page to location  0  200
    wait until page contains element  //div[@class='bottomBarRight slds-col--bump-left']//span[text()="Save"][1]/..  20s
    wait until element is visible  //div[@class='bottomBarRight slds-col--bump-left']//span[text()="Save"][1]/..  20s
    click element  //div[@class='bottomBarRight slds-col--bump-left']//span[text()="Save"][1]/..
    capture page screenshot
    #Log to console      enter comments
    sleep   10s
    Force click element     //span[text()='Comment']
    sleep   10s
    Input Text      //textarea[@class=' textarea']      Test Comments
    #Log to console      save comments
    sleep   10s
    Force click element  //button[@class='slds-button slds-button--brand cuf-publisherShareButton MEDIUM uiButton']/span
    sleep   10s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible   //span[text()='Commit Decision']  60s
    Run Keyword If    ${status_page} == False    Reload Page
    sleep    60s
    #Wait until element is visible   //span[text()='Commit Decision']    60s
    Force click element  //span[text()='Commit Decision']
    sleep   15s
    Wait until element is visible   //button[@title='Next']     30s
    force click element  //button[@title='Next']

ContractStateMessaging
    #log to console    NextButtonOnOrderPage
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #Log to console      Inside frame
    wait until page contains element   //button[@class="form-control btn btn-primary ng-binding" and normalize-space(.)='Open Order']
    #Log to console      Element found
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
    #log to console    ${cid}.cid receioved
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
    #log to console    selecting Request Date FLow chart page
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
    #log to console    a
    click element    //div[normalize-space(.) = 'Additional PDU for 52 RU']/ancestor::div[@class="cpq-item-base-product"]/div[contains(@class,"slds-text-align_right")]/button[normalize-space(.)='Add to Cart']
    #log to console    aa
    sleep    10s
    wait until page contains element    //div[normalize-space(.) = 'Additional PDU for 52 RU']/ancestor::div[@class="cpq-item-base-product"]/div[4]/div[text()='Add']    30s
    #log to console    aaa
    sleep    10s
    click element    //span[text()='Next']
    sleep    30s
    #unselect frame
    #log to console    this is addand removing prod close here.
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
    #log to console    Exiting Review page

ValidateTheOrchestrationPlan- B20

    [Documentation]   Orchestration plan will not be available in the realated tab in case of B2o user. So move to Details tab and then  click on plan
    wait until page contains element        //div[@class='slds-page-header__title slds-m-right--small slds-align-middle fade-text']/span        30s
    ${order_number}   get text  //div[@class='slds-page-header__title slds-m-right--small slds-align-middle fade-text']/span
    log to console  ${order_number}.this is order numner
    set test variable  ${order_no}   ${order_number}
    ${Detail}=  set variable   //div[contains(@class,'active')]//span[text()='Details']//parent::a
    sleep  3s
    Wait until element is visible   ${Detail}  60s
    Force click element   ${Detail}
    Wait until element is visible  //span[text()='Orchestration Plan']//following::a[1]  30s
    Click element  //span[text()='Orchestration Plan']//following::a[1]
    sleep    10s
    Wait until element is visible  xpath=//iframe[@title='accessibility title'][@scrolling='yes']   60s
    select frame    xpath=//iframe[@title='accessibility title'][@scrolling='yes']
    Wait until element is visible  //a[text()='Start']  60s
    Element should be visible    //a[text()='Start']
    Element should be visible    //a[text()='Create Assets']
    Element should be visible    //a[text()='Deliver Service']
    Element should be visible    //a[text()='Order Events Update']
    Element should be visible   //a[text()='Call Billing System']
    #go back
    sleep   3s
    force click element       //a[@class='item-label item-header' and text()='Deliver Service']
    unselect frame
    #sleep       80s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //lightning-formatted-text[text()="Completed"]    60s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
    wait until page contains element    //lightning-formatted-text[text()="Completed"]     60s
    [Return]  ${order_number}

ValidateTheOrchestrationPlan
    wait until page contains element        //div[@class='slds-page-header__title slds-m-right--small slds-align-middle fade-text']/span        30s
    ${order_number}   get text  //div[@class='slds-page-header__title slds-m-right--small slds-align-middle fade-text']/span
    log to console  ${order_number}.this is order numner
    set test variable  ${order_no}   ${order_number}
    #Do not remove. Required for change order
    #At times the Orchestration Plan is not visible in Related Page then get the Plan ID from Detail Page
    ${status} =    Run Keyword and Return status  Page should contain element   //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]
    Run Keyword if   ${status} == False    GetOrchestrationPlanfromDetail
#    scrolluntillfound    //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]
    #execute javascript    window.scrollTo(0,2000)
    sleep    30s
    #log to console    plan validation
#    wait until page contains element     //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]    30s
#    click element     //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]
     wait until page contains element   //span[text()='Orchestration Plan']   30s
#    click element   //span[text()='Orchestration Plan']
    sleep    10s
    ${location}=    Get Location
    set test variable   ${url}   ${location}
    Wait until element is visible  xpath=//iframe[@title='accessibility title'][@scrolling='yes']   60s
    select frame    xpath=//iframe[@title='accessibility title'][@scrolling='yes']
    sleep    30s
    Element should be visible    //a[text()='Start']
    Element should be visible    //a[text()='Create Assets']
    Element should be visible    //a[text()='Deliver Service']
    Element should be visible    //a[text()='Order Events Update']
    Element should be visible   //a[text()='Call Billing System']
    #go back
    sleep   3s
    force click element       //a[@class='item-label item-header' and text()='Deliver Service']
    unselect frame
    #sleep       80s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //lightning-formatted-text[text()="Completed"]    60s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
    wait until page contains element    //lightning-formatted-text[text()="Completed"]     60s
    [Return]  ${order_number}


GetOrchestrationPlanfromDetail
   [Documentation]  In Orchestration Plan Page it capture the Plan ID from the Details TAB
    Reload page
    wait until page contains element    //span[@class='title' and text()='Details']    100s
    click element   //span[@class='title' and text()='Details']
    sleep  40s
    scrolluntillfound    //span[text()='Orchestration Plan']/following::div[1]//a[contains(@class,'textUnderline')]
    click element   //span[text()='Orchestration Plan']/following::div[1]//a[contains(@class,'textUnderline')]

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
    wait until element is visible   //div/div[@role="menu"]//a[@title="B2B Sales Expert Request"][1]/..   60s
    #page should contain element   //div/div[@role="menu"]//a[@title="B2B Sales Expert Request"][1]/..
    force click element   //a[@title="B2B Sales Expert Request"]/div
    wait until page contains element  //span[text()='Subject']/../following-sibling::input   60s
    ${case_number}=    Generate Random String    7    [NUMBERS]
    input text  //span[text()='Subject']/../following-sibling::input   ${case_number}
    Force click element  //span[text()='Subscriptions and Networks']/../following::input[1]
    ${date}=    Get Date From Future    7
    #log to console  ${date}
    input text   //span[text()='Offer Date']/../following::div[@class='form-element']/input   ${date}
    scroll element into view  //span[text()='Type of Support Requested']/../following::textarea
    input text  //span[text()='Type of Support Requested']/../following::textarea   Dummy Text
    #Scroll Page To Location  0  200
    #scroll element into view  //span[text()='Sales Project']/../following::input[1]
    click element  //span[text()='Sales Project']/../following::input[1]
    Sleep  10s
    wait until element is visible   //button[@class='slds-button slds-button_brand cuf-publisherShareButton undefined uiButton']//span[text()='Save']   60s
    click element  //button[@class='slds-button slds-button_brand cuf-publisherShareButton undefined uiButton']//span[text()='Save']
    [Return]    ${case_number}

createACaseFromMore
    [Arguments]    ${oppo_name}   ${case_type}

    #log to console   ${case_type}.this is case type..${oppo_name}
    Click element   //span[text()='More']
    sleep   30s
    ${status}  set variable     run keyword and return status   page should contain  //a[@href="/lightning/o/Case/home"][@role='menuitemcheckbox']
    #log to console      ${status}
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
    #Log to console  ${count}
    force click element   //div[@title='${oppo_name}'][@class='primaryLabel slds-truncate slds-lookup__result-text']
    #scrolluntillfound  //label/span[text()='Type of Support Requested']
    #Execute JavaScript  window.document.getElementsByClassName('modal-body scrollable slds-modal__content slds-p-around--medium')[0].scrollTop += 250
    #scroll element into view  //label/span[text()='Type of Support Requested']
    input text   //span[text()='Opportunity Value Estimate (€)']/../following-sibling::input   532
    input text   //span[text()='Opportunity Description']/../following-sibling::textarea  Testing Description
    input text   //span[text()='Type of Support Requested']/../following::textarea   Dummy Text
    #Log to console  to save
    click element  //button[@title='Save']
    [Return]    ${case_number}


Create Pricing Request
    ${More}   set variable   //a[@title='CPQ']//following::a[contains(@title,'more actions')]
    ${Create Pricing List}   set variable  //div[@class='branding-actions actionMenu']//following::a[@title='Create Pricing Request']
    Wait until element is visible  ${More}  30S
    cLICK ELEMENT   ${More}
    Wait until element is visible    ${Create Pricing List}   30s
    Click element  ${Create Pricing List}
    sleep  5s    # for the page to load
    Wait until element is visible  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe  30s
    select frame  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe
    #Wait until element is visible  //section[@class='slds-page-header vlc-slds-page--header ng-scope']//following::h1[contains(text(),'Pricing Request')]  60s
    Wait until element is visible   //input[@id='Subject']  30s
    Input Text   //input[@id='Subject']  Test Pricing Request
    Click element   //label[@class='slds-checkbox']/span[1]
    Input Text  //input[@id='OtherReason']  Test
    execute javascript    window.scrollTo(0,200)
    Click Element  //input[@id='PricingNeededBy']
    Wait until element is visible  //button[@title='Next Month']  30s
    Click element  //button[@title='Next Month']
    Click element  //table[@class='slds-datepicker__month nds-datepicker__month']/tbody/tr[1]/td[1]/span[1]
    Wait until element is visible   //p[text()='Create Pricing Request']  30s
    Click element  //p[text()='Create Pricing Request']
    Unselect Frame
    Wait until element is visible   //p[@title='Case Number']//following::lightning-formatted-text[1]   30s
    ${Case_number}     get text   //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text    //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number for Pricing Request and the status is ${Case_status}
    Capture Page Screenshot


Create Pricing Escalation

    ${More_actions}   set variable  //a[@title='CPQ']//following::a[contains(@title,'more actions')]
    ${CPE}    set variable   //a[@title='Create Pricing Escalation']
    Reload Page
    Wait until element is visible   ${More_actions}  30s
    set focus to element  ${More_actions}
    Force Click element  ${More_actions}
    Wait until element is visible  ${CPE}   30s
    Click element  ${CPE}
    sleep  5s
    Wait until element is visible  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe
    Select frame  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe
    Wait until element is visible  //input[@id='Subject']  20s
    Input Text   //input[@id='Subject']  Test Subject
    Click element  //input[@id='Type'][@type='checkbox']//following::span[text()='Mobile']
    Click element  //input[@id='ReasonCategories'][@type='checkbox']//following::span[text()='Revenue']
    Input text  //textarea[@id='Comments']  Test Comments
    Click element  //input[@id='EndorserLookup']
    Wait until element is visible  //li[contains(text(),'Endorser Automation')]  30s
    Click element  //li[contains(text(),'Endorser Automation')]
    Click element  //input[@id='ApproverLookup']
    Wait until element is visible  //li[contains(text(),'Approver Automation')]  30s
    Click element  //li[contains(text(),'Approver Automation')]
    Click element     //input[@id='NotifyLookup']
    Wait until element is visible  //li[contains(text(),'notifier Automation')]  30s
    Click element  //li[contains(text(),'notifier Automation')]
    execute javascript    window.scrollTo(0,300)
    Wait until element is visible  //p[text()='Create Pricing Escalation']  30s
    Click element  //p[text()='Create Pricing Escalation']
    Unselect frame
    Sleep  5s
    execute javascript    window.scrollTo(0,200)
    Capture Page Screenshot
    Reload Page
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number and the status is ${Case_status}
    [Return]  ${Case_number}



Submit for approval
    [Arguments]       ${case_type}
    sleep  10s
    #Required since wait is not working
    ${More_actions}   set variable  //span[contains(text(),'more actions')]
    Wait until element is visible   ${More_actions}  30s
    set focus to element  ${More_actions}
    Force Click element  ${More_actions}
    Click element  //a[@title='Submit for Approval']
    Wait until element is visible  //textarea[@class='inputTextArea cuf-messageTextArea textarea']   60s
    Input text  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  Submit
    Click element  //span[text()='Submit']
    Capture Page Screenshot
    sleep  5s
    Reload page
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number for ${case_type}  and the status is ${Case_status}
    logoutAsUser    ${PM_User}


Case Approval By Endorser
    [Arguments]   ${Case_number}   ${oppo_name}
    Login to Salesforce Lightning  ${Endorser_User}  ${Endorser_PW}
    #Log to console  Logged in as Endorser
    Check for Notification  ${Case_number}  ${EMPTY}

    Select Options to Verify Chatter Box   ${Case_number}
    Page should contain element   //div[@class='slds-media__body forceChatterFeedItemHeader'][1]/div/p/span/a/span[text()='${Case_number}']
    Page should contain   requested approval for this case from
    Capture Page Screenshot
    #Log to console    There is an alert in the Chatter about new case

    Wait until element is visible  //span[text()='Items to Approve']  30s
    #Click element  //a[text()='00031101']
    Wait until element is visible  //a[text()='${Case_number}']  30s
    Click element  //a[text()='${Case_number}']
    sleep  10s
    Click element  //a[text()='${Case_number}']
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number and the status is ${Case_status}
    Wait until element is visible   //a[contains(text(),'Test Robot Order')]  30s
    ${oppo}  Run Keyword  Get Text  //a[contains(text(),'Test Robot Order')]
    Should be equal   ${oppo_name}   ${oppo}
    #Log to console  Linked Opportunity is ${oppo}
    Go back
    Sleep  10s
    Wait until element is visible  //div[@title='Approve']  30s
    Capture Page Screenshot
    Click element  //div[@title='Approve']
    Wait until element is visible  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  60s
    Input text  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  Approved by Endorser
    Click element  //span[text()='Approve']
    Capture Page Screenshot
    sleep  5s
    logoutAsUser    ${Endorser_User}

Case Approval By Approver
     [Arguments]   ${Case_number}  ${oppo_name}  ${Account_Type}=${EMPTY}
    Run Keyword If   '${Account_Type}'== 'B2O'    Login to Salesforce Lightning   ${B2O_Approver_User}   ${B2O_Approver_PW}
    Run Keyword Unless  '${Account_Type}' == 'B2O'   Login to Salesforce Lightning   ${Approver_User}  ${Approver_PW}
    #Log to console  Logged in as Approver
    Check for Notification  ${Case_number}

    Select Options to Verify Chatter Box   ${Case_number}
    Page should contain element   //div[@class='slds-media__body forceChatterFeedItemHeader'][1]/div/p/span/a/span[text()='${Case_number}']
    Page should contain   requested approval for this case from
    Capture Page Screenshot
    #Log to console    There is an alert in the Chatter about new case

    Wait until element is visible  //span[text()='Items to Approve']  30s
    #Click element  //a[text()='00031101']
    Wait until element is visible  //a[text()='${Case_number}']  30s
    Click element  //a[text()='${Case_number}']
    sleep  10s
    Click element  //a[text()='${Case_number}']
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number  and the status is ${Case_status}
    Wait until element is visible   //a[contains(text(),'Test Robot Order')]  30s
    ${oppo}  Run Keyword  Get Text  //a[contains(text(),'Test Robot Order')]
    Should be equal   ${oppo_name}   ${oppo}
    #Log to console  Opportunity Validation is Sucessful
    sleep  5s
    #Log to console  Linked Opportunity is ${oppo}
    Go back
    Sleep  10s
    Page should contain element  //div[@class='approval-comments']/ul/li/article/div[2]/div/span
    Run Keyword if   '${Account_Type}'== 'B2B'   Endorser Verification
    Run Keyword Unless  '${Account_Type}' == '${EMPTY}'   Verify Pricing comments
    Capture Page Screenshot
    Wait until element is visible  //div[@title='Approve']  30s
    Capture Page Screenshot
    Click element  //div[@title='Approve']
    Wait until element is visible  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  30s
    Input text  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  Approved by Approver
    Click element  //span[text()='Approve']
    Capture Page Screenshot
    sleep  5s
    logoutAsUser    ${Approver_User}

Verify Pricing comments

    Page should contain element  //span[text()='Approval Details']//following::span[6][text()='Pricing Comments']//following::span[2]
    ${Pricing Comments}  Get text  //span[text()='Approval Details']//following::span[6][text()='Pricing Comments']//following::span[2]
    #Log to console  Pricing comments is visible and the comment is ${Pricing Comments}

Endorser Verification
    ${Endorser_Comments}   Get text   //div[@class='approval-comments']/ul/li/article/div[2]/div/span
    #Log to console  Endorser comment is visible and the comment given is ${Endorser_Comments}

Case Rejection By Approver
     [Arguments]   ${Case_number}  ${oppo_name}
    Login to Salesforce Lightning   ${Approver_User}  ${Approver_PW}
    #Log to console  Logged in as Approver
    Check for Notification  ${Case_number}
    Wait until element is visible  //span[text()='Items to Approve']  30s
    #Click element  //a[text()='00031101']
    Wait until element is visible  //a[text()='${Case_number}']  30s
    Click element  //a[text()='${Case_number}']
    sleep  10s
    Click element  //a[text()='${Case_number}']
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number and the status is ${Case_status}
    Wait until element is visible   //a[contains(text(),'Test Robot Order')]  30s
    ${oppo}  Run Keyword  Get Text  //a[contains(text(),'Test Robot Order')]
    Should be equal   ${oppo_name}   ${oppo}
    #Log to console  Opportunity Validation is Sucessful
    sleep  5s
    #Log to console  Linked Opportunity is ${oppo}
    Go back
    Wait until element is visible  //div[@title='Reject']  30s
    Capture Page Screenshot
    Click element  //div[@title='Reject']
    Wait until element is visible  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  30s
    Input text  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  Rejected
    Click element  //span[text()='Reject']
    Capture Page Screenshot
    sleep  5s
    logoutAsUser    ${Approver_User}



Check for Notification
    [Arguments]   ${Case_number}   ${status}=${EMPTY}
    Wait until element is visible  //div[@class='headerButtonBody']  60s
    Click element  //div[@class='headerButtonBody']
    Click element  //div[@class='headerButtonBody']
    Wait until element is visible  //div[@class='notification-content']/div/span[contains(text(),${Case_number})]   30s
    ${Notification}   Run keyword   Get text  //div[@class='notification-content']/span[contains(text(),${Case_number})]/../span
    ${Notification_2}  Run keyword   Get text  //div[@class='notification-content']/span[contains(text(),${Case_number})]
    Run Keyword If  '${status}' == 'Rejected'  Should end with     ${Notification}    is rejected
    Run Keyword If  '${status}' == '${EMPTY}'   Should end with     ${Notification}    is requesting approval for case
    Run Keyword If  '${status}' == 'Approved'   Should end with     ${Notification}    is approved
    Capture Page Screenshot
    #Log to console   ${Notification}
    #Log to console    ${Notification_2}
    Capture Page Screenshot
    sleep  2s
    Force Click element  //button[@title='Close']

Select Options to Verify Chatter Box

    [Arguments]   ${Case_number}
    ${sort}  set variable   //input[@name='sort']
    ${sort_option}  set variable   //span[@title='Latest Posts']
    ${Filter}   set variable  //span[text()='Filter Feed']
    ${Filter_option}  set variable  //span[text()='Filter Feed']//following::div[1]/div/slot/lightning-menu-item[1]/a/span

    WAit until element is visible    ${sort}  30s
    Click element    ${sort}
    Click element    ${sort_option}
    Page should contain element  ${Filter}
    Force Click element   ${Filter}
    Page should contain element  ${Filter_option}
    Force Click element  ${Filter_option}
    sleep  5s


Check Case Status
    [Arguments]   ${Case_number}  ${Account_Type}
    Run Keyword If   '${Account_Type}'== 'B2O'   Login to Salesforce as B2O User
    Run Keyword If   '${Account_Type}'== 'B2B'   Login to Salesforce as B2B DigiSales
    Select Options to Verify Chatter Box    ${Case_number}
    Page should contain element   //div[@class='slds-media__body forceChatterFeedItemHeader'][1]/div/p/span/a/following::span[contains(text(),'${Case_number}')]
    #Page should contain   created an attachment
    Capture Page Screenshot
    #Log to console    There is an alert in the Chatter about new case pdf generation

    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}    ${case_Number}
    Press Enter On    ${SEARCH_SALESFORCE}
    Sleep    2s
    ${IsVisible}=    Run Keyword And Return Status    Element Should Be Visible    ${SEARCH_RESULTS}    60s
    run keyword unless    ${IsVisible}    Press Enter On    ${SEARCH_SALESFORCE}
    ${element_catenate} =    set variable    [@title='${case_Number}']
    Wait Until Page Contains element    ${TABLE_HEADER}${element_catenate}    120s
    Click Element    ${TABLE_HEADER}${element_catenate}
    #Verify it the opportunity details are visible
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number and the status is ${Case_status}

Verify case Status by PM
    [Arguments]   ${Case_number}
    Login to Salesforce Lightning   ${PM_User}  ${PM_PW}
    #Log to console  Logged in as Pm to verify the Case Status
    #Reload page
    Search Salesforce    ${Case_number}
    ${element_catenate} =    set variable    [@title='${Case_number}']
    Wait Until Page Contains element    ${TABLE_HEADER}${element_catenate}    120s
    #Sleep    15s
    Click Element    ${TABLE_HEADER}${element_catenate}
    sleep  10s
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number and the status is ${Case_status}
    logoutAsUser    ${PM_User}

Verify case Status by Endorser
    [Arguments]   ${Case_number}  ${status}=${EMPTY}
    Login to Salesforce Lightning   ${Endorser_User}  ${Endorser_PW}
    #Log to console  Logged in as Endorser to verify the Case Status
    Check for Notification  ${Case_number}   ${status}
    #Reload page
    Search Salesforce    ${Case_number}
    ${element_catenate} =    set variable    [@title='${Case_number}']
    Wait Until Page Contains element    ${TABLE_HEADER}${element_catenate}    120s
    #Sleep    15s
    Click Element    ${TABLE_HEADER}${element_catenate}
    sleep  10s
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number and the status is ${Case_status}
    logoutAsUser    ${Endorser_User}

Case Not visible to Normal User

     [Arguments]   ${Case_number}
    Login to Salesforce Lightning       ${B2B_DIGISALES_LIGHT_USER}   ${Password_merge}
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}    ${Case_number}
    Press Enter On    ${SEARCH_SALESFORCE}
    sleep  10s
    Page should not contain  //span[@class='slds-form-element__label slds-truncate'][@title='Case Number']//following::div[1]/div/span[text()='${Case_number}']
    #Log to console  Case Not visible to Normal User
    Capture Page Screenshot

createACaseFromOppoRelated
    [Arguments]    ${oppo_name}   ${case_type}
    #log to console   ${case_type}.this is case type..${oppo_name}
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

Click Manual Availabilty

    [Documentation]  Click manual availability button and select the product segment

    ${Manual_availability_button}   set variable  //div[text()='Manual Availability (Sproject)']
    Wait until element is visible   ${Manual_availability_button}  30s
    Click element  ${Manual_availability_button}
    sleep  10s
    Wait until element is visible  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe  30s
    select frame  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe
    sleep  5s
    ${count}  Run Keyword and Return Status  Get Element Count   //select[@id='Product Segment']
    #Log to console  ${count}
    force click element   //select[@id='Product Segment']
    #Wait until element is visible  //select[@id='Product Segment']   30s
    #Click element  //select[@id='Product Segment']
    Wait until element is visible  //select[@id='Product Segment']/option[3]  30s
    Click element   //select[@id='Product Segment']/option[3]
    Wait until element is visible  //div[@id='Product_nextBtn']  30s
    Click element   //div[@id='Product_nextBtn']

Fill Request Form

    [Documentation]  Fill Manual availabilty request form

    #Log to console   Fiiling Manual Availability form
    ${street}  set variable   //input[@id='Street Name Site A']
    ${Building Number}  set variable  //input[@id='Building Number Site A']
    ${Postal code}  set variable  //input[@id='Postal Code Site A']
    ${city}  set variable  //input[@id='City Site A']
    ${speed}  set variable  //select[@id='Speed']
    ${product}  set variable   //input[@id='TypeAhead']
    Wait until element is visible   ${street}    30s
    Input Text  ${street}   Street
    Input Text   ${Building Number}  4
    Input Text   ${Postal code}  001100
    Input Text    ${city}   Helsinsiki
    Click element    ${speed}
    Wait until element is visible  //select[@id='Speed']/option[2]  20s
    Click element  //select[@id='Speed']/option[2]
    Execute JavaScript    window.scrollTo(0,500)
    Wait until element is visible  ${product}  30s
    Click element    ${product}
    Input Text   ${product}   Telia Unmanaged IP VPN
    Wait until element is visible   css=.typeahead .ng-binding   30s
    Click element   css=.typeahead .ng-binding
    Click element  //div[@id ='Address_nextBtn']/p
    ${Send Request}  set variable  //p[text()='Send Request']
    Wait until element is visible   ${Send Request}  30s
    Click element  ${Send Request}
    sleep  5s
    Wait until element is visible   //ng-form[@id='Request Complated']/div/p/p  30s
    ${Message}   Run keyword   Get Text  //ng-form[@id='Request Complated']/div/p/p
    Should contain    ${Message}   request has been sent successfully to Sproject
    Wait until element is visible  //div[@id='Send Manual Availability Request_nextBtn']/p  30s
    Click element  //div[@id='Send Manual Availability Request_nextBtn']/p



Verify Opportunity

    [Documentation]  Verify if the details populated in Manual Availability check in the opportunity page s correct

    Wait until element is visible  //div[@id='GetBackToOpportunity']  30s
    Click element  //div[@id='GetBackToOpportunity']
    Unselect Frame
    Navigate to related tab
    Wait until element is visible  //a[@title='Manual Availability Checks']  30s
    Click element  //a[@title='Manual Availability Checks']
    Capture Page Screenshot
    Wait until element is visible   //h1[@title='Manual Availability Checks']//following::table[1]/tbody/tr/td[2]/span/span  30s
    ${status}  Run Keyword  Get Text  //h1[@title='Manual Availability Checks']//following::table[1]/tbody/tr/td[2]/span/span
    ${Product}  Run Keyword  Get Text  //h1[@title='Manual Availability Checks']//following::table[1]/tbody/tr/td[4]/span/span
    ${Document_id}  Run Keyword  Get Text  //h1[@title='Manual Availability Checks']//following::table[1]/tbody/tr/td[6]/span/span
    #Log to console  Status and Document id Of Manual Availabilty Request for the product ${Product} is ${status}, ${Document_id}





click on more actions
    wait until page contains element  //a[contains(@title, 'more actions')][1]   30s
    force click element  //a[contains(@title, 'more actions')][1]
    capture page screenshot


Create Investment Case
    [Documentation]  Click Create investmnet button anf fill details and check the status of case created
    [Arguments]   ${Account_Type}
    ${More}   set variable   //a[@title='CPQ']//following::a[contains(@title,'more actions')]
    ${Create Investment}   set variable  //div[@class='branding-actions actionMenu']//following::a[@title='Create Investment']
    Wait until element is visible  ${More}  30S
    ${count}  Run Keyword and Return Status  Get Element Count   ${More}
    #Log to console    ${count}
    Force click element    ${More}
    Wait until element is visible    ${Create Investment}   30s
    Click element  ${Create Investment}
    sleep  10s    # for the page to load
    Reload page
    sleep  10s
    Fill Investment Info   ${Account_Type}
    Unselect frame
    Wait until element is visible   //p[@title='Case Number']//following::lightning-formatted-text[1]   30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text    //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number for Investment Request and the status is ${Case_status}
    logoutAsUser    ${B2B_DIGISALES_LIGHT_USER}
    [Return]    ${case_number}


Fill Investment Info
    [Documentation]    Fill Investment Case Creation form
    [Arguments]   ${Account_Type}

    ${Type}   set variable  //select[@id='Type']
    ${Type_Option}  set variable   //select[@id='Type']/option[@label='Mobile']
    ${Subject}  set variable   //input[@id='Subject']
    ${Summary}   set variable    //textarea[@id='Summary']
    ${Full_Investment}  set variable    //input[@id='FullInvestmentEur']
    ${Contract_length}  set variable   //input[@id='ContractLength']
    ${Payment_Method}   set variable  //select[@id='PaymentMethod']
    ${Payment_Option}  set variable   //select[@id='PaymentMethod']/option[@label='Monthly payment']
    ${Payment_Option_2}   set variable   //select[@id='PaymentMethod']/option[@label='One time']
    ${Customer_Pays}  set variable  //input[@id='CustomerPaysMonthlyEur']
    ${Decision}   set variable  //textarea[@id='DecisionArgument']
    ${Mobile_Coverage}  set variable  //input[@id='MobileCoverageNo']
    ${Attachment}  set variable   //input[@type='file']
    #${File_Path}   set variable    C:\\Users\\Ram\\work\\aarthy\\claudia-pipeline_rt\\robot_tests\\resources\\Input.txt
    ${File_Path}   set variable    ${CURDIR}${/}Input.txt
    ${Button}  set variable   //div[@id='InvestmentInfo_nextBtn']
    ${Telia_Pays}  set variable  //input[@id='TeliaPaysOne']
    ${Full_Inv_Value}  set variable  2000
    ${contract_Len_Value}  set variable  ${${Account_Type}_Contract_Length}
    ${Cust_pay_val}  set variable  10
    ${Cust_pay_total}  Run keyword   evaluate  (${contract_Len_Value}*${Cust_pay_val})
    ${Telia_pay_expected_val}   Run keyword    evaluate   (${Full_Inv_Value}-${Cust_pay_total})
    #Log to console   ${Telia_pay_expected_val}
    sleep  10s
    Wait until element is visible  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe  30s
    select frame  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe
    ${count}  Run Keyword and Return Status  Get Element Count   ${Type}
    #Log to console    ${count}
    Force click element    ${Type}
    Click element  ${Type_Option}
    Input Text  ${Subject}  Test Subject
    Input Text  ${Summary}   Test Summary
    Input Text  ${Full_Investment}   ${Full_Inv_Value}
    Input Text  ${Contract_length}  ${contract_Len_Value}
    Click element   ${Payment_Method}
    Page should contain Element  ${Payment_Option}
    Page should contain Element  ${Payment_Option_2}
    #Log to console  Both Payment Options available
    Click element    ${Payment_Option}
    Input TExt  ${Customer_Pays}  ${Cust_pay_val}
    ${Value}  Get Value  //input[contains(@id,'TeliaPays')]
    ${str_Telia_pay_val}    Run Keyword  Convert to string   ${Telia_pay_expected_val}
    Should be equal    ${Value}   ${str_Telia_pay_val}
    #Log to console  Teli Pay value populated correctly
    Input Text  ${Decision}   Invest
    ${status}   Run Keyword and Return Status  Page should contain element  ${Mobile_Coverage}
    #Log to console   ${status}
    Run Keyword If   ${status}   Input Text  ${Mobile_Coverage}   25
    Choose File   ${Attachment}   ${File_Path}
    Wait until element is visible  ${Button}  30s
    Click element  ${Button}
    Wait until element is visible  //button[@id='alert-ok-button']  30s
    Click element  //button[@id='alert-ok-button']
    Page should contain element   //small[text()='Maximum contract length is ${${Account_Type}_Max_contract_len} months.']
    #Log to console   Contract length maximum validation is successful
    Clear Element text  ${Contract_length}
    Input Text  ${Contract_length}  100
    Wait until element is visible  ${Button}  30s
    Force Click element  ${Button}



PM details
    [Documentation]  Login as PM. Search and select Case. Fill Pricing Manager Approval form and submit the case for approval.
    [Arguments]    ${oppo_name}   ${case_Number}  ${Account_Type}

    # Login and select the case
    Run Keyword If   '${Account_Type}'== 'B2O'    Login to Salesforce Lightning      ${B2O_PM_User}   ${B2O_PM_PW}
    Run Keyword Unless  '${Account_Type}' == 'B2O'   Login to Salesforce Lightning      ${PM_User}   ${PM_PW}
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}    ${case_Number}
    Press Enter On    ${SEARCH_SALESFORCE}
    Sleep    2s
    ${IsVisible}=    Run Keyword And Return Status    Element Should Be Visible    ${SEARCH_RESULTS}    60s
    run keyword unless    ${IsVisible}    Press Enter On    ${SEARCH_SALESFORCE}
    ${element_catenate} =    set variable    [@title='${case_Number}']
    Wait Until Page Contains element    ${TABLE_HEADER}${element_catenate}    120s
    Click Element    ${TABLE_HEADER}${element_catenate}
    #Verify it the opportunity details are visible
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number  and the status is ${Case_status}
    Wait until element is visible   //span/a[contains(text(),'Test Robot Order')]  30s
    ${oppo}  Run Keyword  Get Text  //span/a[contains(text(),'Test Robot Order')]
    Should be equal   ${oppo_name}   ${oppo}
    #Log to console  Linked Opportunity is ${oppo}

    ${More_actions}   set variable  //span[contains(text(),'more actions')]
    Wait until element is visible   ${More_actions}  30s
    set focus to element  ${More_actions}
    Force Click element  ${More_actions}
    Click element  //a[@title='Pricing Manager Approval']
    Sleep  5s

    Wait until element is visible  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe  30s
    select frame  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe
    Execute JavaScript    window.scrollTo(0,1000)
    Wait until element is visible   //textarea[@id='PricingComments']  30s
    Input Text  //textarea[@id='PricingComments']    ${Pricing Comments}

    Run Keyword If   '${Account_Type}'== 'B2O'     Submit Investment - B2O
    Run Keyword Unless  '${Account_Type}' == 'B2O'    Submit Investment - B2B

    sleep  3s
    Wait until element is visible   //p[text()='Save']  30s
    Click element  //p[text()='Save']
    Unselect frame
    Submit for approval  Investment Case

Submit Investment - B2O
    [Documentation]  Fill the specifc fields for B2O to submit the investment

    Input Text   //input[@id='FirstYear']  100
    Click element  //select[@id='ApprovalActionB2O']
    Wait until element is visible  //select[@id='ApprovalActionB2O']/option[@label='Send for Approval']  30s
    Click element  //select[@id='ApprovalActionB2O']/option[@label='Send for Approval']

    Wait until element is visible  //input[@id='ApproverB2O']  30s
    Click element  //input[@id='ApproverB2O']
    Wait until element is visible  //li[contains(text(),'B2OApprover Automation')]  30s
    Click element  //li[contains(text(),'B2OApprover Automation')]

    Wait until element is visible  //input[@id='NotifyB2O']  30s
    Click element  //input[@id='NotifyB2O']
    Wait until element is visible  //li[contains(text(),'B2ONotify Automation')]  30s
    Force Click element  //li[contains(text(),'B2ONotify Automation')]
    sleep  3s

Submit Investment - B2B
    [Documentation]   Fill the specifc fields for B2B to submit the investment
    Input Text  //input[@id='Ebit']   ${Ebit Value}
    Click element  //select[@id='ApprovalActionB2B']
    Click element  //select[@id='ApprovalActionB2B']//option[@label='Prepare for Endorsement']

    Wait until element is visible  //input[@id='EndorserB2B']  30s
    Click element  //input[@id='EndorserB2B']
    Wait until element is visible  //li[contains(text(),'Endorser')]  30s
    Click element  //li[contains(text(),'Endorser')]

    Wait until element is visible  //input[@id='ApproverB2B']  30s
    Click element  //input[@id='ApproverB2B']
    Wait until element is visible  //li[contains(text(),'Approver')]  30s
    Click element  //li[contains(text(),'Approver')]

    Wait until element is visible  //input[@id='NotifyB2B']  30s
    Click element  //input[@id='NotifyB2B']
    Wait until element is visible  //li[contains(text(),'notifier')]  30s
    Force Click element  //li[contains(text(),'notifier')]

Activate the generated service contract
    [Arguments]   ${contact_name}  ${contract_number}
    Go To Entity    ${CONTRACT_ACCOUNT}
    wait until element is visible    ${ACCOUNT_RELATED}    60s
    Force click element    ${ACCOUNT_RELATED}
    ScrollUntillFound   //span[text()='View All']/span[text()='Contracts']
    Force Click element    //span[text()='View All']/span[text()='Contracts']
    Wait Until Page Contains element        //h1[@title="Contracts"]        60s
    Click element    //button[@title="Show quick filters"]
    Sleep  10s
    Wait Until Element Is Visible    //h2[text()="Filters"]    60s
    #${count}=    get element count    ${table_row}
    Click element   //legend[text()="Agreement Type"]/..//div/span[2]/label/span
    sleep  3s
    click element    //button[@title="Apply"]
    Wait Until Page Contains element    //button[@title="Close Filters"]    60s
    click element   //button[@title="Close Filters"]
    sleep  10s
    Wait Until Page Contains element   //*[@title="Contract Number"]/../../..//th[@class="slds-cell-edit cellContainer"]//a  60s
    click element    //*[@title="Contract Number"]/../../..//th[@class="slds-cell-edit cellContainer"]//a
    wait until page contains element  //li//a//div[@title="Activate"]       60s
    Fill Contract Details   Service   ${contact_name}   ${contract_number}
    Activate Contract  Service

Create contract Agreement

    [Documentation]  Create contract(service/Customership) based on the contract type
    [Arguments]   ${Contract_Type}   ${Linked Customer Contract}=${EMPTY}
    ${Create Agreement}  set variable  //div[@title='Create Agreement']
    ${Frame}  set variable  //div[contains(@class,'slds')]/iframe
    ${Agreement_Type}  set variable  //select[@id='AgreementType']
    ${option}  set variable  //select[@id='AgreementType']/option[@label='${Contract_Type} Agreement']
    ${Next_Button}  set variable  //p[text()='Next']
    ${Create_Agreement_Button}  set variable    //p[text()='Create Agreement']
    ${contact_name}   run keyword    Create New Contact for Account
    sleep  40s
    #Wait Until Page Contains element  //ul/li//a[@title="Show 2 more actions"]  60s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible      //li//a[@title="Create Agreement"]   60s
    #Run Keyword If    ${status_page} == True    force click element    //li/a/div[@title='Billing Account']
    Run Keyword If    ${status_page} == False   force click element     //a[@title="Show 2 more actions"]
    sleep  20s
    click element     //li//a[@title="Create Agreement"]
    sleep   10s   # Required for loading
    Reload page
    sleep  30s
    Wait until element is visible  ${Frame}  30s
    Select frame  ${Frame}
    ${count}  Run Keyword and Return Status  Get Element Count   ${Agreement_Type}
    #Log to console    ${count}

    Force click element   ${Agreement_Type}
    Wait until element is visible  ${option}  30s
    Click element   ${option}
    Click element    ${Next_Button}
    Run keyword if   '${Contract_Type}' == 'Service'    Select Offerings
    Wait until element is visible  ${Create_Agreement_Button}   30s
    Click element  ${Create_Agreement_Button}
    unselect frame
    sleep  10s
    Fill Contract Details  ${Contract_Type}  ${contact_name}  ${Linked Customer Contract}
    Activate Contract  ${Contract_Type}


Activate Contract
    [Documentation]  Activate the created contract and check the status of the contract
    [Arguments]   ${Contract_Type}
    Execute JavaScript    window.scrollTo(0,200)
    sleep  5s
    Page should contain element  //span[text()='Agreement Data Complete']
    Reload page
    Wait until element is visible  //img[@alt='Ready']  60s
    Wait until element is visible  //div[@title='Activate']  30s
    Click element  //div[@title='Activate']
    Wait until element is visible  //button[@title='Yes']
    Click element  //button[@title='Yes']
    sleep  3s
    Wait until element is visible   //span[@class='slds-form-element__label slds-truncate'][@title='Contract Number']//following::div[9]/span[text()='Activated']   60s
    #Log to console   ${Contract_Type} Contract is activated
    ${Contract Agreement}  Run keyword   Get text  //span[@class='slds-form-element__label slds-truncate'][@title='Contract Number']//following::div[2]/span
    ${Contract Agreement_No}   Convert to integer   ${Contract Agreement}
    ${Contract}=   Evaluate   ${Contract Agreement_No}+ 1
    ${Contract Number}    Convert to String    ${Contract}
    set test variable  ${Customer_contract}     ${Contract Number}
    #Log to console  The ${Contract_Type} Contract Number is ${Customer_contract}
    click element  //a[@title="Related"]
    wait until page contains element  //a//span[@title="Attached Documents"]  60s
    sleep  20s
    scrolluntillfound  //div//span[text()="View All"]
    click element  //div//span[text()="View All"]
    wait until page contains element  //div//h1[@title="Attached Documents"]  60s
    wait until page contains element  //table[@role="grid"]//td[10]//span/span   60s
    ${ecm-id}  get text  //table[@role="grid"]//td[10]//span/span
    #${ecm-id}   convert to number   ${Contract Agreement}
    page should contain element  //table[@role="grid"]//td[10]//span/span[@title="${ecm-id}"]

Check Customer Signed By
    [Documentation]   This keyword to be used when Customer signed by field is not getting populated properly
    Execute JavaScript    window.scrollTo(0,1100)
    Press Key   ${Customer Signed By}   ${contact_name}
    sleep  3s
    ${Count}  run keyword and return status   Page should contain element ${contact}
    Run Keyword Unless   ${Count}   clear element text   ${Customer Signed By}
    Run keyword Unless   ${Count}   Press Key   ${Customer Signed By}    ${contact_name}
    #sleep  5s
    Page should contain element  ${contact}  30s
    Force Click element  ${contact}
    ${status}   Run keyword and return status  Page should contain element  //li[text()='An invalid option has been chosen.']
    Run Keyword If  ${status}  Force Click element   //span[text()='Undo Customer Signed By']
    Run Keyword If  ${status}   Force Click element  ${contact}
    Capture Page Screenshot
    sleep  5s
     ${status}  run keyword and return status   Element should be visible  ${save}
    Run Keyword if  ${status}   Force Click element  ${save}
    sleep  3s
    ${status}  run keyword and return status   Element should be visible  ${save}
    Run Keyword if  ${status}   Force Click element  ${save}
    sleep  3s


Fill Contract Details
    [Documentation]  To fill form while creating SErvice and customership contract
    [Arguments]  ${Contract_Type}  ${contact_name}   ${Linked Customer Contract}=${EMPTY}
    ${Edit Contractual Contact Person}   set variable   //button[@title='Edit Contractual Contact Person']
    ${Search Contracts}    set variable  //span[text()='Contractual Contact Person']//following::div[1]/div/div/div/input[@title='Search Contacts']
    ${contact}  set variable  //div[@title='${contact_name}']
    ${Customer Signed By}  set variable   //span[text()='Customer Signed By']//following::div[1]/div/div/div/input[@title='Search Contacts']
    ${Customer Signed Date}   set variable   //label[@class='label inputLabel uiLabel-left form-element__label uiLabel']/span[text()='Customer Signed Date']//following::input[1]
    ${Customer Signature Place}  set variable   //label[@class='label inputLabel uiLabel-left form-element__label uiLabel']/span[text()='Customer Signature Place']//following::textarea[1]
    ${Telia Signed By}  set variable   //label[@class='label inputLabel uiLabel-left form-element__label uiLabel']/span[text()='Telia Signed By']//following::input[1]
    ${Telia Signed Date}   set variable  //label[@class='label inputLabel uiLabel-left form-element__label uiLabel']/span[text()='Telia Signed Date']//following::input[1]
    ${Attachment_Button}  set variable   //a[@title='Add Attachment']
    ${File_Path}   set variable    ${CURDIR}${/}input.txt
    #${filepath}     set variable   ${CURDIR}\\Input.txt
    ${save}  set variable  //button[@title='Save']
    ${ATTACHMENT_NAME}  set variable  //input[@id='name']
    ${File}  set variable   //input[@type='file']
    ${Type}  set variable   //select[@id='type']
    ${Type_Option}  set variable   //select[@id='type']/option[@value='Customership Agreement']
    ${Document}  set variable   //select[@id='Document_Stage']
    ${Document_option}  set variable   //select[@id='Document_Stage']/option[@value='Approved']
    ${Frame}  set variable  //div[contains(@class,'slds')]/iframe
    Run keyword if   '${Contract_Type}' == 'Service'      Verify if Customer Contract is linked  ${Linked Customer Contract}
    #Run keyword if   '${Contract_Type}' == 'Service'
    Wait Until Page Contains element        //div[text()="Contract"]        60s
    ${Telia party}  get text  //span[text()="Telia Party"]/../../div[@class="slds-form-element__control slds-grid itemBody"]//span[@class="test-id__field-value slds-form-element__static slds-grow "]
    #${itrm}     get length   ${Telia party}
    #${status}   Run keyword and return status   should not be empty   ${itrm}
    #Run Keyword Unless   ${status}  click element  //button[@title="Edit Telia Party"]
    #Run Keyword Unless   ${status}  Wait until element is visible   //div//span[text()="Telia Party"]/../..//input[@title="Search Accounts"]     60s
    #Run Keyword Unless   ${status}     Select from search List  //div//span[text()="Telia Party"]/../..//input[@title="Search Accounts"]        Telia Communication Oy
    #Run Keyword Unless   ${status}     click element  ${save}
    #Run Keyword Unless   ${status}     sleep   20s
    #ScrollUntillFound     //span[text()="Telia Party"]/../..//input[@title="Search Accounts"]
    ScrollUntillFound   //button[@title='Edit Customer Signed By']
    Wait until element is visible  //button[@title='Edit Customer Signed By']  30s
    Force Click element  //button[@title='Edit Customer Signed By']
    Wait until element is visible   ${Customer Signed By}  30s
    Press Key   ${Customer Signed By}   ${contact_name}
    sleep  3s
    ${Count}  run keyword and return status   Page should contain element ${contact}
    Run Keyword Unless   ${Count}   clear element text   ${Customer Signed By}
    Run keyword Unless   ${Count}   Press Key   ${Customer Signed By}    ${contact_name}
    #sleep  5s
    Page should contain element  ${contact}
    Force Click element  ${contact}
    ${status}   Run keyword and return status  Page should contain element  //li[text()='An invalid option has been chosen.']
    Run Keyword If  ${status}  Force Click element   //span[text()='Undo Customer Signed By']
    Run Keyword If  ${status}   Force Click element  ${contact}
    Capture Page Screenshot
    #sleep  5s

    Wait until element is visible  ${Customer Signed Date}  30s
    Force Click element   ${Customer Signed Date}
    Wait until element is visible   //a[@title='Go to next month']   30s
    Click element   //a[@title='Go to next month']
    Click element   //table[@class='calGrid']/tbody/tr[1]/td[1]/span[1]
    Input Text   ${Customer Signature Place}  Helsinsiki
    Execute JavaScript    window.scrollTo(0,1700)
    input text    ${Telia Signed By}   Automation Admin
    Wait until element is visible    //div[@title='Automation Admin']    30s
    Click element  //div[@title='Automation Admin']
    Force Click element   ${Telia Signed Date}
    Click element   //a[@title='Go to next month']
    Click element   //table[@class='calGrid']/tbody/tr[1]/td[1]/span[1]
    #Wait until element is visible    ${Edit Contractual Contact Person}  60s
    #Click element    ${Edit Contractual Contact Person}
    Wait until element is visible    ${Search Contracts}  30s
    Click element  ${Search Contracts}
    Input Text  ${Search Contracts}  ${contact_name}
    sleep   4s
    ${status}  run keyword and return status   Element should be visible  ${contact}
    Run Keyword Unless   ${status}   clear element text   ${Search Contracts}
    Run keyword Unless   ${status}   Press Key   ${Search Contracts}   ${contact_name}
    Wait until element is visible    ${contact}  30s
    Force Click element  ${contact}
    Execute JavaScript    window.scrollTo(0,1700)
    sleep  8s
    ${status}   Run keyword and return status  Page should contain element  ${save}
    Run keyword unless    ${status}   Reload page
    Run keyword unless    ${status}   sleep  10s
    Run keyword unless    ${status}   Fill Contract Details   ${Contract_Type}  ${Linked Customer Contract}
    ${status}   Run keyword and return status  Element should be visible  ${save}
    Run keyword unless    ${status}   Reload page
    Run keyword unless    ${status}   sleep  10s
    Run keyword unless    ${status}   Fill Contract Details   ${Contract_Type}  ${Linked Customer Contract}
    click element  ${save}
    sleep  10s
    ${status}  Run keyword and return status  Element should not be visible  ${save}
    Reload page
    sleep  10s
    Run keyword Unless    ${status}   Fill Contract Details   ${Contract_Type}  ${Linked Customer Contract}
    ${page}  get location
    #Attachment
    Wait until element is visible  ${Attachment_Button}  60s
    Click Link  ${Attachment_Button}
    sleep  30s
    Reload page
    sleep  30s
        #Click element   ${Attachment_Button}
    Wait until element is visible  ${Frame}  30s
    Select frame  ${Frame}
    sleep  15s
    #Wait until element is visible  ${File}  60s  - Not working
    log to console  file path started
    ${status}  Run keyword and return status  Element should be visible  ${File}
    Choose File   ${File}   ${File_Path}
    Wait until element is visible  //textarea[@id='description']  30s
    Force Click element  //textarea[@id='description']
    Input text  //textarea[@id='description']  Test Description
    Click element  ${Type}
    Click element  ${Type_Option}
    Click element  ${Document}
    Click element  ${Document_option}
    sleep  10s
    wait until page contains element  //label[@class="slds-checkbox"]//input[@id="sync_to_ecm"]  60s
    select checkbox  //label[@class="slds-checkbox"]//input[@id="sync_to_ecm"]
    sleep  2s
    Click element  //p[text()='Load Attachment']
    Wait until element is visible  //p[contains(text(),'Attachment has been loaded successfully.')]  60s
    Unselect Frame
    sleep  2s
    go to   ${page}
    sleep  30s
    log to console  file contracts details ended
Go to account from oppo page
    [Documentation]  Go back to account page from opportubnity page
    Reload page
    ${Account}  set variable  //span[@class='slds-form-element__label slds-truncate'][@title='Account Name']//following::div[3]/a
    Wait until element is visible   ${Account}   30s
    Click element  ${Account}
    sleep  3s

Select Offerings
    [Documentation]  Select offerings while creating service contract
    #Wait until element is visible  ${Frame}  30s
    #Select frame  ${Frame}
    sleep  10s
    ${offering}  set variable  //div[@id='agreement-off-scroll-h']/div/table/tbody/tr[1]/td[1]/label/input[@type='checkbox']
    ${next}  set variable   //div[@id='AddOfferingsStep_nextBtn']
    ${status}   Run keyword and return status   Get element count  ${offering}
    #Log to console  ${status}
    Force Click element  ${offering}
    Click element  ${next}


Verify if Customer Contract is linked
    [Documentation]  To verify if the primary customer ship contract(the one that is not set to merge) is getting linked to the service contract that is being created.
    [Arguments]  ${Linked Customer Contract}
    ${Linked Contract}  set variable    //span[text()='Related Customership Contract']//following::a[1]
    Wait until element is visible   ${Linked Contract}  30s
    ${check}   Run keyword    Get Text   ${Linked Contract}
    Should be equal    ${check}  ${Linked Customer Contract}
    #Log to console  Customer Contract is properly linked with the service contract that is being created

Change Merged Status

    [Documentation]   Toggle the merge status for the given cutomer contract by going into the related tab of account
    [Arguments]  ${contract_Number}
    Go To Entity    ${account}
    ${save}  set variable  //button[@title='Save']
    wait until element is visible    ${ACCOUNT_RELATED}    60s
    Force click element    ${ACCOUNT_RELATED}
    ScrollUntillFound   //span[text()='View All']/span[text()='Contracts']
    Force Click element    //span[text()='View All']/span[text()='Contracts']
    Wait until element is visible   //th[@scope='row']/span/a[contains(text(),'${contract_Number}')]  30s
    Click element  //th[@scope='row']/span/a[contains(text(),'${contract_Number}')]
    ScrollUntillFound    //button[@title='Edit Merged']
    Click element  //button[@title='Edit Merged']
    Wait until element is visible  //div[@class='slds-form-element slds-hint-parent']//following::span[text()='Merged']//following::input[@type='checkbox'][1]  30s
    Click element  //div[@class='slds-form-element slds-hint-parent']//following::span[text()='Merged']//following::input[@type='checkbox'][1]
    sleep   5s
    ${status}  Run keyword and return status  Element should be visible  ${save}
    Run keyword Unless   ${status}   Reload page
    Run keyword Unless   ${status}   Toggle Merge Checkbox
    click element  ${save}
    sleep  5s

Toggle Merge Checkbox
    [Documentation]  Reload the page and set the merge status. To use this keyword when the save button does not work properly in the contract page while setting the merge status.
    sleep  10s
    ${save}  set variable  //button[@title='Save']
    ScrollUntillFound    //button[@title='Edit Merged']
    Click element  //button[@title='Edit Merged']
    Wait until element is visible  //div[@class='slds-form-element slds-hint-parent']//following::span[text()='Merged']//following::input[@type='checkbox'][1]  30s
    Click element  //div[@class='slds-form-element slds-hint-parent']//following::span[text()='Merged']//following::input[@type='checkbox'][1]
    ${status}  Run keyword and return status  Element should be visible  ${save}
    Run keyword Unless   ${status}   Reload page
    Run keyword Unless   ${status}   Toggle Merge Checkbox


Verify Populated Cutomership Contract
    [Documentation]  Verify if the opportunity page has customership contract details populated properly
    [Arguments]  ${Contract_Number}

    ${Customership_Contract_Filed}   set variable  //span[text()='Customership Contract']
    ScrollUntillFound   ${Customership_Contract_Filed}

    Run keyword if  '${Contract_Number}' =='${EMPTY}'  Page should not contain   //span[text()='Customership Contract'][@class='test-id__field-label']//following::span[1]/div/a
    Run keyword if  '${Contract_Number}' =='${EMPTY}'  Log to console  Customer contract ship field is empty
    Return From Keyword if   '${Contract_Number}' =='${EMPTY}'
    ${populated_Contract value}  Get Text   //span[text()='Customership Contract'][@class='test-id__field-label']//following::span[1]/div/a
    Should be equal   ${populated_Contract value}  ${Contract_Number}
    #Log to console  Contract Number Population validation is succesful in opportunity page

Select Customer ship contract manually
    [Documentation]   When multiple contracts are present for an account and their status are not merged, select the customer ship contract manually
    [Arguments]  ${Contract_Number}
    ${Customership_Contract_Filed}   set variable  //span[text()='Customership Contract']
    ${save}  set variable  //span[text()='Customership Contract']/following::span[text()='Save']
    #${save}  set variable  //div[@class='footer ']/div/div/button[@title='Save']
    ScrollUntillFound   //span[text()='Edit Customership Contract']
    Wait until element is visible  //span[text()='Edit Customership Contract']   30s
    Force Click element  //span[text()='Edit Customership Contract']
    Input Text   //input[@title='Search Contracts']  ${Contract_Number}
    Wait until element is visible   //div[@title='${Contract_Number}']
    Click element   //div[@title='${Contract_Number}']
    sleep  5s
    Wait until page contains element   ${save}  20s
    ${status}   Run keyword and return status   Get element count  ${save}
    #Log to console  ${status}
    Set focus to element  ${save}
    click element  ${save}
    sleep  5s


Change Order
   [Arguments]   ${contact_name}

    Initiate Change Order
    Request Date
    CPQ Page
    Order Post script   ${contact_name}

CPQ Page
    Sleep  10s
    Verify the Action of product  Telia Colocation   Existing
    Verify onetime total charge
    ${Toggle}  set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/button/span[2][text()='Telia Colocation']
    ${status}   Run keyword and return status   Element should be visible   ${Toggle}
    Log to console    Toggle status is ${status}
    Run keyword if  ${status}  Click element  ${Toggle}
    #Delete Product   Cabinet 52 RU
    #Verify the Action of child product  Cabinet 52 RU   Disconnect
    #Failing need to check.
    Add Product   Cabinet 12 RU
    Verify the Action of child product  Cabinet 12 RU   Add
    scrolluntillfound    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    sleep    10s
    wait until page contains element    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']    60s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']


clicking on next button
    ${iframe}    Set Variable    //div[contains(@class,'slds')]/iframe
    ${next_button}    set variable    //span[contains(text(),'Next')]
    Reload page
    Wait Until Element Is Enabled    ${iframe}    90s
    select frame    ${iframe}
    sleep  30s
    Wait Until Element Is Visible    ${next_button}    60s
    #Run Keyword If    ${status} == True
    click element    ${next_button}
    Unselect Frame
    #sleep  10s

Select Account

    [Documentation]    This is to search and select the account
    ${account_name}=    Set Variable    //p[contains(text(),'Search')]
    ${account_checkbox}=    Set Variable    //td[@class='slds-cell-shrink']//span[@class='slds-checkbox--faux']
    ${search_account_next_button}=    Set Variable    //div[@id='SearchAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    sleep    5s
    wait until element is visible   //div[@class='iframe-parent slds-template_iframe slds-card']/iframe    60s
    select frame  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe

    Wait Until Element Is Visible    ${account_name}    120s
    click element    ${account_name}
    #sleep    3s
    Wait Until Element Is Visible    ${account_checkbox}    120s
    click element    ${account_checkbox}
    #sleep    3s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${search_account_next_button}    120s
    Click Element    ${search_account_next_button}
    Unselect frame
    sleep  5s

Select Account - no frame

    [Documentation]    This is to search and select the account
    ${account_name}=    Set Variable    //div[@title='Search']
    ${account_checkbox}=    Set Variable    //td[@class='slds-cell-shrink']//span[@class='slds-checkbox--faux']
    ${search_account_next_button}=    Set Variable    //div[@id='SearchAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    sleep    5s
    #wait until element is visible   //div[@class='iframe-parent slds-template_iframe slds-card']/iframe    60s
   # select frame  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe

    Wait Until Element Is Visible    ${account_name}    120s
    click element    ${account_name}
    #sleep    3s
    Wait Until Element Is Visible    ${account_checkbox}    120s
    click element    ${account_checkbox}
    #sleep    3s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${search_account_next_button}    120s
    Click Element    ${search_account_next_button}
   # Unselect frame
    sleep  5s

select contact - no frame
     [Arguments]   ${contact_name}

    ${contact_search}=    Set Variable    //input[@id='OrderContactTA']
    ${contact_next_button}=    Set Variable    //div[@id='SelectOrderLevelContacts_nextBtn']
    ${updateContactDR}=    Set Variable    //button[@class='slds-button slds-button--neutral ng-binding ng-scope'][@ng-click='nextRepeater(child.nextIndex, child.indexInParent)']
    #Wait until element is visible   //div[contains(@class,'slds')]/iframe   30s
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    log to console    entering Technical COntact page
    Wait Until Element Is Visible    ${contact_search}    120s
    Input Text    ${contact_search}   ${contact_name}  # For Telia Communication Oy Account
    #sleep    15s
    Wait until element is visible   css=.typeahead .ng-binding   30s
    Click element   css=.typeahead .ng-binding
    #sleep   10s
    #Wait until element is visible  //input[@id='OCEmail']   30s
    #Input Text   //input[@id='OCEmail']   primaremail@noemail.com

    ${status}=  Run keyword and return status   Element should be visible  //p[text()='Select Technical Contact:']
    Run Keyword if  ${status}  Enter technical contact
    Execute JavaScript    window.scrollTo(0,200)
    Sleep    5s

    ${status}=    Run Keyword and return status  Element should be visible  //p[text()='Copy technical contact from first product to other products']
    Run keyword if  ${status}  Click element   //p[text()='Copy technical contact from first product to other products']
    sleep  5s
    #sleep  10s
    Wait until element is visible   ${contact_next_button}  30s
    Click Element    ${contact_next_button}
    #unselect frame
    #sleep   10s

select contact
    ${contact_search}=    Set Variable    //input[@id='OrderContactTA']
    ${contact_next_button}=    Set Variable    //div[@id='SelectOrderLevelContacts_nextBtn']
    ${updateContactDR}=    Set Variable    //button[@class='slds-button slds-button--neutral ng-binding ng-scope'][@ng-click='nextRepeater(child.nextIndex, child.indexInParent)']
    Wait until element is visible   //div[contains(@class,'slds')]/iframe   30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    log to console    entering Technical COntact page
    Wait Until Element Is Visible    ${contact_search}    120s
    Input Text    ${contact_search}   ${contact_name}  # For Telia Communication Oy Account
    #sleep    15s
    Wait until element is visible   css=.typeahead .ng-binding   30s
    Click element   css=.typeahead .ng-binding
    #sleep   10s
    Wait until element is visible  //input[@id='OCEmail']   30s
    Input Text   //input[@id='OCEmail']   primaryemail@noemail.com

    ${status}=  Run keyword and return status   Element should be visible  //p[text()='Select Technical Contact:']
    Run Keyword if  ${status}  Enter technical contact
    Execute JavaScript    window.scrollTo(0,200)
    Sleep    5s

    ${status}=   Run Keyword and return status  Element should be visible  //p[text()='Copy technical contact from first product to other products']
    Run keyword if  ${status}  Click element   //p[text()='Copy technical contact from first product to other products']
    sleep  5s
    #sleep  10s
    Wait until element is visible   ${contact_next_button}  30s
    Click Element    ${contact_next_button}
    unselect frame

Enter technical contact
    ${Technical_contact_search}=  set variable    //input[@id='TechnicalContactTA']
    Execute JavaScript    window.scrollTo(0,200)
    Wait Until element is visible   ${Technical_contact_search}     30s
    Input text   ${Technical_contact_search}  ${contact_name}  # Contact of TeliaCommunication Oy account
    #sleep  10s
    Wait until element is visible   css=.typeahead .ng-binding  30s
    Click element   css=.typeahead .ng-binding
    #sleep  10s
    #Wait until element is visible  //input[@id='TCEmail']   30s
    #Input Text   //input[@id='TCEmail']   primaremail@noemail.com
    #Removing hardcodong email since DDM order fails when email id is already present
    Execute JavaScript    window.scrollTo(0,200)
    ${status}=  Run keyword and return status   Element should be visible  //p[text()='Select Main User:']
    Run Keyword if  ${status}  Enter Main user



Enter Main User

    ${Main_user_serach}=  set variable  //input[@id='MainContactTA']
    Wait Until element is visible   ${Main_user_serach}     30s
    Input text   ${Main_user_serach}  ${contact_name}
    #sleep  10s
    Wait until element is visible   css=.typeahead .ng-binding  30s
    Click element   css=.typeahead .ng-binding
    #sleep  10s
    Wait until element is visible  //input[@id='MCEmail']   30s
    Input Text   //input[@id='MCEmail']   primaryemail@noemail.com
    Execute JavaScript    window.scrollTo(0,200)





Select Date

    [Documentation]    Used for selecting \ requested action date
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    Wait until element is visible   //div[contains(@class,'slds')]/iframe  30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #sleep    60s
    Wait until element is visible   ${additional_info_next_button}  60s
    ${status}    Run Keyword and Return Status    Page should contain element    //input[@id='RequestedActionDate']
    #Log to console    ${status}
    Run Keyword if    ${status}   Pick Date without product
    Run Keyword Unless    ${status}    Click Element    ${additional_info_next_button}
    Unselect frame

Select Date - no frame

    [Documentation]    Used for selecting \ requested action date
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    #Wait until element is visible   //div[contains(@class,'slds')]/iframe  30s
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    #sleep    60s
    Wait until element is visible   ${additional_info_next_button}  60s
    ${status}    Run Keyword and Return Status    Page should contain element    //input[@id='RequestedActionDate']
    #Log to console    ${status}
    Run Keyword if    ${status}   Pick Date without product
    Run Keyword Unless    ${status}    Click Element    ${additional_info_next_button}
   # Unselect frame

Pick Date without product

    Log to console    picking date
    ${date_id}=    Set Variable    //input[@id='RequestedActionDate']
    ${next_month}=    Set Variable    //button[@title='Next Month']
    ${firstday}=    Set Variable    //span[contains(@class,'slds-day nds-day')][text()='01']
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    #${additional_info_next_button}=    Set Variable    //div[@id='Additional data_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    Wait Until Element Is Visible    ${date_id}    120s
    Click Element    ${date_id}
    Wait Until Element Is Visible    ${next_month}    120s
    Click Button    ${next_month}
    click element    ${firstday}
    #sleep    5s
    Capture Page Screenshot
    Click Element    ${additional_info_next_button}


select Date for multiple products

    [Arguments]   ${prod_1}   ${prod_2}
    [Documentation]    Used for selecting \ requested action date for each parent product
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    Wait until element is visible   //div[contains(@class,'slds')]/iframe  30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    Wait until element is visible   ${additional_info_next_button}  60s
    ${status}    Run Keyword and Return Status    Element should be visible    //div[@class='ProductName2 ng-binding ng-scope'][contains(text(),'${prod_1}')]//following::input[2]
    Log to console    ${prod_1}
    Run Keyword if    ${status}    Pick Date with product    ${prod_1}
    ${status}    Run Keyword and Return Status    Element should be visible   //div[@class='ProductName2 ng-binding ng-scope'][contains(text(),'${prod_2}')]//following::input[2]
    Log to console    ${prod_2}
    Run Keyword if    ${status}    Pick Date with product     ${prod_2}
    #sleep  5s
    Click Element    ${additional_info_next_button}
    Unselect frame

Pick date with product

    [Arguments]    ${product}
    Log to console    picking date
    ${date_id}=    Set Variable    //div[@class='ProductName2 ng-binding ng-scope'][contains(text(),'${product}')]//following::input[2]
    ${next_month}=    Set Variable    //button[@title='Next Month']
    ${firstday}=    Set Variable    //span[contains(@class,'slds-day nds-day')][text()='01']
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    #${additional_info_next_button}=    Set Variable    //div[@id='Additional data_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    Wait Until Element Is Visible    ${date_id}    120s
    Click Element    ${date_id}
    Wait Until Element Is Visible    ${next_month}    120s
    Click Button    ${next_month}
    click element    ${firstday}
    #sleep   5s
    Capture Page Screenshot


Select account Owner - no frame

    log to console    Select Owner Account FLow Chart Page
    log to console    entering Owner Account page
    ${owner_account}=    Set Variable    //ng-form[@id='BuyerAccount']//span[@class='slds-checkbox--faux']
    ${buyer_payer}=    Set Variable    //input[@id='BuyerIsPayer']/../span
    ${buyer_account_next_button}=    Set Variable    //div[@id='SelectedBuyerAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    Wait Until Element Is Visible    ${buyer_payer}    120s
    sleep  10s
    #Click Element    ${owner_account}
    #Removing this as this will be ticked automatically as part fo feature delivered recently
    sleep    3s
    click element    ${buyer_payer}
    sleep    3s
    Wait Until Element Is Visible    ${buyer_account_next_button}    120s
    click element    ${buyer_account_next_button}
    sleep  3s
    log to console    Exiting owner Account page
    sleep    10s

Select account Owner

    log to console    Select Owner Account FLow Chart Page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    log to console    entering Owner Account page
    ${owner_account}=    Set Variable    //ng-form[@id='BuyerAccount']//span[@class='slds-checkbox--faux']
    ${buyer_payer}=    Set Variable    //input[@id='BuyerIsPayer']/../span
    ${buyer_account_next_button}=    Set Variable    //div[@id='SelectedBuyerAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    Wait Until Element Is Visible    ${buyer_payer}    120s
    Click Element    ${owner_account}
    sleep    3s
    click element    ${buyer_payer}
    sleep    3s
    #Capture Page Screenshot
    Wait Until Element Is Visible    ${buyer_account_next_button}    120s
    click element    ${buyer_account_next_button}
    sleep  3s
    ${status} =  Run Keyword and Return status   Page should contain element   //p[text()='Update Order']
    Run Keyword if  ${status}   Continue and submit
    unselect frame
    log to console    Exiting owner Account page
    sleep    10s

Continue and submit
    [Documentation]   Give continue for Update Order Dialogue box after selecting account
    Wait until element is visible  //button[contains(text(),' Continue')]
    Click element  //button[contains(text(),' Continue')]
    sleep  3s


#Submit for Approval

    sleep    40s
    ${status}   set variable  Run keyword and return status   Page contains element   //div[text()='Submit for Approval']
    Run Keyword if   {status}   Click element   //div[text()='Submit for Approval']
    Wait until page contains element  //h2[text()='Submit for Approval']
    Input Text   //textarea[@role='textbox']  submit
    click element  //span[text()='Submit']

Submit Order Button
    Reload page
    Wait until element is visible   //div[@title='Submit Order']    60s
    Log to console    submitted
    Click element  //div[@title='Submit Order']
    #sleep  10s
    Capture Page Screenshot
    Wait until element is visible     //h2[text()='Submit Order']   30s
    sleep  5s
    Capture Page Screenshot
    ${status} =    Run Keyword and Return status  Page should contain element   //div[text()='Please add Group Billing ID.']
    Run Keyword if   ${status}  Enter Group id and submit
    Run Keyword unless   ${status}   click element   //button[text()='Submit']
    sleep  15s

Enter Group id and submit

    ${cancel}=  set variable    //span[text()='Cancel']
    ${Detail}=  set variable   //div[contains(@class,'active')]//span[text()='Details']//parent::a
    #${Group id}=  set variable   //span[text()='Edit Group Billing ID']
    ${Group Billing ID}=  set variable   //div/span[text()='Group Billing ID']
    ${status}   Run keyword and return status   Wait until element is visible   ${cancel}   30s
    Run keyword if   ${status}  Click element   ${cancel}
    sleep  3s
    Wait until element is visible   ${Detail}  60s
    Force click element   ${Detail}
    #sleep  10s
    Wait until element is visible  //span[text()='Edit Status']     30s
    Force Click element  //span[text()='Edit Status']
    sleep  3s
    Page should contain element  //label/span[text()='Group Billing ID']
    ScrollUntillFound    //label/span[text()='Group Billing ID']
    Select from search List     //input[@title='Search Group Billing IDs']     ${group_id}
    Wait until element is visible  //label/span[text()='Desired Installation Date']/..//following::input[1]   30s
    Force Click element  //label/span[text()='Desired Installation Date']/..//following::input[1]
    Click element   //a[@title='Go to next month']
    Wait until element is visible      //tr[@class='calRow'][2]/td[1]/span  30s
    Click element  //tr[@class='calRow'][2]/td[1]/span

    # Contract id issue at times in Order submition SAP Contract ID is not visible  during the submittion of order
    ${status}    Run keyword and return status   Page should contain element   //label/span[text()='SAP Contract ID']/..//following::input[1]
    Run Keyword If    ${status} == True    Input Text  //label/span[text()='SAP Contract ID']/..//following::input[1]  1010004095

    Wait until element is visible   //button[@title='Save']  30s
    Click element  //button[@title='Save']
    sleep  5s
    Wait until element is visible   //div[@title='Submit Order']    60s
    Click element  //div[@title='Submit Order']/..
    sleep  5s
    Capture Page Screenshot
    Wait until element is visible     //h2[text()='Submit Order']   30s
    click element   //button[text()='Submit']
    sleep  15s

Order Post script
    [Arguments]   ${contact_name}
    Select Account - no frame
    select contact - no frame   ${contact_name}
    Select Date - no frame
    Select account Owner - no frame
    Verify Order Type
    Submit Order Button
    ValidateTheOrchestrationPlan

Verify Order Type

    ${ACCOUNT_DETAILS}  set variable   //div[contains(@class,'active')]//span[text()='Details']//parent::a
    Wait until element is visible   ${ACCOUNT_DETAILS}  60s
    Force Click element  ${ACCOUNT_DETAILS}
    ${Order_Type}  get text   //div[@class='test-id__field-label-container slds-form-element__label']/span[text()='Order Type']//following::span[2]
    Should be equal   ${Order_Type}  Change

Verify the Action of child product

    [Arguments]  ${pname}  ${Value}
    ${Action_xpath}   set variable   //div[contains(text(),'${pname}')]//following::div[19]
    Wait until element is visible  ${Action_xpath}    60s
    ${Action}  Get Text  ${Action_xpath}
    Should be equal     ${Action}  ${Value}
    Log to console  The ACtion value for the product ${pname} is verified

Verify the Action of product
      [Arguments]  ${pname}  ${Value}
    #${Action}   set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/button/span[2][text()='${pname}']//following::div[13]/div
    ${Action}   set variable   //span[text()='${pname}']//following::div[19]/div
    Wait until element is visible  ${Action}    60s
    ${Action Value}  Get Text  ${Action}
    Should be equal     ${Action Value}  ${Value}
    Log to console  The ACtion value for the product ${pname} is verified

Verify onetime total charge

    ${One Time Value}  get text  //div[contains(text(),'OneTime Total')]//following::div[1]
    Should be equal   '${One Time Value}'  '0.00 €'

Delete Product
    [Arguments]  ${pname}

    ${Delete_Button}   set variable   //div[contains(text(),'${pname}')]//following::button[4][@title='Delete Item']
    Wait until element is visible   ${Delete_Button}  30s
    Click element  ${Delete_Button}
    Wait until element is visible  //button[text()='Delete']  30s
    Click element  //button[text()='Delete']

Add Product

    [Arguments]  ${pname}

    ${Add_Product}  set variable   //div[contains(text(),'${pname}')]//following::button[1]
    Wait until element is visible  ${Add_Product}  60s
    Click element  ${Add_Product}
    #Wait until element is added
    Wait until element is visible   //div[contains(text(),'${pname}')]//following::button[4][@title='Delete Item']   50s

Request date

    Wait until element is visible  //input[@id='RequestDate']   30s
    Click element  //input[@id='RequestDate']
    Wait until element is visible  //button[@title='Next Month']  30s
    Click element  //button[@title='Next Month']
    Click element  //tr[@id='week-0']/td[2]/span
    Click element  //div[@id='Request Date_nextBtn']

Initiate Change Order

     Go to entity   ${vLocUpg_TEST_ACCOUNT}
    #Go to entity   ${Account}
#    Page should contain element   //span[text()='Account ID']
#    Force Click element  //span[text()='Account ID']
    ${AssetHistory}   set variable   //button//span[text()='Asset History']
    Execute JavaScript    window.scrollTo(5000,4900)
    Page should contain element   ${AssetHistory}
    Log to console   Asset history found
    ${frame}  set variable  //button/span[text()='Asset History']/../../..//div[@class="content iframe-parent"]/iframe
    Page should contain element    ${frame}
    select frame  ${frame}
    ${status}   Run keyword and return status  Page should contain element   //li[@ng-repeat='prod in assetItems'][1]/div/div/input
    Run keyword if   ${status}   Page should contain element    //li[@ng-repeat='prod in assetItems'][1]/div/div/input
    Wait until page contains element   //li[@ng-repeat='prod in assetItems'][1]/div/div/input   60s
    page should contain checkbox    //li[@ng-repeat='prod in assetItems'][1]/div/div/input
    force Click element   //li[@ng-repeat='prod in assetItems'][1]/div/div/input
    sleep  5s
    Checkbox Should Be Selected   //li[@ng-repeat='prod in assetItems'][1]/div/div/input
    Capture Page Screenshot
    sleep  5s
    Log to console   Change Order Initiated
    ${status}   Run keyword and return status   Element Should Be Enabled   //button[text()='Change To Order']
    Force Click element  //button[text()='Change To Order']
    Unselect frame

DDM Request Handling
    [Arguments]    ${orderNo}
    Login Workbench
    File Handling - Change Order id   ${orderNo}
    File Handling - Get Debug Line
    Execute Debug code
    Verify Response code
    Close opened windows


Close opened windows

    ${title_var}        Get Window Titles
    ${Length}   Run keyword   Get length   ${title_var}
    : FOR    ${i}    IN RANGE    0   ${Length}
    \    Select Window       title=@{title_var}[${i}]
    \    close window



Verify Response code

    Sleep  5s
    Wait until element is visible  //div[@id='codeViewPortContainer']//p[@id='codeViewPort']  30s
    ${Response}    Get Text  //div[@id='codeViewPortContainer']//p[@id='codeViewPort']
    ${Line}   Get Line   ${Response}  0
    Should contain  ${Line}    200
    Log to console   Recieved proper response code

Execute Debug code
    ${Utilities}  set variable    //span[text()='utilities']
    ${Rest Explorer}  set variable   //span[text()='utilities']//following::li[1]/a
    ${Submit}  set variable  //input[@id='execBtn']
    Wait until element is visible   ${Utilities}  30s
    Force Click element   ${Utilities}
    Force Click element  ${Rest Explorer}
    Wait until element is visible   //input[@value='POST']   30s
    Click Element  //input[@value='POST']
    clear element text   //input[@id='urlInput']
    Input Text  //input[@id='urlInput']   /services/apexrest/DDM/Events
    Input Text   //textarea[@name='requestBody']   ${DEBUG CODE}
    Click element  ${Submit}

File Handling - Get Debug Line
    ${result}   Fetch Result
    Get Debug line   ${result}


Get Debug line
    [Arguments]   ${result}
    ${Debug_line}   Get Lines Containing String  ${result}  |DEBUG|
    #Log to console   ${Debug_line}
    ${Debug_Code}   Fetch From Right   ${Debug_line}  |DEBUG|
    Set Test Variable    ${DEBUG CODE}    ${Debug_Code}
    #Log to console    ${Debug_Code}

Login Workbench

    ${Env}  set variable   //label[text()='Environment:']//following::select[1]
    ${Environment_Option}  set variable  //label[text()='Environment:']//following::select[1]/option[text()='Sandbox']
    ${T&C}  set variable  //input[@type='checkbox'][@id='termsAccepted']
    ${login}  set variable  //input[@type='submit']
    Wait Until Keyword Succeeds    60s    1 second    Execute Javascript    window.open('https://workbench.developerforce.com');
    #Open Browser    https://workbench.developerforce.com    ${BROWSER}
    sleep    30s
    Switch between windows  1
    Wait until page contains element  //label[text()='Environment:']   60s
    Wait Until Element Is Visible    ${ENV}    30s
    Click element   ${Env}
    Click element  ${Environment_Option}
    Force Click element    ${T&C}
    Click element   ${login}
    sleep  5s
    ${title}    Get Title
    Run keyword if   '${title}'=='Login | Salesforce'   Login Salesforce to access Workbench   ${SYSTEM_ADMIN_USER}   ${SYSTEM_ADMIN_PWD}
    sleep  10s
    ${status}    Run keyword and return status   Page should contain element   //input[@title='Allow']
    Run Keyword If   ${status}   Click element   //input[@title='Allow']
    Run Keyword If   ${status}   sleep  5s
    ${status}    Run keyword and return status   Page should contain element    //span[text()='utilities']
    Run Keyword If    ${status} == False    Login Workbench


Login Salesforce to access Workbench
   [Arguments]    ${username}   ${password}
    Wait Until Page Contains Element    id=username    240s
    Input Text    id=username    ${username}
    Sleep    5s
    Input text    id=password    ${password}
    Click Element    id=Login


Switch between windows
    [Arguments]    ${index}
    @{titles}    Get Window Titles
    Select Window    title=@{titles}[${index}]
    ${title}    Get Title



File Handling - Change Order id
    [Arguments]   ${orderNo}
    #${File_Path}   set variable    ${CURDIR}\\..\\resources\\DDM_Request.txt
    ${File_Path}   set variable    ${CURDIR}${/}DDM_Request.txt
    ${DDM_request}   get file    ${File_Path}
    ${No.of lines}    get line count    ${DDM_request}
    #Log to console   ${No.of lines}
    ${Line}   Get Line   ${DDM_request}  0
    #Log to console  ${Line}
    ${Existing_Order_Number}   Get Substring    ${Line}  11
    #Log to console  ${Existing_Order_Number}
    ${Replaced_line}   Replace String Using Regexp    ${Line}   ${Existing_Order_Number}   '${orderNo}';
#    ${Replaced_line}   Replace String Using Regexp    ${Line}   ${Existing_Order_Number}   '319103017660';
    #Log to console   ${Replaced_line}
    ${New_request}   Replace String Using Regexp    ${DDM_request}  ${Line}   ${Replaced_line}
    #Log to console   ${New_request}
    Execute DDM Request   ${New_request}


Execute DDM Request
    [Arguments]   ${New_request}
    ${Utilities}  set variable    //span[text()='utilities']
    ${Apex Execute}  set variable   //span[text()='utilities']//following::li[2]/a
    ${Submit}  set variable  //input[@type='submit']
    Wait until element is visible   ${Utilities}  30s
    Force Click element   ${Utilities}
    Force Click element  ${Apex Execute}
    Input Text   //textarea[@id='scriptInput']   ${New_request}
    Click element  ${Submit}



Fetch Result

    ${Result_Text}  set variable  //*[contains(text(),'Execute Anonymous')]
    Wait until element is visible   ${Result_Text}   30s
    ${Result}   Get Text   ${Result_Text}
    #Log to console  ${Result}
    [Return]   ${Result}


Validate Billing system response
    Reload page
    #Go back
    Wait until element is visible    //div[@class='content iframe-parent']/iframe   60s
    select frame    //div[@class='content iframe-parent']/iframe
    sleep    30s
    Element should be visible    //a[text()='Start']
    Element should be visible    //a[text()='Create Assets']
    Element should be visible    //a[text()='Deliver Service']
    Element should be visible    //a[text()='Order Events Update']
    Element should be visible   //a[text()='Call Billing System']
    #go back
    log to console    Validate Billing system Response
    force click element       //a[@class='item-label item-header' and text()='Call Billing System']
    unselect frame
    sleep       80s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //lightning-formatted-text[contains(text(),"Completed")]
#    ${status_page}    Run Keyword And Return Status    Page should contain element     //lightning-formatted-text[contains(text(),"Completed")]   60s
    Run Keyword If    ${status_page} == False    force click element   //button[text()='Complete Item']
    sleep   20s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
#    wait until page contains element    //div[@class="slds-form-element__control slds-grid itemBody"]//span[text()="Completed"]      300s
    wait until page contains element  //lightning-formatted-text[contains(text(),"Completed")]    300s
    #Go back


HDC Order
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact}.this is name
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
    ${billing_acc_name}    run keyword    CreateABillingAccount  ${vLocUpg_TEST_ACCOUNT}
    log to console    ${billing_acc_name}.this is billing account name
    Go To Entity    ${oppo_name}
    ChangeThePriceList      B2B
    ClickingOnCPQ    ${oppo_name}
    Adding Telia Colocation    Telia Colocation
    Updating Setting Telia Colocation
    UpdateAndAddSalesType    Telia Colocation
    #View Open Quote
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount   ${vLocUpg_TEST_ACCOUNT}
    select order contacts- HDC  ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    ${billing_acc_name}
    clickOnSubmitOrder
    ValidateTheOrchestrationPlan

HDC Order_B2O

    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact}.this is name
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
    ${billing_acc_name}    run keyword    CreateABillingAccount  ${vLocUpg_TEST_ACCOUNT}
    log to console    ${billing_acc_name}.this is billing account name
    Go To Entity    ${oppo_name}
    ChangeThePriceList      B2B
    ClickingOnCPQ    ${oppo_name}
    Adding Telia Colocation    Telia Colocation
    Updating Setting Telia Colocation
    UpdateAndAddSalesType    Telia Colocation
    View Open Quote
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount   ${vLocUpg_TEST_ACCOUNT}
    select order contacts- HDC  ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    ${billing_acc_name}
    clickOnSubmitOrder
    ValidateTheOrchestrationPlan- B20

Terminate asset
    [Arguments]   ${asset}
    ${Accounts_More}  set variable  //div[contains(@class,'tabset slds-tabs_card uiTabset')]/div[@role='tablist']/ul/li[8]/div/div/div/div/a
    wait until element is visible  ${Accounts_More}  60s
    Click element  ${Accounts_More}
    Click element  //li[@class='uiMenuItem']/a[@title='Assets']
    Wait until element is visible  //span[@title='Assets']  60s
    Click element  //span[@title='Assets']
    Wait until element is visible  //h1[@title='Assets']  60s
    sleep  10s
    ${product}   set variable   //div[@class='slds-col slds-no-space forceListViewManagerPrimaryDisplayManager']//tr//a[contains(text(),'${asset}')]
    Click element   ${product}
    Wait until element is visible  //a[@title='Edit']  60s
    wait until page contains element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Asset Name']/../following-sibling::div/span/span    60s
    page should contain element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Asset Name']/../following-sibling::div/span/span
    page should contain element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Product']/../following-sibling::div/span/div/a[text()='${asset}']
    click element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Status']/../..//following::button[@title='Edit Status']
    sleep    10s
    click element    //Span[text()='Status']//following::div[@class="uiMenu"]/div[@data-aura-class="uiPopupTrigger"]/div/div/a[@class='select' and text()='Active']
    click element    //a[@title='Terminated']
    click element    //div[@class="footer active"]//button[@title="Save"]

Adding Arkkitehti

    [Arguments]   ${pname}=${product_name}
    Log to console      adding product
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    sleep   20s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    unselect frame


Adding Telia Cid

    [Arguments]   ${pname}=${product_name}
    Log to console      adding product
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    sleep   20s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    unselect frame

Adding Vula

    [Arguments]   ${pname}=${product_name}
    Log to console      adding product
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    sleep   20s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    unselect frame






Update Setting Vula

     [Arguments]        ${pname}
    ${Nopeus}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Nopeus']]//following::select[1]
    ${Asennuskohde}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Asennuskohde']]//following::select[1]
    ${Toimitustapa}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Toimitustapa']]//following::select[1]
    ${VLAN}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'VLAN']]//following::input[1]
    ${VULA NNI}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'VULA NNI']]//following::input[1]
    ${Yhteyshenkilön nimi}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Yhteyshenkilön nimi']]//following::input[1]
    ${Yhteyshenkilön puhelinnumero}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Yhteyshenkilön puhelinnumero']]//following::input[1]
    ${Katuosoite}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Katuosoite']]//following::input[1]
    ${Katuosoite numero}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Katuosoite numero']]//following::input[1]
    ${Postinumero}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Postinumero']]//following::input[1]
    ${Postitoimipaikka}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Postitoimipaikka']]//following::input[1]
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${SETTINGS}   set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/div/span[text()='${pname}']//following::button[@title='Settings']
    Wait until element is visible   ${SETTINGS}   60s
    Click Button    ${SETTINGS}
    sleep  10s
    Click element  ${Nopeus}
    Click element  ${Nopeus}/option[2]
    Click element   ${Asennuskohde}
    Click element   ${Asennuskohde}/option[2]
    Click element   ${Toimitustapa}
    Click element   ${Toimitustapa}/option[2]
    Input Text  ${VLAN}  1
    Input Text   ${VULA NNI}    Test
    Input Text   ${Yhteyshenkilön nimi}    Test
    Input Text    ${Yhteyshenkilön puhelinnumero}   Test
    Input Text   ${Katuosoite}   Test
    Input Text    ${Katuosoite numero}  Test
    Input Text  ${Postinumero}  00510
    Input Text    ${Postitoimipaikka}  Test
    sleep  3s
    Click element  //*[@alt='close'][contains(@size,'large')]
    sleep  10s
    Reload page
    sleep  10s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    scrolluntillfound    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    #sleep    10s
    wait until page contains element    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']    60s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    Unselect Frame


Validate Call case Management status
    Wait until element is visible    //div[@class='content iframe-parent']/iframe
    select frame    //div[@class='content iframe-parent']/iframe
    Wait until element is visible   //a[@class='item-label item-header' and text()='Call Case Management']   60s
    force click element       //a[@class='item-label item-header' and text()='Call Case Management']
    unselect frame
    #sleep       80s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //div[@class="slds-form-element__control slds-grid itemBody"]//span[text()="Completed"]
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
    wait until page contains element    //div[@class="slds-form-element__control slds-grid itemBody"]//span[text()="Completed"]      300s
    #Go back

Validate Order status

    Wait until page contains element   //a[text()='${order_no}']  60s
    Click element   //a[text()='${order_no}']
    ${Order status}  set variable   //span[@title='Status']/../div/div/span
    Wait until element is visible  ${Order status}   60s
    ${Status}  Get text   ${Order status}
    Should be equal   ${Status}   Completed
    Log to console  The Order is completed

UpdatePageNextButton

    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    log to console    UpdateAndAddSalesType
    sleep    20s
    #Requires sleep to overcome dead object issue
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Wait until element is visible  ${next_button}  30s
    click element    ${next_button}
    unselect frame


Close and submit
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${status}   set variable   Run Keyword and Return Status   Frame should contain   //div[@id='Close']/p   Close
    Run Keyword if   ${status}   Click Element    //div[@id='Close']/p
    sleep  10s
    #sleep  15s
    Unselect frame
    Capture Page Screenshot
    Wait until element is visible     //h2[text()='Submit Order']   30s
    sleep  5s
    Capture Page Screenshot
    Enter Group id and submit

#Submit Order Button
#    Reload page
#    Wait until element is visible   //div[@title='Submit Order']    60s
#    Log to console    submitted
#    Click element  //div[@title='Submit Order']
#    #sleep  10s
#    Capture Page Screenshot
#    Wait until element is visible     //h2[text()='Submit Order']   30s
#    sleep  5s
#    Capture Page Screenshot
#    ${status} =    Run Keyword and Return status  Page should contain element   //div[text()='Please add Group Billing ID.']
#    Run Keyword if   ${status}  Enter Group id and submit
#    Run Keyword unless   ${status}   click element   //button[text()='Submit']
#    sleep  15s
#


ValidateSapCallout

    wait until page contains element        //div[@class='slds-page-header__title slds-m-right--small slds-align-middle fade-text']/span        30s
    ${order_number}   get text  //div[@class='slds-page-header__title slds-m-right--small slds-align-middle fade-text']/span
    log to console  ${order_number}.this is order numner
    Set test variable   ${order_no}      ${order_number}
    # Donot remove as reusing it for change plan - Aarthy
#    ${Detail}=  set variable   //div[contains(@class,'active')]//span[text()='Details']//parent::a
    ${Detail}=  set variable   //span[@class='title' and text()='Details']
    sleep  3s
    Wait until element is visible   ${Detail}  60s
    Force click element   ${Detail}
    log to console   ${Detail}.details is clicked
    Wait until element is visible  //span[text()='Orchestration Plan']//following::a[1]  30s
    Click element  //span[text()='Orchestration Plan']//following::a[1]
    sleep    100s
#    Wait until element is visible  xpath=//*[@title='Orchestration Plan View']/div/iframe[1]   60s
#     Wait until element is visible  xpath=//div[contains(@class,'content iframe-parent')]/iframe   100s
#    select frame    xpath=//*[@title='Orchestration Plan View']/div/iframe[1]
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[contains(@class,'content iframe-parent')]/iframe
   Run Keyword If    ${status_page} == False    Reload Page
    select frame    xpath= //div[contains(@class,'content iframe-parent')]/iframe
    Wait until element is visible  //a[text()='Start Order']  60s
    Element should be visible    //a[text()='Start Order']
    Element should be visible    //a[text()='Create Assets']
    sleep   3s
    force click element       //a[@class='item-label item-header' and text()='Callout to SAP Provisioning I']
    unselect frame
    #sleep       80s
#    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //div[@class="slds-form-element__control slds-grid itemBody"]//span[text()="Completed"]   200s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //span[text()='State']/../../../../..//lightning-formatted-text[text()='Completed']    200s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
#   wait until page contains element    //div[@class="slds-form-element__control slds-grid itemBody"]//span[text()="Completed"]      300s
    wait until page contains element    //span[text()='State']/../../../../..//lightning-formatted-text[text()='Completed']      300s
    force click element      //span[contains(text(),"Orchestration Plan")]/../..//*[@class="slds-form-element__control"]//span/..//a
create another quote with same opportunity

    Wait Until Element Is Enabled    //div[contains(@class,'slds')]/iframe    60s
    Select Frame    //div[contains(@class,'slds')]/iframe
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    Log to console      ${status}
    wait until page contains element    //span[text()='Next']/..    60s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    unselect frame
    sleep  30s
    Wait Until Element Is Enabled    //div[contains(@class,'slds')]/iframe    60s
    Select Frame    //div[contains(@class,'slds')]/iframe
    ${status}   set variable    Run Keyword and return status    Frame should contain    //button[contains(text(),"Next")]    Next
    Log to console      ${status}
    wait until page contains element    //button[contains(text(),"Next")]   60s
    click button    //button[contains(text(),"Next")]
    unselect frame
    #OpenQuoteButtonPage_release
    log to console  2



Sync quote

    wait until page contains element        //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']       60s
    sleep  10s
    force click element    //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']
    sleep    30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    Wait until page contains element   //button[@title="Sync Quote"]    60s
    click button  //button[@title="Sync Quote"]
    unselect frame
    #wait until page contains element    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span   60s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //a[@title='Details']   60s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
    Force Click element  //a[@title='Details']
    wait until page contains element  //div[@role="listitem"]//span[text()="Syncing"]    60s
    page should contain element   //div[@role="listitem"]//span[text()="Syncing"]/../../div[2]/span/span/img

Manual Credit enquiry Button
    ${send_quote}    Set Variable    //div[@title='Send Quote Email']
    select frame   xpath=//div[contains(@class,'slds')]/iframe
    Wait until page contains element  //div[@class="panel-heading"]//h1[contains(text(),"Credit Score Validation")]   60s
    Wait until page contains element  //div//*[text()="Credit Score Not Accepted - Result: MAN"]  60s
    page should contain element	 //div//button[contains(text(),"Create Manual Credit Inquiry")]
    click button    //div//button[contains(text(),"Create Manual Credit Inquiry")]
    wait until page contains element  //div//h1[contains(text(),"Input Manual Credit Inquiry information")]  60s
    Wait Until Element Is Visible  //ng-form//textarea[@id="Description"]   50s
    sleep  5s
    input text   //ng-form//textarea[@id="Description"]   approve
    click element  //div//button[contains(text(),"Done")]
    unselect frame
    wait until page contains element    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span   60s
    ${quote_number}    get text    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span
    wait until page contains element    ${send_quote}   60s
    click element  ${send_quote}
    sleep  10s
    Wait Until Element Is Enabled    //div[contains(@class,'slds')]/iframe    60s
    select frame   xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //div//h1[contains(text(),"Credit Score result: Manual Credit Inquiry Case is not complete")]  60s
    ${value}    get text  //div[@class="slds-form-element__control"]//p//h3
    ${value} =  remove string   ${value}  Related Manual Credit Inquiry Case:
    ${value} =  remove string   ${value}   is waiting for decision.
    ${String_count} =  Get Line Count  ${value}
    #${Ending_position} =  Evaluate  ${String_count}-1
    ${value}=  Get Substring  ${value}  1  9
    log to console  ${value}
    #${value}  convert to number  ${value}
    unselect frame
    #logoutAsUser
    [Return]   ${value}  ${quote_number}

Activate The Manual Credit enquiry with positive
    [Arguments]  ${value}   ${Decision}
    reload page
    sleep  30s
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}   ${value}
    Sleep    2s
    Press Enter On    ${SEARCH_SALESFORCE}
    Wait Until Page Contains element    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a[@title='${value}']    120s
    Sleep    15s
    Click Element    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a[@title='${value}']
    wait until page contains element  //span[text()="Case Number"]  60s
    wait until page contains element  //a[text()="Case Details"]   30s
    sleep  30s
    click element  ${DETAILS_TAB}
    wait until page contains element  ${CHANGE_OWNER}  20s
    click element   ${CHANGE_OWNER}
    wait until page contains element  //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]  30s
    input text   //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]  Credit Control
    sleep  3s
    Press Enter On  //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]
    wait until page contains element  //a[text()="Full Name"]//following::a[text()='Credit Control']  60s
    click element     //a[text()="Full Name"]//following::a[text()='Credit Control']
    sleep  10s
    click element   ${CHANGE_OWNER_BUTTON}
    sleep  30s
    page should contain element  //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="In Progress"]
    force click element  //button[@title="Edit Decision"]
    #click element  //div//span/span[text()="Decision"]/../../div//a[@class="select"]
    select option from dropdown  //lightning-combobox//label[text()="Decision"]/..//div/*[@class="slds-combobox_container"]/div  ${Decision}
    click element   //button[@title="Save"]
    wait until page contains element    //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="Closed"]   60s
    page should contain element  //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="Closed"]
    logoutAsUser    Credit Control
    sleep  20s

Activate The Manual Credit enquiry with Negative
    [Arguments]  ${value}   ${Decision}
    reload page
    sleep  30s
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}   ${value}
    Sleep    2s
    Press Enter On    ${SEARCH_SALESFORCE}
    Wait Until Page Contains element    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a[@title='${value}']    120s
    Sleep    15s
    Click Element    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a[@title='${value}']
    wait until page contains element  //span[text()="Case Number"]  60s
    wait until page contains element  //a[text()="Case Details"]   30s
    sleep  30s
    click element  ${DETAILS_TAB}
    wait until page contains element  ${CHANGE_OWNER}  20s
    click element   ${CHANGE_OWNER}
    wait until page contains element  //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]  30s
    input text   //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]  Credit Control
    sleep  3s
    Press Enter On  //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]
    wait until page contains element  //a[text()="Full Name"]//following::a[text()='Credit Control']  60s
    click element     //a[text()="Full Name"]//following::a[text()='Credit Control']
    sleep  10s
    click element   ${CHANGE_OWNER_BUTTON}
    sleep  30s
    page should contain element  //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="In Progress"]
    force click element  //button[@title="Edit Decision"]
    #click element  //div//span/span[text()="Decision"]/../../div//a[@class="select"]
    select option from dropdown  //lightning-combobox//label[text()="Decision"]/..//div/*[@class="slds-combobox_container"]/div  ${Decision}
    click element   //button[@title="Save"]
    wait until page contains element  //div/strong[text()="Review the following fields"]  60s
    page should contain element     //div[text()="Please provide comments of negative decision."]
    click element  //li//a[text()="Decision Comments"]
    input text  //label[text()="Decision Comments"]/..//textarea  testing
    click element   //button[@title="Save"]
    wait until page contains element    //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="Closed"]   60s
    page should contain element  //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="Closed"]
    logoutAsUser    Credit Control
    sleep  20s

Activate The Manual Credit enquiry with positive with condition
    [Arguments]  ${value}   ${Decision}
    reload page
    sleep  30s
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}   ${value}
    Sleep    2s
    Press Enter On    ${SEARCH_SALESFORCE}
    Wait Until Page Contains element    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a[@title='${value}']    120s
    Sleep    15s
    Click Element    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a[@title='${value}']
    wait until page contains element  //span[text()="Case Number"]  60s
    wait until page contains element  //a[text()="Case Details"]   30s
    sleep  30s
    click element  ${DETAILS_TAB}
    wait until page contains element  ${CHANGE_OWNER}  20s
    click element   ${CHANGE_OWNER}
    wait until page contains element  //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]  30s
    input text   //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]  Credit Control
    sleep  3s
    Press Enter On  //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]
    wait until page contains element  //a[text()="Full Name"]//following::a[text()='Credit Control']  60s
    click element     //a[text()="Full Name"]//following::a[text()='Credit Control']
    sleep  10s
    click element   ${CHANGE_OWNER_BUTTON}
    sleep  30s
    page should contain element  //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="In Progress"]
    force click element  //button[@title="Edit Decision"]
    #click element  //div//span/span[text()="Decision"]/../../div//a[@class="select"]
    select option from dropdown  //lightning-combobox//label[text()="Decision"]/..//div/*[@class="slds-combobox_container"]/div  ${Decision}
    select option from dropdown   //lightning-combobox//label[text()="Conditions"]/..//div/*[@class="slds-combobox_container"]/div  Other
    click element  //lightning-textarea//label[text()="Other Condition"]/..//textarea
    input text  //lightning-textarea//label[text()="Other Condition"]/..//textarea   testing
    click element   //button[@title="Save"]
    wait until page contains element    //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="Closed"]   60s
    page should contain element  //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="Closed"]
    logoutAsUser    Credit Control
    sleep  20s

credit score status after approval
    ${send_quote}    Set Variable    //div[@title='Send Quote Email']
    ${quote_n}    Set Variable    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span
    ${send_mail}    Set Variable    //p[text()='Send Email']
    wait until page contains element    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span   60s
    wait until page contains element    ${send_quote}   60s
    click element  ${send_quote}
    sleep  50s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Click Visible Element    ${send_mail}
    unselect frame
    #ClickonCreateOrderButton
    wait until page contains element        //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']       60s
    sleep  10s
    ##${expiry} =    get text    //*[text()='Expiration Date']
    ##log to console    ${expiry}
    force click element    //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']
    #force click element       //a[@title='CPQ']
    sleep    30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #Log to console      Inside frame
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Create Order']/..    Create Order
    #Log to console      ${status}
    wait until page contains element    //span[text()='Create Order']/..    60s
    click element    //span[text()='Create Order']/..
    #Sleep  30s
    unselect frame
    Sleep  60s

Check the credit score result of the case with postive
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //button[contains(text(),"Create Order")]  60s
    page should contain element  //div//small[text()="Manual Credit Inquiry accepted. Decision: Positive"]
    page should contain element  //button[contains(text(),"Create Order")]
    click element  //button[contains(text(),"Create Order")]
    unselect frame
    Sleep  10s
    NextButtonOnOrderPage
    sleep  30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //section[@id='OrderTypeCheck']/section/div/div/div/h1  40s
    unselect frame
    OrderNextStepsPage

Check the credit score result of the case with Positive with Conditions
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //button[contains(text(),"Create Order")]  60s
    page should contain element  //div//small[text()="Manual Credit Inquiry accepted. Decision: Positive with Conditions"]
    page should contain element  //button[contains(text(),"Create Order")]
    click element  //button[contains(text(),"Create Order")]
    unselect frame
    Sleep  10s
    NextButtonOnOrderPage
    sleep  30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //section[@id='OrderTypeCheck']/section/div/div/div/h1  40s
    unselect frame
    OrderNextStepsPage

Check the credit score result of the Negative cases
    ${send_quote}    Set Variable    //div[@title='Send Quote Email']
    ${quote_n}    Set Variable    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span
    ${send_mail}    Set Variable    //p[text()='Send Email']
    wait until page contains element    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span   60s
    wait until page contains element    ${send_quote}   60s
    click element  ${send_quote}
    sleep  50s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    page should contain element   //span[contains(text(),"Credit Score result: Manual Credit Inquiry Case is not approved")]
    page should contain element  //p//h3[text()="Decision: Negative"]
    click element  //div//p[text()="Next"]
    unselect frame
    wait until page contains element        //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']       60s
    sleep  10s
    force click element    //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']
    sleep    30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Create Order']/..    Create Order
    wait until page contains element    //span[text()='Create Order']/..    60s
    click element    //span[text()='Create Order']/..
    unselect frame
    Sleep  60s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //h1[contains(text(),"Credit Score Validation")]   60s
    page should contain element     //div/small[text()="Manual Credit Inquiry case is not accepted. Decision: Negative"]

create two different billing account for payer and buyer validation
   [Arguments]  ${billing_acc_name}
   go to entity  ${vLocUpg_TEST_ACCOUNT}
   ${billing_acc_name1}    run keyword    CreateABillingAccount   ${vLocUpg_TEST_ACCOUNT}
   Go to Entity  ${billing_acc_name1}
   wait until page contains element  //div//span[text()="Payer for"]
   click button  //button[@title="Edit Payer for"]
   Select from search List   //div//input[@title="Search Accounts"]   ${vLocUpg_TEST_ACCOUNT}
   click element  //button[@title="Save"]
   go to entity   ${billing_acc_name}
   wait until page contains element  //div//span[text()="Payer for"]
   click button  //button[@title="Edit Payer for"]
   Select from search List   //div//input[@title="Search Accounts"]   ${vLocUpg_TEST_ACCOUNT}
   click element  //button[@title="Save"]
   [Return]     ${billing_acc_name1}

Validation for different billing account selection
   go to entity  ${vLocUpg_TEST_ACCOUNT}
   wait until page contains element  //a[@title="Sales Plan"]/../..//a[text()="More"]
   click element  //a[@title="Sales Plan"]/../..//a[text()="More"]
   wait until page contains element  //li[@role="presentation"]//a[@title="Assets"]
   click element  //li[@role="presentation"]//a[@title="Assets"]


updating setting Telia Domain Name space
    [Documentation]   Go to CPQ Page and updating setting Telia Domain Name space
    select frame    ${Page_iframe}
    Wait until element is visible   ${DNS_Setting}   60s
    Click Button    ${DNS_Setting}
    sleep  10s
    Input Text   ${Asiakkaan verkkotunnus}     Test
    Input Text   ${Linkittyvä tuote}    Test
    sleep  3s
    Click element  ${Setting_Close}
    sleep  10s
    Reload page
    sleep  10s
    select frame    ${Page_iframe}
    scrolluntillfound    ${CPQ_Next_Button}
    #sleep    10s
    wait until page contains element   ${CPQ_Next_Button}    60s
    click element    ${CPQ_Next_Button}
    Unselect Frame
    sleep    10s

SearchAndSelectBillingAccount
    [Arguments]   ${vLocUpg_TEST_ACCOUNT}
    execute javascript    window.location.reload(true)
    sleep    30s
    Wait until element is visible    //div[contains(@class,'slds')]/iframe   60s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until element is visible    //*[@id="ExtractAccount"]    60s
    click element    //*[@id="ExtractAccount"]
    wait until element is visible    //label[normalize-space(.)='Select Account']    30s
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until element is visible    //div[text()='${vLocUpg_TEST_ACCOUNT}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']    30s
    force click element    //div[text()='${vLocUpg_TEST_ACCOUNT}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    sleep    2s
    click element    //*[@id="SearchAccount_nextBtn"]
    unselect frame
    sleep    30s

SelectingTechnicalContactforTeliaDomainNameService
    [Documentation]   For selecting Technical contact field for DNS product
    [Arguments]   ${contact_name}
    ${Name}=  Run Keyword  Create Unique Name    ${DEFAULT_NAME}
    ${Mobile}=  Run Keyword   Create Unique Phone Number
    Wait until Element is enabled    ${Page_iframe}    60s
    select frame    ${Page_iframe}
    log to console    entering Technical COntact page
    Wait Until Element Is Visible    ${contact_search}    60s
    Input Text    ${contact_search}   ${contact_name}
    sleep   15s
    #Wait until element is visible   css=.typeahead .ng-binding   30s
    Click element   css=.typeahead .ng-binding
    sleep   15s
    Wait until element is visible  ${contact_email}   30s
    ${primary_email}  get text  ${contact_email}
    Execute JavaScript    window.scrollTo(0,200)
    Wait Until element is visible   ${Technical_contact_search}     30s
    Input text   ${Technical_contact_search}  ${contact_name}
    sleep  15s
    Wait until element is visible   css=.typeahead .ng-binding   60s
    Click element   css=.typeahead .ng-binding
    sleep   15s
    Wait until element is visible  ${Technical_contact_email}   30s
    Execute JavaScript    window.scrollTo(0,200)
    sleep  10s
    Execute JavaScript    window.scrollTo(0,200)
    Wait Until element is visible   ${Main_User}     30s
    Input text    ${Main_User}  ${d}
    sleep  10s
    Click element   css=.typeahead .ng-binding
    sleep  10s
    Execute JavaScript    window.scrollTo(0,200)
    Wait until element is visible   ${FirstName}  30s

    Wait until element is visible  ${LastName}  30s
    Wait until element is visible  ${MobileNumber}   30s
    Input Text  ${MobileNumber}  ${Mobile}
    Wait until element is visible  ${Street}  30s
    Input Text   ${Street}   ${DEFAULT_ADDRESS}
    Wait until element is visible  ${Postal_codes}   30s
    Input Text   ${Postal_codes}   43500
    Wait until element is visible   ${city_Name}   30s
    Input Text    ${city_Name}   ${City}
    force click element  ${Communication}
    sleep  10s
    wait until page contains element  ${DNS_communication_language} 60s
    click visible element  ${DNS_communication_language}

    sleep  60s
    Click Element    ${contact_next_button}
    log to console  clicked next button
    sleep  60s
    unselect frame
    sleep   30s

Validate Main user in order product
    [Arguments]    ${Ordernumber}  ${pdtname}
    [Documentation]   To validate the ordered product belongs to main user
    log to console  ${Ordernumber}.is the order number
    Go To Entity    ${Ordernumber}
    wait until page contains element      //li[@class="tabs__item active uiTabItem"]//a//span[text()="Related"]   45s
    Force Click Element    //li[@class="tabs__item active uiTabItem"]//a//span[text()="Related"]
    sleep    10s
    wait until page contains element    //div[@class="slds-media__body"]//a//span[text()="Order Products"]    20s
    Force Click Element  //div[@class="slds-media__body"]//a//span[text()="Order Products"]
    sleep    10s
    log to console  Order product is clicked
    wait until page contains element  //th/span/a[@title='${pdtname}']  60s
    sleep  60s
    click element  //th/span/a[@title='${pdtname}']
    sleep  20s
    log to console  product is clicked
    sleep  60s
    Reload page
    ${status_page} =  run keyword and return status  wait until page contains element   /a[@title="Related"]   60s
    Run Keyword If    ${status_page} == False    Reload Page
#   Run Keyword If    ${status_page} == False    Sleep  60s
    sleep  60s
    Force Click Element  //a[@title="Related"]
    Log to console   related page is clicked
    sleep  20s
    wait until page contains element    //div[@class="slds-media__body"]//a//span[text()="Order Contact Roles"]   60s
    click element   //div[@class="slds-media__body"]//a//span[text()="Order Contact Roles"]
   # Go to   ${order_contactrole}
    Sleep  20s
    wait until page contains element    //div[@id="brandBand_1"]//h1[@title="Order Contact Roles"]     20s
    ${ordercontact role}  get text   //td[@role="gridcell"]//span[text()="Main User"]
    Log to Console    ${ordercontact role}

Validate ServiceAdministrator in Account contact role
   [Arguments]    ${First_name}   ${lastname}
   [Documentation]   This is to validate the account contact role created belongs to Service Adminisatrator
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Reload page
    wait until page contains element     ${ACCOUNT_RELATED}  45s
    Force Click Element    ${ACCOUNT_RELATED}
    sleep    10s
    wait until page contains element    //div[@class="slds-media__body"]//a//span[text()="Contact Roles"]  45s
    Click Element   //div[@class="slds-media__body"]//a//span[text()="Contact Roles"]
    sleep   10s
    wait until page contains element    //h1[@title="Contact Roles"]    30s
    scrolluntillfound     //*[@id="brandBand_1"]//td//span//span[@title="${lastname}"]
    Page should contain element     //*[@id="brandBand_1"]//th//span//span[@title="${First_name}"]   60s
    Page should contain element     //*[@id="brandBand_1"]//td//span//span[@title="${lastname}"]    30s
    Page should contain element   //*[@id="brandBand_1"]//td//span//span[@title="${lastname}"]//following::td[1]//span//span[text()="Service Administrator"]   30s
#    Page should contain element   //*[@id="brandBand_1"]//td//span//a[text()="${email}"]    60s

Update Setting Vula without Next
    [Documentation]    Go to CPQPage and Update Setting Vula without going Next
    [Arguments]        ${pname}
    select frame    ${Page_iframe}
    ${SETTINGS}   set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/div/span[text()='${pname}']//following::button[@title='Settings']
    Wait until element is visible   ${SETTINGS}   60s
    Click Button    ${SETTINGS}
    sleep  30s
    Click element  ${Nopeus}
    Click element  ${Nopeus}/option[2]
    Click element   ${Asennuskohde}
    Click element   ${Asennuskohde}/option[2]
    Click element   ${Toimitustapa}
    Click element   ${Toimitustapa}/option[2]
    Input Text  ${VLAN}  1
    Input Text   ${VULA NNI}    Test
    Input Text   ${Yhteyshenkilön nimi}    Test
    Input Text    ${Yhteyshenkilön puhelinnumero}   Test
    Input Text   ${Katuosoite}   Test
    Input Text    ${Katuosoite numero}  Test
    sleep  3s
    Input Text  ${Postinumero}   00510
    sleep  3s
    Input Text    ${Postitoimipaikka}   Test
    sleep  4s
    Click element    ${Postitoimipaikka}
    sleep  5s
    Click element   //div[@class="slds-grid slds-grid--vertical cpq-product-cart-config"]
    sleep  10s
    Click element  ${Setting_Close}
    sleep  10s
    Reload page
    sleep  10s


FetchfromOrderproduct
    [Documentation]    Go to OrderProductPage and fetch the subscription ID
    [Arguments]    ${Ordernumber}
    Go To Entity    ${Ordernumber}
    wait until page contains element      ${Order_Related_Tab}   45s
    Force Click Element    ${Order_Related_Tab}
    sleep    10s
    wait until page contains element    ${Order_Products_Tab}    20s
    Force Click Element  ${Order_Products_Tab}
    sleep    10s
    sleep  10s
    click element  ${Order_Products_Select}
    sleep  20s
    Reload page
    wait until page contains element     ${Order_Products_Related_Tab}   60s
    Force Click Element   ${Order_Products_Related_Tab}
    log to console  related is clicked
    sleep  20s
    wait until page contains element  ${Order_Products_Assets_Tab}  60s
    click element  ${Order_Products_Assets_Tab}
    sleep  10s
    ${subscription_ID}   get text   ${Order_Products_SubID}
    sleep  3s
    [Return]   ${subscription_ID}


Validate technical contact in the asset history page using subscription as
   [Documentation]    Go to Account asset History and select the respective product based on subscription ID and validate the technical contact details
   [Arguments]    ${sub_name}     ${Contact_name}
     Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
     scroll page to location  0  9000
     ScrollUntillFound   //button//span[text()='Asset History']
     Log to console  scroll to asset history
     select frame   ${Account_Asset_iframe}
     ScrollUntillFound  //div[text()='Subscription Id']/following::ul/li/div/div[3]/div[text()='${sub_name}']/../..//div[@class="p-name"]/a
     wait until page contains element  //div[text()='Subscription Id']/following::ul/li/div/div[3]/div[text()='${sub_name}']/../..//div[@class="p-name"]/a  60s
     Force click element   //div[text()='Subscription Id']/following::ul/li/div/div[3]/div[text()='${sub_name}']/../..//div[@class="p-name"]/a
     unselect frame
     sleep  10s
     switch between windows  1
#    Switch Window  NEW
     ${contact_value}  get text  ${Account_Asset_TechnicalContact}
     Should be equal   ${contact_value}    ${Contact_name}

Add multiple products in SVE

   [Arguments]     @{items}
    ${i} =    Set Variable    ${0}
    ${fyr_value_total}=   Set Variable   ${0}
    ${count_list}=  Get length  ${items}
    log to console  ${count_list}.number of items
    select frame   ${Page_iframe}
     :FOR    ${item}    IN    @{items}
     \    ${i} =    Set Variable    ${i + 1}
#     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@class='form-control ng-pristine ng-untouched ng-valid ng-empty']
     \  input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][ ${i}]/td/input[@class='form-control ng-pristine ng-untouched ng-valid ng-empty']    ${item}
     \  Click element   css=.typeahead.dropdown-menu.ng-scope.am-fade.bottom-left li.ng-scope a.ng-binding
     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@type='number']
     \  input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@type='number']   ${product_quantity}
     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model='p.OneTimeTotalt']
     \  input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model='p.OneTimeTotalt']   ${NRC}
     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model='p.RecurringTotalt']
     \  input text     //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model='p.RecurringTotalt']   ${RC}
     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/select[@ng-model='p.SalesType']
     \  sleep  2s
     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/select[@ng-model='p.SalesType']/option[@value='${sales_type_value${i}}']
     \  sleep  5s
     \  click element  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model="p.ContractLength"]
     \  Input text  //th[normalize-space(.)='Solution Area']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model='p.ContractLength']  ${contract_lenght}
     \  ${fyr_value}=   evaluate  ((${RC}*${contract_lenght})+ ${NRC}) * ${product_quantity}
     \  ${revenue_value}=  evaluate  ((${RC}*${contract_lenght})+ ${NRC}) * ${product_quantity}
     \  page should contain element  //th[normalize-space(.)='FYR']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model="p.RecurringTotalt"]/../following-sibling::td[normalize-space(.)='${fyr_value}.00'][1]
     \  page should contain element  //th[normalize-space(.)='FYR']//following::tr[@class='parent-product ng-scope'][${i}]/td/input[@ng-model="p.RecurringTotalt"]/../following-sibling::td[normalize-space(.)='${revenue_value}.00'][2]
     \  Run keyword if   ${i}<${count_list}   click element   //div[text()='Add']
     \  ${fyr_value_total}=  evaluate  (${fyr_value_total}+${fyr_value})
     wait until page contains element  //button[normalize-space(.)='Save Changes']   60s
     force click element  //button[normalize-space(.)='Save Changes']
     sleep  30s
     unselect frame
     sleep  30s
    [Return]  ${fyr_value_total}

validateproductsbasedonsalestype

   [Arguments]     @{items}
    ${list_Prd}    Create List    @{items}
    @{list_with prod and sales}     create list
    ${count}    Get Length    ${list_Prd}
    Wait until element is visible   ${Oppo_Related_Tab}   10s
    Force click element     ${Oppo_Related_Tab}
    Wait until element is visible   ${Oppo_Product_panel}   10s
    Wait until element is visible   ${Product_viewall_button}   30s
    Click Button    ${Product_viewall_button}
    sleep  30s
    switch between windows  1
    sleep  30s
    :FOR    ${i}    IN RANGE    ${count}
    \    ${i} =    Set Variable    ${i + 1}
    \   ${sales_type}  get text   //table[@role="treegrid"]/tbody/tr[${i}]/th/following::td[2]//div
    \   ${sales_value}  get text  //table[@role="treegrid"]/tbody/tr[${i}]/th/following::td[8]//div
    \   Append To List  ${list_with prod and sales}    ${sales_type}    ${sales_value}
    ${add_new}  ${add_ren}  ${add_frame} =   addFYRbasedonSalesType  ${list_with prod and sales}
    switch between windows  0
    [Return]   ${add_new}  ${add_ren}  ${add_frame}


Validating FYR values in Opportunity Header

     [Arguments]    ${fyr_total}   ${new}   ${ren}   ${frame}
     sleep  90s
     page should contain element    //p[text()="FYR Total"]/../..//lightning-formatted-text[text()=normalize-space(.)=" ${fyr_total},00 €"]
     page should contain element    //p[text()="FYR New Sales"]/../..//lightning-formatted-text[text()=normalize-space(.)=" ${new},00 €"]
     page should contain element   //p[text()="FYR Continuation Sales"]/../..//lightning-formatted-text[text()=normalize-space(.)="${ren},00 €"]
     page should contain element    //p[text()="FYR Total Frame Agreement"]/../..//lightning-formatted-text[text()=normalize-space(.)="${frame},00 €"]
