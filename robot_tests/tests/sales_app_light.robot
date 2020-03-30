*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
#Library             test123.py
Library             ../resources/customPythonKeywords.py

*** Test Cases ***

##################################################  SANITY TESTS ###################################################
Add new contact - Master
    [Documentation]    Go to SalesForce Lightning. Create new master contact and validate the details
    [Tags]    BQA-8396  AUTOLIGHTNINGOLD   ContactsManagement
    Go To Salesforce and Login into Lightning
    Create New Master Contact
    Validate Master Contact Details

Add new contact - Non person
    [Documentation]    Go to SalesForce Lightning. Create new non master contact and validate the details.
    [Tags]    BQA-8395  AUTOLIGHTNINGOLD   ContactsManagement
    Go To Salesforce and Login into Lightning
    Create New NP Contact
    Validate NP Contact

Add new contact from Accounts Page
    [Documentation]    Go to SalesForce Lightning. Create new contact for account and validate the details.
    [Tags]    BQA-8394  AUTOLIGHTNINGOLD   ContactsManagement
    Go To Salesforce and Login into Lightning
    Go to Entity    ${AP_ACCOUNT_NAME}
    Create New Contact for Account
    Validate AP Contact Details

Create opportunity from Account
    [Documentation]    Create new opportunity and validate in accounts related tab search in salesforce
    ...    and then in My all open Opportunities section.
    [Tags]    BQA-8393    AUTOLIGHTNINGOLD        OpportunityValidation
    Go To Salesforce and Login into Lightning
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Verify That Opportunity is Found From My All Open Opportunities

Negative - Validate Opportunity cannot be created for Passive account
    [Documentation]    Select the Passive account and validate that the Opportunity creation
    ...    throws an error
    [Tags]    BQA-8457    AUTOLIGHTNINGOLD       OpportunityValidation
    Go To Salesforce and Login into Lightning
    Go To Entity    ${PASSIVE_TEST_ACCOUNT}
    Create New Opportunity For Customer    PASSIVEACCOUNT

Negative - Validate Opportunity cannot be created for Group account
    [Documentation]    Select the Group account and validate that the new opportunity button
    ...    is not displayed
    [Tags]    BQA-8464    AUTOLIGHTNINGOLD         OpportunityValidation
    Go To Salesforce and Login into Lightning
    Go To Entity    ${GROUP_TEST_ACCOUNT}
    Validate Opportunity cannot be created    GROUPACCOUNT

Closing active opportunity as cancelled
    [Documentation]    Create new opportunity and cancel the opportunity and validate that
    ...    it cannot be updated further
    [Tags]    BQA-8465    AUTOLIGHTNINGOLD         OpportunityValidation
    Go To Salesforce and Login into Lightning
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Cancel Opportunity and Validate     ${OPPORTUNITY_NAME}     Cancelled

Closing active opportunity as lost
    [Documentation]    Create new opportunity and close the opportunity as lost and validate that
    ...    it cannot be updated further
    [Tags]    BQA-8466    AUTOLIGHTNINGOLD         OpportunityValidation
    Go To Salesforce and Login into Lightning
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Cancel Opportunity and Validate    ${OPPORTUNITY_NAME}    Closed Lost

Check Attributes/Business Account are named right in Sales Force UI
    [Documentation]    To Verify the Business Account Attributes Are Named Right
    [Tags]    BQA-8484    AUTOLIGHTNINGOLD        AcccountManagement
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    Verify That Business Account Attributes Are Named Right

Check Attributes/Contact Person are named right
    [Documentation]    To Verify the Contact Person Attributes and values Are Named Right after adding the contact
    [Tags]    BQA-8483    AUTOLIGHTNINGOLD     ContactsManagement
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New Master Contact With All Details
    Validate Master Contact Details In Contact Page    ${CONTACT_DETAILS}
    Validate That Contact Person Attributes Are Named Right

Lightning: Create Meeting from Account
    [Documentation]    To create meeting for a account
    [Tags]    BQA-7948    AUTOLIGHTNINGOLD     QuickActionsForAccount
    Go To Salesforce and Login into Admin User
    Go To Entity    ${TEST_CONTACT}
    sleep    20s
    Check original account owner and change if necessary for event
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_CONTACT}
    Create New Contact for Account
    Go to Entity   ${TEST_CONTACT}
    Create a Meeting

Lightning: Create Call from Account
    [Documentation]    To create call for a account
    [Tags]    BQA-8085    AUTOLIGHTNINGOLD     QuickActionsForAccount
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_CONTACT}
    Create New Contact for Account
    Go to Entity    ${TEST_CONTACT}
    Create a Call

Lightning: Create Task from Account
    [Documentation]    To create task for a account
    [Tags]    BQA-8463    AUTOLIGHTNINGOLD     QuickActionsForAccount
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_CONTACT}
    Create New Contact for Account
    Go To Entity    ${TEST_CONTACT}
    Create a Task
    #Create opportunity from Account for HDCFlow
    #    [Tags]    BQA-HDCOppo    Lightning
    #    Go To Salesforce and Login into Lightning
    #    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    # Create New Opportunity For Customer    ACTIVEACCOUNT
    #Verify That Opportunity Is Found With Search And Go To Opportunity
    #Verify That Opportunity is Found From My All Open Opportunities

Change Account owner for Group Account
    [Documentation]    To change the account  owner for group  account
    [Tags]    BQA-8523     AUTOLIGHTNINGOLD      AccountManagement
    Go To Salesforce and Login into Admin User
    Go To Entity    ${GROUP_TEST_ACCOUNT}
    Check original account owner and change if necessary
    Validate that account owner was changed successfully    ${NEW_OWNER}
    Validate that account owner has changed in Account Hierarchy

Remove Account owner
    [Documentation]    REmoving the account owner (changing the account owner to GESB Integration)
    [Tags]    BQA-8524    AUTOLIGHTNINGOLD      AccountManagement
    Go To Salesforce and Login into Admin User
    Go To Entity    ${RemoveAccountOwner}
    Remove change account owner
    #Change account owner to  ${REMOVE_ACCOUNT}
    #Validate that account owner was changed successfully  ${REMOVE_ACCOUNT}

Lightning: Sales admin Change Account owner
    [Documentation]    Change Business Account owner by logging into Digisales Admin User
    [Tags]    BQA-8525    AUTOLIGHTNINGOLD     AccountManagement
    Login to Salesforce as DigiSales Admin user
    Go to Entity    ${TEST_CONTACT}
    Change Account Owner
    #THIS IS A DUPLICATE

Lightning: Sales admin Change Account owner for group account
    [Documentation]    Change Group Account owner by logging into Digisales Admin User
    [Tags]    BQA-8526    AUTOLIGHTNINGOLD     AccountManagement
    Login to Salesforce as DigiSales Admin user
    Go to Entity    ${GROUP_TEST_ACCOUNT}
    Change Account Owner
    #Create opportunity from Account for HDCFlow
    #    [Tags]    BQA-HDCOppo    Lightning2
    #    #Login to Salesforce as DigiSales Lightning User
    #    Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
    # #sleep    20s
    #Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    #${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    #sleep    10s
    #sleep    10s
    #${billing_acc_name}    run keyword    CreateABillingAccount
    #sleep    10s    #pass
    #capture page screenshot
    #log to console    ${billing_acc_name}.this is billing account name
    #Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    #capture page screenshot
    #sleep    10s
    #${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    ###${contact_name}
    #log to console    ${oppo_name}.this is opportunity
    #sleep    10s
    #Go To Entity    ${oppo_name}
    #sleep    30s
    #ChangeThePriceBookToHDC    HDC Pricebook B2B
    #ClickingOnCPQ    ${oppo_name}
    ##ClickingOnCPQ    Oppo_ 20190112-151427
    #Adding Telia Colocation    Telia Colocation
    #Updating Setting Telia Colocation
    #UpdateAndAddSalesType    Telia Colocation
    #OpenQuoteButtonPage
    #CreditScoreApproving
    #ClickonCreateOrderButton
    #NextButtonOnOrderPage
    #SearchAndSelectBillingAccount
    #SelectingTechnicalContact    ${contact_name}
    #RequestActionDate
    #SelectOwnerAccountInfo    ${billing_acc_name}
    #ReviewPage
    #ValidateTheOrchestrationPlan
    #Reach the Order Page and Validating the details
    #wait until page contains element    //span[text()='Order']//following::div/span[@class='uiOutputText']
    #${order_id}=    get text    //span[text()='Order']//following::div/span[@class='uiOutputText']
    #spage should contain element    //th/div/a[text()='Telia Colocation']
    #page should contain element    //th/div/a[text()='Telia Colocation']//following::td/span[text()='New Money-New Services']
    #Execute JavaScript    window.scrollTo(0,2000)
    #page should contain element    //th[@title='Orchestration Plan Name']//following::div[@data-aura-class='forceOutputLookupWithPreview']/a
    #click element    //th[@title='Orchestration Plan Name']//following::div[@data-aura-class='forceOutputLookupWithPreview']/a
    #sleep    20s

#Create HDC Order -old
#    [Tags]    BQA-HDCOrder
#    Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
#    #go to entity    319021811502
#    #sleep    10s
#    #${order_number}    run keyword    getOrderStatusAfterSubmitting
#    #ValidateTheOrchestrationPlan
#    #go to entity    ${order_number}
#    #openAssetviaOppoProductRelated
#    #sleep    300s
#    #click element    //span[@class='title' and text()='Assets']
#    #sleep    3s
#    #click element    //div[@data-aura-class="forceOutputLookupWithPreview"]/a[text()='Telia Colocation']
#    ##${business_acc_name}    run keyword    CreateBusinessAccount
#    ##log to console    ${business_acc_name}.this is business account
#    #Execute javascript    document.body.style.transform = 'scale(0.8)';
#    #document.body.style.zoom="50%"
#    #Go To Entity    ${business_acc_name}
#    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
#    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
#    log to console    ${contact_name}.this is name
#    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
#    log to console    ${oppo_name}.this is opportunity
#    ${billing_acc_name}    run keyword    CreateABillingAccount
#    log to console    ${billing_acc_name}.this is billing account name
#    Go To Entity    ${oppo_name}
#    ChangeThePriceBookToHDC    HDC Pricebook B2B
#    ClickingOnCPQ    ${oppo_name}
#    Adding Telia Colocation    Telia Colocation
#    Updating Setting Telia Colocation
#    UpdateAndAddSalesType    Telia Colocation
#    OpenQuoteButtonPage
#    #CreditScoreApproving
#    #go to entity    Oppo_ 20190217-115637    Quotes
#    sleep    40s
#    ClickonCreateOrderButton
#    NextButtonOnOrderPage
#    SearchAndSelectBillingAccount
#    SelectingTechnicalContact    ${contact_name}
#    #${contact_name}
#    RequestActionDate
#    SelectOwnerAccountInfo    ${billing_acc_name}
#    #${billing_acc_name}
#    ReviewPage
#    ValidateTheOrchestrationPlan

Create HDC Order
    [Tags]    BQA-11774    AUTOLIGHTNINGOLD       HDCOrderManagement
    Login to Salesforce as DigiSales Lightning User
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    ${billing_acc_name}    run keyword    CreateABillingAccount   ${vLocUpg_TEST_ACCOUNT}
    Go To Entity    ${oppo_name}
    #Edit Opportunity values    Price List      B2B
    ChangeThePriceList      B2B
    ClickingOnCPQ    ${oppo_name}
    Adding Telia Colocation    Telia Colocation
    Updating Setting Telia Colocation
    UpdateAndAddSalesType    Telia Colocation
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount   ${vLocUpg_TEST_ACCOUNT}
    select order contacts- HDC  ${contact_name}
    #SelectingTechnicalContact    ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    ${billing_acc_name}
    #${billing_acc_name}
    #ReviewPage
    clickOnSubmitOrder
    ValidateTheOrchestrationPlan

