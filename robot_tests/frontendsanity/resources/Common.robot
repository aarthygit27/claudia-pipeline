*** Settings ***
Library           SeleniumLibrary
Library           String
Library           Dialogs
Library           Screenshot
Library           DateTime
Library           Collections
Library           OperatingSystem
Resource          ../../frontendsanity/resources/Variables.robot
Resource          ../../frontendsanity/resources/Login.robot
Resource          ../../frontendsanity/resources/Contact.robot
Resource          ../../frontendsanity/resources/Account.robot
Resource          ../../frontendsanity/resources/Opportunity.robot
Resource          ../../frontendsanity/resources/CPQ.robot
Resource          ../../frontendsanity/resources/Quote.robot
Resource          ../../frontendsanity/resources/Order.robot

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

Create Unique Email
    [Arguments]    ${email}=${DEFAULT_EMAIL}
    ${email_prefix}=    Create Unique Name    ${EMPTY}
    ${email}=    Set Variable If    '${email}' == '${DEFAULT_EMAIL}'    ${email_prefix}${email}    ${email}
    [Return]    ${email}


Create Unique Mobile Number
    #${numbers}=    Generate Random String    6    [NUMBERS]
    #[Return]    +358888${numbers}
    [Return]    +358888888888

Create Unique Task Subject
    ${random_string}    generate random string    8
    [Return]    Task-${random_string}

Click specific element
    [Arguments]    ${element}
    @{locators}=    Get Webelements    xpath=${element}
    ${original}=    Create List
    : FOR    ${locator}    IN    @{locators}
    Click Element    xpath=${element}

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

Delete all entities from Accounts Related tab
    [Arguments]     ${entities}
    wait until element is visible    ${ACCOUNT_RELATED}    60s
    Force click element    ${ACCOUNT_RELATED}
    ${status}=    run keyword and return status    Element Should Be Visible    //span[@title='${entities}']
    #Run keyword Unless    ${status}    Run Keyword With Delay    0.10s    Click Element    xpath=${ACCOUNT_RELATED}
    Run keyword Unless    ${status}    Click Element    xpath=${ACCOUNT_RELATED}
    Sleep    30s
    ScrollUntillFound    //span[text()='${entities}']/../../a/span[@title="${entities}"]
    Execute Javascript    window.scrollTo(0,800)
    Sleep  30s
    ${visible}=    run keyword and return status    Element Should Be Visible    //span[text()='View All']/span[text()='${entities}']
    run keyword if    ${visible}    ScrollUntillFound    //span[text()='View All']/span[contains(text(),'${entities}')]
    #//span[contains(text(),'${entities}')]/../../span/../../../a
    ${display}=    run keyword and return status    Element Should Be Visible    //span[text()='View All']/span[contains(text(),'${entities}')]


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


Delete all entities
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

Click New Item For Account
    [Arguments]    ${type}
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    //a[@title='${type}']
    Run Keyword If    ${status}    Run Keyword With Delay    0.10s    Click Element    xpath=//a[@title='${type}']
    Wait Until Page Contains Element    ${NEW_ITEM_POPUP}    60s

Scroll Page To Element
    [Arguments]    ${element}
    #Run Keyword Unless    ${status}    Execsute JavaScript    window.scrollTo(0,100)
    : FOR    ${i}    IN RANGE    99
    \    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
    \    Execute JavaScript    window.scrollTo(0,100)
    \    Sleep    5s
    \    Exit For Loop If    ${status}


Select option from Dropdown
    [Arguments]    ${list}    ${item}
    ScrollUntillFound  ${list}
    force click element   ${list}
    sleep  10s
    wait until page contains element   ${list}/div[2]/lightning-base-combobox-item[@data-value="${item}"]  60s
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

Scroll Page To Location
    [Arguments]    ${x_location}    ${y_location}
    Execute JavaScript    window.scrollTo(${x_location},${y_location})
    Sleep    10s

Open tab
    [Arguments]    ${tabName}    ${timeout}=60s
    Wait Until Element is Visible    //a[@title='${tabName}']    60s
    Click Element    //a[@title='${tabName}']
    Sleep    10s

Select option from Dropdown with Force Click Element
    [Arguments]    ${list}    ${item}
    #Select From List By Value    //div[@class="uiInput uiInput--default"]//a[@class="select"]    ${item}
    ${element_xpath}=    Replace String    ${list}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep    5s
    force click element    ${item}


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
    Select rows to delete the items

Select rows to delete the items
    [Documentation]    Used to delete all the existing contracts for the business account
    ${count}=    get element count    ${table_row}
    #log to console    ${count}
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > ${count}-1
    \    Delete all Contracts    ${table_row}
    ${count}=    get element count    ${table_row}
    Run Keyword Unless   '${count}'=='0'  Select rows to delete the contract


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
    ${contact_name}    run keyword    Create New Contact for Account
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

Switch between windows
    [Arguments]    ${index}
    @{titles}    Get Window Titles
    Select Window    title=@{titles}[${index}]
    ${title}    Get Title


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

