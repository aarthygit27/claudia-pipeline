*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Variables.robot
Resource          ../../frontendsanity/resources/Common.robot
*** Keywords ***

Create New Master Contact
    ${first_name}=    Run Keyword    Create Unique Name    ${EMPTY}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${mobile_num}=    Run Keyword    Create Unique Mobile Number
    ${present}=    Run Keyword And Return Status    Element Should Be Visible    ${CLOSE_NOTIFICATION}
    Run Keyword If    ${present}    Close All Notifications
    wait until keyword succeeds    2mins    5s    Go to Contacts
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
    Input Text    ${MASTER_EMAIL_FIELD}    ${MASTER_EMAIL}
    Select from search List   ${ACCOUNT_NAME_FIELD}    ${MASTER_ACCOUNT_NAME}
    Click Element    ${SAVE_BUTTON}
    Sleep    10s
    #Validate Master Contact Details    ${CONTACT_DETAILS}

Go to Contacts
    ${isContactTabVisible}=    Run Keyword And Return Status    Element Should Be Visible    ${CONTACTS_TAB}
    run keyword unless    ${isContactTabVisible}    Go to More tab and select option    Contacts
    Click Visible Element    ${CONTACTS_TAB}
    Sleep    30s
    ${isVisible}=    Run Keyword And Return Status    Element Should Be Visible    //*[@title='Close this window']
    Run Keyword If    ${isVisible}    Go to Contacts
    Wait Until Page Contains element    ${CONTACTS_ICON}    240s

Validate Master Contact Details
    ${contact_name}=    Set Variable    //span[text()='Name']/../..//span//*[text()='${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']/../..//a[text()='${MASTER_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']/../..//span//*[text()='${MASTER_MOBILE_NUM}']
    ${phone_number}=    Set Variable    //span[text()='Phone']//following::span//*[text()='${MASTER_PHONE_NUM}']
    ${primary_email}=    Set Variable    //span[text()='Primary eMail']/../..//a[text()='${MASTER_PRIMARY_EMAIL}']
    ${email}=    Set Variable           //span[text()='Email']/../..//a[text()='${MASTER_EMAIL}']
    Go to Entity    ${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}
    Click Visible element    ${DETAILS_TAB}
    Validate Contact Details    ${CONTACT_DETAILS}    ${contact_name}    ${account_name}    ${mobile_number}    ${primary_email}    ${email}
    #Wait Until Page Contains Element    ${element}${phone_number}
    #Wait Until Page Contains Element    ${element}${email}

Validate Contact Details
    [Arguments]    ${element}    ${contact_name}    ${account_name}    ${mobile_number}   ${primary_email}  ${email}
    Wait Until Page Contains Element    ${contact_name}    240s
    Wait Until Page Contains Element    ${account_name}    240s
    Wait Until Page Contains Element    ${mobile_number}    240s
    Wait Until Page Contains Element    ${primary_email}    240s
    Wait Until Page Contains Element    ${email}            240s


Create New NP Contact
    ${first_name}=    Run Keyword    Create Unique Name    ${EMPTY}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${mobile_num}=    Run Keyword    Create Unique Mobile Number
    wait until keyword succeeds    2mins    5s    Go to Contacts
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

Validate NP Contact
    ${contact_name}=    Set Variable    //span[text()='Name']/../..//*[text()='Non-person ${NP_FIRST_NAME} ${NP_LAST_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']/../..//a[text()='${NP_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']/../..//span//*[text()='${NP_MOBILE_NUM}']
    ${email}=    Set Variable    //span[text()='Email']/../..//a[text()='${NP_EMAIL}']
    Go to Entity    Non-person ${NP_FIRST_NAME} ${NP_LAST_NAME}
    Click Visible Element    ${DETAILS_TAB}
    Validate NP Contact Details    ${CONTACT_DETAILS}    ${contact_name}    ${account_name}    ${mobile_number}     ${email}


Validate NP Contact Details
    [Arguments]    ${element}    ${contact_name}    ${account_name}    ${mobile_number}   ${email}
    Wait Until Page Contains Element    ${contact_name}    240s
    Wait Until Page Contains Element    ${account_name}    240s
    Wait Until Page Contains Element    ${mobile_number}    240s
    Wait Until Page Contains Element    ${email}            240s


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


