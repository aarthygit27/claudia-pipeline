*** Settings ***
Library              Collections

Resource          ..${/}resources${/}common.robot
Resource          ..${/}resources${/}cpq_keywords.robot
Resource          ..${/}resources${/}sales_app_light_variables.robot

*** Keywords ***

Go To Salesforce
    [Documentation]     Go to SalesForce and verify the login page is displayed.
    Go To    ${LOGIN_PAGE}
    Login Page Should Be Open

Go to Sales App
    [Documentation]     Go to SalesForce and switch to salesapp menu.
    ${IsElementVisible}=    Run Keyword And Return Status    element should not be visible    ${SALES_APP_NAME}
    Run Keyword If    ${IsElementVisible}    Switch to SalesApp

Switch to SalesApp
    [Documentation]     Go to App launcher and click on SalesApp
    Click Element    ${APP_LAUNCHER}
    Wait until Page Contains Element    ${SALES_APP_LINK}    60s
    Click Element    ${SALES_APP_LINK}
    Wait Until Element is Visible    ${SALES_APP_NAME}    60s

Login Page Should Be Open
    [Documentation]     To Validate the elements in Login page
    Wait Until Keyword Succeeds    60s    1 second    Location Should Be    ${LOGIN_PAGE}
    Wait Until Element Is Visible    id=username    60s
    Wait Until Element Is Visible    id=password    60s

Go To Salesforce and Login into Lightning
    [Documentation]     Go to Salesforce and then Login as DigiSales Lightning User, then switch to Sales App
    ...     and then select the Home Tab in Menu
    [Arguments]    ${user}=DigiSales Lightning User
    Go to Salesforce
    Run Keyword    Login to Salesforce as ${user}
    Go to Sales App
    Reset to Home
    Click Clear All Notifications

Go To Salesforce and Login into Lightning User
    [Documentation]     Go to Salesforce and then Login as DigiSales Admin User, then switch to Sales App
    ...     and then select the Home Tab in Menu
    [Arguments]    ${user}=DigiSales Admin User
    Go to Salesforce
    Run Keyword    Login to Salesforce as ${user}
    Go to Sales App
    Reset to Home

Login to Salesforce as DigiSales Admin User

    Login To Salesforce Lightning    ${SALES_ADMIN_USER}    ${PASSWORD-SALESADMIN}

Login to Salesforce as DigiSales Lightning User
    [Arguments]       ${username}=${B2B_DIGISALES_LIGHT_USER}
      ...              ${password}=${Password_merge}

    Login To Salesforce Lightning    ${username}    ${password}

Login to Salesforce Lightning
    [Arguments]    ${username}    ${password}
    #log to console    ${password}
    Wait Until Page Contains Element    id=username
    Input Text    id=username    ${username}
    Input Password    id=password    ${password}
    Click Element    id=Login
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
    Log    Going to '${target}'
    Search And Select the Entity    ${target}    ${type}
    Sleep    10s    The page might load too quickly and it can appear as the search tab would be closed even though it isn't

Search And Select the Entity
    [Arguments]    ${target}    ${type}=${EMPTY}
    Search Salesforce    ${target}
    Select Entity    ${target}    ${type}

Search Salesforce
    [Arguments]    ${item}
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}    ${item}
    #Sleep    2s
    Press Enter On  ${SEARCH_SALESFORCE}
    #Press Key    xpath=${SEARCH_SALESFORCE}    \\13
    Sleep    2s
    ${IsVisible}=   Run Keyword And Return Status    Element Should Be Visible   ${SEARCH_RESULTS}      20s
    run keyword unless  ${IsVisible}    Press Enter On  ${SEARCH_SALESFORCE}
    ${IsNotVisible}=   Run Keyword And Return Status    Element Should Be Visible   ${SEARCH_RESULTS}      20s
    run keyword If  ${IsNotVisible}    Press Enter On  ${SEARCH_SALESFORCE}
    Wait Until Page Contains element    xpath=${SEARCH_RESULTS}    120s

Select Entity
    [Arguments]    ${target_name}    ${type}
    ${element_catenate} =  catenate  ${TABLE_HEADER}  [@title='${target_name}']
    Wait Until Page Contains element    ${element_catenate}   120s
    Click Element       ${element_catenate}
    #Press key      ${TABLE_HEADER}[@title='${target_name}']   //13
    Sleep   10s
    Entity Should Be Open    ${target_name}

Entity Should Be Open
    [Arguments]    ${target_name}
    Sleep   5s
    Wait Until Page Contains element    ${ENTITY_HEADER}//*[text()='${target_name}']        30s
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
    Input Quick Action Value For Attribute    Opportunity Name    ${OPPORTUNITY_NAME}
    Select Quick Action Value For Attribute    Stage    ${stage}
    Input Quick Action Value For Attribute    Close Date    ${OPPORTUNITY_CLOSE_DATE}

Input Quick Action Value For Attribute
    [Arguments]    ${field}    ${value}
    Wait Until Element Is Visible    ${NEW_ITEM_POPUP}//label//*[contains(text(),'${field}')]    60s
    Input Text    xpath=${NEW_ITEM_POPUP}//label//*[contains(text(),'${field}')]//following::input    ${value}

Select Quick Action Value For Attribute
    [Arguments]    ${field}    ${value}
    Wait Until Element Is Visible    ${NEW_ITEM_POPUP}//span[contains(text(),'${field}')]//following::div//a[@class='select']    60s
    Force Click Element    ${NEW_ITEM_POPUP}//span[contains(text(),'${field}')]//following::div//a[@class='select']
    Wait Until Element Is Visible    //div[@class='select-options']//li//a[contains(text(),'${value}')]
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
    Sleep    10s
    #Scroll Page To Location    0    1000
    Run Keyword And Continue On Failure    Scroll Page To Element    //span[text()='Opportunities']/../../span/../../../a
    ${element_xpath}=    Replace String    //span[text()='Opportunities']/../../span/../../../a    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    #Click Visible Element    //span[text()='Opportunities']/../../span/../../../a
    Verify That Opportunity Is Saved And Data Is Correct    ${RELATED_OPPORTUNITY}

