*** Settings ***
Resource                ../resources/common.robot
Resource                ../resources/cpq_keywords.robot
Resource                ../resources/sales_app_light_variables.robot

*** Keywords ***

Go To Salesforce
    Go To           ${LOGIN_PAGE}
    Login Page Should Be Open

Go to Sales App
    ${IsElementVisible}=    Run Keyword And Return Status       element should not be visible  ${SALES_APP_NAME}
    Run Keyword If  ${IsElementVisible}   Switch to SalesApp

Switch to SalesApp
    Click Element       ${APP_LAUNCHER}
    Wait until Page Contains Element        ${SALES_APP_LINK}       20s
    Click Element       ${SALES_APP_LINK}
    Wait Until Element is Visible       ${SALES_APP_NAME}           20s

Login Page Should Be Open
    Wait Until Keyword Succeeds     10 seconds      1 second    Location Should Be      ${LOGIN_PAGE}
    Wait Until Element Is Visible        id=username     10 seconds
    Wait Until Element Is Visible        id=password     10 seconds

Go To Salesforce and Login into Lightning
    [Arguments]   ${user}=DigiSales Lightning User
    Go to Salesforce
    Run Keyword     Login to Salesforce as ${user}
    Go to Sales App
    Reset to Home


Login to Salesforce as DigiSales Lightning User
    Login To Salesforce Lightning     ${B2B_DIGISALES_LIGHT_USER}       ${PASSWORD}

Login to Salesforce Lightning
    [Arguments]         ${username}=${B2B_DIGISALES_LIGHT_USER}
    ...                 ${password}=${PASSWORD}
    Wait Until Page Contains Element        id=username
    Input Text          id=username         ${username}
    Input Password      id=password         ${password}
    Click Element       id=Login
    Check For Lightning Force
    Wait Until Page Contains Element   xpath=${LIGHTNING_ICON}    30 seconds


Check For Lightning Force
    Sleep   15s
    ${url}=     Get Location
    ${contains}=  Evaluate  'lightning' in '${url}'
    Run Keyword Unless  ${contains}   Switch to Lightning

Switch to Lightning
    Sleep   15s
    Click Element       xpath=${CLASSIC_MENU}
    Page Should Contain Element       xpath=${SWITCH_TO_LIGHTNING}      30s
    Click Element       xpath=${SWITCH_TO_LIGHTNING}

Reset to Home
    [Arguments]     ${timeout}=20 seconds
    Wait Until Element is Visible       ${SALES_APP_HOME}       20 seconds
    Click Element     ${SALES_APP_HOME}
    Sleep       10s

Go to Entity
    [Arguments]    ${target}    ${type}=${EMPTY}
    Log     Going to '${target}'
    Search And Select the Entity    ${target}     ${type}
    Sleep   10s      The page might load too quickly and it can appear as the search tab would be closed even though it isn't

Search And Select the Entity
    [Arguments]     ${target}   ${type}=${EMPTY}
    Search Salesforce    ${target}
    Select Entity    ${target}     ${type}

Search Salesforce
    [Arguments]         ${item}
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}      20s
    Input Text          xpath=${SEARCH_SALESFORCE}      ${item}
    Sleep   5s
    Press Key       xpath=${SEARCH_SALESFORCE}     \\13
    Sleep   5s
    Wait Until Page Contains element        xpath=${SEARCH_RESULTS}     30S

Select Entity
    [Arguments]         ${target_name}     ${type}
    Wait Until Page Contains element    ${TABLE_HEADER}[@title='${target_name}']   15s
    Click Element       ${TABLE_HEADER}[@title='${target_name}']
    #Press key      ${TABLE_HEADER}[@title='${target_name}']   //13
    Sleep   10s
    Entity Should Be Open    ${target_name}

Entity Should Be Open
    [Arguments]         ${target_name}
    Wait Until Page Contains element            ${ENTITY_HEADER}//*[text()='${target_name}']

Create New Opportunity For Customer
    [Arguments]     ${opport_name}=${EMPTY}
    ...             ${stage}=Analyse Prospect
    ...             ${days}=1
    ...             ${expect_error}=${FALSE}
    Click New Item For Account      New Opportunity
    Fill Mandatory Opportunity Information      ${stage}    ${days}
    Fill Mandatory Classification
    Click Save Button
    Sleep           5s
    Run Keyword Unless      ${expect_error}     Verify That Opportunity Creation Succeeded

