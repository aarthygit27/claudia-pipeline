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
     [Tags]     BQA-11305   AUTOLIGHTNING   rerun
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
