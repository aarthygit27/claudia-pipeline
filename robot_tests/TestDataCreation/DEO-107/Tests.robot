*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          Keywords.robot
Resource          Variables.robot
Resource          ../../resources/common.robot

*** Variables ***
${LIGHTNING_TEST_ACCOUNT}           testmerge8
${ENVIRONMENT}                      fesit

*** Test Cases ***

Create opportunity from Account
    [Documentation]    Open Oppo, Contact, Open Order, Closed Case.
    [Tags]    BQA-8393    AUTOLIGHTNING        OpportunityValidation
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    ${contact}  run keyword    Create New Contact for Account
    Set Test Variable    ${contact_name}  ${contact}
    ${opportunity}    run keyword    Create Opportunity    ${contact_name}
    Set Test Variable    ${oppo_name}     ${opportunity}
    Go To Entity    ${oppo_name}
    Create case from more actions
    Go To Entity    ${oppo_name}
    ClickingOnCPQ    ${oppo_name}
    AddProductToCart    Fiksunetti
    UpdateAndAddSalesTypeandClickDirectOrder    Fiksunetti
    #View Open Quote
    #openOrderFromDirecrOrder
    getorderstatusbeforesubmitting
    clickonsubmitorder
    ${order_no}    run keyword    getorderstatusaftersubmitting
    #go to entity    ${order_no}
    getMultibellaCaseGUIID    ${order_no}
    #Close this order

Create Customership Contract
     [Tags]  BQA-12655
     [Documentation]    Create Customership Contract
     Go To Salesforce and Login into Lightning       DigiSales Admin
     Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
     Create contract Agreement  Customership

Create DNS Order
    [Documentation]    To create new P&O order adding Telia Domain Name Service, Other Domain name and DNS Primary
    [Tags]    BQA-11509     PO_Scripts     RunTest
    General Setup    B2B    ${LIGHTNING_TEST_ACCOUNT}
    Searching and adding product    Telia Domain Name Service
    Update Setting for Telia Domain Name Service     russianpupu.ru
    Add Other Domain Name and update settings       .RU     1       35.00
    Add DNS Primary
    #update_setting_Telia Domain Name Service
    clicking on next button
    Update Product Page    Telia Domain Name Service
    Create_Order


Create Case
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    ${oppo_name}      run keyword  CreateAOppoFromAccount_HDC      ${contact_name}
    Go To Entity    ${oppo_name}
    Create case from more actions

create a Colocation Order
    [Tags]    BQA-10813    AUTOLIGHTNINGOLD       B2BOrderManagement
    General Setup    B2B    ${LIGHTNING_TEST_ACCOUNT}
    Adding Telia Colocation    Telia Colocation
    Updating Setting Telia Colocation
    UpdateAndAddSalesType    Telia Colocation
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount   ${LIGHTNING_TEST_ACCOUNT}