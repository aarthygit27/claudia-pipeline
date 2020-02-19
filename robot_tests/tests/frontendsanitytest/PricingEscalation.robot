*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
#Library             test123.py


*** Test Cases ***

Pricing Escalation
    [Tags]   BQA-11368
    [Documentation]    Create Pricing escatalation case and then complete the approval flow by endorser and approver
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    logoutAsUser  ${B2B_DIGISALES_LIGHT_USER}
    Login to Salesforce as DigiSales Lightning User  ${PM_User}  ${PM_PW}
    Go To Entity  ${oppo_name}
    Create Pricing Request
    ${Case_number}   run keyword   Create Pricing Escalation
    Submit for approval   Pricing Escalation
    Case Approval By Endorser   ${Case_number}  ${oppo_name}
    Case Approval By Approver   ${Case_number}  ${oppo_name}
    Verify case Status by PM   ${Case_number}
    Verify case Status by Endorser   ${Case_number}  Approved
    Case Not visible to Normal User    ${Case_number}

Pricing Escalation - Rejection
    [Tags]   BQA-11386
    [Documentation]    Create Pricing
    Go To Salesforce and Login into Lightning       System Admin
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    #${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    Test RT
    logoutAsUser    ${SYSTEM_ADMIN_USER}
    Go To Salesforce and Login into Lightning       Pricing Manager
    Login to Salesforce Lightning   ${PM_User}  ${PM_PW}
    Go To Entity  ${oppo_name}
    Create Pricing Request
    ${Case_number}   run keyword   Create Pricing Escalation
    Submit for approval  Pricing Escalation
    Case Approval By Endorser   ${Case_number}  ${oppo_name}
    Case Rejection By Approver   ${Case_number}  ${oppo_name}
    #Verify case Status by PM  ${Case_number}  Rejected    --- Not notified. Raised Bug
    Verify case Status by Endorser  ${Case_number}   Rejected
    Case Not visible to Normal User  ${Case_number}
