*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Login.robot
Resource          ../../frontendsanity/resources/Opportunity.robot
Resource          ../../frontendsanity/resources/ApprovalProcess.robot
Resource          ../../frontendsanity/resources/Contact.robot
Resource          ../../frontendsanity/resources/Variables.robot

*** Test Cases ***
Investment Process - B2B
    [Tags]   BQA-11387      Investment
    [Documentation]    Create B2B Investment case. Complete the approval flow.
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    Aacon Oy
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity  ${oppo_name}
    ${case_number}  run keyword    Create Investment Case  B2B
    PM details  ${oppo_name}    ${case_number}    B2B
    Case Approval By Endorser   ${case_number}   ${oppo_name}
    Case Approval By Approver   ${case_number}   ${oppo_name}
    Check Case Status  ${case_number}  B2B

Investment Process - B2O
    [Tags]   BQA-11395      Investment
    [Documentation]    Create B2O Investment case. Complete the approval flow.
    Go To Salesforce and Login into Lightning       B2O User
    Go To Entity    ${B2O Account}
    ${oppo_name}   run keyword  CreateAOppoFromAccount_HDC  Test RT
    Go To Entity    ${oppo_name}
    ${case_number}  run keyword    Create Investment Case   B2O
    PM details    ${oppo_name}   ${case_number}  B2O
    Case Approval By Approver   ${Case_number}  ${oppo_name}
    Check Case Status  ${Case_number}  B2O