Validate AP Contact Details
    Go To Entity    ${AP_FIRST_NAME} ${AP_LAST_NAME}    ${SEARCH_SALESFORCE}
    ${contact_name}=    Set Variable    //span[text()="Name"]/../../div[2]//*[text()='${AP_FIRST_NAME} ${AP_LAST_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']/../..//a[text()='${AP_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']/../..//span//*[text()='${AP_MOBILE_NUM}']
    ${Primary email}=    Set Variable    //span[text()='Primary eMail']/../..//a[text()='${AP_EMAIL}']
    ${mail}=             Set Variable    //span[text()='Email']/../..//a[text()='${Ap_mail}']
    #Click Visible Element    //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
    Validate Contact Details    ${CONTACT_DETAILS}    ${contact_name}    ${account_name}    ${mobile_number}    ${Primary email}   ${mail}


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
    Sleep   5s
    Click Visible Element    ${MASTER}
    Sleep  2s
    click Element    ${NEXT}
    Wait Until Element is Visible    ${CONTACT_INFO}    10s
    sleep    5s
    Input Text    ${MASTER_MOBILE_NUM_FIELD}    ${MASTER_PHONE_NUM}
    Input Text    ${FIRST_NAME_FIELD}    ${MASTER_FIRST_NAME}
    Input Text    ${LAST_NAME_FIELD}    ${MASTER_LAST_NAME}
    Input Text    ${MASTER_PHONE_NUM_FIELD}    ${MASTER_PHONE_NUM}
    Input Text    ${MASTER_PRIMARY_EMAIL_FIELD}    ${MASTER_PRIMARY_EMAIL}
    Input Text    ${EMAIL_ID_FIELD}    ${MASTER_PRIMARY_EMAIL}
    Select from search List   ${ACCOUNT_NAME_FIELD}    ${MASTER_ACCOUNT_NAME}
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
    ${contact_name}=    Set Variable    //span[text()='Name']//following::span//lightning-formatted-name[text()='${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}']
    ${business_card_text}=    Set Variable    //span[text()='Business Card Title']//following::span//lightning-formatted-text[text()='${BUSINESS_CARD}']
    ${gender_selection}=    Set Variable    //span[text()='Gender']//following::span/lightning-formatted-text[text()='${gender}']
    ${account_name}=    Set Variable    //span[text()='Account Name']//following::a[text()='${MASTER_ACCOUNT_NAME}']
    ${mobile_number}=    Set Variable    //span[text()='Mobile']/../..//lightning-formatted-phone/a[text()='${MASTER_MOBILE_NUM}']
    ${phone_number}=    Set Variable    //span[text()='Phone']/../..//lightning-formatted-phone/a[text()='${MASTER_PHONE_NUM}']
    ${primary_email}=    Set Variable    //span[text()='Primary eMail']/../..//a[text()='${MASTER_PRIMARY_EMAIL}']
    ${email}=    Set Variable    //span[text()='Email']/../..//a[text()='${MASTER_PRIMARY_EMAIL}']
    ${status}=    Set Variable    //span[text()='Status']//following::span//lightning-formatted-text[text()='${STATUS_TEXT}']
    ${preferred_contact}=    Set Variable    //span[text()='Preferred Contact Channel']//following::span//lightning-formatted-text[text()='${PREFERRED_CONTACT}']
    ${comm_lang}=    Set Variable    //span[text()='Communication Language']//following::span//lightning-formatted-text[text()='${COMMUNICATION_LANG}']
    ${birth_date}=    Set Variable    //span[text()='Birthdate']//following::span//lightning-formatted-text[text()='${day}.${month_digit}.${year}']
    ${last_contact_date}=    Set Variable   //span[text()='Last Contacted Date']/../../div[2]/span//lightning-formatted-text
    #${last_contact_date}=    Set Variable    //span[text()='Last Contacted Date']//following::span//span[text()='${contacted_date_text}']
    ${sales_role}=    Set Variable    //span[text()='Sales Role']//following::span//lightning-formatted-text[text()='${sales_role_text}']
    ${job_title}=    Set Variable    //span[text()='Job Title Code']//following::span//lightning-formatted-text[text()='${job_title_text}']
    ${office_name_text}=    Set Variable    //span[text()='Office Name']//following::span//lightning-formatted-text[text()='${OFFICE_NAME}']
    Go to Entity    ${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}
    Sleep    5s
    Click Visible element    ${DETAILS_TAB}
    Sleep    5s
    Validate Contact Details In Contact Page    ${element}    ${contact_name}    ${account_name}    ${mobile_number}    ${primary_email}    ${email}
    ...    ${status}    ${preferred_contact}    ${comm_lang}    ${birth_date}    ${last_contact_date}    ${sales_role}
    ...    ${job_title}    ${office_name_text}
    #Wait Until Page Contains Element    ${element}${phone_number}
    #Wait Until Page Contains Element    ${element}${email}


