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
    General setup    ${SALES_ADMIN_USER_RELEASE}    ${SALEADM_PASSWORD_RELEASE}
    ${oppo_name}=    creating opportunity
    Go To Entity    ${oppo_name}
    sleep    30s
    ClickingOnCPQ    ${oppo_name}
    search products    Telia Yritysinternet
    Adding Products    ${Telia_yritysinternet}
    Updating setting Telia_yritysinternet
    sleep    10s
    order creation    Telia Yritysinternet
    #sleep    10s
    Capture Page Screenshot

Create opportunity from Account for HDCFlow
    [Tags]    Product_monitoring    HDC_montoring
    General setup    ${SALES_ADMIN_USER_RELEASE}    ${SALEADM_PASSWORD_RELEASE}
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
    SelectOwnerAccountInfo    ${vLocUpg_TEST_ACCOUNT}
    ReviewPage
    ValidateTheOrchestrationPlan

Create opportunity from Account for B2O other services
    General setup    ${SALES_ADMIN_USER_RELEASE}    ${SALEADM_PASSWORD_RELEASE}
    sleep    10s
    ${oppo_name}=    creating opportunity
    ChangeThePriceBookToHDC    HDC Pricebook B2O
    ClickingOnCPQ    ${oppo_name}
    search products    B2O Other Services
    Adding Products    ${B2O_Other_Services}
    Updating setting B2O other services
    UpdateAndAddSalesTypeB2O    B2O Other Services
    OpenQuoteButtonPage
    #CreditScoreApproving
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount
    SelectingTechnicalContact    ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    ${vLocUpg_TEST_ACCOUNT}
    ReviewPage
    ValidateTheOrchestrationPlan

<<<<<<< HEAD
    [Tags]    BQA-B2BOrder    Lightning3
    General setup    ${SALES_ADMIN_USER_RELEASE}    ${SALEADM_PASSWORD_RELEASE}

=======
    [Tags]    Product_monitoring    HDC_montoring
    General setup    ${B2B_LIGHT_USER}    ${PASSWORD_LIGHT}
    sleep    10s

>>>>>>> d8cba9b6ec7b32e8835e51535531a1d7368f8f87
    ${oppo_name}=    creating opportunity
    ChangeThePriceBookToHDC    HDC Pricebook B2O
    ClickingOnCPQ    ${oppo_name}
    search products    B2O Other Services

<<<<<<< HEAD
    Adding Products    ${B2O_Other_services}
    Update Setting B2O other services
    UpdateAndAddSalesTypeB2O    B2O Other Services

=======
    Adding Products    ${B2O_Other_Services}
    Updating setting B2O other services
    UpdateAndAddSalesType    Telia Colocation

>>>>>>> d8cba9b6ec7b32e8835e51535531a1d7368f8f87
    OpenQuoteButtonPage
    #CreditScoreApproving
    ClickonCreateOrderButton
    NextButtonOnOrderPage

<<<<<<< HEAD
    OrderNextStepsPage
    getOrderStatusBeforeSubmitting
    sleep    60s
    clickOnSubmitOrder
    getOrderStatusAfterSubmitting

=======
    SearchAndSelectBillingAccount
    SelectingTechnicalContact    ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    ${vLocUpg_TEST_ACCOUNT}
    ReviewPage
    ValidateTheOrchestrationPlan

>>>>>>> d8cba9b6ec7b32e8835e51535531a1d7368f8f87
