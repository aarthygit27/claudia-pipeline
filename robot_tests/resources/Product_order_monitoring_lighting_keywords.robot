*** Settings ***
Library           Collections
Resource          ..${/}resources${/}common.robot
Resource          ..${/}resources${/}cpq_keywords.robot
Resource          ..${/}resources${/}sales_app_light_variables.robot
Resource          ..${/}resources${/}sales_app_light_keywords.robot

*** Keywords ***
Adding telia yritysinternet
    Adding Products    ${Telia_yritysinternet}

General setup
    [Arguments]    ${username}    ${password}
    Login as Light user    ${username}    ${password}
    sleep    20s
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    sleep    10s
    capture page screenshot
    Log To Console    pause now
    #sleep    5s

creating opportunity
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    Chetan
    log to console    ${oppo_name}.this is opportunity
    sleep    10s
    Go To Entity    ${oppo_name}
    sleep    30s
    [Return]    ${oppo_name}

order creation
    [Arguments]    ${products}
    UpdateAndAddSalesType    ${products}
    OpenQuoteButtonPage
    #CreditScoreApproving
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    close order

Close order
    ${frame}=    Set Variable    xpath=//div[contains(@class,'slds')]/iframe
    ${close_order}=    Set Variable    //p[contains(text(),'Close')]
    sleep    10s
    Capture Page Screenshot
    Select Frame    ${frame}
    Click Element    ${close_order}
    Unselect Frame

Login as Light user
    [Arguments]    ${username}    ${password}
    Login To Salesforce Lightning    ${username}    ${password}

Adding Products
    [Arguments]    ${product}
    wait until page contains element    //div[@data-product-id='${product}']/div/div/div/div/div/button    60s
    sleep    10s
    click element    //div[@data-product-id='${product}']/div/div/div/div/div/button
    Capture Page Screenshot

Updating setting Telia_yritysinternet
    ${SETTINGS}=    Set Variable    //button[@title='Settings']
    ${ Liittymän_nopeus}=    Set Variable    //select[@name='productconfig_field_0_0']
    ${Sopimusaika}=    Set Variable    //select[@name='productconfig_field_0_1']
    ${X_BUTTON}=    Set Variable    //button[@class='slds-button slds-button--icon']
    ${Next_Button}=    Set Variable    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    Wait Until Element Is Visible    ${SETTINGS}    60s
    click element    ${SETTINGS}
    Wait Until Element Is Visible    ${ Liittymän_nopeus}    60s
    Click Element    ${ Liittymän_nopeus}
    Wait Until Element Is Visible    ${ Liittymän_nopeus}/option[@value='1']    30s
    click element    ${ Liittymän_nopeus}/option[@value='1']
    click element    ${Sopimusaika}
    Wait Until Element Is Visible    ${Sopimusaika}/option[@value='1']    30s
    click element    ${Sopimusaika}/option[@value='1']
    sleep    5s
    Click Element    ${X_BUTTON}
    Wait Until Element Is Visible    ${Next_Button}    60s
    Click Element    ${Next_Button}

update sales products
    [Arguments]    ${products}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_list}=    Set Variable    //td[normalize-space(.)='${products}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    log to console    UpdateAndAddSalesType
    sleep    30s
    Select Window
    Select Frame    //div[contains(@class,'slds')]/iframe
    sleep    20s
    wait until page contains element    ${product_list}    70s
    click element    ${product_list} //following-sibling::td/select[contains(@class,'required')]

Opening Quote
    ${open_quote}=    Set Variable    //*[@id="Open Quote"]
    ${approval}=    Set variable    //div[@class='vlc-validation-warning ng-scope']/small[contains(text(),'Quote')]
    log to console    OpenQuoteButtonPage
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    log to console    selected final page frame
    wait until page contains element    ${approval}    60s
    log to console    wait completed before open quote click
    wait until element is visible    ${open_quote}    30s
    wait until element is enabled    ${open_quote}    20s
    log to console    element visible next step
    click element    ${open_quote}
    unselect frame
    sleep    60s

Updating setting B2O other services
    ${Next_Button}=    Set Variable    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    Wait Until Element Is Visible    ${Next_Button}    60s
    Click Element    ${Next_Button}
