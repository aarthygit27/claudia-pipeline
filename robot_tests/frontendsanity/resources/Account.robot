*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Variables.robot
Resource          ../../frontendsanity/resources/Common.robot
*** Keywords ***

Go To Accounts
    ${element_xpath}=    Replace String    ${ACCOUNTS_LINK}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep    2s
    #Click on Account Name
    #    sleep    5s
    ## Log To Console    Count:${count}
    #click element    ${ACCOUNT_NAME}[1]

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
    ${error}=    Run Keyword And Return Status    Element Should Be Visible    //button[text()='Change Owner']
    Run Keyword If    ${error}    click button      //button[text()='Change Owner']
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

Click on a given account
    [Arguments]    ${acc_name}
    sleep    5s
    ${present}=    Run Keyword And Return Status    Element Should Be Visible    //th[@scope='row' and contains(@class,'slds-cell-edit')]//a[@title='${acc_name}']
    Run Keyword If    ${present}    Click specific element    //th[@scope='row' and contains(@class,'slds-cell-edit')]//a[@title='${acc_name}']
    ...    ELSE    Log To Console    No account name available
    sleep    10s

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
    Wait until page contains element    //span[text()='User']//following::input     60s
    Select from search List     //span[text()='User']//following::input     ${new_team_member}
    sleep   2s
    #Wait element to load and click  //a[@role='option']/div//div[@title='${new_team_member}']
    Wait element to load and click  //a[text()='--None--']
    force click element     //div[@class="select-options"]//ul/li/a[@title="${role}"]
    Sleep  10s
    Click element   //button[@title='Save']
    sleep   30s

Delete Account team member
    : FOR    ${i}    IN RANGE    1000
    \   ${status}=  Run Keyword And Return Status    Element Should Be Visible    ${table_row}
    \    Exit For Loop If    ${status}== False
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


Go to account from oppo page
    [Documentation]  Go back to account page from opportubnity page
    Reload page
    ${Account}  set variable  //span[@class='slds-form-element__label slds-truncate'][@title='Account Name']//following::div[3]/a
    Wait until element is visible   ${Account}   30s
    Click element  ${Account}
    sleep  3s


CreateABillingAccount
    [Arguments]    ${LIGHTNING_TEST_ACCOUNT}
    # go to particular account and create a billing accouint from there
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible     //li/a/div[@title='Billing Account']   60s
    #Run Keyword If    ${status_page} == True    force click element    //li/a/div[@title='Billing Account']
    Run Keyword If    ${status_page} == False   force click element     //a[@title="Show 2 more actions"]
    sleep  20s
    wait until page contains element    //li/a/div[@title='Billing Account']    45s
    force click element    //li/a/div[@title='Billing Account']
    #sleep    20s
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    #wait until page contains element    //*[@id="RemoteAction1"]    30s
    #click element    //*[@id="RemoteAction1"]
    #unselect frame
    #sleep    10s
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    #wait until page contains element    //*[@id="Customer_nextBtn"]    30s
    #click element    //*[@id="Customer_nextBtn"]
    #unselect frame
    sleep    20s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]    30s
    ${account_name_get}=    get value    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]
    ${numbers}=    Generate Random String    4    [NUMBERS]
    sleep  30s
    clear element text  //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]
    input text    //div[@class='vlc-control-wrapper']/input[@id="Name_Billing"]    Billing_${LIGHTNING_TEST_ACCOUNT}_${numbers}
    Execute JavaScript    window.scrollTo(0,700)
    #scroll page to element    //*[@id="billing_country"]
    click element    //*[@id="billing_country"]
    sleep  2s
    click element    //*[@id="billing_country"]/option[@value='FI']
    sleep  2s
    click element    //*[@id="Invoice_Delivery_Method"]
    sleep  2s
    click element    //*[@id="Invoice_Delivery_Method"]/option[@value='Paper Invoice']
    sleep  2s
    input text    //*[@id="payment_term"]    10
    sleep  2s
    click element    //*[@id="create_billing_account"]/p[text()='Create Billing Account']
    sleep    10s
    execute javascript    window.scrollTo(0,2100)
    #scroll page to element    //*[@id="Create Billing account_nextBtn"]/p[text()='Next']
    sleep    5s
    wait until page contains element    //*[@id="billing_account_creation_result"]/div/p[text()='Billing account added succesfully to Claudia']    30s
    force click element    //*[@id="Create Billing account_nextBtn"]/p[text()='Next']
    unselect frame
    sleep    30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    sleep    20s
    force click element    //*[@id="return_billing_account"]
    sleep    10s
    unselect frame
    [Return]    Billing_${LIGHTNING_TEST_ACCOUNT}_${numbers}


