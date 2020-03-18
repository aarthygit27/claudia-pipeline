*** Settings ***
Library           Collections
Resource          ../../resources/frontendsanity/Common.robot
Resource          ../../resources/frontendsanity/Variables.robot

*** Keywords ***

Navigate to Availability check
    [Documentation]    In B2B account page click 360-view and availability check buttons
    ${iframe}    Set Variable    //div[@class="oneAlohaPage"]//iframe[@title="accessibility title"]
    Click Element    ${360_VIEW}
    sleep  120s
    wait until page contains element  //div//h2//span[text()="Dashboard"]   60s
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    ${status}   set variable    Run Keyword and return status    Frame should contain    ${AVAILABILITY_CHECK_BUTTON}    Availability check
    #Current Frame Should Contain    //button[text()="Availability check"]
    Wait until page contains element  //button[text()="Availability check"]    60s
    Click Button   //button[text()="Availability check"]
    ${status}=    Run Keyword and return status    Wait until element is not visible    ${AVAILABILITY_CHECK_BUTTON}
    Run Keyword if    ${status} == False    Click Button    ${AVAILABILITY_CHECK_BUTTON}
    unselect frame


Validate Address details
    [Documentation]    Validate address in availability check
    ${iframe}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${postal_code_field}    Set Variable    xpath=//input[@id="postalCodeCityForAddressA"]
    ${address_field}    Set Variable    //input[@id='AddressA']
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    ${status}=    Run Keyword and return status    Wait until element is visible    ${postal_code_field}    20s
    Run Keyword If    ${status} == False    Execute Javascript    window.location.reload(false);
    Run Keyword If    ${status} == False    Wait until element is visible    ${postal_code_field}    20s
    Wait until keyword succeeds    30s    2s    Input Text    ${postal_code_field}    43500
    Wait until keyword succeeds    30s    2s    Input Text    ${address_field}    ${DEFAULT_ADDRESS}
    Wait element to load and click    ${ADDRESS_VALIDATION_DROPDOWN}
    Click Element    //div[@id='Address Details_nextBtn']
    unselect frame

Select product available for the address and create an opportunity
    ${iframe}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${days}    Set Variable    7
    ${opport_name}=    Run Keyword    Create Unique Name    TestOpportunity
    ${date}=    Get Date With Dashes    ${days}
    Set Test Variable    ${OPPORTUNITY_CLOSE_DATE}    ${date}
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    Wait element to load and click    ${PRODUCT_CHECKBOX}
    Click element    //div[@id='ListofProductsAvailable_nextBtn']
    Wait element to load and click    ${NEW_OPPORTUNITY_RADIOBUTTON}
    Click element    //div[@id='CreateOrUpdateOpp_nextBtn']
    sleep  5s
    Wait until page contains element    //input[@id='Name']    30s
    input text    //input[@id='Name']    ${opport_name}
    Sleep  2s
    Wait until page contains element    //textarea[@id='Description']    30s
    input text    //textarea[@id='Description']    Testopportunity description
    sleep  2s
    Wait until page contains element    //input[@id='CloseDate']    30s
    input text    //input[@id='CloseDate']    ${OPPORTUNITY_CLOSE_DATE}
    sleep  5s
    Click element    //div[@id='CreateB2BOpportunity_nextBtn']
    sleep    30s
    ${isVisible}    Run Keyword and return status    Wait until page contains element    //button[contains(text(),"Continue")]  30s
    Run Keyword If    ${isVisible}    Click element    //button[contains(text(),"Continue")]
    unselect frame
    #Sleep  60s
    wait until page contains element    //a[@title='CPQ']   60s
    Click element    //a[@title='CPQ']

Check the CPQ-cart contains the wanted products
    [Arguments]    ${product_name}
    ${iframe}    Set Variable    xpath=//div[contains(@class,'slds')]/iframe
    Sleep  30s
    Wait until element is enabled    ${iframe}    60s
    Wait until keyword succeeds    30s    2s    select frame    ${iframe}
    Wait until page contains element    //button/span[text()='${product_name}']    60s
    ${value} =   get text    //button/span[text()='${product_name}']
    unselect frame


