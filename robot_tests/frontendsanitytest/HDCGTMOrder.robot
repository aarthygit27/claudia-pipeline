*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
#Library             test123.py


*** Test Cases ***

CreateB2BHDCGTMOrder
    [Tags]      BQA-10818       AUTOLIGHTNING       HDCGTMOrderManagement
    [Documentation]    Create GTM approval request, complete the process.
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${vLocUpg_TEST_ACCOUNT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    sleep   10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    go to entity  ${oppo_name}
    changethepricelist     GTM
    clickingOnSolutionValueEstimate   ${oppo_name}
    ${fyr}  run keyword   addProductsViaSVE      Telia Colocation
    ${GTM_limit}=  set variable  600000
    ${result}=  evaluate  ${fyr} > ${GTM_limit}
    Run keyword If    ${result}=='True'   click on more actions
    scrolluntillfound  //button[@title="Edit GTM Approval Request Justification"]
    click element  //button[@title="Edit GTM Approval Request Justification"]
    wait until page contains element  //Span[text()='GTM Approval Request Justification']/../following-sibling::textarea   30s
    force click element  //Span[text()='GTM Approval Request Justification']/../following-sibling::textarea
    input text    //Span[text()='GTM Approval Request Justification']/../following-sibling::textarea    Please APprove
    click element  //div[@class="footer active"]//button[@title="Save"]
    scroll page to location  0  0
    sleep  3s
    wait until page contains element  //a[contains(@title, 'more actions')][1]   30s
    force click element  //a[contains(@title, 'more actions')][1]
    wait until page contains element   //div/div[@role="menu"]//a[@title="Submit for HDC GTM Approval"][1]/..   20s
    page should contain element   //div/div[@role="menu"]//a[@title="Submit for HDC GTM Approval"][1]/..
    force click element   //div[text()='Submit for HDC GTM Approval']
    sleep  5s
    reload page
    Sleep  60s
    page should contain element  //span[text()='Pending Approval']
    logoutAsUser  B2B DigiSales
    sleep   10s
    Go To Salesforce and Login into Lightning       System Admin
    ApproveB2BGTMRequest  Leila Podduikin  ${oppo_name}
    ApproveB2BGTMRequest  Tommi Mattila    ${oppo_name}
    go to entity  ${oppo_name}
    scrolluntillfound  //span[text()='GTM Pricing Approval Status']/..//following-sibling::div//span[text()='Approved']
    page should contain element  //span[text()='GTM Pricing Approval Status']/..//following-sibling::div//span[text()='Approved']
    ClickingOnCPQ    ${oppo_name}