Terminate asset
    [Arguments]   ${asset}
    ${Accounts_More}  set variable  //div[contains(@class,'tabset slds-tabs_card uiTabset')]/div[@role='tablist']/ul/li[8]/div/div/div/div/a
    wait until element is visible  ${Accounts_More}  60s
    Click element  ${Accounts_More}
    Click element  //li[@class='uiMenuItem']/a[@title='Assets']
    Wait until element is visible  //span[@title='Assets']  60s
    Click element  //span[@title='Assets']
    Wait until element is visible  //h1[@title='Assets']  60s
    sleep  10s
    ${product}   set variable   //div[@class='slds-col slds-no-space forceListViewManagerPrimaryDisplayManager']//tr//a[contains(text(),'${asset}')]
    Click element   ${product}
    Wait until element is visible  //a[@title='Edit']  60s
    wait until page contains element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Asset Name']/../following-sibling::div/span/span    60s
    page should contain element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Asset Name']/../following-sibling::div/span/span
    page should contain element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Product']/../following-sibling::div/span/div/a[text()='${asset}']
    click element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Status']/../..//following::button[@title='Edit Status']
    sleep    10s
    click element    //Span[text()='Status']//following::div[@class="uiMenu"]/div[@data-aura-class="uiPopupTrigger"]/div/div/a[@class='select' and text()='Active']
    click element    //a[@title='Terminated']
    click element    //div[@class="footer active"]//button[@title="Save"]

Create a Meeting
    #Check original account owner and change if necessary for event
    ${unique_subject_task}=    run keyword    Create Unique Task Subject
    Click Clear All Notifications
    click Meeting Link on Page
    Enter Mandatory Info on Meeting Form    ${unique_subject_task}
    Save Meeting and click on Suucess Message
    Search And Select the Entity    ${unique_subject_task}    ${EMPTY}
    Validate Created Meeting
    Modify Meeting Outcome
    Validate the Modified Outcome


Enter Mandatory Info on Meeting Form
    [Arguments]    ${task_subject}
    sleep    5s
    input text    xpath=${SUBJECT_INPUT}    ${task_subject}
    sleep    5s
    click element    xpath=${EVENT_TYPE}
    Click Visible Element   xpath=${meeting_select_dropdown}
    sleep    5s
    Select option from Dropdown with Force Click Element    ${reason_select_dropdown}    ${reason_select_dropdown_value}
    #click element    xpath=${reason_select_dropdown}
    #click element    xpath=${reason_select_dropdown_value}
    Enter Meeting Start and End Date
    sleep    5s
    Input Text    ${city_input}    ${DEFAULT_CITY}
    sleep    5s
    Enter and Select Contact Meeting
    sleep    10s

Enter Meeting Start and End Date
    ${date}=    Get Date From Future    1
    Set Test Variable    ${meeting_start_DATE}    ${date}
    #log to console    ${meeting_start_DATE}
    Clear Element Text   ${meeting_start_date_input}
    sleep  3s
    Input Text    ${meeting_start_date_input}    ${meeting_start_DATE}
    click element   ${meeting_start_time_input}
    clear element text    ${meeting_start_time_input}
    input text    ${meeting_start_time_input}    ${meeting_start_time}
    ${date}=    Get Date From Future    2
    Set Test Variable    ${meeting_end_DATE}    ${date}
    Input Text    ${meeting_end_date_input}    ${meeting_end_DATE}
    click element   ${meeting_end_time_input}
    sleep  3s
    clear element text    ${meeting_end_time_input}
    input text    ${meeting_end_time_input}    ${meeting_end_time}

Enter and Select Contact Meeting
    Set Test Variable    ${name_input}    ${AP_FIRST_NAME} ${AP_LAST_NAME}
    Scroll Page To Element    ${save_button_create}
    Force click element    ${contact_name_input}
    #click element    ${contact_name_input}
    input text    ${contact_name_input}    ${name_input}
    Wait Until Page Contains Element    //*[@title='${name_input}']/../..    60s
    Sleep    15s
    click element    //div[@title='${name_input}']/../..
    sleep    5s

click Meeting Link on Page
    force click element  ${NEW_EVENT_LABEL}
    #Sleep    10s
    Wait Until Page Contains element    xpath=${SUBJECT_INPUT}    100s

