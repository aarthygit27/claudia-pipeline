*** Settings ***
Library           SeleniumLibrary
Library           String
Library           Dialogs
Library           Screenshot
Library           DateTime
Library           Collections
Library           OperatingSystem

*** Keywords ***
General Setup
    [Arguments]    ${price_list}    ${test_account}
    Open Salesforce and Login into Lightning   #sitpo admin
    Go To Entity    ${test_account}
    ${contact}  run keyword    Create New Contact for Account
    Set Test Variable    ${contact_name}  ${contact}
    ${opportunity}    run keyword    Create Opportunity    ${contact_name}
    Set Test Variable    ${oppo_name}   ${opportunity}
    ${billing_acc_name}    run keyword    CreateABillingAccount
    Set Test Variable    ${billingaccount}   ${billing_acc_name}
    Go To Entity    ${opportunity}
    Scroll Page To Element       //span[text()='Price List']
    ${price_list_old}=     get text     //span[text()='Price List']//following::a
    Log to console      old pricelist is ${price_list_old}
    ${compare}=    Run Keyword And Return Status    Should Be Equal As Strings    ${price_list_old}    ${price_list}
    Run Keyword If    ${compare}== False   Log to console    Change Pricielist
    Run Keyword If    ${compare}== False   Edit Opportunity Page     Price List  ${price_list}
    ClickingOnCPQ   ${oppo_name}
   #sleep  15s