Click New Item For Account
    [Arguments]     ${type}
     ${status}=      Run Keyword And Return Status      Element Should Be Visible     //a[@title='${type}']
    Run Keyword If       ${status}     Run Keyword With Delay      0.5s    Click Element   xpath=//a[@title='${type}']
    Wait Until Page Contains Element    ${NEW_ITEM_POPUP}     10s

Fill Mandatory Opportunity Information
    [Arguments]
    ...    ${stage}=Analyse Prospect
    ...    ${days}=1
           ${opport_name}=  Run Keyword        Create Unique Name          TestOpportunity
    Set Test Variable    ${OPPORTUNITY_NAME}    ${opport_name}
    ${date}=    Get Date From Future    ${days}
    Set Test Variable    ${OPPORTUNITY_CLOSE_DATE}      ${date}
    Input Quick Action Value For Attribute     Opportunity Name    ${OPPORTUNITY_NAME}
    Select Quick Action Value For Attribute    Stage        ${stage}
    Input Quick Action Value For Attribute     Close Date   ${OPPORTUNITY_CLOSE_DATE}


Input Quick Action Value For Attribute
    [Arguments]     ${field}    ${value}
    Wait Until Element Is Visible    ${NEW_ITEM_POPUP}//label//*[contains(text(),'${field}')]      20s
    Input Text       xpath=${NEW_ITEM_POPUP}//label//*[contains(text(),'${field}')]//following::input      ${value}


Select Quick Action Value For Attribute
    [Arguments]     ${field}    ${value}
    Wait Until Element Is Visible    ${NEW_ITEM_POPUP}//span[contains(text(),'${field}')]//following::div//a[@class='select']   20s
    Click Element       ${NEW_ITEM_POPUP}//span[contains(text(),'${field}')]//following::div//a[@class='select']
    Wait Until Element Is Visible    //div[@class='select-options']//li//a[contains(text(),'${value}')]
    Click Element       //div[@class='select-options']//li//a[contains(text(),'${value}')]


Fill Mandatory Classification
    [Arguments]    ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    Set Test Variable    ${OPPO_DESCRIPTION}     Test Automation opportunity description
    Input Text       xpath=//label//span[contains(text(),'Description')]//following::textarea    ${OPPO_DESCRIPTION}

Click Save Button
    Click Element       ${SAVE_OPPORTUNITY}


Verify That Opportunity Creation Succeeded
    Wait Until Element Is Visible       ${ACCOUNT_RELATED}      20s
    Click element       xpath=${ACCOUNT_RELATED}
    ${status}=      Run Keyword And Return Status      Element Should Be Visible     //span[@title='Account Team Members']
    Run Keyword If       ${status}     Run Keyword With Delay      0.5s    Click Element   xpath=${ACCOUNT_RELATED}
    Sleep       5s
    Scroll Page To Location         0       450
    Verify That Opportunity Is Saved And Data Is Correct    ${RELATED_OPPORTUNITY}


Scroll Page To Location
    [Arguments]    ${x_location}    ${y_location}
    Execute JavaScript    window.scrollTo(${x_location},${y_location})
    Sleep       10s


Verify That Opportunity Is Saved And Data Is Correct
    [Arguments]     ${element}
    ...             ${account_name}=${LIGHTNING_TEST_ACCOUNT}
                    ${oppo_name}=    Set Variable       //*[text()='${OPPORTUNITY_NAME}']
                    ${account_name}=    Set Variable    //*[@title='Account Name']//following-sibling::div//*[text()='${LIGHTNING_TEST_ACCOUNT}']
                    ${oppo_date}=    Set Variable       //*[@title='Close Date']//following-sibling::div//*[text()='${OPPORTUNITY_CLOSE_DATE}']
    sleep       5s
    Wait Until Page Contains Element   ${element}${oppo_name}       20s
    Run keyword and ignore error        Click element       ${element}${oppo_name}
    Sleep       10s
    Wait Until Page Contains Element    ${oppo_name}        20s
    Wait Until Page Contains Element    ${account_name}     20s
    Wait Until Page Contains Element    ${oppo_date}        20s

Verify That Opportunity Is Found With Search And Go To Opportunity
    [Arguments]     ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    Go to Entity        ${OPPORTUNITY_NAME}
    Wait until Page Contains Element    ${OPPORTUNITY_PAGE}//*[text()='${OPPORTUNITY_NAME}']     15s
    Verify That Opportunity Is Saved And Data Is Correct    ${OPPORTUNITY_PAGE}