Scroll Page To Location
    [Arguments]    ${x_location}    ${y_location}
    Execute JavaScript    window.scrollTo(${x_location},${y_location})
    Sleep    10s

Scroll Page To Element
    [Arguments]    ${element}
    #Run Keyword Unless    ${status}    Execsute JavaScript    window.scrollTo(0,100)
    : FOR    ${i}    IN RANGE    9999999
    \    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
    \    Execute JavaScript    window.scrollTo(0,100)
    \    Sleep    5s
    \    Exit For Loop If    ${status}

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
    ${account_name}=    Set Variable    //*[@title='Account Name']//following-sibling::div//*[text()='${LIGHTNING_TEST_ACCOUNT}']
    ${oppo_date}=    Set Variable    //*[@title='Close Date']//following-sibling::div//*[text()='${date}']
    Open Tab    Opportunities
    Select Correct View Type    My All Open Opportunities
    Filter Opportunities By    Opportunity Name    ${OPPORTUNITY_NAME}
    Sleep    10s
    Wait Until Page Contains Element    ${OPPORTUNITY_PAGE}${oppo_name}    60s
    Wait Until Page Contains Element    ${account_name}    60s
    Wait Until Page Contains Element    ${oppo_date}    60s

Open tab
    [Arguments]    ${tabName}    ${timeout}=60s
    Wait Until Element is Visible    //a[@title='${tabName}']    60s
    Click Element    //a[@title='${tabName}']
    Sleep    10s

Select Correct View Type
    [Arguments]    ${type}
    Sleep    10s
    #click element    //span[contains(@class,'selectedListView')]
    #Wait Until Page Contains Element    //span[@class=' virtualAutocompleteOptionText' and text()='${type}']    60s
    #Click Element    //span[@class=' virtualAutocompleteOptionText' and text()='${type}']//parent::a
    Select option from Dropdown with Force Click Element    //span[contains(@class,'selectedListView')]    //span[@class=' virtualAutocompleteOptionText' and text()='${type}']//parent::a
    Sleep    10s

Filter Opportunities By
    [Arguments]    ${field}    ${value}
    #${Count}=    get element count    ${RESULTS_TABLE}
    Click Element    //input[@name='search-input']
    Wait Until Page Contains Element    ${SEARCH_INPUT}    60s
    Input Text    xpath=${SEARCH_INPUT}    ${value}
    Press Key    xpath=${SEARCH_INPUT}    \\13
    Sleep    10s
    #get_all_links
    Force click element    ${RESULTS_TABLE}[contains(@class,'forceOutputLookup') and (@title='${value}')]
    #Run Keyword If    ${Count} > 1    click visible element    xpath=${RESULTS_TABLE}[contains(@class,'forceOutputLookup') and (@title='${value}')]

Go to Contacts
    Click Visible Element    ${CONTACTS_TAB}
    Wait Until Page Contains element    ${CONTACTS_ICON}    60s

Create New Master Contact
    ${first_name}=    Run Keyword    Create Unique Name    ${EMPTY}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${mobile_num}=    Run Keyword    Create Unique Mobile Number
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
    #Input Text    ${MASTER_EMAIL_FIELD}    ${MASTER_EMAIL}
    Select from Autopopulate List    ${ACCOUNT_NAME_FIELD}    ${MASTER_ACCOUNT_NAME}
    Click Element    ${SAVE_BUTTON}
    Sleep    10s
    #Validate Master Contact Details    ${CONTACT_DETAILS}

Select from Autopopulate List
    [Arguments]    ${field}    ${value}
    Input Text    ${field}    ${value}
    Sleep   10s
    Click Visible Element    //div[contains(@class,'primaryLabel') and @title='${value}']

Validate Master Contact Details
    ${contact_name}=    Set Variable    //span[text()='Name']//following::span//span[text()='${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']//following::a[text()='${MASTER_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']//following::span//span[text()='${MASTER_MOBILE_NUM}']
    ${phone_number}=    Set Variable    //span[text()='Phone']//following::span//span[text()='${MASTER_PHONE_NUM}']
    ${primary_email}=    Set Variable    //span[text()='Primary eMail']//following::a[text()='${MASTER_PRIMARY_EMAIL}']
    #${email}=    Set Variable    //span[text()='Email']//following::a[text()='${MASTER_EMAIL}']
    Go to Entity    ${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}
    Click Visible element    ${DETAILS_TAB}
    Validate Contact Details    ${CONTACT_DETAILS}    ${contact_name}    ${account_name}    ${mobile_number}    ${primary_email}
    #Wait Until Page Contains Element    ${element}${phone_number}
    #Wait Until Page Contains Element    ${element}${email}

Validate Contact Details
    [Arguments]    ${element}    ${contact_name}    ${account_name}    ${mobile_number}    ${email}
    Wait Until Page Contains Element    ${element}${contact_name}
    Wait Until Page Contains Element    ${element}${account_name}
    Wait Until Page Contains Element    ${element}${mobile_number}
    Wait Until Page Contains Element    ${element}${email}

Create New NP Contact
    ${first_name}=    Run Keyword    Create Unique Name    ${EMPTY}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${mobile_num}=    Run Keyword    Create Unique Mobile Number
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

Validate NP Contact Details
    ${contact_name}=    Set Variable    //span[text()='Name']//following::span//span[text()='Non-person ${NP_FIRST_NAME} ${NP_LAST_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']//following::a[text()='${NP_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']//following::span//span[text()='${NP_MOBILE_NUM}']
    ${email}=    Set Variable    //span[text()='Email']//following::a[text()='${NP_EMAIL}']
    Go to Entity    Non-person ${NP_FIRST_NAME} ${NP_LAST_NAME}
    Click Visible Element    ${DETAILS_TAB}
    Validate Contact Details    ${CONTACT_DETAILS}    ${contact_name}    ${account_name}    ${mobile_number}    ${email}

