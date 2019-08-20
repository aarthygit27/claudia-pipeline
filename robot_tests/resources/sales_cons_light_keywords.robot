*** Settings ***
Library           Collections
Resource          ..${/}resources${/}common.robot
Resource          ..${/}resources${/}cpq_keywords.robot
Resource          ..${/}resources${/}sales_cons_light_variables.robot

*** Keywords ***
Go To Salesforce
    Go To    ${LOGIN_PAGE}
    Login Page Should Be Open

Login Page Should Be Open
    Wait Until Keyword Succeeds    10 seconds    1 second    Location Should Be    ${LOGIN_PAGE}
    Wait Until Element Is Visible    id=username    10 seconds
    Wait Until Element Is Visible    id=password    10 seconds

Go To Salesforce and Login into Lightning
    [Arguments]    ${user}=DigiSales Lightning User
    Go to Salesforce
    Login To Salesforce Lightning And Close All Tabs    ${user}

Login To Salesforce Lightning And Close All Tabs
    [Arguments]    ${user}=Digisales Lightning User
    Run Keyword    Login to Salesforce as ${user}
    Sleep    5s
    #Run Keyword and Ignore Error    Wait For Load
    Go to Lightning Sales Console
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   ${TABS_OPENED}
    Run Keyword If    ${present}    Close All Tabs
    Sleep    5s
    Reset to Home Tab

Login to Salesforce as DigiSales Lightning User
    Login To Salesforce Lightning    ${B2B_DIGISALES_LIGHT_USER}    ${PASSWORDCONSOLE}

Login to Salesforce Lightning
    [Arguments]    ${username}=${B2B_DIGISALES_LIGHT_USER}    ${password}=${PASSWORD}
    Wait Until Page Contains Element    id=username     240s
    Input Text    id=username    ${username}
    Sleep       5s
    Input Password    id=password    ${password}
    Force click element        //input[@id='Login']
    Sleep    60s
    run keyword and ignore error    Check For Lightning Force
    Wait Until Page Contains Element    xpath=${LIGHTNING_ICON}    120 seconds

Check For Lightning Force
    Sleep    15s
    ${url}=    Get Location
    ${contains}=    Evaluate    'lightning' in '${url}'
    Run Keyword Unless    ${contains}    Switch to Lightning

Switch to Lightning
    Sleep    15s
    Click Element    xpath=${CLASSIC_MENU}
    Page Should Contain Element    xpath=${SWITCH_TO_LIGHTNING}    30s
    Click Element    xpath=${SWITCH_TO_LIGHTNING}

Go to Account
    [Arguments]    ${target_account}    ${type}=${EMPTY}
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   ${TABS_OPENED}
    Run Keyword If    ${present}    Close All Tabs
    Log    Going to '${target_account}'
    #Wait Until Keyword Succeeds    240s    5s
    Search And Select the Account    ${target_account}    ${type}
    Sleep    10s    The page might load too quickly and it can appear as the search tab would be closed even though it isn't
    #Wait Until Keyword Succeeds    20s    1s    Close Search Tab
    #Close Search Tab
    #    ${tab_class}=    Set Variable    x-tab-strip-closable setupTab
    #    Wait Until Page Contains Element    xpath=${SEARCH_TAB}    20 seconds
    #    Close Tab    ${tab_class}    # search tab needs to be closed to avoid multiple matching xpaths of details view
    #    Wait Until Page Does Not Contain Element    xpath=${SEARCH_TAB}    2s

Search And Select the Account
    [Arguments]    ${target_account}    ${type}=${EMPTY}
    Search Salesforce    ${target_account}
    #Searched Item Should Be Visible    ${target_account}    ${type}
    Select Account    ${target_account}    ${type}

Search Salesforce
    [Arguments]    ${item}
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    20s
    Input Text    ${SEARCH_SALESFORCE}    ${item}
    Sleep    15s
    Press Enter On  ${SEARCH_SALESFORCE}
    Sleep    10s
    ${IsVisible}=   Run Keyword And Return Status    Element Should Be Visible   ${TABS_OPENED}//a[contains(@title, 'Search')]  20s
    run keyword unless  ${IsVisible}        Search Salesforce      ${item}
    Wait Until Page Contains element    xpath=${TABS_OPENED}//a[contains(@title, 'Search')]    30S

Select Account
    [Arguments]    ${account_name}    ${type}
    Wait Until Page Contains element        //div[@data-aura-class='forceSearchResultsRegion']//div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//a[@title='${account_name}']    30s
    Click Element    //div[@data-aura-class='forceSearchResultsRegion']//div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//a[@title='${account_name}']
    Sleep    10s
    Account Should Be Open    ${account_name}
    #    To close the search tab