Create B2B Order
    [Tags]    BQA-8919     AUTOLIGHTNINGOLD        B2BOrderManagement
    Login to Salesforce as DigiSales Lightning User
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    sleep    10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity    ${oppo_name}
    #Edit Opportunity values    Price List      B2B
    ChangeThePriceList      B2B
    #ChangeThePriceBookToHDC    B2B Pricebook
    ##B2O pricebook
    ClickingOnCPQ   ${oppo_name}
    AddProductToCart    Alerta projektointi
    ##B2O Other Services
    Run Keyword If    '${r}'== 'b2b'    run keyword    UpdateAndAddSalesType    Alerta projektointi
    Run keyword If    '${r}'== 'b2o'    run keyword    UpdateAndAddSalesTypeB2O    B2O Other Services
    ##sleep    600s
    ##B2O Other Services
    ##OpenQuoteButtonPage
    #View Open Quote
    #CreditScoreApproving
    ClickonCreateOrderButton
    #ContractStateMessaging
    #OpenOrderPage
    NextButtonOnOrderPage
    OrderNextStepsPage
    getOrderStatusBeforeSubmitting
    #sleep    60s
    clickOnSubmitOrder
    getOrderStatusAfterSubmitting

Create B2O Order
    [Tags]    BQA-8920    AUTOLIGHTNINGOLD         B2OOrderManagement
    Login to Salesforce as DigiSales Lightning User
    #Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    Create New Contact for Account
    #log to console    ${contact_name}.this is name
    sleep    10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity    ${oppo_name}
    #Edit Opportunity values    Price List      B2O
    ChangeThePriceList      B2O
    #ChangeThePriceBookToHDC    B2O pricebook
    ##B2B Pricebook
    ClickingOnCPQ    ${oppo_name}
    #${oppo_name}    set variable   Test Robot Order_ 20191114-182830
    AddProductToCart    B2O Other Services
    ##Alerta projektointi
    #Run Keyword If    '${p}'== 'b2b'    run keyword    UpdateAndAddSalesType    Alerta projektointi
    Run keyword If    '${p}'== 'b2o'    run keyword    UpdateAndAddSalesTypeB2O    B2O Other Services
    #sleep    600s
    ##B2O Other Services
    #OpenQuoteButtonPage
    #View Open Quote
    ${quote_number}    Run Keyword    preview and submit quote  ${oppo_name}
    verifying quote and opportunity status      ${oppo_name}
    Search Salesforce    ${quote_number}
    Select Entity    ${oppo_name}    ${EMPTY}
    #CreditScoreApproving
    ClickonCreateOrderButton
    #clickonopenorderbutton
    NextButtonOnOrderPage
    OrderNextStepsPage
    getOrderStatusBeforeSubmitting
    #sleep    60s
    clickOnSubmitOrder
    getOrderStatusAfterSubmitting
    Go to Entity    ${oppo_name}
    Closing the opportunity with reason    Closed Won
    Verify That Opportunity is Found From My All Opportunities  ${oppo_name}

createAOppoViaSVE
    [Tags]    BQA-8798    AUTOLIGHTNINGOLD
    Login to Salesforce as DigiSales Lightning User
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    sleep    10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    #log to console    ${oppo_name}.this is opportunity
    go to entity    ${oppo_name}
    clickingOnSolutionValueEstimate    ${oppo_name}
    ${fyr}    run keyword    addProductsViaSVE    Telia Colocation
    Go To Entity    ${oppo_name}
    validateCreatedOppoForFYR   Telia Colocation  ${fyr}
    Move the Opportunity to next stage      ${oppo_name}    Negotiate and Close  Closed Won

E2E opportunity process incl. modelled and unmodelled products & Quote & SA & Order
    [Tags]    BQA-9121    AUTOLIGHTNINGOLD         B2BOrderManagement  rerun
    Go To Salesforce and Login into Lightning
    Go To Entity    Ylöjärven Yrityspalvelu Oy
    ${contact_name}    run keyword    Create New Contact for Account
    #log to console    ${contact_name}.this is name
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    #${oppo_name}    set variable    Test Robot Order_ 20191010-124935
    #sleep    5s
    Go To Entity    ${oppo_name}
    sleep    5s
    Editing Win prob    no
    Adding partner and competitor
    Capture Page Screenshot
    sleep    10s
    #clickingOnSolutionValueEstimate    ${oppo_name}
    ClickingOnCPQ    ${oppo_name}
    #click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    search products  Telia Yritysinternet Plus
    Adding Yritysinternet Plus  Telia Yritysinternet Plus
    search products    DataNet Multi
    Adding DataNet Multi  DataNet Multi
    #sleep   20s
    UpdateAndAddSalesType for 2 products    Telia Yritysinternet Plus    DataNet Multi
    #OpenQuoteButtonPage_release
    sleep    10s
    ${quote_number}    Run Keyword    preview and submit quote  ${oppo_name}
    Opportunity status
    #Create contract    ${TEST_ACCOUNT_CONTACT}    ${oppo_name}
    Create Order from quote    ${quote_number}    ${oppo_name}
    View order and send summary
    #sleep    10s
    Go to Entity    ${oppo_name}
    Closing the opportunity    No

Lightning: Opportunity: Products used for reporting only must not be visible on Quote & Order
    [Tags]    BQA-9122    AUTOLIGHTNINGOLD         B2BOrderManagement
    ${next_button}=    set variable    //span[contains(text(),'Next')]
    @{products}    Set Variable    Telia Ulkoistettu asiakaspalvelu    Telia Neuvottelupalvelut    Telia Palvelunumero    Telia Yritysliittymä    Telia Laskutuspalvelu
    ...    Telia Ulkoistettu asiakaspalvelu - Lisäkirjaus    Telia Neuvottelupalvelut - Lisäkirjaus    Telia Palvelunumero - Lisäkirjaus    Telia Yritysliittymä - Lisäkirjaus    Telia Laskutuspalvelu - Lisäkirjaus
    ...    Sopiva Pro-migraatio    Sovelluskauppa 3rd Party Apps    VIP:n käytössä olevat Cid-numerot    Ohjaus Telia Numeropalveluun    Online Asiantuntijapalvelut
    ${Submit Order}    set variable    //div[@title='Submit Order']
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    ${contact_name}    run keyword    Create New Contact for Account
    ${oppo_name}      run keyword    CreateAOppoFromAccount_HDC     ${contact_name}
    #${oppo_name}    set variable    Test Robot Order_ 20191010-182003
    sleep    5s
    Go To Entity   ${oppo_name}
    sleep    5s
    ClickingOnCPQ    ${oppo_name}
    #sleep    30s
    Searching and adding multiple products    @{products}
    Updating sales type multiple products    @{products}
    #OpenQuoteButtonPage_release
    preview and submit quote  ${oppo_name}
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    OrderNextStepsPage
    Preview order summary and verify order    @{products}
    Sleep       10s
    #go back
    wait until page contains element   ${Submit Order}  60s
    #Sleep       30s
    click element    ${Submit Order}
    sleep    60s
    Capture Page Screenshot
    #${multibella_GuiID}    Get Multibella id
    #verifying Multibella order case    ${multibella_GuiID}    @{products}

HDC - Complete Sales Process: UAT/Sanity Regression
    [Tags]    BQA-8560    AUTOLIGHTNINGOLD         HDCOrderManagement
    ${win_prob_edit}=    Set Variable    //span[contains(text(),'Win Probability %')]/../../button
    Go To Salesforce and Login into Lightning
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    #Go To Entity    ${TEST_ACCOUNT_CONTACT}
    #sleep    10s
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    ${billing_acc_name}    run keyword    CreateABillingAccount  ${vLocUpg_TEST_ACCOUNT}
    #log to console    ${oppo_name}.this is opportunity
    Go To Entity    ${oppo_name}
    sleep    10s
    wait until page contains element    ${win_prob_edit}    30s
    click element    ${win_prob_edit}
    Adding partner and competitor
    Sleep  10s
    #ChangeThePriceBookToHDC    HDC Pricebook B2B
    ChangeThePriceList      B2B
    ClickingOnCPQ    ${oppo_name}
    Adding Telia Colocation    Telia Colocation
    Updating Setting Telia Colocation
    UpdateAndAddSalesType    Telia Colocation
    #OpenQuoteButtonPage_release
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    #SearchAndSelectBillingAccount
    #select order contacts- HDC  ${contact_name}
    #RequestActionDate
    #SelectOwnerAccountInfo    ${billing_acc_name}
    #clickOnSubmitOrder

Automatic availability check B2B-Account
    [Tags]    BQA-10225    AUTOLIGHTNINGOLD        AvailabilityCheck
    Go To Salesforce and Login into Lightning
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Navigate to Availability check
    Validate Address details
    select product available for the address and create an opportunity
    #ClickingOnCPQ
    Check the CPQ-cart contains the wanted products    Telia Yritysinternet

Automatic availability check B2O-Account
    [Tags]    BQA-10225    AUTOLIGHTNINGOLD        AvailabilityCheck
    Go To Salesforce and Login into Lightning    DigiSales B2O User
    Go to Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer      ACTIVEACCOUNT
    Go to Entity    ${LIGHTNING_TEST_ACCOUNT}
    Navigate to Availability check
    Validate point to point address details
    Select B2O product available and connect existing opportunity
    #ClickingOnCPQ
    Check the CPQ-cart contains the wanted products     MetroEthernet Kapasiteetti

# Delete all contracts from account
#    [Tags]  Lightning
#    [Documentation]     Delete all service contracts from account related tab
#    Go To Salesforce and Login into Admin User
#    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
#    Delete all existing contracts from Accounts Related tab

Check banner for customership and service contract
    [Documentation]    Create new opportunity for account without service contract and verify that service contract draft is automatically created
    [Tags]      BQA-10334    AUTOLIGHTNINGOLD      ContractManagement
    Go To Salesforce and Login into Admin User
    Go To Entity    ${CONTRACT_ACCOUNT}
    Delete all entities from Accounts Related tab      Contracts
    Go To Salesforce and Login into Lightning
    #Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Go To Entity    ${CONTRACT_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    #Create New Opportunity For Customer    ACTIVEACCOUNT
    Verify that warning banner is displayed on opportunity page   ${OPPORTUNITY_NAME}
    #ClickingOnCPQ
    ClickingOnCPQ       ${OPPORTUNITY_NAME}
    Add product to cart (CPQ)    Telia Verkkotunnuspalvelu
    Update products
    #Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Go To Entity    ${CONTRACT_ACCOUNT}
    Check service contract is on Draft Status

Create contact relationship for account
    [Documentation]    Add new relationship for contact and check that account are displayed correctly on contact page.
    [Tags]     BQA-10523    AUTOLIGHTNINGOLD     ContactsManagement
    Go To Salesforce and Login into Lightning
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Contact for Account
    Add relationship for the contact person
    Go to Entity    ${contact_name}
    Validate contact relationship

Change business account owner
    [Documentation]    Change owner of the Business account to B2BDigisales Lightning user
    [Tags]    BQA-10736    AUTOLIGHTNINGOLD     AccountManagement
    Go To Salesforce and Login into Admin User
    Go To Entity    Aacon Oy
    Change account owner to     B2B Lightning
    Validate that account owner was changed successfully    B2B Lightning

Add an account team member as account owner
    [Tags]    BQA-10524     AUTOLIGHTNINGOLD       AccountManagement
    [Documentation]     Log in as digisales user and navigate to business account that you own. Add some user to business account team.
    Go To Salesforce and Login into Admin User
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Check original account owner and change if necessary for event
    logoutAsUser  Sales Admin
    Go To Salesforce and Login into Lightning
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Add new team member     Sales Admin
    Validate that team member is created succesfully

Edit team member's role as account owner
    [Tags]     BQA-10948    AUTOLIGHTNINGOLD       AccountManagement
    [Documentation]     Log in as B2B-sales user and edit team member's role when you are the owner of the account.
    Go To Salesforce and Login into Lightning
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Validate that team member is created succesfully
    Change team member role from account