Create New Contact for Account
    ${first_name}=    Run Keyword    Create Unique Name    ${EMPTY}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${mobile_num}=    Run Keyword    Create Unique Mobile Number
    Set Test Variable    ${AP_FIRST_NAME}    AP ${first_name}
    Set Test Variable    ${AP_LAST_NAME}    Test ${first_name}
    Set Test Variable    ${AP_EMAIL}    ${email_id}
    Set Test Variable    ${AP_MOBILE_NUM}    ${mobile_num}
    click element    ${AP_NEW_CONTACT}
    #Sleep    2s
    Click Visible Element    ${AP_MOBILE_FIELD}
    Input Text    ${AP_MOBILE_FIELD}    ${AP_MOBILE_NUM}
    Input Text    ${FIRST_NAME_FIELD}    ${AP_FIRST_NAME}
    Input Text    ${LAST_NAME_FIELD}    ${AP_LAST_NAME}
    Input Text    ${MASTER_PRIMARY_EMAIL_FIELD}    ${AP_EMAIL}
    Click Element    ${AP_SAVE_BUTTON}
    Sleep    2s

Validate AP Contact Details
    Go To Entity    ${AP_FIRST_NAME} ${AP_LAST_NAME}    ${SEARCH_SALESFORCE}
    ${contact_name}=    Set Variable    //span[text()='Name']//following::span//span[text()='${AP_FIRST_NAME} ${AP_LAST_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']//following::a[text()='${AP_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']//following::span//span[@class="uiOutputPhone" and text()='${AP_MOBILE_NUM}']
    ${email}=    Set Variable    //span[text()='Primary eMail']//following::a[text()='${AP_EMAIL}']
    #Click Visible Element    //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    Validate Contact Details    ${CONTACT_DETAILS}    ${contact_name}    ${account_name}    ${mobile_number}    ${email}

Create Unique Mobile Number
    #${numbers}=    Generate Random String    6    [NUMBERS]
    #[Return]    +358888${numbers}
    [Return]    +358888888888

Validate Opportunity cannot be created
    [Arguments]    ${case}
    Run Keyword If    '${Case}'== 'PASSIVEACCOUNT'    Wait Until Element is Visible    ${NEW_ITEM_POPUP}//*[text()='Account is either not a Business Account or Legal Status is not Active! Please review the Account information.']
    ...    ELSE    element should not be visible    //a[@title='New Opportunity' or @title='New']

Cancel Opportunity and Validate
    [Arguments]    ${opportunity}    ${stage}
    Go to Entity    ${opportunity}
    click visible element    ${EDIT_STAGE_BUTTON}
    sleep    5s
    Select option from Dropdown    //div[@class="uiInput uiInput--default"]//a[@class="select"]    ${stage}
    #click visible element    //div[@class="uiInput uiInput--default"]//a[@class="select"]
    #Press Key    //div[@class="uiInput uiInput--default"]//a[@class="select"]    ${stage}
    #Click Element    //a[@title="${stage}"]
    Save
    Validate error message
    Cancel and save
    Validate Closed Opportunity Details    ${opportunity}    ${stage}
    Verify That Opportunity is Not Found under My All Open Opportunities    ${opportunity}

Validate Closed Opportunity Details
    [Arguments]    ${opportunity_name}    ${stage}
    #${current_date}=    Get Current Date    result_format=%d.%m.%Y
    ${current_ts}=    Get Current Date
    ${c_date} =    Convert Date    ${current_ts}    datetime
    ${oppo_close_date}=    Set Variable    //span[@title='Close Date']//following-sibling::div//span[text()='${c_date.day}.${c_date.month}.${c_date.year}']
    Go to Entity    ${opportunity_name}
    Wait Until Page Contains Element    ${oppo_close_date}    60s
    Wait Until Page Contains Element    //span[text()='Edit Stage']/../preceding::span[text()='${stage}']    60s
    ${oppo_status}=    set variable if    '${stage}'== 'Closed Lost'    Lost    Cancelled
    ${buttonNotAvailable}=    Run Keyword And Return Status    element should not be visible    ${EDIT_STAGE_BUTTON}
    Run Keyword If    ${buttonNotAvailable}    reload page
    Click Visible Element    ${EDIT_STAGE_BUTTON}
    Select option from Dropdown    //div[@class="uiInput uiInput--default"]//a[@class="select"]    Closed Won
    Save
    Wait Until Page Contains Element    //span[text()='Review the following errors']    60s
    Press ESC On    //span[text()='Review the following errors']
    click element    //*[@title='Cancel']

Save
    click element    //button[@title='Save']
    sleep    2s

Validate error message
    wait until element is visible    //a[@data-field-name="telia_Close_Comment__c"]    15s
    wait until element is visible    //a[@data-field-name="telia_Close_Reason__c"]    15s
    #element should be visible    //a[contains(text(),"Close Comment")]
    #element should be visible    //a[contains(text(),"Close Reason")]
    #element should be visible    //div[@data-aura-class="forcePageError"]

Cancel and save
    Scroll Page To Location    0    3000
    Click element    //a[contains(text(),"Close Comment")]
    Input Text    //label//span[contains(text(),"Close Comment")]/../following::textarea    Cancelling the opportunity
    Click Element    //span[text()='Close Reason']//parent::span//parent::div//div[@class='uiPopupTrigger']//a
    Click Element    //a[@title="09 Customer Postponed"]
    Save
    Sleep    2s

Edit Opportunity
    [Arguments]    ${opportunity}
    Go to Entity    ${opportunity}

Select option from Dropdown
    [Arguments]    ${list}    ${item}
    #Select From List By Value    //div[@class="uiInput uiInput--default"]//a[@class="select"]    ${item}
    click visible element    ${list}
    Press Key    ${list}    ${item}
    Sleep   3s
    force click element    //a[@title='${item}']

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
    Search And Select the Entity    ${unique_subject_task}    ${EMPTY}
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
    #Click Visible Element    xpath=${name_input_task}
    Force click element    ${name_input_task}
    Input text    xpath=${name_input_task}    ${name_input}
    sleep    10s
    click element    //*[@title='${name_input}']/../../..
    sleep    10s