Account Should Be Open
    [Arguments]    ${account_name}
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   ${TABS_OPENED}//[contains(@class,'tabItem') and @title='${account_name}']
    Run Keyword If    ${present}    Click specific element      ${TABS_OPENED}//[contains(@class,'tabItem') and @title='${account_name}']
    #${Count}=    get element count    ${TABS_OPENED}
    #Run Keyword If    ${Count} > 1    Click Element    xpath=${TABS_OPENED}//[contains(@class,'tabItem') and @title='${account_name}']
    #Wait Until Page Contains Element    xpath=${TABS_OPENED}//[contains(@class,'tabItem') and @title='${account_name}']    60 seconds

Create New Opportunity For Customer
    [Arguments]    ${stage}=Analyse Prospect    ${days}=1    ${expect_error}=${FALSE}    #${opport_name}=${EMPTY}
    Click New Item For Account    New Opportunity
    Fill Mandatory Opportunity Information    ${stage}    ${days}
    Fill Mandatory Classification
    Click Save Button
    #Run Keyword Unless      ${expect_error}     Verify That Opportunity Creation Succeeded

Click New Item For Account
    [Arguments]    ${type}
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    //a[@title='${type}']
    #Click Element    xpath=//a[@title='${type}']
    Run Keyword If    ${status}    Run Keyword With Delay    0.5s    Click Element    xpath=//a[@title='${type}']
    #Run Keyword Unless    ${status}    Click New Item For Account From Dropdown    ${type}
    Wait Until Page Contains Element    ${NEW_ITEM_POPUP}    30s

Fill Mandatory Opportunity Information
    [Arguments]    ${stage}=Analyse Prospect    ${days}=1
    ${opport_name}=    Run Keyword    Create Unique Name    TestOpportunity
    Set Test Variable    ${OPPORTUNITY_NAME}    ${opport_name}
    ${date}=    Get Date From Future    ${days}
    Set Test Variable    ${OPPORTUNITY_CLOSE_DATE}    ${date}
    Input Quick Action Value For Attribute    Opportunity Name    ${OPPORTUNITY_NAME}
    Select Quick Action Value For Attribute    Stage    ${stage}
    Input Quick Action Value For Attribute    Close Date    ${OPPORTUNITY_CLOSE_DATE}

Input Quick Action Value For Attribute
    [Arguments]    ${field}    ${value}
    Wait Until Element Is Visible    ${NEW_ITEM_POPUP}//label//*[contains(text(),'${field}')]    20s
    Input Text    xpath=${NEW_ITEM_POPUP}//label//*[contains(text(),'${field}')]//following::input    ${value}

Select Quick Action Value For Attribute
    [Arguments]     ${field}    ${value}
    Wait Until Element Is Visible    ${NEW_ITEM_POPUP}//span[contains(text(),'${field}')]//following::div//a[@class='select']   20s
    #Click Element       ${NEW_ITEM_POPUP}//span[contains(text(),'${field}')]//following::div//a[@class='select']
    #Wait Until Element Is Visible    //div[@class='select-options']//li//a[contains(text(),'${value}')]
    #Click Element       //div[@class='select-options']//li//a[contains(text(),'${value}')]
    Select option from Dropdown with Force Click Element    ${NEW_ITEM_POPUP}//span[contains(text(),'${field}')]//following::div//a[@class='select']    //div[@class='select-options']//li//a[contains(text(),'${value}')]


Fill Mandatory Classification
    [Arguments]    ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    Set Test Variable    ${OPPO_DESCRIPTION}     Test Automation opportunity description
    Input Text       xpath=//label//span[contains(text(),'Description')]//following::textarea    ${OPPO_DESCRIPTION}

Click Save Button
    Click Element       ${SAVE_OPPORTUNITY}


Scroll Page To Element
    [Arguments]    ${element}
    #Run Keyword Unless       ${status}          Execsute JavaScript          window.scrollTo(0,100)
    :FOR    ${i}    IN RANGE    99999
    \    ${status}=      Run Keyword And Return Status      Element Should Be Visible     ${element}
    \    Execute JavaScript          window.scrollTo(0,${i}*100)
    \    Sleep   3s
    \    Exit For Loop If       ${status}


