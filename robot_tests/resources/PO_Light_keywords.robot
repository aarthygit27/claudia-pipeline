*** Settings ***
#Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
Resource          ../resources/PO_Lighting_variables.robot

*** Keywords ***
General Setup

    [Arguments]    ${price_list}    ${test_account}
    Open Salesforce and Login into Lightning   #sitpo admin
    Go To Entity    ${test_account}
    ${contact}  run keyword    Create New Contact for Account
    Set Test Variable    ${contact_name}  ${contact}
    ${opportunity}    run keyword    Create Opportunity    ${contact_name}
    Set Test Variable    ${oppo_name}   ${opportunity}
    ${billing_acc_name}    run keyword    CreateABillingAccount
    Set Test Variable    ${billingaccount}   ${billing_acc_name}
    Go To Entity    ${opportunity}
    Scroll Page To Element       //span[text()='Price List']
    ${price_list_old}=     get text     //span[text()='Price List']//following::a
    Log to console      old pricelist is ${price_list_old}
    ${compare}=    Run Keyword And Return Status    Should Be Equal As Strings    ${price_list_old}    ${price_list}
    Run Keyword If    ${compare}== False   Log to console    Change Pricielist
    Run Keyword If    ${compare}== False   Edit Opportunity Page     Price List  ${price_list}
    ClickingOnCPQ   ${oppo_name}
   #sleep  15s

Login to Salesforce as sitpo admin
    Login To Salesforce Lightning    ${SALES_ADMIN_SITPO}    ${PASSWORD_SALESADMIN_SITPO}

Open Salesforce and Login into Lightning
    [Arguments]    ${user}=DigiSales Lightning User
    [Documentation]    Go to Salesforce and then Login as DigiSales Lightning User, then switch to Sales App
    ...    and then select the Home Tab in Menu
    Open Salesforce
    #Sleep    20s
    #Run Keyword    Login to Salesforce as ${user}
    Open Salesforce Lightning    ${B2B_DIGISALES_LIGHT_USER}    ${Password_merge}
    Open Sales App
    Go to Home
    Clear All Notifications
    #Sleep    30s
    ${error}=    Run Keyword And Return Status    Element Should Be Visible    //div[@class()='modal-container slds-modal__container']
    Run Keyword If    ${error}    click button    //button[@title='OK']

Open Salesforce
    [Documentation]    Go to SalesForce and verify the login page is displayed.
    Go To    ${LOGIN_PAGE}
    Login Page Should Be Open

Login Page Should Be Open
    [Documentation]    To Validate the elements in Login page
    Wait Until Keyword Succeeds    60s    1 second    Location Should Be    ${LOGIN_PAGE}
    Wait Until Element Is Visible    id=username    60s
    Wait Until Element Is Visible    id=password    60s

Open Sales App
    [Documentation]    Go to SalesForce and switch to salesapp menu.
    ${IsElementVisible}=    Run Keyword And Return Status    element should not be visible    ${SALES_APP_NAME}
    Run Keyword If    ${IsElementVisible}    Switch to SalesApp

Go to Home
    [Arguments]    ${timeout}=60s
    Wait Until Element is Visible    ${SALES_APP_HOME}    60s
    Click Element    ${SALES_APP_HOME}
    Sleep    10s

Switch to SalesApp
    [Documentation]    Go to App launcher and click on SalesApp
    Click Element    ${APP_LAUNCHER}
    Wait until Page Contains Element    ${SEARCH_APP}    60s
    input text      ${SEARCH_APP}   Sales
    wait until page contains element   //div[@class='al-menu-dropdown-list']//a[@data-label='Sales']  60s
    click element     //div[@class='al-menu-dropdown-list']//a[@data-label='Sales']
    sleep   30s
    Wait Until Element is Visible    ${SALES_APP_NAME}    60s

Clear All Notifications
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

Open Salesforce Lightning

    [Arguments]    ${username}    ${password}
    #log to console    ${password}
    Wait Until Page Contains Element    id=username    240s
    Input Text    id=username    ${username}
    Sleep    5s
    Input text    id=password    ${password}
    Click Element    id=Login
    Sleep    20s
    ${infoAvailable}=    Run Keyword And Return Status    element should be visible    //a[text()='Remind Me Later']
    Run Keyword If    ${infoAvailable}    force click element    //a[text()='Remind Me Later']
    run keyword and ignore error    Check For Lightning Force
    ${buttonNotAvailable}=    Run Keyword And Return Status    element should not be visible    ${LIGHTNING_ICON}
    Run Keyword If    ${buttonNotAvailable}    reload page
    Wait Until Page Contains Element    xpath=${LIGHTNING_ICON}    60 seconds

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
    #Sleep    2s
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
    #Sleep    15s
    Click Element    ${TABLE_HEADER}${element_catenate}
    #Sleep    15s
    Wait Until Page Contains element    //h1//*[text()='${target_name}']    400s
    ${ISOpen}=    Run Keyword And Return Status    Entity Should Be Open    //h1//*[text()='${target_name}']
    run keyword Unless    ${ISOpen}    Search And Select the Entity    ${target_name}    ${type}

Entity Should Be Open
    [Arguments]    ${target_name}
    Sleep    5s
    Wait Until Page Contains element    ${target_name}    30s
    #${Case} ---- ActiveStatus or PassiveStatus of Account


Create New Contact for Account
    ${first_name}=    Run Keyword    Create Unique Name    ${EMPTY}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${mobile_num}=    Run Keyword    Create Unique Phone Number
    Set Test Variable    ${AP_FIRST_NAME}    AP ${first_name}
    Set Test Variable    ${AP_LAST_NAME}    Test ${first_name}
    Set Test Variable    ${AP_EMAIL}    ${email_id}
    Set Test Variable    ${AP_MOBILE_NUM}    ${mobile_num}
    Set Test Variable    ${Ap_mail}     ${email_id}
    Wait Until Page Contains element    //div[@title="New Contact"]    60s
    click element    //div[@title="New Contact"]
    #Sleep    2s
    Wait Until Page Contains element    xpath=${AP_MOBILE_FIELD}    60s
    Click Visible Element    ${AP_MOBILE_FIELD}
    Input Text    ${AP_MOBILE_FIELD}    ${AP_MOBILE_NUM}
    Input Text    ${FIRST_NAME_FIELD}    ${AP_FIRST_NAME}
    Input Text    ${LAST_NAME_FIELD}    ${AP_LAST_NAME}
    Input Text    ${MASTER_PRIMARY_EMAIL_FIELD}    ${AP_EMAIL}
    Input Text    ${MASTER_EMAIL_FIELD}     ${Ap_mail}
    wait until page contains element    ${AP_SAVE_BUTTON}
    Click Element    ${AP_SAVE_BUTTON}
    Sleep    10s
    [Return]    ${AP_FIRST_NAME} ${AP_LAST_NAME}


Create Contact From Account
    ${primary_email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    #log to console    This is to create new contact
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
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Primary eMail']//following::input[1]    ${primary_email_id}
    Sleep  10s
    #log to console      enter email
    clear element text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]  30s
    input text   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]       ${email_id}
    sleep    5s
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='modal-footer slds-modal__footer']/button/span[text()='Save']    30s
    force click element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='modal-footer slds-modal__footer']/button/span[text()='Save']
    ${IsErrorVisible}=    Run Keyword And Return Status    element should be visible    //span[text()='Review the errors on this page.']
    Sleep  30s
    #log to console    ${IsErrorVisible}
    #Run Keyword If    ${IsErrorVisible}    reEnterContactData    ${a}
    [Return]    Testing ${a}

reEnterContactData
    [Arguments]    ${random_name}
    ${primary_email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
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
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Primary eMail']//following::input[1]    ${primary_email_id}
    sleep    2s
    #log to console      Enter primary email
    clear element text   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]  30s
    input text   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Email']//following::input[1]       ${email_id}
    Sleep  2s
    #log to console      Enter email
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='modal-footer slds-modal__footer']/button/span[text()='Save']    30s
    force click element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='modal-footer slds-modal__footer']/button/span[text()='Save']
    sleep    5s
    ${IsErrorVisible}=    Run Keyword And Return Status    element should be visible    //span[text()='Review the errors on this page.']
    Sleep  30s
    #log to console    ${IsErrorVisible}
    Run Keyword If    ${IsErrorVisible}    reEnterContactData    ${random_name}
    #sleep    10s

Create Opportunity

    [Arguments]    ${b}=${contact_name}
    #log to console    this is to create a Oppo from contact ${b}
    ${oppo_name}    create unique name    Test Robot Order_
    wait until page contains element    //li/a[@title="New Opportunity"]   60s
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

