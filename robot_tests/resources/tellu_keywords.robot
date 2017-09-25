*** Settings ***

Resource                ${PROJECTROOT}${/}resources${/}common.robot
Resource                ${PROJECTROOT}${/}resources${/}tellu_variables.robot

*** Keywords ***

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
    Select Window    ${TELLU_EDIT_CONTACT_PERSON_PAGE_TITLE}

TellU Search Contact Person By Attribute
    [Arguments]    ${attribute}    ${value}
    Wait Until Element Is Visible    //td/label[contains(text(), "${attribute}")]/../following-sibling::td/div/input
    Prolonged Input Text    //td/label[contains(text(), "${attribute}")]/../following-sibling::td/div/input    ${value}
    Wait Until Element Is Visible    ${TELLU_CONTACT_PERSON_SEARCH_BUTTON}    10 s
    Click Element    ${TELLU_CONTACT_PERSON_SEARCH_BUTTON}
    Element Should Be Visible    ${TELLU_SEARCH_RESULT_PAGE_HEADER}    30 s

TellU Search Result Page Should Contain Contact Person With Name
    [Arguments]    ${contact_person_last_name}
    Unselect Checkbox    ${TELLU_SHOW_ONLY_CONTACT_PERSON_WITH_SALES_ROLE_CHECKBOX}
    #TODO: this is only needed when there is a lot of contact persons. Fix this to be used on when needed.
    Run Keyword And Ignore Error    Click Element    ${TELLU_CONTACT_PERSON_SELECT_ALL_BUTTON}
    TellU Page Should Contain Contact Person Last Name    ${contact_person_last_name}

TellU Page Should Contain Contact Person Last Name
    [Arguments]    ${contact_person_last_name}
    Page Should Contain    ${contact_person_last_name}
