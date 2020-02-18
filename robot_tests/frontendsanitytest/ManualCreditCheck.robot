*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
#Library             test123.py


*** Test Cases ***

Manual Credit Check Enquiry with postive
    [Tags]  BQA-12600
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${TEST_CONTACT}
    ${contact_name}    run keyword    Create New Contact for Account
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    ${billing_acc_name}    run keyword    CreateABillingAccount  ${TEST_CONTACT}
    Go to Entity   ${oppo_name}
    clickingoncpq   ${oppo_name}
    Add product to cart (CPQ)  Telia Chat
    UpdateAndAddSalesType  Telia Chat
    ${value}   ${quote_number}  run keyword    Manual Credit enquiry Button
    logoutAsUser  B2B DigiSales
    sleep  20s
    Go To Salesforce and Login into Lightning       System Admin
    swithchtouser  Credit Control
    Activate The Manual Credit enquiry with positive   ${value}   Positive
    Go To Salesforce and Login into Lightning       B2B DigiSales
    ScrollUntillFound  //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Positive.")]
    page should contain element    //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Positive.")]
    Search Salesforce    ${quote_number}
    Select Entity    ${oppo_name}    ${EMPTY}
    credit score status after approval
    Check the credit score result of the case with postive
    clickOnSubmitOrder
    ValidateTheOrchestrationPlan

Manual Credit Check Enquiry with postive and condition
    [Tags]  BQA-12674
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${TEST_CONTACT}
    ${contact_name}    run keyword    Create New Contact for Account
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    ${billing_acc_name}    run keyword    CreateABillingAccount  ${TEST_CONTACT}
    Go to Entity   ${oppo_name}
    clickingoncpq   ${oppo_name}
    Add product to cart (CPQ)  Telia Chat
    UpdateAndAddSalesType  Telia Chat
    ${value}   ${quote_number}  run keyword    Manual Credit enquiry Button
    logoutAsUser  B2B DigiSales
    sleep  20s
    Go To Salesforce and Login into Lightning       System Admin
    swithchtouser  Credit Control
    Activate The Manual Credit enquiry with positive with condition   ${value}  Positive with Conditions
    Go To Salesforce and Login into Lightning       B2B DigiSales
    ScrollUntillFound  //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Positive.")]
    page should contain element    //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Positive with Conditions.")]
    Search Salesforce    ${quote_number}
    Select Entity    ${oppo_name}    ${EMPTY}
    credit score status after approval
    Check the credit score result of the case with Positive with Conditions
    SearchAndSelectBillingAccount   ${TEST_CONTACT}
    select order contacts- HDC  ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    ${billing_acc_name}
    clickOnSubmitOrder
    ValidateTheOrchestrationPlan

Manual Credit Check Enquiry with Negative
    [Tags]  BQA-12673
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${TEST_CONTACT}
    ${contact_name}    run keyword    Create New Contact for Account
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    ${billing_acc_name}    run keyword    CreateABillingAccount  ${TEST_CONTACT}
    Go to Entity   ${oppo_name}
    clickingoncpq   ${oppo_name}
    Add product to cart (CPQ)  Telia Chat
    UpdateAndAddSalesType  Telia Chat
    ${value}   ${quote_number}  run keyword    Manual Credit enquiry Button
    logoutAsUser  B2B DigiSales
    sleep  20s
    Go To Salesforce and Login into Lightning       System Admin
    swithchtouser  Credit Control
    Activate The Manual Credit enquiry with Negative    ${value}   Negative
    Go To Salesforce and Login into Lightning       B2B DigiSales
    ScrollUntillFound  //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Negative.")]
    page should contain element    //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Negative.")]
    Search Salesforce    ${quote_number}
    Select Entity    ${oppo_name}    ${EMPTY}
    credit score status after approval
    SearchAndSelectBillingAccount   ${TEST_CONTACT}
    select order contacts- HDC  ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    ${billing_acc_name}
    clickOnSubmitOrder
    ValidateTheOrchestrationPlan

Manual Credit Check Enquiry with No Result
    [Tags]  BQA-12675
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${TEST_CONTACT}
    ${contact_name}    run keyword    Create New Contact for Account
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    ${billing_acc_name}    run keyword    CreateABillingAccount  ${TEST_CONTACT}
    Go to Entity   ${oppo_name}
    clickingoncpq   ${oppo_name}
    Add product to cart (CPQ)  Telia Chat
    UpdateAndAddSalesType  Telia Chat
    sleep  20s