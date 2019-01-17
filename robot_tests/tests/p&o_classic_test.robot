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
    [Tags]    BQA-8504    PO
    Go To Salesforce and Login2    Digisales User devpo
    Go To    ${CLASSIC_APP}
    Go to Account2    ${DEFAULT_TEST_ACCOUNT}
    Run Keyword    create new opportunity    ${DEFAULT_TEST_ACCOUNT}  1
    #${new_opportunity_name}=    Set Variable    Test_Opportunity_080120192055
    sleep    10s
    Search Opportunity and click CPQ
    Search Products    Telia Arkkitehti jatkuva palvelu
    Add Telia Arkkitehti jatkuva palvelu
    sleep    10s
    Search Products    Muut asiantuntijapalvelut
    Add Muut asiantuntijapalvelut
    sleep    10s
    Place the order  Aacon Oy
    Capture Page Screenshot

Wait time checking
    [Tags]    PO1
    Go To Salesforce and Login2    Digisales User devpo
    Go To    ${CLASSIC_APP}
    Get Time
    Go to Account2    ${DEFAULT_TEST_ACCOUNT}

Telia Domain Name Service - P&O create new order
    [Tags]      BQA-8513
    [Documentation]  To create new P&O order adding Telia Domain Name Service

    Go To Salesforce and Login2    Digisales User devpo
    Go To    ${CLASSIC_APP}
    Search for a given account and click on Account  2018060002152336 (Betonimestarit Oy)  Betonimestarit Oy
    Run Keyword    create new opportunity    ${DEFAULT_TEST_ACCOUNT}  30
    sleep    10s
    Search Opportunity and click CPQ
    Search Products    Telia Domain Name Service
    Add Telia Domain Service Name
    Place the order  Betonimestarit Oy
    Capture Page Screenshot