#Verify That Opportunity Is Saved And Data Is Correct
#    [Arguments]     ${element}
#    ...             ${account_name}=${LIGHTNING_TEST_ACCOUNT}
#    ...             ${days}=1
#                    ${date}=    Get Date From Future    ${days}
#                    ${oppo_name}=    Set Variable       //*[@title='${OPPORTUNITY_NAME}']
#                    ${account_name}=    Set Variable    //*[@title='Account Name']//following-sibling::div//*[text()='${LIGHTNING_TEST_ACCOUNT}']
#                    ${oppo_date}=    Set Variable       //*[@title='Close Date']//following-sibling::div//*[text()='${date}']
#    #Run Keyword     Scroll Page To Element              ${element}${oppo_name}
#    Sleep       30s
#    element should be visible       //table[contains(@class,'uiVirtualDataTable')]//tbody//tr//a[@title='${OPPORTUNITY_NAME}']
#    Wait Until Page Contains Element   //table[contains(@class,'uiVirtualDataTable')]//tbody//tr//a[@title='${OPPORTUNITY_NAME}']      30s
#    force click element        //table[contains(@class,'uiVirtualDataTable')]//tbody//tr//a[@title='${OPPORTUNITY_NAME}']
#    #Force click element       ${element}${oppo_name}
#    Sleep       10s
#    Wait Until Page Contains Element    ${element}${oppo_name}      20s
#    Wait Until Page Contains Element    ${account_name}             20s
#    #Wait Until Page Contains Element    ${oppo_date}
#    Close All Tabs

Verify That Opportunity Is Saved And Data Is Correct
    [Arguments]    ${element}    ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    ${oppo_name}=    Set Variable    //*[text()='${OPPORTUNITY_NAME}']
    ${account_name}=    Set Variable    //*[@title='Account Name']//following-sibling::div//*[text()='${LIGHTNING_TEST_ACCOUNT}']
    ${oppo_date}=    Set Variable    //*[@title='Close Date']//following-sibling::div//*[text()='${OPPORTUNITY_CLOSE_DATE}']
    sleep    10s
    Wait Until Page Contains Element    ${element}${oppo_name}    60s
    Run keyword and ignore error    Click element    ${element}${oppo_name}
    Sleep    10s
    Wait Until Page Contains Element    ${oppo_name}    60s
    Wait Until Page Contains Element    ${account_name}    60s
    Wait Until Page Contains Element    ${oppo_date}    60s

Scroll Page To Location
    [Arguments]    ${x_location}    ${y_location}
    Execute JavaScript    window.scrollTo(${x_location},${y_location})

Close All Tabs
    #${original}=    run keyword     Get Element Count    xpath=${TABS_OPENED}//div[contains(@class,'close')]
    #:FOR    ${i}    IN RANGE    ${original}
    #\   Run Keyword and Ignore Error    Close Tab
    #${current}=   run keyword       Get Element Count    xpath=${TABS_OPENED}//div[contains(@class,'close')]
    #${closed}=      Evaluate        ${original}-${current}
    #Log             Closed ${closed} tabs
    #Should Be Equal As Integers     ${current}    0
    @{locators}=     Get Webelements    xpath=${TABS_OPENED}//div[contains(@class,'close')]
    ${original}=       Create List
    :FOR   ${locator}   IN    @{locators}
    \       Run Keyword and Ignore Error    Close Tab

Close Tab
    ${visible}=     run keyword and return status   element should be visible  ${TABS_OPENED}//div[contains(@class,'close')]
    run keyword if  ${visible}
    ...     Click Element   xpath=${TABS_OPENED}//div[contains(@class,'close')]

Verify That Opportunity Is Found With Search And Go To Opportunity
    [Arguments]     ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   ${TABS_OPENED}
    Run Keyword If    ${present}    Close All Tabs
    Go to Account        ${OPPORTUNITY_NAME}
    Wait until Page Contains Element    ${OPPORTUNITYNAME_TAB}//*[text()='${OPPORTUNITY_NAME}']     30s
    Verify That Opportunity Is Saved And Data Is Correct    ${OPPORTUNITYNAME_TAB}


