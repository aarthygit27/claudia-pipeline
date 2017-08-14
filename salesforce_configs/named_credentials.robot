*** Settings ***
Library                 Selenium2Library

Suite Setup             Open Browser And Go To Login Page
Suite Teardown          Close Browser

*** Variables ***
${USERNAME}             fbl11955@teliacompany.com.preprod
${PASSWORD}             Cp4r2P7hT2T4
${AddressValidation}    https://emily.extra.sonera.fi:62502/Adapters/Global/AddressValidation/Service/ValidateAddressService.serviceagent/ValidateAddressPortTypeEndpoint1
${AvailabilityCheck}    https://emily.extra.sonera.fi:62503/Adapters/Global/AvailabilityCheck/Service/AvailabilityCheckService.serviceagent/AvailabilityCheckPortTypeEndpoint1
${CaseManagement}       https://emily.extra.sonera.fi:62501/Adapters/B2BSelfcare/CRMCaseManagementCommon-service0.serviceagent/CRMCaseManagementCommonEndpoint0
${BEHIND_PROXY}         False
${LOGIN_PAGE}           https://test.salesforce.com
${BROWSER}              Firefox
${LOGOUT_BUTTON}        //div[@id='userNav-menuItems']//a[text()='Logout']


*** Test Cases ***
Change Named Credentials
    Login To Salesforce And Handle Mobile Phone Registration     ${USERNAME}     ${PASSWORD}
    Go To Application       Sales
    Navigate To Setup Page
    Navigate To Named Credentials Page
    Set AvailabilityCheck
    Set AddressValidation
    Set CaseManagement


*** Keywords ***
Open Browser And Go To Login Page
    Run Keyword If      '${BEHIND_PROXY}'=='True'     Open Browser And Go To Login Page (Proxy)
    Run Keyword If      '${BEHIND_PROXY}'=='True'     Return From Keyword
    Open Browser        ${LOGIN_PAGE}       ${BROWSER}
    Maximize Browser Window

Open Browser And Go To Login Page (Proxy)
    ${profile}=    Evaluate    selenium.webdriver.firefox.firefox_profile.FirefoxProfile(profile_directory="/home/jenkins/.mozilla/firefox/al34m1vz.default")    selenium
    ${proxy}=    Evaluate    sys.modules['selenium.webdriver'].Proxy()    sys, selenium.webdriver
    ${proxy.https_proxy}=    Set Variable    ${PROXY}
    Create Webdriver    ${BROWSER}    proxy=${proxy}    firefox_profile=${profile}
    Go To    ${LOGIN_PAGE}

Login To Salesforce And Handle Mobile Phone Registration
    [Arguments]         ${username}     ${password}
    Input Text          id=username         ${username}
    Input Password      id=password         ${password}
    Click Element       id=Login
    Run Keyword And Ignore Error        Dismiss Mobile Phone Registration
    Wait Until Page Contains Element   xpath=${LOGOUT_BUTTON}    15 seconds

Dismiss Mobile Phone Registration
    Wait Until Page Contains Element       //div[@id='header' and contains(text(),'Register Your Mobile Phone')]    10 s
    Capture Page Screenshot
    Click Element       //a[text()="I Don't Want to Register My Phone"]

Go To Application
    [Arguments]         ${app_name}
    Log                 First check if '${app_name}' is open, only navigate there if necessary
    ${app_open}=        Run Keyword And Return Status    App Is Open         ${app_name}
    Run Keyword Unless      ${app_open}      Navigate To App       ${app_name}

App Is Open
    [Arguments]         ${app_name}
    Click Element       id=tsidButton
    ${app_open}=        Run Keyword and Return Status   Element Should Not Be Visible   xpath=//a[@class='menuButtonMenuLink' and contains(text(),'${app_name}')]
    Click Element       id=tsidButton   # Close Menu
    [Return]            ${app_open}

Navigate To App
    [Documentation]     Called from 'Go To Application' keyword.
    [Arguments]         ${app_name}
    Click Element       id=tsidButton
    Wait Until Element is Visible           id=tsid-menuItems    5 seconds
    Click Element       xpath=//div[@id='tsid-menuItems']/a[text()='${app_name}']
    Wait Until Keyword Succeeds     10s     1s      App Should Be Open      ${app_name}

App Should Be Open
    [Arguments]         ${app_name}
    ${app_open}=        App Is Open     ${app_name}
    Should Be True      ${app_open}

Navigate To Setup Page
    # The Setup button is in different location depending on the sandbox
    ${r}=    Run Keyword and Return Status      Try From Dropdown
    Run Keyword If    '${r}'=='False'           Try From Menubar

Try From Dropdown
    Click Element       id=globalHeaderNameMink
    Click Element       xpath=//a[@id='globalHeaderNameMink']/following-sibling::ul//a[@title='Setup']
    Wait Until Page Contains Element        id=setupSearch      5 seconds

Try From Menubar
    Click Element       id=setupLink
    Wait Until Page Contains Element        id=setupSearch      5 seconds

Navigate To Named Credentials Page
    (Setup) Search For      Named Credentials
    Wait Until Element Is Visible       id=NamedCredential_font
    Click Element       id=NamedCredential_font
    Wait Until Page Contains Element    xpath=//h1[text()='Named Credentials']

(Setup) Search For
    [Arguments]         ${item}
    # Do not click the search button to get the quick access link for the search item
    Input Text          id=setupSearch      ${item}
    Wait Until Page Contains Element        xpath=//div[@id='AutoNumber5']//a[contains(text(),'${item}')]

Set AvailabilityCheck
    Click Element       xpath=//a[contains(@title, 'AvailabilityCheck')]
    Wait Until Page Contains Element        xpath=//h1[text()='Named Credential Edit: AvailabilityCheck']
    Input Text          xpath=//label[contains(text(),'URL')]/../following-sibling::td//textarea      ${AvailabilityCheck}
    Click Save

Set AddressValidation
    Click Element       xpath=//a[contains(@title, 'AddressValidation')]
    Wait Until Page Contains Element        xpath=//h1[text()='Named Credential Edit: AddressValidation']
    Input Text          xpath=//label[contains(text(),'URL')]/../following-sibling::td//textarea      ${AddressValidation}
    Click Save

Set CaseManagement
    Click Element       xpath=//a[contains(@title, 'CaseManagement')]
    Wait Until Page Contains Element        xpath=//h1[text()='Named Credential Edit: CaseManagement']
    Input Text          xpath=//label[contains(text(),'URL')]/../following-sibling::td//textarea      ${CaseManagement}
    Click Save

Click Save
    Click Element       xpath=//input[@value='Save']
    Wait Until Page Contains Element    xpath=//h1[text()='Named Credentials']