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
    Sleep    20s
    [Return]    ${AP_FIRST_NAME} ${AP_LAST_NAME}

Create Unique Mobile Number
    #${numbers}=    Generate Random String    6    [NUMBERS]
    #[Return]    +358888${numbers}
    [Return]    +358888888888

General Setup
    [Arguments]    ${price_list}    ${test_account}
    Go To Salesforce and Login into Lightning    B2B DigiSales
    Go To Entity    ${test_account}
    ${contact}  run keyword    Create New Contact for Account
    Set Test Variable    ${contact_name}  ${contact}
    ${opportunity}    run keyword    Create Opportunity    ${contact_name}
    Set Test Variable    ${oppo_name}   ${opportunity}
    #${billing_acc_name}    run keyword    CreateABillingAccount
    #Set Test Variable    ${billingaccount}   ${billing_acc_name}
    Go To Entity    ${opportunity}
    Scroll Page To Element       //span[text()='Price List']
    ${price_list_old}=     get text     //span[text()='Price List']//following::a
    Log to console      old pricelist is ${price_list_old}
    ${compare}=    Run Keyword And Return Status    Should Be Equal As Strings    ${price_list_old}    ${price_list}
    Run Keyword If    ${compare}== False   Log to console    Change Pricielist
    Run Keyword If    ${compare}== False   Edit Opportunity Page     Price List  ${price_list}
    ClickingOnCPQ   ${oppo_name}
   #sleep  15s

ClickingOnCPQ
    [Arguments]    ${b}=${oppo_name}
    ##clcking on CPQ
    #log to console    ClickingOnCPQ
    Wait until keyword succeeds     30s     5s      click element    xpath=//a[@title='CPQ']
    #wait until page contains element    xpath=//h1[text()='${b}']    30s
    sleep    30s

Create Opportunity

    [Arguments]    ${b}=${contact_name}
    #log to console    this is to create a Oppo from contact ${b}
    ${oppo_name}    create unique name    Test Robot Order_
    wait until page contains element    //li/a[@title="New Opportunity"]   120s
    click element    //li/a[@title="New Opportunity"]
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[1]    40s
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[1]    ${oppo_name}
    sleep    3s
    ${close_date}    get date from future    10
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[2]    ${close_date}
    #sleep    10s
    Wait until element is visible    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[3]  30s
    Capture Page Screenshot
    Select from search List   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[3]    ${b}
    #Input text   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[3]    ${b}
    #Wait until element is visible   //*[@title='${b}']/../../..    30s
    #click element    //*[@title='${b}']/../../..
    sleep    2s
    input text    //textarea    Description Testing
    click element    //button[@data-aura-class="uiButton"]/span[text()='Save']
    sleep    10s
    [Return]    ${oppo_name}


Select from search List
    [Arguments]    ${field}    ${value}
    Input Text    ${field}    ${value}
    Wait until element is visible    //div[@role="listbox"]//div[@role="option"]/lightning-icon//lightning-primitive-icon/*[@data-key="search"]  30s
    click element  //div[@role="listbox"]//div[@role="option"]/lightning-icon//lightning-primitive-icon/*[@data-key="search"]
    Click Visible Element    //div[@data-aura-class="forceSearchResultsGridView"]//a[@title='${value}']
    Sleep    2s


Edit Opportunity Page
    [Arguments]    ${field}      ${value}
    ${fieldProperty}=    Set Variable        //button[@title='Edit ${field}']
    scroll page to element      //*[text()='Price List']//following::input
    ${price_list_old}=     get element attribute       //*[text()='Price List']//following::input       placeholder
    log to console          ${price_list_old}
    ${B2B_Price_list_delete_icon}=    Set Variable    //input[contains(@placeholder,'B2B')]//following::button[@title='Clear Selection']
    ScrollUntillFound       ${fieldProperty}
    Force click element       ${fieldProperty}
    Sleep       2s
    Wait until element is visible  ${B2B_Price_list_delete_icon}  30s
    Force click element           ${B2B_Price_list_delete_icon}
    sleep    10s
    wait until page contains element       //input[contains(@placeholder,'Search ${field}')]        60s
    input text    //input[contains(@placeholder,'Search ${field}')]    ${value}
    sleep    3s
    click element    //*[@title='${value}']/../../..
    Sleep  10s
    click element    //button[@title='Save']
    Sleep  10s