Change Price list
    [Arguments]    ${price_lists}
    #${Price List}    set variable    //span[contains(text(),'Price List')]/../../button
    ${Price List}    set variable    //span[contains(text(),'Edit Close Date')]/../../button
    ${B2B_Price_list_delete_icon}=    Set Variable    //label/span[text()='Price List']/../../div//a[@class='deleteAction']
    ${edit pricelist}    Set Variable    //button[@title='Edit Price List']
    #Log To Console    Change Price list
    sleep    10s
    Scroll Page To Element    ${edit pricelist}
    ${element_position}    Get Vertical Position    ${edit pricelist}
    ${scroll_position}=    Evaluate    ${element_position}+1
    #Log To Console    ${scroll_position}as
    Scroll Page To Location    0    ${scroll_position}
    ScrollUntillFound    ${edit pricelist}
    Click Element    ${edit pricelist}
    #sleep    10s
    #ScrollUntillFound    ${B2B_Price_list_delete_icon}
    #Scroll Element Into View    ${B2B_Price_list_delete_icon}
    #log to console    ${price_lists}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${B2B_Price_list_delete_icon}    15s
    #log to console    ${status}
    Run Keyword If    ${status} == False    Click Element    ${edit pricelist}
    #log to console    waiting for delete icon
    Wait Until Element Is Visible    ${B2B_Price_list_delete_icon}    15s
    Capture Page Screenshot
    sleep    3s
    Capture Page Screenshot
    click element    ${B2B_Price_list_delete_icon}
    sleep    3s
    Capture Page Screenshot
    #Log To Console    searching for price list
    ${search}    Get Vertical Position    //input[@title='Search Price Lists']
    ${vert_post}    Evaluate    ${search}+3
    Scroll Page To Location    0    ${vert_post}
    #Scroll Page To Element    //input[@title='Search Price Lists']
    #log to console    scrolling
    Wait Until Element Is Visible    //input[@title='Search Price Lists']    15s
    Capture Page Screenshot
    #Log To Console    ${price_lists}
    input text    //input[@title='Search Price Lists']    ${price_lists}
    sleep    3s
    click element    //*[@title='${price_lists}']/../../..
    #Log To Console    saving
    click element    //button[@title='Save']
    #execute javascript    window.scrollTo(0,0)
    sleep    5s

ClickingOnCPQ
    [Arguments]    ${b}=${oppo_name}
    ##clcking on CPQ
    #log to console    ClickingOnCPQ
    Wait until keyword succeeds     30s     5s      click element    xpath=//a[@title='CPQ']
    #wait until page contains element    xpath=//h1[text()='${b}']    30s
    sleep    30s

Force click element
    [Arguments]    ${elementToClick}
    ${element_xpath}=    Replace String    ${elementToClick}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep    2s

ScrollUntillFound
    [Arguments]    ${element}
    #Run Keyword Unless    ${status}    Execsute JavaScript    window.scrollTo(0,100)
    : FOR    ${i}    IN RANGE    9999
    \    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
    \    Sleep    5s
    \    Execute JavaScript    window.scrollTo(0,${i}*200)
    \    Exit For Loop If    ${status}

updating close date
    ${close_date}=    Get Date From Future    30
    ${Edit_close_date}    set variable    //span[contains(text(),'Edit Close Date')]/../../button
    ${closing_date}    Set Variable    //div[contains(@data-aura-class,'uiInput--datetime')]/div/input
    #Log To Console    updating close date
    Scroll Page To Element    ${Edit_close_date}
    click element    ${Edit_close_date}
    Scroll Page To Element    ${closing_date}
    Clear Element Text    ${closing_date}
    input text    ${closing_date}    ${close_date}
    Scroll Page To Element    //button[@title='Save']
    click element    //button[@title='Save']
    sleep    10s
    #execute javascript    window.scrollTo(0,0)
    #sleep    5s

Review_page_sitpo
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${yes}    Set Variable    //input[@id='SubmitOrder'][@value='Yes']/../span[contains(@class,'radio')]
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Wait Until Element Is Visible    ${yes}    60s
    Click Element    ${yes}
    sleep    10s

Orchestration_plan_details
    ${orchestration plan name}    Set Variable    //th[@aria-label='Orchestration Plan Name']
    ${plan}    Set Variable    //th/div/a[contains(text(),'Plan')]
    ${orchestration plan}    Set Variable    //span[text()='Orchestration Plan']
    Wait Until Element Is Visible    ${orchestration plan name}    60s
    ScrollUntillFound   ${plan}
    Click Element    ${plan}
    #sleep    10s
    Wait Until Element Is Visible    ${orchestration plan}    60s
    Scroll Page To Location    0    50
    Capture Page Screenshot

update_setting1
    ${street_add1}    set variable    //input[@name='productconfig_field_1_0']
    ${street_add2}    set variable    //input[@name='productconfig_field_1_1']
    ${postal_code}    Set Variable    //input[@name='productconfig_field_1_3']
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${setting}    Set Variable    //button[@title='Settings']
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    ${city}    set variable    //input[@name='productconfig_field_1_4']
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    #Click Element    ${setting}
    Wait Until Element Is Visible    ${street_add1}    60s
    Press Key    ${street_add1}    This is a test opportunity
    Wait Until Element Is Visible    ${street_add2}    60s
    Press Key     ${street_add2}    This is a test opportunity
    Wait Until Element Is Visible    ${postal_code}    60s
    Press Key    ${postal_code}    00100
    Wait Until Element Is Visible    ${city}    60s
    click element    ${city}
    Press Key    ${city}    helsinki
    Capture Page Screenshot
    click element    ${closing}
    unselect frame

AddToCart with product_id

    [Documentation]  Search and add products with product id and click settings
    [Arguments]   ${pname}  ${p_id}
    ${Toggle}  set variable   //button[@class='slds-button cpq-item-has-children']/span[2][text()='${pname}']
    Wait until element is visible   //div[contains(@class,'slds')]/iframe  30s
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${status}      Run Keyword and return status    Element should be visible    //div[contains(@class, 'cpq-searchbox')]//input
    #Log to console      ${status}
    Wait until element is visible  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    Wait until element is visible  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    Wait until element is visible    //div[contains(@class,'cpq-products-list')]     60s
    Click element  //div[contains(@class, 'cpq-searchbox')]//input
    input text   //div[contains(@class, 'cpq-searchbox')]//input   ${pname}
    #Wait until element is enabled   xpath=//div[contains(@data-product-id,'${p_id}')]/div/div/div[2]/div/div[2]/button   60s
    Wait until element is enabled   //div/span[contains(text(),'${pname}')]/../../../div[@class="slds-tile__detail"]//button    60s
    #sleep   5s
    #Force click element  xpath=//div[contains(@data-product-id,'${p_id}')]/div/div/div[2]/div/div[2]/button
    #Click element    xpath=//div[contains(@data-product-id,'${p_id}')]/div/div/div[2]/div/div[2]/button
    click element  //div/span[contains(text(),'${pname}')]/../../../div[@class="slds-tile__detail"]//button
    sleep  10s
    ${status}   Run keyword and return status   Element should be visible   ${Toggle}
    #Log to console    Toggle status is ${status}
    Run keyword if  ${status}  Click element  ${Toggle}
    Click Settings  ${pname}
    Unselect frame

Searching and adding product
    [Documentation]  Search and add products and click settings
    [Arguments]   ${pname}=${product_name}
    ${Toggle}  set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/button/span[2][text()='${pname}']
    Wait until element is visible   //div[contains(@class,'slds')]/iframe  30s
    select frame  xpath=//div[contains(@class,'slds')]/iframe
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
    ${status}   Run keyword and return status  wait until page contains element   //span[contains(text(),"Required attribute missing")]  60s
    Run keyword if  ${status}   Click Settings  ${pname}
    Unselect frame
    #sleep  20s

AddProductToCart with product_id
    [Documentation]  Search and add products with product id and click settings
    [Arguments]   ${p_id}  ${pname}
    ${Toggle}  set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/button/span[2][text()='${pname}']
    Wait until element is visible   //div[contains(@class,'slds')]/iframe  30s
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${status}   set variable    Run Keyword and return status    Element should be visible    //div[contains(@class, 'cpq-searchbox')]//input
    #Log to console      ${status}

    Wait until element is visible  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    Wait until element is visible  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    Wait until element is visible    //div[contains(@class,'cpq-products-list')]     60s
    Click element  //div[contains(@class, 'cpq-searchbox')]//input
    input text   //div[contains(@class, 'cpq-searchbox')]//input   ${pname}

    Wait until element is visible   xpath=//div[contains(@data-product-id,'${p_id}')]/div/div/div[2]/div/div[2]/button   60s

    click element  xpath=//div[contains(@data-product-id,'${p_id}')]/div/div/div[2]/div/div[2]/button
    sleep  10s
    ${status}   Run keyword and return status   Element should be visible   ${Toggle}
    #Log to console    Toggle status is ${status}
    Run keyword if  ${status}  Click element  ${Toggle}


    Unselect frame

Search and add product
   [Documentation]  Search and add products without clickings setting button
   [Arguments]   ${pname}=${product_name}
   ${Toggle}  set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/button/span[2][text()='${pname}']
    Wait until element is visible   //div[contains(@class,'slds')]/iframe  30s
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    Wait until element is visible   xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    Wait until element is visible    //div[contains(@class,'cpq-products-list')]     60s
    click element   //div[contains(@class, 'cpq-searchbox')]//input
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    Wait until element is visible  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    #sleep   5s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    Wait until element is visible   //span[text()='${pname}']   30s
    sleep  10s
    ${status}   Run keyword and return status   Element should be visible   ${Toggle}
    #Log to console    Toggle status is ${status}
    Run keyword if  ${status}  Click element  ${Toggle}
    #Click Settings
    Unselect frame
    #sleep  20s