Delete team member as account owner
    [Tags]     BQA-10949       AUTOLIGHTNINGOLD        AccountManagement
    [Documentation]     Log in as B2B-sales user and remove team member when you are the owner of the account.
    Go To Salesforce and Login into Lightning
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Validate that team member is created succesfully    Sales,Admin     Account Manager
    Delete team member from account

Add an account team member as Sales Admin
    [Documentation]    Log in as Sales Admin and then add some user as a team member for business account
    [Tags]    BQA-10727     AUTOLIGHTNINGOLD       AccountManagement
    Go To Salesforce and Login into Admin User
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Add new team member     Sales Admin
    Validate that team member is created succesfully

Edit team member's role as Sales Admin
    [Documentation]    Log in as Sales Admin and then edit existing team member's role for business account
    [Tags]     BQA-10728     AUTOLIGHTNINGOLD          AccountManagement
    Go To Salesforce and Login into Admin User
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Validate that team member is created succesfully
    Change team member role from account

Delete account team member as Sales Admin
    [Documentation]    Log in as Sales Admin and then delete team member from business account
    [Tags]     BQA-10740    AUTOLIGHTNINGOLD       AccountManagement
    Go To Salesforce and Login into Admin User
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Validate that team member is created succesfully    Sales,Admin     Account Manager
    Delete team member from account

Add an account team member to Group
    [Documentation]    Log in as Sales Admin and add team member to concern/group
    [Tags]     BQA-10737    AUTOLIGHTNINGOLD       AccountManagement
    Go To Salesforce and Login into Admin User
    Go to Entity  Aho Group
    Navigate to view    Account Team Members
    Add new team member     Sales Admin
    Validate that team member is created succesfully

Negative: Try to add account owner to Account team
    [Documentation]     Log in as sales admin and try to add the account owner to account team. This should not be possible.
    [Tags]      BQA-10952     AUTOLIGHTNINGOLD     AccountManagement
    Go To Salesforce and Login into Admin User
    Go to Entity  Aacon Oy
    Navigate to related tab
    Add account owner to account team
    Validate that account owner can not be added to account team

Negative: Try to add group owner to group's account team
    [Documentation]     Log in as sales admin and try to add group owner to group's account team as a member. This should not be possible.
    [Tags]      BQA-10951       AUTOLIGHTNINGOLD       AccountManagement
    Go To Salesforce and Login into Admin User
    Go to Entity  Aho Group
    Add account owner to account team
    Validate that account owner can not be added to account team

Group: Edit team member's role
    [Documentation]    Log in as Sales Admin. Go to group and edit existing team member's role.
    [Tags]    BQA-10738    AUTOLIGHTNINGOLD        AccountManagement
    Go To Salesforce and Login into Admin User
    Go to Entity  Aho Group
    Navigate to view    Account Team Members
    Validate that team member is created succesfully
    Change team member role from account

Group: Delete team member
    [Documentation]    Log in as Sales Admin. Go to group and delete existing team member.
    [Tags]     BQA-10739    AUTOLIGHTNINGOLD       AccountManagement
    Go To Salesforce and Login into Admin User
    Go to Entity  Aho Group
    Navigate to view    Account Team Members
    Validate that team member is created succesfully    Sales,Admin     Account Manager
    Delete team member from account

Negative: Try to add same team member twice to account team
    [Documentation]     Expected result: It's not possible to add same team member twice to business account's account team.
    [Tags]     BQA-11052       AUTOLIGHTNINGOLD        AccountManagement
    Go To Salesforce and Login into Admin User
    Go to Entity  ${LIGHTNING_TEST_ACCOUNT}
    Navigate to related tab
    Navigate to view    Account Team Members
    Try to add same team member twice  B2B Lightning
    Validate that same user can not be added twice to account team
    Delete team member from account

Negative: Check external data is not editable when creating new contact
    [Tags]      BQA-10945    AUTOLIGHTNINGOLD      ContactsManagement
    [Documentation]     Log in as B2B-sales user and try to create new contact. External data fields in the form shouldn't be editable.
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Navigate to create new contact
    Validate external contact data can not be modified
    Close contact form

Negative: Check external data is not editable with existing contact
    [Tags]       BQA-10946     AUTOLIGHTNINGOLD        ContactsManagement
    [Documentation]     Search contact with external data. Click edit and chect that external data fields are read-only.
    Login to Salesforce as System Admin
    Create new contact with external data
    Go To Salesforce and Login into Lightning
    Go to Entity    ${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}
    Open edit contact form
    Validate external contact data can not be modified
    Close contact form

Negative: Check external data is not editable from account contact relationship view
    [Tags]      BQA-10947     AUTOLIGHTNINGOLD     ContactsManagement
    [Documentation]     Search contact with external data. Go to related tab and click view relationship from related accounts. Check external data is not editable.
    Login to Salesforce as System Admin
    Create new contact with external data
    Go To Salesforce and Login into Lightning
    Go to Entity    ${MASTER_FIRST_NAME} ${MASTER_LAST_NAME}
    Navigate to related tab
    Click view contact relationship
    Validate external contact data can not be modified

Add several team members to business account team
    [Tags]    BQA-10937    AUTOLIGHTNINGOLD          AccountManagement
    [Documentation]     Log in as sales amdin and open business account that is member in some group hierarchy. Add several account team members and validate that
    ...     it's not possible to add same user twice and there can be several users with same role. Validate that it's possible for users to have different roles.
    Go To Salesforce and Login into Admin User
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
    [Tags]      BQA-10933       AUTOLIGHTNINGOLD       AccountManagement
    Go To Salesforce and Login into Admin User
    Go to Entity  Aho Group
    Check original account owner and change if necessary for event
    Navigate to view    Account Team Members
    Add new team member     Sales Admin
    Validate that team member is created succesfully  Sales,Admin
    Go to Entity  Aho Group
    Change account owner to     Sales Admin
    Validate that account owner was changed successfully  Sales Admin
    Navigate to view    Account Team Members
    Wait until page contains element    //div[@class='emptyContent']//p[text()='No items to display.']      30s
    Go to Entity  Aho Group
    Navigate to Account History
    Validate that Account history contains record   Sales Admin
    Go to Entity  Aho Group
    Change account owner to  B2B Lightning
    Validate that account owner was changed successfully  B2B Lightning

Negative: Try to change account owner different from the group account owner
    [Documentation]     Log in as sales admin and find Business account from group hierarchy. Try to change the Business Account owner different from
    ...     the group account owner. This should not be possible.
    [Tags]     BQA-10968     AUTOLIGHTNINGOLD     AccountManagement
    Go To Salesforce and Login into Admin User
    ${group_account_owner}=    Set variable     Maris Steinbergs
    Go to Entity  AT&T
    Compare owner names  ${group_account_owner}
    Change account owner to  Sales Admin
    Validate that account owner cannot be different from the group account owner

Mobile coverage request redirects to Tellu
    [Documentation]     Check that mobile coverage request button redirects to Tellu-system log in.
    [Tags]     BQA-10955      AUTOLIGHTNINGOLD         OpportunityValidation
    Go To Salesforce and Login into Lightning
    Go to Entity  ${LIGHTNING_TEST_ACCOUNT}
    Navigate to view  Opportunities
    Wait element to load and click  ${test_opportunity}
    ${status}=  Run keyword and return status    Wait element to load and click  //a[@title='Mobile Coverage Request']
    Run keyword if      ${status} == False    Force click element  //a[@title='Show 9 more actions']
    Run keyword if      ${status} == False    Click element   //a[@title='Mobile Coverage Request']
    Sleep   10s
    Validate that Tellu login page opens

Manual availability check redirects to Tellu
    [Documentation]     Check that manual availability check button from the opportunity page redirects to Tellu-system login.
    [Tags]     BQA-10954     AUTOLIGHTNINGOLD          OpportunityValidation
    Go To Salesforce and Login into Lightning
    Go to Entity  ${LIGHTNING_TEST_ACCOUNT}
    Navigate to view  Opportunities
    Wait element to load and click  ${test_opportunity}
    Wait element to load and click  //a[@title='Manual Availability Check']
    Validate that Tellu login page opens

Investment redirects to Tellu
    [Documentation]     In opportunity view clicking investment button redirects to Tellu-system login
    [Tags]      BQA-10953      AUTOLIGHTNINGOLD        OpportunityValidation
    Go To Salesforce and Login into Lightning
    Go to Entity  ${LIGHTNING_TEST_ACCOUNT}
    Navigate to view  Opportunities
    Wait element to load and click  ${test_opportunity}
    Wait element to load and click  //a[@title='Investment']
    Validate that Tellu login page opens

Price input for unmodeled products in omniscript
    [Tags]    BQA-9160      AUTOLIGHTNINGOLD          OpportunityValidation
    Go To Salesforce and Login into Lightning
    Go to Entity  ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer     ACTIVEACCOUNT
    ClickingOnCPQ       ${OPPORTUNITY_NAME}
    Add product to cart (CPQ)  Datainfo DaaS-palvelu
    Update products OTC and RC
    Check prices are correct in quote line items
    Go to Entity  ${OPPORTUNITY_NAME}
    Check opportunity value is correct

create a b2b direct order
    [Tags]    BQA-10813    AUTOLIGHTNINGOLD       B2BOrderManagement
    Login to Salesforce as DigiSales Lightning User
    #Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
    Go To Entity    Ylöjärven Yrityspalvelu Oy
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    sleep    10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity    ${oppo_name}
    ClickingOnCPQ    ${oppo_name}
    AddProductToCart    Fiksunetti
    Run Keyword If    '${r}'== 'b2b'    run keyword    UpdateAndAddSalesTypeandClickDirectOrder    Fiksunetti
    #View Open Quote
    #openOrderFromDirecrOrder
    getorderstatusbeforesubmitting
    clickonsubmitorder
    ${order_no}    run keyword    getorderstatusaftersubmitting
    #go to entity    ${order_no}
    getMultibellaCaseGUIID    ${order_no}

Add Oppo Team Member and Edit the Oppo with New Team Member
    [Tags]  BQA-10816       AUTOLIGHTNINGOLD       OpportunityValidation
    [Documentation]  Create an opportunity with User-A and add new Oppo team member User-B and try modifying the oppo with newly added team member
    #login to salesforce as digisales lightning user vlocupgsandbox
    #swithchtouser  Sales Admin
    Go To Salesforce and Login into Admin User
    Go To Entity    Aarsleff Oy
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    sleep   10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    #log to console    ${oppo_name}.this is opportunity
    go to entity  ${oppo_name}
    #clickingoncpq  ${oppo_name}
    logoutasuser  Sales Admin
    sleep   10s
    Login to Salesforce as DigiSales Lightning User
    #login to salesforce as digisales lightning user vlocupgsandbox
    #swithchtouser  B2B DigiSales
    go to entity  ${oppo_name}
    #Edit Opportunity values     Price List  B2B
    changethepricelist      B2B
    #wait until page contains element  //li[text()='insufficient access rights on object id']   30s
    #page should contain element  //li[text()='insufficient access rights on object id']
    #click element  //span[text()='Cancel']/..
    #click element     //div[@class="riseTransitionEnabled test-id__inline-edit-record-layout-container risen"]//div[@class="actionsContainer"]//*[contains(text(),"Cancel")]
    #sleep  3s
    #reload page
    Sleep  10s
    logoutasuser  B2B DigiSales
    sleep  10s
    #Go To Salesforce and Login into Admin User
    #${oppo_name}     set variable   Test Robot Order_ 20191021-143603
    Login to Salesforce as DigiSales Admin User
    #login to salesforce as digisales lightning user vlocupgsandbox
    #swithchtouser  Sales Admin
    #AddOppoTeamMember  Oppo2349_2    B2O NetworkSales
    AddOppoTeamMember  ${oppo_name}   B2B DigiSales
    logoutAsUser  Sales Admin
    sleep  10s
    Login to Salesforce as DigiSales Lightning User
    #login to salesforce as digisales lightning user vlocupgsandbox
    #swithchtouser  B2B DigiSales
    go to entity  ${oppo_name}
    changethepricelist    GTM
    #Edit Opportunity values     Price List  B2B


