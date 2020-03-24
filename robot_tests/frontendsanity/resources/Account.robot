*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Variables.robot
Resource          ../../frontendsanity/resources/Common.robot
*** Keywords ***
Verify That Business Account Attributes Are Named Right
    Verify That Record Contains Attribute    Account SF ID
    Verify That Record Contains Attribute    Record Type Name
    Verify That Record Contains Attribute    Account Owner
    Verify That Record Contains Attribute    Business ID
    Verify That Record Contains Attribute    Account Name
    Verify That Record Contains Attribute    Telia Customer ID
    Verify That Record Contains Attribute    Marketing Name
    Verify That Record Contains Attribute    AIDA ID
    Verify That Record Contains Attribute    Phone
    Verify That Record Contains Attribute    VAT Code
    Verify That Record Contains Attribute    Website
    Verify That Record Contains Attribute    Registered Association ID
    Verify That Record Contains Attribute    Contact Preferences
    Verify That Record Contains Attribute    Group Name
    Verify That Record Contains Attribute    Next Opportunity Due
    Verify That Record Contains Attribute    Group ID
    Verify That Record Contains Attribute    Opportunities Open
    Verify That Record Contains Attribute    Parent Account
    Verify That Record Contains Attribute    Last Contacted Date
    Verify That Record Contains Attribute    Days Uncontacted
    Verify That Record Contains Attribute    Marketing Restriction
    Verify That Record Contains Attribute    Company Form
    Verify That Record Contains Attribute    Legal Status
    Verify That Record Contains Attribute    Tax Activity
    Verify That Record Contains Attribute    Status Reason
    Verify That Record Contains Attribute    Bankruptcy Process Status
    Verify That Record Contains Attribute    Business Segment
    Verify That Record Contains Attribute    Street Address
    Verify That Record Contains Attribute    Postal Code
    Verify That Record Contains Attribute    City
    Verify That Record Contains Attribute    Country
    Verify That Record Contains Attribute    Main Mailing Address
    Verify That Record Contains Attribute    Visiting Address
    #Verify That Record Contains Attribute    Multibella System ID
    Verify That Record Contains Attribute    Billing System ID
    #Verify That Record Contains Attribute    AccountNumber
    Verify That Record Contains Attribute    BS ID

Check original account owner and change if necessary
    Wait Until Element Is Visible     //div//p[text()="Account Owner"]/..//a    30s
    ${account_owner}=    Get Text     //div//p[text()="Account Owner"]/..//a
    #log to console    ${account_owner}
    ${user_is_already_owner}=    Run Keyword And Return Status    Should Be Equal As Strings    ${account_owner}    Maris Steinbergs
    Run Keyword If    ${user_is_already_owner}    Set Test Variable     ${NEW_OWNER}    B2B Lightning
    ...     ELSE    Set Test Variable   ${NEW_OWNER}    Maris Steinbergs
    Change account owner to     ${NEW_OWNER}


Change account owner to
    [Arguments]    ${new_owner}
    [Documentation]    Checks if account given as a parameter is already account owner and if not proceeds to change the account owner
    ${isAccountOwner}=    Run keyword and return status    Wait until page contains element    //div//p[text()="Account Owner"]/..//a[text()="${new_owner}']    30s
    Run Keyword if    ${isAccountOwner} == False    Open change owner view and fill the form    ${new_owner}

Open change owner view and fill the form
    [Arguments]    ${username}
    #Wait element to load and click    //button[@title='Change Owner']
    #Wait until page contains element    //input[@title='Search People']
#    Wait element to load and click      //div[@class="slds-form-element__control slds-grid itemBody"]//button[@title='Change Owner']
    Wait element to load and click      //button[@title='Change Owner']
    Wait until page contains element    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]  60s
    input text     //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]    ${username}
    Sleep  10s
    Press Enter On   //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]
    Sleep    10s
    Click element   //a[text()="Full Name"]//following::a[text()='${username}']
    #Click element    //a[text()='${username}']
    sleep  10s
    #Wait element to load and click  //a[@role='option']/div/div[@title='${username}']