Add Avainasiakaspalvelukeskus

    [Documentation]    This is to add Avainasiakaspalvelukeskus to cart
    ${Toggle}  set variable   //button[@class='slds-button cpq-item-has-children']/span[2][text()='Avainasiakaspalvelukeskus']
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product}=  set variable   //div[contains(text(),'Avainasiakaspalvelukeskus')]//following::button[1]
    Wait until element is visible   ${product}
    click button  ${product}
    #sleep   10s
    Wait until element is visible   ${Toggle}  60s
    Click element  ${Toggle}
    Unselect frame


Add Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu

    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Avainasiakaspalvelukeskus Lisätyö jatkuva palvelu')]//following::button[1]
    Wait until element is visible   ${product_id}  30s
    click button    ${product_id}
    sleep  10s
    Wait until element is visible  //div[contains(text(),'Avainasiakaspalvelukeskus Lisätyö jatkuva palvelu')]//following::button[@title='Settings']  30s
    Click element    //div[contains(text(),'Avainasiakaspalvelukeskus Lisätyö jatkuva palvelu')]//following::button[@title='Settings']
    Unselect frame

Add Avainasiakaspalvelukeskus lisätyöt kertapalvelu

    [Documentation]    This is to add Avainasiakaspalvelukeskus lisätyöt kertapalvelu to cart and click grand child settings button

    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Avainasiakaspalvelukeskus Lisätyö kertapalvelu')]//following::button[1]
    Wait until element is visible   ${product_id}  30s
    click button    ${product_id}
    sleep  10s
    Click Button  //div[contains(text(),'Avainasiakaspalvelukeskus Lisätyö kertapalvelu')]//following::button[@title='Settings']
    Unselect frame

Add Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Avainasiakaspalvelukeskus Lisätyö varallaolo ja matkustus')]//following::button[1]
    Wait until element is visible   ${product_id}  30s
    click button    ${product_id}
    Wait until element is visible  //div[contains(text(),'Avainasiakaspalvelukeskus Lisätyö varallaolo ja matkustus')]//following::button[@title='Settings']  30s
    click button    //div[contains(text(),'Avainasiakaspalvelukeskus Lisätyö varallaolo ja matkustus')]//following::button[@title='Settings']
    Unselect frame

Add Koulutus jatkuva palvelu
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Koulutus jatkuva palvelu')]//following::button[1]
    Wait until element is visible   ${product_id}  30s
    click button    ${product_id}
    Wait until element is visible  //div[contains(text(),'Koulutus jatkuva palvelu')]//following::button[@title='Settings']  30s
    click button    //div[contains(text(),'Koulutus jatkuva palvelu')]//following::button[@title='Settings']
    Unselect frame

Add Child product of Telia Palvelunhallintakeskus
    [Arguments]   ${pname}
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'${pname}')]//following::button[1]
    Wait until element is visible   ${product_id}  30s
    click button    ${product_id}
    Wait until element is visible  //div[contains(text(),'${pname}')]//following::button[@title='Settings']  30s
    click button    //div[contains(text(),'${pname}')]//following::button[@title='Settings']
    Unselect frame


Add Hallinta ja Tuki
    ${Toggle}  set variable   //button[@class='slds-button cpq-item-has-children']/span[2][text()='Hallinta ja Tuki']
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    [Documentation]    This is to add Hallinta ja Tuki to cart
    ${product}=  set variable   //div[contains(text(),'Hallinta ja Tuki')]//following::button[1]
    Wait until element is visible   ${product}  30s
    Force click element      ${product}
    sleep   5s
    Wait until element is visible   ${Toggle}  60s
    Click element  ${Toggle}
    Capture Page Screenshot
    Unselect frame

Add Hallinta ja Tuki jatkuva palvelu
    [Documentation]    This is to add Hallinta ja Tuki jatkuva palvelu
    ...    to cart and fill the required details for grand child product
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Hallinta ja Tuki jatkuva palvelu')]//following::button[1]
    Wait until element is visible   ${product_id}  30s
    click button    ${product_id}
    sleep    5s
    Wait until element is visible   //div[contains(text(),'Hallinta ja Tuki jatkuva palvelu')]//following::button[@title='Settings']  30s
    Click Button   //div[contains(text(),'Hallinta ja Tuki jatkuva palvelu')]//following::button[@title='Settings']
    Unselect frame

Add Hallinta ja Tuki kertapalvelu
    [Documentation]    This is to add Hallinta ja Tuki kertapalvelu
    ...    to cart and fill the required details for grand child product
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Hallinta ja Tuki kertapalvelu')]//following::button[1]
    Wait until element is visible   ${product_id}  30s
    click button    ${product_id}
    sleep    10s
    Wait until element is visible  //div[contains(text(),'Hallinta ja Tuki kertapalvelu')]//following::button[@title='Settings']  30s
    Click button  //div[contains(text(),'Hallinta ja Tuki kertapalvelu')]//following::button[@title='Settings']
    Unselect frame

Add Hallinta ja Tuki varallaolo ja matkustus
    [Documentation]    This is to add Hallinta ja Tuki varallaolo ja matkustus
    ...    to cart and fill the required details for grand child product

    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Hallinta ja Tuki varallaolo ja matkustus')]//following::button[1]
    Wait until element is visible   ${product_id}  30s
    click button    ${product_id}
    sleep    5s
    Wait until element is visible   //div[contains(text(),'Hallinta ja Tuki varallaolo ja matkustus')]//following::button[@title='Settings']  30s
    Click Button   //div[contains(text(),'Hallinta ja Tuki varallaolo ja matkustus')]//following::button[@title='Settings']
    Unselect frame


Add Toimenpide XS
    [Documentation]    This is to Add Toimenpide XS
    ...    to cart and fill the required details
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    Execute JavaScript   window.scrollTo(0,500)
    #Log to console  select product
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide XS')]//following::button[1]
    Wait until element is visible   //div[contains(text(),'Toimenpide XS')]//following::button[1]  30s
    ScrollUntillFound      ${product_id}
    Force click element     ${product_id}
    sleep   30s
    Capture Page Screenshot
    #Click Button  //div[contains(text(),'Toimenpide XS')]//following::button[@title='Settings']
    Force click element         //div[contains(text(),'Toimenpide XS')]//following::button[@title='Settings']
    Click Settings Button       Toimenpide XS
    Unselect frame

Add Toimenpide S
    [Documentation]    This is to Add Toimenpide S
    ...    to cart and fill the required details
    Sleep   20s
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    Execute JavaScript   window.scrollTo(0,500)
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide S')]//following::button[1]
    Wait until element is visible   ${product_id}   30s
    ScrollUntillFound   ${product_id}
    Force click element      ${product_id}
    sleep   20s
    wait until page contains element        //div[contains(text(),'Toimenpide S')]//following::button[@title='Settings']        30s
    Force click element         //div[contains(text(),'Toimenpide S')]//following::button[@title='Settings']
    Click Settings Button       Toimenpide S
    Unselect frame

Click Settings Button
    [Arguments]    ${product}
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    //span[text()='Close']/..
    Run Keyword Unless    ${status}    Run Keyword With Delay    0.10s    Force click element     //div[contains(text(),'${product}')]//following::button[@title='Settings']

Add Toimenpide M
    [Documentation]    This is to Add Toimenpide M
    ...    to cart and fill the required details
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide M')]//following::button[1]
    Wait until element is visible   ${product_id}   30s
    ScrollUntillFound   ${product_id}
    Force click element      ${product_id}
    sleep   20s
    wait until page contains element        //div[contains(text(),'Toimenpide M')]//following::button[@title='Settings']        30s
    Force click element         //div[contains(text(),'Toimenpide M')]//following::button[@title='Settings']
    Click Settings Button       Toimenpide M
    sleep  10s
    Unselect frame


Add Toimenpide L
    [Documentation]    This is to Add Toimenpide L
    ...    to cart and fill the required details
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    Sleep       20s
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide L')]//following::button[1]
    Wait until element is visible  ${product_id}   30s
    ScrollUntillFound   ${product_id}
    Force click element      ${product_id}
    sleep   30s
    wait until page contains element        //div[contains(text(),'Toimenpide L')]//following::button[@title='Settings']        30s
    Force click element         //div[contains(text(),'Toimenpide L')]//following::button[@title='Settings']
    Click Settings Button       Toimenpide L
    sleep  10s
    Unselect frame

Add Toimenpide XL
    [Documentation]    This is to Add Toimenpide XL
    ...    to cart and fill the required details
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    Sleep       20s
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide XL')]//following::button[1]
    Wait until element is visible  ${product_id}   30s
    ScrollUntillFound   ${product_id}
    Force click element    ${product_id}
    sleep   20s
    wait until page contains element        //div[contains(text(),'Toimenpide XL')]//following::button[@title='Settings']       30s
    ScrollUntillFound           //div[contains(text(),'Toimenpide XL')]//following::button[@title='Settings']
    Force click element         //div[contains(text(),'Toimenpide XL')]//following::button[@title='Settings']
    Click Settings Button       Toimenpide XL
    sleep  10s
    Unselect frame

