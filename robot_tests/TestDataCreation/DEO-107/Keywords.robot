*** Settings ***
Library           Collections
Resource          Variables.robot
Resource          ../../resources/common.robot

*** Keywords ***
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

Go To Salesforce
    [Documentation]    Go to SalesForce and verify the login page is displayed.
    Go To    ${LOGIN_PAGE}
    Login Page Should Be Open

Login Page Should Be Open
    [Documentation]    To Validate the elements in Login page
    Wait Until Keyword Succeeds    60s    1 second    Location Should Be    ${LOGIN_PAGE}
    Wait Until Element Is Visible    id=username    60s
    Wait Until Element Is Visible    id=password    60s

Login to Salesforce as B2B DigiSales
    [Arguments]    ${username}=${B2B_DIGISALES_LIGHT_USER}    ${password}=${Password_merge}
    Login To Salesforce Lightning    ${username}    ${password}

Login to Salesforce as System Admin
    [Arguments]        ${username}= ${SYSTEM_ADMIN_USER}   ${password}= ${SYSTEM_ADMIN_PWD}  #${username}=mmw9007@teliacompany.com.release    #${password}=Sriram@234
    Login To Salesforce Lightning    ${username}    ${password}

Login to Salesforce as DigiSales Admin
    Login To Salesforce Lightning    ${SALES_ADMIN_APP_USER}   ${PASSWORD-SALESADMIN}

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
    \    Execute JavaScript    window.scrollTo(0,${i}*450)

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
    scrolluntillfound       ${Customer Signed Date}
    Wait until element is visible  ${Customer Signed Date}  30s
    Force Click element   ${Customer Signed Date}
    Wait until element is visible   //a[@title='Go to next month']   30s
    Click element   //a[@title='Go to next month']
    Click element   //table[@class='calGrid']/tbody/tr[1]/td[1]/span[1]
    Input Text   ${Customer Signature Place}  Helsinsiki
    Execute JavaScript    window.scrollTo(0,1700)
    ScrollUntillFound       ${Telia Signed By}
    input text    ${Telia Signed By}   Sales Admin
    Wait until element is visible    //div[@title='Sales Admin']    30s
    Click element  //div[@title='Sales Admin']
    ScrollUntillFound       ${Telia Signed Date}
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
    Force click element     ${Attachment_Button}
    sleep  30s
    Reload page
    Select Window   NEW
    sleep  30s
        #Click element   ${Attachment_Button}
    #Wait until element is visible  ${Frame}  30s
    #Select frame  ${Frame}
    sleep  15s
    #Wait until element is visible  ${File}  60s  - Not working
    log to console  file path started
    ${status}  Run keyword and return status  Element should be visible  ${File}
    Choose File   ${File}   ${File_Path}
    Sleep       10s
    Wait until element is visible       //span[text()='Done']       10s
    Force Click element   //span[text()='Done']/..
    Sleep          10s
    Wait until element is visible  //textarea[@name='fDesc']  30s
    Force Click element  //textarea[@name='fDesc']
    Input text  //textarea[@name='fDesc']  Test Description
    #Click element  ${Type}
    #Click element  ${Type_Option}
    #Click element  ${Document}
    #Click element  ${Document_option}
    sleep  10s
    Wait until element is visible      //button[@title='Save and Close']       10s
    Force click element         //button[@title='Save and Close']
    #wait until page contains element  //label[@class="slds-checkbox"]//input[@id="sync_to_ecm"]  60s
    #select checkbox  //label[@class="slds-checkbox"]//input[@id="sync_to_ecm"]
    #sleep  2s
    #Click element  //p[text()='Load Attachment']
    #Wait until element is visible  //p[contains(text(),'Attachment has been loaded successfully.')]  60s
    Unselect Frame
    sleep  2s
    go to   ${page}
    sleep  30s
    log to console  file contracts details ended

