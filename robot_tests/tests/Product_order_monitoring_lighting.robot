*** Settings ***
Documentation     Suite description
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/Product_order_monitoring_lighting_keywords.robot
Resource          ../resources/Product_order_monitoring_lighting_variables.robot
Resource          ../resources/sales_app_light_variables.robot

*** Test Cases ***
Create opportunity from Account for telia yritysinternet
    [Tags]    Product_monitoring
    General setup    ${B2B_LIGHT_USER}    ${PASSWORD_LIGHT}
    ${oppo_name}=    creating opportunity
    ClickingOnCPQ    ${oppo_name}
    search products    telia yritysinternet
    Adding Products    ${Telia_yritysinternet}
    Updating setting Telia_yritysinternet
    sleep    10s
    order creation    telia yritysinternet
    #sleep    10s
    Capture Page Screenshot

Create opportunity from Account for HDCFlow
    [Tags]    Product_monitoring
    General setup    ${B2B_LIGHT_USER}    ${PASSWORD_LIGHT}
    sleep    10s
    ${oppo_name}=    creating opportunity
    ChangeThePriceBookToHDC    HDC Pricebook B2B
    ClickingOnCPQ    ${oppo_name}
    search products    Telia Colocation
    Adding Products    ${Telia_Colocation}
    Updating Setting Telia Colocation
    UpdateAndAddSalesType    Telia Colocation
    OpenQuoteButtonPage
    #CreditScoreApproving
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount
    SelectingTechnicalContact    ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    ${TEST_ACCOUNT_CONTACT}
    ReviewPage
    ValidateTheOrchestrationPlan
    #Reach the Order Page and Validating the details
    #wait until page contains element    //span[text()='Order']//following::div/span[@class='uiOutputText']
    #${order_id}=    get text    //span[text()='Order']//following::div/span[@class='uiOutputText']
    #spage should contain element    //th/div/a[text()='Telia Colocation']
    #page should contain element    //th/div/a[text()='Telia Colocation']//following::td/span[text()='New Money-New Services']
    #Execute JavaScript    window.scrollTo(0,2000)
    #page should contain element    //th[@title='Orchestration Plan Name']//following::div[@data-aura-class='forceOutputLookupWithPreview']/a
    #click element    //th[@title='Orchestration Plan Name']//following::div[@data-aura-class='forceOutputLookupWithPreview']/a
    #sleep    20s
