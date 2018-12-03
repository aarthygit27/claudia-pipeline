*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}common.robot
Resource            ${PROJECTROOT}${/}resources${/}cpq_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}sales_cons_light_variables.robot

*** Keywords ***

Go To Salesforce
    Go To           ${LOGIN_PAGE}
    Login Page Should Be Open

Login Page Should Be Open
    Wait Until Keyword Succeeds     10 seconds      1 second    Location Should Be      ${LOGIN_PAGE}
    Wait Until Element Is Visible        id=username     10 seconds
    Wait Until Element Is Visible        id=password     10 seconds

Go To Salesforce and Login into Lightning
    [Arguments]     ${user}=DigiSales Lightning User
    Go to Salesforce
    Login To Salesforce Lightning And Close All Tabs      ${user}

Login To Salesforce Lightning And Close All Tabs
    [Arguments]     ${user}=Digisales Lightning User
    Run Keyword     Login to Salesforce as ${user}
    Run Keyword and Ignore Error    Wait For Load
    Close All Tabs
    Reset to Home Tab


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

Go to Account
    [Arguments]    ${target_account}    ${type}=${EMPTY}
    Close All Tabs
    Log     Going to '${target_account}'
    #Wait Until Keyword Succeeds     240s     5s
    Search And Select the Account    ${target_account}     ${type}
    Sleep   10s      The page might load too quickly and it can appear as the search tab would be closed even though it isn't
    #Wait Until Keyword Succeeds   20s   1s   Close Search Tab


#Close Search Tab
#    ${tab_class}=    Set Variable       x-tab-strip-closable setupTab
#    Wait Until Page Contains Element    xpath=${SEARCH_TAB}    20 seconds
#    Close Tab    ${tab_class}  # search tab needs to be closed to avoid multiple matching xpaths of details view
#    Wait Until Page Does Not Contain Element    xpath=${SEARCH_TAB}     2s


Search And Select the Account
    [Arguments]     ${target_account}   ${type}=${EMPTY}
    Search Salesforce    ${target_account}
    #Searched Item Should Be Visible    ${target_account}    ${type}
    Select Account    ${target_account}     ${type}


Search Salesforce
    [Arguments]         ${item}
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}      20s
    Input Text          xpath=${SEARCH_SALESFORCE}      ${item}
    Sleep   5s
    Press Key       xpath=${SEARCH_SALESFORCE}     \\13
    Sleep   10s
    #ENVIRONMENT ISSUE
    #Wait Until Page Contains        //div[@class='listContent']//span[contains(@class,'mruSearchLabel') and contains(@title,'${item}')]
    #Click Element       //div[@class='listContent']//span[contains(@class,'mruSearchLabel') and contains(@title,'${item}')]
    Wait Until Page Contains element        xpath=${TABS_OPENED}//a[contains(@title, 'Search')]     30S
    #wait until page contains element        //*[@class='tabBarItems slds-grid']//a[contains(@title, 'Search')]
    #Press Enter On     phSearchInput    # At least in Firefox version 52.0 enter needs to be pressed or the search won't happen
    #Click Element       id=phSearchClearButton

Select Account
    [Arguments]         ${account_name}     ${type}
    Wait Until Page Contains element    ${TABLE_HEADER}[@title='${account_name}']
    Click Element       ${TABLE_HEADER}[@title='${account_name}']
    Sleep   10s
    Account Should Be Open    ${account_name}
    #   To close the search tab

Account Should Be Open
    [Arguments]         ${account_name}
    ${Count}=    get element count    ${TABS_OPENED}
    Run Keyword If  ${Count} > 1  Click Element     xpath=${TABS_OPENED}//[contains(@class,'tabItem') and @title='${account_name}']
    #Wait Until Page Contains Element        xpath=${TABS_OPENED}//[contains(@class,'tabItem') and @title='${account_name}']      60 seconds

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
    #Click Element   xpath=//a[@title='${type}']
    Run Keyword If       ${status}     Run Keyword With Delay      0.5s    Click Element   xpath=//a[@title='${type}']
    #Run Keyword Unless   ${status}      Click New Item For Account From Dropdown    ${type}
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
    #Wait Until Element Is Visible   ${SUCCESS_MESSAGE}     60 s
    Sleep       10s
    Click element       ${ACCOUNT_RELATED}
    Sleep       5s
    Scroll Page To Location         0       500
    Verify That Opportunity Is Saved And Data Is Correct    ${RELATED_OPPORTUNITY}