#   Click element   //div[@class='modal-footer slds-modal__footer']//button[@title='Change Owner']
    Click element  //button[text()='Change Owner']
    sleep   40s

Validate that account owner was changed successfully
    [Documentation]     Validates that account owner change was successfull. Takes the name of the new owner as parameter.
    [Arguments]     ${validated_owner}
    Compare owner names  ${validated_owner}

Compare owner names
    [Arguments]     ${validated_owner}
    : FOR    ${i}    IN RANGE    10
    \   ${new_owner}=    Get Text    //div//p[text()="Account Owner"]/..//a
    \   ${status}=    Run Keyword And Return Status    Should Be Equal As Strings  ${validated_owner}   ${new_owner}
    \   Run Keyword If   ${status} == False      reload page
    \   Sleep  20s
    \   Wait Until Page Contains Element    //div//p[text()="Account Owner"]/..//a    120s
    \   Exit For Loop If    ${status}
    Should Be Equal As Strings    ${validated_owner}    ${new_owner}


Validate that account owner has changed in Account Hierarchy
    [Documentation]     View account hierarchy and check that new owner is copied down in hierarchy
    Wait element to load and click  //button[@title='View Account Hierarchy']
    Wait element to load and click  //button[@title='Expand']
    Wait until page contains element    //table/tbody/tr[1]/td[4]/span[text()='${NEW_OWNER}']   30s

Remove change account owner
    ${ACCOUNT_OWNER}    Get Text    ${ownername}
    ${status}=    Run Keyword And Return Status    Should Not Be Equal As Strings    ${ACCOUNT_OWNER}    ${REMOVE_ACCOUNT}
    Run Keyword If    ${status} == False    Change to original owner
    Wait Until Element Is Visible   //button[@title='Change Owner']  10s
    click element     //button[@title='Change Owner']
    sleep   8s
    Element Should Be Enabled     //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]
    Wait Until Page Contains Element    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]    60s
    Input Text    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]   ${REMOVE_ACCOUNT}
    sleep  5s
    press enter on  //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]
    Sleep  15s
    click element     //a[text()="Full Name"]//following::a[text()='${REMOVE_ACCOUNT}']
    #Select from Autopopulate List    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]   ${REMOVE_ACCOUNT}
    sleep  15s
    Click element   //button[text()='Change Owner']
    Sleep  15s
    : FOR    ${i}    IN RANGE    10
    \   ${new_owner}=    Get Text    ${ownername}
    \   ${status}=    Run Keyword And Return Status    Should Be Equal As Strings  ${REMOVE_ACCOUNT}   ${new_owner}
    \   Run Keyword If   ${status} == False      reload page
    \   sleep  15s
    \   Wait Until Page Contains Element   ${ownername}   120s
    \   Exit For Loop If    ${status}
    Should Be Equal As Strings    ${REMOVE_ACCOUNT}    ${new_owner}
    Capture Page Screenshot


Change to original owner
    [Documentation]    We are changing the account owner to Sales Admin in case the account owner is GESB Integration
     #Change account owner to  ${ACCOUNT_OWNER}
     Wait Until Element Is Visible    //*[@data-key="change_owner"]  30s
     Click element   //*[@data-key="change_owner"]
     sleep    8s
     Element Should Be Enabled    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]
     Wait Until Page Contains Element    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]    60s
    #Input Text    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]   ${ACCOUNT_OWNER}
     Select from Autopopulate List    //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]   ${ACCOUNT_OWNER}
     Click Element   //*[text()="Change Account Owner"]//following::span[text()="Change Owner"]
     : FOR    ${i}    IN RANGE    10
     \   ${new_owner}=   Get Text    ${ownername}
     \   ${status}=    Run Keyword And Return Status    Should Not Be Equal As Strings  ${REMOVE_ACCOUNT}   ${new_owner}
     \   Run Keyword If   ${status} == False      reload page
     \   Wait Until Page Contains Element   ${ownername}   120s
     \   Exit For Loop If    ${status}
     #log to console   ${new_owner}
     sleep  120s

