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

Select from search List
    [Arguments]    ${field}    ${value}
    Input Text    ${field}    ${value}
    Sleep    10s
    click element  //div[@role="listbox"]//div[@role="option"]/lightning-icon//lightning-primitive-icon/*[@data-key="search"]
    ${count}=    Get Element Count      //*[text()='Sorry to interrupt']
    ${IsErrorVisible}=    Run Keyword And Return Status        element should not be visible      //*[text()='Sorry to interrupt']
    Sleep   2s
    #log to console          ${IsErrorVisible}
    Run Keyword unless  ${IsErrorVisible}    Click Element       //button[@title='OK']
    #Press Enter On   ${field}
    Sleep   5s
    Click Visible Element    //div[@data-aura-class="forceSearchResultsGridView"]//a[@title='${value}']
    Sleep    2s

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
