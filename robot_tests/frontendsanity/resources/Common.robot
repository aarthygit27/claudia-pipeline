*** Settings ***
Library           SeleniumLibrary
Library           String
Library           Dialogs
Library           Screenshot
Library           DateTime
Library           Collections
Library           OperatingSystem
Resource          ../../frontendsanity/resources/Variables.robot

*** Keywords ***
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

Reset to Home
    [Arguments]    ${timeout}=60s
    Wait Until Element is Visible    ${SALES_APP_HOME}    60s
    Click Element    ${SALES_APP_HOME}
    Sleep    10s

Force click element
    [Arguments]    ${elementToClick}
    ${element_xpath}=    Replace String    ${elementToClick}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep    2s

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

Press Enter On
    [Arguments]    ${locator}
    Press Key    ${locator}    \\13

Open Browser And Go To Login Page
    [Arguments]    ${page}=${LOGIN_PAGE_APP}
    Open Browser    ${page}    ${BROWSER}
    Maximize Browser Window
    log to console    browser open

Logout From All Systems
    [Documentation]    General logout keyword for test teardowns
    ${salesforce_open}=    Run Keyword And Return Status    Location Should Contain    salesforce.com
    Run Keyword If    ${salesforce_open}    Run Keyword and Ignore Error    Close Tabs And Logout    # Salesforce
    ${mube_open}=    Run Keyword And Return Status    Location Should Contain    replicator-mnt.stadi.sonera.fi/
    Run Keyword If    ${mube_open}    Run Keyword and Ignore Error    MUBE Logout CRM    # MultiBella

Logout From All Systems and Close Browser
    Logout From All Systems
    Close Browser

Verify That Record Contains Attribute
    [Arguments]    ${attribute}
    Wait Until Page Contains Element    //span[contains(@class,'test-id__field-label') and (text()='${attribute}')]    240s    10s

Wait element to load and click
    [Arguments]    ${element}
    ${status}=    Run Keyword and return status    Wait until page contains element    ${element}    30s
    Run Keyword If    ${status} == False    Execute Javascript    window.location.reload(false);
    Run Keyword If    ${status} == False    Wait until page contains element    ${element}    30s
    Wait until keyword succeeds    30s    2s    Click Element    ${element}

Select from Autopopulate List
    [Arguments]    ${field}    ${value}
    Input Text    ${field}    ${value}
    Sleep    20s
    Click element    //div[@title='${value}']/../../../a

Click Visible Element
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    120s
    Click Element    ${locator}

logoutAsUser
    [Arguments]  ${user}
    [Documentation]     Logout through seetings button as direct logout is not available in some pages.
    ${setting_lighting}    Set Variable    //button[contains(@class,'userProfile-button')]
    sleep  20s
    ${count}  set variable  Get Element Count   ${setting_lighting}
    click element   ${setting_lighting}
    sleep  2s
    wait until page contains element   //a[text()='Log Out']  60s
    click element  //a[text()='Log Out']
    sleep  10s

Navigate to related tab
    Wait Until Element Is Visible    ${ACCOUNT_RELATED}    60s
    Force click element    ${ACCOUNT_RELATED}

Navigate to view
    [Arguments]     ${title}
    ScrollUntillFound  //span[text()='${title}']
    Click element   //span[text()='${title}']

ScrollUntillFound
    [Arguments]    ${element}
    : FOR    ${i}    IN RANGE    9999
    \    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
    \    Sleep    5s
    \    Exit For Loop If    ${status}
    \    Execute JavaScript    window.scrollTo(0,${i}*200)

Get Date With Dashes
    [Arguments]    ${days}
    ${date}=    Get Current Date
    ${date_in_future}=    Add Time To Date    ${date}    ${days} days
    ${converted_date}=    Convert Date    ${date_in_future}    result_format=%d-%m-%Y
    [Return]    ${converted_date}

Get Date From Future
    [Arguments]    ${days}
    [Documentation]    Returns current date (format: day.month.year, e.g. 28.6.2020) + x days,
    ...    where x = ${days} given as argument
    ${date}=    Get Current Date
    ${date_in_future}=    Add Time To Date    ${date}    ${days} days
    ${converted_date}=    Convert Date    ${date_in_future}    result_format=datetime
    ${converted_date}=    Set Variable    ${converted_date.day}.${converted_date.month}.${converted_date.year}
    [Return]    ${converted_date}

Create Unique Name
    [Arguments]    ${prefix}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d-%H%M%S
    ${name}=    Set Variable If    '${prefix}'=='${EMPTY}'    ${timestamp}    ${prefix}${timestamp}
    ${length}=    Get Length    ${name}
    # Removed the space between prefix and timestamp as having space will throw errro in giving email in contact page. Donot change this
    ## By aarthy
    # The search does not work if the name is too long. Cut characters to fit the timestamp. The timestamp takes 16 characters.
    # For example 'Telia Palvelulaite Lenovo ThinkPad L460 i5-6200U / 14" FHD / 8GB / 256SSD / W10P Opportunity <timestamp>' is too long
    ${name}=    Set Variable If    ${length} > 100    ${name[:70]} ${timestamp}    ${name}
    [Return]    ${name}

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
