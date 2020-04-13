*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Login.robot
Resource          ../../frontendsanity/resources/Opportunity.robot
Resource          ../../frontendsanity/resources/CPQ.robot
Resource          ../../frontendsanity/resources/Quote.robot
Resource          ../../frontendsanity/resources/Order.robot
Resource          ../../frontendsanity/resources/Variables.robot
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
    #Adding partner and competitor
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
    Go To Entity    Digita Oy
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


DNS - Asset Verification
    [Tags]  BQA-12672
    [Documentation]  This script is designed to validate Technical Contact Information on Asset for DNS product by B2B user
    Go To Salesforce and Login into Lightning   System Admin
    Go to Entity  ${LIGHTNING_TEST_ACCOUNT}
    Delete all assets
    logoutAsUser   ${SALES_ADMIN_APP_USER}
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    ${contact}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact}.this is name
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
#    ${billing_acc_name}    run keyword    CreateABillingAccount     $${B2O Account}
#   log to console    ${billing_acc_name}.this is billing account name
    Go To Entity    ${oppo_name}
    ClickingOnCPQ    ${oppo_name}
    search products   ${pdtname}
    Adding Products   ${pdtname}
    updating setting Telia Domain Name space
    UpdateAndAddSalesType  ${pdtname}
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    sleep  40s
    SearchAndSelectBillingAccount   ${LIGHTNING_TEST_ACCOUNT}
    SelectingTechnicalContactforTeliaDomainNameService  ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo   ${billing_acc_name_comm1}
    clickOnSubmitOrder
    ${Ordernumber}  run keyword  getOrderStatusAfterSubmitting
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Go To Salesforce and Login into Lightning       System Admin
    Go To  ${Order_url}
    ${SubscriptionID}   run keyword  FetchfromOrderproduct  ${Ordernumber}
    log to console    ${SubscriptionID}.is a subscription ID
    Validate technical contact in the asset history page using subscription as  ${SubscriptionID}  ${contact_name}