Save Task and click on Suucess Message
    click element    ${save_task_button}
    sleep    30s
    click element    ${suucess_msg_task_anchor}
    sleep    40s

Validate Created Task
    [Arguments]    ${unique_subject_task_form}
    ${name_form}    get text    ${contact_name_form}    #helina kejiyu comoare
    #${related_to_form}    get text    ${related_to}    #aacon Oy ${save_opportunity}
    #log to console    ${name_form}
    ${date_due}=    Get Date From Future    7
    page should contain element    //span[@class='uiOutputDate' and text()='${date_due}']
    page should contain element    //span[@class='test-id__field-value slds-form-element__static slds-grow ']/span[@class='uiOutputText' and text()='${unique_subject_task_form}']

Enter and Select Contact Meeting
    Force click element    ${contact_name_input}
    #click element    ${contact_name_input}
    input text    ${contact_name_input}    ${name_input}
    sleep    5s
    click element    ${contact_name_select}
    sleep    5s

Create a Meeting
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
    click Element    ${NEW_EVENT_LABEL}
    #Sleep    10s
    Wait Until Page Contains element    xpath=${SUBJECT_INPUT}    40s

Enter Mandatory Info on Meeting Form
    [Arguments]    ${task_subject}
    sleep    5s
    input text    xpath=${SUBJECT_INPUT}    ${task_subject}
    sleep    5s
    click element    xpath=${EVENT_TYPE}
    click element    xpath=${meeting_select_dropdown}
    sleep    5s
    Select option from Dropdown with Force Click Element    ${reason_select_dropdown}    ${reason_select_dropdown_value}
    #click element    xpath=${reason_select_dropdown}
    #click element    xpath=${reason_select_dropdown_value}
    Enter Meeting Start and End Date
    sleep    5s
    Input Text    ${city_input}    ${DEFAULT_CITY}
    sleep    5s
    Enter and Select Contact Meeting
    sleep    5s

Enter Meeting Start and End Date
    ${date}=    Get Date From Future    1
    Set Test Variable    ${meeting_start_DATE}    ${date}
    #log to console    ${meeting_start_DATE}
    Input Text    ${meeting_start_date_input}    ${meeting_start_DATE}
    clear element text    ${meeting_start_time_input}
    input text    ${meeting_start_time_input}    ${meeting_start_time}
    ${date}=    Get Date From Future    2
    Set Test Variable    ${meeting_end_DATE}    ${date}
    Input Text    ${meeting_end_date_input}    ${meeting_end_DATE}
    clear element text    ${meeting_end_time_input}
    input text    ${meeting_end_time_input}    ${meeting_end_time}

Save Meeting and click on Suucess Message
    #click element    ${save_button_create}
    Force click element     ${save_button_create}
    sleep    30s
    #click element    ${success_message_anchor}
    Force click element     ${success_message_anchor}
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
    Click element       //div[@title='Edit']/..
    wait until page contains element        //*[contains(text(),'Edit Task')]       30s
    Sleep       5s
    Select Quick Action Value For Attribute    Meeting Outcome    Positive
    Sleep      5s
    Select Quick Action Value For Attribute    Meeting Status    Done
    input text    xpath=${description_textarea}    ${name_input}.Edited.${Meeting}
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
    Wait Until Page Contains Element    //span[contains(@class,'test-id__field-label') and (text()='${attribute}')]

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
    Click Visible Element    ${MASTER}
    click Element    ${NEXT}
    Wait Until Element is Visible    ${CONTACT_INFO}    10s
    sleep    5s
    Input Text    ${MASTER_MOBILE_NUM_FIELD}    ${MASTER_PHONE_NUM}
    Input Text    ${FIRST_NAME_FIELD}    ${MASTER_FIRST_NAME}
    Input Text    ${LAST_NAME_FIELD}    ${MASTER_LAST_NAME}
    Input Text    ${MASTER_PHONE_NUM_FIELD}    ${MASTER_PHONE_NUM}
    Input Text    ${MASTER_PRIMARY_EMAIL_FIELD}    ${MASTER_PRIMARY_EMAIL}
    Input Text    ${EMAIL_ID_FIELD}    ${MASTER_PRIMARY_EMAIL}
    Select from Autopopulate List    ${ACCOUNT_NAME_FIELD}    ${MASTER_ACCOUNT_NAME}
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
    ${contact_name}=    Set Variable    //span[text()='Name']//following::span//span[text()='${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}']
    ${business_card_text}=    Set Variable    //span[text()='Business Card Title']//following::span//span[text()='${BUSINESS_CARD}']
    ${gender_selection}=    Set Variable    //span[text()='Gender']//following::span//span[text()='${gender}']
    ${account_name}=    Set Variable    //span[text()='Account Name']//following::a[text()='${MASTER_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']//following::span//span[text()='${MASTER_MOBILE_NUM}']
    ${phone_number}=    Set Variable    //span[text()='Phone']//following::span//span[text()='${MASTER_PHONE_NUM}']
    ${primary_email}=    Set Variable    //span[text()='Primary eMail']//following::a[text()='${MASTER_PRIMARY_EMAIL}']
    ${email}=    Set Variable    //span[text()='Email']//following::a[text()='${MASTER_PRIMARY_EMAIL}']
    ${status}=    Set Variable    //span[text()='Status']//following::span//span[text()='${STATUS_TEXT}']
    ${preferred_contact}=    Set Variable    //span[text()='Preferred Contact Channel']//following::span//span[text()='${PREFERRED_CONTACT}']
    ${comm_lang}=    Set Variable    //span[text()='Communication Language']//following::span//span[text()='${COMMUNICATION_LANG}']
    ${birth_date}=    Set Variable    //span[text()='Birthdate']//following::span//span[text()='${day}.${month_digit}.${year}']
    ${last_contact_date}=    Set Variable    //span[text()='Last Contacted Date']//following::span//span[text()='${contacted_date_text}']
    ${sales_role}=    Set Variable    //span[text()='Sales Role']//following::span//span[text()='${sales_role_text}']
    ${job_title}=    Set Variable    //span[text()='Job Title Code']//following::span//span[text()='${job_title_text}']
    ${office_name_text}=    Set Variable    //span[text()='Office Name']//following::span//span[text()='${OFFICE_NAME}']
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
    Wait Until Page Contains Element    ${element}${contact_name}
    Wait Until Page Contains Element    ${element}${account_name}
    Wait Until Page Contains Element    ${element}${mobile_number}
    Wait Until Page Contains Element    ${element}${primary_email}
    Wait Until Page Contains Element    ${element}${email}
    Wait Until Page Contains Element    ${element}${status}
    Wait Until Page Contains Element    ${element}${preferred_contact}
    Wait Until Page Contains Element    ${element}${comm_lang}
    Wait Until Page Contains Element    ${element}${birth_date}
    Wait Until Page Contains Element    ${element}${last_contact_date}
    Wait Until Page Contains Element    ${element}${sales_role}
    Wait Until Page Contains Element    ${element}${job_title}
    Wait Until Page Contains Element    ${element}${office_name_text}

