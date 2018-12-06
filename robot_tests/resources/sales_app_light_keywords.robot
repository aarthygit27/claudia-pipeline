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

Go to Account
    [Arguments]    ${target_account}    ${type}=${EMPTY}
    Log     Going to '${target_account}'
    Search And Select the Account    ${target_account}     ${type}
    Sleep   10s      The page might load too quickly and it can appear as the search tab would be closed even though it isn't

Search And Select the Account
    [Arguments]     ${target_account}   ${type}=${EMPTY}
    Search Salesforce    ${target_account}
    Select Account    ${target_account}     ${type}

Search Salesforce
    [Arguments]         ${item}
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}      20s
    Input Text          xpath=${SEARCH_SALESFORCE}      ${item}
    Sleep   5s
    Press Key       xpath=${SEARCH_SALESFORCE}     \\13
    Sleep   10s
    Wait Until Page Contains element        xpath=${SEARCH_RESULTS}     30S

Select Account
    [Arguments]         ${account_name}     ${type}
    Wait Until Page Contains element    ${TABLE_HEADER}[@title='${account_name}']
    Click Element       ${TABLE_HEADER}[@title='${account_name}']
    Sleep   10s
    Account Should Be Open    ${account_name}

Account Should Be Open
    [Arguments]         ${account_name}
    Wait Until Page Contains element            ${ACCOUNT_HEADER}//*[text()='${account_name}']

Create New Opportunity For Customer
    [Arguments]     ${opport_name}=${OPPORTUNITY_NAME}
    ...             ${stage}=Analyse Prospect
    ...             ${days}=1
    ...             ${expect_error}=${FALSE}
    Click New Item For Account      New Opportunity
    Fill Mandatory Opportunity Information      ${opport_name}    ${stage}    ${days}
    Fill Mandatory Classification
    Click Save Button
    Run Keyword Unless      ${expect_error}     Verify That Opportunity Creation Succeeded

Click New Item For Account
    [Arguments]     ${type}
     ${status}=      Run Keyword And Return Status      Element Should Be Visible     //a[@title='${type}']
    Run Keyword If       ${status}     Run Keyword With Delay      0.5s    Click Element   xpath=//a[@title='${type}']
    Wait Until Page Contains Element    ${NEW_ITEM_POPUP}     10s

Fill Mandatory Opportunity Information
    [Arguments]
    ...    ${opport_name}=${OPPORTUNITY_NAME}
    ...    ${stage}=Analyse Prospect
    ...    ${days}=1
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
    Sleep       10s
    Click element       ${ACCOUNT_RELATED}
    Sleep       5s
    Scroll Page To Location         0       500
    Verify That Opportunity Is Saved And Data Is Correct    ${RELATED_OPPORTUNITY}


Scroll Page To Location
    [Arguments]    ${x_location}    ${y_location}
    Execute JavaScript    window.scrollTo(${x_location},${y_location})
    Sleep       10s


Verify That Opportunity Is Saved And Data Is Correct
    [Arguments]     ${element}
    ...             ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    ...             ${days}=1
                    ${date}=    Get Date From Future    ${days}
                    ${oppo_name}=    Set Variable       //*[text()='${OPPORTUNITY_NAME}']
                    ${account_name}=    Set Variable    //*[@title='Account Name']//following-sibling::div//*[text()='${LIGHTNING_TEST_ACCOUNT}']
                    ${oppo_date}=    Set Variable       //*[@title='Close Date']//following-sibling::div//*[text()='${date}']

    Wait Until Page Contains Element   ${element}${oppo_name}       20s
    Run keyword and ignore error        Click element       ${element}${oppo_name}
    Sleep       10s
    Wait Until Page Contains Element    ${oppo_name}        20s
    Wait Until Page Contains Element    ${account_name}     20s
    Wait Until Page Contains Element    ${oppo_date}        20s

Verify That Opportunity Is Found With Search And Go To Opportunity
    [Arguments]     ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    Go to Account        ${OPPORTUNITY_NAME}
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
    Wait Until Element is Visible       ${CONTACTS_TAB}     10s
    Click Element                       ${CONTACTS_TAB}
    Wait Until Page Contains element    ${CONTACTS_ICON}    10S

Create New Master Contact and Validate
    Wait Until Element is Visible       ${NEW_BUTTON}       10s
    Click Element                       ${NEW_BUTTON}
    Wait Until Element is Visible       ${MASTER}           10s
    Click Element                       ${MASTER}
    click Element                       ${NEXT}
    Wait Until Element is Visible       ${CONTACT_INFO}     10s
    Input Text                          xpath=${MASTER_MOBILE_NUM_FIELD}        ${MASTER_MOBILE_NUM_VALUE}
    Input Text                          xpath=${MASTER_FIRST_NAME_FIELD}        ${MASTER_FIRST_NAME_VALUE}
    Input Text                          ${MASTER_LAST_NAME_FIELD}               ${MASTER_LAST_NAME_VALUE}
    Input Text                          ${MASTER_PHONE_NUM_FIELD}               ${MASTER_PHONE_NUM_VALUE}
    Input Text                          ${MASTER_PRIMARY_EMAIL_FIELD}           ${MASTER_PRIMARY_EMAIL_VALUE}
    #Input Text                          ${MASTER_EMAIL_FIELD}                   ${MASTER_EMAIL_VALUE}
    Select from Autopopulate List       ${ACCOUNT_NAME_FIELD}                   ${ACCOUNT_NAME_VALUE}
    Click Element                       ${SAVE_BUTTON}
    Sleep                               10s
    Validate Contact Details            ${CONTACT_DETAILS}

Select from Autopopulate List
    [Arguments]                             ${field}            ${value}
    Input Text                              xpath=${field}          ${value}
    Wait until page contains element        //div[contains(@class,'primaryLabel') and @title='${value}']
    Click Element                           //div[contains(@class,'primaryLabel') and @title='${value}']

Validate Contact Details
    [Arguments]     ${element}
                    ${contact_name}=    Set Variable       //span[text()='Name']//following::span//span[text()='${MASTER_FIRST_NAME_VALUE} ${MASTER_LAST_NAME_VALUE}']
                    ${account_name}=    Set Variable       //span[text()='Account Name']//following::a[text()='${ACCOUNT_NAME_VALUE}']
                    ${mobile_number}=   Set Variable       //span[text()='Mobile']//following::span//span[text()='${MASTER_MOBILE_NUM_VALUE}']
                    ${phone_number}=    Set Variable       //span[text()='Phone']//following::span//span[text()='${MASTER_PHONE_NUM_VALUE}']
                    ${primary_email}=   Set Variable       //span[text()='Primary eMail']//following::a[text()='${MASTER_PRIMARY_EMAIL_VALUE}']
                    #${email}=           Set Variable       //span[text()='Email']//following::a[text()='${MASTER_EMAIL_VALUE}']
    Wait Until Page Contains Element    //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']         10s
    #Click element                       //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    Sleep                               5s
    #Validation
    Wait Until Page Contains Element    ${element}${contact_name}
    Wait Until Page Contains Element    ${element}${account_name}
    Wait Until Page Contains Element    ${element}${mobile_number}
    Wait Until Page Contains Element    ${element}${phone_number}
    Wait Until Page Contains Element    ${element}${primary_email}
    #Wait Until Page Contains Element    ${element}${email}


