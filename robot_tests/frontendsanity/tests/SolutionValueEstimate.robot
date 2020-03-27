*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/SolutionValueEstimate.robot
Resource          ../../frontendsanity/resources/Login.robot
Resource          ../../frontendsanity/resources/Opportunity.robot
Resource          ../../frontendsanity/resources/CPQ.robot
Resource          ../../frontendsanity/resources/Quote.robot
Resource          ../../frontendsanity/resources/Order.robot
Resource          ../../frontendsanity/resources/Contact.robot
Resource          ../../frontendsanity/resources/Variables.robot


*** Test Cases ***

createAOppoViaSVE
    [Tags]    BQA-8798    AUTOLIGHTNING
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    sleep    10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    go to entity    ${oppo_name}
    clickingOnSolutionValueEstimate    ${oppo_name}
    ${fyr}    run keyword    addProductsViaSVE    Telia Colocation
    Go To Entity    ${oppo_name}
    validateCreatedOppoForFYR   Telia Colocation  ${fyr}
    Move the Opportunity to next stage      ${oppo_name}    Negotiate and Close  Closed Won


AddProducrViaSVEandCPQFlow
    [Tags]      BQA-10817      AUTOLIGHTNING        OpportunityValidation
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    Digita Oy
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    sleep   10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    go to entity  ${oppo_name}
    clickingOnSolutionValueEstimate   ${oppo_name}
    ${fyr}  run keyword  addProductsViaSVE         ${product_name}
    Go To Entity    ${oppo_name}
    ${revenue_total}=  get text  //p[text()="Revenue Total"]/../..//lightning-formatted-text
    ${fyr_total}=  get text  //p[text()="FYR Total"]/../..//lightning-formatted-text
    ${revenue_total}=  remove string  ${revenue_total}  ,00 €
    ${revenue_total}=       Evaluate    '${revenue_total}'.replace(' ','')
    ${fyr_total}=  remove string  ${fyr_total}  ,00 €
    ${fyr_total}=       Evaluate    '${fyr_total}'.replace(' ','')
    #log to console  ${revenue_total}.this is final revenue total
    #log to console  ${fyr}.this is output of addproductviasve keyword
    should be equal as strings  ${fyr_total}  ${fyr}
    should be equal as strings  ${revenue_total}  ${fyr}
    ClickingOnCPQ  ${oppo_name}
    AddProductToCart  Fiksunetti
    Run Keyword If    '${r}'== 'b2b'    run keyword  UpdateAndAddSalesType   Fiksunetti
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    OrderNextStepsPage
    clickOnSubmitOrder
    ${order_no}  run keyword  getOrderStatusAfterSubmitting
    getMultibellaCaseGUIID   ${order_no}
