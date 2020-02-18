*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
#Library             test123.py


*** Test Cases ***

Create HDC Order
    [Tags]    BQA-11774    AUTOLIGHTNING       HDCOrderManagement
    [Documentation]    Add Telia colocation to opportunity cart, submit order and validate orchestration plan
    Login to Salesforce as DigiSales Lightning User
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    ${billing_acc_name}    run keyword    CreateABillingAccount   ${vLocUpg_TEST_ACCOUNT}
    Go To Entity    ${oppo_name}
    ChangeThePriceList      B2B
    ClickingOnCPQ    ${oppo_name}
    Adding Telia Colocation    Telia Colocation
    Updating Setting Telia Colocation
    UpdateAndAddSalesType    Telia Colocation
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount   ${vLocUpg_TEST_ACCOUNT}
    select order contacts- HDC  ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    ${billing_acc_name}
    clickOnSubmitOrder
    ValidateTheOrchestrationPlan


HDC - Complete Sales Process: UAT/Sanity Regression
    [Tags]    BQA-8560    AUTOLIGHTNING         HDCOrderManagement
    ${win_prob_edit}=    Set Variable    //span[contains(text(),'Win Probability %')]/../../button
    Go To Salesforce and Login into Lightning
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    ${billing_acc_name}    run keyword    CreateABillingAccount  ${vLocUpg_TEST_ACCOUNT}
    Go To Entity    ${oppo_name}
    sleep    10s
    wait until page contains element    ${win_prob_edit}    30s
    click element    ${win_prob_edit}
    Adding partner and competitor
    Sleep  10s
    ChangeThePriceList      B2B
    ClickingOnCPQ    ${oppo_name}
    Adding Telia Colocation    Telia Colocation
    Updating Setting Telia Colocation
    UpdateAndAddSalesType    Telia Colocation
    ClickonCreateOrderButton
    NextButtonOnOrderPage