Change Account Owner
    ${CurrentOwnerName}=    Get Text    ${OWNER_NAME}
    Click Element  //span[text()='Account Owner']/../..//button[@title='Change Owner']
    Wait until Page Contains Element    ${SEARCH_OWNER}    240s
    Sleep    10s
    ${NewOwner}=    set variable if    '${CurrentOwnerName}'== 'Sales Admin'    B2B DigiSales    Sales Admin
    Select from Autopopulate List    ${SEARCH_OWNER}     ${NewOwner}
    Click Visible Element    ${CHANGE_OWNER_BUTTON}
    Sleep    60s
    : FOR    ${i}    IN RANGE    10
    \   ${NEW_OWNER_REFLECTED}=    Get Text    ${OWNER_NAME}
    \   ${status}=    Run Keyword And Return Status    Should Be Equal As Strings  ${NEW_OWNER_REFLECTED}    ${NewOwner}
    \   Run Keyword If   ${status} == False      reload page
    \   Wait Until Page Contains Element   ${OWNER_NAME}   120s
    \   Exit For Loop If    ${status}
    Should Be Equal As Strings    ${NEW_OWNER_REFLECTED}    ${NewOwner}


Check original account owner and change if necessary for event
#    Wait Until Element Is Visible    //div[@class='ownerName']//a    30s
    Wait Until Element Is Visible     //div//p[text()="Account Owner"]/..//a     30s
    ${account_owner}=    Get Text     //div//p[text()="Account Owner"]/..//a
    Set Test Variable     ${NEW_OWNER}    B2B Lightning
    #log to console    ${account_owner}
    #log to console    ${NEW_OWNER}
    ${user_is_already_owner}=    Run Keyword And Return Status    Should Be Equal As Strings    ${account_owner}    B2B Lightning
    #log to console    ${user_is_already_owner}
    #log to console     ${account_owner}
    #Run Keyword unless    ${user_is_already_owner}
    Run Keyword unless  ${user_is_already_owner}  Change account owner to     ${NEW_OWNER}
    sleep       30s

Add new team member
    [Documentation]     Add new team member to account
    [Arguments]     ${new_team_member}      ${role}=--None--
    sleep   10s
    Delete Account team member
    Wait until page contains element    //ul/li/a[@title='New']     30s
    Force click element  //ul/li/a[@title='New']
    Wait until page contains element    //input[@title='Search People']     60s
    Input text  //input[@title='Search People']     ${new_team_member}
    Wait element to load and click  //a[@role='option']/div//div[@title='${new_team_member}']
    Wait element to load and click  //a[text()='--None--']
    force click element  //div[@class="select-options"]//ul/li/a[@title="${role}"]
    Sleep  10s
    Click element   //button[@title='Save']
    sleep   30s

Delete Account team member
    : FOR    ${i}    IN RANGE    1000
    #\    Exit For Loop If    ${i} > ${count}-1
    \   Wait Until Element Is Visible    ${table_row}    60s
    \   ${count}=    get element count    ${table_row}
    \   log to console       ${count}
    \    exit for loop if       ${count}==0
    \    Delete all entities    ${table_row}


Validate that team member is created succesfully
    [Arguments]     ${name}=Sales,Admin     ${role}=
    reload page
    Wait until page contains element   //table/tbody/tr/th/span/span[text()='${name}']     120s
    Wait until page contains element    //table/tbody/tr/th/span/span[text()='${name}']/../../../td[2]/span/span[text()='${role}']  30s

