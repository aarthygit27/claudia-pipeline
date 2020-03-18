*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Login.robot
Resource          ../../frontendsanity/resources/Account.robot
Resource          ../../frontendsanity/resources/Variables.robot
#Library             test123.py


*** Test Cases ***

Check Attributes/Business Account are named right in Sales Force UI
    [Documentation]    To Verify the Business Account Attributes Are Named Right
    [Tags]    BQA-8484    AUTOLIGHTNING        AcccountManagement
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    Verify That Business Account Attributes Are Named Right

Change Account owner for Group Account
    [Documentation]    To change the account  owner for group  account
    [Tags]    BQA-8523     AUTOLIGHTNING      AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go To Entity    ${GROUP_TEST_ACCOUNT}
    Check original account owner and change if necessary
    Validate that account owner was changed successfully    ${NEW_OWNER}
    Validate that account owner has changed in Account Hierarchy

Remove Account owner
    [Documentation]    REmoving the account owner (changing the account owner to GESB Integration)
    [Tags]    BQA-8524    AUTOLIGHTNING      AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go To Entity    ${RemoveAccountOwner}
    Remove change account owner

Lightning: Sales admin Change Account owner
    [Documentation]    Change Business Account owner by logging into Digisales Admin User
    [Tags]    BQA-8525    AUTOLIGHTNING     AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go to Entity    ${TEST_CONTACT}
    Change Account Owner
    #THIS IS A DUPLICATE

Lightning: Sales admin Change Account owner for group account
    [Documentation]    Change Group Account owner by logging into Digisales Admin User
    [Tags]    BQA-8526    AUTOLIGHTNING     AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go to Entity    ${GROUP_TEST_ACCOUNT}
    Change Account Owner

Change business account owner
    [Documentation]    Change owner of the Business account to B2BDigisales Lightning user
    [Tags]    BQA-10736    AUTOLIGHTNING     AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go To Entity    ${businessAccount}
    Change account owner to     B2B Lightning
    Validate that account owner was changed successfully    B2B Lightning

Add an account team member as account owner
    [Tags]    BQA-10524     AUTOLIGHTNING       AccountManagement
    [Documentation]     Log in as digisales user and navigate to business account that you own. Add some user to business account team.
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Check original account owner and change if necessary for event
    logoutAsUser  Sales Admin
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Add new team member     Sales Admin
    Validate that team member is created succesfully

Edit team member's role as account owner
    [Tags]     BQA-10948    AUTOLIGHTNING       AccountManagement
    [Documentation]     Log in as B2B-sales user and edit team member's role when you are the owner of the account.
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Validate that team member is created succesfully
    Change team member role from account

Delete team member as account owner
    [Tags]     BQA-10949       AUTOLIGHTNING        AccountManagement
    [Documentation]     Log in as B2B-sales user and remove team member when you are the owner of the account.
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Validate that team member is created succesfully    Sales,Admin     Account Manager
    Delete team member from account

Add an account team member as Sales Admin
    [Documentation]    Log in as Sales Admin and then add some user as a team member for business account
    [Tags]    BQA-10727     AUTOLIGHTNING       AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Add new team member     Sales Admin
    Validate that team member is created succesfully

Edit team member's role as Sales Admin
    [Documentation]    Log in as Sales Admin and then edit existing team member's role for business account
    [Tags]     BQA-10728     AUTOLIGHTNING          AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Validate that team member is created succesfully
    Change team member role from account

Delete account team member as Sales Admin
    [Documentation]    Log in as Sales Admin and then delete team member from business account
    [Tags]     BQA-10740    AUTOLIGHTNING       AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Validate that team member is created succesfully    Sales,Admin     Account Manager
    Delete team member from account

Add an account team member to Group
    [Documentation]    Log in as Sales Admin and add team member to concern/group
    [Tags]     BQA-10737    AUTOLIGHTNING       AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go to Entity    ${groupAccount}
    Navigate to view    Account Team Members
    Add new team member     Sales Admin
    Validate that team member is created succesfully