Searching and adding product
    [Documentation]  Search and add products and click settings
    [Arguments]   ${pname}=${product_name}
    ${Toggle}  set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/button/span[2][text()='${pname}']
    Wait until element is visible   //div[contains(@class,'slds')]/iframe  30s
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${closing}    Run keyword and return status     Element should be visible     //*[@alt='close'][contains(@size,'large')]
    Run Keyword If      ${closing}      Click Visible Element         //*[@alt='close'][contains(@size,'large')]
    ${status}     Run Keyword and return status    Element should be visible    //div[contains(@class, 'cpq-searchbox')]//input
    Sleep       10s
    #Log to console      ${status}
    Wait until element is visible  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    Wait until element is visible  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    Wait until element is visible    //div[contains(@class,'cpq-products-list')]     60s
    Click element  //div[contains(@class, 'cpq-searchbox')]//input
    input text   //div[contains(@class, 'cpq-searchbox')]//input   ${pname}
    Wait until element is visible   xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    sleep   5s
    CLICK ELEMENT   xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    sleep  60s  # Better to have sleep time as it takes time to load
    ${status}   Run keyword and return status   Element should be visible   ${Toggle}
    #Log to console    Toggle status is ${status}
    Run keyword if  ${status}  Click element  ${Toggle}
    Sleep   5s
    ${status}   Run keyword and return status  wait until page contains element   //span[contains(text(),"Required attribute missing")]  60s
    Run keyword if  ${status}   Click Settings  ${pname}
    Unselect frame
    #sleep  20s

Click Settings
    [Arguments]  ${pname}
    #Reload page
    #sleep  15s
    #Wait until element is visible   //div[contains(@class,'slds')]/iframe     60s
    #select frame  xpath=//div[contains(@class,'slds')]/iframe
    #${SETTINGS}   set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/div/span[text()='${pname}']//following::button[@title='Settings']
    Sleep       5s
    ${exist}=    Run Keyword And Return Status    Element Should Be Visible     //*[contains(text(),'${pname}')]/../../..//*[@alt='settings']/..
    Run Keyword If    ${exist}      Click Button     //*[contains(text(),'${pname}')]/../../..//*[@alt='settings']/..
    ...    ELSE         Click Button     //*[contains(text(),'${pname}')]/../../../..//*[@alt='settings']/..
    #${SETTINGS}   set variable      //*[contains(text(),'${pname}')]/../../..//*[@alt='settings']/..
    #Wait until element is visible   ${SETTINGS}   60s
    #Click Button    ${SETTINGS}
    sleep  10s

Update Setting for Telia Domain Name Service
    [Arguments]    ${asiakkaan_verkkotunnus}
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    ${Asiakkaan_verkkotunnus_field}  set variable   //input[@name='productconfig_field_1_0']
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Wait Until Element Is Visible    ${Asiakkaan_verkkotunnus_Field}    240s
    click element    ${Asiakkaan_verkkotunnus_Field}
    Press key    ${Asiakkaan_verkkotunnus_Field}        ${asiakkaan_verkkotunnus}
    click element    ${closing}
    Unselect Frame


Add Other Domain Name and update settings
    [Arguments]    ${Verkotunnus}         ${Voimassaoloaika}        ${otc}
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${Other_Domain_Service_Add_To_Cart}   set variable   //*[contains(text(),'Other Domain name')]/../../..//button[contains(text(),'Add to Cart')]
    ${Other_Domain_Service_Settings_Icon}   set variable     //*[contains(text(),'Other Domain name')]/../../..//*[@alt='settings']/..
    ${Verkotunnus_Field}  set variable    //select[@name='productconfig_field_0_0']
    ${Verkotunnus_option}   set variable    //select[contains(@name,'productconfig_field_0_0')]//option[text()='${Verkotunnus}']
    ${Voimassaoloaika_Field}  set variable    //select[contains(@name,'productconfig_field_0_2')]
    ${Voimassaoloaika_option}   set variable    //select[contains(@name,'productconfig_field_0_2')]//option[text()='${Voimassaoloaika}']
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    wait until element is visible       //span[text()='Internet Domain']/../button      240s
    click element       //span[text()='Internet Domain']/../button
    Wait Until Element Is Visible    ${Other_Domain_Service_Add_To_Cart}    240s
    click element    ${Other_Domain_Service_Add_To_Cart}
    Wait Until Element Is Visible    ${Other_Domain_Service_Settings_Icon}    240s
    force click element    ${Other_Domain_Service_Settings_Icon}
    Wait Until Element Is Visible   ${Verkotunnus_Field}   10s
    press enter on    ${Verkotunnus_Field}
    Wait Until Element Is Visible   ${Verkotunnus_option}   2s
    click element    ${Verkotunnus_option}
    Validate the validity and the price for Other Domain     ${Voimassaoloaika_Field}        1          ${otc}
    Validate the validity and the price for Other Domain     ${Voimassaoloaika_Field}        existing       ${otc}
    Wait Until Element Is Visible    ${Voimassaoloaika_Field}  10s
    press enter on    ${Voimassaoloaika_Field}
    Wait Until Element Is Visible    ${Voimassaoloaika_option}    2s
    click element    ${Voimassaoloaika_option}
    #Wait Until Element Is Visible    10s
    click element    ${closing}
    wait until element is visible       //span[text()='Internet Domain']/../button      240s
    click element       //span[text()='Internet Domain']/../button
    Unselect Frame