Add Events jatkuva palvelu
    [Documentation]   This is to  Add Events jatkuva palvelu  using Add to cart button
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    Sleep       20s
    ${product_id}=    Set Variable    //div[contains(text(),'Events jatkuva palvelu')]//following::button[1]
    Wait until element is visible  ${product_id}   30s
    ScrollUntillFound   ${product_id}
    Force click element     ${product_id}
    sleep   20s
    wait until page contains element        //div[contains(text(),'Events jatkuva palvelu')]//following::button[@title='Settings']
    ScrollUntillFound       //div[contains(text(),'Events jatkuva palvelu')]//following::button[@title='Settings']
    Force click element    //div[contains(text(),'Events jatkuva palvelu')]//following::button[@title='Settings']
    Click Settings Button       Events jatkuva palvelu
    Unselect frame

Add Events kertapalvelu
    [Documentation]   This is to  Add Events kertapalvelu  using Add to cart button
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    Sleep       20s
    ${product_id}=    Set Variable    //div[contains(text(),'Events kertapalvelu')]//following::button[1]
    Wait until element is visible  ${product_id}   30s
    ScrollUntillFound    ${product_id}
    Force click element     ${product_id}
    sleep   20s
    wait until page contains element        //div[contains(text(),'Events kertapalvelu')]//following::button[@title='Settings']         30s
    ScrollUntillFound     //div[contains(text(),'Events kertapalvelu')]//following::button[@title='Settings']
    Force click element    //div[contains(text(),'Events kertapalvelu')]//following::button[@title='Settings']
    Click Settings Button       Events kertapalvelu
    Unselect frame

Add_child_product
    [Arguments]    ${child_product}
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${child_cart}=    set variable    //div[@class='cpq-item-no-children'][contains(text(),'${child_product}')]/../../../div/button
    Wait until element is visible  ${child_cart}  30s
    Force Click Element    ${child_cart}
    Wait Until Element Is Not Visible    ${SPINNER_SMALL}    120s
    Wait until element is visible  ${CHILD_SETTINGS}  30s
    click button    ${CHILD_SETTINGS}
    sleep    5s
    Unselect frame

Click Settings
    [Arguments]  ${pname}
    #Reload page
    #sleep  15s
    #Wait until element is visible   //div[contains(@class,'slds')]/iframe     60s
    #select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${SETTINGS}   set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/div/span[text()='${pname}']//following::button[@title='Settings']
    Wait until element is visible   ${SETTINGS}   60s
    Click Button    ${SETTINGS}
    sleep  10s

update setting common
    [Arguments]    ${option}    ${cbox}

    Wait until element is visible  //div[contains(@class,'slds')]/iframe  30s
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    Capture Page Screenshot
    Wait until element is visible   ${Hinnoitteluperuste}  60s
    ${status}=     Run Keyword and Return status  Element should be enabled  ${Hinnoitteluperuste}
    Run Keyword IF   ${status}  click element    ${Hinnoitteluperuste}
    Run Keyword IF   ${status}  click element    ${Hinnoitteluperuste}/option[contains(text(),'${option}')]
    Wait until element is visible   ${Henkilötyöaika}  30s
    click element    ${Henkilötyöaika}
    Press Key    ${Henkilötyöaika}    10
    Wait until element is visible   ${Palveluaika}  30s
    click element    ${Palveluaika}
    Wait until element is visible   ${Palveluaika}//option[contains(text(),'arkisin 8-16')]   30s
    click element     ${Palveluaika}//option[contains(text(),'arkisin 8-16')]
    Wait until element is visible  ${Laskuttaminen}   30s
    Run Keyword And Ignore Error    click element    ${Laskuttaminen}
    Wait until element is visible   ${Laskuttaminen}/option[contains(text(),'Laskutus heti')]  30s
    Run Keyword And Ignore Error    click element     ${Laskuttaminen}/option[contains(text(),'Laskutus heti')]
    #Wait until element is visible   ${Työtilaus vaadittu}   30s
    ${compare}=    Run Keyword And Return Status    Should Be Equal As Strings    ${cbox}    yes
    Run Keyword If    ${compare}== True    click element    ${Työtilaus vaadittu}
    #Fill Laskutuksen lisätieto
    click element    ${X_BUTTON}
    Wait until element is not visible  ${X_BUTTON}  30s
    unselect frame
    sleep    5s

update setting Toimenpide
    [Arguments]    ${option}    ${cbox}
    Wait until element is visible  //div[contains(@class,'slds')]/iframe  30s
    sleep   10s
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    Capture Page Screenshot
    Wait until element is visible   ${Hinnoitteluperuste}  60s
    ${status}=     Run Keyword and Return status  Element should be enabled  ${Hinnoitteluperuste}
    Run Keyword IF   ${status}  click element    ${Hinnoitteluperuste}
    Run Keyword IF   ${status}  click element    ${Hinnoitteluperuste}/option[contains(text(),'${option}')]
    Wait until element is visible   ${Henkilötyöaika}  30s
    click element    ${Henkilötyöaika}
    Press Key    ${Henkilötyöaika}    10
    Wait until element is visible   ${Palveluaika}  30s
    click element    ${Palveluaika}
    Wait until element is visible   ${Palveluaika}//option[contains(text(),'arkisin 8-16')]   30s
    click element     ${Palveluaika}//option[contains(text(),'arkisin 8-16')]
    ${compare}=    Run Keyword And Return Status    Should Be Equal As Strings    ${cbox}    yes
    Run Keyword If    ${compare}== True    click element    ${Työtilaus vaadittu}
    #Fill Laskutuksen lisätieto
    click element    ${X_BUTTON}
    Wait until element is not visible  ${X_BUTTON}  30s
    unselect frame
    sleep    20s


Update setting Telia Arkkitehti jatkuva palvelu
    [Arguments]    ${option}    ${cbox}
    [Documentation]    ${option}= to select the option in \ Hinnoitteluperuste --> d or h
    ...    ${cbox}= to select the checkbox \ Työtilaus vaadittu \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ yes--> to check the check box
    ...    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ no--> not to check the checkbox


    Wait until element is visible  //div[contains(@class,'slds')]/iframe  30s
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    Capture Page Screenshot
    #sleep    10s
    Wait Until Element Is Visible    ${Hinnoitteluperuste}    30s
    click element    ${Hinnoitteluperuste}
    click element    ${Hinnoitteluperuste}/option[contains(text(),'${option}')]
    Wait Until Element Is Visible  ${Henkilötyöaika}  30s
    click element    ${Henkilötyöaika}
    input text    ${Henkilötyöaika}    10
    Wait Until Element Is Visible  ${Palveluaika}  30s
    click element    ${Palveluaika}
    Wait Until Element Is Visible   ${Palveluaika}//option[contains(text(),'arkisin 8-16')]   30s
    click element    ${Palveluaika}//option[contains(text(),'arkisin 8-16')]
    Wait Until Element Is Visible   ${Laskuttaminen}   30s
    Run Keyword And Ignore Error    click element    ${Laskuttaminen}
    Wait Until Element Is Visible  ${Laskuttaminen}/option[contains(text(),'Laskutus heti')]  30s
    Run Keyword And Ignore Error    click element    ${Laskuttaminen}/option[contains(text(),'Laskutus heti')]

    ${compare}=    Run Keyword And Return Status    Should Be Equal As Strings    ${cbox}    yes
    #Wait Until Element Is Visible   ${Työtilaus vaadittu}  30s
    Run Keyword If    ${compare}== True    click element    ${Työtilaus vaadittu}
    #Fill Laskutuksen lisätieto -- Not Mandatory
    click element    ${X_BUTTON}
    sleep    5s
    Unselect frame

Update setting Muut asiantuntijapalvelut
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    sleep    5s
    Fill Laskutuksen lisätieto
    sleep    5s
    click element    ${X_BUTTON}
    sleep    20s
    Click parent Product     Muut Asiantuntijapalvelut
    sleep   30s
    ${present}=    Run Keyword And Return Status    Element Should Be Visible    ${Kilometrikorvaus}
    run keyword unless   ${present}    Click parent Product     Muut Asiantuntijapalvelut
    sleep       10s
    click element    ${Kilometrikorvaus}
    Wait Until Element Is Not Visible    ${SPINNER_SMALL}    120s
    sleep    10s
    click element    ${CHILD_SETTINGS}
    sleep    10s
    Wait until element is visible  ${Kilometrit}  60s
    input text    ${Kilometrit}    100
    sleep    5s
    Fill Laskutuksen lisätieto
    sleep    5s
    click element    ${X_BUTTON}
    click element       //span[text()='Muut Asiantuntijapalvelut']/parent::button
    Unselect frame

Click parent Product
    [Arguments]    ${parent}
    wait until page contains element        //span[text()='${parent}']//parent::button       30s
    click element       //span[text()='${parent}']//parent::button

Update setting Telia Palvelunhallintakeskus
    [Arguments]    ${product}
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    Click Settings   ${product}
    #select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${Palvelunhallintakeskus}=    Set Variable    //input[@name='productconfig_field_1_0']
    ${Työtilaus vaadittu}=    Set Variable    //form[@name='productconfig']//span[@class='slds-form-element__label'][contains(text(),'Työtilaus vaadittu')]
    #sleep  15s
    Wait Until Element Is Visible    ${Palvelunhallintakeskus}    30s
    click element    ${Palvelunhallintakeskus}
    click element    ${Palvelunhallintakeskus}//option[contains(text(),'Olemassaoleva avainasiakaspalvelukeskus')]
    Wait until element is visible   ${Työtilaus vaadittu}  10s
    click element    ${Työtilaus vaadittu}
    #Fill Laskutuksen lisätieto
    click element    ${X_BUTTON}
    unselect frame
    sleep    5s

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

