*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Variables.robot

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
    Go To    ${LOGIN_PAGE_APP}
    Login Page Should Be Open

Login Page Should Be Open
    [Documentation]    To Validate the elements in Login page
    Wait Until Keyword Succeeds    60s    1 second    Location Should Be   ${LOGIN_PAGE_APP}
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

Login to Salesforce as Pricing Manager
    Login To Salesforce Lightning    ${PM_User}  ${PM_PW}

Login to Salesforce as B2O User
    [Arguments]    ${username}=${B2O_DIGISALES_LIGHT_USER}    ${password}=${B2O_DIGISALES_LIGHT_PASSWORD}
    Login To Salesforce Lightning    ${username}    ${password}

Login to Salesforce Lightning
    [Arguments]    ${username}    ${password}
    #log to console    ${password}
    Wait Until Page Contains Element    id=username    240s
    Input Text    id=username    ${username}
    Sleep    5s
    Input text    id=password    ${password}
    Click Element    id=Login
    sleep  45s
    ${infoAvailable}=    Run Keyword And Return Status    element should be visible    ${remindmelater}
    Run Keyword If    ${infoAvailable}    force click element    ${remindmelater}
    run keyword and ignore error    Check For Lightning Force
    ${buttonNotAvailable}=    Run Keyword And Return Status    element should not be visible    ${LIGHTNING_ICON}
    Run Keyword If    ${buttonNotAvailable}    reload page
    Wait Until Page Contains Element    xpath=${LIGHTNING_ICON}    60 seconds