Validate the validity and the price for Other Domain
    [Arguments]    ${field}         ${value}        ${otc}
    ${Voimassaoloaika_Field}  set variable    //select[contains(@name,'productconfig_field_0_2')]
    ${Voimassaoloaika_option}   set variable    //select[contains(@name,'productconfig_field_0_2')]//option[text()='${value}']
    sleep  20s
    wait until page contains element  //*[contains(text(),'Other Domain name')]/../../..//div[@class='cpq-item-base-product-currency cpq-item-currency-value'][1]  60s
    #${recurringcharge}    get text      //*[contains(text(),'Other Domain name')]/../../..//div[@class='cpq-item-base-product-currency cpq-item-currency-value'][1]
    ${onetimecharge}    get text     //*[contains(text(),'Other Domain name')]/../../..//div[@class='cpq-item-base-product-currency cpq-item-currency-value'][3]
    Wait Until Element Is Visible    ${Voimassaoloaika_Field}  5s
    press enter on    ${Voimassaoloaika_Field}
    Wait Until Element Is Visible    ${Voimassaoloaika_option}   2s
    click element    ${Voimassaoloaika_option}
    sleep   20s
    #Should be true       '35.00' in '${recurringcharge}'
    Should be true       '${otc}' in '${onetimecharge}'

Add DNS Primary
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${DNS_Primary_Add_To_Cart}   set variable   //*[contains(text(),'DNS Primary')]/../../..//button[contains(text(),'Add to Cart')]
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    wait until element is visible       //span[text()='DNS Maintenance']/../button      240s
    click element       //span[text()='DNS Maintenance']/../button
    Wait Until Element Is Visible    ${DNS_Primary_Add_To_Cart}    240s
    click element    ${DNS_Primary_Add_To_Cart}
    sleep   20s
    #Wait Until Element Is Visible    10s
    click element    ${closing}
    unselect frame

clicking on next button
    ${iframe}    Set Variable    //div[contains(@class,'slds')]/iframe
    ${next_button}    set variable    //span[contains(text(),'Next')]
    Reload page
    Wait Until Element Is Enabled    ${iframe}    90s
    select frame    ${iframe}
    #Wait Until Element Is Enabled    ${iframe}    90s
    Wait Until Element Is Visible    ${next_button}    60s
    #Run Keyword If    ${status} == True
    click element    ${next_button}
    Unselect Frame
    #sleep  10s


Update Product Page
    [Arguments]    ${products}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_list}=    Set Variable    //td[normalize-space(.)='${products}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    #log to console    UpdateAndAddSalesType
    sleep    8s
    Wait Until Element Is Visible    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Wait until element is Visible    ${update_order}    60s
    #log to console    selected new frame
    Wait until element is Visible    ${product_list}    70s
    Wait until element is visible  ${product_list} //following-sibling::td/select[contains(@class,'required')]  30s
    click element    ${product_list} //following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_list}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    ${status}    Run Keyword and return status    Frame should contain    ${next_button}    Next
    #Log to console      Next button on update Order ${status}
    Wait until element is visible   ${next_button}   30s
    Force click element    ${next_button}
    unselect frame
    sleep  60s


