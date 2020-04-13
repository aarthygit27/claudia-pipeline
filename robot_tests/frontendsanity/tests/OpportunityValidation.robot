*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Login.robot
Resource          ../../frontendsanity/resources/SolutionValueEstimate.robot
Resource          ../../frontendsanity/resources/Contact.robot
Resource          ../../frontendsanity/resources/Opportunity.robot
Resource          ../../frontendsanity/resources/Quote.robot
Resource          ../../frontendsanity/resources/Variables.robot


*** Test Cases ***

Create opportunity from Account
    [Documentation]    Create new opportunity and validate in accounts related tab search in salesforce
    ...    and then in My all open Opportunities section.
    [Tags]    BQA-8393    AUTOLIGHTNING        OpportunityValidation
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Verify That Opportunity is Found From My All Open Opportunities

Negative - Validate Opportunity cannot be created for Passive account
    [Documentation]    Select the Passive account and validate that the Opportunity creation
    ...    throws an error
    [Tags]    BQA-8457    AUTOLIGHTNING       OpportunityValidation
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${PASSIVE_TEST_ACCOUNT}
    Create New Opportunity For Customer    PASSIVEACCOUNT

Negative - Validate Opportunity cannot be created for Group account
    [Documentation]    Select the Group account and validate that the new opportunity button
    ...    is not displayed
    [Tags]    BQA-8464    AUTOLIGHTNING         OpportunityValidation
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${GROUP_TEST_ACCOUNT}
    Validate Opportunity cannot be created    GROUPACCOUNT

Closing active opportunity as cancelled
    [Documentation]    Create new opportunity and cancel the opportunity and validate that
    ...    it cannot be updated further
    [Tags]    BQA-8465    AUTOLIGHTNING         OpportunityValidation
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Cancel Opportunity and Validate     ${OPPORTUNITY_NAME}     Cancelled


Closing active opportunity as lost
    [Documentation]    Create new opportunity and close the opportunity as lost and validate that
    ...    it cannot be updated further
    [Tags]    BQA-8466    AUTOLIGHTNING         OpportunityValidation
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${LIGHTNING_TEST_ACCOUNT}
    Create New Opportunity For Customer    ACTIVEACCOUNT
    Cancel Opportunity and Validate    ${OPPORTUNITY_NAME}    Closed Lost

Mobile coverage request redirects to Tellu
    [Documentation]     Check that mobile coverage request button redirects to Tellu-system log in.
    [Tags]     BQA-10955      AUTOLIGHTNING         OpportunityValidation
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go to Entity  ${LIGHTNING_TEST_ACCOUNT}
    Navigate to view  Opportunities
    Wait element to load and click  ${test_opportunity}
    ${status}=  Run keyword and return status    Wait element to load and click   ${mobilecoveragerequest}
    Run keyword if      ${status} == False    Force click element   ${showmoreactions}
    Run keyword if      ${status} == False    Click element    ${mobilecoveragerequest}
    Sleep   10s
    Validate that Tellu login page opens

Manual availability check redirects to Tellu
    [Documentation]     Check that manual availability check button from the opportunity page redirects to Tellu-system login.
    [Tags]     BQA-10954     AUTOLIGHTNING          OpportunityValidation
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go to Entity  ${LIGHTNING_TEST_ACCOUNT}
    Navigate to view  Opportunities
    Wait element to load and click  ${test_opportunity}
    Wait element to load and click    ${manualavailabilitycheck}
    Validate that Tellu login page opens

Investment redirects to Tellu
    [Documentation]     In opportunity view clicking investment button redirects to Tellu-system login
    [Tags]      BQA-10953      AUTOLIGHTNING        OpportunityValidation
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go to Entity  ${LIGHTNING_TEST_ACCOUNT}
    Navigate to view  Opportunities
    Wait element to load and click  ${test_opportunity}
    Wait element to load and click      ${investment}
    Validate that Tellu login page opens


Add Oppo Team Member and Edit the Oppo with New Team Member
    [Tags]  BQA-10816       AUTOLIGHTNING       OpportunityValidation
    [Documentation]  Create an opportunity with User-A and add new Oppo team member User-B and try modifying the oppo with newly added team member
    Go To Salesforce and Login into Lightning       DigiSales Admin
    Go To Entity    Aarsleff Oy
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    sleep   10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    go to entity  ${oppo_name}
    logoutasuser  Sales Admin
    sleep   10s
    Go To Salesforce and Login into Lightning       B2B DigiSales
    go to entity  ${oppo_name}
    changethepricelist      B2B
    Sleep  10s
    logoutasuser  B2B DigiSales
    sleep  10s
    Go To Salesforce and Login into Lightning       DigiSales Admin
    AddOppoTeamMember  ${oppo_name}   B2B DigiSales
    logoutAsUser  Sales Admin
    sleep  10s
    Go To Salesforce and Login into Lightning       B2B DigiSales
    go to entity  ${oppo_name}
    changethepricelist    GTM

