*** Settings ***
#Suite Teardown    Close All Browsers    # Suite Setup
Test Setup        Open Browser And Go To Login Page_PO
#Test Teardown     Logout From All Systems and Close Browser
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
    [Tags]    BQA-8504    PO1    PO
    ${prod_1}   set variable   Telia Arkkitehti jatkuva palvelu
    ${prod_2}   set variable    Muut asiantuntijapalvelut
    General test setup    Aacon Oy    b2b    sitpo
    Search Products    ${prod_1}
    Add Telia Arkkitehti jatkuva palvelu    sitpo
    sleep    10s
    Search Products    ${prod_2}
    Add Muut asiantuntijapalvelut   sitpo
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo


Test scenario 2: Telia Project management
    [Documentation]    Ordering Telia Project Management continuous service and one time Service with Case management request
    [Tags]    BQA-8790    PO1    Rerun
    ${prod_1}   set variable   Telia Projektijohtaminen jatkuva palvelu
    ${prod_2}   set variable    Telia Projektijohtaminen varallaolo ja matkustus
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Projektijohtaminen jatkuva palvelu
    Add Telia Projektijohtaminen jatkuva palvelu    sitpo
    Search Products    Telia Projektijohtaminen varallaolo ja matkustus
    Add Telia Projektijohtaminen varallaolo ja matkustus    sitpo
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 3:Telia Consulting
    [Documentation]    Ordering TeliaConsulting continuous service and onetime Service with Case management request
    [Tags]    BQA-9189    PO1    Rerun
    ${prod_1}   set variable   Telia Konsultointi jatkuva palvelu
    ${prod_2}   set variable    Telia Konsultointi varallaolo ja matkustus
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Konsultointi jatkuva palvelu
    Add Telia Konsultointi jatkuva palvelu   sitpo
    Search Products    Telia Konsultointi varallaolo ja matkustus
    Add Telia Konsultointi varallaolo ja matkustus   sitpo
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 4: Key Customer Service Desk
    [Documentation]    Ordering Key Customer Service Desk Continuous Service with Case management request. Product Removed
    [Tags]    BQA-9190        PO
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Avainasiakaspalvelukeskus jatkuva palvelu
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    #Search and add Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus
    Add  Avainasiakaspalvelukeskus jatkuva palvelu
    Add Avainasiakaspalvelukeskus jatkuva palvelu   sitpo
    Capture Page Screenshot
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 5: Key Customer Service Desk
    [Documentation]    Ordering Key Customer Service Desk one-time services. Product Removed
    [Tags]    BQA-9191        PO
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Avainasiakaspalvelukeskus kertapalvelu
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Search and add Avainasiakaspalvelukeskus
    Search Products    Avainasiakaspalvelukeskus kertapalvelu
    Add Avainasiakaspalvelukeskus kertapalvelu  sitpo
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 6: Key Customer Service Desk
    [Documentation]    Ordering Key Customer Service Desk standby and travelling Services
    [Tags]    BQA-9192        PO
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    sleep    10s
    Add Avainasiakaspalvelukeskus
    #Search Products    Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus
    Add Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus  sitpo
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 7: Key Customer Service Desk Additional Work
    [Documentation]    Ordering Key Customer Service Desk Additional work Continuous Service
    [Tags]    BQA-9193    PO1    Rerun
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    sleep    10s
    Add Avainasiakaspalvelukeskus
    #Search and add Avainasiakaspalvelukeskus
    #Search Products    Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu
    Add Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu   sitpo
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 8: Key Customer Service Desk Additional Work
    [Documentation]    Ordering Key Customer Service Desk Additional work \ One Time Service
    [Tags]    BQA-9194    PO1    PO
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Avainasiakaspalvelukeskus lisätyöt kertapalvelu
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    sleep    10s
    Add Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt kertapalvelu  sitpo
     #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 9: Key Customer Service Desk
    [Documentation]    Ordering Key Customer Service Desk Additional Work Standby and Travel Service with Case management request
    [Tags]    BQA-9195    PO1    Rerun
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    sleep    10s
    Add Avainasiakaspalvelukeskus
    #Search Products    Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus
    Add Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus  sitpo
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 10:Training
    [Documentation]    Ordering Training Continuous Service
    [Tags]    BQA-9196    PO1    Rerun
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Koulutus jatkuva palvelu
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Search Products    Koulutus jatkuva palvelu
    Add Koulutus jatkuva palvelu    sitpo
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 11:Training
    [Documentation]    Ordering Training \ One Time Service
    [Tags]    BQA-9197    PO1    PO
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Koulutus kertapalvelu
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Search Products    Koulutus kertapalvelu
    Add Koulutus kertapalvelu   sitpo
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 12:Training
    [Documentation]    Ordering Training Standby and Travel Service with Case management request
    [Tags]    BQA-9198    PO1    Rerun
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Koulutus varallaolo ja matkustus
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Search Products    Koulutus varallaolo ja matkustus
    Add Koulutus varallaolo ja matkustus    sitpo
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 13:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]    BQA-9199    PO1    PO
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Jatkuvuudenhallinta jatkuva palvelu
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Add_child_product    Jatkuvuudenhallinta jatkuva palvelu
    Add Jatkuvuudenhallinta jatkuva palvelu
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 14:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]    BQA-9200    PO1    PO
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Jatkuvuudenhallinta kertapalvelu
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Add_child_product    Jatkuvuudenhallinta kertapalvelu
    Add Jatkuvuudenhallinta kertapalvelu
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 15:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]    BQA-9201    PO1    Rerun
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Jatkuvuudenhallinta varallaolo ja matkustus
    General test setup    Aacon Oy    b2b   sitpo
    #General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Add_child_product    Jatkuvuudenhallinta varallaolo ja matkustus
    Add Jatkuvuudenhallinta varallaolo ja matkustus
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 16:Service Lead Service
    [Documentation]    Ordering Service Lead Service Continuous Service
    [Tags]    BQA-9202    PO1    PO
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Palvelujohtaminen kertapalvelu
    General test setup    Aacon Oy    b2b   sitpo
    #General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Search Products    Palvelujohtaminen jatkuva palvelu
    Add Palvelujohtaminen jatkuva palvelu   sitpo
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 17:Service Lead Service
    [Documentation]    Ordering Service Lead Service Onetime Service
    [Tags]    BQA-9203    PO1    PO
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Palvelujohtaminen kertapalvelu
    General test setup    Aacon Oy    b2b   sitpo
    #General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Search Products    Palvelujohtaminen kertapalvelu
    Add Palvelujohtaminen kertapalvelu  sitpo
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 18: Service Lead Service
    [Documentation]    Ordering Service Lead Service Standby and Travel Service
    [Tags]    BQA-9204    PO1    Rerun
    ${prod_1}   set variable   Telia Palvelunhallintakeskus
    ${prod_2}   set variable    Palvelujohtaminen varallaolo ja matkustus
    General test setup    Aacon Oy    b2b   sitpo
    #General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Search Products    Palvelujohtaminen varallaolo ja matkustus
    Add Palvelujohtaminen varallaolo ja matkustus   sitpo
    #create order    ${DEVPO_ACCOUNT}
    #${order_id}=    Complete Order
    #checking the orchestration plan    ${order_id}
    create order sitpo - Professional Products    Aacon Oy   2   ${prod_1}  ${prod_2}
    view orchestration plan sitpo

