*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
#Library             test123.py


*** Test Cases ***

One Order - B2B Colocation and Change Order
    [Tags]  BQA-11521
    [Documentation]    Create new order with product B2B Telia colocation and then perform change order
    Login to Salesforce Lightning   ${SALES_ADMIN_APP_USER}  ${PASSWORD-SALESADMIN}
    Go to Entity    ${vLocUpg_TEST_ACCOUNT}
    Delete all assets
    logoutAsUser   ${SALES_ADMIN_APP_USER}
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    HDC Order
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Login to Salesforce Lightning   ${SYSTEM_ADMIN_USER}  ${SYSTEM_ADMIN_PWD}
    DDM Request Handling
    Open Browser And Go To Login Page
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go to   ${url}
    Validate Billing system response
    Log to console   Entering change Order
    Change Order
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Login to Salesforce Lightning  ${SYSTEM_ADMIN_USER}  ${SYSTEM_ADMIN_PWD}
    DDM Request Handling
    Open Browser And Go To Login Page
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go to   ${url}
    Validate Billing system response
    Capture Page Screenshot



One Order- B2O Colocation and change order
    [Tags]  BQA-11523
    [Documentation]    Create new order with product B2O Telia colocation and then perform change order
    Login to Salesforce Lightning   ${SALES_ADMIN_APP_USER}  ${PASSWORD-SALESADMIN}
    Go to Entity   ${vLocUpg_TEST_ACCOUNT}
    Delete all assets
    logoutAsUser   ${SALES_ADMIN_APP_USER}
    Login to Salesforce as DigiSales Lightning User   ${B2O_DIGISALES_LIGHT_USER}   ${B2O_DIGISALES_LIGHT_PASSWORD}
    HDC Order
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Login to Salesforce Lightning   ${SYSTEM_ADMIN_USER}  ${SYSTEM_ADMIN_PWD}
    DDM Request Handling
    Switch between windows    0
    logoutAsUser   ${SYSTEM_ADMIN_USER}
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go to   ${url}
    Validate Billing system response
    Change Order
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Login to Salesforce Lightning  ${SYSTEM_ADMIN_USER}  ${SYSTEM_ADMIN_PWD}
    DDM Request Handling
    Switch between windows    0
    logoutAsUser  ${SYSTEM_ADMIN_USER}
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go to   ${url}
    Validate Billing system response
    Capture Page Screenshot
    Go to Entity    ${vLocUpg_TEST_ACCOUNT}
    Terminate asset     Telia Colocation


One Order- B2B Colocation, Case management product, Modeled Case management product
    [Tags]  BQA-11522
    [Documentation]    Create new order with product B2B Telia colocation , Arkkitehti, CID and then perform change order
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
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
    Login to Salesforce Lightning   ${SYSTEM_ADMIN_USER}  ${SYSTEM_ADMIN_PWD}
    DDM Request Handling
    Open Browser And Go To Login Page
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go to   ${url}
    Validate Billing system response
    Validate Order status
    Validate Billing account