AddProducrViaSVEandCPQFlow
    [Tags]      BQA-10817      AUTOLIGHTNINGOLD        OpportunityValidation
    Login to Salesforce as DigiSales Lightning User
    #Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
    Go To Entity    Digita Oy
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    sleep   10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    #log to console    ${oppo_name}.this is opportunity
    go to entity  ${oppo_name}
    clickingOnSolutionValueEstimate   ${oppo_name}
    ${fyr}  run keyword  addProductsViaSVE         ${product_name}
    Go To Entity    ${oppo_name}
    ${revenue_total}=  get text  //p[text()="Revenue Total"]/../..//lightning-formatted-text
    ${fyr_total}=  get text  //p[text()="FYR Total"]/../..//lightning-formatted-text
    ${revenue_total}=  remove string  ${revenue_total}  ,00 €
    ${revenue_total}=       Evaluate    '${revenue_total}'.replace(' ','')
    #log to console  ${revenue_total}.this is final revenue total
    ${fyr_total}=  remove string  ${fyr_total}  ,00 €
    ${fyr_total}=       Evaluate    '${fyr_total}'.replace(' ','')
    #log to console  ${revenue_total}.this is final revenue total
    #log to console  ${fyr}.this is output of addproductviasve keyword
    should be equal as strings  ${fyr_total}  ${fyr}
    should be equal as strings  ${revenue_total}  ${fyr}
    #validateCreatedOppoForFYR  ${fyr}
    ClickingOnCPQ  ${oppo_name}
    AddProductToCart  Fiksunetti
    Run Keyword If    '${r}'== 'b2b'    run keyword  UpdateAndAddSalesType   Fiksunetti
    #OpenQuoteButtonPage
    #${quote_number}   run keyword   getQuoteNumber
    #logoutAsUser  B2B DigiSales
    #sleep   10s
    #login to salesforce as digisales lightning user vlocupgsandbox
    #openQuoteFromOppoRelated   ${oppo_name}   ${quote_number}
    #CreditScoreApproving
    #swithchtouser  B2B DigiSales
    #openQuoteFromOppoRelated   ${oppo_name}   ${quote_number}
    ClickonCreateOrderButton
    #ContractStateMessaging
    NextButtonOnOrderPage
    OrderNextStepsPage
    clickOnSubmitOrder
    ${order_no}  run keyword  getOrderStatusAfterSubmitting
    #go to entity   ${order_no}
    getMultibellaCaseGUIID   ${order_no}


CreateB2BHDCGTMOrder
    [Tags]      BQA-10818       AUTOLIGHTNINGOLD       HDCGTMOrderManagement
    #Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
    #swithchtouser   B2B DigiSales
    Go To Salesforce and Login into Lightning
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    sleep   10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    #log to console    ${oppo_name}.this is opportunity
    go to entity  ${oppo_name}
    #Edit Opportunity values    Price List      GTM
    changethepricelist     GTM
    clickingOnSolutionValueEstimate   ${oppo_name}
    ${fyr}  run keyword   addProductsViaSVE      Telia Colocation
    #log to console  ${fyr}.this is total
    ${GTM_limit}=  set variable  600000
    ${result}=  evaluate  ${fyr} > ${GTM_limit}
    #log to console  ${result}.this is comparison
    Run keyword If    ${result}=='True'   click on more actions
    scrolluntillfound  //button[@title="Edit GTM Approval Request Justification"]
    click element  //button[@title="Edit GTM Approval Request Justification"]
    wait until page contains element  //Span[text()='GTM Approval Request Justification']/../following-sibling::textarea   30s
    force click element  //Span[text()='GTM Approval Request Justification']/../following-sibling::textarea
    input text    //Span[text()='GTM Approval Request Justification']/../following-sibling::textarea    Please APprove
    click element  //div[@class="footer active"]//button[@title="Save"]
    #Log to console  To be submitted for approval
    scroll page to location  0  0
    sleep  3s
    wait until page contains element  //a[contains(@title, 'more actions')][1]   30s
    force click element  //a[contains(@title, 'more actions')][1]
    wait until page contains element   //div/div[@role="menu"]//a[@title="Submit for HDC GTM Approval"][1]/..   20s
    page should contain element   //div/div[@role="menu"]//a[@title="Submit for HDC GTM Approval"][1]/..
    force click element   //div[text()='Submit for HDC GTM Approval']
    #Log to console      Submitted for approval
    sleep  5s
    reload page
    Sleep  60s
    #scrolluntillfound  //span[text()='Pending Approval']
    page should contain element  //span[text()='Pending Approval']
    #Log to console  Pending approval
    logoutAsUser  B2B DigiSales
    sleep   10s
    Login to Salesforce as System Admin
    #login to salesforce as digisales lightning user vlocupgsandbox
    ApproveB2BGTMRequest  Leila Podduikin  ${oppo_name}
    ApproveB2BGTMRequest  Tommi Mattila    ${oppo_name}
    #swithchtouser  B2B DigiSales
    go to entity  ${oppo_name}
    scrolluntillfound  //span[text()='GTM Pricing Approval Status']/..//following-sibling::div//span[text()='Approved']
    page should contain element  //span[text()='GTM Pricing Approval Status']/..//following-sibling::div//span[text()='Approved']
    #Log to console      Status Approved
    ClickingOnCPQ    ${oppo_name}
    #Adding Telia Colocation    Telia Colocation
    #Updating Setting Telia Colocation
    #UpdateAndAddSalesType    Telia Colocation
    #OpenQuoteButtonPage
    #sleep   15s
    #go to entity  Oppo_ 20190428-002314
    #changethepricelist  B2B   GTM
    #clickingOnSolutionValueEstimate   Oppo_ 20190428-002314
    #${fyr}  run keyword   addProductsViaSVE      Telia Colocation
    #log to console  ${fyr}.this is total
    #${GTM_limit}=  set variable  600000
    #${result}=  evaluate  635000 > ${GTM_limit}
    #log to console  ${result}.this is comparison
    #go to entity  Oppo_ 20190428-002314
    #Run keyword If    ${result}=='True'   click on more actions
    ###scrolluntillfound  //button[@title="Edit GTM Approval Request Justification"]
    ###click element  //button[@title="Edit GTM Approval Request Justification"]
    ###wait until page contains element  //Span[text()='GTM Approval Request Justification']/../following-sibling::textarea   30s
    ###input text    //Span[text()='GTM Approval Request Justification']/../following-sibling::textarea    Please APprove
    ###click element  //button[@title="Save"]
    ###scroll page to location  0  0
    ###sleep  3s
    ###wait until page contains element  //a[contains(@title, 'more actions')][1]   30s
    ###force click element  //a[contains(@title, 'more actions')][1]
    ###wait until page contains element   //div/div[@role="menu"]//a[@title="Submit for HDC GTM Approval"][1]/..   10s
    ###page should contain element   //div/div[@role="menu"]//a[@title="Submit for HDC GTM Approval"][1]/..
    ###force click element   //a[@title="Submit for HDC GTM Approval"]/div

    #Leila Podduikin 1st approval
    #Tommi Mattila  Final Approval
    #scrolluntillfound  //span[text()='Items to Approve']
    #click element  //span[text()='Items to Approve']/ancestor::div[contains(@class,'card__header')]//following::a[text()='Oppo_ 20190428-002314']
    #wait until page contains element   //span[text()='Opportunity Approval']  60s
    #click element  //div[text()='Approve']
    #wait until page contains element  //h2[text()='Approve Opportunity']   30s
    #wait until element is visible  //span[text()='Comments']/../following::textarea   30s
    #input text  //span[text()='Comments']/../following::textarea   1st level Approval Done By Leila
    #input text  //span[text()='Comments']/../following::textarea   Final level Approval Done By Tommi Mattila
    #click element  //span[text()='Approve']
    #swithchtouser  B2B DigiSales
    #Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    #${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    #sleep   10s
    #${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    #log to console    ${oppo_name}.this is opportunity
    #go to entity  ${oppo_name}
    #changethepricelist
    #${fyr}  run keyword  addProductsViaSVE         ${product_name}

createSalesProjectOppo
    [Tags]        BQA-11776    AUTOLIGHTNINGOLD        OpportunityValidation
    Login to Salesforce as DigiSales Lightning User
    #login to salesforce as digisales lightning user vlocupgsandbox
    #swithchtouser  B2B DigiSales
    Go To Entity   ${vLocUpg_TEST_ACCOUNT}
    #Log to console      Create Contact
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    sleep   10s
    #Log to console      create oppurtunity
    ${oppo_name}      run keyword  CreateAOppoFromAccount_HDC      ${contact_name}
    #${oppo_name} =   Set variable                                  Test Robot Order_ 20190927-123308
    Go To Entity     ${oppo_name}
    sleep  2s
    #Log to console      addproductsviasve
    clickingOnSolutionValueEstimate     ${oppo_name}
    addProductsViaSVE   Subscriptions and networks
    Sleep  10s
    #Log to console  Create case
    ${case_number}=  run keyword      Create case from more actions
    #log to console   ${case_number}.this is created case
    logoutAsUser  B2B DigiSales
    Login to Salesforce as System Admin
    #login to salesforce as digisales lightning user vlocupgsandbox
    swithchtouser      B2B DigiSales
    #swithchtouser  Anna Vierinen
    openquotefromopporelated  ${oppo_name}  ${case_number}
    SalesProjectOppurtunity     ${case_number}
    go to entity    ${oppo_name}
    page should contain element  //span[text()='Opportunity Record Type']/../..//div//span[text()='Sales Project Opportunity']
    #createSalesProjectOppo