Update Product
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${Count}=  GetElement Count     ${sales_type}
    #Log to console      No of products is ${count}
    Run Keyword IF  ${Count} != 1   Select From List By Value    (//select[@ng-model='p.SalesType'])[1]    New Money-New Services
    Run Keyword IF  ${Count} != 1     Select From List By Value    (//select[@ng-model='p.SalesType'])[2]    New Money-New Services
    Run Keyword IF  ${count} == 1     Select From List By Value    ${sales_type}    New Money-New Services
    Capture Page Screenshot
    click button    ${CPQ_next_button}

UpdatePageNextButton

    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    #log to console    UpdateAndAddSalesType
    sleep    20s
    #Requires sleep to overcome dead object issue
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Wait until element is visible  ${next_button}  30s
    click element    ${next_button}
    unselect frame
    sleep    40s

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

Update Product Page for 2 products
    [Arguments]    ${product1}    ${product2}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_1}=    Set Variable    //td[normalize-space(.)='${product1}']
    ${product_2}=    Set Variable    //td[normalize-space(.)='${product2}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    #log to console    UpdateAndAddSalesType for 2 products
    sleep  10s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    wait until element is visible    ${update_order}    60s
    #log to console    selected new frame
    wait until element is visible   ${product_1}    70s
    click element    ${product_1} //following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_1}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    sleep    5s
    wait until element is visible    ${product_2}    70s
    click element    ${product_2} //following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_2}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    Unselect Frame
    sleep    30s

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

Credit Score Validation Checking

    select frame    xpath=//div[contains(@class,'slds')]/iframe
    Wait until page contains element  //div[@class="panel-heading"]//h1[contains(text(),"Credit Score Validation")]   60
    ${Status}=      Run Keyword and Return Status   element should be visible    //div//*[text()="Credit Score Not Accepted - Result: MAN"]
    Run Keyword if    ${Status}     Manual Credit enquiry Button
    Run Keyword unless   ${Status}  log to console   Not able to create the order without sucessful validation of credit score

Manual Credit enquiry Button
    ${send_quote}    Set Variable    //div[@title='Send Quote Email']
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
    logoutAsUser  B2B DigiSales
    sleep  20s
    Open Salesforce Lightning  ${SYSTEM_ADMIN_USER}   ${SYSTEM_ADMIN_PWD}
    swithchtouser  Credit Control
    Activate The Manual Credit enquiry   ${value}
    Open Salesforce and Login into Lightning
    ScrollUntillFound  //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Positive.")]
    page should contain element    //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Positive.")]
    Search Salesforce    ${quote_number}
    Select Entity    ${oppo_name}    ${EMPTY}
    credit score status after approval

Activate The Manual Credit enquiry
    [Arguments]  ${value}
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
    select option from dropdown  //lightning-combobox//label[text()="Decision"]/..//div/*[@class="slds-combobox_container"]/div  Positive
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
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //button[contains(text(),"Create Order")]  60s
    page should contain element  //div//small[text()="Manual Credit Inquiry accepted. Decision: Positive"]
    page should contain element  //button[contains(text(),"Create Order")]
    click element  //button[contains(text(),"Create Order")]
    unselect frame
    Sleep  10s

Select option from Dropdown
    [Arguments]    ${list}    ${item}
    ScrollUntillFound  ${list}
    force click element   ${list}
    sleep  10s
    wait until page contains element   ${list}/div[2]/lightning-base-combobox-item[@data-value="${item}"]  60s
    click visible element  ${list}/div[2]/lightning-base-combobox-item[@data-value="${item}"]

View Or Open Quote

    ${open_quote}=    Set Variable    //button[@id='Open Quote']    #//button[@id='Open Quote']
    ${view_quote}    Set Variable    //button[@id='View Quote']
    ${quote}    Set Variable    //button[contains(@id,'Quote')]
    ${central_spinner}    Set Variable    //div[@class='center-block spinner']
    wait until element is not visible    ${central_spinner}    120s
    sleep  10s
    #Reload page
    Wait until element is visible  //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe   30s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    #log to console    selected Create Quotation frame
    Wait Until Element Is Visible    ${quote}    120s
    ${quote_text}    get text    ${quote}
    ${open}    Run Keyword And Return Status    Should Be Equal As Strings    ${quote_text}    Open Quote
    ${view}    Run Keyword And Return Status    Should Be Equal As Strings    ${quote_text}    View Quote
    Run Keyword If    ${open} == True    click element    ${open_quote}
    Run Keyword If    ${view} == True    click element    ${view_quote}
    unselect frame

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

Open Order Page

    sleep   15s
    Wait until element is visible  //iframe[@title='accessibility title'][@scrolling='yes']   30s
    select frame    //iframe[@title='accessibility title'][@scrolling='yes']
    #Log to console      Open Order
    ${status}    Run Keyword and return status    Frame should contain    //button[contains(text(),'Open Order')]    Open Order
    #Current frame should contain  Open
    Wait until element is visible   //button[contains(text(),'Open Order')]  60s
    set focus to element    //button[contains(text(),'Open Order')]
    #wait until element is visible   //button[contains(text(),'Open Order')]    60s
    click element    //button[contains(text(),'Open Order')]
    unselect frame

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

Create_Order for multiple products
    [Arguments]    ${prod_1}  ${prod_2}
    #View Or Open Quote
    #Wait Until Element Is Visible    //ul[@class='branding-actions slds-button-group slds-m-left--xx-small oneActionsRibbon forceActionsContainer']/li[4]/a    120s
    #Click element   //ul[@class='branding-actions slds-button-group slds-m-left--xx-small oneActionsRibbon forceActionsContainer']/li[4]/a
    ${Status}=      Run Keyword and Return Status      wait until page contains element   //h1/div[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']  60s
    run keyword unless     ${Status}     Credit Score Validation Checking
    run keyword if     ${Status}    ClickonCreateOrder
    #Open Order Page
    #ClickonCreateOrder
    Sleep  30s
    #Open Order Page  # Removed not available in release
    NextButtonInOrderPage
    Sleep  20s
    Select Account
    #sleep  5s
    select contact
    #sleep  5s
    Select Date for multiple products    ${prod_1}  ${prod_2}
    #sleep  5s
    Select account Owner
    #Close and Submit
    submit order
    wait until page contains element        //div[text()='Order']//following::div//span         60s
    ${Order}        Get Text    //div[text()='Order']//following::div//span
    Set Test Variable     ${Order_Id}    ${Order}
    view orchestration plan details


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


select Date for multiple products

    [Arguments]   ${prod_1}   ${prod_2}
    [Documentation]    Used for selecting \ requested action date for each parent product
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    Wait until element is visible   //div[contains(@class,'slds')]/iframe  30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    Wait until element is visible   ${additional_info_next_button}  60s
    ${status}    Run Keyword and Return Status    Element should be visible    //div[@class='ProductName2 ng-binding ng-scope'][contains(text(),'${prod_1}')]//following::input[2]
    #Log to console    ${prod_1}
    Run Keyword if    ${status}    Pick Date with product    ${prod_1}
    ${status}    Run Keyword and Return Status    Element should be visible   //div[@class='ProductName2 ng-binding ng-scope'][contains(text(),'${prod_2}')]//following::input[2]
    #Log to console    ${prod_2}
    Run Keyword if    ${status}    Pick Date with product     ${prod_2}
    #sleep  5s
    Click Element    ${additional_info_next_button}
    Unselect frame

Pick date with product

    [Arguments]    ${product}
    #Log to console    picking date
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

Create account owner
    select frame    xpath=//div[contains(@class,'slds')]/iframe


    unselect frame

Select account Owner
    #log to console    Select Owner Account FLow Chart Page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #log to console    entering Owner Account page
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
    #log to console    Exiting owner Account page
    sleep    10s


Continue and submit
    [Documentation]   Give continue for Update Order Dialogue box after selecting account
    Wait until element is visible  //button[contains(text(),' Continue')]
    Click element  //button[contains(text(),' Continue')]
    sleep  3s


Submit for Approval

    sleep    40s
    ${status}   set variable  Run keyword and return status   Page contains element   //div[text()='Submit for Approval']
    Run Keyword if   {status}   Click element   //div[text()='Submit for Approval']
    Wait until page contains element  //h2[text()='Submit for Approval']
    Input Text   //textarea[@role='textbox']  submit
    click element  //span[text()='Submit']

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

update_setting2
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${setting}    Set Variable    //button[@title='Settings']
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    ${street_add1-a}    set variable    //input[@name='productconfig_field_1_1']
    ${street_add2-a}    set variable    //input[@name='productconfig_field_1_2']
    ${postal_code-a}    set variable    //input[@name='productconfig_field_1_4']
    ${city_town-a}    set variable    //input[@name='productconfig_field_1_5']
    ${street_add1-b}    set variable    //input[@name='productconfig_field_1_8']
    ${street_add2-b}    set variable    //input[@name='productconfig_field_1_9']
    ${postal_code-b}    set variable    //input[@name='productconfig_field_1_11']
    ${city_town-b}    set variable    //input[@name='productconfig_field_1_12']
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    #Click Element    ${setting}
    Wait Until Element Is Visible    ${street_add1-a}    60s
    Press Key     ${street_add1-a}    This is a test opportunity
    sleep    10s
    click element    ${street_add2-a}
    sleep    10s
    Press Key    ${street_add2-a}    This is a test opportunity
    sleep    10s
    click element    ${postal_code-a}
    sleep    10s
    Press Key     ${postal_code-a}    00100
    sleep    10s
    click element    ${city_town-a}
    sleep    10s
    Press Key     ${city_town-a}    helsinki
    sleep    10s
    Press Key    ${street_add1-a}    This is a test opportunity
    sleep    10s
    click element    ${street_add2-a}
    sleep    10s
    Press Key    ${street_add2-a}    This is a test opportunity
    sleep    10s
    click element    ${postal_code-a}
    sleep    10s
    Press Key    ${postal_code-a}    00100
    sleep    10s
    click element    ${city_town-a}
    sleep    10s
    Press Key     ${city_town-a}    helsinki
    sleep    10s
    Capture Page Screenshot
    click element    ${closing}

update_setting_Ethernet Nordic E-LAN EVP-LAN
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${setting}    Set Variable    //button[@title='Settings']
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    ${ Network bridge }    set variable    //input[@name='productconfig_field_0_5']
    ${pricing area}  set variable  //select[@name='productconfig_field_2_1']
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    #Click Element    ${setting}
    Wait Until Element Is Visible    ${ Network bridge }    60s
    Press Key    ${ Network bridge }    This is a test opportunity
    helinsiki_address
    Wait until element is visible   ${pricing area}  30s
    Click element  ${pricing area}
    sleep  5s
    Click element  //select[@name='productconfig_field_2_1']/option[2]
    sleep  3s
    click element    ${closing}
    Unselect frame







update_setting_Ethernet Nordic HUB/E-NNI
    ${Service level}    Set Variable    //select[@name='productconfig_field_0_4']
    ${platinum}    Set Variable    //select[@name='productconfig_field_0_4']//option[contains(text(),'Platinum')]
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${setting}    Set Variable    //button[@title='Settings']
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    #Click Element    ${setting}
    Wait Until Element Is Visible    ${Service level}    60s
    click element    ${Service level}
    click element    ${platinum}
    sleep    5s
    helinsiki_address
    Capture Page Screenshot
    click element    ${closing}
    Wait until element is visible   //div[normalize-space(.) = 'CPE for Nordic HUB E-NNI']//following::button[1]
    click element  //div[normalize-space(.) = 'CPE for Nordic HUB E-NNI']//following::button[1]
    Wait until element is visible  //select[@name='productconfig_field_0_0']  30s
    Click element  //select[@name='productconfig_field_0_0']
    Click element   //select[@name='productconfig_field_0_0']//option[contains(text(),'Multi')]
    click element    ${closing}
    Unselect Frame

helinsiki_address
    ${street_add1}    set variable    //input[@name='productconfig_field_1_0']
    ${street_add2}    set variable    //input[@name='productconfig_field_1_1']
    ${postal_code}    Set Variable    //input[@name='productconfig_field_1_3']
    ${city}    set variable    //input[@name='productconfig_field_1_4']
    ${country}  set variable   //select[@name='productconfig_field_1_5']
    Wait until element is visible   ${street_add1}  30s
    click element    ${street_add1}
    sleep  3s
    Press Key     ${street_add1}    This is a test opportunity
    Wait until element is visible   ${street_add2}  30s
    click element    ${street_add2}

    Press Key     ${street_add2}    99
    sleep  3s
    Wait until element is visible    ${postal_code}  30s
    click element   ${postal_code}
    Press Key     ${postal_code}    00100
    Press Key     ${postal_code}    00100
    sleep  3s
    Wait until element is visible   ${city}  30s
    click element    ${city}
    Press Key    ${city}    helsinki
    Press Key    ${city}    helsinki
    sleep  3s

    Wait until element is visible    ${country}  30s
    Click element   ${country}
    #Log to console   verify if address is populated properly
    ${code}  get text  ${postal_code}
    ${compare}=    Run Keyword And Return Status    Should Not Be Empty   ${code}
    Run Keyword If    ${compare}== False   Press Key    ${postal_code}    00100
    ${city_value}   get text  ${city}
    ${compare}=    Run Keyword And Return Status    Should Not Be Empty   ${city_value}
    Run Keyword If    ${compare}== False   Press Key    ${city}    helsinki
    sleep  10s

update_setting_Telia Ethernet subscription
    ${E_NNI-ID}    Set Variable    //input[@name='productconfig_field_0_6']
    ${E-NNI S-Tag VLAN}    Set Variable    //input[@name='productconfig_field_0_7']
    ${Interface}    Set Variable    //select[@name='productconfig_field_0_8']
    ${option}    Set Variable    ${Interface}//option[contains(text(),'10/100Base-TX')]
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    ${setting}    Set Variable    //button[@title='Settings']
    ${Pricing area matrix}  set variable    //select[@name='productconfig_field_2_0']
    ${pricing area}  set variable  //select[@name='productconfig_field_2_3']
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    #Click Element    ${setting}
    sleep    5s
    Wait Until Element Is Visible    ${E_NNI-ID}    60s
    Press Key     ${E_NNI-ID}    10
    sleep    5s
    Click Element    ${E-NNI S-Tag VLAN}
    sleep    10s
    Press Key     ${E-NNI S-Tag VLAN}    100
    sleep    5s
    Click Element    ${Interface}
    Click Element    ${option}
    helinsiki_address
    Click element  ${Pricing area matrix}
    sleep  5s
    Click element  //select[@name='productconfig_field_2_0']/option[2]
    sleep  5s
    Click element  ${pricing area}
    sleep  5s
    Click element  //select[@name='productconfig_field_2_3']/option[2]
    sleep  5s
    click element    ${closing}
    sleep  5s
    Unselect Frame

update_setting_TeliaRobotics
    #    Wait Until Element Is Visible    ${iframe}    60s
    #    Select Frame    ${iframe}
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    ${setting}    Set Variable    //button[@title='Settings']
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Wait Until Element Is Visible    ${setting}    60s
    #Click Element    ${setting}
    Fill Laskutuksen lisätieto
    click element    ${closing}
    Unselect Frame

Fill Laskutuksen lisätieto

    ${Laskutuksen lisätieto 1}=    set variable    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Laskutuksen lisätieto 1']]//following::input[1]
	${Laskutuksen lisätieto 2}=    set variable    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Laskutuksen lisätieto 2']]//following::input[1]
	${Laskutuksen lisätieto 3}=    set variable    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Laskutuksen lisätieto 3']]//following::input[1]
	${Laskutuksen lisätieto 4}=    set variable    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Laskutuksen lisätieto 4']]//following::input[1]
	${Laskutuksen lisätieto 5}=    set variable    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Laskutuksen lisätieto 5']]//following::input[1]
    Press Key     ${Laskutuksen lisätieto 1}    test order by robot framework.L1
    sleep    3s
    Press Key    ${Laskutuksen lisätieto 2}    test order by robot framework.L2
    sleep    3s
    Press Key     ${Laskutuksen lisätieto 3}    test order by robot framework.L3
    sleep    3s
    Press Key    ${Laskutuksen lisätieto 4}    test order by robot framework.L4
    sleep    3s
    Press Key   ${Laskutuksen lisätieto 5}    test order by robot framework.L5
    sleep    3s

update_setting_TeliaSign
    #    Wait Until Element Is Visible    ${iframe}    60s
    #    Select Frame    ${iframe}
    @{package}    Set Variable    paketti M    paketti L    paketti XL    paketti S
    @{cost}    Set Variable    62.00 €    225.00 €    625.00 €    10.00 €
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    ${setting}    Set Variable    //button[@title='Settings']
    ${Paketti}    set variable    //select[@name='productconfig_field_0_0']
    ${update}    Set Variable    //h2[contains(text(),'Updated Telia Sign')]
    Select Frame    ${iframe}
    Click Settings  Telia Sign
    unselect frame
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Wait Until Element Is Visible    ${setting}    60s
    #Click Element    ${setting}
    Wait Until Element Is Visible    ${Paketti}    60s
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > 3
    \    ${package_name}    set variable    @{package}[${i}]
    \    ${package_cost}    set variable    @{cost}[${i}]
    \    ${money}    Set Variable    //span[contains(text(),'${package_cost}')]
    \    Select From List By Value    ${Paketti}    ${package_name}
    \    Wait Until Element Is Visible    ${update}    60s
    \    #click element    //button[@ng-click='importedScope.close()']
    \    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${money}    60s
    \    Log To Console    package name = ${package_name} | Package cost = \ ${package_cost} | Status = ${status}
    Wait Until Element Is Enabled    ${closing}    60s
    Scroll Page To Element    ${closing}
    click element    ${closing}
    Unselect Frame

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
    wait until page contains element  //*[contains(text(),'Other Domain name')]/../../..//div[@class='cpq-item-base-product-currency cpq-item-currency-value'][1]  60s
    ${recurringcharge}    get text      //*[contains(text(),'Other Domain name')]/../../..//div[@class='cpq-item-base-product-currency cpq-item-currency-value'][1]
    ${onetimecharge}    get text     //*[contains(text(),'Other Domain name')]/../../..//div[@class='cpq-item-base-product-currency cpq-item-currency-value'][3]
    Wait Until Element Is Visible    ${Voimassaoloaika_Field}  5s
    press enter on    ${Voimassaoloaika_Field}
    Wait Until Element Is Visible    ${Voimassaoloaika_option}   2s
    click element    ${Voimassaoloaika_option}
    sleep   20s
    Should be true       '35.00' in '${recurringcharge}'
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

Add Office 365 Configuration
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${DNS_Office365_Add_To_Cart}   set variable   //*[contains(text(),'Office 365 Configuration')]/../../..//button[contains(text(),'Add to Cart')]
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Wait Until Element Is Visible    ${DNS_Office365_Add_To_Cart}    240s
    click element    ${DNS_Office365_Add_To_Cart}
    sleep   20s
    #Wait Until Element Is Visible    10s
    click element    ${closing}
    Unselect Frame

update_setting_Telia Domain Name Service

    [documentation]   Add Telia Domain Name Service, Finnish Domain name, DNS Primary, DNS Security, Redirect and Express Delivery to cart in CPQ page. Validate that Finnish Domain name registrant agreement is added automatically after adding Finnish domain name. Update required settings for the added products
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    ${Asiakkaan_verkkotunnus_field}  set variable   //input[@name='productconfig_field_1_0']
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Wait Until Element Is Visible    ${Asiakkaan_verkkotunnus_Field}    240s
    click element    ${Asiakkaan_verkkotunnus_Field}
    Input Text    ${Asiakkaan_verkkotunnus_Field}    Testrobot.fi
    click element    ${closing}



Add Finnish_Domain_Service

    ${Internet Domain_Toggle}  set variable  //span[text()='Internet Domain']/../button
    ${Finnish Domain Name Registrant}  set variable  //div[contains(text(),'Finnish Domain Name Registrant')]/../../..//*[@alt='settings']/..
    ${Finnish_Domain_Service_Add_To_Cart}   set variable   //div[contains(text(),'Finnish Domain Name') and not(contains(text(),'Finnish Domain Name Registrant'))]/../../..//button[contains(text(),'Add to Cart')]
    ${Finnish_Domain_Service_Settings_Icon}   set variable     //div[contains(text(),'Finnish Domain Name') and not(contains(text(),'Finnish Domain Name Registrant'))]/../../..//*[@alt='settings']/..
    ${Verkotunnus_Field}  set variable    //select[@name='productconfig_field_0_0']
    ${Verkotunnus_option}   set variable    //select[contains(@name,'productconfig_field_0_0')]//option[text()='.FI']
    ${Voimassaoloaika_Field}  set variable    //select[contains(@name,'productconfig_field_0_1')]
    ${Voimassaoloaika_option}   set variable    //select[contains(@name,'productconfig_field_0_1')]//option[text()='5']
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    Wait until element is visible  ${Internet Domain_Toggle}   60s
    Click element  ${Internet Domain_Toggle}
    Wait Until Element Is Visible    ${Finnish_Domain_Service_Add_To_Cart}    240s
    click element    ${Finnish_Domain_Service_Add_To_Cart}
    Wait Until Element Is Visible    ${Finnish_Domain_Service_Settings_Icon}    240s
    force click element    ${Finnish_Domain_Service_Settings_Icon}
    Wait Until Element Is Visible   ${Verkotunnus_Field}   10s
    press enter on    ${Verkotunnus_Field}
    Wait Until Element Is Visible   ${Verkotunnus_option}   2s
    click element    ${Verkotunnus_option}
    #Wait Until Element Is Visible    ${Voimassaoloaika_Field}  5s
    #press enter on    ${Voimassaoloaika_Field}
    #Wait Until Element Is Visible    ${Voimassaoloaika_option}    2s
    #click element    ${Voimassaoloaika_option}
    #Wait Until Element Is Visible    10s
    Validate the validity and the price for Finnish Domain     ${Voimassaoloaika_Field}        1      19
    Validate the validity and the price for Finnish Domain     ${Voimassaoloaika_Field}        2      25
    click element    ${closing}
    Wait until element is visible  ${Finnish Domain Name Registrant}   60s
    sleep       120s
    #Log to console   Finnish Domain Name Registrant added automatically
    wait until element is visible       //span[text()='Internet Domain']/../button      240s
    click element       //span[text()='Internet Domain']/../button
    Unselect Frame

Validate the validity and the price for Finnish Domain
    [Arguments]    ${field}         ${value}        ${otc}
    ${Voimassaoloaika_Field}  set variable    //select[contains(@name,'productconfig_field_0_1')]
    ${Voimassaoloaika_option}   set variable    //select[contains(@name,'productconfig_field_0_1')]//option[text()='${value}']
    Wait Until Element Is Visible    ${Voimassaoloaika_Field}  5s
    press enter on    ${Voimassaoloaika_Field}
    Wait Until Element Is Visible    ${Voimassaoloaika_option}   2s
    click element    ${Voimassaoloaika_option}
    sleep   20s
    #Should be true       '35.00' in '${recurringcharge}'
    ${recurringcharge}    get text      //*[contains(text(),'Finnish Domain Name')]/../../../div[@class='cpq-item-base-product-currency cpq-item-currency-value'][1]
    ${onetimecharge}    get text     //*[contains(text(),'Finnish Domain Name')]/../../../div[@class='cpq-item-base-product-currency cpq-item-currency-value'][3]
    ${onetimecharge} =  remove string   ${onetimecharge}  .00€
    Should be true       '${otc}' in '${onetimecharge}'


Adding DNS Primary
    ${DNS Maintenance_Toggle}  set variable  //span[text()='DNS Maintenance']/../button
    ${DNS Primary}  set variable   //div[contains(text(),'DNS Primary')]/../../..//button[contains(text(),'Add to Cart')]
    Wait until element is visible   ${DNS Maintenance_Toggle}  240s
    Sleep       30s
    Click element   ${DNS Maintenance_Toggle}
    Wait until element is visible  ${DNS Primary}  240s
    Click element       ${DNS Primary}

Add DNS Security
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${DNS Primary Toggle}  set variable  //span[text()='DNS Primary']/../../button
    ${DNS Security}   set variable   //div[contains(text(),'DNS Security')]/../../..//button[contains(text(),'Add to Cart')]
    select frame     ${iframe}
    Wait until element is visible  ${DNS Primary Toggle}   60s
    Click element       ${DNS Primary Toggle}
    Wait until element is visible   ${DNS Security}  60s
    Click element  ${DNS Security}
    unselect frame

Add Redirect
    ${Redirect}  set variable  //div[contains(text(),'Redirect')]/../../..//button[contains(text(),'Add to Cart')]
    ${Redirect_settings}  set variable  //div[contains(text(),'Redirect')]/../../..//*[@alt='settings']/..
    ${Lähdeosoite}  set variable   //input[@name='productconfig_field_0_0']
    ${Kohdeosoite}  set variable  //input[@name='productconfig_field_0_1']
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    select frame        ${iframe}
    Wait until element is visible  ${Redirect}  60s
    Click element       ${Redirect}
    Wait until element is visible  ${Redirect_settings}  60s
    Click element  ${Redirect_settings}
    Input Text    ${Lähdeosoite}   teollisuskatu 14 00510
    Press Key    ${Kohdeosoite}   telekatu 12 00510
    sleep  5s
    Click element  ${closing}
    unselect frame

Add Express Delivery
    ${Express Delivery}  set variable  //div[contains(text(),'Express Delivery')]/../../..//button[contains(text(),'Add to Cart')]
    ${Express Delivery settings}  set variable  //div[contains(text(),'Express Delivery')]/../../..//*[@alt='settings']/..
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    select frame         ${iframe}
    Wait until element is visible  ${Express Delivery}   60s
    sleep    5s
    Click element       ${Express Delivery}
    Wait until element is visible   ${Express Delivery settings}  60s
    Unselect Frame

Update Setting Ethernet Operator Subscription

    ${iframe}    Set Variable    xpath=//div[contains(@class,'slds')]/iframe
    ${redundancy}  set variable  //form[@name='productconfig']//following::label[text()[normalize-space() = 'Redundancy']]//following::select[1]

    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Wait Until Element Is Visible    ${redundancy}  30s
    Click element  ${redundancy}
    Click element  ${redundancy}/option[2]
    Wait Until Element Is Enabled    ${closing}    60s
    click element    ${closing}
    Unselect Frame

update telia robotics price sitpo
    ${iframe}    Set Variable    xpath=//div[contains(@class,'slds')]/iframe
    ${recurring charge}    Set Variable    //span[contains(@ng-class,'switchpaymentmode')]
    ${adjustments}    Set Variable    //h2[text()='Adjustment']
    ${price}    Set Variable    //input[@id='adjustment-input-01']
    ${apply button}    Set Variable    //button[contains(text(),'Apply')]
    #Log To Console    update telia robotics price sitpo
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Wait Until Element Is Visible    ${recurring charge}    60s
    click element    ${recurring charge}
    Wait Until Element Is Visible    ${adjustments}    60s
    Wait Until Element Is Visible    ${price}    60s
    input text    ${price}    30
    click element    ${apply button}
    sleep    10s
    Capture Page Screenshot
    Unselect Frame

account selection
    ${iframe}    Set Variable    xpath=//div[contains(@class,'slds')]/iframe
    ${account_name}=    Set Variable    //p[contains(text(),'Search')]
    ${account_checkbox}=    Set Variable    //td[@class='slds-cell-shrink']//span[@class='slds-checkbox--faux']
    ${search_account_next_button}=    Set Variable    //div[@id='SearchAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    sleep    3s
    select frame    ${iframe}
    Wait Until Element Is Visible    ${account_name}    120s
    click element    ${account_name}
    sleep    3s
    Wait Until Element Is Visible    ${account_checkbox}    120s
    click element    ${account_checkbox}
    sleep    3s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${search_account_next_button}    120s
    Click Element    ${search_account_next_button}
    Unselect Frame

select order contacts
    [Arguments]    ${technical_contact}=sitpo test
    ${iframe}    Set Variable    //div[contains(@class,'slds')]/iframe
    ${contact_search}=    Set Variable    //input[@id='ContactName']
    ${contact_next_button}=    Set Variable    //div[@id='Select Contact_nextBtn']
    #Wait Until Element Is Visible    ${contact_search_title}    120s
    select frame    ${iframe}
    Wait Until Element Is Visible    ${contact_search}    120s
    Input Text    ${contact_search}    ${technical_contact}
    sleep    3s
    Capture Page Screenshot
    wait until page contains element    //div[text()='${technical_contact}']/..//preceding-sibling::td[2]    30s
    click element    //div[text()='${technical_contact}']/..//preceding-sibling::td[2]
    sleep    5s
    #${order_name}    set variable    //input[@id='OrderContactDetailsTypeAhead']
    #${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${order_name}    5s
    #run keyword if    ${status} == True    update order details
    Click Element    ${contact_next_button}
    Unselect Frame

Select owner
    [Arguments]    ${billing_account}
    ${iframe}    Set Variable    //div[contains(@class,'slds')]/iframe
    ${owner_account}=    Set Variable    //td/div[text()='${billing_account}']/../../td[@data-label='Select']
    ${buyer_payer}=    Set Variable    //input[@id='BuyerIsPayer']/../span
    ${buyer_account_next_button}=    Set Variable    //div[@id='SelectedBuyerAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    select frame    ${iframe}
    Wait Until Element Is Visible    ${buyer_payer}    120s
    Click Element    ${owner_account}
    sleep    3s
    click element    ${buyer_payer}
    sleep    3s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${buyer_account_next_button}    120s
    click element    ${buyer_account_next_button}
    Unselect Frame

submit order
    ${submit_order}=    Set Variable    //span[text()='Yes']
    #${iframe}    Set Variable    //div[contains(@class,'slds')]/iframe
    #select frame    ${iframe}
    Wait until element is visible   //div[@title='Submit Order']    60s
    #Log to console    submitted
    click element    //div[@title='Submit Order']
    wait until element is visible       //button[text()='Submit']      60s
    click element       //button[text()='Submit']
    #wait until element is visible    ${submit_order}    120s
    #click element    ${submit_order}
    sleep    10s
    #Unselect Frame

Product_updation
    [Arguments]    ${product_name}
    clicking on next button
    UpdateAndAddSalesType    ${product_name}
    OpenQuoteButtonPage_release

updating setting telia ethernet capacity
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${setting}    Set Variable    //button[@title='Settings']
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    ${street_add1-a}    set variable    //input[@name='productconfig_field_1_0']
    ${street_add2-a}    set variable    //input[@name='productconfig_field_1_1']
    ${postal_code-a}    set variable    //input[@name='productconfig_field_1_3']
    ${city_town-a}    set variable    //input[@name='productconfig_field_1_4']
    ${street_add1-b}    set variable    //input[@name='productconfig_field_1_6']
    ${street_add2-b}    set variable    //input[@name='productconfig_field_1_7']
    ${postal_code-b}    set variable    //input[@name='productconfig_field_1_9']
    ${city_town-b}    set variable    //input[@name='productconfig_field_1_10']
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    #Click Element    ${setting}
    Wait Until Element Is Visible    ${street_add1-a}    60s
    input text    ${street_add1-a}    This is a test opportunity
    sleep    10s
    click element    ${street_add2-a}
    sleep    10s
    input text    ${street_add2-a}    This is a test opportunity
    sleep    10s
    click element    ${postal_code-a}
    sleep    10s
    input text    ${postal_code-a}    00100
    sleep    10s
    click element    ${city_town-a}
    sleep    10s
    input text    ${city_town-a}    helsinki
    sleep    10s
    input text    ${street_add1-a}    This is a test opportunity
    sleep    10s
    click element    ${street_add2-a}
    sleep    10s
    input text    ${street_add2-a}    This is a test opportunity
    sleep    10s
    click element    ${postal_code-a}
    sleep    10s
    input text    ${postal_code-a}    00100
    sleep    10s
    click element    ${city_town-a}
    sleep    10s
    input text    ${city_town-a}    helsinki
    sleep    10s
    click element    ${closing}

Send Account to billing system
    click element       //div[@title='Send Account to billing system']
    wait until page contains element        //*[text()='Billing Id was fetch successfully for the business account.']
    Force click element     //*[@id="Customer_nextBtn"]/p[text()='Next']

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
    wait until page contains element    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]    30s
    ${account_name_get}=    get value    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]
    ${numbers}=    Generate Random String    4    [NUMBERS]
    clear element text  //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]
    input text    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]    Billing_${test_account}_${numbers}
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
    [Return]    Billing_${test_account}_${numbers}