Verify That Opportunity is Found From My All Open Opportunities
    [Arguments]     ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    ...             ${days}=1
                    ${date}=    Get Date From Future    ${days}
                    ${oppo_name}=    Set Variable       //*[text()='${OPPORTUNITY_NAME}']
                    ${account_name}=    Set Variable    //*[@title='Account Name']//following-sibling::div//*[text()='${LIGHTNING_TEST_ACCOUNT}']
                    ${oppo_date}=    Set Variable       //*[@title='Close Date']//following-sibling::div//*[text()='${date}']
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   ${TABS_OPENED}
    Run Keyword If    ${present}    Close All Tabs
    Open Opportunities
    Select Correct View Type    My All Open Opportunities
    Filter Opportunities By     Opportunity Name    ${OPPORTUNITY_NAME}
    #Click element       ${RELATED_OPPORTUNITY}${oppo_name}
    Sleep       10s
    Wait Until Page Contains Element    ${OPPORTUNITYNAME_TAB}${oppo_name}      240s
    Wait Until Page Contains Element    ${account_name}     240s
    #Wait Until Page Contains Element    ${oppo_date}
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   ${TABS_OPENED}
    Run Keyword If    ${present}    Close All Tabs


Open Opportunities
    [Arguments]     ${timeout}=20 seconds
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   ${TABS_OPENED}
    Run Keyword If    ${present}    Close All Tabs
    Select Correct Tab Type     ${OPPORTUNITIES}
    Wait Until Page Contains Element    ${OPPORTUNITIES_SECTION}    ${timeout}
    Sleep       10s

Reset to Home Tab
    [Arguments]     ${timeout}=20 seconds
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   ${TABS_OPENED}
    Run Keyword If    ${present}    Close All Tabs
    Sleep       5s
    Select Correct Tab Type     ${HOME}
    Sleep       5s

Select Correct Tab Type
    [Arguments]         ${tab}
    Wait Until Element is Visible       ${SALES_CONSOLE_MENU}       20 seconds
    Sleep   5s
    force click element     ${SALES_CONSOLE_MENU}
    #Click Element     ${SALES_CONSOLE_MENU}
    ${CreateButtonVisible} =    Run Keyword And Return Status      Element Should Be Visible    ${tab}
    run keyword if      ${CreateButtonVisible}=='FAIL'    Click Element     ${SALES_CONSOLE_MENU}
    Sleep       3s
    Click Element               ${tab}
    Sleep       5s


Select Correct View Type
    [Arguments]         ${type}
    #Click Element       //a[@title='Select List View']
    #Wait Until Page Contains Element        //span[@class=' virtualAutocompleteOptionText' and text()='${type}']      30s
    #Click Element       //span[@class=' virtualAutocompleteOptionText' and text()='${type}']//parent::a
    Select option from Dropdown with Force Click Element        //a[@title='Select List View']           //span[@class=' virtualAutocompleteOptionText' and text()='${type}']//parent::a
    Sleep       5s

Filter Opportunities By
    [Arguments]     ${field}    ${value}
    #${Count}=    get element count    ${RESULTS_TABLE}
    Click Element      //input[contains(@name,'search-input')]
    Wait Until Page Contains Element        ${SEARCH_INPUT}     20s
    Input Text          xpath=${SEARCH_INPUT}      ${value}
    Press Key       xpath=${SEARCH_INPUT}     \\13
    Sleep   5s
    Force click element     ${RESULTS_TABLE}[contains(@class,'forceOutputLookup') and (@title='${value}')]
    #${present}=  Run Keyword And Return Status    Element Should Be Visible   ${RESULTS_TABLE}[contains(@class,'forceOutputLookup') and (@title='${value}')]
    #Run Keyword If    ${present}    Click specific element      ${RESULTS_TABLE}[contains(@class,'forceOutputLookup') and (@title='${value}')]

Click specific element
    [Arguments]     ${element}
    @{locators}=     Get Webelements    xpath=${element}
    ${original}=       Create List
    :FOR   ${locator}  IN    @{locators}
    Click Element     xpath=${element}

Go to Contacts
    Go to Sales Console
    Wait Until Element is Visible       ${CONTACTS}                 20 seconds
    Click Element                       ${CONTACTS}
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   ${TABS_OPENED}
    Run Keyword If    ${present}    Close All Tabs
    #Wait Until Page Contains element        xpath=${TABS_OPENED}//a[contains(@title, 'Contacts)]     30S

Go to Sales Console
    Wait Until Element is Visible       ${SALES_CONSOLE_MENU}       20 seconds
    Click Element                       ${SALES_CONSOLE_MENU}