Validate That Contact Person Attributes Are Named Right
    ${business_card_title}=    Set Variable    //button[@title='Edit Business Card Title']/../..//span[text()='Business Card Title']
    ${name}=    Set Variable    //span[@class='uiOutputText']/../../..//span[text()='Name']
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
    ${Address}=    Set Variable    //div[contains(@class,'windowViewMode-normal')]//div[contains(@class,'test-id__section slds-section')]//span[text()='Address']
    ${External_address}=    Set Variable    //div[contains(@class,'windowViewMode-normal')]//div[contains(@class,'test-id__section slds-section')]//span[text()='External Address']
    ${3rd_Party_Contact}=    Set Variable    //button[@title='Edit 3rd Party Contact']/../..//span[text()='3rd Party Contact']
    ${external_phone}=    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//section[@class='tabs__content active uiTab']//div[contains(@class,'test-id__section slds-section')]//button[@title='Edit Phone']//parent::div/../../../../div/div/div/div/span[text()='External Phone']
    Wait Until Page Contains Element    ${business_card_title}
    Wait Until Page Contains Element    ${name}
    Wait Until Page Contains Element    ${contact_ID}
    Wait Until Page Contains Element    ${account_name}
    Wait Until Page Contains Element    ${mobile_number}
    Wait Until Page Contains Element    ${phone_number}
    Wait Until Page Contains Element    ${primary_email}
    Wait Until Page Contains Element    ${email}
    Wait Until Page Contains Element    ${status}
    Scroll Page To Location    0    200
    Wait Until Page Contains Element    ${preferred_contact_title}
    Wait Until Page Contains Element    ${comm_lang}
    Wait Until Page Contains Element    ${birth_date}
    Scroll Page To Location    0    500
    Wait Until Page Contains Element    ${sales_role}
    Wait Until Page Contains Element    ${office_name_text}
    Wait Until Page Contains Element    ${gender_text}
    Wait Until Page Contains Element    ${Address}
    Wait Until Page Contains Element    ${External_address}
    Wait Until Page Contains Element    ${3rd_Party_Contact}
    Wait Until Page Contains Element    ${external_phone}

Go To Accounts
    ${element_xpath}=    Replace String    ${ACCOUNTS_LINK}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep    2s

#Click on Account Name
 #   sleep    5s
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
    Sleep    2s
    force click element    ${item}