Add all child products
     ${AddChildProducts}=    Set Variable       //div[@class='cpq-product-cart-item-child']//button[contains(text(), 'Add to Cart')]
     Sleep      10s
     Wait until element is visible   //div[contains(@class,'slds')]/iframe  30s
     select frame  xpath=//div[contains(@class,'slds')]/iframe
     ${count}    get element count      ${AddChildProducts}
     #${locators}=    Get Webelements    xpath=${AddChildProducts}
     : FOR    ${locator}    IN RANGE  ${count}
     \    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
     \    ScrollUntillFound      ${AddChildProducts}
     \    Force click element         ${AddChildProducts}
     \    Exit For Loop If    ${status}
     unselect frame

Update Setting
    [Arguments]    ${product}       ${field}      ${value}
    ${settings}  set variable  //div[contains(text(),'${product}')]/../../..//*[@alt='settings']/..
    ${fieldname}  set variable   //input[@name='${field}']
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    select frame        ${iframe}
    ScrollUntillFound     ${settings}
    Force Click element     ${settings}
    Input Text    ${fieldname}   ${value}
    sleep  5s
    Click element  ${closing}
    unselect frame

Override Prices in CPQ
    [Arguments]    ${product}       ${rc}       ${otc}
    ${recurringcharge}  set variable  //div[contains(text(),'${product}')]/../../../div/div/div/div[contains(@ng-if,'vlocity_cmt__RecurringCharge__c')]/div/span
    ${onetimecharge}  set variable   //div[contains(text(),'${product}')]/../../../div/div/div/div[contains(@ng-if,'vlocity_cmt__OneTimeCharge__c')]/span
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    select frame        ${iframe}
    wait until page contains element        ${recurringcharge}      20s
    ScrollUntillFound     ${recurringcharge}
    Force Click element     ${recurringcharge}
    wait until page contains element     //input[@id='adjustment-input-01']         60s
    input text       //input[@id='adjustment-input-01']     ${rc}
    Sleep   3s
    click element   //button[contains(text(),'Apply')]
    unselect frame
    select frame        ${iframe}
    wait until page contains element        ${onetimecharge}        20s
    ScrollUntillFound     ${onetimecharge}
    Force Click element     ${onetimecharge}
    Sleep   3s
    wait until page contains element     //input[@id='adjustment-input-01']     60s
    input text       //input[@id='adjustment-input-01']     ${otc}
    click element   //button[contains(text(),'Apply')]
    sleep   5s
    unselect frame