Verify That Opportunity is Found From My All Open Opportunities
    [Arguments]     ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    ...             ${days}=1
                    ${date}=    Get Date From Future    ${days}
                    ${oppo_name}=    Set Variable       //*[text()='${OPPORTUNITY_NAME}']
                    ${account_name}=    Set Variable    //*[@title='Account Name']//following-sibling::div//*[text()='${LIGHTNING_TEST_ACCOUNT}']
                    ${oppo_date}=    Set Variable       //*[@title='Close Date']//following-sibling::div//*[text()='${date}']
    Open Tab    Opportunities
    Select Correct View Type    My All Open Opportunities
    Filter Opportunities By     Opportunity Name    ${OPPORTUNITY_NAME}
    Sleep       10s
    Wait Until Page Contains Element    ${OPPORTUNITY_PAGE}${oppo_name}        20s
    Wait Until Page Contains Element    ${account_name}     20s
    Wait Until Page Contains Element    ${oppo_date}        20s

Open tab
    [Arguments]    ${tabName}
    ...     ${timeout}=20 seconds
    Wait Until Element is Visible       //a[@title='${tabName}']       20 seconds
    Click Element     //a[@title='${tabName}']
    Sleep       10s

Select Correct View Type
    [Arguments]         ${type}
    Sleep       5s
    click element      //span[contains(@class,'selectedListView')]
    #${flag}    Run Keyword And Return Status    Wait Until Element Is Visible    //span[@class=' virtualAutocompleteOptionText' and text()='${type}']
    #Run Keyword If      ${flag}         Click Element           //a[@title='Select List View']
    Wait Until Page Contains Element        //span[@class=' virtualAutocompleteOptionText' and text()='${type}']      20s
    Click Element       //span[@class=' virtualAutocompleteOptionText' and text()='${type}']//parent::a
    Sleep       5s


Filter Opportunities By
    [Arguments]     ${field}    ${value}
    ${Count}=    get element count    ${RESULTS_TABLE}
    Click Element      //input[@name='search-input']
    Wait Until Page Contains Element        ${SEARCH_INPUT}     20s
    Input Text          xpath=${SEARCH_INPUT}      ${value}
    Press Key       xpath=${SEARCH_INPUT}     \\13
    Sleep   5s
    Run Keyword If  ${Count} > 1  Click Element     xpath=${RESULTS_TABLE}[contains(@class,'forceOutputLookup') and (@title='${value}')]

Go to Contacts
    Click Visible Element               ${CONTACTS_TAB}
    Wait Until Page Contains element    ${CONTACTS_ICON}    10S

Create New Master Contact
    ${first_name}=  Run Keyword     Create Unique Name          ${EMPTY}
    ${email_id}=    Run Keyword     Create Unique Email         ${DEFAULT_EMAIL}
    ${mobile_num}=  Run Keyword     Create Unique Mobile Number
    Set Test Variable    ${MASTER_FIRST_NAME}       Mas ${first_name}
    Set Test Variable    ${MASTER_LAST_NAME}        Test ${first_name}
    Set Test Variable    ${MASTER_PRIMARY_EMAIL}    ${email_id}
    Set Test Variable    ${MASTER_MOBILE_NUM}       ${mobile_num}
    Click Visible Element               ${NEW_BUTTON}
    Click Visible Element               ${MASTER}
    click Element                       ${NEXT}
    Wait Until Element is Visible       ${CONTACT_INFO}     10s
    Input Text                          ${MASTER_MOBILE_NUM_FIELD}        ${MASTER_MOBILE_NUM}
    Input Text                          ${MASTER_FIRST_NAME_FIELD}        ${MASTER_FIRST_NAME}
    Input Text                          ${MASTER_LAST_NAME_FIELD}         ${MASTER_LAST_NAME}
    Input Text                          ${MASTER_PHONE_NUM_FIELD}         ${MASTER_PHONE_NUM}
    Input Text                          ${MASTER_PRIMARY_EMAIL_FIELD}     ${MASTER_PRIMARY_EMAIL}
    #Input Text                          ${MASTER_EMAIL_FIELD}             ${MASTER_EMAIL}
    Select from Autopopulate List       ${ACCOUNT_NAME_FIELD}             ${MASTER_ACCOUNT_NAME}
    Click Element                       ${SAVE_BUTTON}
    Sleep                               5s
    #Validate Master Contact Details     ${CONTACT_DETAILS}

