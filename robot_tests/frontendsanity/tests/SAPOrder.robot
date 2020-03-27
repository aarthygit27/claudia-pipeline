*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Login.robot
Resource          ../../frontendsanity/resources/Opportunity.robot
Resource          ../../frontendsanity/resources/CPQ.robot
Resource          ../../frontendsanity/resources/OtherSystem.robot
Resource          ../../frontendsanity/resources/Order.robot
Resource          ../../frontendsanity/resources/Variables.robot


*** Test Cases ***

SAP Order
    [Tags]  BQA-12512
    [Documentation]     This script is designed for Digita Oy. If account is changed, the corresponding group id has to be changed for the script to work. SAP contract id hardcoded as it is getting failed nowadys.
    set test variable   ${Account}    Digita Oy
    #Login to Salesforce as DigiSales Lightning User   ${B2O_DIGISALES_LIGHT_USER}   ${B2O_DIGISALES_LIGHT_PASSWORD}
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${Account}
    ${contact}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact}.this is name
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
    ${billing_acc_name}    run keyword    CreateABillingAccount     ${Account}
    log to console    ${billing_acc_name}.this is billing account name
    Go To Entity    ${oppo_name}
    ChangeThePriceList      B2O
    ClickingOnCPQ    ${oppo_name}
    Adding Vula    VULA
    Update Setting Vula   VULA
    UpdatePageNextButton
    View Open Quote
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    Close and submit
    Enter Group id and submit
    Reload page
    ValidateSapCallout