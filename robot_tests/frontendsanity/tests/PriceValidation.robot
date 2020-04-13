*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Login.robot
Resource          ../../frontendsanity/resources/Order.robot
Resource          ../../frontendsanity/resources/Contact.robot
Resource          ../../frontendsanity/resources/Opportunity.robot
Resource          ../../frontendsanity/resources/Quote.robot
Resource          ../../frontendsanity/resources/Variables.robot


*** Test Cases ***

Price input for unmodeled products in omniscript
    [Tags]    BQA-9160      AUTOLIGHTNING          OpportunityValidation
    [Documentation]    Validate OTC and MRC in quote and opportunity
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go to Entity  ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer     ACTIVEACCOUNT
    ClickingOnCPQ       ${OPPORTUNITY_NAME}
    Add product to cart (CPQ)  Datainfo DaaS-palvelu
    Update products OTC and RC
    Check prices are correct in quote line items
    Go to Entity  ${OPPORTUNITY_NAME}
    Check opportunity value is correct

Lightning - FYR Calculation for B2B
     [Tags]     BQA-11305   AUTOLIGHTNING   OpportunityValidation
     [Documentation]    Add products to cart, calculate otc, mrc. Validate FYR and revenue.
    Go To Salesforce and Login into Lightning       B2B DigiSales
     Go to Entity    Kotipizza Group Oyj
     ${contact_name}   run keyword    Create New Contact for Account
     ${oppo_name}      run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
     Go to Entity   ${oppo_name}
     clickingoncpq   ${oppo_name}
     search products    ${B2bproductfyr1}
     Adding Products for Telia Sopiva Pro N    ${B2bproductfyr1}
     Adding Products for Telia Sopiva Pro N child products  ${B2bproductfyr2}   ${B2bproductfyr3}
     Validate the MRC and OTC and Opportunity total in CPQ  ${B2bproductfyr1}   ${B2bproductfyr2}   ${B2bproductfyr3}
     UpdateAndAddSalesType for B2b products     ${B2bproductfyr1}   ${B2bproductfyr2}
     Go to Entity   ${oppo_name}
     ${lineitem_total}  ${fyr_total}    validate createdOPPO for products     ${oppo_name}
     ${Revenue_Total}   ${fyrt_total}   validate createOPPO values against quote value    ${oppo_name}
     validate lineitem totals in quote  ${oppo_name}    ${lineitem_total}  ${fyr_total}
     clickoncreateorderbutton
     clickonopenorderbutton
     NextButtonOnOrderPage
     OrderNextStepsPage
     validatation on order page     ${fyrt_total}    ${Revenue_Total}


Validate FYR values in Oppo page created through SVE
    [Documentation]  This script is designed to  validate and verify the FYR values in Opportunity page  based on SalesType selected for the multiple products added SVE by using  B2B user
    [Tags]  BQA-13171
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    ${contact}    run keyword    CreateAContactFromAccount_HDC
    Log to console    ${contact}.this is name
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
    Go To Entity   ${oppo_name}
    clickingOnSolutionValueEstimate     ${oppo_name}
    sleep  10s
    ${fyr_total}  Add multiple products in SVE  @{LIST}
    reload page
    sleep  10s
    ${new}  ${ren}  ${frame}   validateproductsbasedonsalestype  @{LIST}
    reload page
    sleep  10s
    Validating FYR values in Opportunity Header   ${fyr_total}  ${new}  ${ren}  ${frame}


FYR calculation with annually recurring charges
    [Tags]  BQA-13123
    Go To Salesforce and Login into Lightning   B2B DigiSales
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    ${contact}    run keyword    Create New Contact for Account
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity    ${oppo_name}
    clickingOnSolutionValueEstimate    ${oppo_name}
    ${fyr}    run keyword    addProductsViaSVE    Telia Domain Name Service
    Go To Entity    ${oppo_name}
    validateCreatedOppoForFYR   Telia Domain Name Service  ${fyr}
    clickingOnSolutionValueEstimate    ${oppo_name}
    ${fyr_new}    run keyword   Mofify the contract length and validate in the opportunity page
    Go To Entity    ${oppo_name}
    validateCreatedOppoForFYR   Telia Domain Name Service  ${fyr_new}
    ClickingOnCPQ     ${oppo_name}
    Adding prouct To cart (cpq) without Next   Telia Domain Name Service
    ${Annual Recurring charge}  ${Monthly recurring chage}  ${One time total}      run keyword      Add Finnish_Domain_Service
    updating setting Telia Domain Name space  Telia Domain Name Service
    UpdateAndAddSalesType  Telia Domain Name Service
    Validation of Telia Domain Name Service   ${Annual Recurring charge}  ${Monthly recurring chage}  ${One time total}


Validate FYR values created through CPQ page in Oppo page
    [Tags]  BQA-13173
    @{products}    Set Variable    Alerta projektointi    Fiksunetti    Telia Chat    Telia Verkkotunnuspalvelu    Genesys PureCloud
    Go To Salesforce and Login into Lightning   B2B DigiSales
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    ${contact}    run keyword    Create New Contact for Account
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity    ${oppo_name}
    ClickingOnCPQ   ${oppo_name}
    Searching and adding multiple products    @{products}
    updateandaddsalestype for multiple products with different salestype  @{products}
    Go To Entity    ${oppo_name}