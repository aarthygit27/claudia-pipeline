*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
#Library             test123.py


*** Test Cases ***

Check banner for customership and service contract
    [Documentation]    Create new opportunity for account without service contract and verify that service contract draft is automatically created
    [Tags]      BQA-10334    AUTOLIGHTNING      ContractManagement
    Go To Salesforce and Login into Lightning        System Admin
    Go To Entity    ${CONTRACT_ACCOUNT}
    Delete all entities from Accounts Related tab      Contracts
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${CONTRACT_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Verify that warning banner is displayed on opportunity page   ${OPPORTUNITY_NAME}
    ClickingOnCPQ       ${OPPORTUNITY_NAME}
    Add product to cart (CPQ)    Telia Verkkotunnuspalvelu
    Update products
    Go To Entity    ${CONTRACT_ACCOUNT}
    Check service contract is on Draft Status

Create contact relationship for account
    [Documentation]    Add new relationship for contact and check that account are displayed correctly on contact page.
    [Tags]     BQA-10523    AUTOLIGHTNING     ContactsManagement
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Contact for Account
    Add relationship for the contact person
    Go to Entity    ${contact_name}
    Validate contact relationship

Lightning_Customership Contract
     [Tags]  BQA-12655
     [Documentation]    Create Customership Contract
     Go To Salesforce and Login into Lightning       DigiSales Admin
     Go To Entity    ${CONTRACT_ACCOUNT}
     Create contract Agreement  Customership

Lightning_Service Contract
    [Tags]  BQA-12666
    [Documentation]    Create Service Contract
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go To Entity    ${CONTRACT_ACCOUNT}
    Delete all entities from Accounts Related tab   Contracts
    Create contract Agreement  Customership
    ${Contract_Number}  set variable  ${Customer_contract}
    Create contract Agreement  Service  ${Contract_Number}

Check of Customership Contract
    [Tags]   BQA-11427
    [Documentation]    Validate banner for customership contract
    set Test variable    ${account}   Telia Communication Oy
    Go To Salesforce and Login into Lightning       System Admin
    Go To Entity    ${account}
    Delete all existing contracts from Accounts Related tab
    Set Test Variable   ${contact_name}   Testing Contact_ 20190924-174806
    ${oppo_name}   run keyword  CreateAOppoFromAccount_HDC  ${contact_name}
    Verify warning banner on oppo page   ${oppo_name}
    Go to account from oppo page
    Create contract Agreement  Customership
    ${Contract_A_Number}  set variable  ${Customer_contract}
    Go To Entity    ${account}
    ${oppo_name}   run keyword  CreateAOppoFromAccount_HDC  ${contact_name}
    Verify that warning banner is not displayed on opportunity page  ${oppo_name}
    Verify Populated Cutomership Contract   ${Contract_A_Number}
    Go to account from oppo page
    Create contract Agreement  Service  ${Contract_A_Number}
    Go To Entity    ${account}
    Create contract Agreement  Customership
    ${Contract_B_Number}   set variable  ${Customer_contract}
    Change Merged Status   ${Contract B_Number}
    Go To Entity    ${account}
    ${oppo_name}   run keyword  CreateAOppoFromAccount_HDC  ${contact_name}
    Verify Warning banner about existing of duplicate contract  ${oppo_name}
    Verify Populated Cutomership Contract   ${Contract_A_Number}
    Change Merged Status  ${Contract_A_Number}
    Change Merged Status  ${Contract_B_Number}
    Go To Entity    ${account}
    ${oppo_name}   run keyword  CreateAOppoFromAccount_HDC  ${contact_name}
    Verify Warning banner about existing of duplicate contract  ${oppo_name}
    Verify Populated Cutomership Contract   ${Contract_B_Number}
    Go to account from oppo page
    Create contract Agreement  Service  ${Contract_B_Number}
    Change Merged Status  ${Contract_A_Number}
    Go To Entity    ${account}
    ${oppo_name}   run keyword  CreateAOppoFromAccount_HDC  ${contact_name}
    Verify Warning banner about Manual selection of contract  ${oppo_name}
    Verify Populated Cutomership Contract  ${EMPTY}
    Select Customer ship contract manually   ${Contract_A_Number}
