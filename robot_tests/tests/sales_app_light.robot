*** Settings ***
Documentation     Suite description
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot

*** Test Cases ***
Add new contact - Master
    [Tags]    BQA-8396    Lightning
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New Master Contact
    Validate Master Contact Details

Add new contact - Non person
    [Tags]    BQA-8395    Lightning
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New NP Contact
    Validate NP Contact Details

Add new contact from Accounts Page
    [Tags]    BQA-8394    Lightning
    Go To Salesforce and Login into Lightning
    Go to Entity    ${AP_ACCOUNT_NAME}
    Create New Contact for Account
    Validate AP Contact Details

Create opportunity from Account
    [Tags]    BQA-8393    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Verify That Opportunity is Found From My All Open Opportunities

Negative - Validate Opportunity cannot be created for Passive account
    [Tags]    BQA-8457    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${PASSIVE_TEST_ACCOUNT}
    Create New Opportunity For Customer    PASSIVEACCOUNT

Negative - Validate Opportunity cannot be created for Group account
    [Tags]    BQA-8464    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${GROUP_TEST_ACCOUNT}
    Validate Opportunity cannot be created    GROUPACCOUNT

Closing active opportunity as cancelled
    [Tags]    BQA-8465    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Cancel Opportunity and Validate    ${OPPORTUNITY_NAME}    Cancelled

Closing active opportunity as lost
    [Tags]    BQA-8466    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Cancel Opportunity and Validate    ${OPPORTUNITY_NAME}    Closed Lost

Check Attributes/Business Account are named right in Sales Force UI
    [Tags]    BQA-8484    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    Verify That Business Account Attributes Are Named Right

Check Attributes/Contact Person are named right
    [Tags]    BQA-8483    Lightning
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New Master Contact With All Details
    Validate Master Contact Details In Contact Page    ${CONTACT_DETAILS}
    Validate That Contact Person Attributes Are Named Right

Lightning: Create Meeting from Account
    [Tags]    BQA-7948    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    Create a Meeting

Lightning: Create Call from Account
    [Tags]    BQA-8085    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    Create a Call

Lightning: Create Task from Account
    [Tags]    BQA-8463    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    Create a Task
    #Create opportunity from Account for HDCFlow
    #    [Tags]    BQA-HDCOppo    Lightning
    #    Go To Salesforce and Login into Lightning
    #    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    # Create New Opportunity For Customer    ACTIVEACCOUNT
    #Verify That Opportunity Is Found With Search And Go To Opportunity
    #Verify That Opportunity is Found From My All Open Opportunities

Change Account owner for Group Account
    [Tags]    BQA-8523    Lightning
    Login to Salesforce as DigiSales Lightning User    ${SALES_ADMIN_USER}    ${PASSWORD-SALESADMIN}
    Go To Entity    ${GROUP_TEST_ACCOUNT}
    sleep    10s
    Scroll Page To Location    0    1407.75
    Wait Until Element Is Visible    //table[contains(@class,'forceRecordLayout')]//tbody//tr[1]//td[3]//span[1]//span[1]    30s
    ${original}=    Get Text    //table[contains(@class,'forceRecordLayout')]//tbody//tr[1]//td[3]//span[1]//span[1]
    Click Element    //div[@title='Change Owner']
    sleep    8s
    Element Should Be Enabled    //input[@title='Search People']
    Wait Until Page Contains Element    //input[@title='Search People']
    Input Text    //input[@title='Search People']    ${original}
    Select from Autopopulate List    //input[@title='Search People']    ${original}
    Click Button    //button[@title='Submit']
    sleep    10s
    ${new_owner}=    Get Text    //div[@class='ownerName']
    Should Be Equal As Strings    ${original}    ${new_owner}

Remove Account owner
    [Tags]    BQA-8524    Lightning
    Login to Salesforce as DigiSales Lightning User    ${SALES_ADMIN_USER}    ${PASSWORD-SALESADMIN}
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    sleep    10s
    ${ACCOUNT_OWNER}    Get Text    ${ownername}
    ${status}=    Run Keyword And Return Status    Should Not Be Equal As Strings    ${ACCOUNT_OWNER}    ${REMOVE_ACCOUNT}
    Run Keyword If    ${status} == False    Fail    Account owner is already removed
    Click Button    //button[@title='Change Owner']
    sleep    8s
    Element Should Be Enabled    //input[@title='Search People']
    Wait Until Page Contains Element    //input[@title='Search People']
    Input Text    //input[@title='Search People']    ${REMOVE_ACCOUNT}
    Select from Autopopulate List    //input[@title='Search People']    ${REMOVE_ACCOUNT}
    Mouse Over    //button[@title='Change Owner']
    Click Element    //button[@title='Cancel']/following-sibling::button
    sleep    10s
    ${new_owner}=    Get Text    ${ownername}
    Should Be Equal As Strings    ${REMOVE_ACCOUNT}    ${new_owner}
    Capture Page Screenshot
    Change to original owner

Lightning: Sales admin Change Account owner
    [Tags]  BQA-8525  Lightning
    Login to Salesforce as DigiSales Admin user
    Go to Entity    Aacon Oy
    Change Account Owner

Lightning: Sales admin Change Account owner for group account
    [Tags]  BQA-8526  Lightning
    Login to Salesforce as DigiSales Admin user
    Go to Entity    Aacon Oy
    Change Account Owner



Create opportunity from Account for HDCFlow
    [Tags]  BQA-HDCOppo        Lightning1
    Login to Salesforce as DigiSales Lightning User
    #Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
    Go To Entity   ${LIGHTNING_TEST_ACCOUNT}
    #go to entity  Oppo_ 20190112-151427
    sleep   10s
    ${billing_acc_name}  run keyword  CreateABillingAccount                                #pass
    log to console  ${billing_acc_name}.this is billing account name
    Go To Entity   ${LIGHTNING_TEST_ACCOUNT}
    sleep   10s
    ${contact_name}   run keyword  CreateAContactFromAccount_HDC
    log to console   ${contact_name}.this is name
    sleep   10s
    ${oppo_name}      run keyword  CreateAOppoFromAccount_HDC     ${contact_name}
    ###${contact_name}
    log to console   ${oppo_name}.this is opportunity
    go to entity  ${oppo_name}
    sleep   30s
    ChangeThePriceBookToHDC
    ClickingOnCPQ  ${oppo_name}
    #ClickingOnCPQ   Oppo_ 20190112-151427
    AddingProductToCartAndClickNextButton
    UpdateAndAddSalesType
    OpenQuoteButtonPage

    CreditScoreApproving
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount
    SelectingTechnicalContact   ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo
    ReviewPage
    ValidateTheOrchestrationPlan

    #Reach the Order Page and Validating the details
    #wait until page contains element  //span[text()='Order']//following::div/span[@class='uiOutputText']
    #${order_id}=   get text  //span[text()='Order']//following::div/span[@class='uiOutputText']
    #page should contain element  //th/div/a[text()='Telia Colocation']
    #page should contain element  //th/div/a[text()='Telia Colocation']//following::td/span[text()='New Money-New Services']
    #Execute JavaScript    window.scrollTo(0,2000)
    #page should contain element   //th[@title='Orchestration Plan Name']//following::div[@data-aura-class='forceOutputLookupWithPreview']/a
    #click element   //th[@title='Orchestration Plan Name']//following::div[@data-aura-class='forceOutputLookupWithPreview']/a
    #sleep   20s