Verify That Opportunity Is Saved And Data Is Correct
    [Arguments]     ${element}
    ...             ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    ...             ${days}=1
                    ${date}=    Get Date From Future    ${days}
                    ${oppo_name}=    Set Variable       //*[text()='${OPPORTUNITY_NAME}']
                    ${account_name}=    Set Variable    //*[@title='Account Name']//following-sibling::div//*[text()='${LIGHTNING_TEST_ACCOUNT}']
                    ${oppo_date}=    Set Variable       //*[@title='Close Date']//following-sibling::div//*[text()='${date}']

    Wait Until Page Contains Element   ${element}${oppo_name}
    Click element       ${element}${oppo_name}
    Sleep       10s
    Wait Until Page Contains Element    ${element}${oppo_name}
    Wait Until Page Contains Element    ${account_name}
    #Wait Until Page Contains Element    ${oppo_date}
    Close All Tabs


Scroll Page To Location
    [Arguments]    ${x_location}    ${y_location}
    Execute JavaScript    window.scrollTo(${x_location},${y_location})
    Sleep       10s

Close All Tabs
    ${original}=    Get Element Count    xpath=${TABS_OPENED}//div[contains(@class,'close')]
    :FOR    ${i}    IN RANGE    ${original}
    \   Run Keyword and Ignore Error    Close Tab
    ${current}=   Get Element Count    xpath=${TABS_OPENED}//div[contains(@class,'close')]
    ${closed}=      Evaluate        ${original}-${current}
    Log             Closed ${closed} tabs
    Should Be Equal As Integers     ${current}    0

Close Tab
    Click Element   xpath=${TABS_OPENED}//div[contains(@class,'close')]

Verify That Opportunity Is Found With Search And Go To Opportunity
    [Arguments]     ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    Close All Tabs
    Go to Account        ${OPPORTUNITY_NAME}
    Wait until Page Contains Element    ${OPPORTUNITYNAME_TAB}//*[text()='${OPPORTUNITY_NAME}']     15s
    Verify That Opportunity Is Saved And Data Is Correct    ${OPPORTUNITYNAME_TAB}


Verify That Opportunity is Found From My All Open Opportunities
    [Arguments]     ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    ...             ${days}=1
                    ${date}=    Get Date From Future    ${days}
                    ${oppo_name}=    Set Variable       //*[text()='${OPPORTUNITY_NAME}']
                    ${account_name}=    Set Variable    //*[@title='Account Name']//following-sibling::div//*[text()='${LIGHTNING_TEST_ACCOUNT}']
                    ${oppo_date}=    Set Variable       //*[@title='Close Date']//following-sibling::div//*[text()='${date}']
    Close All Tabs
    Open Opportunities
    Select Correct View Type    My All Open Opportunities
    Filter Opportunities By     Opportunity Name    ${OPPORTUNITY_NAME}
    #Click element       ${RELATED_OPPORTUNITY}${oppo_name}
    Sleep       10s
    Wait Until Page Contains Element    ${OPPORTUNITYNAME_TAB}${oppo_name}
    Wait Until Page Contains Element    ${account_name}
    #Wait Until Page Contains Element    ${oppo_date}
    Close All Tabs


Open Opportunities
    [Arguments]     ${timeout}=20 seconds
    Close All Tabs
    Select Correct Tab Type     ${OPPORTUNITIES}
    Wait Until Page Contains Element    ${OPPORTUNITIES_SECTION}    ${timeout}
    Sleep       10s

Reset to Home Tab
    [Arguments]     ${timeout}=20 seconds
    Close All Tabs
    Sleep       10s
    Select Correct Tab Type     ${HOME}
    Sleep       10s

Select Correct Tab Type
    [Arguments]         ${tab}
    Wait Until Element is Visible       ${SALES_CONSOLE_MENU}       20 seconds
    Click Element     ${SALES_CONSOLE_MENU}
    ${CreateButtonVisible} =    Page Should Contain Element    ${tab}
    Run Keyword If      ${CreateButtonVisible} == 'FAIL'    Click Element     ${SALES_CONSOLE_MENU}
    Click Element               ${tab}
    Sleep       5s


Select Correct View Type
    [Arguments]         ${type}
    Click Element       //a[@title='Select List View']
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
    Wait Until Element is Visible       ${SALES_CONSOLE_MENU}       20 seconds
    Click Element                       ${SALES_CONSOLE_MENU}
    Wait Until Element is Visible           ${CONTACTS}                 20 seconds
    Click Element           ${CONTACTS}
    Close All Tabs
    #Wait Until Page Contains element        xpath=${TABS_OPENED}//a[contains(@title, 'Contacts)]     30S

