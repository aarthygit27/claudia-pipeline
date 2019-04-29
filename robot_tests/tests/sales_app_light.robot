*** Settings ***
Documentation     Suite description
Test Setup        Open Browser And Go To Login Page
#Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot

*** Test Cases ***
Add new contact - Master
    [Documentation]    Go to SalesForce Lightning. Create new master contact and validate the details.
    [Tags]    BQA-8396    Lightning
    Go To Salesforce and Login into Lightning
    Create New Master Contact
    Validate Master Contact Details

Add new contact - Non person
    [Documentation]    Go to SalesForce Lightning. Create new non master contact and validate the details.
    [Tags]    BQA-8395    Lightning
    Go To Salesforce and Login into Lightning
    Create New NP Contact
    Validate NP Contact Details

Add new contact from Accounts Page
    [Documentation]    Go to SalesForce Lightning. Create new contact for account and validate the details.
    [Tags]    BQA-8394    Lightning
    Go To Salesforce and Login into Lightning
    Go to Entity    ${AP_ACCOUNT_NAME}
    Create New Contact for Account
    Validate AP Contact Details

Create opportunity from Account
    [Documentation]    Create new opportunity and validate in accounts related tab search in salesforce
    ...    and then in My all open Opportunities section.
    [Tags]    BQA-8393    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Verify That Opportunity is Found From My All Open Opportunities

Negative - Validate Opportunity cannot be created for Passive account
    [Documentation]    Select the Passive account and validate that the Opportunity creation
    ...    throws an error
    [Tags]    BQA-8457    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${PASSIVE_TEST_ACCOUNT}
    Create New Opportunity For Customer    PASSIVEACCOUNT

Negative - Validate Opportunity cannot be created for Group account
    [Documentation]    Select the Group account and validate that the new opportunity button
    ...    is not displayed
    [Tags]    BQA-8464    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${GROUP_TEST_ACCOUNT}
    Validate Opportunity cannot be created    GROUPACCOUNT

Closing active opportunity as cancelled
    [Documentation]     Create new opportunity and cancel the opportunity and validate that
    ...    it cannot be updated further
    [Tags]    BQA-8465    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Cancel Opportunity and Validate    ${OPPORTUNITY_NAME}    Cancelled

Closing active opportunity as lost
    [Documentation]    Create new opportunity and close the opportunity as lost and validate that
    ...    it cannot be updated further
    [Tags]    BQA-8466    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Cancel Opportunity and Validate    ${OPPORTUNITY_NAME}    Closed Lost

Check Attributes/Business Account are named right in Sales Force UI
    [Documentation]    To Verify the Business Account Attributes Are Named Right
    [Tags]    BQA-8484    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    Verify That Business Account Attributes Are Named Right

Check Attributes/Contact Person are named right
    [Documentation]    To Verify the Contact Person Attributes and values Are Named Right after adding the contact
    [Tags]    BQA-8483    Lightning
    Go To Salesforce and Login into Lightning
    Go to Contacts
    Create New Master Contact With All Details
    Validate Master Contact Details In Contact Page    ${CONTACT_DETAILS}
    Validate That Contact Person Attributes Are Named Right

Lightning: Create Meeting from Account
    [Documentation]    To create meeting for a account
    [Tags]    BQA-7948    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    Create New Contact for Account
    Go to Entity    ${TEST_ACCOUNT_CONTACT}
    Create a Meeting

Lightning: Create Call from Account
    [Documentation]    To create call for a account
    [Tags]    BQA-8085    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    Create New Contact for Account
    Go to Entity    ${TEST_ACCOUNT_CONTACT}
    Create a Call

Lightning: Create Task from Account
    [Documentation]    To create task for a account
    [Tags]    BQA-8463    Lightning
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    Create New Contact for Account
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
    Login to Salesforce as DigiSales Lightning User    ${SALES_ADMIN_APP_USER}    ${PASSWORD-SALESADMIN}
    Go To Entity    ${GROUP_TEST_ACCOUNT}
    sleep    10s
    #Scroll Page To Location    0    1407.75
    Wait Until Element Is Visible    //div[@class='ownerName']//a    30s
    ${original}=    Get Text    //div[@class='ownerName']//a
    Click Element    //div[@title='Change Owner']
    sleep    8s
    Element Should Be Enabled    //input[@title='Search People']
    Wait Until Page Contains Element    //input[@title='Search People']
    Input Text    //input[@title='Search People']    ${original}
    Select from Autopopulate List    //input[@title='Search People']    ${original}
    Click Button    //button[@title='Submit']
    sleep    10s
    ${new_owner}=    Get Text    //div[@class='ownerName']//a
    Should Be Equal As Strings    ${original}    ${new_owner}

