*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          Keywords.robot
Resource          Variables.robot
Resource          ../../resources/common.robot

*** Variables ***
${LIGHTNING_TEST_ACCOUNT}           9Lives Oy
${ENVIRONMENT}                      rel

*** Test Cases ***

Create opportunity from Account
    [Documentation]    Create new opportunity and validate in accounts related tab search in salesforce
    ...    and then in My all open Opportunities section.
    [Tags]    BQA-8393    AUTOLIGHTNING        OpportunityValidation
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Verify That Opportunity is Found From My All Open Opportunities

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