#    [Tags]  SreeramE2E       Lightning
#    login to salesforce as digisales lightning user vlocupgsandbox
#    swithchtouser  B2B DigiSales
#    Go To Entity   ${vLocUpg_TEST_ACCOUNT}
#    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
#    log to console    ${contact_name}.this is name
#    sleep   10s
#    ${oppo_name}      run keyword  CreateAOppoFromAccount_HDC      ${contact_name}
#    Go To Entity     ${oppo_name}
#    #reload page
#    sleep  2s
#    ${case_number}=  run keyword      createACaseFromMore  ${oppo_name}  B2B Sales Expert Request
#    #createACaseFromOppoRelated  ${oppo_name}  B2B Sales Expert Request
#    log to console   ${case_number}.this is created case
#    logoutAsUser  B2B DigiSales
#    login to salesforce as digisales lightning user vlocupgsandbox
#    swithchtouser  Anna Vierinen
#    openquotefromopporelated  ${oppo_name}  ${case_number}
#    #go to entity  ${case_number}
#    sleep  15s
#    click element  //span[text()='${case_number}']//following::button[@title='Edit Subject']
#    wait until element is visible  //a[@class='select' and text()='New']   30
#    click element  //a[@class='select' and text()='New']
#    sleep  3s
#    #//a[text()='New']//ancestor::div[@data-aura-class='uiMenu']
#    click element  //a[@title="In Case Assessment"]
#    ${date}  get date from future  7
#    input text   //span[text()='Offer Date']/../following-sibling::div/input   ${date}
#    force click element  //span[text()='Sales Project']/..//following-sibling::input[@type="checkbox"]
#    Scroll Page To Location    0    1400
###scroll element into view  //Span[text()='Support Case Cycle Time']
###//a[@class='select' and text()='--None--']
#    wait until element is visible   //a[@class='select' and text()='--None--']
#    force click element  //a[@class='select' and text()='--None--']
#    click element  //a[@title='Sales Project']
#    click element  //button[@title='Save']/span
#    Log to console      Case Saved
#    Scroll Page To Location    0    0
#    wait until page contains element  //span[text()='Assign Support Resource' and @class="title"]   30s
#    force click element  //span[text()='Assign Support Resource' and @class='title']
#    wait until page contains element  //span[text()='Assigned Resource']  30s
#    input text   //span[text()='Assigned Resource']/../following::input[@title="Search People"]   B2B DigiSales
#    sleep  10s
#    click element  //div[@title="B2B DigiSales"]
#    wait until element is visible  //a[@class='select' and text()='Solution Design']   20s
#    click element  //a[@class='select' and text()='Solution Design']
#    sleep   10s
#    wait until element is visible   //div[@class='select-options']//ul//li/a[contains(text(),'Sales Project')]
#    click element  //div[@class='select-options']//ul//li/a[contains(text(),'Sales Project')]
#    sleep  5s
#    #click element  //a[@title="Sales Project"]
#    click element  //span[text()='Sales Support Case Lead']/../following::input[@type="checkbox"]
#    #sleep   40s
#    #scrolluntillfound   //span[text()="Save"][1]/../..
#    #sleep   2s
#    scroll page to location  0  200
#    wait until page contains element  //div[@class='bottomBarRight slds-col--bump-left']//span[text()="Save"][1]/..  20s
#    wait until element is visible  //div[@class='bottomBarRight slds-col--bump-left']//span[text()="Save"][1]/..  20s
#    click element  //div[@class='bottomBarRight slds-col--bump-left']//span[text()="Save"][1]/..
#    capture page screenshot
#    #go to entity   Oppo_ 20190427-010703
#    #${case_number}=  run keyword  createACaseFromOppoRelated  Oppo_ 20190427-010703  B2B Sales Expert Request
#    #log to console   ${case_number}.this is created case
#    #wait until page contains element  //span[text()='Commit Decision' and @class='title']   20s
#    #click element  //span[text()='Commit Decision' and @class='title']
#    #wait until page contains element  //div[text()='You are about to commit the case assessment decision and reassign the case to the designated case lead. Are you sure?']    20s
#    #click element  //span[text()='Next']/..
#    #sleep  5s
#    go to entity    ${oppo_name}
#    #sleep  10s
#    #scrolluntillfound  //span[text()='Opportunity Record Type']/../..//div//span[text()='Sales Project Opportunity']
#    page should contain element  //span[text()='Opportunity Record Type']/../..//div//span[text()='Sales Project Opportunity']
#    #click on more actions
#    #wait until page contains element  //a[contains(@title, 'more actions')][1]
#    #//a[contains(@title, 'more actions')]/..   30s
#    #force click element  //a[contains(@title, 'more actions')][1]
#    #wait until page contains element   //div/div[@role="menu"]//a[@title="B2B Sales Expert Request"][1]/..   10s
#    #page should contain element   //div/div[@role="menu"]//a[@title="B2B Sales Expert Request"][1]/..
#    #force click element   //a[@title="B2B Sales Expert Request"]/div
#    #wait until page contains element  //span[text()='Subject']/../following-sibling::input   60s
#    #${case_number}=    Generate Random String    7    [NUMBERS]
#    #input text  //span[text()='Subject']/../following-sibling::input   ${case_number}
#    #${date}=    Get Date From Future    7
#    #input text   //span[text()='Offer Date']/../following::div[@class='form-element']/input   ${date}
#    #scroll element into view  //span[text()='Type of Support Requested']/../following::textarea
#    #input text  //span[text()='Type of Support Requested']/../following::textarea   Dummy Text
#    #scroll element into view  //span[text()='Sales Project']/../following::input[1]
    #click element  //span[text()='Sales Project']/../following::input[1]
    #click element  //span[text()='Save']/..
    #capture page screenshot


Create B2B Order - Multibella
    [Tags]    BQA-11778       AUTOLIGHTNINGOLD         B2BOrderManagement
    #Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
    #SwithchToUser  B2B DigiSales
    Go To Salesforce and Login into Lightning
    Go To Entity    Digita Oy
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    sleep   10s
    ${oppo_name}      run keyword  CreateAOppoFromAccount_HDC      ${contact_name}
    go to entity   ${oppo_name}
    ClickingOnCPQ  ${oppo_name}
    AddProductToCart   Fiksunetti
    Run Keyword If    '${r}'== 'b2b'    run keyword    UpdateAndAddSalesType    Fiksunetti
    #OpenQuoteButtonPage
    ClickonCreateOrderButton
    #ContractStateMessaging
    NextButtonOnOrderPage
    OrderNextStepsPage
    getOrderStatusBeforeSubmitting
    sleep  60s
    clickOnSubmitOrder
    ${order_no}  run keyword  getOrderStatusAfterSubmitting
    #Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    #Input Text    xpath=${SEARCH_SALESFORCE}    ${order_no}
    #wait until page contains element  //ul[@class="lookup__list  visible"]/li[2]/a   30s
    #force click element     //ul[@class="lookup__list  visible"]/li[2]/a
    #Sleep  30s
    #go to entity   ${order_no}
    getMultibellaCaseGUIID   ${order_no}




###########################################   Scripts that needs fixing ########################################


Closing Opportunity as Won with FYR below 3 KEUR
    [Tags]    BQA-8794     AUTOLIGHTNINGOLD
    Closing Opportunity as Won with FYR    8    No
    #${FYR}=    set variable    //span[@title='FYR Total']/../div
    #Go To Salesforce and Login into Lightning
    #Go To Entity    ${TEST_ACCOUNT_CONTACT}
    #${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    Chetan
    #Go To Entity    ${oppo_name}
    #ClickingOnCPQ    ${oppo_name}
    #searching and adding Telia Viestintäpalvelu VIP (24 kk)
    #updating settings Telia Viestintäpalvelu VIP (24 kk)
    #search products    Telia Taloushallinto XXL-paketti
    #Adding Telia Taloushallinto XXL-paketti
    #UpdateAndAddSalesTypewith quantity    Telia Viestintäpalvelu VIP (24 kk)    8
    #OpenQuoteButtonPage_release
    #Go To Entity    ${oppo_name}
    #Closing the opportunity    no
    #sleep    15s
    #Capture Page Screenshot
    #${FYR_value}=    get text    ${FYR}
    #Log to console    The FYR value is ${FYR_value}

Closing Opportunity as Won with FYR between 3 KEUR to 100KEUR
    [Tags]    BQA-8795    AUTOLIGHTNINGOLD
    Go To Salesforce and Login into Lightning
    ${FYR}=    set variable    //p[@title='FYR Total']/..//lightning-formatted-text
    ${Edit_continuation}=    Set Variable    //div/button[@title='Edit Create Continuation Sales Opportunity?']
    Closing Opportunity as Won with FYR    200    Yes
    ${FYR_value}=    get text    ${FYR}
    sleep    10s
    Closing the opportunity and check Continuation  Closed Won
    ${oppo_name}  get text  //div//h1//div[text()="Opportunity"]/..//lightning-formatted-text
    Go to Entity   Continuation Sales: ${oppo_name}
    #Go to Entity  Continuation Sales: Test Robot Order_ 20191210-185900
    reload page
    sleep  60s
    ${FYR_value1}=    get text    //p[@title='FYR Total']/..//lightning-formatted-text
    Should be equal as strings  ${FYR_value}  ${FYR_value1}
    ${current_stage}=    set variable    //div[contains(@class,'test-id__field')]/span[contains(text(),'Stage')]/../../div/span[contains(@class,'field-value')]
    ${stage}  get text  ${current_stage}
    Should be equal as strings   ${stage}   Analyse Prospect
    #scrolluntillfound  //*[text()="Create Continuation Sales Opportunity?"]
    Execute Javascript    window.scrollTo(0,1000)
    wait until page contains element  //*[text()="Create Continuation Sales Opportunity?"]   30s
    #Click button   ${Edit_continuation}
    #Page Should Contain Element     //*[text()="Create Continuation Sales Opportunity?"]/../../div[2]//span/span[text()="Yes"]
    #Select option from Dropdown with Force Click Element    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Create Continuation Sales Opportunity?')]/../../div/div/div/div/a    //div[@class='select-options']/ul/li//a[@title='--None--']
    #Select option from Dropdown    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Create Continuation Sales Opportunity?')]/../../div/div/div/div/a    Yes
    #click element    //div[@class='footer active']//div[@class='actionsContainer']/button[@title='Save']/span
    #${msg} =  run keyword and expect error   Select option from Dropdown    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Create Continuation Sales Opportunity?')]/../../div/div/div/div/a    yes
    #log to console  opportunity is closed as Won, ${msg} no continuation opportunity created
    #click element    //div[@class='footer active']//div[@class='actionsContainer']/button[@title='Save']/span
    sleep    5s
    Capture Page Screenshot

Closing Opportunity as Won with FYR greater than 100KEUR
    [Tags]    BQA-8796   AUTOLIGHTNINGOLD
    Closing Opportunity as Won with FYR    300    Yes
    Closing the opportunity and check Continuation  Closed Won

Frame test
    [Tags]    frame
    ${frame}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Go To Salesforce and Login into Lightning
    Go To    https://telia-fi--release.lightning.force.com/one/one.app#eyJjb21wb25lbnREZWYiOiJvbmU6YWxvaGFQYWdlIiwiYXR0cmlidXRlcyI6eyJhZGRyZXNzIjoiaHR0cHM6Ly90ZWxpYS1maS0tcmVsZWFzZS5saWdodG5pbmcuZm9yY2UuY29tL2FwZXgvdmxvY2l0eV9jbXRfX2h5YnJpZGNwcT9pZD0wMDYwRTAwMDAwQ25rZDYifSwic3RhdGUiOnt9fQ%3D%3D
    Wait Until Element Is Visible    ${frame}    45s
    select frame    ${frame}
    sleep    10s
    Capture Page Screenshot
    Get Window Size
    #Set Window Size    1920    1080
    #Capture Page Screenshot

reload page test
    [Tags]    reloaded
    ${frame}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Go To Salesforce and Login into Lightning
    Go To    https://telia-fi--release.lightning.force.com/one/one.app#eyJjb21wb25lbnREZWYiOiJvbmU6YWxvaGFQYWdlIiwiYXR0cmlidXRlcyI6eyJhZGRyZXNzIjoiaHR0cHM6Ly90ZWxpYS1maS0tcmVsZWFzZS5saWdodG5pbmcuZm9yY2UuY29tL2FwZXgvdmxvY2l0eV9jbXRfX2h5YnJpZGNwcT9pZD0wMDYwRTAwMDAwQ25rZDYifSwic3RhdGUiOnt9fQ%3D%3D
    Wait Until Element Is Visible    ${frame}    45s
    select frame    ${frame}
    sleep    10s
    Capture Page Screenshot
    # Window Size
    Execute Javascript    window.location.reload(false);
    Capture Page Screenshot

Contract activation
    Go To Salesforce and Login into Lightning
    Go to Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Contact for Account
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Update Contact and Pricelist in Opportunity    B2B


#######please donot panic with Portal test cases #######

