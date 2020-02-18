*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
#Library             test123.py


*** Test Cases ***

Create B2O Order
    [Tags]    BQA-8920    AUTOLIGHTNING         B2OOrderManagement
    [Documentation]     Create Order by adding B2O Other services into cart
    Login to Salesforce as DigiSales Lightning User
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    Create New Contact for Account
    sleep    10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity    ${oppo_name}
    ChangeThePriceList      B2O
    ClickingOnCPQ    ${oppo_name}
    AddProductToCart    B2O Other Services
    Run keyword If    '${p}'== 'b2o'    run keyword    UpdateAndAddSalesTypeB2O    B2O Other Services
    ${quote_number}    Run Keyword    preview and submit quote  ${oppo_name}
    verifying quote and opportunity status      ${oppo_name}
    Search Salesforce    ${quote_number}
    Select Entity    ${oppo_name}    ${EMPTY}
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    OrderNextStepsPage
    getOrderStatusBeforeSubmitting
    clickOnSubmitOrder
    getOrderStatusAfterSubmitting
    Go to Entity    ${oppo_name}
    Closing the opportunity with reason    Closed Won
    Verify That Opportunity is Found From My All Opportunities  ${oppo_name}