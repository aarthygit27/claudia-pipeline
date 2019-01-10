*** Settings ***
Suite Teardown    Close All Browsers    # Suite Setup
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ..${/}resources${/}salesforce_keywords.robot
Resource          ..${/}resources${/}multibella_keywords.robot
Resource          ..${/}resources${/}uad_keywords.robot
Resource          ..${/}resources${/}tellu_keywords.robot
Resource          ..${/}resources${/}P&O_Classic_keywords.robot
Resource          ..${/}resources${/}P&O_Classic_variables.robot
Resource          ..${/}resources${/}common_variables.robot
Resource          ..${/}resources${/}common.robot

*** Test Cases ***
Create New Order
    Go To Salesforce and Login2    Digisales User devpo
    Go To    ${CLASSIC_APP}
    Go to Account2    ${DEFAULT_TEST_ACCOUNT}
    ${new_opportunity_name}=    Run Keyword    create new opportunity    ${DEFAULT_TEST_ACCOUNT}
    #${new_opportunity_name}=    Set Variable    Test_Opportunity_080120192055
    Search Opportunity and click CPQ    ${new_opportunity_name}
    Search Products    Telia Arkkitehti jatkuva palvelu
    Add Telia Arkkitehti jatkuva palvelu
    sleep    10s
    Search Products    Muut asiantuntijapalvelut
    Add Muut asiantuntijapalvelut
    sleep    10s
    Wait Until Element Is Visible    //button/span[text()='Next']    120s
    click element    //button/span[text()='Next']
    Wait Until Element Is Visible    //button[@id='BackToCPQ']    240s
    click button    //button[contains(text(),'Next')]
    sleep    10s
    Wait Until Element Is Visible    //button[@id='Open Quote']    240s
    Click Button    //button[@id='Open Quote']
    Wait Until Element Is Enabled    ${CPQ_BUTTON}    120s
    click button    ${CPQ_BUTTON}
    Wait Until Element Is Visible    ${CREATE_ORDER}    120s
    click element    ${CREATE_ORDER}
    sleep    10s
    Wait Until Element Is Visible    ${VIEW_BUTTON}    120s
    Click Element    ${VIEW_BUTTON}
    Edit Billing details
    sleep    10s
    Wait Until Element Is Visible    ${DECOMPOSE_ORDER}
    click button    ${DECOMPOSE_ORDER}
    Wait Until Element Is Visible    //h1[contains(text(),'Source Orders')]    120s
    Wait Until Element Is Visible    ${ORCHESTRATE_PLAN}
    Click Element    ${ORCHESTRATE_PLAN}
    sleep    30s