createRFQviaOnline
    [Documentation]    this is to create RFQ via b2o Online portal
    [Tags]        B2OPortal
    openOnlinePortal
    ## RFQ Creation Starts ##
    wait until page contains element    //span[text()='Offering']    60s
    click element    //span[text()='Offering']
    wait until page contains element    //h1[text()='Telia Offering']    60s
    page should contain element    //h2[text()='None']
    page should contain element    //h2[text()='Networking']
    page should contain element    //h2[text()='Internet']
    page should contain element    //h2[text()='Data centre']
    click element    //h2[text()='Networking']
    wait until page contains element    //h2[text()='Telia Networking products']    60s
    click element    //span[contains(@class,'arrow-down telia-react-icon__sizeXs')]/..
    click element    //div[text()='Finland']
    #click element    //Span[text()='Postal code']
    input text    //label[contains(@class,'postal-code')]//input    00250
    wait until page contains element    //span[contains(@class,'darkGreen')]    5s
    page should contain element    //span[contains(@class,'darkGreen')]
    input text    //div[contains(@class,'street-address')]//input    Humalistonkatu 1a
    click element    //div[text()='Humalistonkatu 1a']
    input text    //label[contains(@class,'select-city')]//input    Helsinki
    click element    //span[text()='Ethernet Nordic Network Bridge']/../../..//button[contains(@class,'select-product')]
    wait until page contains element    //h1[text()='Select configuration']    90s
    scrolluntillfound    //button[contains(@class,'configuration-send-rfq-button')]
    click element    //button[contains(@class,'configuration-send-rfq-button')]
    wait until page contains element    //h1[text()='Send request for quotation']    60s
    page should contain element    //h2[text()='Installation information']
    input text    //label[contains(@class,'company-name')]//input    Test COmpany A Party
    input text    //label[contains(@class,'contact-name')]//input    Test Contact Person A Party
    input text    //label[contains(@class,'contact-phone')]//input    +35811111111
    input text    //label[contains(@class,'contact-email')]//input    test@test.com
    input text    //label[contains(@class,'project-id')]//input    999999
    scrolluntillfound    //div[text()='Send RFQ']
    click element    //div[text()='Send RFQ']
    wait until page contains element    //h1[text()='Thank you for your RFQ!' ]    60s
    ${rfq_number}=    get text    //Span[text()='RFQ number']/..//h2
    #log to console    ${rfq_number}.this is rfq
    ## RFQ Creation Ends ##
    ## Logout from portal starts ##
    click element    //span[@class='telia-react-element telia-react-color__purple telia-react-icon telia-icon--arrow-down telia-react-icon__sizeSm']
    sleep    1s
    click element    //span[text()='Logout']
    sleep    5s
    close browser
    logout from all systems and close browser
    ## Logout from portal ends ##
    ## Login to Claudia Sitpo starts ##

RFQValidationInClaudia
    [Tags]       B2OPortal
    login to salesforce as digisales lightning user sitposandbox
    ## Search the Oppo based on the RFQ id received via portal starts ##
    Search Salesforce    2019040000036072
    wait until page contains element    //span[@title='2019040000036072']//ancestor::tbody//th//a    60s
    click element    //span[@title='2019040000036072']//ancestor::tbody//th//a
    ## Search the Oppo based on the RFQ id received via portal starts ##
    ## Validate    the Oppo starts##
    wait until page contains element    //span[text()='2019040000036072']    60s
    page should contain element    //span[text()='2019040000036072']
    scrolluntillfound    //span[text()='Price List']/..//following-sibling::div//a[text()='B2O']
    page should contain element    //span[text()='Price List']/..//following-sibling::div//a[text()='B2O']
    page should contain element    //span[text()='Price Book']/..//following-sibling::div//a[text()='Standard Price Book']
    page should contain element    //span[text()='Source']/..//following-sibling::div//span[text()='B2O Self Care']
    page should contain element    //span[text()='Visible to Portal']/..//following-sibling::div//img[@class=" checked"]
    scrolluntillfound    //span[text()='Opportunity Record Type']/..//following-sibling::div//span[text()='B2O Opportunity']
    page should contain element    //span[text()='Opportunity Record Type']/..//following-sibling::div//span[text()='B2O Opportunity']
    page should contain element    //span[text()='Created By']/..//following-sibling::div//a[text()='Online Integration']
    ## Validate    the Oppo ends##
    ## Click on the CPQ from Oppo starts##
    click element    xpath=//a[@title='CPQ']
    sleep    20s
    ## Click on the CPQ from Oppo ends##
    select frame    //div[contains(@class,'slds')]/iframe
    page should not contain element    //h2[text()='Required attribute missing for Ethernet Nordic Network Bridge.']
    validateThePricesInTheCart    Ethernet Nordic Network Bridge
    click element    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    unselect frame
    sleep    20s
    UpdateAndAddSalesTypeB2O    Ethernet Nordic Network Bridge
    openb2oquotebuttonpage
    ## Open the Quote and make visisble to portal ##
    wait until page contains element    //span[@class='title' and text()='Details']    30s
    Reload Page
    wait until page contains element    //span[@class='title' and text()='Details']    30s
    click element    //span[@class='title' and text()='Details']
    wait until page contains element    //span[text()='Quote Name']    30s
    scrolluntillfound    //button[@title="Edit Visible to Portal"]
    click element    //button[@title="Edit Visible to Portal"]
    wait until page contains element    //span[text()='Visible to Portal']/../..//input    20
    click element    //span[text()='Visible to Portal']/../..//input
    scrolluntillfound    //span[text()='Save']/..
    click element    //span[text()='Save']/..
    ## Open the Quote and make visisble to portal ##

createOrderFromQuoteinOnlinePortal
    [Tags]       B2OPortal
    openOnlinePortal
    ## Search for the RFQ,Quote    ##
    wait until page contains element    //span[text()='Offering']    60s
    click element    //span[text()='Quotes and orders']
    wait until page contains element    //h1[text()='Quotes and orders']    30s
    input text    //input[contains(@class,'input_with_icon')]    2019040000036075
    sleep    3s
    click element    //span[text()='quotes and orders']
    Scroll Page To Location    0    300
    sleep    5s
    #scrolluntillfound    //div[text()='ID']/../..//span[text()='2019040000036075']
    #Scroll Page To Location    0    300
    wait until page contains element    //span[text()='2019040000036075']/..    30s
    wait until element is enabled    //span[text()='2019040000036075']/..    30s
    click element    //span[text()='2019040000036075']/..
    wait until page contains element    //span[text()='1 quotes received']    30s
    scrolluntillfound    //h2[text()='Our offer']
    click element    //button[contains(@class,'green telia-react-button')]
    wait until page contains element    //button[contains(@class,'order-quote-test')]    30s
    click element    //button[contains(@class,'order-quote-test')]
    wait until page contains element    //h1[text()='Thank you for your order']    30s
    page should contain element    //h1[text()='Thank you for your order']
    ${order_number}=    get text    //span[text()='Order number']/../h2
    ## Search for the RFQ,Quote    ##

validateTheOrderCreatedViaPortalInClaudia
    [Tags]       B2OPortal
    login to salesforce as digisales lightning user sitposandbox
    go to entity    319043010544
    wait until page contains element    //span[@class='title' and text()='Details']    30s
    click element    //span[@class='title' and text()='Details']
    wait until page contains element    //span[text()='B2O Order']    30s
    page should contain element    //span[text()='B2O Order']
    scrolluntillfound    //span[text()='SAP Order Number']/..//span
    ${sap_number}=    get text    //span[text()='SAP Order Number']/..//span
    #log to console    ${sap_number}

DummyTestCaseForHDC
    [Tags]        Lightning
    Login to Salesforce as System Admin
    swithchtouser    B2B DigiSales
    go to entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    sleep    5s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    #log to console    ${oppo_name}.this is opportunity
    sleep    5s
    ${billing_acc_name}    run keyword    CreateABillingAccount    ${vLocUpg_TEST_ACCOUNT}
    #log to console    ${billing_acc_name}
    sleep    5s
    go to entity    ${oppo_name}
    clickingoncpq    ${oppo_name}
    AddTeliaColocation    Telia Colocation    Cabinet 52 RU
    UpdateAndAddSalesType    Telia Colocation
    HDCOpenQuoteButtonPage
    ${quote_no}    run keyword    getQuoteNumber
    #log to console    ${quote_no}.this is quote
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount    Aacon Oy
    SelectingTechnicalContact    ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    ${billing_acc_name}
    #${billing_acc_name}
    ReviewPage
    ${order_no}    run keyword    ValidateTheOrchestrationPlan
    #log to console    ${order_no} .this is order

Delete All the Oppotunities in Account
    [Tags]       Lightning
    Go To Salesforce and Login into Admin User
    Go to Entity   Affecto Oy
    Delete all entities from Accounts Related tab       Opportunities

Delete all the contacts in Account
    Login to Salesforce as System Admin
    Search Salesforce    Aacon Oy
    Delete all entries from Search list     Contacts

Lightning - FYR Calculation for B2B
     [Tags]     BQA-11305   AUTOLIGHTNINGOLD   rerun
     Go To Salesforce and Login into Lightning
     Go to Entity    Kotipizza Group Oyj
     ${contact_name}   run keyword    Create New Contact for Account
     ${oppo_name}      run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
     #log to console      ${oppo_name}.this is opportunity
     #${oppo_name}    set variable   Test Robot Order_20200122-165146
     Go to Entity   ${oppo_name}
     clickingoncpq   ${oppo_name}
     search products    ${B2bproductfyr1}
     Adding Products for Telia Sopiva Pro N    ${B2bproductfyr1}
     Adding Products for Telia Sopiva Pro N child products  ${B2bproductfyr2}   ${B2bproductfyr3}
     Validate the MRC and OTC and Opportunity total in CPQ  ${B2bproductfyr1}   ${B2bproductfyr2}   ${B2bproductfyr3}
     UpdateAndAddSalesType for B2b products     ${B2bproductfyr1}   ${B2bproductfyr2}
     Go to Entity   ${oppo_name}
     ${lineitem_total}  ${fyr_total}    validate createdOPPO for products     ${oppo_name}
     ${Revenue_Total}   ${fyrt_total}   validate createOPPO values against quote value    ${oppo_name}
     validate lineitem totals in quote  ${oppo_name}    ${lineitem_total}  ${fyr_total}
     clickoncreateorderbutton
     clickonopenorderbutton
     NextButtonOnOrderPage
     OrderNextStepsPage
     validatation on order page     ${fyrt_total}    ${Revenue_Total}

#Lightning_Customership Contract
#     Go To Salesforce and Login into Admin User
#     #Login To Salesforce Lightning  ${SALES_ADMIN_APP_USER}  ${PASSWORD-SALESADMIN}
#     Go To Entity    ${CONTRACT_ACCOUNT}
#     #${contact_name}   run keyword    Create New Contact for Account
#     Delete all entities from Accounts Related tab   Contracts
#     Create contract Agreement  Customership
#     Go To Salesforce and Login into Lightning
#     Go to Entity    ${CONTRACT_ACCOUNT}
#     #${oppo_name}    set variable  Test Robot Order_ 20191112-160038
#     ${contact_name}   run keyword    Create New Contact for Account
#     ${oppo_name}      run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
#     Go to Entity   ${oppo_name}
#     clickingoncpq   ${oppo_name}
#     search products  Telia Colocation
#     Adding Products  Telia Colocation
#     search products  Telia Cid
#     Adding Products  Telia Cid
#     updating setting Telia Cid
#     Verify that warning banner is displayed on opportunity page sevice contract     ${oppo_name}
#     creation of the quote without service contract  ${oppo_name}
#     #go to  https://telia-fi--release.lightning.force.com/one/one.app#eyJjb21wb25lbnREZWYiOiJvbmU6YWxvaGFQYWdlIiwiYXR0cmlidXRlcyI6eyJhZGRyZXNzIjoiaHR0cHM6Ly90ZWxpYS1maS0tcmVsZWFzZS5saWdodG5pbmcuZm9yY2UuY29tL2FwZXgvdmxvY2l0eV9jbXRfX09tbmlTY3JpcHRVbml2ZXJzYWxQYWdlP2lkPTAwNjZFMDAwMDA4OWNjWFFBUSZ0cmFja0tleT0xNTczNTYyMzg3MjkwIy9PbW5pU2NyaXB0VHlwZS9PcHBvcnR1bml0eSUyMFByb2R1Y3QvT21uaVNjcmlwdFN1YlR5cGUvT0xJJTIwRmllbGRzL09tbmlTY3JpcHRMYW5nL0VuZ2xpc2gvQ29udGV4dElkLzAwNjZFMDAwMDA4OWNjWFFBUS9QcmVmaWxsRGF0YVJhcHRvckJ1bmRsZS8vdHJ1ZSJ9LCJzdGF0ZSI6e319
#     #sleep  50s
#     UpdateAndAddSalesType for 2 products and check contract     Telia Colocation  Telia Cid
#     View Open Quote
#     creation of the another one quote to verify the service contract  ${oppo_name}
#     verify that warning banner not displayed in that quote creation page
#     #sleep  50s
#     UpdateAndAddSalesType for 2 products and check contract     Telia Colocation  Telia Cid
#     View Open Quote
#     #log to console  activate the created service contract
#     Go To Salesforce and Login into Admin User
#     Activate the generated service contract     AP 20191112-160020 Test 20191112-160020  519111213248
#     Go To Salesforce and Login into Lightning
#     Go to Entity    ${CONTRACT_ACCOUNT}
#     ${oppo_name1}      run keyword    CreateAOppoFromAccount_HDC    AP 20191112-160020 Test 20191112-160020
#     Go to Entity   ${oppo_name1}
#     clickingoncpq   ${oppo_name1}
#     search products  Muutos Telia Cid
#     Adding Products  Muutos Telia Cid
#     search products  Telia DataCenter -tilaratkaisu
#     Adding Products  Telia DataCenter -tilaratkaisu
#     UpdateAndAddSalesType for 2 products and check contract    Muutos Telia Cid    Telia DataCenter -tilaratkaisu
#     View Open Quote
#     Verify that warning banner is not displayed on opportunity page   ${oppo_name1}



