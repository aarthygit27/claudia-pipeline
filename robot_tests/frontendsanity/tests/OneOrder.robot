*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Login.robot
Resource          ../../frontendsanity/resources/Account.robot
Resource          ../../frontendsanity/resources/Contact.robot
Resource          ../../frontendsanity/resources/Opportunity.robot
Resource          ../../frontendsanity/resources/CPQ.robot
Resource          ../../frontendsanity/resources/Quote.robot
Resource          ../../frontendsanity/resources/Order.robot
Resource          ../../frontendsanity/resources/OtherSystem.robot
Resource          ../../frontendsanity/resources/Variables.robot


*** Test Cases ***

One Order - B2B Colocation and Change Order
    [Tags]  BQA-11521       OneOrder
    [Documentation]    Create new order with product B2B Telia colocation and then perform change order
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go to Entity    ${vLocUpg_TEST_ACCOUNT}
    Delete all assets
    logoutAsUser   ${SALES_ADMIN_APP_USER}
    Go To Salesforce and Login into Lightning       B2B DigiSales
    HDC Order
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Go To Salesforce and Login into Lightning       System Admin
    DDM Request Handling
    Open Browser And Go To Login Page
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go to   ${url}
    Validate Billing system response
    Log to console   Entering change Order
    Change Order
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Go To Salesforce and Login into Lightning       System Admin
    DDM Request Handling
    Open Browser And Go To Login Page
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go to   ${url}
    Validate Billing system response
    Capture Page Screenshot

One Order- B2O Colocation and change order
    [Tags]  BQA-11523       OneOrder
    [Documentation]    Create new order with product B2O Telia colocation and then perform change order
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go to Entity   ${vLocUpg_TEST_ACCOUNT}
    Delete all assets
    logoutAsUser   ${SALES_ADMIN_APP_USER}
    Go To Salesforce and Login into Lightning       B2O User
    HDC Order
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Go To Salesforce and Login into Lightning       System Admin
    DDM Request Handling
    Switch between windows    0
    logoutAsUser   ${SYSTEM_ADMIN_USER}
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go to   ${url}
    Validate Billing system response
    Change Order
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Go To Salesforce and Login into Lightning       System Admin
    DDM Request Handling
    Switch between windows    0
    logoutAsUser  ${SYSTEM_ADMIN_USER}
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go to   ${url}
    Validate Billing system response
    Capture Page Screenshot
    Go to Entity    ${vLocUpg_TEST_ACCOUNT}
    Terminate asset     Telia Colocation


One Order- B2B Colocation, Case management product, Modeled Case management product
    [Tags]  BQA-11522       OneOrder
    [Documentation]    Create new order with product B2B Telia colocation , Arkkitehti, CID and then perform change order
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact}.this is name
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
    ${billing_acc_name}    run keyword    CreateABillingAccount   ${vLocUpg_TEST_ACCOUNT}
    log to console    ${billing_acc_name}.this is billing account name
    Go To Entity    ${oppo_name}
    ChangeThePriceList      B2B
    ClickingOnCPQ    ${oppo_name}
    Adding Telia Colocation    Telia Colocation
    Updating Setting Telia Colocation without Next
    Adding Arkkitehti   Arkkitehti
    Adding Telia Cid    Telia Cid
    Updating Setting Telia Cid
    UpdateAndAddSalesType for 3 products and check contract    Telia Colocation   Arkkitehti  Telia Cid
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount   ${vLocUpg_TEST_ACCOUNT}
    select order contacts- HDC  ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    ${billing_acc_name}
    clickOnSubmitOrder
    ValidateTheOrchestrationPlan
    Go to   ${url}
    Validate Call case Management status
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Go To Salesforce and Login into Lightning       System Admin
    DDM Request Handling
    Open Browser And Go To Login Page
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go to   ${url}
    Validate Billing system response
    Validate Order status
    #Validate Billing account