Change team member role from account
    Wait until page contains element    ${table_row}
    Force Click element    ${table_row}
    Sleep  20s
    ${isAccountOwner}=    Run keyword and return status    Wait until page contains element    //a[@title='Edit']    30s
    Run Keyword if    ${isAccountOwner} == False    reload page
    Run Keyword if    ${isAccountOwner} == False    Wait until page contains element    ${table_row}        60s
    Run Keyword if    ${isAccountOwner} == False    Force Click element    ${table_row}
    Wait until page contains element    //a[@title='Edit']  60s
    Force Click element  //a[@title='Edit']
    Wait element to load and click    //a[text()='--None--']
    Wait element to load and click    //ul/li[2]/a[text()='Account Manager']
    Click element    //button[@title='Save']
    Wait until page contains element    //table/tbody/tr/td[2]/span/span[text()='Account Manager']    30s
    sleep    10s

Delete team member from account
    :FOR    ${i}    IN RANGE    999
    \   ${no_team_members}=     Run keyword and return status   Wait until page contains element    //div[@class='emptyContent']//p[text()='No items to display.']      10s
    \   Exit For Loop If    ${no_team_members}
    \   Wait until page contains element    ${table_row}   30s
    \   Delete row items    ${table_row}

Add account owner to account team
    ${account_owner}=    Get Text   //div//p[text()="Account Owner"]/..//a
    Navigate to view    Account Team Members
    Add new team member  ${account_owner}

Validate that account owner can not be added to account team
    Wait until page contains element    //ul[@class='errorsList']/li[text()='Cannot add account owner to account team']     30s
    Wait until element is visible   //ul[@class='errorsList']/li[text()='Cannot add account owner to account team']     30s

Try to add same team member twice
    [Documentation]     Tries to add same user twice as a team member for business account.
    [Arguments]     ${user}
    Add new team member  ${user}
    Add new team member  ${user}

Validate that same user can not be added twice to account team
    Wait until page contains element    //ul[@class='errorsList']/li[text()='Cannot create a duplicate entry']     30s
    Wait until element is visible   //ul[@class='errorsList']/li[text()='Cannot create a duplicate entry']     30s
    Click element   //button[@title='Cancel']

Navigate to Account History
    ScrollUntillFound  //a/span[text()='Account History']
    Click element   //a/span[text()='Account History']

Validate that Account history contains record
    [Arguments]     ${user}
    Wait until page contains element    //table/tbody/tr[1]/td[5]//span[text()='${user}']

Validate that account owner cannot be different from the group account owner
    Wait until page contains element    //span[text()='Owner ID: Account Owner cannot be different from the Group Account owner']   30s
    Click button  //button[text()='Cancel']


Add relationship for the contact person
    Set Test Variable    ${contact_name}    ${AP_FIRST_NAME} ${AP_LAST_NAME}
    sleep    20s
    Wait element to load and click    ${ACCOUNT_RELATED}
    Wait element to load and click    //a[@title='Add Relationship']
    Wait until element is visible    //input[@title='Search Contacts']    30s
    Input text    //input[@title='Search Contacts']    ${contact_name}
    Wait element to load and click    //a[@role='option']/div/div[@title='${contact_name}']
    Wait element to load and click    //span[text()='Account']/../..//div//li//a[@class='deleteAction']
    Wait until keyword succeeds    30s    2s    Input text    //input[@title='Search Accounts']    Aacon Oy
    Wait element to load and click    //input[@title='Search Accounts']/..//a[@role='option']/div/div[@title='Aacon Oy']
    Wait until keyword succeeds    30s    2s    Click element    //button[@title='Save']

Validate contact relationship
    #log to console    Validating contact relationship
    Execute Javascript    window.location.reload(false);
    Wait element to load and click    ${ACCOUNT_RELATED}
    ScrollUntillFound    //h2/a/span[text()='Related Accounts']
    Click element    //h2/a/span[text()='Related Accounts']
    Wait until page contains element    //table/tbody/tr/th/span/a[text()='Aacon Oy']    20s
    Wait until page contains element    //table/tbody/tr/th/span/a[text()='${LIGHTNING_TEST_ACCOUNT}']    20s
    Wait until page contains element    //table/tbody/tr[2]/td[2]/span/span/img[@class='slds-truncate checked']    20s

