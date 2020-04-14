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


*** Test Cases ***

Sync_quote
    [Tags]  BQA-12587       SyncQuote
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go to Entity   ${oppo_name}
    clickingoncpq   ${oppo_name}
    search products  Telia Cid
    Adding Products  Telia Cid
    updating setting Telia Cid
    UpdateAndAddSalesType  Telia Cid
    Go to Entity   ${oppo_name}
    reload page
    clickingoncpq  ${oppo_name}
    create another quote with same opportunity
    Sync quote