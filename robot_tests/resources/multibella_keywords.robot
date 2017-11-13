*** Settings ***
Library                 Selenium2Library
Library                 libs.selenium_extensions.SeleniumExtensions.SeleniumExtensions
Library                 libs.business_id_generator.BusinessIdGenerator.BusinessIdGenerator
Library                 Screenshot

Resource                ${PROJECTROOT}${/}resources${/}common.robot

*** Variables ***
${MUBE_SERVER}                  https://replicator-mnt.stadi.sonera.fi
${MUBE_LOGOUT_URL}              ${MUBE_SERVER}/c/portal/logout
${CUSTOMERS_PAGE}               ${MUBE_SERVER}/group/crm/customers
${CONTACT_PERSONS_PAGE}         ${MUBE_SERVER}/group/crm/contact-persons
${ALL_CASES_PAGE}               ${MUBE_SERVER}/group/crm/all_cases

${ADDRESS_VALIDATION_MODAL_YES_BUTTON}    xpath=//button[contains(text(), 'Yes')]
${ANY_ELEMENT_MACHING_LOGIN_FIELDS}    //*[contains(@id, '_58_login')]
${CONTACT_PERSON_CRM_ID_FIELD}    //td[contains(text(), "CRM ID")]/following-sibling::td/div/span
${CP_SAVE_BUTTON}               xpath=(//a[contains(text(), 'Save')])[2]
${CREATE_BUTTON}                //a[contains(text(), 'Create')]
${KEYWORD_RETRY}                1 sec
${KEYWORD_WAIT}                 1 min
${LOADING_ANIMATION}            //div[contains(@class, 'loading-animation')]
${MUBE_CUSTOMER_USERNAME}       tas-cm1-1
${MUBE_CUSTOMER_PASSWORD}       5AW8w5Y5nYY11232324x2
${MUBE_ADMIN_USERNAME}          tas-cim-adm2
${MUBE_ADMIN_PASSWORD}          9XwHVkDt3FgT5511232449
${MUBE_CIM_USER}                tas-cim2
${MUBE_CIM_PASSWORD}            9XwHVkDt3dXy251123251733
${POSTAL_CODE_FIELD}            //td[contains(text(), "Postal Code")]/following-sibling::td/div/input
${DIV_CONTAINING_ALL_CASES_TEXT}    xpath=//div[@class='block-title']/a[contains(text(), 'All cases')]
${CASE_LINK}                    //td/a/span
${APPLY_FILTERS_BUTTON}         //div[@class = 'filters']//div[@class = 'button']/a[./img[contains(@src, 'search.gif')]]
${CONTACT_PERSON_LINK}          //tr/td/a[span]
${MUBE_LOGIN_FIELD}             _58_login
${MUBE_PASSWORD_FIELD}          _58_password
${FIRST_COPY_FROM_OFFICIAL_ADDRESS_BUTTON}    xpath=(//a[contains(text(), "Copy from official address")])[1]
${SECOND_COPY_FROM_OFFICIAL_ADDRESS_BUTTON}    xpath=(//a[contains(text(), "Copy from official address")])[2]
${ORDER_ID_FIELD}               //tr[2]/td[2]/div/span
${CUSTOMER_AIDA_ID_FIELD}       //td[3]/span
${SALES_CASE_STATUS_FIELD}      //td[8]/span
${LEGAL_STATUS_FIELD}           //td[contains(text(),'Legal Status')]/following-sibling::td//select
${STATUS_REASON_FIELD}          //td[contains(text(),'Status Reason')]/following-sibling::td//select
${NEW_CUSTOMER_OFFICIAL_NAME_FIELD}    //div[contains(@class, 'block-title')]/a[contains(text(), "Customer")]/parent::div/following-sibling::div[1]/table/tbody/tr/td[contains(text(), "Official Name")]

*** Keywords ***
MUBE Accept Unvalidated Address
    # Error notification only occurs if address is unvalidated.
    Run Keyword And Ignore Error    MUBE Click Element And Wait Page To Load    ${ADDRESS_VALIDATION_MODAL_YES_BUTTON}

MUBE Apply Second Filter In Page
    [Documentation]    Used when there is two filter buttons in the page
    ${xpath}=    Set Variable    (//div[@class = 'filters']//div[@class = 'button']/a[./img[contains(@src, 'search.gif')]])[2]
    Wait Until Element Is Visible    xpath=${xpath}    5s
    Execute Javascript    document.evaluate("${xpath}", document, null, XPathResult.ANY_TYPE, null).iterateNext().click();
    MUBE Wait For Load

MUBE Change Customer Legal Status To Passived
    [Arguments]     ${businessid}
    MUBE Open Customers Page
    MUBE Select Customer    ${businessid}
    MUBE Click Left Panel Link      Change Business Customer Data
    MUBE Wait For Load
    Select From List By Value       ${LEGAL_STATUS_FIELD}       TS_LEGAL_STATUS.PASSIVE
    MUBE Wait For Load
    Select From List By Value       ${STATUS_REASON_FIELD}      TS_STATUS_REASON.BANKRUPTCY
    MUBE Wait For Load
    MUBE Click Blue Button          Save Changes
    MUBE Verify That Customer Order Status Is Set To Finished

MUBE Check History Description Value Should Not Be Empty
    ${passed}=    Run Keyword And Return Status    MUBE Set Filter Select    Attribute name    Description
    Run Keyword Unless    ${passed}    MUBE Set Filter Select    Attribute name    -- Any --
    MUBE Apply Second Filter In Page
    ${base_xpath}=      Set Variable    //tr/td/span[contains(translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), translate('Description', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))]
    Wait Until Element Is Visible    ${base_xpath}    5 s
    Page Should Contain Element     ${base_xpath}/../following-sibling::td/span[contains(text(), '')]/../following-sibling::td//iframe

MUBE Check History Old And New Value For Contact Person Attribute
    [Arguments]    ${attribute}    ${old_value}    ${new_value}
    Wait Until Keyword Succeeds    20 s    2 s    MUBE Select Contact Person And Verify Attributes From History    ${attribute}    ${old_value}    ${new_value}

MUBE Check History Old And New Value For Attribute
    [Arguments]    ${attribute}    ${old_value}    ${new_value}
    [Documentation]    Ensure that you are on the history tab before running this keyword.
    Wait Until Keyword Succeeds    20 s    2 s    MUBE Filter History By Attribute And Verify Change    ${attribute}    ${old_value}    ${new_value}

MUBE Choose Button "New Contact Person" And Fill Mandatory Data
    [Documentation]    Fill mandatory contact person data with given or generated data. Sets lastname of crated contact
    ...    person as test variable '${TEST_CONTACT_PERSON_LAST_NAME}'. First and last name can be given or use
    ...    the values generated by this keyword.
    [Arguments]     ${first_name}=${EMPTY}
    ...             ${last_name}=${EMPTY}
    ...             ${language}=${DEFAULT_LANGUAGE}
    ...             ${email}=${DEFAULT_EMAIL}
    ...             ${phone_number}=${DEFAULT_PHONE}
    ${name}=    Create Unique Name    Contact Person
    ${first_name}=    Set Variable If     '${first_name}' == '${EMPTY}'    Test         ${first_name}
    ${last_name}=     Set Variable If     '${last_name}' == '${EMPTY}'     ${name}      ${last_name}
    MUBE Click Blue Button    New contact person
    Set Test Variable    ${TEST_CONTACT_PERSON_LAST_NAME}    ${last_name}
    MUBE Fill Mandatory Contact Person Values With First And Lastname
    ...    ${first_name}
    ...    ${TEST_CONTACT_PERSON_LAST_NAME}
    ...    ${language}
    ...    ${email}
    ...    ${phone_number}

MUBE Choose From Main Menu Customer And Choose From List Proper Record
    [Arguments]    ${customer_businessid}
    MUBE Open Customers Page
    MUBE Select Customer    ${customer_businessid}

MUBE Click Add New Business Customer
    [Documentation]    Tries to click new customer icon on right panel
    MUBE Click Left Panel Link    Create New Business Customer
    Page Should Contain Element     ${NEW_CUSTOMER_OFFICIAL_NAME_FIELD}

MUBE Click Address Validation Modal Yes Button
    MUBE Click Element And Wait Page To Load    ${ADDRESS_VALIDATION_MODAL_YES_BUTTON}
    # Sleep    2 s

MUBE Click Apply Filters
    [Documentation]    We need to click the element with javascript because sometimes navigation list hides the filtering button if we don't do so. Doesn't work with ie10.
    MUBE Click Element With Javascript    ${APPLY_FILTERS_BUTTON}

MUBE Click Blue Button
    [Arguments]    ${title}
    [Documentation]    Click blue button on page which title contains ${title}
    ${xpath}=    Set Variable    //div[@id = 'content-wrapper']//div[@class = 'buttons']/div[@class = 'button']/a[contains(text(), '${title}')]
    MUBE Click Element With Javascript    ${xpath}

MUBE Click Element And Wait Page To Load
    [Arguments]    ${element}
    Wait Until Element Is Visible    ${element}    10 s
    Click Element    ${element}
    MUBE Wait For Load

MUBE Click Element With Javascript
    [Documentation]    This keyword doesn't work well with ie 10. Locator expression must contain only single quotes.
    ...    The 'xpath=' expression can't be used with this keyword.
    [Arguments]    ${xpath}
    Wait Until Page Contains Element     ${xpath}    15 s
    Execute Javascript    document.evaluate("${xpath}", document, null, XPathResult.ANY_TYPE, null).iterateNext().click();
    Sleep    1 s
    MUBE Wait For Load

MUBE Click Left Panel Link
    [Arguments]     ${name}
    [Documentation]    Clicks link on left panel by comparing given text to tooltip of icon
    # Wait Until Keyword Succeeds    60 s    10 s    Click Element    xpath=//div[contains(@class, 'panel-content')]//a[./div[contains(text(), '${name}')]]
    Focus           xpath=//div[contains(@class, 'panel-content')]//a[./div[contains(text(), '${name}')]]
    Press Enter on    xpath=//div[contains(@class, 'panel-content')]//a[./div[contains(text(), '${name}')]]
    MUBE Wait For Load

MUBE Check Order Status
    MUBE Set Filter Input    Order ID    ${CREATE_CUSTOMER_ORDER_ID}
    MUBE Click Apply Filters
    Element Should Contain    //td[3]/span    Finished

MUBE Contact Person Should Be Found X Times
    [Arguments]     ${contact_person_last_name}     ${times}=1
    Go To    ${CONTACT_PERSONS_PAGE}
    MUBE Wait For Load
    MUBE Set Filter Input    Name    ${contact_person_last_name}
    MUBE Click Apply Filters
    Wait Until Element Is Visible    ${CONTACT_PERSON_LINK}[./span[contains(text(),'${contact_person_last_name}')]]    10 s
    Xpath Should Match X Times      ${CONTACT_PERSON_LINK}[./span[contains(text(),'${contact_person_last_name}')]]      ${times}

MUBE Create New Business Customer With Language
    [Documentation]    Generates new business customer with given language and official name (optional).
    ...    Variable "NEW_CUSTOMER_BUSINESS_ID" contains the new business customer business id
    ...    after creation (variable set in MUBE Generate Business Id And Verify That It Doesn't Exist Already In The System).
    [Arguments]    ${language}    ${official_name}=${EMPTY}
    MUBE Generate Unique Business Id For The Customer
    ${new_customer_name}=    Create Unique Name    Customer
    ${customer}=        Set Variable If     "${official_name}" == "${EMPTY}"   ${new_customer_name}     ${official_name}
    Set Suite Variable   ${NEW_CUSTOMER_NAME}    ${customer}
    Wait Until Keyword Succeeds    30s    5s    MUBE Click Add New Business Customer
    MUBE Set Form Input    Customer    Official Name    ${NEW_CUSTOMER_NAME}
    MUBE Set Form Input    Customer    Business ID    ${NEW_CUSTOMER_BUSINESS_ID}
    MUBE Set Form Input    Contact Information    Main Phone Number    8881234
    MUBE Set Form Select    Contact Information    Language    ${language}
    MUBE Fill In Address Information
    MUBE Fill In Address Information    Visiting Address
    MUBE Click Blue Button    Create Customer
    # Sleep    1 s
    MUBE Wait For Load
    # For some reason address input field data is cleared if the planets and the galaxy aren't aligned. So we must try again.
    ${status}=    Run Keyword And Return Status    MUBE Click Address Validation Modal Yes Button
    Run Keyword If    ${status}    MUBE Fill In Address Again And Finish Creation
    MUBE Verify That Customer Order Status Is Set To Finished

MUBE Create New Contact Person For Business Customer
    [Documentation]    Create contact person for customer pointed by the given business id.
    ...    Only mandatory argument is '{customer_businessid}'. Rest of the arguments are optional and they will be
    ...    generated/defaults used if left out. Following suite variables are created after this keyword:
    ...    '${TEST_CONTACT_PERSON_LAST_NAME}' and  '${CONTACT_PERSON_CRM_ID}'.
    [Arguments]     ${customer_businessid}
    ...             ${first_name}=${EMPTY}
    ...             ${last_name}=${EMPTY}
    ...             ${language}=${DEFAULT_LANGUAGE}
    ...             ${email}=${DEFAULT_EMAIL}
    ...             ${phone_number}=8881234     # MUBE disallows +358 starting phone numbers
    ...             ${street_name}=${DEFAULT_STREET_NAME}
    ...             ${street_number}=${DEFAULT_STREET_NUMBER}
    ...             ${staircase}=${DEFAULT_STAIRCASE}
    ...             ${apartment_door}=${DEFAULT_APPARTMENT}
    ...             ${postal_code}=${DEFAULT_POSTAL_CODE}
    ...             ${city}=${DEFAULT_CITY}
    MUBE Choose From Main Menu Customer And Choose From List Proper Record    ${customer_businessid}
    MUBE In Context Of Customer Choose From Menu "Contact Person"
    MUBE Choose Button "New Contact Person" And Fill Mandatory Data    ${first_name}    ${last_name}    ${language}    ${email}    ${phone_number}
    MUBE Fill Address Information With Address Type    Physical    ${street_name}    ${street_number}    ${staircase}    ${apartment_door}    ${postal_code}    ${city}
    Wait Until Keyword Succeeds    10s      2s      MUBE Save Contact Person
    MUBE Accept Unvalidated Address
    MUBE Handle Contact Person With Email Exists Notification
    MUBE Get Contact Person Crm Id

MUBE Customer Search Is Complete
    Wait Until Keyword Succeeds    30 s    5 s    Wait Until Page Contains Element    ${XPATH_COMPANY_NAME}

MUBE Fill Address Information With Address Type
    [Documentation]    Fills contact persons address information. Address can be set to physical or po box location.
    ...    Address type argument is mandatory. Other arguments are optional.
    [Arguments]     ${address_type}
    ...             ${street_name}=${DEFAULT_STREET_NAME}
    ...             ${street_number}=${DEFAULT_STREET_NUMBER}
    ...             ${staircase}=${DEFAULT_STAIRCASE}
    ...             ${apartment_door}=${DEFAULT_APPARTMENT}
    ...             ${postal_code}=${DEFAULT_POSTAL_CODE}
    ...             ${city}=${DEFAULT_CITY}
    Wait Until Keyword Succeeds    30s    5s    MUBE Select Address Type    ${address_type}
    MUBE Set Form Input    Address    Postal Code    ${postal_code}
    Sleep    1 s
    MUBE Set Form Input    Address    City    ${city}
    Run Keyword If    '${address_type}' == 'Physical'
    ...    MUBE Set Address Information    ${street_name}   ${street_number}    ${staircase}    ${apartment_door}
    Run Keyword If    '${address_type}' == 'PO Box'    MUBE Set Form Input And Press Enter    Address    PO Box Number    347

MUBE Fill In Address Again And Finish Creation
    MUBE Wait For Load
    MUBE Fill In Address Information
    MUBE Fill In Address Information    Visiting Address
    MUBE Click Blue Button    Create Customer
    Sleep    2 s
    MUBE Click Address Validation Modal Yes Button
    Run Keyword And Ignore Error    MUBE Click Address Validation Modal Yes Button

MUBE Fill In Address Information
    [Arguments]     ${address_type}=Official Address
    ...             ${postal_code}=${DEFAULT_POSTAL_CODE}
    ...             ${city}=${DEFAULT_CITY}
    ...             ${street}=${DEFAULT_STREET_NAME}
    ...             ${street_number}=${DEFAULT_STREET_NUMBER}
    Sleep    3    Wait For Load
    MUBE Set Form Select    ${address_type}    Address Type    Physical
    MUBE Set Form Input     ${address_type}    Postal Code     ${postal_code}
    Sleep    1 s
    MUBE Set Form Input     ${address_type}    City            ${city}
    Sleep    1 s
    MUBE Set Form Input     ${address_type}    Street Name     ${street}
    MUBE Set Form Input     ${address_type}    Street Number   ${street_number}
    # Sleep    3    Wait For Load
    Wait Until Page Contains Element    ${FIRST_COPY_FROM_OFFICIAL_ADDRESS_BUTTON}
    Wait Until Keyword Succeeds    30 s    5 s    Click Element    ${FIRST_COPY_FROM_OFFICIAL_ADDRESS_BUTTON}
    # Sleep    3    Wait For Page/Ajax To Finish Loading
    Wait Until Page Contains Element    ${SECOND_COPY_FROM_OFFICIAL_ADDRESS_BUTTON}
    Wait Until Keyword Succeeds    30 s    5 s    Click Element    ${SECOND_COPY_FROM_OFFICIAL_ADDRESS_BUTTON}
    # Sleep    3    Wait For Page/Ajax To Finish Loading

MUBE Fill Mandatory Contact Person Values With First And Lastname
    [Arguments]     ${firstname}
    ...             ${lastname}
    ...             ${language}=${DEFAULT_LANGUAGE}
    ...             ${email}=${DEFAULT_EMAIL}
    ...             ${phone_number}=${DEFAULT_PHONE}
    ${email}=       Create Unique Email     ${email}
    Wait Until Keyword Succeeds    30 s    5 s    MUBE Set Form Select      General Information    Language         ${language}
    Wait Until Keyword Succeeds    30 s    5 s    MUBE Set Form Input       General Information    Last Name        ${lastname}
    Wait Until Keyword Succeeds    30 s    5 s    MUBE Set Form Input       General Information    First Name       ${firstname}
    Wait Until Keyword Succeeds    30 s    5 s    MUBE Set Form Input       General Information    Phone Number     ${phone_number}
    Wait Until Keyword Succeeds    30 s    5 s    MUBE Set Form Input       General Information    Mobile Phone     ${phone_number}
    Wait Until Keyword Succeeds    30 s    5 s    MUBE Set Form Input       General Information    E-mail           ${email}

MUBE Filter History By Attribute And Verify Change
    [Arguments]    ${attribute}    ${old_value}    ${new_value}
    [Documentation]    Expects that you are in the history tab.
    ${passed}=    Run Keyword And Return Status    MUBE Set Filter Select    Attribute name    ${attribute}
    Run Keyword Unless    ${passed}    MUBE Set Filter Select    Attribute name    -- Any --
    MUBE Apply Second Filter In Page
    ${base_xpath}=      Set Variable    //tr/td/span[contains(translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), translate('${attribute}', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))]
    Wait Until Element Is Visible    ${base_xpath}    5 s
    Element Text Should Be    ${base_xpath}/../following-sibling::td/span[contains(text(), '${old_value}')]/../following-sibling::td/span[contains(text(), '${new_value}')]    ${new_value}

MUBE Filter History Of Contact Person By Attribute And Verify Change
    [Arguments]    ${attribute}    ${old_value}    ${new_value}
    [Documentation]    Filter attribute if found from list otherwise just checks the history table
    ${passed}=    Run Keyword And Return Status    MUBE Set Filter Select    Attribute name    ${attribute}
    Run Keyword Unless    ${passed}    MUBE Set Filter Select    Attribute name    -- Any --
    MUBE Apply Second Filter In Page
    ${xpath}=       Set Variable If     '${attribute}'=='Main Phone Number'
    ...            //tr/td/span[contains(translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), translate('Phone Number', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))]
    ...            //tr/td/span[contains(translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), translate('${attribute}', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))]
    ${old_value_xpath}=     Set Variable    ../following-sibling::td/span[contains(text(), '${old_value}')]
    ${new_value_xpath}=     Set Variable    ../following-sibling::td/span[contains(text(), '${new_value}')]
    Wait Until Element Is Visible    ${xpath}   5 s
    Element Text Should Be           ${xpath}/${old_value_xpath}/${new_value_xpath}    ${new_value}

MUBE Generate Business Id And Verify That It Doesn't Exist Already In The System
    [Documentation]     Generates a random Business ID (from business_id_generator library), verifies it doesn't
    ...                 exist in the system and sets the value in 'NEW_CUSTOMER_BUSINESS_ID' test variable.
    ${new_customer_business_id}=    Generate Business Id
    MUBE Open Customers Page
    MUBE Set Filter Input    Business ID    ${new_customer_business_id}
    MUBE Click Apply Filters
    Element Should Contain    css=div.portlet-msg-nodata    No data to display.
    Set Test Variable    ${NEW_CUSTOMER_BUSINESS_ID}    ${new_customer_business_id}

MUBE Generate Unique Business Id For The Customer
    Wait Until Keyword Succeeds    6 min    15 s    MUBE Generate Business Id And Verify That It Doesn't Exist Already In The System

MUBE Get Contact Person Crm Id
    [Documentation]     Sets a new Test Variable 'CONTACT_PERSON_CRM_ID'
    Wait Until Element Is Visible    ${CONTACT_PERSON_CRM_ID_FIELD}    30 s
    ${cp_crm_id}=    Get Text    ${CONTACT_PERSON_CRM_ID_FIELD}
    Set Test Variable    ${CONTACT_PERSON_CRM_ID}    ${cp_crm_id}

MUBE Get Customer AIDA ID
    [Documentation]    Get Customer AIDA ID and set it available to '${CUSTOMER_AIDA_ID}' test variable.
    ...    After AIDA ID creation customer is created successfully. It can some times
    ...    take a long time for the AIDA ID to be generated. Keyword expects customers business id to exist in the
    ...    '${NEW_CUSTOMER_BUSINESS_ID}' variable.
    Wait Until Keyword Succeeds    11 min    30 s    MUBE Select Customer And Get AIDA ID

MUBE Get Customer Order Id
    [Documentation]     Sets a new Test Variable 'CREATE_CUSTOMER_ORDER_ID'
    Wait Until Page Contains Element    ${ORDER_ID_FIELD}
    ${order_id}=    Get Text    ${ORDER_ID_FIELD}
    Set Test Variable     ${CREATE_CUSTOMER_ORDER_ID}    ${order_id}

MUBE Get VarValue
    [Documentation]     Returns value for 'a' if not None, otherwise returns value from 'b'
    [Arguments]    ${a}    ${b}
    Return From Keyword If    '${a}' != 'None'    ${a}
    [Return]       ${b}

MUBE Go To CRM Login Page And Login As CM User
    Go To       ${MUBE_SERVER}
    MUBE Login As CM User

MUBE Handle Contact Person With Email Exists Notification
    # Error notification only occurs if contact person with same email exists.
    ${notification_exists}=    Run Keyword And Return Status
    ...    Page Should Contain
    ...    Possible duplicate Contact Persons found. Please select to create, if you want to create a new Contact Person
    Run Keyword If    ${notification_exists}    Click Element    ${CREATE_BUTTON}

MUBE Handle Login
    [Arguments]    ${username}    ${password}
    Wait Until Page Contains Element    ${MUBE_LOGIN_FIELD}
    Run Keyword And Ignore Error    Set Global Variable    ${USED_USERNAME}    ${username}
    Run Keyword And Ignore Error    Set Global Variable    ${USED_PASSWORD}    ${password}
    Prolonged Input Text    ${MUBE_LOGIN_FIELD}    ${used_username}
    Input Password    ${MUBE_PASSWORD_FIELD}    ${used_password}
    Submit Form    _58_fm
    MUBE Wait For Load
    Wait Until Page Does Not Contain Element    ${MUBE_LOGIN_FIELD}     10s
    Element Should Not Be Visible    ${MUBE_PASSWORD_FIELD}

MUBE In Context Of Customer Choose From Menu "Contact Person"
    MUBE Open Tab    Contact Persons

MUBE Log In CRM
    [Arguments]    ${username}    ${password}
    [Documentation]    Log user in with ${username} and ${password}
    Wait Until Keyword Succeeds    1 min    10 s    MUBE Handle Login    ${username}    ${password}

MUBE Log In If Session Has Ended
    ${count}=    Get Matching Xpath Count    ${ANY_ELEMENT_MACHING_LOGIN_FIELDS}
    Run Keyword If    "${count}" == "1"    MUBE Log In CRM    ${USED_USERNAME}    ${USED_PASSWORD}

MUBE Login As CM User
    MUBE Log In CRM    ${MUBE_CUSTOMER_USERNAME}    ${MUBE_CUSTOMER_PASSWORD}

MUBE Login As CIM User
    Mube Log In CRM    ${MUBE_CIM_USER}     ${MUBE_CIM_PASSWORD}

MUBE Logout CRM
    Go To    ${MUBE_LOGOUT_URL}

MUBE Open All Cases Page
    [Documentation]    Open Cases > All Cases
    Go To    ${ALL_CASES_PAGE}
    Wait Until Page Contains Element    ${DIV_CONTAINING_ALL_CASES_TEXT}

MUBE Open Browser And Go To CRM Login Page
    [Documentation]    Open browser and goes to ${MUBE_SERVER}
    Open Browser And Go To Login Page   ${MUBE_SERVER}


MUBE Open Browser And Login As CM User
    MUBE Open Browser And Go To CRM Login Page
    MUBE Login As CM User

MUBE Open Browser And Login As CIM User
    MUBE Open Browser And Go To CRM Login Page
    MUBE Login As CIM User

MUBE Open Customers Page
    [Documentation]    Open Customers > Customers
    MUBE Log In If Session Has Ended
    Go To    ${CUSTOMERS_PAGE}
    MUBE Wait Until Page Is Loaded    Customers    Overview

MUBE Open Tab
    [Arguments]    ${title}
    [Documentation]    Open tab ${title}
    ${xpath}=    Set Variable    //div[contains(@class, 'tab')]/a[contains(text(), '${title}')]
    MUBE Click Element With Javascript    ${xpath}
    Wait Until Element Is Visible    //div[contains(@class, "selected")]/a[contains(text(), "${title}")]    5 s

MUBE Save Contact Person
    Run Keyword And Ignore Error    Click Visible Element    ${CP_SAVE_BUTTON}
    Sleep   2
    MUBE Wait For Load
    ${unvalidated_address}=     Run Keyword And Return Status   Element Should Be Visible    ${ADDRESS_VALIDATION_MODAL_YES_BUTTON}
    ${update_button}=           Run Keyword And Return Status   Element Should Be Visible    //a[contains(text(), 'Update')]
    Run Keyword Unless     ${unvalidated_address} or ${update_button}   Run Keywords    Capture Page Screenshot     AND     Fail

MUBE Search And Select Customer With Name
    [Arguments]    ${partial_name}
    MUBE Set Filter Input    Customer name    ${partial_name}
    # Mouse Over    xpath=//span[@class = 'key']
    MUBE Click Apply Filters
    ${xpath_company_name}=    Set Variable    xpath=//form/div/table/tbody/tr[1]/td/a
    Set Global Variable    ${XPATH_COMPANY_NAME}     ${xpath_company_name}
    ${xpath_company_name_text}=    Get Text    ${XPATH_COMPANY_NAME}/span
    Set Global Variable    ${XPATH_COMPANY_NAME_TEXT}     ${xpath_company_name_text}
    ${xpath_business_id}=    Get Text    xpath=//tr[1]/td[3]/span
    Set Global Variable    ${XPATH_BUSINESS_ID}     ${xpath_business_id}
    MUBE Customer Search Is Complete
    Sleep    5    Wait For Load
    Click Element   ${XPATH_COMPANY_NAME}
    Wait Until Page Contains Element    xpath=//div[@class='content-wrapper']//div/*[contains(text(), '${xpath_business_id}')]
    MUBE Wait For Load

MUBE Search Customer
    [Arguments]    ${businessid}
    ${xpath_company_name}=    Set Variable    xpath=//td[./span[contains(text(), '${businessid}')]]/preceding-sibling::td/a
    Set Global Variable    ${XPATH_COMPANY_NAME}     ${xpath_company_name}
    MUBE Set Filter Input    Business ID    ${businessid}
    Mouse Over    banner
    MUBE Click Apply Filters
    MUBE Customer Search Is Complete
    Sleep    5    Wait For Load
    Click Element   ${XPATH_COMPANY_NAME}
    Wait Until Page Contains Element    xpath=//div[@class='content-wrapper']//*[contains(text(), '${businessid}')]
    MUBE Wait For Load

MUBE Select Customer
    [Arguments]    ${businessid}
    [Documentation]    Select company by business id. If not in customers page, use keyword Open Customers Page to open it.
    Wait Until Keyword Succeeds    30s    5s    MUBE Search Customer    ${businessid}

MUBE Select Customer And Get AIDA ID
    MUBE Open Customers Page
    MUBE Select Customer    ${NEW_CUSTOMER_BUSINESS_ID}
    MUBE Open Tab    History
    MUBE Verify That AIDA ID Has Been Generated For Customer
    ${aida_id}=    Get Text    ${CUSTOMER_AIDA_ID_FIELD}
    Set Test Variable    ${CUSTOMER_AIDA_ID}    ${aida_id}

MUBE Select Address Type
    [Arguments]    ${address_type}
    MUBE Set Form Select    Address    Address Type    ${address_type}
    Element Should Be Visible    ${POSTAL_CODE_FIELD}

MUBE Select Contact Person
    [Arguments]    ${contact_person_last_name}
    Go To    ${CONTACT_PERSONS_PAGE}
    MUBE Wait For Load
    MUBE Set Filter Input    Name    ${contact_person_last_name}
    MUBE Click Apply Filters
    MUBE Click Element And Wait Page To Load    ${CONTACT_PERSON_LINK}[./span[contains(text(),'${contact_person_last_name}')]]
    MUBE Click Blue Button    Refresh data

MUBE Select Contact Person And Verify Attributes From History
    [Arguments]    ${attribute}    ${old_value}    ${new_value}
    [Documentation]    Test Contact Person Last Name Should be set to variable ${TEST_CONTACT_PERSON_LAST_NAME}
    MUBE Select Contact Person    ${TEST_CONTACT_PERSON_LAST_NAME}
    Wait Until Keyword Succeeds    30 s    5 s    MUBE Open Tab    History
    MUBE Filter History Of Contact Person By Attribute And Verify Change    ${attribute}    ${old_value}    ${new_value}

MUBE Set Address Information
    [Arguments]     ${street_name}      ${street_number}    ${staircase}    ${apartment_door}
    MUBE Set Form Input And Press Enter    Address    Street Name       ${street_name}
    MUBE Set Form Input And Press Enter    Address    Street Number     ${street_number}
    MUBE Set Form Input And Press Enter    Address    Staircase         ${staircase}
    MUBE Set Form Input     Address    Appartment Door   ${apartment_door}

MUBE Set Filter Input
    [Arguments]    ${title}    ${value}
    ${xpath}=    Set Variable    xpath=//div[@class = 'field' and ./label[contains(translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), translate("${TITLE}", 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))]]//input
    Wait Until Page Contains Element    ${xpath}
    Prolonged Input Text    ${xpath}    ${value}

MUBE Set Filter Select
    [Arguments]    ${title}    ${value}
    ${xpath}=    Set Variable    xpath=//div[@class = 'field' and ./label[contains(text(), "${title}")]]//select
    Select From List By Label    ${xpath}    ${value}

MUBE Set Form Input
    [Arguments]    ${block}    ${field}    ${value}
    [Documentation]    Set value of textfield on form to ${value}
    ${xpath_default}=    Set Variable    xpath=//div[contains(@class, "block-title")]/a[contains(text(), "${block}")]/parent::div/following-sibling::div[1]/table/tbody/tr/td[contains(text(), "${field}")]/following-sibling::td[1]/div//input[@type="text"]
    ${xpath_noblock}=    Set Variable If    len("${block}") == 0    xpath=//td[contains(text(), "${field}")]/following-sibling::td[1]/div//input[@type="text"]
    ${xpath}=    MUBE Get VarValue    ${xpath_noblock}    ${xpath_default}
    Wait Until Element Is Visible    ${xpath}
    Click Element    ${xpath}
    MUBE Wait For Load
    Prolonged Input Text    ${xpath}    ${value}
    Press Tab On    ${xpath}
    MUBE Wait For Load

MUBE Set Form Input And Press Enter
    [Arguments]    ${block}    ${field}    ${value}
    [Documentation]    Set value of textfield on form to ${value} and verifies that field is also filled (used to be really problematic)
    ${xpath_default}=    Set Variable       //div[contains(@class, 'block-title')]/a[contains(text(), "${block}")]/parent::div/following-sibling::div[1]/table/tbody/tr/td[contains(text(), "${field}")]/following-sibling::td[1]/div//input[@type="text"]
    ${xpath_noblock}=    Set Variable If    len("${block}") == 0    //td[contains(text(), "${field}")]/following-sibling::td[1]/div//input[@type="text"]
    ${xpath}=    MUBE Get VarValue    ${xpath_noblock}    ${xpath_default}
    Wait Until Element Is Visible    ${xpath}
    Click Element    ${xpath}
    MUBE Wait For Load
    Prolonged Input Text    ${xpath}    ${value}
    Press Enter On    ${xpath}
    MUBE Wait For Load

MUBE Set Form Select
    [Arguments]    ${block}    ${field}    ${value}
    [Documentation]    Select correct option from select on form
    ${xpath_default}=    Set Variable   xpath=//div[contains(@class, 'block-title')]/a[contains(text(), "${block}")]/parent::div/following-sibling::div[1]/table/tbody/tr/td[contains(text(), "${field}")]/following-sibling::td[1]/div/select
    ${xpath_noblock}=    Set Variable If    len("${block}") == 0    xpath=//td[contains(text(), "${field}")]/following-sibling::td[1]/div/select
    ${xpath}=    MUBE Get VarValue      ${xpath_noblock}    ${xpath_default}
    Wait Until Element Is Visible       ${xpath}
    Run Keyword If    "${value}" == "-random-"    MUBE Set Form Select Random Option    ${block}    ${field}
    ...                         ELSE              Select From List By Label             ${xpath}    ${value}
    MUBE Wait For Load

MUBE Set Form Select Random Option
    [Arguments]    ${block}    ${field}
    [Documentation]    Select random option from select
    ${xpath_default}=    Set Variable    xpath=//div[contains(@class, 'block-title')]/a[contains(text(), "${block}")]/parent::div/following-sibling::div[1]/table/tbody/tr/td[contains(text(), "${field}")]/following-sibling::td[1]/div/select
    ${xpath_noblock}=    Set Variable If    len("${block}") == 0    xpath=//tr/td[contains(text(), "${field}")]/following-sibling::td[1]/div/select
    ${xpath}=    MUBE Get VarValue    ${xpath_noblock}    ${xpath_default}
    Wait Until Element Is Visible    ${xpath}
    Select Random Option    ${xpath}

MUBE Terminate Customer
    [Arguments]     ${businessid}
    MUBE Open Customers Page
    MUBE Select Customer    ${businessid}
    MUBE Click Left Panel Link      Terminate customer
    MUBE Wait For Load
    MUBE Click Blue Button          Terminate customer
    MUBE Wait For Load
    MUBE Verify That Customer Order Status Is Set To Finished

MUBE Verify That AIDA ID Has Been Generated For Customer
    MUBE Set Filter Select    Attribute name    AIDA ID
    MUBE Click Apply Filters
    Wait Until Element Is Visible       ${CUSTOMER_AIDA_ID_FIELD}
    Should Not Be Empty    Get Text     ${CUSTOMER_AIDA_ID_FIELD}

MUBE Verify That Business Customer Is Terminated
    [Arguments]     ${businessid}=${NEW_CUSTOMER_BUSINESS_ID}
    MUBE Open Customers Page
    MUBE Select Customer    ${businessid}
    MUBE Open Tab      Details
    Page Should Contain Element     //td[contains(text(),'Status in CRM')]/following-sibling::td//span[text()='Terminated']

MUBE Verify That Case Exists in MuBe
    MUBE Open All Cases Page
    MUBE Set Filter Input    Case no    ${MUBE_CASE_ID}
    MUBE Click Apply Filters
    MUBE Click Element And Wait Page To Load    ${CASE_LINK}

MUBE Verify That Customer Order Status Is Set To Finished
    Wait Until Keyword Succeeds    30 s     5 s     MUBE Get Customer Order Id
    # Customer creation order can take some time to finish. Especially if there is a mass process going on at the same time.
    Wait Until Keyword Succeeds    10 min   15 s    MUBE Check Order Status

MUBE Verify That Case Attributes Are Populated Correctly
    Element Should Contain    ${SALES_CASE_STATUS_FIELD}    New
    MUBE Open Tab    History
    MUBE Check History Old And New Value For Attribute    Customer    ${EMPTY}    ${DEFAULT_TEST_ACCOUNT}
    MUBE Check History Old And New Value For Attribute    Reporter    ${EMPTY}    b2b selfcare (b2bselfcare)
    MUBE Check History Old And New Value For Attribute    Type    ${EMPTY}    Orders and deliveries
    MUBE Check History Old And New Value For Attribute    Subtype    ${EMPTY}    New, change or termination
    MUBE Check History Old And New Value For Attribute    Actual Reason    ${EMPTY}    New subscription / service
    MUBE Check History Old And New Value For Attribute    Title    ${EMPTY}    ${PRODUCT}
    MUBE Check History Old And New Value For Attribute    Product 1    ${EMPTY}    ${PRODUCT_TYPE}
    MUBE Check History Old And New Value For Attribute    Contact Person    ${EMPTY}    ${DEFAULT_TEST_CONTACT}
    # MUBE Check History Old And New Value For Attribute    Contact Person Phone    ${EMPTY}    +358888888
    MUBE Check History Old And New Value For Attribute    External system    ${EMPTY}    B2BSELFCARE
    MUBE Check History Old And New Value For Attribute    Group    ${EMPTY}    Key Service Desk [TSF]
    MUBE Check History Description Value Should Not Be Empty

MUBE Verify That Contact Person Information Is Updated
    Sleep    30 s    Wait For All Contact Person Changes to be applied.
    MUBE Select Contact Person    ${TEST_CONTACT_PERSON_LAST_NAME}
    MUBE Get Contact Person Crm Id
    Wait Until Keyword Succeeds    60 s    10 s    MUBE Open Tab    History
    MUBE Check History Old And New Value For Contact Person Attribute    Email                  ${OLD_EMAIL}        ${NEW_EMAIL}
    MUBE Check History Old And New Value For Contact Person Attribute    Main Phone Number      ${OLD_PHONE}        ${NEW_PHONE}
    MUBE Check History Old And New Value For Contact Person Attribute    Business Card Title    ${EMPTY}            ${DEFAULT_BUSINESS_CARD_TITLE_UPDATED}
    MUBE Check History Old And New Value For Contact Person Attribute    Gender                 ${EMPTY}            ${DEFAULT_GENDER}
    MUBE Check History Old And New Value For Contact Person Attribute    3rd Party              ${EMPTY}            ${DEFAULT_3RD_PARTY_CONTACT_UPDATED}
    MUBE Check History Old And New Value For Contact Person Attribute    Sales Role             ${EMPTY}            ${DEFAULT_SALES_ROLE_UPDATED}
    MUBE Check History Old And New Value For Contact Person Attribute    SMS                    PermitByDefault     ${DEFAULT_MARKETING_SMS_PERMISSION_UPDATED}

MUBE Verify That Contact Person From Tellu Is Updated
    Sleep    30 s    Wait For All Contact Person Changes to be applied.
    MUBE Select Contact Person    ${TEST_CONTACT_PERSON_LAST_NAME}
    MUBE Get Contact Person Crm Id
    Wait Until Keyword Succeeds    60 s    10 s    MUBE Open Tab    History
    MUBE Check History Old And New Value For Contact Person Attribute    Email                  ${OLD_EMAIL}        ${NEW_EMAIL}
    MUBE Check History Old And New Value For Contact Person Attribute    Business Card Title    ${DEFAULT_BUSINESS_CARD_TITLE}            ${DEFAULT_BUSINESS_CARD_TITLE_UPDATED}
    MUBE Check History Old And New Value For Contact Person Attribute    Gender                 ${EMPTY}            ${DEFAULT_GENDER}
    MUBE Check History Old And New Value For Contact Person Attribute    Sales Role             ${EMPTY}            Business Contact – proposed     # By the way, that is not a "-" but a "–"
    MUBE Check History Old And New Value For Contact Person Attribute    Name                   Test                Test123
    MUBE Check History Old And New Value For Contact Person Attribute    Language               ${DEFAULT_LANGUAGE}    ${DEFAULT_LANGUAGE_UPDATED}
    MUBE Check History Old And New Value For Contact Person Attribute    Address Type A         Physical            PO Box
    MUBE Check History Old And New Value For Contact Person Attribute    Hobbies                ${EMPTY}            Golf

MUBE Verify That Contact Person Sales Role Is Updated
    Sleep    30 s    Wait For All Contact Person Changes to be applied.
    MUBE Select Contact Person    ${TEST_CONTACT_PERSON_LAST_NAME}
    MUBE Get Contact Person Crm Id
    Wait Until Keyword Succeeds    60 s    10 s    MUBE Open Tab    History
    MUBE Check History Old And New Value For Contact Person Attribute   Sales Role              ${EMPTY}    Business Contact

MUBE Verify That New Contact Person Is Send To Crm
    [Arguments]    ${mobile_or_email}=email    ${address_type}=Physical    ${preferred_channel}=eMail
    Sleep    30 s    Wait For All Contact Person Changes to be applied.
    Log    ${TEST_CONTACT_PERSON_LAST_NAME}
    MUBE Select Contact Person    ${TEST_CONTACT_PERSON_LAST_NAME}
    MUBE Get Contact Person Crm Id
    Run Keyword If    '${mobile_or_email}'=='mobile'    Mobile Should Be Set As Default
    Run Keyword If    '${mobile_or_email}'=='email'     Email Should Be Set As Default
    Wait Until Keyword Succeeds    60 s    10 s    MUBE Open Tab    History
    MUBE Check History Old And New Value For Contact Person Attribute    Email                  ${EMPTY}    ${DEFAULT_EMAIL}
    MUBE Check History Old And New Value For Contact Person Attribute    Language               ${EMPTY}    ${DEFAULT_LANGUAGE}
    MUBE Check History Old And New Value For Contact Person Attribute    Preferred channel      ${EMPTY}    ${preferred_channel}
    MUBE Check History Old And New Value For Contact Person Attribute    Name                   ${EMPTY}    Test
    MUBE Check History Old And New Value For Contact Person Attribute    Office Name            ${EMPTY}    Official Name
    MUBE Check History Old And New Value For Contact Person Attribute    Address Type A         ${EMPTY}    ${address_type}
    MUBE Check History Old And New Value For Contact Person Attribute    Business Card Title    ${EMPTY}    ${DEFAULT_BUSINESS_CARD_TITLE}

MUBE Wait For Load
    # Random error messages can cause this keyword to fail.
    Run Keyword And Ignore Error    Wait Until Keyword Succeeds    ${KEYWORD_WAIT}    ${KEYWORD_RETRY}    Wait For Condition    return jQuery != undefined && jQuery.active === 0 && jQuery('div.loading-animation').length == 0
    Wait Until Keyword Succeeds    30 s    1 s    Element Should Not Be Visible    ${LOADING_ANIMATION}

MUBE Wait Until Page Is Loaded
    [Arguments]    ${title}    ${child}
    MUBE Wait For Load
    Wait Until Page Contains Element    xpath=//div/div[a[contains(., "${title}")]]/following-sibling::div/a[contains(., '${child}')]
