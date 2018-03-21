*** Settings***
Documentation           Sets the named credentials of the given environment. By default they are set for PREPROD.
...                     ${AddressValidation}, ${AvailabilityCheck}, and ${CaseManagement} if wanted to run for
...                     a different environment.


*** Variables ***
${PROJECTROOT}          ${EXECDIR}${/}..${/}..${/}robot_tests
${ENVIRONMENT}          preprod
${AddressValidation}    https://emily.extra.sonera.fi:62502/Adapters/Global/AddressValidation/Service/ValidateAddressService.serviceagent/ValidateAddressPortTypeEndpoint1
${AvailabilityCheck}    https://emily.extra.sonera.fi:62503/Adapters/Global/AvailabilityCheck/Service/AvailabilityCheckService.serviceagent/AvailabilityCheckPortTypeEndpoint1
${CaseManagement}       https://emily.extra.sonera.fi:62501/Adapters/B2BSelfcare/CRMCaseManagementCommon-service0.serviceagent/CRMCaseManagementCommonEndpoint0
${AC_USER}              salesforce
${AC_PASS}              niunau/987
${AV_USER}              salesforce
${AV_PASS}              niunau/987
${CM_USER}              b2bselfcare
${CM_PASS}              passu99

*** Test Cases ***
Change Named Credentials
    [Setup]     Run Keywords    Import Resource     ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot    AND
    ...                         Open Browser And Go To Login Page
    Login to Salesforce As System Administrator     ${ENVIRONMENT}
    Run Keyword And Ignore Error        Dismiss Mobile Phone Registration
    Go To Application       Sales
    Navigate To Setup Page
    Navigate To Named Credentials Page
    Sleep   1
    Set AvailabilityCheck
    Sleep   1
    Set AddressValidation
    Sleep   1
    Set CaseManagement
    Sleep   1
    Capture Page Screenshot     # In order to check the named credentials are actually set
    [Teardown]  Close Browser


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
    Input Text          //input[contains(@id,':Username')]      ${AC_USER}
    Input Password      //input[contains(@id,':Password')]      ${AC_PASS}
    Click Save

Set AddressValidation
    Click Element       xpath=//a[contains(@title, 'AddressValidation')]
    Wait Until Page Contains Element        xpath=//h1[text()='Named Credential Edit: AddressValidation']       20s
    Input Text          xpath=//label[contains(text(),'URL')]/../following-sibling::td//textarea      ${AddressValidation}
    Input Text          //input[contains(@id,':Username')]      ${AV_USER}
    Input Password      //input[contains(@id,':Password')]      ${AV_PASS}
    Click Save

Set CaseManagement
    Click Element       xpath=//a[contains(@title, 'CaseManagement')]
    Wait Until Page Contains Element        xpath=//h1[text()='Named Credential Edit: CaseManagement']          20s
    Input Text          xpath=//label[contains(text(),'URL')]/../following-sibling::td//textarea      ${CaseManagement}
    Input Text          //input[contains(@id,':Username')]      ${CM_USER}
    Input Password      //input[contains(@id,':Password')]      ${CM_PASS}
    Click Save

Click Save
    Click Element       xpath=//input[@value='Save']
    Wait Until Page Contains Element    xpath=//h1[text()='Named Credentials']