Click Clear All Notifications
    ${notifi_present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//*[text()='Clear All']/..
    Run Keyword If    ${notifi_present}    Clear Notifications

Clear Notifications
    click element    xpath=//*[text()='Clear All']/..

Change to original owner
    Click Button    //button[@title='Change Owner']
    sleep    8s
    Element Should Be Enabled    //input[@title='Search People']
    Wait Until Page Contains Element    //input[@title='Search People']
    Input Text    //input[@title='Search People']    ${ACCOUNT_OWNER}
    Select from Autopopulate List    //input[@title='Search People']    ${ACCOUNT_OWNER}
    Mouse Over    //button[@title='Change Owner']
    Click Element    //button[@title='Cancel']/following-sibling::button
    sleep    10s

Change Account Owner
    ${CurrentOwnerName}=  Get Text  ${OWNER_NAME}
    Click Element  ${CHANGE_OWNER}
    Wait until Page Contains Element  ${SEARCH_OWNER}
    Sleep  10s
    #Click Element  ${SEARCH_OWNER}
    #sleep  5s
    #Clear Element Text  ${SEARCH_OWNER}
    ${NewOwner}=    set variable if    '${CurrentOwnerName}'== 'Sales Admin'    B2B DigiSales     Sales Admin
    Input Text    xpath=${SEARCH_OWNER}     ${NewOwner}
    Sleep    2s
    Press Enter On   ${SEARCH_OWNER}
    Sleep   5s
    #Wait Until Page Contains element    //a[@title='${NewOwner}']   120s
    Force click element       //a[text()='${NewOwner}']
    #Wait Until Page Contains Element  ${NEW_OWNER_SELECTED}  10s
    #Select option from Dropdown with Force Click Element      ${SEARCH_OWNER}          //*[@title='${NewOwner}']
    Click Visible Element     ${CHANGE_OWNER_BUTTON}
    Sleep  20s
    ${NEW_OWNER_REFLECTED}=  Get Text  ${OWNER_NAME}
    Should Be Equal As Strings  ${NEW_OWNER_REFLECTED}  ${NewOwner}


    #${OWNER_OPTIONS}=  Set Variable  (//a[@role='option' and not(contains(., '${CurrentOwnerName}'))])
    #${Count}=    get element count    ${OWNER_OPTIONS}
    #Log To Console  No of options available as new owner:${Count}
    #${SELECT_NEW_OWNER}=  catenate  ${OWNER_OPTIONS}  [1]
    #Run Keyword If  ${Count}!=0  Click Element  ${SELECT_NEW_OWNER}
    #...          ELSE  Log to console  No Option available
#    Wait Until Page Contains Element  ${NEW_OWNER_SELECTED}  10s
#    ${NEW_OWNER_NAME}=  Get Text  ${NEW_OWNER_SELECTED}
#    Log To Console  New Owner selected:${NEW_OWNER_NAME}
#    click element  ${CHANGE_OWNER_BUTTON}
#    sleep  15s
#    ${NEW_OWNER_REFLECTED}=  Get Text  ${OWNER_NAME}
#    Sleep  20s
#    Should Be Equal As Strings  ${NEW_OWNER_REFLECTED}  ${NEW_OWNER_NAME}
#    Log to Console  Owner changed for the account



Click on a given account
    [Arguments]  ${acc_name}
    sleep  5s
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   //th[@scope='row' and contains(@class,'slds-cell-edit')]//a[@title='${acc_name}']
    Run Keyword If    ${present}    Click specific element      //th[@scope='row' and contains(@class,'slds-cell-edit')]//a[@title='${acc_name}']
    ...     ELSE    Log To Console  No account name available
    #${count}=  Get Element Count  ${ACCOUNT_NAME}
    #${elementUsed}=  Set Variable  //th[@scope='row' and contains(@class,'slds-cell-edit')]//a[@title='${acc_name}']
    #Run Keyword if  ${count}!=0  click element  ${elementUsed}
    #...         ELSE  Log To Console  No account name available
    sleep  10s

Click specific element
    [Arguments]     ${element}
    @{locators}=     Get Webelements    xpath=${element}
    ${original}=       Create List
    :FOR   ${locator}   in    @{locators}
    Click Element     xpath=${element}


Click on Account Name
    sleep  5s
    ${count}=  Get Element Count  ${ACCOUNT_NAME}
    ${elementUsed}=  Catenate  ${ACCOUNT_NAME}  [1]
    Run Keyword if  ${count}!=0  click element  ${elementUsed}
    ...         ELSE  Log To Console  No account name available
    sleep  10s





####HDC Keywords Sreeram


#################################################################################the below keywords are for hdc on jan 11 and after recent pulling


CreateAContactFromAccount_HDC
    log to console  this is to create a account from contact for HDC flow
    ${a}  create unique name   Contact_
    click element  //li/a/div[text()='New Contact']
    sleep  10s
    #click element  //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='form-element__group ']/div[@class='uiInput uiInputSelect forceInputPicklist uiInput--default uiInput--select']/div/div/div/div/a
    sleep   3s
    input text  //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='firstName compoundBorderBottom form-element__row input']     Testing
    sleep  5s
    wait until page contains element  //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='lastName compoundBLRadius compoundBRRadius form-element__row input']   60s
    clear element text  //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='lastName compoundBLRadius compoundBRRadius form-element__row input']
    #set focus to element  //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::input[@class='lastName compoundBLRadius compoundBRRadius form-element__row input']
    force click element  //input[@placeholder="Last Name"]
    input text  //input[@placeholder="Last Name"]   ${a}
    sleep  2s
    input text   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::span[text()='Primary eMail']//following::input[1]   kasibhotla.sreeramachandramurthy@teliacompany.com
    sleep  2s
    click element  //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::div[@class='modal-footer slds-modal__footer']/button/span[text()='Save']
    sleep  30s

    [return]  ${a}

CreateAOppoFromAccount_HDC

     [Arguments]   ${b}=${contact_name}
     log to console  this is to create a Oppo from contact for HDC flow
     ${oppo_name}  create unique name   Oppo_
     wait until page contains element  //li/a/div[text()='New Opportunity']   60s
     click element  //li/a/div[text()='New Opportunity']
     sleep  30s
     wait until page contains element  //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[1]   40s
     input text  //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[1]   ${oppo_name}
     sleep  3s
     ${close_date}  get date from future  10
     input text  //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[2]    ${close_date}
     sleep  7s
     input text  //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[3]     Testing ${b}
     wait until page contains element  //*[@title='Testing ${b}']/../../..   10s
     click element  //*[@title='Testing ${b}']/../../..
     sleep  2s
     input text      //textarea   ${oppo_name}.${close_date}.Description Testing
     click element  //button[@data-aura-class="uiButton"]/span[text()='Save']
     sleep  60s
     [return]  ${oppo_name}

ChangeThePriceBookToHDC
    log to console  this is to change the prioebook to HDCB2B
    sleep  30s
    Execute JavaScript    window.scrollTo(0,600)
    #scroll page to element  //button[@title="Edit Price Book"]
    click element  //button[@title="Edit Price Book"]
    sleep  10s
    click element  //div/div[10]/div[1]/div/div/div/div/div/div[2]/div/ul/li[1]/a/a
    sleep  3s
    input text   //input[@title='Search Price Books']   HDC Pricebook B2B
    sleep  3s
    click element  //*[@title='HDC Pricebook B2B']/../../..
    click element  //button[@title='Save']
    sleep  10s
    execute javascript  window.scrollTo(0,0)
    sleep  5s

ClickingOnCPQ
    ##clcking on CPQ
     [Arguments]   ${b}=${oppo_name}
    click element     xpath=//a[@title='CPQ']
    #wait until page contains element  xpath=//h1[text()='${b}']   30s
    sleep   40s

AddingProductToCartAndClickNextButton
    ##enter searcing product and click on add to cart and click on next button
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class,'cpq-searchbox')]//input[contains(@class,'ng-empty')]  60s
    #input text  xpath=//div[contains(@class,'cpq-searchbox')]//input[contains(@class,'ng-empty')]  Telia Colocation
    wait until page contains element  xpath=//p[normalize-space(.) = 'Telia Colocation']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    click element  xpath=//p[normalize-space(.) = 'Telia Colocation']/../../../div[@class='slds-tile__detail']/div/div/button
    wait until page contains element   xpath=//div[@class='cpq-item-product']/div[@class='cpq-item-base-product']/div/div/button[1]/span[@class='cpq-product-name' and text()='Telia Colocation']  60s

    wait until page contains element  xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-actions slds-text-align_right']/button  60s
    click element  xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-actions slds-text-align_right']/button
    wait until page contains element  xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-string cpq-item-text-value']/div[text()='Add']   60s
    ##page should contain element  xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-string cpq-item-text-value']/div[text()='Add']
    ##wait until page contains element  xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-string cpq-item-text-value']/div[text()='Add']   60s
    #wait until page contains element  xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']   60s
    execute javascript  window.scrollTo(0,200)
    #scroll page to element  //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    sleep  10s
    wait until page contains element  //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']   60s
    click element  xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    log to console  before teardiwn
    Unselect Frame
    sleep   60s