Validate Contact Details In Contact Page
    [Arguments]    ${element}    ${contact_name}    ${account_name}    ${mobile_number}    ${primary_email}    ${email}
    ...    ${status}    ${preferred_contact}    ${comm_lang}    ${birth_date}    ${last_contact_date}    ${sales_role}
    ...    ${job_title}    ${office_name_text}
    Wait Until Page Contains Element    ${contact_name}    240s
    Wait Until Page Contains Element    ${account_name}    240s
    Wait Until Page Contains Element    ${mobile_number}    240s
    Wait Until Page Contains Element    ${primary_email}    240s
    Wait Until Page Contains Element    ${email}    240s
    Wait Until Page Contains Element    ${status}    240s
    Wait Until Page Contains Element    ${preferred_contact}    240s
    Wait Until Page Contains Element    ${comm_lang}    240s
    Wait Until Page Contains Element    ${birth_date}    240s
    Wait Until Page Contains Element    ${last_contact_date}    240s
    ${last_contact_date}    Get text    ${last_contact_date}
    Should Be Equal As Strings   ${last_contact_date}  ${EMPTY}
    Wait Until Page Contains Element    ${sales_role}    240s
    Wait Until Page Contains Element    ${job_title}    240s
    Wait Until Page Contains Element    ${office_name_text}    240s


Validate That Contact Person Attributes Are Named Right
    ${business_card_title}=    Set Variable    //button[@title='Edit Business Card Title']/../..//span[text()='Business Card Title']
    ${name}=    Set Variable     //span[text()="Edit Name"]/./../../..//span[text()='Name']
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
    ${Address}=    Set Variable    //div[@class="slds-form"]//span[text()='Address']
    ${External_address}=    Set Variable    //div[@class="slds-form"]//span[text()='External Address']
    ${3rd_Party_Contact}=    Set Variable    //button[@title='Edit 3rd Party Contact']/../..//div/span[text()='3rd Party Contact']
    ${external_phone}=    Set Variable    //span[text()='External Phone']
    Wait Until Page Contains Element    ${business_card_title}    240s
    Wait Until Page Contains Element    ${name}    240s
    Wait Until Page Contains Element    ${contact_ID}    240s
    Wait Until Page Contains Element    ${account_name}    240s
    Wait Until Page Contains Element    ${mobile_number}    240s
    Wait Until Page Contains Element    ${phone_number}    240s
    Wait Until Page Contains Element    ${primary_email}    240s
    Wait Until Page Contains Element    ${email}    240s
    Wait Until Page Contains Element    ${status}    240s
    Scroll Page To Location    0    200
    Wait Until Page Contains Element    ${preferred_contact_title}    240s
    Wait Until Page Contains Element    ${comm_lang}    240s
    Wait Until Page Contains Element    ${birth_date}    240s
    Scroll Page To Location    0    500
    Wait Until Page Contains Element    ${sales_role}    240s
    Wait Until Page Contains Element    ${office_name_text}    240s
    Wait Until Page Contains Element    ${gender_text}    240s
    Wait Until Page Contains Element    ${Address}    240s
    Wait Until Page Contains Element    ${External_address}    240s
    Wait Until Page Contains Element    ${3rd_Party_Contact}    240s
    Wait Until Page Contains Element    ${external_phone}    240s

Navigate to create new contact
    Wait element to load and click    //a[@title='New']
    Wait until page contains element    //button/span[text()='Next']    30s
    Click element    //button/span[text()='Next']