Remove Account owner
    [Tags]    BQA-8524    Lightning
    Login to Salesforce as DigiSales Lightning User    ${SALES_ADMIN_APP_USER}    ${PASSWORD-SALESADMIN}
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
    [Documentation]    Change Business Account owner by logging into Digisales Admin User
    [Tags]    BQA-8525    Lightning
    Login to Salesforce as DigiSales Admin user
    Go to Entity    Aacon Oy
    Change Account Owner

Lightning: Sales admin Change Account owner for group account
    [Documentation]    Change Group Account owner by logging into Digisales Admin User
    [Tags]    BQA-8526    Lightning
    Login to Salesforce as DigiSales Admin user
    Go to Entity    Aacon Oy
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



Create HDC Order
    [Tags]    BQA-HDCOrder    LightningE2E
    Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
    #go to entity    319021811502
    #sleep    10s
    #${order_number}    run keyword    getOrderStatusAfterSubmitting
    #ValidateTheOrchestrationPlan
    #go to entity    ${order_number}
    #openAssetviaOppoProductRelated
    #sleep    300s
    #click element    //span[@class='title' and text()='Assets']
    #sleep    3s
    #click element    //div[@data-aura-class="forceOutputLookupWithPreview"]/a[text()='Telia Colocation']
    ##${business_acc_name}    run keyword    CreateBusinessAccount
    ##log to console    ${business_acc_name}.this is business account
    #Execute javascript    document.body.style.transform = 'scale(0.8)';
    #document.body.style.zoom="50%"
    #Go To Entity    ${business_acc_name}
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact_name}.this is name
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
    ${billing_acc_name}    run keyword    CreateABillingAccount
    log to console    ${billing_acc_name}.this is billing account name
    Go To Entity    ${oppo_name}
    ChangeThePriceBookToHDC    HDC Pricebook B2B
    ClickingOnCPQ    ${oppo_name}
    Adding Telia Colocation    Telia Colocation
    Updating Setting Telia Colocation
    UpdateAndAddSalesType    Telia Colocation
    OpenQuoteButtonPage
    #CreditScoreApproving
    #go to entity    Oppo_ 20190217-115637    Quotes
    sleep    40s
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount
    SelectingTechnicalContact    ${contact_name}
    #${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    ${billing_acc_name}
    #${billing_acc_name}
    ReviewPage
    ValidateTheOrchestrationPlan

Create B2B Order
    [Tags]    BQA-B2BOrder    LightningE2E
    #Login to Salesforce as DigiSales Lightning User
    Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
    #GO TO ENTITY    Oppo_ 20190217-191125
    #SLEEP    60S
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    #${sc_name}    run keyword    createAAgreement    Service Contract
    #${billing_acc_name}    run keyword    CreateABillingAccount
    #capture page screenshot
    #Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    #capture page screenshot
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact_name}.this is name
    sleep    10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity    ${oppo_name}
    ChangeThePriceBookToHDC    B2B Pricebook
    ##B2O pricebook
    ClickingOnCPQ    ${oppo_name}
    AddProductToCart    Alerta projektointi
    ##B2O Other Services
    Run Keyword If    '${r}'== 'b2b'    run keyword    UpdateAndAddSalesType    Alerta projektointi
    Run keyword If    '${r}'== 'b2o'    run keyword    UpdateAndAddSalesTypeB2O    B2O Other Services
    #sleep    600s
    ##B2O Other Services
    OpenQuoteButtonPage
    #CreditScoreApproving
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    OrderNextStepsPage
    getOrderStatusBeforeSubmitting
    sleep    60s
    clickOnSubmitOrder
    getOrderStatusAfterSubmitting

Create B2O Order
    [Tags]    BQA-B2OOrder    LightningE2E
    #Login to Salesforce as DigiSales Lightning User
    Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact_name}.this is name
    sleep    10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity    ${oppo_name}
    ChangeThePriceBookToHDC    B2O pricebook
    ##B2B Pricebook
    ClickingOnCPQ    ${oppo_name}
    AddProductToCart    B2O Other Services
    ##Alerta projektointi
    Run Keyword If    '${r}'== 'b2b'    run keyword    UpdateAndAddSalesType    Alerta projektointi
    Run keyword If    '${p}'== 'b2o'    run keyword    UpdateAndAddSalesTypeB2O    B2O Other Services
    #sleep    600s
    ##B2O Other Services
    OpenQuoteButtonPage
    #CreditScoreApproving
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    OrderNextStepsPage
    getOrderStatusBeforeSubmitting
    sleep    60s
    clickOnSubmitOrder
    getOrderStatusAfterSubmitting

createAOppoViaSVE
    [Tags]    BQA-8798    LightningE2E
    Login to Salesforce as DigiSales Lightning User vLocUpgSandbox
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact_name}.this is name
    sleep    10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
    go to entity    ${oppo_name}
    clickingOnSolutionValueEstimate    ${oppo_name}
    ${fyr}    run keyword    addProductsViaSVE    ${product_name}
    Go To Entity    ${oppo_name}
    validateCreatedOppoForFYR    ${fyr}