createSalesProjectOppo
    [Tags]        BQA-11776    AUTOLIGHTNING        OpportunityValidation
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity   ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    sleep   10s
    ${oppo_name}      run keyword  CreateAOppoFromAccount_HDC      ${contact_name}
    Go To Entity     ${oppo_name}
    sleep  2s
    clickingOnSolutionValueEstimate     ${oppo_name}
    addProductsViaSVE   Subscriptions and networks
    Sleep  10s
    ${case_number}=  run keyword      Create case from more actions
    logoutAsUser  B2B DigiSales
    Go To Salesforce and Login into Lightning       DigiSales Admin
    swithchtouser      B2B DigiSales
    openquotefromopporelated  ${oppo_name}  ${case_number}
    SalesProjectOppurtunity     ${case_number}
    go to entity    ${oppo_name}
    page should contain element  //span[text()='Opportunity Record Type']/../..//div//span[text()='Sales Project Opportunity']


###################  Needs Fixing ###################
Closing Opportunity as Won with FYR below 3 KEUR
    [Tags]    BQA-8794     AUTOLIGHTNING
    Closing Opportunity as Won with FYR    8    No


Closing Opportunity as Won with FYR between 3 KEUR to 100KEUR
    [Tags]    BQA-8795    AUTOLIGHTNING
    Go To Salesforce and Login into Lightning       B2B DigiSales
    ${FYR}=    set variable    //p[@title='FYR Total']/..//lightning-formatted-text
    ${Edit_continuation}=    Set Variable    //div/button[@title='Edit Create Continuation Sales Opportunity?']
    Closing Opportunity as Won with FYR    200    Yes
    ${FYR_value}=    get text    ${FYR}
    sleep    10s
    Closing the opportunity and check Continuation  Closed Won
    ${oppo_name}  get text  //div//h1//div[text()="Opportunity"]/..//lightning-formatted-text
    Go to Entity   Continuation Sales: ${oppo_name}
    reload page
    sleep  60s
    ${FYR_value1}=    get text    //p[@title='FYR Total']/..//lightning-formatted-text
    Should be equal as strings  ${FYR_value}  ${FYR_value1}
    ${current_stage}=    set variable    //div[contains(@class,'test-id__field')]/span[contains(text(),'Stage')]/../../div/span[contains(@class,'field-value')]
    ${stage}  get text  ${current_stage}
    Should be equal as strings   ${stage}   Analyse Prospect
    Execute Javascript    window.scrollTo(0,1000)
    wait until page contains element  //*[text()="Create Continuation Sales Opportunity?"]   30s
    sleep    5s
    Capture Page Screenshot

Closing Opportunity as Won with FYR greater than 100KEUR
    [Tags]    BQA-8796   AUTOLIGHTNING
    Closing Opportunity as Won with FYR    300    Yes
    Closing the opportunity and check Continuation  Closed Won


B2B opportunity closing
    [Documentation]  This script is designed to close opportunity by B2B User
    [Tags]  BQA-13357
     set test variable  ${contact_name}   Testing Contact_20200331-143447
     set test variable  ${oppo_name}   Test Robot Order_20200331-143556
     Go To Salesforce and Login into Lightning  B2B DigiSales
    Go To Entity   ${LIGHTNING_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    Log to console    ${contact}.this is name
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    log to console    ${oppo_name}.this is opportunity
    Go To Entity    ${oppo_name}
    ClickingOnCPQ   ${oppo_name}
    Adding Telia Colocation    Telia Colocation
    Updating Setting Telia Colocation
    UpdateAndAddSalesTypeB2O   Telia Colocation
    Move the Opportunity to next stage      ${oppo_name}    Negotiate and Close  Closed Won
    Cancel Opportunity and Validate     ${oppo_name}     Cancelled


Availability of HDC Related Fields in b2b opportunitty
    [Documentation]  To Check the Availability the HDC related Fields in B2b opportunity  and Edit the values and validate sales user and admin user
    [Tags]  BQA-13174
    Go To Salesforce and Login into Lightning  B2B DigiSales
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    Go To Entity    ${oppo_name}
    ClickingOnCPQ   ${oppo_name}
    AddProductToCart    Alerta projektointi
    UpdateAndAddSalesType    Alerta projektointi
    Go To Entity    ${oppo_name}
    Validate that HDC Rack Amount and HDC Total KW fields and Edit the value
    Closing the opportunity    Closed Won
    Validate the HDc Related fields are non editable after closing Opportunity
    logoutAsUser  ${B2B_DIGISALES_LIGHT_USER}
    Login to Salesforce Lightning   ${SYSTEM_ADMIN_USER}  ${SYSTEM_ADMIN_PWD}
    Go To Entity    ${oppo_name}
    Validate the HDc Related fields aeditable if the profile is admin after closing Opportunity