Select from Autopopulate List
    [Arguments]                             ${field}            ${value}
    Input Text                              ${field}            ${value}
    Click Visible Element                   //div[contains(@class,'primaryLabel') and @title='${value}']

Validate Master Contact Details
    [Arguments]     ${element}
                    ${contact_name}=    Set Variable       //span[text()='Name']//following::span//span[text()='${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}']
                    ${account_name}=    Set Variable       //span[text()='Account Name']//following::a[text()='${MASTER_ACCOUNT_NAME}']
                    ${mobile_number}=   Set Variable       //span[text()='Mobile']//following::span//span[text()='${MASTER_MOBILE_NUM}']
                    ${phone_number}=    Set Variable       //span[text()='Phone']//following::span//span[text()='${MASTER_PHONE_NUM}']
                    ${primary_email}=   Set Variable       //span[text()='Primary eMail']//following::a[text()='${MASTER_PRIMARY_EMAIL}']
                    #${email}=           Set Variable       //span[text()='Email']//following::a[text()='${MASTER_EMAIL}']
    Go to Entity   ${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}
    Click Visible element                       //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    Sleep                               5s
    Validate Contact Details   ${element}  ${contact_name}  ${account_name}  ${mobile_number}  ${primary_email}
    #Wait Until Page Contains Element    ${element}${phone_number}
    #Wait Until Page Contains Element    ${element}${email}

Validate Contact Details
    [Arguments]  ${element}  ${contact_name}  ${account_name}  ${mobile_number}  ${email}
    Wait Until Page Contains Element    ${element}${contact_name}
    Wait Until Page Contains Element    ${element}${account_name}
    Wait Until Page Contains Element    ${element}${mobile_number}
    Wait Until Page Contains Element    ${element}${email}

Create New NP Contact
    ${first_name}=  Run Keyword         Create Unique Name          ${EMPTY}
    ${email_id}=    Run Keyword         Create Unique Email         ${DEFAULT_EMAIL}
    ${mobile_num}=  Run Keyword         Create Unique Mobile Number
    Set Test Variable                   ${NP_FIRST_NAME}            NP ${first_name}
    Set Test Variable                   ${NP_LAST_NAME}             Test ${first_name}
    Set Test Variable                   ${NP_EMAIL}                 ${email_id}
    Set Test Variable                   ${NP_MOBILE_NUM}            ${mobile_num}
    Click Visible Element               ${NEW_BUTTON}
    Click Visible Element               ${NON-PERSON}
    click Element                       ${NEXT}
    Wait Until Element is Visible       ${CONTACT_INFO}             10s
    Input Text                          ${MASTER_MOBILE_NUM_FIELD}  ${NP_MOBILE_NUM}
    Input Text                          ${MASTER_FIRST_NAME_FIELD}  ${NP_FIRST_NAME}
    Input Text                          ${MASTER_LAST_NAME_FIELD}   ${NP_LAST_NAME}
    Input Text                          ${NP_EMAIL_FIELD}           ${NP_EMAIL}
    #Select from Autopopulate List       ${ACCOUNT_NAME_FIELD}             ${NP_ACCOUNT_NAME}
    Input Text                           ${ACCOUNT_NAME_FIELD}            ${NP_ACCOUNT_NAME}
    Sleep  2s
    Press Enter On                      ${ACCOUNT_NAME_FIELD}
    Click Visible Element               //div[@data-aura-class="forceSearchResultsGridView"]//a[@title='${NP_ACCOUNT_NAME}']
    Press Enter On                      ${SAVE_BUTTON}

Validate NP Contact Details
    [Arguments]     ${element}
                    ${contact_name}=    Set Variable       //span[text()='Name']//following::span//span[text()='Non-person ${NP_FIRST_NAME} ${NP_LAST_NAME}']
                    ${account_name}=    Set Variable       //span[text()='Account Name']//following::a[text()='${NP_ACCOUNT_NAME}']
                    ${mobile_number}=   Set Variable       //span[text()='Mobile']//following::span//span[text()='${NP_MOBILE_NUM}']
                    ${email}=           Set Variable       //span[text()='Email']//following::a[text()='${NP_EMAIL}']
    Go to Entity   Non-person ${NP_FIRST_NAME} ${NP_LAST_NAME}
    Click Visible Element                       //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    Validate Contact Details  ${element}  ${contact_name}  ${account_name}  ${mobile_number}  ${email}

