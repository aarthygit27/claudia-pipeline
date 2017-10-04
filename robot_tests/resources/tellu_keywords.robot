*** Settings ***

Resource                ${PROJECTROOT}${/}resources${/}common.robot
Resource                ${PROJECTROOT}${/}resources${/}tellu_variables.robot

*** Keywords ***

Tellu Create New Contact Person
    [Arguments]     ${customer_business_id}=${DEFAULT_TEST_ACCOUNT_BUSINESS_ID}
    ...             ${address_type}=Physical
    ...             ${streetname}=${DEFAULT_STREET_NAME}
    ...             ${postal}=${DEFAULT_POSTAL_CODE}
    ...             ${city}=${DEFAULT_CITY}
    ...             ${country}=${DEFAULT_COUNTRY}
    ${name}=    Create Unique Name      Contact Person
    ${email}=   Create Unique Email
    Tellu Open Contact Person Editor
    Reload Page
    Wait Until Element Is Visible    ${TELLU_BUSINESS_ID_FIELD}    30 s
    Prolonged Input Text    ${TELLU_BUSINESS_ID_FIELD}    ${customer_business_id}
    Wait Until Element Is Visible    ${TELLU_CONTACT_PERSON_SEARCH_BUTTON}
    Click Element           ${TELLU_CONTACT_PERSON_SEARCH_BUTTON}
    Wait Until Element Is Visible    ${TELLU_CREATE_NEW_CONTACT_PERSON_BUTTON}    30 s
    Click Element           ${TELLU_CREATE_NEW_CONTACT_PERSON_BUTTON}
    Wait Until Element Is Visible    ${TELLU_FIRST_NAME_FIELD}    30 s
    Prolonged Input Text    ${TELLU_FIRST_NAME_FIELD}               Test
    Prolonged Input Text    ${TELLU_LAST_NAME_FIELD}                ${name}
    Unselect Checkbox       ${TELLU_MOBILE_AS_DEFAULT_CHECKBOX}
    Select Checkbox         ${TELLU_EMAIL_AS_DEFAULT_CHECKBOX}
    Prolonged Input Text    ${TELLU_BUSINESS_CARD_TITLE_FIELD}      ${DEFAULT_BUSINESS_CARD_TITLE}
    Prolonged Input Text    ${TELLU_EMAIL_FIELD}                    ${email}
    Prolonged Input Text    ${TELLU_MOBILE_PHONE_FIELD}             ${DEFAULT_PHONE[4:]}    # Cut +358 from the phone number
    Select From List        ${TELLU_ADDRESS_TYPE_SELECT}            ${address_type}
    Wait Until Element Is Visible   ${TELLU_STREETNAME_FIELD}       30s
    Run Keyword And Ignore Error    Select From List    ${TELLU_COUNTRY_CODE_FIELD}    ${country}
    Prolonged Input Text    ${TELLU_STREETNAME_FIELD}               ${streetname}
    Prolonged Input Text    ${TELLU_POSTAL_CODE_FIELD}              ${postal}
    Prolonged Input Text    ${TELLU_CITY_CODE_FIELD}                ${city}
    Select From List        ${TELLU_PREFERRED_CONTACT_CHANNEL_SELECT}    Email
    Prolonged Input Text    ${TELLU_OFFICIAL_NAME_FIELD}            Official Name
    Click Element           ${TELLU_UPDATE_CONTACT_PERSON_BUTTON}
    Confirm Action
    Wait Until Element Is Visible    css=ul.customValidationError    30 s
    Element Should Contain    css=ul.customValidationError    Data updated successfully to CRM
    Set Test Variable       ${TEST_CONTACT_PERSON_LAST_NAME}    ${name}

TellU Go to Login Page And Login
    [Documentation]    Log in to TellU, skip if already logged in.
    Go To    ${TELLU_SERVER}
    ${passed}=    Run Keyword And Return Status    Element Should Be Visible    ${TELLU_USERNAME_FIELD}
    Run Keyword If    ${passed}    Prolonged Input Text    ${TELLU_USERNAME_FIELD}    ${TELLU_USERNAME}
    Run Keyword If    ${passed}    Input Password    ${TELLU_PASSWORD_FIELD}    ${TELLU_PASSWORD}
    Run Keyword If    ${passed}    Press Enter On    ${TELLU_PASSWORD_FIELD}
    Run Keyword If    ${passed}    Page Should Not Contain    Cannot login. Please check your user name and password.

TellU Open Contact Person Editor
    Wait Until Keyword Succeeds    30 s    5 s    TellU Open Contact Person Editor And Verify
    Wait Until Element Is Visible    ${TELLU_CONTACT_PERSON_LAST_NAME_FIELD}    60 s
    Click Element    ${TELLU_RESET_ALL_SEARCH_FIELDS_BUTTON}

TellU Open Contact Person Editor And Verify
    Wait Until Element Is Visible    ${TELLU_CONTACT_PERSON_LINK}
    Click Element    ${TELLU_CONTACT_PERSON_LINK}
    Wait Until Keyword Succeeds    5s    1s     Select Window    ${TELLU_EDIT_CONTACT_PERSON_PAGE_TITLE}

TellU Search Contact Person By Attribute
    [Arguments]    ${attribute}     ${value}
    Reload Page
    Wait Until Element Is Visible   //td/label[contains(text(), "${attribute}")]/../following-sibling::td/div/input
    Prolonged Input Text            //td/label[contains(text(), "${attribute}")]/../following-sibling::td/div/input    ${value}
    Wait Until Element Is Visible   ${TELLU_CONTACT_PERSON_SEARCH_BUTTON}    10 s
    Click Element    ${TELLU_CONTACT_PERSON_SEARCH_BUTTON}
    Wait Until Element Is Visible    ${TELLU_SEARCH_RESULT_PAGE_HEADER}    30 s

TellU Search Result Page Should Contain Contact Person With Name
    [Arguments]    ${contact_person_last_name}
    Wait Until Page Contains Element    ${TELLU_SHOW_ONLY_CONTACT_PERSON_WITH_SALES_ROLE_CHECKBOX}      10s
    Unselect Checkbox    ${TELLU_SHOW_ONLY_CONTACT_PERSON_WITH_SALES_ROLE_CHECKBOX}
    #TODO: this is only needed when there is a lot of contact persons. Fix this to be used on when needed.
    Run Keyword And Ignore Error    Click Element    ${TELLU_CONTACT_PERSON_SELECT_ALL_BUTTON}
    TellU Page Should Contain Contact Person Last Name    ${contact_person_last_name}

TellU Page Should Contain Contact Person Last Name
    [Arguments]    ${contact_person_last_name}
    Wait Until Page Contains Element    //tr[./td/div[contains(text(),'Search Result')]]/following-sibling::tr//p[text()='${contact_person_last_name}']     10s

TellU Verify That Contact Person Is Updated
    [Arguments]     ${contact_person_last_name}=${TEST_CONTACT_PERSON_LAST_NAME}
    Log    ${contact_person_last_name}
    TellU Page Should Contain Contact Person Last Name    ${contact_person_last_name}
    ${x}=       Get Selected List Label    //tr[./td/div[contains(text(),'Search Result')]]/following-sibling::tr//td[./div/div/p[text()='${contact_person_last_name}']]/following-sibling::td//select[contains(@name,'role')]
    Should Be Equal As Strings      ${x}    Business Contact