Create_Order
    ${Status}=      Run Keyword and Return Status      wait until page contains element   //h1/div[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']  60s
    run keyword unless     ${Status}     Credit Score Validation Checking
    #Wait Until Element Is Visible    //ul[@class='branding-actions slds-button-group slds-m-left--xx-small oneActionsRibbon forceActionsContainer']/li[4]/a    120s
    #Click element   //ul[@class='branding-actions slds-button-group slds-m-left--xx-small oneActionsRibbon forceActionsContainer']/li[4]/a
    run keyword if     ${Status}    ClickonCreateOrder
    #Open Order Page
    NextButtonInOrderPage
    sleep  30s
    Wait until element is visible   //div[contains(@class,'slds')]/iframe   30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${Status}=    Run Keyword and Return Status    wait until page contains element   //section[@id='OrderTypeCheck']/section/div/div/div/h1  40s
    Run Keyword if    ${Status}    Close and Submit
    Unselect frame
    Run Keyword Unless    ${Status}    Enter Details
    #wait until page contains element        //div[text()='Order']//following::div//span         60s
    ${Order}        Get Text    //h1//div[text()="Order"]/../div[2]//span[@class='uiOutputText']
    log to console           ${Order}
    Set Test Variable     ${Order_Id}    ${Order}
    #view orchestration plan details

ClickonCreateOrder

    #log to console    ClickonCreateOrderButton
    wait until page contains element    //h1/div[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']    60s
    force click element    //h1/div[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']
    sleep    15s
    Wait until element is visible   //div[contains(@class,'slds')]/iframe  60s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #Log to console      Inside frame
    ${status}     Run Keyword and return status    Frame should contain    //span[text()='Create Order']/..    Create Order
    #Log to console      ${status}
    wait until page contains element    //span[text()='Create Order']/..    60s
    click element    //span[text()='Create Order']/..
    unselect frame
    sleep  30s


NextButtonInOrderPage

    #log to console    NextButtonOnOrderPage
    #Reload page  If reloaded it opens the open order page. So does not include here
    sleep  20s
    Wait until element is visible  //div[contains(@class,'slds')]/iframe  30s
    #click on the next button from the cart
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #Log to console      Inside frame
    sleep  20s
    wait until element is visible       //span[text()='Next']/..        30s
    ${count}    Run Keyword and return status    Get Element Count   //span[text()='Next']/..
    #Log to console  ${count}
    #Run Keyword and return status  Frame should contain    //span[text()='Next']/..    Next
    #Log to console      ${status}
    #wait until element is visible    //span[text()='Next']/..    60s
    #set focus to element    //span[text()='Next']/..
    Force click element  //span[text()='Next']/..
    unselect frame



Close and Submit

    ${submit_order}=    Set Variable    //span[text()='Yes']
    ${status}   set variable   Run Keyword and Return Status   Frame should contain   //div[@id='Close']/p   Close
    Run Keyword if   ${status}   Click Element    //div[@id='Close']/p
    sleep  10s
    #sleep  15s
    Unselect frame
    #${status}    Run Keyword and Return Status    Page Should contain Element    ${submit_order}    30s
    #Run Keyword if    ${status}    click element    ${submit_order}
    #Run Keyword Unless    ${status}    Submit Order Button
    Submit Order Button
    view orchestration plan details


Enter Details
    Select Account
    select contact
    Select Date
    SelectOwnerAccountInfo    ${billingaccount}
    #Select account Owner
    Submit Order Button
    #view orchestration plan details


Select Account
    [Documentation]    This is to search and select the account
    ${account_name}=    Set Variable    //p[contains(text(),'Search')]
    ${account_checkbox}=    Set Variable    //td[@class='slds-cell-shrink']//span[@class='slds-checkbox--faux']
    ${search_account_next_button}=    Set Variable    //div[@id='SearchAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    sleep    5s
    wait until element is visible   //div[@class='iframe-parent slds-template_iframe slds-card']/iframe    60s
    select frame  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe
    Sleep   3s
    Wait Until Element Is Visible    ${account_name}    120s
    Force click element      ${account_name}
    #sleep    3s
    Wait Until page contains element    ${account_checkbox}    120s
    click element    ${account_checkbox}
    #sleep    3s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${search_account_next_button}    120s
    Click Element    ${search_account_next_button}
    Unselect frame
    sleep  5s