Create New Master Contact and Validate
    Sleep       10s
    Click Element                           ${NEW_CONTACT}
    Wait Until Element is Visible           //span[text()='Master']    20s
    Click Element                           //span[text()='Master']
    click element                           //span[text()='Next']
    Wait Until Element is Visible           ${CONTACT_INFO}               20 seconds
    Input Text              xpath=${MOBILE_NUM}         ${CONTACT_MOBILE}
    Input Text              xpath=${FIRST_NAME}         ${CONTACT_FIRSTNAME}
    Input Text              xpath=${LAST_NAME}          ${CONTACT_LASTNAME}
    Select from Autopopulate List       ${ACCOUNT_NAME}         ${CONTACT_ACCOUNTNAME}
    Input Text              xpath=${PRIMARY_EMAIL}          ${CONTACT_EMAIL}
    Click Element                           ${SAVE_BUTTON}
    Sleep       10s
    Validate Contact Details    ${CONTACT_DETAILS}

Select from Autopopulate List
    [Arguments]         ${field}            ${value}
    Input Text              xpath=${field}          ${value}
    #${split} =	Fetch from Left	    ${value}        ${SPACE}
    Wait until page contains element  //div[contains(@class,'primaryLabel') and @title='${value}']
    Click Element           //div[contains(@class,'primaryLabel') and @title='${value}']


Validate Contact Details
    [Arguments]     ${element}
                    ${contact_name}=    Set Variable       //span[text()='Name']//following::span//span[text()='${CONTACT_FIRSTNAME} ${CONTACT_LASTNAME}']
                    ${account_name}=    Set Variable       //span[text()='Account Name']//following::a[text()='${CONTACT_ACCOUNTNAME}']
                    ${mobile_number}=    Set Variable      //span[text()='Mobile']//following::span//span[text()='${CONTACT_MOBILE}']
                    ${email}=    Set Variable      //span[text()='Primary eMail']//following::a[text()='${CONTACT_EMAIL}']
    Wait Until Page Contains Element            //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']         20s
    Click element           //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    Sleep       10s
    Wait Until Page Contains Element   ${element}${contact_name}
    Wait Until Page Contains Element    ${element}${account_name}
    Wait Until Page Contains Element    ${element}${mobile_number}
    Wait Until Page Contains Element    ${element}${email}
    Close All Tabs

Create New NP Contact and Validate
    Sleep       10s
    Click Element                           ${NEW_CONTACT}
    Wait Until Element is Visible           //span[text()='Non-person']    20s
    Click Element                           //span[text()='Non-person']
    click element                           //span[text()='Next']
    Wait Until Element is Visible           ${CONTACT_INFO}               20 seconds
    Input Text              xpath=${MOBILE_NUM}         ${NP_CONTACT_MOBILE}
    Input Text              xpath=${FIRST_NAME}         ${NP_CONTACT_FIRSTNAME}
    Input Text              xpath=${LAST_NAME}          ${NP_CONTACT_LASTNAME}
    Select from Autopopulate List       ${ACCOUNT_NAME}         ${NP_CONTACT_ACCOUNTNAME}
    Input Text              xpath=${PRIMARY_EMAIL}          ${NP_CONTACT_EMAIL}
    Click Element                           ${SAVE_BUTTON}
    Sleep       10s
    Validate NP Contact Details    ${CONTACT_DETAILS}

Validate NP Contact Details
    [Arguments]     ${element}
                    ${contact_name}=    Set Variable       //span[text()='Name']//following::span//span[text()='Non-person ${NP_CONTACT_FIRSTNAME} ${NP_CONTACT_LASTNAME}']
                    ${account_name}=    Set Variable       //span[text()='Account Name']//following::a[text()='${NP_CONTACT_ACCOUNTNAME}']
                    ${mobile_number}=    Set Variable      //span[text()='Mobile']//following::span//span[text()='${NP_CONTACT_MOBILE}']
                    ${email}=    Set Variable      //span[text()='Email']//following::a[text()='${NP_CONTACT_EMAIL}']
    Wait Until Page Contains Element            //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']         20s
    Click element           //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    Sleep       10s
    Wait Until Page Contains Element   ${element}${contact_name}
    Wait Until Page Contains Element    ${element}${account_name}
    Wait Until Page Contains Element    ${element}${mobile_number}
    Wait Until Page Contains Element    ${element}${email}
    Close All Tabs