Create New Master Contact and Validate
    Sleep       10s
    Click Element                           ${NEW_CONTACT}
    Click Visible Element                   //span[text()='Master']
    Click element                           //span[text()='Next']
    Wait Until Element is Visible           ${CONTACT_INFO}               20 seconds
    ${first_name}=  Run Keyword     Create Unique Name          ${EMPTY}
    ${email_id}=    Run Keyword     Create Unique Email         ${DEFAULT_EMAIL}
    Set Test Variable    ${CONTACT_FIRST_NAME}       Master ${first_name}
    Set Test Variable    ${CONTACT_LAST_NAME}        Test ${first_name}
    Set Test Variable    ${CONTACT_PRIMARY_EMAIL}    ${email_id}
    Input Text           ${MOBILE_NUM}         ${CONTACT_MOBILE}
    Input Text           ${FIRST_NAME_FIELD}         ${CONTACT_FIRST_NAME}
    Input Text           ${LAST_NAME_FIELD}          ${CONTACT_LAST_NAME}
    Select from Autopopulate List       ${ACCOUNT_NAME}         ${CONTACT_ACCOUNTNAME}
    sleep  10s
    Input Text              xpath=${PRIMARY_EMAIL}          ${CONTACT_PRIMARY_EMAIL}
    Click Element                           ${SAVE_BUTTON}
    Sleep       10s
    Validate Contact Details    ${CONTACT_DETAILS}

Select from Autopopulate List
    [Arguments]                     ${field}            ${value}
    Input Text                      xpath=${field}          ${value}
    Sleep  10s
    Press Enter On   ${field}
    Click Visible Element   //div[contains(@class,'primaryLabel')]//following::*[@title='${value}']
    Sleep    2s
    #${split} =	Fetch from Left	    ${value}        ${SPACE}
    #Wait until page contains element  //div[contains(@class,'primaryLabel') and @title='${value}']      60s
    #Click Element                   //div[contains(@class,'primaryLabel') and @title='${value}']


Validate Contact Details
    [Arguments]     ${element}
                    ${contact_name}=    Set Variable       //span[text()='Name']//following::span//span[text()='${CONTACT_FIRST_NAME} ${CONTACT_LAST_NAME}']
                    ${account_name}=    Set Variable       //span[text()='Account Name']//following::a[text()='${CONTACT_ACCOUNTNAME}']
                    ${mobile_number}=   Set Variable       //span[text()='Mobile']//following::span//span[text()='${CONTACT_MOBILE}']
                    ${email}=    Set Variable               //span[text()='Primary eMail']//following::a[text()='${CONTACT_PRIMARY_EMAIL}']
    Click Visible Element       //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    #Wait Until Page Contains Element    //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']         20s
    #Click element                       //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    Sleep                               5s
    Wait Until Page Contains Element    ${element}${contact_name}           240s
    Wait Until Page Contains Element    ${element}${account_name}       240s
    Wait Until Page Contains Element    ${element}${mobile_number}      240s
    Wait Until Page Contains Element    ${element}${email}      240s
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   ${TABS_OPENED}
    Run Keyword If    ${present}    Close All Tabs

Create New NP Contact and Validate
    Sleep                                   10s
    Click Element                           ${NEW_CONTACT}
    Click Visible Element                   //span[text()='Non-person']
    click element                           //span[text()='Next']
    Wait Until Element is Visible           ${CONTACT_INFO}                 20 seconds
    ${first_name}=  Run Keyword     Create Unique Name          ${EMPTY}
    ${email_id}=    Run Keyword     Create Unique Email         ${DEFAULT_EMAIL}
    Set Test Variable    ${NP_CONTACT_FIRSTNAME}       NP ${first_name}
    Set Test Variable    ${NP_CONTACT_LASTNAME}        Test ${first_name}
    Set Test Variable    ${NP_CONTACT_EMAIL}           ${email_id}
    Input Text                              ${MOBILE_NUM}             ${NP_CONTACT_MOBILE}
    Input Text                              ${FIRST_NAME_FIELD}       ${NP_CONTACT_FIRSTNAME}
    Input Text                              ${LAST_NAME_FIELD}        ${NP_CONTACT_LASTNAME}
    Select from Autopopulate List           ${ACCOUNT_NAME}           ${NP_CONTACT_ACCOUNTNAME}
    Input Text                              ${PRIMARY_EMAIL}          ${NP_CONTACT_EMAIL}
    sleep  10s
    Click Element                           ${SAVE_BUTTON}
    Sleep                                   10s
    Validate NP Contact Details             ${CONTACT_DETAILS}