Test scenario 19:Operation and Support Service
    [Documentation]    Ordering Operation and Support Continuous Service
    [Tags]    BQA-9205    PO1    Rerun
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Add Hallinta ja Tuki
    Add Hallinta ja Tuki jatkuva palvelu
    create order sitpo    Aacon Oy
    view orchestration plan sitpo

Test scenario 20:Operation and Support Service
    [Documentation]    Ordering Operation and Support Service Onetime Service
    [Tags]    BQA-9206    PO1    PO
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Add Hallinta ja Tuki
    Add Hallinta ja Tuki kertapalvelu
    create order sitpo    Aacon Oy
    view orchestration plan sitpo

Test scenario 21:Operation and Support Service
    [Documentation]    Ordering Operation and Support Service Standby and Travel Service
    [Tags]    BQA-9207    PO1    Rerun
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Add Hallinta ja Tuki
    Add Hallinta ja Tuki varallaolo ja matkustus
    create order sitpo    Aacon Oy
    view orchestration plan sitpo

Test scenario 22 Other:Operation and Support Services
    [Documentation]    Ordering Other Operation and Support Services
    [Tags]    BQA-9208    PO1    Rerun
    General test setup    Aacon Oy    b2b   sitpo
    Search Products    Telia Palvelunhallintakeskus
    Add Telia Palvelunhallintakeskus    sitpo
    Search Products    Asiantuntijakäynti
    Adding Product   Asiantuntijakäynti
    Search Products    Pikatoimituslisä
    Adding Product   Pikatoimituslisä
    Search Products    Events jatkuva palvelu
    Add Events jatkuva palvelu     d   sitpo
    Search Products    Events jatkuva palvelu
    Add Events jatkuva palvelu    h  sitpo
    Add Hallinta ja Tuki
    #Search Products    Toimenpide XS
    Add Toimenpide XS sitpo
    #Search Products    Toimenpide S
    Add Toimenpide S sitpo
    #Search Products    Toimenpide M
    Add Toimenpide M sitpo
    #Search Products    Toimenpide L
    Add Toimenpide L sitpo
    #Search Products    Toimenpide XL
    Add Toimenpide XL sitpo
    create order sitpo    Aacon Oy
    view orchestration plan sitpo