Sync_quote
    [Tags]  BQA-12587
    Go To Salesforce and Login into Lightning
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go to Entity   ${oppo_name}
    clickingoncpq   ${oppo_name}
    search products  Telia Cid
    Adding Products  Telia Cid
    updating setting Telia Cid
    UpdateAndAddSalesType  Telia Cid
    #OpenQuoteButtonPage_release
    Go to Entity   ${oppo_name}
    reload page
    clickingoncpq  ${oppo_name}
    create another quote with same opportunity
    Sync quote


Lightning_Customership Contract
     [Tags]  BQA-12655
     Go To Salesforce and Login into Admin User
     #Login To Salesforce Lightning  ${SALES_ADMIN_APP_USER}  ${PASSWORD-SALESADMIN}
     Go To Entity    ${CONTRACT_ACCOUNT}
     #${contact_name}   run keyword    Create New Contact for Account
     #Delete all entities from Accounts Related tab   Contracts
     Create contract Agreement  Customership
     #Create contract Agreement  Sevice

Lightning_Service Contract
    [Tags]  BQA-12666
    Go To Salesforce and Login into Admin User
    Go To Entity    ${CONTRACT_ACCOUNT}
    Delete all entities from Accounts Related tab   Contracts
    Create contract Agreement  Customership
    ${Contract_Number}  set variable  ${Customer_contract}
    Create contract Agreement  Service  ${Contract_Number}


Manual Credit Check Enquiry with postive
    [Tags]  BQA-12600
    Go To Salesforce and Login into Lightning
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
    Login to Salesforce as DigiSales Lightning User  ${SYSTEM_ADMIN_USER}   ${SYSTEM_ADMIN_PWD}
    swithchtouser  Credit Control User
    Activate The Manual Credit enquiry with positive   ${value}   Positive
    Login to Salesforce as DigiSales Lightning User
    ScrollUntillFound  //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Positive.")]
    page should contain element    //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Positive.")]
    Search Salesforce    ${quote_number}
    Select Entity    ${oppo_name}    ${EMPTY}
    credit score status after approval
    Check the credit score result of the case with postive
#    SearchAndSelectBillingAccount   ${TEST_CONTACT}
#    select order contacts- HDC  ${contact_name}
#    RequestActionDate
#    SelectOwnerAccountInfo    ${billing_acc_name}
    clickOnSubmitOrder

Manual Credit Check Enquiry with postive and condition
    [Tags]  BQA-12674
    Go To Salesforce and Login into Lightning
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
    Login to Salesforce as DigiSales Lightning User  ${SYSTEM_ADMIN_USER}   ${SYSTEM_ADMIN_PWD}
    swithchtouser  Credit Control User
    Activate The Manual Credit enquiry with positive with condition   ${value}  Positive with Conditions
    Login to Salesforce as DigiSales Lightning User
    ScrollUntillFound  //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Positive with Conditions.")]
    page should contain element    //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Positive with Conditions.")]
    Search Salesforce    ${quote_number}
    Select Entity   ${oppo_name}   ${EMPTY}
    credit score status after approval
    Check the credit score result of the case with Positive with Conditions
    clickOnSubmitOrder

Manual Credit Check Enquiry with Negative
    [Tags]  BQA-12673
    Go To Salesforce and Login into Lightning
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
    Login to Salesforce as DigiSales Lightning User  ${SYSTEM_ADMIN_USER}   ${SYSTEM_ADMIN_PWD}
    swithchtouser  Credit Control User
    Activate The Manual Credit enquiry with Negative    ${value}   Negative
    Login to Salesforce as DigiSales Lightning User
    ScrollUntillFound  //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Negative.")]
    page should contain element    //span[contains(text()," Your Manual Credit Inquiry Case ${value} has been completed. Final decision: Negative.")]
    Search Salesforce    ${quote_number}
    Select Entity    ${oppo_name}    ${EMPTY}
    Check the credit score result of the Negative cases

Manual Credit Check Enquiry with No Result
    [Tags]  BQA-12675
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_CONTACT}
    ${contact_name}    run keyword    Create New Contact for Account
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    ${billing_acc_name}    run keyword    CreateABillingAccount  ${TEST_CONTACT}
    Go to Entity   ${oppo_name}
    clickingoncpq   ${oppo_name}
    search products    ${B2bproductfyr1}
    Adding Products for Telia Sopiva Pro N    ${B2bproductfyr1}
    Adding Products for Telia Sopiva Pro N child products  ${B2bproductfyr2}   ${B2bproductfyr3}
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    wait until page contains element    //span[text()='Next']/..    100s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    unselect frame
    UpdateAndAddSalesType for B2b products     ${B2bproductfyr1}   ${B2bproductfyr2}


Pricing Escalation
    [Tags]   BQA-11368
    Login to Salesforce as DigiSales Lightning User  ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
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
    Login to Salesforce as DigiSales Lightning User ${SYSTEM_ADMIN_USER}   ${SYSTEM_ADMIN_PWD}
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    #${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    Test RT
    logoutAsUser    ${SYSTEM_ADMIN_USER}
    Login to Salesforce as DigiSales Lightning User vLocUpgSandbox   ${PM_User}  ${PM_PW}
    Go To Entity  ${oppo_name}
    Create Pricing Request
    ${Case_number}   run keyword   Create Pricing Escalation
    Submit for approval  Pricing Escalation
    Case Approval By Endorser   ${Case_number}  ${oppo_name}
    Case Rejection By Approver   ${Case_number}  ${oppo_name}
    #Verify case Status by PM  ${Case_number}  Rejected    --- Not notified. Raised Bug
    Verify case Status by Endorser  ${Case_number}   Rejected
    Case Not visible to Normal User  ${Case_number}

Test file handling
    [Tags]  Test_file
    Wait Until element is visible   id=username     30s
    Input Text  id=username   ${SALES_ADMIN_APP_USER}
    Input Text   id =password  ${PASSWORD-SALESADMIN}
    Click Element  id=Login
    DDM Request Handling

Investment Process - B2B
    [Tags]   BQA-11387
    Login to Salesforce as DigiSales Lightning User     ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go To Entity    Aacon Oy
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    #${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity  ${oppo_name}
    ${case_number}  run keyword    Create Investment Case  B2B
    #Submit created Investment    ${oppo_name}   ${case_number}
    PM details  ${oppo_name}    ${case_number}    B2B
    #PM details    ${oppo_name}   ${case_number}  B2B
    Case Approval By Endorser   ${case_number}   ${oppo_name}
    Case Approval By Approver   ${case_number}   ${oppo_name}
    Check Case Status  ${case_number}  B2B



Investment Process - B2O
    [Tags]   BQA-11395
    Login to Salesforce as DigiSales Lightning User  ${B2O_DIGISALES_LIGHT_USER}  ${B2O_DIGISALES_LIGHT_PASSWORD}
    Go To Entity    ${B2O Account}
    ${oppo_name}   run keyword  CreateAOppoFromAccount_HDC  Test RT
    Go To Entity    ${oppo_name}
    ${case_number}  run keyword    Create Investment Case   B2O
    PM details    ${oppo_name}   ${case_number}  B2O
    Case Approval By Approver   ${Case_number}  ${oppo_name}
    Check Case Status  ${Case_number}  B2O

Manual Availability - B2O

    [Tags]   BQA-11380  Test
    Login to Salesforce as DigiSales Lightning User   ${B2O_DIGISALES_LIGHT_USER}  ${B2O_DIGISALES_LIGHT_PASSWORD}
    Go To Entity    ${B2O Account}
    Go To Entity    ${B2O Account}
    ${oppo_name}   run keyword  CreateAOppoFromAccount_HDC  Test RT
    Go To Entity    ${oppo_name}
    Click Manual Availabilty
    Fill Request Form
    Verify Opportunity

Check of Customership Contract
    [Tags]   BQA-11427
    set Test variable    ${account}   Telia Communication Oy
    Login To Salesforce As DigiSales Lightning User   ${SYSTEM_ADMIN_USER}   ${SYSTEM_ADMIN_PWD}
    Go To Entity    ${account}
    Delete all existing contracts from Accounts Related tab
    #${contact}    run keyword    CreateAContactFromAccount_HDC
    #Set Test Variable   ${contact_name}   ${contact}
    Set Test Variable   ${contact_name}   Testing Contact_ 20190924-174806
    ${oppo_name}   run keyword  CreateAOppoFromAccount_HDC  ${contact_name}
    #Set Test Variable   ${oppo_name}    Test Robot Order_ 20191107-170816
    Verify warning banner on oppo page   ${oppo_name}
    Go to account from oppo page
    Create contract Agreement  Customership
    ${Contract_A_Number}  set variable  ${Customer_contract}
    #Log to console   Contract A is ${Contract_A_Number}
    Go To Entity    ${account}
    ${oppo_name}   run keyword  CreateAOppoFromAccount_HDC  ${contact_name}
    Verify that warning banner is not displayed on opportunity page  ${oppo_name}
    Verify Populated Cutomership Contract   ${Contract_A_Number}
    Go to account from oppo page
    Create contract Agreement  Service  ${Contract_A_Number}
    Go To Entity    ${account}
    Create contract Agreement  Customership
    ${Contract_B_Number}   set variable  ${Customer_contract}
    #Log to console   Contract B is ${Contract_B_Number}
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



One Order - B2B Colocation and Change Order
    [Tags]  BQA-11521
    Login to Salesforce Lightning   ${SALES_ADMIN_APP_USER}  ${PASSWORD-SALESADMIN}
    Go to Entity    ${vLocUpg_TEST_ACCOUNT}
    Delete all assets
    logoutAsUser   ${SALES_ADMIN_APP_USER}
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    HDC Order
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Login to Salesforce Lightning   ${SYSTEM_ADMIN_USER}  ${SYSTEM_ADMIN_PWD}
    DDM Request Handling
    #Switch between windows    0
    #logoutAsUser   ${SYSTEM_ADMIN_USER}
    Open Browser And Go To Login Page
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go to   ${url}
    Validate Billing system response
    Log to console   Entering change Order
    Change Order
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Login to Salesforce Lightning  ${SYSTEM_ADMIN_USER}  ${SYSTEM_ADMIN_PWD}
    DDM Request Handling
    Open Browser And Go To Login Page
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go to   ${url}
    Validate Billing system response
    Capture Page Screenshot



