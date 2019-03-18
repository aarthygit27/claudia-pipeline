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
Test scenario 1:Telia Architect
    [Documentation]    Ordering Telia Architect Continuous Service with Other Services Extra Service and Kilometer allowance
    [Tags]    BQA-8504    PO
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Arkkitehti jatkuva palvelu
    Add Telia Arkkitehti jatkuva palvelu
    sleep    10s
    Search Products    Muut asiantuntijapalvelut
    Add Muut asiantuntijapalvelut
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 2: Telia Project management
    [Documentation]    Ordering Telia Project Management continuous service and one time Service with Case management request
    [Tags]    PO    BQA-8790
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Projektijohtaminen jatkuva palvelu
    Add Telia Projektijohtaminen jatkuva palvelu
    Search Products    Telia Projektijohtaminen varallaolo ja matkustus
    Add Telia Projektijohtaminen varallaolo ja matkustus
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 3:Telia Consulting
    [Documentation]    Ordering TeliaConsulting continuous service and onetime Service with Case management request
    [Tags]    PO    BQA-9189
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Konsultointi jatkuva palvelu
    Add Telia Konsultointi jatkuva palvelu
    Search Products    Telia Konsultointi varallaolo ja matkustus
    Add Telia Konsultointi varallaolo ja matkustus
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 4: Key Customer Service Desk
    [Documentation]    Ordering Key Customer Service Desk Continuous Service with Case management request
    [Tags]    PO    BQA-9190
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Telia Projektijohtaminen varallaolo ja matkustus
    Add Telia Projektijohtaminen varallaolo ja matkustus
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 5: Key Customer Service Desk
    [Documentation]    Ordering Key Customer Service Desk one-time services
    [Tags]    PO    BQA-9191
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus kertapalvelu
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 6: Key Customer Service Desk
    [Documentation]    Ordering Key Customer Service Desk standby and travelling Services
    [Tags]    PO    BQA-9192    PO1
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    sleep    10s
    Search Products    Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 7: Key Customer Service Desk Additional Work
    [Documentation]    Ordering Key Customer Service Desk Additional work Continuous Service
    [Tags]    PO    BQA-9193    PO1
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 8: Key Customer Service Desk Additional Work
    [Documentation]    Ordering Key Customer Service Desk Additional work \ One Time Service
    [Tags]    PO    BQA-9194    PO1
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt kertapalvelu
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 9: Key Customer Service Desk
    [Documentation]    Ordering Key Customer Service Desk Additional Work Standby and Travel Service with Case management request
    [Tags]    PO    BQA-9195    PO1
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 10:Training
    [Documentation]    Ordering Training Continuous Service
    [Tags]    PO    BQA-9196
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Koulutus jatkuva palvelu
    Add Koulutus jatkuva palvelu
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 11:Training
    [Documentation]    Ordering Training \ One Time Service
    [Tags]    PO    BQA-9197
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Koulutus kertapalvelu
    Add Koulutus kertapalvelu
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 12:Training
    [Documentation]    Ordering Training Standby and Travel Service with Case management request
    [Tags]    PO    BQA-9198
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Koulutus varallaolo ja matkustus
    Add Koulutus varallaolo ja matkustus
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 13:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]    PO    BQA-9199
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Add_child_product    Jatkuvuudenhallinta jatkuva palvelu
    Add Jatkuvuudenhallinta jatkuva palvelu
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 14:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]    PO    BQA-9200
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Add_child_product    Jatkuvuudenhallinta kertapalvelu
    Add Jatkuvuudenhallinta kertapalvelu
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 15:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]    PO    BQA-9201
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Add_child_product    Jatkuvuudenhallinta varallaolo ja matkustus
    Add Jatkuvuudenhallinta varallaolo ja matkustus
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 16:Service Lead Service
    [Documentation]    Ordering Service Lead Service Continuous Service
    [Tags]    PO    BQA-9202
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Palvelujohtaminen jatkuva palvelu
    Add Palvelujohtaminen jatkuva palvelu
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 17:Service Lead Service
    [Documentation]    Ordering Service Lead Service Onetime Service
    [Tags]    PO    BQA-9203
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Palvelujohtaminen kertapalvelu
    Add Palvelujohtaminen kertapalvelu
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 18: Service Lead Service
    [Documentation]    Ordering Service Lead Service Standby and Travel Service
    [Tags]    PO    BQA-9204
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Palvelujohtaminen varallaolo ja matkustus
    Add Palvelujohtaminen varallaolo ja matkustus
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 19:Operation and Support Service
    [Documentation]    Ordering Operation and Support Continuous Service
    [Tags]    PO    BQA-9205
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Hallinta ja Tuki jatkuva palvelu
    Add Hallinta ja Tuki jatkuva palvelu
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 20:Operation and Support Service
    [Documentation]    Ordering Operation and Support Service Onetime Service
    [Tags]    PO    BQA-9206
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Hallinta ja Tuki kertapalvelu
    Add Hallinta ja Tuki kertapalvelu
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 21:Operation and Support Service
    [Documentation]    Ordering Operation and Support Service Standby and Travel Service
    [Tags]    PO    BQA-9207
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Hallinta ja Tuki varallaolo ja matkustus
    Add Hallinta ja Tuki varallaolo ja matkustus
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Test scenario 22 Other:Operation and Support Services
    [Documentation]    Ordering Other Operation and Support Services
    [Tags]    PO    BQA-9208
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus
    Search Products    Asiantuntijakäynti
    Add Asiantuntijakäynti
    Search Products    Pikatoimituslisä
    Add Pikatoimituslisä
    Search Products    Events jatkuva palvelu
    Add Events jatkuva palvelu    d
    Search Products    Events jatkuva palvelu
    Add Events jatkuva palvelu    h
    Search Products    Toimenpide XS
    Add Toimenpide XS
    Search Products    Toimenpide S
    Add Toimenpide S
    Search Products    Toimenpide M
    Add Toimenpide M
    Search Products    Toimenpide L
    Add Toimenpide L
    Search Products    Toimenpide XL
    Add Toimenpide XL
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Telia Domain Name Service - P&O create new order
    [Documentation]    To create new P&O order adding Telia Domain Name Service
    [Tags]    BQA-8513    PO
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Domain Name Service
    Add Telia Domain Service Name
    create order    ${DEVPO_ACCOUNT}
    #Place the order    Betonimestarit Oy
    Capture Page Screenshot

Test : Telia IP VPN NNI
    [Tags]    IPVPN    BQA-9002
    General test setup    ${DEVPO_ACCOUNT}    B2O
    Search Products    Telia IP VPN NNI \
    Add Telia IP VPN NNI    ${TELIA_VPN_NNI}
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}
    #Order events update
    #checking the orchestration plan    ${order_id}

Test : Telia IP VPN ACCESS
    [Tags]    IPVPN    BQA-9002
    General test setup    ${DEVPO_ACCOUNT}    B2O
    Search Products    Telia IP VPN Access
    Add Telia IP VPN ACCESS    ${TELIA_VPN_ACCESS}
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}