Negative: Try to add account owner to Account team
    [Documentation]     Log in as sales admin and try to add the account owner to account team. This should not be possible.
    [Tags]      BQA-10952     AUTOLIGHTNING     AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go to Entity   ${businessAccount}
    Navigate to related tab
    Add account owner to account team
    Validate that account owner can not be added to account team

Negative: Try to add group owner to group's account team
    [Documentation]     Log in as sales admin and try to add group owner to group's account team as a member. This should not be possible.
    [Tags]      BQA-10951       AUTOLIGHTNING       AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go to Entity    ${groupAccount}
    Add account owner to account team
    Validate that account owner can not be added to account team

Group: Edit team member's role
    [Documentation]    Log in as Sales Admin. Go to group and edit existing team member's role.
    [Tags]    BQA-10738    AUTOLIGHTNING        AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go to Entity    ${groupAccount}
    Navigate to view    Account Team Members
    Validate that team member is created succesfully
    Change team member role from account

Group: Delete team member
    [Documentation]    Log in as Sales Admin. Go to group and delete existing team member.
    [Tags]     BQA-10739    AUTOLIGHTNING       AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go to Entity    ${groupAccount}
    Navigate to view    Account Team Members
    Validate that team member is created succesfully    Sales,Admin     Account Manager
    Delete team member from account

Negative: Try to add same team member twice to account team
    [Documentation]     Expected result: It's not possible to add same team member twice to business account's account team.
    [Tags]     BQA-11052       AUTOLIGHTNING        AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go to Entity  ${LIGHTNING_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Try to add same team member twice  B2B Lightning
    Validate that same user can not be added twice to account team
    Delete team member from account

Add several team members to business account team
    [Tags]    BQA-10937    AUTOLIGHTNING          AccountManagement
    [Documentation]     Log in as sales amdin and open business account that is member in some group hierarchy. Add several account team members and validate that
    ...     it's not possible to add same user twice and there can be several users with same role. Validate that it's possible for users to have different roles.
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go to Entity  Digita Oy
    Navigate to related tab
    Navigate to view    Account Team Members
    Delete team member from account
    Add new team member  Sales Admin    Account Manager
    Validate that team member is created succesfully    Sales,Admin     Account Manager
    Add new team member  B2O NetworkSales   Account Manager
    Validate that team member is created succesfully    B2O,NetworkSales    Account Manager
    Add new team member  B2B Lightning  ICT Architect
    Validate that team member is created succesfully    B2B,Lightning   ICT Architect
    Try to add same team member twice   GESB Integration
    Validate that same user can not be added twice to account team
    Delete team member from account

Group: Account team member is added as group owner
    [Documentation]     Account team member is added as group owner. History is checked and it should contain record about changing the owner.
    ...     Check that new owner is removed from the account team.
    [Tags]      BQA-10933       AUTOLIGHTNING       AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go to Entity    ${groupAccount}
    Check original account owner and change if necessary for event
    Navigate to view    Account Team Members
    Add new team member     Sales Admin
    Validate that team member is created succesfully  Sales,Admin
    Go to Entity    ${groupAccount}
    Change account owner to     Sales Admin
    Validate that account owner was changed successfully  Sales Admin
    Navigate to view    Account Team Members
    Wait until page contains element    ${noitems}       30s
    Go to Entity    ${groupAccount}
    Navigate to Account History
    Validate that Account history contains record   Sales Admin
    Go to Entity    ${groupAccount}
    Change account owner to  B2B Lightning
    Validate that account owner was changed successfully  B2B Lightning

Negative: Try to change account owner different from the group account owner
    [Documentation]     Log in as sales admin and find Business account from group hierarchy. Try to change the Business Account owner different from
    ...     the group account owner. This should not be possible.
    [Tags]     BQA-10968     AUTOLIGHTNING     AccountManagement
    Go To Salesforce and Login into Lightning       DigiSales Admin
    ${group_account_owner}=    Set variable     Maris Steinbergs
    Go to Entity  AT&T
    Compare owner names  ${group_account_owner}
    Change account owner to  Sales Admin
    Validate that account owner cannot be different from the group account owner