Closing Opportunity as Won with FYR below 3 KEUR
    [Tags]    BQA-8794    new
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
    [Tags]    BQA-8795    new
    ${Edit_continuation}=    Set Variable    //button[@title='Edit Create Continuation Sales Opportunity?']
    Closing Opportunity as Won with FYR    200    Yes
    sleep    10s
    Execute Javascript    window.scrollTo(0,125)
    Click Element    ${Edit_continuation}
    Execute Javascript    window.scrollTo(0,125)
    sleep    3s
    Select option from Dropdown    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Create Continuation Sales Opportunity?')]/../../div/div/div/div/a    No
    click element    //span[contains(text(),'Save')]
    sleep    5s
    Capture Page Screenshot

Closing Opportunity as Won with FYR greater than 100KEUR
    [Tags]    BQA-8796    new
    Closing Opportunity as Won with FYR    300    Yes

E2E opportunity process incl. modelled and unmodelled products & Quote & SA & Order
    [Tags]    BQA-9121    new
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    Chetan
    #${oppo_name}    set variable    Oppo_ 20190301-113538
    sleep    5s
    Go To Entity    ${oppo_name}
    sleep    5s
    Editing Win prob    no
    Adding partner and competitor
    Capture Page Screenshot
    sleep    10s
    #clickingOnSolutionValueEstimate    ${oppo_name}
    ClickingOnCPQ    ${oppo_name}
    search products    Telia Yritysinternet Plus
    Adding Yritysinternet Plus
    search products    DataNet Multi
    Adding DataNet Multi
    UpdateAndAddSalesType for 2 products    Telia Yritysinternet Plus    DataNet Multi
    OpenQuoteButtonPage_release
    sleep    10s
    ${quote_number}    Run Keyword    preview and submit quote
    Opportunity status
    Create contract    ${TEST_ACCOUNT_CONTACT}    ${oppo_name}
    Create Order from quote    ${quote_number}    ${oppo_name}
    View order and send summary
    sleep    10s
    Go to Entity    ${oppo_name}
    Closing the opportunity    No

Lightning: Opportunity: Products used for reporting only must not be visible on Quote & Order
    [Tags]    BQA-9122    new
    ${next_button}=    set variable    //span[contains(text(),'Next')]
    @{products}    Set Variable    Telia Ulkoistettu asiakaspalvelu    Telia Neuvottelupalvelut    Telia Palvelunumero    Telia Yritysliittymä    Telia Laskutuspalvelu
    ...    Telia Sopiva Enterprise    Telia Ulkoistettu asiakaspalvelu - Lisäkirjaus    Telia Neuvottelupalvelut - Lisäkirjaus    Telia Palvelunumero - Lisäkirjaus    Telia Yritysliittymä - Lisäkirjaus    Telia Laskutuspalvelu - Lisäkirjaus
    ...    Telia Sopiva Enterprise - Lisäkirjaus    Sopiva Pro-migraatio    Sovelluskauppa 3rd Party Apps    VIP:n käytössä olevat Cid-numerot    Ohjaus Telia Numeropalveluun    Online Asiantuntijapalvelut
    ${Submit Order}    set variable    //div[@title='Submit Order']
    Go To Salesforce and Login into Lightning
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    Chetan
    #${oppo_name}    set variable    Oppo_ 20190301-113538
    sleep    5s
    Go To Entity    ${oppo_name}
    sleep    5s
    ClickingOnCPQ    ${oppo_name}
    sleep    10s
    Searching and adding multiple products    @{products}
    Updating sales type multiple products    @{products}
    OpenQuoteButtonPage_release
    preview and submit quote
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    OrderNextStepsPage
    Preview order summary and verify order    @{products}
    go back
    Wait Until Element Is Visible    ${Submit Order}
    click element    ${Submit Order}
    sleep    60s
    Capture Page Screenshot
    ${multibella_GuiID}    Get Multibella id
    verifying Multibella order case    ${multibella_GuiID}    @{products}

HDC - Complete Sales Process: UAT/Sanity Regression
    [Tags]    BQA-8560
    ${win_prob_edit}=    Set Variable    //span[contains(text(),'Win Probability %')]/../../button
    Go To Salesforce and Login into Lightning
    #Go To Entity    ${TEST_ACCOUNT_CONTACT}
    #${billing_acc_name}    run keyword    CreateABillingAccount
    #log to console    ${billing_acc_name}.this is billing account name
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    sleep    10s
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    log to console    ${contact_name}.this is name
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
    Go To Entity    ${oppo_name}
    sleep    5s
    wait until element is visible    ${win_prob_edit}    20s
    click element    ${win_prob_edit}
    Adding partner and competitor
    ChangeThePriceBookToHDC    HDC Pricebook B2B

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
