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
    scrolluntillfound  ${editgtmapprovalrequest}
    click element  ${editgtmapprovalrequest}
    wait until page contains element  ${gtmapprovaljustification}   30s
    force click element   ${gtmapprovaljustification}
    input text    ${gtmapprovaljustification}    Please APprove
    click element   ${gtmsave}
    scroll page to location  0  0
    sleep  3s
    wait until page contains element    ${moreactionslink}   30s
    force click element     ${moreactionslink}
    wait until page contains element   ${submitgtmapproval}   20s
    page should contain element   ${submitgtmapproval}
    force click element   //div[text()='Submit for HDC GTM Approval']
    sleep  5s
    reload page
    Sleep  60s
    page should contain element   ${pendingapproval}
    logoutAsUser  B2B DigiSales
    sleep   10s
    Go To Salesforce and Login into Lightning       System Admin
    ApproveB2BGTMRequest  Leila Podduikin  ${oppo_name}
    ApproveB2BGTMRequest  Tommi Mattila    ${oppo_name}
    go to entity  ${oppo_name}
    scrolluntillfound    ${approvedstatus}
    page should contain element    ${approvedstatus}
    ClickingOnCPQ    ${oppo_name}