Telia Domain Name Service - P&O create new order
    [Documentation]    To create new P&O order adding Telia Domain Name Service
    [Tags]    BQA-8513    PO
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Domain Name Service
    Add Telia Domain Service Name
    create order    ${DEVPO_ACCOUNT}
    #Place the order    Betonimestarit Oy
    Capture Page Screenshot
    ${/}

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

window sizing
    [Tags]    size
    Go To Salesforce and Login2    Sales admin User devpo
    sleep    10s
    Capture Page Screenshot
    Maximize Browser Window
    Capture Page Screenshot
    #Set Window Size    1920    720
    #Capture Page Screenshot
    #Press Key    xpath=//body    Keys.CONTROL, Keys.SUBTRACT
    #Execute Javascript    document.body.style.MozTransform = "zoom: 0.50";
    #Execute Javascript    keyPress(KeyEvent.VK_CONTROL);
    #Execute Javascript    robot.keyPress(KeyEvent.VK_SUBTRACT);
    #Execute Javascript    robot.keyRelease(KeyEvent.VK_SUBTRACT);
    #Execute Javascript    robot.keyRelease(KeyEvent.VK_CONTROL);
    Capture Page Screenshot

Telia Crowd Insights
    [Documentation]    Ordering Other Operation and Support Services
    [Tags]    PO2new    PO    devpo&failedsitpo    crowd
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Crowd Insights
    Add Telia Crowd Insights
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Telia Robotics
    [Documentation]    Ordering Other Operation and Support Services
    [Tags]    PO2new    PO    devpo&failedsitpo    robotics
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Robotics
    Add Telia Robotics
    update telia robotics price devpo
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Telia Sign
    [Tags]    PO2new    PO    devpo&failedsitpo
    General test setup    ${DEVPO_ACCOUNT}    b2b
    Search Products    Telia Sign
    Add Telia Sign
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

Telia Crowd Insights_sitpo
    [Documentation]    Ordering Other Operation and Support Services
    [Tags]    sitpo_classic_Latest
    General test setup    ${DEVPO_ACCOUNT}    b2b    sitpo
    Search Products    Telia Crowd Insights
    Add Telia Crowd Insights    sitpo
    create order sitpo    ${DEVPO_ACCOUNT}
    view orchestration plan sitpo