Create New Contact for Account
    ${first_name}=  Run Keyword         Create Unique Name          ${EMPTY}
    ${email_id}=    Run Keyword         Create Unique Email         ${DEFAULT_EMAIL}
    ${mobile_num}=  Run Keyword         Create Unique Mobile Number
    Set Test Variable                   ${AP_FIRST_NAME}            AP ${first_name}
    Set Test Variable                   ${AP_LAST_NAME}             Test ${first_name}
    Set Test Variable                   ${AP_EMAIL}                 ${email_id}
    Set Test Variable                   ${AP_MOBILE_NUM}            ${mobile_num}
    click element           ${AP_NEW_CONTACT}
    sleep                   2s
    Input Text              ${AP_MOBILE_FIELD}              ${AP_MOBILE_NUM}
    Input Text              ${MASTER_FIRST_NAME_FIELD}      ${AP_FIRST_NAME}
    Input Text              ${MASTER_LAST_NAME_FIELD}       ${AP_LAST_NAME}
    Input Text              ${MASTER_PRIMARY_EMAIL_FIELD}   ${AP_EMAIL}
    Click Element           ${AP_SAVE_BUTTON}
    Sleep                   2s

Validate AP Contact Details
    Go To Entity   ${AP_FIRST_NAME} ${AP_LAST_NAME}  ${SEARCH_SALESFORCE}
    [Arguments]     ${element}
                    ${contact_name}=        Set Variable        //span[text()='Name']//following::span//span[text()='${AP_FIRST_NAME} ${AP_LAST_NAME}']
                    ${account_name}=        Set Variable        //span[text()='Account Name']//following::a[text()='${AP_ACCOUNT_NAME}']
                    ${mobile_number}=       Set Variable        //span[text()='Mobile']//following::span//span[@class="uiOutputPhone" and text()='${AP_MOBILE_NUM}']
                    ${email}=               Set Variable        //span[text()='Primary eMail']//following::a[text()='${AP_EMAIL}']
    #Click Visible Element               //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    Validate Contact Details  ${element}  ${contact_name}  ${account_name}  ${mobile_number}  ${email}

Create Unique Mobile Number
    ${numbers}=     Generate Random String    6    [NUMBERS]
    [Return]        +358888${numbers}

Cancel Opportunity
    [Arguments]       ${opportunity}
    Edit Opportunity  ${opportunity}
    click visible element       ${EDIT_STAGE_BUTTON}
    Select option from Dropdown     //div[@class="uiInput uiInput--default"]//a[@class="select"]   //a[@title="Cancelled"]
    Save
    Validate error message
    Cancel and save


Validate Opportunity Details
    [Arguments]  ${OPPORTUNITY_NAME}  ${STAGE}
                 ${current_date}=    Get Current Date    result_format=%d.%m.%Y
                 ${oppo_close_date}=    Set Variable        //span[@title='Close Date']//following-sibling::div//span[text()='${current_date}']
    Go to Entity  ${OPPORTUNITY_NAME}
    Wait Until Page Contains Element   ${oppo_close_date}       10s
    Wait Until Page Contains Element   //span[text()='Edit Stage']/../preceding::span[text()='${STAGE}']  10s
    Wait Until Page Contains Element   ${OPPORTUNITY_CANCELLED}  10s


Save
    click element                   //button[@title='Save']
    sleep  2s

Validate error message
    #element should be visible       //div[@data-aura-class="forcePageError"]
    #element should be visible       //a[contains(text(),"Close Comment")]
    #element should be visible       //a[contains(text(),"Close Reason")]
    element should be visible       //a[@data-field-name="telia_Close_Reason__c"]
    element should be visible       //a[@data-field-name="telia_Close_Comment__c"]


Cancel and save
    Scroll Page To Location     0       3000
    click element                   //a[contains(text(),"Close Comment")]
    input text      //label//span[contains(text(),"Close Comment")]/../following::textarea  Cancelling based on Customer request
    Click Element           xpath=//span[text()='Close Reason']//parent::span//parent::div//div[@class='uiPopupTrigger']//a
    sleep  2s
    click element   //a[@title="09 Customer Postponed"]
    Save

Edit Opportunity
    [arguments]     ${opportunity}
    Go to Entity    ${opportunity}

Select option from Dropdown
    [Arguments]             ${list}        ${item}
    #Select From List By Value    //div[@class="uiInput uiInput--default"]//a[@class="select"]   ${item}
    Click Visible Element  ${list}
    Click Visible Element  ${item}