select contact
    ${contact_search}=    Set Variable    //input[@id='OrderContactTA']
    ${contact_next_button}=    Set Variable    //div[@id='SelectOrderLevelContacts_nextBtn']
    ${updateContactDR}=    Set Variable    //button[@class='slds-button slds-button--neutral ng-binding ng-scope'][@ng-click='nextRepeater(child.nextIndex, child.indexInParent)']
    Wait until element is visible   //div[contains(@class,'slds')]/iframe   30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #log to console    entering Technical COntact page
    Wait Until Element Is Visible    ${contact_search}    120s
    Input Text    ${contact_search}   ${contact_name}
    sleep    15s
    Wait until element is visible   css=.typeahead .ng-binding   30s
    Click element   css=.typeahead .ng-binding
    #sleep   10s
    Wait until element is visible  //input[@id='OCEmail']   30s
    #Input Text   //input[@id='OCEmail']   primaryemail@noemail.com
    ${status}=  Run keyword and return status   Element should be visible  //p[text()='Select Technical Contact:']
    Run Keyword if  ${status}  Enter technical contact
    Execute JavaScript    window.scrollTo(0,200)
    Sleep    5s
    #sleep  10s
    Wait until element is visible   ${contact_next_button}  30s
    Click Element    ${contact_next_button}
    unselect frame
    #sleep   10s

Enter technical contact
    ${Technical_contact_search}=  set variable    //input[@id='TechnicalContactTA']
    Execute JavaScript    window.scrollTo(0,200)
    Wait Until element is visible   ${Technical_contact_search}     30s
    Input text   ${Technical_contact_search}  ${contact_name}  # Contact of TeliaCommunication Oy account
    #sleep  10s
    Wait until element is visible   css=.typeahead .ng-binding  30s
    Click element   css=.typeahead .ng-binding
    #sleep  10s
    Wait until element is visible  //input[@id='TCEmail']   30s
    #Input Text   //input[@id='TCEmail']   primaryemail@noemail.com
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
    #Input Text   //input[@id='MCEmail']   primaryemail@noemail.com
    Execute JavaScript    window.scrollTo(0,200)



Select Date

    [Documentation]    Used for selecting \ requested action date
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    Wait until element is visible   //div[contains(@class,'slds')]/iframe  30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #sleep    60s
    Wait until element is visible   ${additional_info_next_button}  60s
    ${status}    Run Keyword and Return Status    Page should contain element    //*[@id="RequestedActionDateSelection"]
    #Log to console    ${status}
    Run Keyword if    ${status}   Pick Date without product
    Run Keyword Unless    ${status}    Click Element    ${additional_info_next_button}
    Unselect frame

Pick Date without product

    #Log to console    picking date
    ${date_id}=    Set Variable    //input[@id='RequestedActionDate']
    ${next_month}=    Set Variable    //button[@title='Next Month']
    ${firstday}=    Set Variable    //span[contains(@class,'slds-day nds-day')][text()='01']
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    #${additional_info_next_button}=    Set Variable    //div[@id='Additional data_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    #click element  //*[@id="RequestedActionDateSelection"]
    Wait Until Element Is Visible    //*[@id="RequestedActionDateSelection"]    120s
    Click Element    //*[@id="RequestedActionDateSelection"]
    Wait Until Element Is Visible    ${next_month}    120s
    Click Button    ${next_month}
    click element    ${firstday}
    #sleep    5s
    Capture Page Screenshot
    Click Element    ${additional_info_next_button}


SelectOwnerAccountInfo
    [Arguments]    ${e}= ${billing_account}
    #log to console    Select Owner Account FLow Chart Page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //div//label[@for="BuyerAccount"]   60s
    #log to console    entering Owner Account page
    Scroll Page To Element   //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    wait until element is visible    //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']    30s
    #Log to console      Selecting Billing account
    sleep   10s
    force click element   //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    sleep  10s
    unselect frame
    Scroll Page To Element       //*[@id="BuyerIsPayer"]//following-sibling::span
    sleep  10s
    select frame   xpath=//div[contains(@class,'slds')]/iframe
    Wait until element is visible    //*[@id="BuyerIsPayer"]//following-sibling::span
    #Log to console   Click BIP
    force click element  //*[@id="BuyerIsPayer"]//following-sibling::span
    ScrollUntillFound       //*[@id="SelectedBuyerAccount_nextBtn"]
    click element    //*[@id="SelectedBuyerAccount_nextBtn"]
    unselect frame
    #log to console    Exiting owner Account page
    sleep    30s