Save Meeting and click on Suucess Message
    #click element    ${save_button_create}
    Force click element    ${save_button_create}
    sleep    30s
    #click element    ${success_message_anchor}
    : FOR    ${i}    IN RANGE    10
    \    sleep  10s
    \    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${success_message_anchor}
    \    Sleep    5s
    \    Run Keyword Unless   ${status}   Click element   //button[text()="View More"]
    \    Exit For Loop If    ${status}
    click visible element  ${success_message_anchor}
    sleep    10s


Validate Created Meeting
    sleep    10s
    ${date}=    Get Date From Future    1
    Set Test Variable    ${meeting_start_DATE}    ${date}
    ${date}=    Get Date From Future    2
    Set Test Variable    ${meeting_end_DATE}    ${date}
    ${start_date_form}    get text    xpath=${start_date_form_span}
    ${end_date_from}    get text    xpath=${end_date_form_span}
    ${location_form}    get text    xpath=${location_form_span}
    # log to console    ${location_form}.this is form data
    #log to console    ${DEFAULT_CITY}.this is inputdata from variables
    should be equal as strings    ${location_form}    ${DEFAULT_CITY}
    #log to console    ${start_date_form}.this is form start date
    #log to console    ${meeting_start_DATE} ${meeting_start time}.this user entered start date
    should be equal as strings    ${start_date_form}    ${meeting_start_DATE} ${meeting_start time}
    should be equal as strings    ${end_date_from}    ${meeting_end_DATE} ${meeting_end_time}



Modify Meeting Outcome
    Set Test Variable    ${EDIT_EVENT_POPUP}    //div[@class="slds-form-element slds-hint-parent"]
    Click element    //div[@title='Edit']/..
    wait until page contains element    //*[contains(text(),'Edit Task')]    30s
    Sleep    5s
    Select Quick Action Value For Attribute    Meeting Outcome    Positive
    Sleep    5s
    Select Quick Action Value For Attribute    Meeting Status    Done
    Wait Until Element Is Visible    ${EDIT_EVENT_POPUP}//label//*[contains(text(),'Description')]    60s
    Input Text    xpath=${EDIT_EVENT_POPUP}//label//*[contains(text(),'Description')]//following::span/../textarea    ${name_input}.Edited.${Meeting}
    click element    ${save_button_editform}
    sleep    20s

Validate the Modified Outcome
    #${description_form}    get text    ${description_span}
    #should be equal as strings    ${name_input}.Edited.${Meeting}    ${description_form}
    ${meeting_outcome_form}    get text    ${meeting_outocme_span}
    should be equal as strings    ${meeting_outcome_form}    Positive

Create a Call
    ${unique_subject_task}=    run keyword    Create Unique Task Subject
    Click Clear All Notifications
    click Meeting Link on Page
    Enter Mandatory Info on Call Form    ${unique_subject_task}
    Save Meeting and click on Suucess Message
    Search And Select the Entity    ${unique_subject_task}    ${EMPTY}
    Validate Created Meeting
    Modify Meeting Outcome
    Validate the Modified Outcome


Enter Mandatory Info on Call Form
    [Arguments]    ${task_subject}
    sleep    10s
    input text    xpath=${SUBJECT_INPUT}    ${task_subject}
    click element    xpath=${EVENT_TYPE}
    click element    xpath=${subject_call_type}
    select option from dropdown with force click element    ${reason_select_dropdown}    ${reason_select_dropdown_value}
    #click element    xpath=${reason_select_dropdown}
    #click element    xpath=${reason_select_dropdown_value}
    Enter Meeting Start and End Date
    Sleep    10s
    input text    ${city_input}    ${DEFAULT_CITY}
    sleep    10s
    Enter and Select Contact Meeting
    sleep    10s

Create a Task
    ${unique_subject_task}=    run keyword    Create Unique Task Subject
    Click Clear All Notifications
    click Task Link on Page
    Enter Mandatory Info on Task Form    ${unique_subject_task}
    Save Task and click on Suucess Message
    Sleep  20s
    Search Salesforce   ${unique_subject_task}
    ${element_catenate} =    set variable    [@title='${unique_subject_task}']
    Wait Until Page Contains element    ${TABLE_HEADERForEvent}${element_catenate}  60s
    Click Visible Element    ${TABLE_HEADERForEvent}${element_catenate}
    Wait Until Page Contains element    //h1//span[text()='${unique_subject_task}']    400s
    #Search And Select the Entity    ${unique_subject_task}    ${EMPTY}
    Sleep  30s
    Validate Created Task    ${unique_subject_task}


click Task Link on Page
    click element    ${NEW_TASK_LABEL}
    Sleep    10s
    wait until page contains element    xpath=${task_subject_input}    40s