One Order- B2O Colocation and change order
    [Tags]  BQA-11523

    Login to Salesforce Lightning   ${SALES_ADMIN_APP_USER}  ${PASSWORD-SALESADMIN}
    Go to Entity   ${vLocUpg_TEST_ACCOUNT}
    Delete all assets
    logoutAsUser   ${SALES_ADMIN_APP_USER}
    Login to Salesforce as DigiSales Lightning User   ${B2O_DIGISALES_LIGHT_USER}   ${B2O_DIGISALES_LIGHT_PASSWORD}
    HDC Order
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Login to Salesforce Lightning   ${SYSTEM_ADMIN_USER}  ${SYSTEM_ADMIN_PWD}
    DDM Request Handling
    Switch between windows    0
    logoutAsUser   ${SYSTEM_ADMIN_USER}
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go to   ${url}
    Validate Billing system response
    Change Order
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Login to Salesforce Lightning  ${SYSTEM_ADMIN_USER}  ${SYSTEM_ADMIN_PWD}
    DDM Request Handling
    Switch between windows    0
    logoutAsUser  ${SYSTEM_ADMIN_USER}
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go to   ${url}
    Validate Billing system response
    Capture Page Screenshot
    Go to Entity    ${vLocUpg_TEST_ACCOUNT}
    Terminate asset     Telia Colocation


One Order- B2B Colocation, Case management product, Modeled Case management product
    [Tags]  BQA-11522
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact}.this is name
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
    ${billing_acc_name}    run keyword    CreateABillingAccount   ${vLocUpg_TEST_ACCOUNT}
    log to console    ${billing_acc_name}.this is billing account name
    Go To Entity    ${oppo_name}
    ChangeThePriceList      B2B
    ClickingOnCPQ    ${oppo_name}
    Adding Telia Colocation    Telia Colocation
    Updating Setting Telia Colocation without Next
    Adding Arkkitehti   Arkkitehti
    Adding Telia Cid    Telia Cid
    Updating Setting Telia Cid
    UpdateAndAddSalesType for 3 products and check contract    Telia Colocation   Arkkitehti  Telia Cid
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount   ${vLocUpg_TEST_ACCOUNT}
    select order contacts- HDC  ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    ${billing_acc_name}
    clickOnSubmitOrder
    ValidateTheOrchestrationPlan
    Go to   ${url}
    Validate Call case Management status
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Login to Salesforce Lightning   ${SYSTEM_ADMIN_USER}  ${SYSTEM_ADMIN_PWD}
    DDM Request Handling
    Open Browser And Go To Login Page
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go to   ${url}
    Validate Billing system response
    Validate Order status
    Validate Billing account

Testing

    #Wait Until element is visible   id=username     30s
    #Input Text  id=username   ${B2B_DIGISALES_LIGHT_USER}
    #Input Text   id =password  ${Password_merge}
    #Click Element  id=Login
    set test variable   ${order_no}  319123015378
    set test variable   ${url}   https://telia-fi--rel.lightning.force.com/lightning/r/vlocity_cmt__OrchestrationPlan__c/a1w1w000000EKLDAA4/view
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go to   ${url}
    Validate Billing system response
    Validate Order status

SAP Order


    [Tags]  BQA-12512
    [Documentation]     This script is designed for Digita Oy. If account is changed, the corresponding group id has to be changed for the script to work. SAP contract id hardcoded as it is getting failed nowadys.
    set test variable   ${Account}    Digita Oy
    #Login to Salesforce as DigiSales Lightning User   ${B2O_DIGISALES_LIGHT_USER}   ${B2O_DIGISALES_LIGHT_PASSWORD}
    Login to Salesforce as DigiSales Lightning User   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go To Entity    ${Account}
    ${contact}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact}.this is name
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
    ${billing_acc_name}    run keyword    CreateABillingAccount     ${Account}
    log to console    ${billing_acc_name}.this is billing account name
    Go To Entity    ${oppo_name}
    ChangeThePriceList      B2O
    ClickingOnCPQ    ${oppo_name}
    Adding Vula    VULA
    Update Setting Vula   VULA
    UpdatePageNextButton
    View Open Quote
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    Close and submit
    Enter Group id and submit
    Reload page
    ValidateSapCallout




Lead_Creation
    [Documentation]    This TC creates lead from the Web-to-lead form and validate the same in Claudia leads tab,
    ...    convert it to opportunity
    [Tags]    SreeramE2E    Lightning
    ${lead_file}    run keyword    open file from resources    lead_Release.html
    go to    file:///${lead_file}
    ${fname}    generate random string    3    [NUMBERS]F
    ${lname}    generate random string    3    [NUMBERS]L
    ${mobile}    create unique mobile number
    ${title}    generate random string    5    [NUMBERS]abcdefghi
    ${desc}    generate random string    10    [NUMBERS]abcdef
    sleep    5s
    enter random data to lead web form    ${fname}    ${lname}    ${lead_email}    ${mobile}    ${title}    ${desc}
    go to    ${LOGIN_PAGE_APP}
    Login to Salesforce as DigiSales Lightning User
    #login to salesforce as digisales lightning user vlocupgsandbox
    go to entity    ${lead_account_name}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    open_todays_leads
    force click element    //a[@title='${fname} ${lname}']
    wait until page contains element    //span[text()='${fname} ${lname}']    30s
    validate_Created_Lead    ${fname}    ${lname}    ${lead_email}    ${mobile}    ${title}    ${desc}
    Edit_and_Select_Contact    ${contact_name}
    scroll page to location    0    0
    click element    ${convert_lead_btn}
    wait until page contains element    ${converting_lead_header}    30s
    input text    ${lead_name_input}    Lead_${fname}_${lname}
    input text    ${lead_desc_textarea}    ${desc}
    ${close_date}    get date from future    10
    sleep    3s
    input text    ${lead_close_date}    ${close_date}
    click element    ${converting_lead_dialogue}
    click element    ${converting_lead_overlay}
    wait until page contains element    ${lead_converted_h4}    60s
    wait until page contains element    //span[text()='Opportunity']//ancestor::div[@class="slds-box"]//a[text()='Lead_${fname}_${lname}']    30s
    click element    //span[text()='Opportunity']//ancestor::div[@class="slds-box"]//a[text()='Lead_${fname}_${lname}']
    wait until page contains element    //span[text()='Opportunity ID']    30s
    scrolluntillfound    //span[text()='Opportunity Record Type']/../..//span[text()='Opportunity']
    page should contain element    //span[text()='Opportunity Record Type']/../..//span[text()='Opportunity']


Validate Main User contact for DNS
   [Tags]  BQA-13122
  [Documentation]  This script is designed to validate the main user contact being created for DNS product
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    ${contact}    run keyword    CreateAContactFromAccount_HDC
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    ${billing_acc_name}    run keyword    CreateABillingAccount     ${LIGHTNING_TEST_ACCOUNT}
    Go To Entity    ${oppo_name}
    ClickingOnCPQ     ${oppo_name}
    search products   Telia Domain Name Service
    Adding Products   Telia Domain Name Service
    updating setting Telia Domain Name space  Telia Domain Name Service
    UpdateAndAddSalesType  Telia Domain Name Service
    View Open Quote
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount   ${LIGHTNING_TEST_ACCOUNT}
    SelectingTechnicalContactforTeliaDomainNameService     ${contact}
    RequestActionDate
#   SelectOwnerAccountInfo   ${billing_acc_name}
    SelectOwnerAccountInfo   Billing Telia Communication Oy
    clickOnSubmitOrder
    ${Ordernumber}  run keyword  getOrderStatusAfterSubmitting
    log to console   ${Ordernumber}
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Go To Salesforce and Login into Lightning       System Admin
    Validate Main user in order product    ${Ordernumber}   Telia Domain Name Service
    ${first_name}=   Fetch From Left  ${contact}  ${SPACE}
    ${second_name}=   Fetch From Right   ${contact}   ${SPACE}
    Validate ServiceAdministrator in Account contact role    ${first_name}     ${second_name}


DNS - Asset Verification
    [Tags]  BQA-12672
    [Documentation]  This script is designed to validate Technical Contact Information on Asset for DNS product by B2B user
    Login to Salesforce Lightning   ${SALES_ADMIN_APP_USER}  ${PASSWORD-SALESADMIN}
    Go to Entity  ${LIGHTNING_TEST_ACCOUNT}
    Delete all assets
    logoutAsUser   ${SALES_ADMIN_APP_USER}
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    ${contact}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact}.this is name
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
#    ${billing_acc_name}    run keyword    CreateABillingAccount     $${B2O Account}
#    log to console    ${billing_acc_name}.this is billing account name
    Go To Entity    ${oppo_name}
    ClickingOnCPQ    ${oppo_name}
    search products   ${pdtname}
    Adding Products   ${pdtname}
    updating setting Telia Domain Name space
    UpdateAndAddSalesType  ${pdtname}
    View Open Quote
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    sleep  40s
    SearchAndSelectBillingAccount   ${LIGHTNING_TEST_ACCOUNT}
    SelectingTechnicalContactforTeliaDomainNameService  ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo   ${billing_acc_name_digi1}
    clickOnSubmitOrder
    ${Ordernumber}  run keyword  getOrderStatusAfterSubmitting
    logoutAsUser   ${B2B_DIGISALES_LIGHT_USER}
    Go To Salesforce and Login into Lightning       System Admin
    Go To Entity   ${Ordernumber}
    ${SubscriptionID}   run keyword  FetchfromOrderproduct  ${Ordernumber}
    log to console    ${SubscriptionID}.is a subscription ID
    Validate technical contact in the asset history page using subscription as  ${SubscriptionID}  ${contact}



One Order- B2O Colocation and E2E B2O product
    [Tags]  BQA-11525
    [Documentation]  This script is designed to  validate the functional flow of  the add two products added and update the  order status correctly by using  B20 user
    set test variable   ${Account}    Digita Oy
    Login to Salesforce Lightning   ${SALES_ADMIN_APP_USER}  ${PASSWORD-SALESADMIN}
    Go to Entity  ${Account}
    Delete all assets
    logoutAsUser   ${SALES_ADMIN_APP_USER}
    Go To Salesforce and Login into Lightning  B2O User
    sleep  40s
    Go To Entity    ${Account}
    ${contact}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact}.this is name
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
#    ${billing_acc_name}    run keyword    CreateABillingAccount   ${vLocUpg_TEST_ACCOUNT}
#    log to console    ${billing_acc_name}.this is billing account name
    Go To Entity    ${oppo_name}
    ChangeThePriceList      B2O
    ClickingOnCPQ    ${oppo_name}
    sleep   10s
    Adding Vula    VULA
    Update Setting Vula without Next   VULA
    Adding Telia Colocation    Telia Colocation
    Updating Setting Telia Colocation
    UpdateAndAddSalesTypeB2O   Telia Colocation
    View Open Quote
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount   ${Account}
    select order contacts- HDC  ${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo   ${billing_acc_name_digi1}
    Submit Order Button
    Reload page
    ${order_number}   run keyword    ValidateTheOrchestrationPlan
    logoutAsUser   ${B2O_DIGISALES_LIGHT_USER}
    Login to Salesforce Lightning   ${SYSTEM_ADMIN_USER}  ${SYSTEM_ADMIN_PWD}
    DDM Request Handling   ${order_number}
    Open Browser And Go To Login Page
    Go To Salesforce and Login into Lightning  B2O User
    Go To Entity    ${order_number}
    Reload page
    ValidateSapCallout
    Validate Billing system response


Validate FYR values in Oppo page created through SVE
    [Documentation]  This script is designed to  validate and verify the FYR values in Opportunity page  based on SalesType selected for the multiple products added SVE by using  B2B user
    [Tags]  BQA-13171
     Login to Salesforce as B2B DigiSales   ${B2B_DIGISALES_LIGHT_USER}  ${Password_merge}
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    ${contact}    run keyword    CreateAContactFromAccount_HDC
    Log to console    ${contact}.this is name
    Set test variable  ${contact_name}   ${contact}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
    Go To Entity   ${oppo_name}
    clickingOnSolutionValueEstimate     ${oppo_name}
    sleep  10s
    ${fyr_total}  Add multiple products in SVE  @{LIST}
    reload page
    sleep  10s
    ${new}  ${ren}  ${frame}   validateproductsbasedonsalestype  @{LIST}
    reload page
    sleep  10s
    Validating FYR values in Opportunity Header   ${fyr_total}  ${new}  ${ren}  ${frame}