Telia Sign sitpo
    [Tags]    sitpo_classic_Latest
    General test setup    ${DEVPO_ACCOUNT}    b2b    sitpo
    Search Products    Telia Sign
    Add Telia Sign    sitpo
    create order sitpo    ${DEVPO_ACCOUNT}
    view orchestration plan sitpo

Telia Robotics sitpo
    [Documentation]    Ordering Other Operation and Support Services
    [Tags]    sitpo_classic_Latest    robotics
    General test setup    ${DEVPO_ACCOUNT}    b2b    sitpo
    Search Products    Telia Robotics
    Add Telia Robotics    sitpo
    update telia robotics price sitpo
    create order sitpo    ${DEVPO_ACCOUNT}
    view orchestration plan sitpo

Telia Multiservice NNI sitpo
    [Documentation]    Ordering Other Operation and Support Services
    [Tags]    robotics    sitpo_classic_Latest
    General test setup    ${DEVPO_ACCOUNT}    b2o    sitpo
    Search Products    Telia Multiservice NNI
    Adding Product    Telia Multiservice NNI
    create order sitpo    ${DEVPO_ACCOUNT}
    view orchestration plan sitpo

Product2:Telia Ethernet Operator Subscription
    [Tags]    sitpo_classic_Latest
    General test setup    ${DEVPO_ACCOUNT}    b2o    sitpo
    Search Products    Telia Ethernet Operator Subscription
    Adding Product    Telia Ethernet Operator Subscription
    create order sitpo    ${DEVPO_ACCOUNT}
    view orchestration plan sitpo

Product3:Ethernet Nordic Network Bridge
    [Tags]    sitpo_classic_Latest
    General test setup    ${DEVPO_ACCOUNT}    b2o    sitpo
    Search Products    Ethernet Nordic Network Bridge
    Add Ethernet Nordic Network Bridge    sitpo
    create order sitpo    ${DEVPO_ACCOUNT}
    view orchestration plan sitpo

Product4:Ethernet Nordic E-Line EPL
    [Tags]    sitpo_classic_Latest
    General test setup    ${DEVPO_ACCOUNT}    b2o    sitpo
    Search Products    Ethernet Nordic E-Line EPL
    Add Ethernet Nordic E-Line EPL    sitpo
    create order sitpo    ${DEVPO_ACCOUNT}
    view orchestration plan sitpo

Product5: Ethernet Nordic E-LAN EVP-LAN
    [Tags]    sitpo_classic_TestRun
    General test setup    ${DEVPO_ACCOUNT}    b2o    sitpo
    Search Products    Ethernet Nordic E-LAN EVP-LAN
    Add Ethernet Nordic E-LAN EVP-LAN    sitpo
    create order sitpo    ${DEVPO_ACCOUNT}
    view orchestration plan sitpo

Product6: Ethernet Nordic HUB/E-NNI
    [Tags]    sitpo_classic_Latest
    General test setup    ${DEVPO_ACCOUNT}    b2o    sitpo
    Search Products    Ethernet Nordic HUB/E-NNI
    Add Ethernet Nordic HUB/E-NNI    sitpo
    create order sitpo    ${DEVPO_ACCOUNT}
    view orchestration plan sitpo

Product7: Telia Ethernet subscription
    [Tags]    sitpo_classic_TestRun     devpo&failedsitpo
    General test setup    ${DEVPO_ACCOUNT}    b2o    sitpo
    Search Products    Telia Ethernet Subscription
    Add Telia Ethernet subscription    sitpo
    create order sitpo    ${DEVPO_ACCOUNT}
    view orchestration plan sitpo

leadfiletest
    sleep    10s
    Go To    file:///C:/Users/meb5053/Desktop/LEADenv-webToLead.html
    sleep    10s
    Capture Page Screenshot