Submit Order Button
    #Reload page
    ${status}  Run keyword and return status   Wait until element is visible   //div[@title='Submit Order']    60s
    Run Keyword unless   ${status}   Reload page
    Run Keyword unless   ${status}   sleep  20s
    Run Keyword unless   ${status}    Wait until element is visible   //div[@title='Submit Order']    60s
    #Log to console    submitted
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
    ${Group id}=  set variable   //span[text()='Edit Group Billing ID']
    ${Installation date}=  set variable   //div/span[text()='Desired Installation Date']

    Wait until element is visible   ${cancel}   30s
    Click element   ${cancel}
    sleep  3s
    Wait until element is visible   ${Detail}  60s
    Force click element   ${Detail}
    #sleep  10s
    Execute JavaScript    window.scrollTo(0,1500)
    Wait until element is visible   ${Installation date}   60s
    #Log to console  Installation date
    set focus to element   ${Installation date}
    Click element  //div/span[text()='Desired Installation Date']//following::button[1]
    sleep  3s
    Wait until element is visible   //label/span[text()='Desired Installation Date']//following::input[1]  30s
    Force Click element  //label/span[text()='Desired Installation Date']//following::input[1]
    Click element   //a[@title='Go to next month']
    Wait until element is visible      //tr[@class='calRow'][2]/td[1]/span  30s
    Click element  //tr[@class='calRow'][2]/td[1]/span
    Execute JavaScript    window.scrollTo(0,1700)
    #Wait until element is visible      ${Group id}  60s
    #set focus to element  ${Group id}
    #Force Click element  ${Group id}
    Wait until element is visible   //input[@title='Search Group Billing IDs']  60s
    Input Text  //input[@title='Search Group Billing IDs']     ${group_billing_id}
    Wait until element is visible   //div[@title='${group_billing_id}']   50s
    Click element   //div[@title='${group_billing_id}']
    Wait until element is visible   //button[@title='Save']  30s

    Click element  //button[@title='Save']
    sleep  5s
    Wait until element is visible   //div[@title='Submit Order']    60s
    Click element  //div[@title='Submit Order']
    sleep  5s
    Capture Page Screenshot
    Wait until element is visible     //h2[text()='Submit Order']   30s
    click element   //button[text()='Submit']
    sleep  15s


view orchestration plan details
    Reload page
    log to console      view orchestration plan details
    sleep  10s
    ${plan}     set variable    //a[contains(@class,'textUnderline outputLookupLink')][contains(text(),'Plan')]
    ScrollUntillFound   ${plan}
    #Execute JavaScript    window.scrollTo(0,1200)
    Click element   ${plan}
    sleep  10s
    Execute Javascript    window.scrollTo(0,200)
    sleep    10s
    Capture Page Screenshot


CreateABillingAccount
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible     //li/a[@title='Billing Account']   60s
    #Run Keyword If    ${status_page} == True    force click element    //li/a/div[@title='Billing Account']
    Run Keyword If    ${status_page} == False   force click element     //a[@title="Show 2 more actions"]
    sleep  20s
    wait until page contains element    //li/a[@title='Billing Account']    45s
    click element    //li/a[@title='Billing Account']
    sleep    20s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible     //div[@title='Send Account to billing system']    40s
    run keyword if    ${status} == True    Send Account to billing system
    wait until page contains element    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]    120s
    ${account_name_get}=    get value    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]
    ${numbers}=    Generate Random String    4    [NUMBERS]
    clear element text  //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]
    input text    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]    Billing_${LIGHTNING_TEST_ACCOUNT}_${numbers}
    Execute JavaScript    window.scrollTo(0,700)
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

Send Account to billing system
    click element       //div[@title='Send Account to billing system']
    wait until page contains element        //*[text()='Billing Id was fetch successfully for the business account.']
    Force click element     //*[@id="Customer_nextBtn"]/p[text()='Next']


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
    #Force click element  //span[text()='Subscriptions and Networks']/../following::input[1]
    ${date}=    Get Date From Future    7
    #log to console  ${date}
    input text   //span[text()='Offer Date']/../following::div[@class='form-element']/input   ${date}
    scroll element into view  //span[text()='Type of Support Requested']/../following::textarea
    input text  //span[text()='Type of Support Requested']/../following::textarea   Dummy Text
    #Scroll Page To Location  0  200
    #scroll element into view  //span[text()='Sales Project']/../following::input[1]
    #click element  //span[text()='Sales Project']/../following::input[1]
    Sleep  10s
    select checkbox     //span[text()='Offering']//following::input
    ${error}=    Run Keyword And Return Status    Element Should Be Visible    //span[text()='Retry']
    Run Keyword If    ${error}    click button      //span[text()='Retry']
    wait until element is visible   //button[@class='slds-button slds-button_brand cuf-publisherShareButton undefined uiButton']//span[text()='Save']   60s
    click element  //button[@class='slds-button slds-button_brand cuf-publisherShareButton undefined uiButton']//span[text()='Save']
    [Return]    ${case_number}


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
    click element     //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Related']
    [Return]   ${order_no}


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

