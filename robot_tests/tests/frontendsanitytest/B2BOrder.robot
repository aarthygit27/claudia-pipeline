*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../../resources/sales_app_light_keywords.robot
Resource          ../../resources/common.robot
Resource          ../../resources/multibella_keywords.robot
#Library             test123.py


*** Test Cases ***

Create B2B Order
    [Tags]    BQA-8919     AUTOLIGHTNING        B2BOrderManagement
    [Documentation]     Create B2B order with product Alerta Projecktointi
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity    ${oppo_name}
    ChangeThePriceList      B2B
    ClickingOnCPQ   ${oppo_name}
    AddProductToCart    Alerta projektointi
    Run Keyword If    '${r}'== 'b2b'    run keyword    UpdateAndAddSalesType    Alerta projektointi
    Run keyword If    '${r}'== 'b2o'    run keyword    UpdateAndAddSalesTypeB2O    B2O Other Services
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    OrderNextStepsPage
    getOrderStatusBeforeSubmitting
    clickOnSubmitOrder
    getOrderStatusAfterSubmitting


E2E opportunity process incl. modelled and unmodelled products & Quote & SA & Order
    [Tags]    BQA-9121    AUTOLIGHTNING         B2BOrderManagement  rerun
    [Documentation]     Create B2B order with modelled product Telia Yritysinternet plus and unmodelled product Data ner multi
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    Ylöjärven Yrityspalvelu Oy
    ${contact_name}    run keyword    Create New Contact for Account
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity    ${oppo_name}
    sleep    5s
    Editing Win prob    no
    Adding partner and competitor
    Capture Page Screenshot
    sleep    10s
    ClickingOnCPQ    ${oppo_name}
    search products  Telia Yritysinternet Plus
    Adding Yritysinternet Plus  Telia Yritysinternet Plus
    search products    DataNet Multi
    Adding DataNet Multi  DataNet Multi
    UpdateAndAddSalesType for 2 products    Telia Yritysinternet Plus    DataNet Multi
    sleep    10s
    ${quote_number}    Run Keyword    preview and submit quote  ${oppo_name}
    Opportunity status
    Create Order from quote    ${quote_number}    ${oppo_name}
    View order and send summary
    Go to Entity    ${oppo_name}
    Closing the opportunity    No


Opportunity: Products used for reporting only must not be visible on Quote & Order
    [Tags]    BQA-9122    AUTOLIGHTNING         B2BOrderManagement
    [Documentation]     Create order with reporting product and validate the visibility
    ${next_button}=    set variable    //span[contains(text(),'Next')]
    @{products}    Set Variable    Telia Ulkoistettu asiakaspalvelu    Telia Neuvottelupalvelut    Telia Palvelunumero    Telia Yritysliittymä    Telia Laskutuspalvelu
    ...    Telia Ulkoistettu asiakaspalvelu - Lisäkirjaus    Telia Neuvottelupalvelut - Lisäkirjaus    Telia Palvelunumero - Lisäkirjaus    Telia Yritysliittymä - Lisäkirjaus    Telia Laskutuspalvelu - Lisäkirjaus
    ...    Sopiva Pro-migraatio    Sovelluskauppa 3rd Party Apps    VIP:n käytössä olevat Cid-numerot    Ohjaus Telia Numeropalveluun    Online Asiantuntijapalvelut
    ${Submit Order}    set variable    //div[@title='Submit Order']
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    ${contact_name}    run keyword    Create New Contact for Account
    ${oppo_name}      run keyword    CreateAOppoFromAccount_HDC     ${contact_name}
    #${oppo_name}    set variable    Test Robot Order_ 20191010-182003
    sleep    5s
    Go To Entity   ${oppo_name}
    sleep    5s
    ClickingOnCPQ    ${oppo_name}
    Searching and adding multiple products    @{products}
    Updating sales type multiple products    @{products}
    preview and submit quote  ${oppo_name}
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    OrderNextStepsPage
    Preview order summary and verify order    @{products}
    Sleep       10s
    wait until page contains element   ${Submit Order}  60s
    click element    ${Submit Order}

Create B2B Direct Order
    [Tags]    BQA-10813    AUTOLIGHTNING       B2BOrderManagement
    [Documentation]     Create B2B Direct order
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    Ylöjärven Yrityspalvelu Oy
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    sleep    10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity    ${oppo_name}
    ClickingOnCPQ    ${oppo_name}
    AddProductToCart    Fiksunetti
    Run Keyword If    '${r}'== 'b2b'    run keyword    UpdateAndAddSalesTypeandClickDirectOrder    Fiksunetti
    getorderstatusbeforesubmitting
    clickonsubmitorder
    ${order_no}    run keyword    getorderstatusaftersubmitting
    getMultibellaCaseGUIID    ${order_no}

Create B2B Order - Multibella
    [Tags]    BQA-11778       AUTOLIGHTNING         B2BOrderManagement
    [Documentation]     Create Order for Multibella product
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    Digita Oy
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    sleep   10s
    ${oppo_name}      run keyword  CreateAOppoFromAccount_HDC      ${contact_name}
    go to entity   ${oppo_name}
    ClickingOnCPQ  ${oppo_name}
    AddProductToCart   Fiksunetti
    Run Keyword If    '${r}'== 'b2b'    run keyword    UpdateAndAddSalesType    Fiksunetti
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    OrderNextStepsPage
    getOrderStatusBeforeSubmitting
    sleep  60s
    clickOnSubmitOrder
    ${order_no}  run keyword  getOrderStatusAfterSubmitting
    getMultibellaCaseGUIID   ${order_no}