Validate NP Contact Details
    [Arguments]     ${element}
                    ${contact_name}=    Set Variable       //span[text()='Name']//following::span//span[text()='Non-person ${NP_CONTACT_FIRSTNAME} ${NP_CONTACT_LASTNAME}']
                    ${account_name}=    Set Variable       //span[text()='Account Name']//following::a[text()='${NP_CONTACT_ACCOUNTNAME}']
                    ${mobile_number}=    Set Variable      //span[text()='Mobile']//following::span//span[text()='${NP_CONTACT_MOBILE}']
                    ${email}=    Set Variable      //span[text()='Email']//following::a[text()='${NP_CONTACT_EMAIL}']
    Wait Until Page Contains Element            //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']         20s
    Click element           //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    Sleep                   10s
    Wait Until Page Contains Element    ${element}${contact_name}       240s
    Wait Until Page Contains Element    ${element}${account_name}       240s
    Wait Until Page Contains Element    ${element}${mobile_number}      240s
    Wait Until Page Contains Element    ${element}${email}      240s
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   ${TABS_OPENED}
    Run Keyword If    ${present}    Close All Tabs


Create New Contact for Account and Validate
    click element           ${AP_NEW_CONTACT}
    sleep                   2s
    Input Text              ${AP_MOBILE_NUM}         ${AP_CONTACT_MOBILE}
    ${first_name}=  Run Keyword     Create Unique Name          ${EMPTY}
    ${email_id}=    Run Keyword     Create Unique Email         ${DEFAULT_EMAIL}
    Set Test Variable    ${AP_CONTACT_FIRSTNAME}        AP ${first_name}
    Set Test Variable    ${AP_CONTACT_LASTNAME}         Test ${first_name}
    Set Test Variable    ${AP_CONTACT_EMAIL}            ${email_id}
    Input Text              ${FIRST_NAME_FIELD}         ${AP_CONTACT_FIRSTNAME}
    Input Text              ${LAST_NAME_FIELD}          ${AP_CONTACT_LASTNAME}
    Input Text              ${PRIMARY_EMAIL}            ${AP_CONTACT_EMAIL}
    Click Element           ${AP_SAVE_BUTTON}
    Sleep                   2s
    Validate AP Contact Details    ${CONTACT_DETAILS}

Validate AP Contact Details
    Reset to Home Tab
    #Go to Contacts
    Go To Account   ${AP_CONTACT_FIRSTNAME} ${AP_CONTACT_LASTNAME}  ${SEARCH_SALESFORCE}
    [Arguments]     ${element}
                    ${contact_name}=        Set Variable        //span[text()='Name']//following::span//span[text()='${AP_CONTACT_FIRSTNAME} ${AP_CONTACT_LASTNAME}']
                    ${account_name}=        Set Variable        //span[text()='Account Name']//following::a[text()='${AP_CONTACT_ACCOUNTNAME}']
                    ${mobile_number}=       Set Variable        //span[text()='Mobile']//following::span//span[text()='${AP_CONTACT_MOBILE}']
                    ${email}=               Set Variable        //span[text()='Primary eMail']//following::a[text()='${AP_CONTACT_EMAIL}']
    Wait Until Page Contains Element        //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']         20s
    Sleep       5s
    Force click element                     //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    Sleep       15s
    Force click element                     //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    Sleep       5s
    Wait Until Page Contains Element    ${element}${contact_name}       240s
    Wait Until Page Contains Element    ${element}${account_name}       240s
    Wait Until Page Contains Element    ${element}${mobile_number}      240s
    Wait Until Page Contains Element    ${element}${email}      240s
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   ${TABS_OPENED}
    Run Keyword If    ${present}    Close All Tabs

Go to Lightning Sales Console
    ${IsElementVisible}=  Run Keyword And Return Status    Element Should Be Visible   ${SALES_APP_NAME}  20s
    run keyword unless  ${IsElementVisible}  Switch to Lightning Sales Console

Switch to Lightning Sales Console
    wait until page contains element        ${APP_LAUNCHER}             15s
    click element                           ${APP_LAUNCHER}
    wait until page contains element        ${SALES_CONSOLE_LINK}       15s
    click element                           ${SALES_CONSOLE_LINK}
    wait until element is visible           ${SALES_APP_NAME}           15s

Force click element
    [Arguments]  ${elementToClick}
    ${element_xpath}=       Replace String      ${elementToClick}        \"  \\\"
    Execute JavaScript  document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep  2s

Select option from Dropdown with Force Click Element
    [Arguments]             ${list}        ${item}
    #Select From List By Value    //div[@class="uiInput uiInput--default"]//a[@class="select"]   ${item}
    ${element_xpath}=       Replace String      ${list}        \"  \\\"
    Execute JavaScript  document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep  2s
    Force click element  ${item}