logoutAsUser
    [Arguments]  ${user}
    [Documentation]     Logout through seetings button as direct logout is not available in some pages.
    ${setting_lighting}    Set Variable    //button[contains(@class,'userProfile-button')]
    sleep  20s
    click element   ${setting_lighting}
    sleep  2s
    wait until page contains element   //a[text()='Log Out']  60s
    click element  //a[text()='Log Out']
    sleep  10s

SwithchToUser
    [Arguments]  ${user}
    #log to console   ${user}.this is user
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}    ${user}
    sleep  3s
    press key   xpath=${SEARCH_SALESFORCE}    \\13
    wait until page contains element    //a[text()='${user}']     45s
    click element  //a[text()='${user}']
    wait until page contains element  //div[@class='primaryFieldAndActions truncate primaryField highlightsH1 slds-m-right--small']//span[text()='${user}']  60s
    wait until page contains element  //div[text()='User Detail']   60s
    click element  //div[text()='User Detail']
    wait until page contains element  //div[@id="setupComponent"]   60s
    Wait until element is visible  //div[contains(@class,'iframe')]/iframe  60s
    select frame  //div[contains(@class,'iframe')]/iframe
    wait until page contains element  //td[@class="pbButton"]/input[@title='Login']   60s
    force click element  //td[@class="pbButton"]/input[@title='Login']
    sleep  30s
    unselect frame
    Reload page
    Execute Javascript    window.location.reload(true)
    #reload page
    wait until page contains element  //a[text()='Log out as ${user}']   60s
    page should contain element  //a[text()='Log out as ${user}']