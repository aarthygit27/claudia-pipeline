*** Settings ***
Library           Collections
Resource          ..${/}resources${/}common.robot
Resource          ..${/}resources${/}cpq_keywords.robot
Resource          ..${/}resources${/}sales_app_light_variables.robot
Resource          ..${/}resources${/}sales_app_light_keywords.robot

*** Keywords ***
Adding telia yritysinternet
    ${Telia_yritysinternet}=    set variable    //div[@data-product-id='01u58000005pgZ8AAI']/div/div/div/div/div/button
    ${SETTINGS}=    Set Variable    //button[@title='Settings']
    ${ Liittymän_nopeus}=    Set Variable    //select[@name='productconfig_field_0_0']
    ${Sopimusaika}=    Set Variable    //select[@name='productconfig_field_0_1']
    ${X_BUTTON}=    Set Variable    //button[@class='slds-button slds-button--icon']
    ${Next_Button}=    Set Variable    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    wait until page contains element    ${Telia_yritysinternet}    60s
    sleep    10s
    click element    ${Telia_yritysinternet}
    Capture Page Screenshot
    ###Updating settings
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

General setup
    [Arguments]    ${username}    ${password}
    Login as Light user    ${username}    ${password}
    sleep    20s
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    sleep    10s
    capture page screenshot
    Log To Console    pause now
    sleep    5s

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