#Fill Contract Details
#    [Documentation]  To fill form while creating SErvice and customership contract
#    [Arguments]  ${Contract_Type}  ${contact_name}   ${Linked Customer Contract}=${EMPTY}
#    ${Edit Contractual Contact Person}   set variable   //button[@title='Edit Contractual Contact Person']
#    ${Search Contracts}    set variable  //span[text()='Contractual Contact Person']//following::div[1]/div/div/div/input[@title='Search Contacts']
#    ${contact}  set variable  //div[@title='${contact_name}']
#    ${Customer Signed By}  set variable   //span[text()='Customer Signed By']//following::div[1]/div/div/div/input[@title='Search Contacts']
#    ${Customer Signed Date}   set variable   //label[@class='label inputLabel uiLabel-left form-element__label uiLabel']/span[text()='Customer Signed Date']//following::input[1]
#    ${Customer Signature Place}  set variable   //label[@class='label inputLabel uiLabel-left form-element__label uiLabel']/span[text()='Customer Signature Place']//following::textarea[1]
#    ${Telia Signed By}  set variable   //label[@class='label inputLabel uiLabel-left form-element__label uiLabel']/span[text()='Telia Signed By']//following::input[1]
#    ${Telia Signed Date}   set variable  //label[@class='label inputLabel uiLabel-left form-element__label uiLabel']/span[text()='Telia Signed Date']//following::input[1]
#    ${Attachment_Button}  set variable   //a[@title='Add Attachment']
#    ${File_Path}   set variable    ${CURDIR}${/}input.txt
#    #${filepath}     set variable   ${CURDIR}\\Input.txt
#    ${save}  set variable  //button[@title='Save']
#    ${ATTACHMENT_NAME}  set variable  //input[@id='name']
#    ${File}  set variable   //input[@type='file']
#    ${Type}  set variable   //select[@id='type']
#    ${Type_Option}  set variable   //select[@id='type']/option[@value='Customership Agreement']
#    ${Document}  set variable   //select[@id='Document_Stage']
#    ${Document_option}  set variable   //select[@id='Document_Stage']/option[@value='Approved']
#    ${Frame}  set variable  //div[contains(@class,'slds')]/iframe
#    Run keyword if   '${Contract_Type}' == 'Service'      Verify if Customer Contract is linked  ${Linked Customer Contract}
#    Sleep       10s
#    #Run keyword if   '${Contract_Type}' == 'Service'
#    Wait Until Page Contains element        //div[text()="Contract"]        60s
#    ${Telia party}  get text  //span[text()="Telia Party"]/../../div[@class="slds-form-element__control slds-grid itemBody"]//span[@class="test-id__field-value slds-form-element__static slds-grow "]
#    #${itrm}     get length   ${Telia party}
#    #${status}   Run keyword and return status   should not be empty   ${itrm}
#    #Run Keyword Unless   ${status}  click element  //button[@title="Edit Telia Party"]
#    #Run Keyword Unless   ${status}  Wait until element is visible   //div//span[text()="Telia Party"]/../..//input[@title="Search Accounts"]     60s
#    #Run Keyword Unless   ${status}     Select from search List  //div//span[text()="Telia Party"]/../..//input[@title="Search Accounts"]        Telia Communication Oy
#    #Run Keyword Unless   ${status}     click element  ${save}
#    #Run Keyword Unless   ${status}     sleep   20s
#    #ScrollUntillFound     //span[text()="Telia Party"]/../..//input[@title="Search Accounts"]
#    #ScrollUntillFound   //button[@title='Edit Customer Signed By']
#    #Wait until element is visible  //button[@title='Edit Customer Signed By']  30s
#    #Force Click element  //button[@title='Edit Customer Signed By']
#    ScrollUntillFound           ${Edit Contractual Contact Person}
#    Wait until element is visible    ${Edit Contractual Contact Person}  60s
#    Click element    ${Edit Contractual Contact Person}
#    Wait until element is visible    ${Search Contracts}  30s
#    Click element  ${Search Contracts}
#    Input Text  ${Search Contracts}  ${contact_name}
#    sleep   4s
#    ${status}  run keyword and return status   Element should be visible  ${contact}
#    Run Keyword Unless   ${status}   clear element text   ${Search Contracts}
#    Run keyword Unless   ${status}   Press Key   ${Search Contracts}   ${contact_name}
#    Wait until element is visible    ${contact}  30s
#    Force Click element  ${contact}
#    Sleep   5s
#    ScrollUntillFound       ${Customer Signed By}
#    Wait until element is visible   ${Customer Signed By}  30s
#    click element       ${Customer Signed By}
#    input text      ${Customer Signed By}   ${contact_name}
#    sleep  3s
#    ${Count}  run keyword and return status   element should be visible     ${contact}
#    Run keyword Unless   ${Count}   clear element text   ${Customer Signed By}
#    Run keyword Unless   ${Count}   Press Key   ${Customer Signed By}    ${contact_name}
#    Wait until element is visible    ${contact}  30s
#    Force Click element  ${contact}/../..
#    ${status}   Run keyword and return status  Page should contain element  //li[text()='An invalid option has been chosen.']
#    Run Keyword If  ${status}  Force Click element   //span[text()='Undo Customer Signed By']
#    Run Keyword If  ${status}   Force Click element  ${contact}
#    Capture Page Screenshot
#    sleep  3s
#    scrolluntillfound       ${Customer Signed Date}
#    Wait until element is visible  ${Customer Signed Date}  30s
#    Force Click element   ${Customer Signed Date}
#    Wait until element is visible   //a[@title='Go to next month']   30s
#    Click element   //a[@title='Go to next month']
#    Click element   //table[@class='calGrid']/tbody/tr[1]/td[1]/span[1]
#    Input Text   ${Customer Signature Place}  Helsinsiki
#    #Execute JavaScript    window.scrollTo(0,1700)
#    ScrollUntillFound       ${Telia Signed By}
#    input text    ${Telia Signed By}   Sales Admin
#    Wait until element is visible    //div[@title='Sales Admin']    30s
#    Click element  //div[@title='Sales Admin']
#    ScrollUntillFound       ${Telia Signed Date}
#    Force Click element   ${Telia Signed Date}
#    Click element   //a[@title='Go to next month']
#    Click element   //table[@class='calGrid']/tbody/tr[1]/td[1]/span[1]
#    #Execute JavaScript    window.scrollTo(0,10)
#    Execute JavaScript    window.scrollTo(0,1700)
#    sleep  8s
#    ${status}   Run keyword and return status  Page should contain element  ${save}
#    Run keyword unless    ${status}   Reload page
#    Run keyword unless    ${status}   sleep  10s
#    Run keyword unless    ${status}   Fill Contract Details   ${Contract_Type}  ${Linked Customer Contract}
#    ${status}   Run keyword and return status  Element should be visible  ${save}
#    Run keyword unless    ${status}   Reload page
#    Run keyword unless    ${status}   sleep  10s
#    Run keyword unless    ${status}   Fill Contract Details   ${Contract_Type}  ${Linked Customer Contract}
#    click element  ${save}
#    sleep  10s
#    ${status}  Run keyword and return status  Element should not be visible  ${save}
#    Reload page
#    sleep  10s
#    Run keyword Unless    ${status}   Fill Contract Details   ${Contract_Type}  ${Linked Customer Contract}
#    ${page}  get location
#    #Attachment
#    Wait until element is visible  ${Attachment_Button}  60s
#    Click Link  ${Attachment_Button}
#    sleep  30s
#    Reload page
#    Select Window   NEW
#    sleep  30s
#        #Click element   ${Attachment_Button}
#    #Wait until element is visible  ${Frame}  30s
#    #Select frame  ${Frame}
#    sleep  15s
#    #Wait until element is visible  ${File}  60s  - Not working
#    log to console  file path started
#    ${status}  Run keyword and return status  Element should be visible  ${File}
#    Choose File   ${File}   ${File_Path}
#    Sleep       10s
#    Wait until element is visible       //span[text()='Done']       10s
#    Force Click element   //span[text()='Done']/..
#    Sleep          10s
#    Wait until element is visible  //textarea[@name='fDesc']  30s
#    Force Click element  //textarea[@name='fDesc']
#    Input text  //textarea[@name='fDesc']  Test Description
#    #Click element  ${Type}
#    #Click element  ${Type_Option}
#    #Click element  ${Document}
#    #Click element  ${Document_option}
#    sleep  10s
#    Wait until element is visible      //button[@title='Save and Close']       10s
#    Force click element         //button[@title='Save and Close']
#    #wait until page contains element  //label[@class="slds-checkbox"]//input[@id="sync_to_ecm"]  60s
#    #select checkbox  //label[@class="slds-checkbox"]//input[@id="sync_to_ecm"]
#    #sleep  2s
#    #Click element  //p[text()='Load Attachment']
#    #Wait until element is visible  //p[contains(text(),'Attachment has been loaded successfully.')]  60s
#    Unselect Frame
#    sleep  2s
#    go to   ${page}
#    sleep  30s
#    log to console  file contracts details ended

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

Create Unique Mobile Number
    #${numbers}=    Generate Random String    6    [NUMBERS]
    #[Return]    +358888${numbers}
    [Return]    +358888888888