UpdateAndAddSalesType

    select frame  //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    wait until page contains element  xpath=//h1[normalize-space(.) = 'Update Products']    60s
    log to console  selected new frame
    wait until page contains element   xpath=//td[normalize-space(.)='Telia Colocation']  70s
    click element  xpath=//td[normalize-space(.)='Telia Colocation']//following-sibling::td/select[contains(@class,'required')]
    sleep  2s
    click element  xpath=//td[normalize-space(.)='Telia Colocation']//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    click element  xpath=//button[normalize-space(.)='Next']
    unselect frame
    sleep  60s

OpenQuoteButtonPage

    select frame  //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    log to console  selected final page frame
    wait until page contains element  //div[@class='vlc-validation-warning ng-scope']/small[contains(text(),'Quote')]   60s
    log to console  wait completed before open quote click
    wait until element is visible  //*[@id="Open Quote"]  30s
    wait until element is enabled  //*[@id="Open Quote"]   20s
    log to console  element visible next step
    click element  //*[@id="Open Quote"]
    unselect frame
    sleep   60s

CreditScoreApproving
     sleep   30s
    #credit score approval and go to home page again
    click element  //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    #wait until page contains element  //span[@class='test-id__field-label' and text()='Quote Number']  10s
    sleep  20s
    #scroll page to element  //button[@title='Edit Approval Status']
    #sleep  10s
    Execute JavaScript    window.scrollTo(0,1900)
    #Execute Javascript    window.location.reload(true)
    sleep   20s
    wait until page contains element  //button[@title='Edit Approval Status']   30s
    click element  //button[@title='Edit Approval Status']
    sleep  10s
     wait until page contains element  //div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved'][1]  30s
     wait until element is enabled  //div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved'][1]  30s
     set focus to element  //div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved'][1]
     force click element  //div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved'][1]
     Execute Javascript    window.location.reload(true)
     sleep   50s
      click element  //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
      sleep  10s
      Execute JavaScript    window.scrollTo(0,1900)
      sleep  50s
       click element  //button[@title='Edit Approval Status']
      sleep  10s
     force click element  //div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved'][1]
     sleep  5s
     force click element  //a[@title='Approved']
    sleep  2s
     #//div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved'][1]
     sleep  50s
     #Execute Javascript    window.location.reload(true)
     #sleep  40s
     #click element  //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
     #sleep  5s
     #Execute JavaScript    window.scrollTo(0,2000)
     #sleep  10s

   #  click element  //button[@title='Edit Approval Status']
   #  sleep   5s
   #  wait until page contains element  //div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved']  30s
   #  wait until element is enabled  //div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved']  30s
   #  set focus to element  //div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved']
    # force click element  //div[@class="uiMenu"]/div[@class="uiPopupTrigger"]/div/div/a[text()='Not Approved']
    #double click element
    #wait until page contains element  //div[@class='uiPopupTrigger']/div/div/a[@class='select' and @role='button'and text()='Not Approved']/..  30s
    #wait until element is visible  //div[@class='uiPopupTrigger']/div/div/a[@class='select' and @role='button'and text()='Not Approved']/..  30s
    #wait until element is enabled   //div[@class='uiPopupTrigger']/div/div/a[@class='select' and @role='button'and text()='Not Approved']/..   20
    #set focus to element  //a[@class='select' and @role='button'and text()='Not Approved']/..
    #force click element  //a[@class='select' and @role='button'and text()='Not Approved']/..
    #//div[@class='uiPopupTrigger']/div/div/a[@class='select' and @role='button'and text()='Not Approved']/..
    #Press key      ${TABLE_HEADER}[@title='${target_name}']   //13
    #Press Key    //a[@class='select' and @role='button'and text()='Not Approved']/..   //13
    #sleep   5s
    #force click element  //a[@title='Approved']
    sleep  2s
    click element  //button[@title='Save']
    sleep   20s
    Execute JavaScript    window.scrollTo(0,0)
    sleep   10s

ClickonCreateOrderButton
    #clicking on CPQ after credit score approval and click create order button this cpq not able to click so work on hold
      wait until page contains element  //a[@title='CPQ']/..   30s
     ##${expiry} =  get text  //*[text()='Expiration Date']
    ##log to console  ${expiry}
    force click element  //a[@title='CPQ']
    sleep  30s
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //span[text()='Create Order']/..  30s
    click element  //span[text()='Create Order']/..
    unselect frame
    sleep  30s

NextButtonOnOrderPage
        #click on the next button from the cart
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //span[text()='Next']/..
    click element   //span[text()='Next']/..
    unselect frame
    sleep  30s

SearchAndSelectBillingAccount
    execute javascript  window.location.reload(true)
    sleep  60s
    #Selecting the billingAC FLow chart page
    #log to console  entering billingAC page
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //*[@id="ExtractAccount"]  30s
    click element   //*[@id="ExtractAccount"]
    wait until page contains element  //label[normalize-space(.)='Select Account']  30s
    wait until page contains element  //div[text()='${vLocUpg_TEST_ACCOUNT}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']   30s
    click element  //div[text()='${vLocUpg_TEST_ACCOUNT}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    sleep  2s
    click element  //*[@id="SearchAccount_nextBtn"]
    log to console  Exiting billingAC page
    unselect frame
    sleep  30s