Enter Mandatory Info on Task Form
    [Arguments]    ${task_subject}
    input text    xpath=${task_subject_input}    ${task_subject}
    sleep    10s
    ${a}=    run keyword    Enter Task Due Date
    Enter and Select Contact

Enter Task Due Date
    ${date}=    Get Date From Future    7
    Set Test Variable    ${task_due_DATE}    ${date}
    Input Text    xpath=//*[text()='Due Date']/../../div/input    ${task_due_DATE}
    [Return]    ${task_due_DATE}

Enter and Select Contact
    Set Test Variable    ${name_input}    ${AP_FIRST_NAME} ${AP_LAST_NAME}
    Force click element    ${name_input_task}
    Input text    ${name_input_task}    ${name_input}
    Wait Until Page Contains Element    //*[@title='${name_input}']/../..    60s
    Force click element    //*[@title='${name_input}']/../..
    sleep    10s

Save Task and click on Suucess Message
    force click element    ${save_task_button}
    sleep    30s
    #force click element    ${suucess_msg_task_anchor}
    #sleep    40s

Validate Created Task
    [Arguments]    ${unique_subject_task_form}
    ${name_form}    get text    ${contact_name_form}    #helina kejiyu comoare
    #${related_to_form}    get text    ${related_to}    #aacon Oy ${save_opportunity}
    #log to console    ${name_form}
    ${date_due}=    Get Date From Future    7
    page should contain element    //span[@class='uiOutputDate' and text()='${date_due}']
    page should contain element    //span[@class='test-id__field-value slds-form-element__static slds-grow ']/span[@class='uiOutputText' and text()='${unique_subject_task_form}']


Validate technical contact in the asset history page using subscription as
   [Documentation]    Go to Account asset History and select the respective product based on subscription ID and validate the technical contact details
   [Arguments]    ${sub_name}     ${Contact_name}
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    scroll page to location  0  9000
    ScrollUntillFound   //button//span[text()='Asset History']
    Log to console  scroll to asset history
    select frame   ${Account_Asset_iframe}
    ScrollUntillFound  //div[text()='Subscription Id']/following::ul/li/div/div[3]/div[text()='${sub_name}']/../..//div[@class="p-name"]/a
    wait until page contains element  //div[text()='Subscription Id']/following::ul/li/div/div[3]/div[text()='${sub_name}']/../..//div[@class="p-name"]/a  60s
    Force click element   //div[text()='Subscription Id']/following::ul/li/div/div[3]/div[text()='${sub_name}']/../..//div[@class="p-name"]/a
    unselect frame
    sleep  10s
    switch between windows  1
    ${contact_value}  get text  ${Account_Asset_TechnicalContact}
    Should be equal   ${contact_value}    ${Contact_name}


create two different billing account for payer and buyer validation
   [Arguments]  ${billing_acc_name}
   go to entity  ${vLocUpg_TEST_ACCOUNT}
   ${billing_acc_name1}    run keyword    CreateABillingAccount   ${vLocUpg_TEST_ACCOUNT}
   Go to Entity  ${billing_acc_name1}
   wait until page contains element  //div//span[text()="Payer for"]   60s
   click button  //button[@title="Edit Payer for"]
   sleep  10s
   wait until page contains element   //div//input[@placeholder="Search Accounts..."]   60s
   click element  //div//input[@placeholder="Search Accounts..."]
   input text    //div//input[@placeholder="Search Accounts..."]   ${vLocUpg_TEST_ACCOUNT}
   sleep  5s
   press enter on  //div//input[@placeholder="Search Accounts..."]
   wait until page contains element   //a[@title="Aarsleff Oy"]  60s
   force click element   //a[@title="Aarsleff Oy"]
   wait until page contains element   //button[@title="Save"]  60s
   click element  //button[@title="Save"]
   sleep  10s
   go to entity   ${billing_acc_name}
   wait until page contains element  //div//span[text()="Payer for"]    60s
   click button  //button[@title="Edit Payer for"]
   sleep  10s
   wait until page contains element   //div//input[@placeholder="Search Accounts..."]   60s
   click element  //div//input[@placeholder="Search Accounts..."]
   sleep  5s
   input text    //div//input[@placeholder="Search Accounts..."]   ${vLocUpg_TEST_ACCOUNT}
   press enter on  //div//input[@placeholder="Search Accounts..."]
   wait until page contains element   //a[@title="Aarsleff Oy"]  60s
   force click element   //a[@title="Aarsleff Oy"]
   wait until page contains element   //button[@title="Save"]  60s
   click element  //button[@title="Save"]
   [Return]     ${billing_acc_name1}