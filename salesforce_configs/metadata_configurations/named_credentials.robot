*** Settings ***
Resource                 salesforce_keywords.robot

Suite Setup             Open Browser And Go To Login Page
Suite Teardown          Close Browser

*** Variables ***
${PROJECTROOT}          ${EXECDIR}${/}..${/}..${/}robot_tests
${ENVIRONMENT}          systeam
${AddressValidation}    https://emily.extra.sonera.fi:62502/Adapters/Global/AddressValidation/Service/ValidateAddressService.serviceagent/ValidateAddressPortTypeEndpoint1
${AvailabilityCheck}    https://emily.extra.sonera.fi:62503/Adapters/Global/AvailabilityCheck/Service/AvailabilityCheckService.serviceagent/AvailabilityCheckPortTypeEndpoint1
${CaseManagement}       https://emily.extra.sonera.fi:62501/Adapters/B2BSelfcare/CRMCaseManagementCommon-service0.serviceagent/CRMCaseManagementCommonEndpoint0
# ${BEHIND_PROXY}         False
# ${LOGIN_PAGE}           https://test.salesforce.com
# ${BROWSER}              Firefox
# ${LOGOUT_BUTTON}        //div[@id='userNav-menuItems']//a[text()='Logout']


*** Test Cases ***
Change Named Credentials
    Login to Salesforce As System Administrator     ${ENVIRONMENT}
    Run Keyword And Ignore Error        Dismiss Mobile Phone Registration
    Go To Application       Sales
    Navigate To Setup Page
    Navigate To Named Credentials Page
    Set AvailabilityCheck
    Set AddressValidation
    Set CaseManagement


*** Keywords ***
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
    Wait Until Page Contains Element        xpath=//h1[text()='Named Credential Edit: AvailabilityCheck']       20s
    Input Text          xpath=//label[contains(text(),'URL')]/../following-sibling::td//textarea      ${AvailabilityCheck}
    Input Text          //input[contains(@id,':Username')]      salesforce
    Input Password      //input[contains(@id,':Password')]      niunau/987
    Click Save

Set AddressValidation
    Click Element       xpath=//a[contains(@title, 'AddressValidation')]
    Wait Until Page Contains Element        xpath=//h1[text()='Named Credential Edit: AddressValidation']       20s
    Input Text          xpath=//label[contains(text(),'URL')]/../following-sibling::td//textarea      ${AddressValidation}
    Input Text          //input[contains(@id,':Username')]      salesforce
    Input Password      //input[contains(@id,':Passwore')]      niunau/987
    Click Save

Set CaseManagement
    Click Element       xpath=//a[contains(@title, 'CaseManagement')]
    Wait Until Page Contains Element        xpath=//h1[text()='Named Credential Edit: CaseManagement']          20s
    Input Text          xpath=//label[contains(text(),'URL')]/../following-sibling::td//textarea      ${CaseManagement}
    Input Text          //input[contains(@id,':Username')]      b2bselfcare
    Input Password      //input[contains(@id,':Passwore')]      passu99
    Click Save

Click Save
    Click Element       xpath=//input[@value='Save']
    Wait Until Page Contains Element    xpath=//h1[text()='Named Credentials']