SelectingTechnicalContact
    [Arguments]   ${d}= ${contact_technical}
    #Selecting the Techincal COntact FLow chart page
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    log to console  entering Technical COntact  page
    wait until page contains element  //*[@id="ContactName"]  30s
    #execute javascript   window.location.reload(true)
    #reload page
    #sleep  10s
    wait until page contains element  //*[@id="ContactName"]  30s
    input text  //*[@id="ContactName"]  Testing ${d}
    click element  //*[@id="SearchContactByName"]

    wait until page contains element  //div[text()='Testing ${d}']/..//preceding-sibling::td[2]  30s
    click element            //div[text()='Testing ${d}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    sleep  5s
    click element                     //*[@id="Select Contact_nextBtn"]
    log to console  Exiting  technical  page
    unselect frame
    sleep  30s

RequestActionDate

    #selecting Requested Action Date FLow chart page
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    log to console  entering Requested action date page
    wait until page contains element  //*[@id="RequestedActionDate"]   30s
    click element  //*[@id="RequestedActionDate"]
    ${date_requested}=    Get Current Date    result_format=%m-%d-%Y
    #log to console  ${d}
    input text  //*[@id="RequestedActionDate"]    ${date_requested}
    click element  //*[@id="Additional data_nextBtn"]
    unselect frame
    log to console  Exiting  Requested Action Date page
    sleep  30s


SelectOwnerAccountInfo
   [Arguments]   ${e}= ${billing_account}
    #Select Owner Account FLow Chart Page
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    log to console  entering Owner Account page
    wait until page contains element  //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']  30s
    click element  //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    click element  //*[@id="BuyerIsPayer"]//following-sibling::span
    click element  //*[@id="SelectedBuyerAccount_nextBtn"]
    unselect frame
    log to console  Exiting  owner Account page
    sleep  30s

ReviewPage
    #Review Page FLow chart Page
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    log to console  entering Review page
    wait until page contains element  //*[@id="SubmitInstruction"]/div/p/h3/strong[contains(text(),'successfully')]   30s
    click element  //*[@id="DecomposeOrder"]
    unselect frame
    log to console  Exiting Review page
    sleep  30s

ValidateTheOrchestrationPlan

    execute javascript  window.scrollTo(0,2000)
    sleep  10s
    wait until page contains element  //th[@title='Orchestration Plan Name']//following::div[@class='outputLookupContainer forceOutputLookupWithPreview']/a
    click element  //th[@title='Orchestration Plan Name']//following::div[@class='outputLookupContainer forceOutputLookupWithPreview']/a

CreateABillingAccount
    # go to particular account and create a billing accouint from there
    wait until page contains element  //li/a/div[@title='Billing Account']   45s
    click element    //li/a/div[@title='Billing Account']
    sleep  30s
     Wait Until Page Contains Element    //div[contains(@class,'slds')]//iframe    40 seconds
    Run Keyword    Select Frame   xpath=//div[contains(@class,'slds')]//iframe
    log to console  frame selected
    sleep  10s
    #frame should contain  //div[contains(@class,'slds')]//iframe   Send Account to billing system
    #sleep  20s
    #Run Inside Iframe    //div[contains(@class,'slds')]//iframe    Click Element    //*[@id="RemoteAction1"]
    click element    xpath=//div[@id="RemoteAction1"]
    log to console  RemoteAction1 clickedselected.
    sleep   60s
    #wait until page contains element  //*[@id="Customer_nextBtn"]   60s
    #Run Inside Iframe    //div[contains(@class,'slds')]//iframe    Click Element    //*[@id="Customer_nextBtn"]
    #log to console  customer_next_btn clicked
    #current frame contains  //div[contains(@class,'slds')]/iframe
    #select frame  //div[contains(@class,'slds')]/iframe
    wait until page contains element  //*[@id="RemoteAction1"]  60s
    click element  //*[@id="RemoteAction1"]
    #unselect frame
    sleep  60s
    #current frame contains  //div[contains(@class,'slds')]/iframe
    #select frame  //div[contains(@class,'slds')]/iframe
    wait until page contains element  //*[@id="Customer_nextBtn"]   60s
    click element  //*[@id="Customer_nextBtn"]
   # unselect frame
    #select frame  xpath=//div[contains(@class,'slds')]/iframe
    sleep   60s
    current frame contains  //div[contains(@class,'slds')]/iframe
    #select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]  60s
    ${account_name_get}=  get text  //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]
    ${numbers}=     Generate Random String    4    [NUMBERS]
    input text  //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]   Billing_${vLocUpg_TEST_ACCOUNT}_${numbers}
    Execute JavaScript    window.scrollTo(0,700)
    #scroll page to element  //*[@id="billing_country"]
    click element  //*[@id="billing_country"]
    sleep  3s
    click element  //*[@id="billing_country"]/option[@value='FI']
    sleep  2s
    click element  //*[@id="Invoice_Delivery_Method"]
    sleep  3s
    click element   //*[@id="Invoice_Delivery_Method"]/option[@value='Paper Invoice']
    sleep  2s
    input text  //*[@id="payment_term"]   10
    sleep  2s
    click element  //*[@id="create_billing_account"]/p[text()='Create Billing Account']
    sleep   10s
    execute javascript  window.scrollTo(0,2100)
    #scroll page to element  //*[@id="Create Billing account_nextBtn"]/p[text()='Next']
    sleep  5s
    wait until page contains element  //*[@id="billing_account_creation_result"]/div/p[text()='Billing account added succesfully to Claudia']   30s
    force click element  //*[@id="Create Billing account_nextBtn"]/p[text()='Next']
    unselect frame
    sleep  60s
    current frame contains  //div[contains(@class,'slds')]/iframe
    #select frame  xpath=//div[contains(@class,'slds')]/iframe
    sleep  30s
    force click element  //*[@id="return_billing_account"]
    sleep  60s
    unselect frame

    [return]  Billing_${vLocUpg_TEST_ACCOUNT}_${numbers}



Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
    [Arguments]       ${username}=mmw9007@teliacompany.com.Vlocupg
                #${B2B_DIGISALES_LIGHT_USER}
     ...              ${password}=Sriram@123
                      #${Password_merge}
    Login To Salesforce Lightning    ${username}    ${password}