Validate external contact data can not be modified
    ${external_phone}    Set Variable    xpath=//span[text()='External Phone']/../..//span[contains(@class, 'is-read-only')]
    ${external_title}    Set Variable    xpath=//span[text()='External Title']/../..//span[contains(@class, 'is-read-only')]
    ${external_eMail}    Set Variable    xpath=//span[text()='External eMail']/../..//span[contains(@class, 'is-read-only')]
    ${external_status}    Set Variable    xpath=//span[text()='External Status']/../..//span[contains(@class, 'is-read-only')]
    ${external_office_name}    Set Variable    xpath=//span[text()='External Office Name']/../..//span[contains(@class, 'is-read-only')]
    ${external_address}    Set Variable    xpath=//span[text()='External Address']/../..//span[contains(@class, 'is-read-only')]
    ${contact_id}    Set Variable    //span[text()='Contact ID']/../..//span[contains(@class, 'is-read-only')]
    ${ulm_id}    Set Variable    //span[text()='ULM id']/../..//span[contains(@class, 'is-read-only')]
    ${external_id}    Set Variable    xpath=//span[text()='External_id']/../..//span[contains(@class, 'is-read-only')]
    #Input Text    ${external_phone}         ${externalphoneno}
    wait until page contains element        ${external_phone}       5s
    wait until page contains element        ${external_title}       5s
    wait until page contains element        ${external_eMail}       5s
    wait until page contains element        ${external_status}       5s
    wait until page contains element        ${external_office_name}       5s
    wait until page contains element        ${external_address}       5s
    wait until page contains element        ${contact_id}       5s
    wait until page contains element        ${ulm_id}       5s
    wait until page contains element        ${external_id}       5s
    sleep       10s

Close contact form
    Click element    //button[@title='Cancel']

Create new contact with external data
    ${first_name}=    Run Keyword    Create Unique Name    ${EMPTY}
    ${email_id}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    ${mobile_num}=    Run Keyword    Create Unique Mobile Number
    ${present}=    Run Keyword And Return Status    Element Should Be Visible    ${CLOSE_NOTIFICATION}
    ${external_phone_field}    Set Variable    xpath=//span[text()='External Phone']/../../input
    ${external_title_field}    Set Variable    xpath=//span[text()='External Title']/../../input
    ${external_eMail_field}    Set Variable    xpath=//span[text()='External eMail']/../../input
    ${external_status_field}    Set Variable    xpath=//span[text()='External Status']//following::a
    ${external_office_name_field}    Set Variable    xpath=//span[text()='External Office Name']/../../input
    ${ulm_id_field}    Set Variable    xpath=//span[text()='ULM id']/../../input
    ${external_id_field}    Set Variable    xpath=//span[text()='External_id']/../../input
    Run Keyword If    ${present}    Close All Notifications
    wait until keyword succeeds    2mins    5s    Go to Contacts
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
    Input Text    ${MASTER_EMAIL_FIELD}    ${MASTER_EMAIL}
    Select from search List   ${ACCOUNT_NAME_FIELD}    ${MASTER_ACCOUNT_NAME}
    Input text          ${external_phone_field}           ${externalphoneno}
    Input text      ${external_title_field}       ${externaltitle}
    Input text      ${external_eMail_field}       ${externaleMail}
    #Select option from Dropdown     ${external_status_field}     Active
    Input text     ${external_office_name_field}       ${externalofficename}
    Input text      ${ulm_id_field}     ${ulmid}
    Input text          ${external_id_field}       ${externalid}
    Click Element       ${SAVE_BUTTON}
    Sleep    10s

Open edit contact form
    Click element    //a[@title='Edit']

Click view contact relationship
    Wait element to load and click    //span[@title='Related Accounts']/../../a
    sleep    10s
    Click element    ${table_row}
    Wait until page contains element    //a[@title='View Relationship']
    Click element    //a[@title='View Relationship']


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

Edit_and_Select_Contact
    [Arguments]    ${contact_name}
    scrolluntillfound    //button[@title='Edit Contact']
    click element    //button[@title='Edit Contact']
    wait until page contains element    //input[@placeholder='Search Contacts...']    30s
    input text    //input[@title='Search Contacts']    ${contact_name}
    wait until page contains element    //div[text()='${contact_name}']//ancestor::a    30s
    click element    //div[text()='${contact_name}']//ancestor::a
    click element    //button[@title="Save"]
    sleep    2s