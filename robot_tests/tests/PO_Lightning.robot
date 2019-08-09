*** Settings ***
Documentation     Suite description
Test Setup        Open Browser And Go To Login Page
Test Teardown     #Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
Resource          ../resources/PO_Lighting_variables.robot
Resource          ../resources/PO_Light_keywords.robot

*** Test Cases ***
Product1:Telia Multiservice NNI
    General Setup    B2O
    Searching and adding product    Multiservice NNI
    Product_updation    Multiservice NNI
    Create_Order

Product2:Telia Ethernet Operator Subscription
    General Setup    B2O
    Searching and adding product    Telia Ethernet Operator Subscription
    Product_updation    Telia Ethernet Operator Subscription
    Create_Order

Product3:Ethernet Nordic Network Bridge
    General Setup    B2O
    Searching and adding product    Ethernet Nordic Network Bridge
    update_setting1
    Product_updation    Ethernet Nordic Network Bridge
    Create_Order

Product4:Ethernet Nordic E-Line EPL
    General Setup    B2O
    Searching and adding product    Ethernet Nordic E-Line EPL
    update_setting2
    Product_updation    Ethernet Nordic E-Line EPL
    Create_Order

Product5: Ethernet Nordic E-LAN EVP-LAN
    General Setup    B2O
    Searching and adding product    Ethernet Nordic E-LAN EVP-LAN
    update_setting_Ethernet Nordic E-LAN EVP-LAN
    Product_updation    Ethernet Nordic E-LAN EVP-LAN
    Create_Order

Product6: Ethernet Nordic HUB/E-NNI
    General Setup    B2O
    Searching and adding product    Ethernet Nordic HUB/E-NNI
    update_setting_Ethernet Nordic HUB/E-NNI
    Product_updation    Ethernet Nordic HUB/E-NNI
    Create_Order

Product7: Telia Ethernet subscription
    General Setup    B2O
    Searching and adding product    Telia Ethernet subscription
    update_setting_Telia Ethernet subscription
    Product_updation    Telia Ethernet subscription
    Create_Order

Product8: TeliaRobotics
    [Tags]    TeliaRobotics
    General Setup    B2B
    Searching and adding product    Telia Robotics
    update_setting_TeliaRobotics
    Product_updation    Telia Robotics
    Create_Order

Product8: Telia Crowd Insights
    [Tags]    Telia Crowd Insights
    General Setup    B2B
    Searching and adding product    Telia Crowd Insights
    update_setting_TeliaRobotics
    Product_updation    Telia Crowd Insights
    Create_Order

Product8: Telia Sign
    [Tags]    TeliaSign
    General Setup    B2B
    Searching and adding product    Telia Sign
    update_setting_TeliaSign
    Product_updation    Telia Sign
    Create_Order

cpq test
    [Tags]    cpq_test
    Go To Salesforce and Login into Lightning    sitpo admin
    Go To    https://telia-fi--sitpo.lightning.force.com/lightning/r/Quote/0Q026000000GimnCAC/view
    sleep    5s
    Capture Page Screenshot
    Create_Order

IP VPN
    [Tags]    ipvpn
    General Setup    B2O
    Searching and adding product    Telia Unmanaged IP VPN
    Product_updation    Telia Unmanaged IP VPN
    Create_Order

Telia Ethernet capacity
    [Tags]    ethcapacity
    General Setup    B2O
    Searching and adding product    Telia Ethernet Capacity
    updating setting telia ethernet capacity
    Product_updation    Telia Ethernet Capacity
    Create_Order

Test scenario 1:Telia Architect
    [Documentation]    Ordering Telia Architect Continuous Service with Other Services Extra Service and Kilometer allowance
    [Tags]  Trial Run
    ${prod_1}   set variable   Telia Arkkitehti jatkuva palvelu
    ${prod_2}   set variable    Muut asiantuntijapalvelut
    #General Setup    b2b
    Wait Until element is visible   id=username     30s
    Input Text  id=username   saleadm@teliacompany.com.sitpo
    Input Text   id =password  PahaPassu5
    Click Element  id=Login
    Execute Manual step  pages
    Searching and adding product    Telia Arkkitehti jatkuva palvelu
    Update setting Telia Arkkitehti jatkuva palvelu  d    yes
    Searching and adding product  Muut asiantuntijapalvelut
    Update setting Muut asiantuntijapalvelut
    clicking on next button
    UpdateAndAddSalesType   Telia Arkkitehti jatkuva palvelu
    Create_Order for multiple products  ${prod_1}  ${prod_2}

Test scenario 2: Telia Project management
    [Documentation]    Ordering Telia Project Management continuous service and one time Service with Case management request
    [Tags]  Trial Run
    ${prod_1}   set variable   Telia Projektijohtaminen jatkuva palvelu
    ${prod_2}   set variable    Telia Projektijohtaminen varallaolo ja matkustus
    General Setup    b2b
    Searching and adding product   Telia Projektijohtaminen jatkuva palvelu
    update setting common   d    yes
    Searching and adding product  Telia Projektijohtaminen varallaolo ja matkustus
    update setting common   h    yes
    clicking on next button
    UpdateAndAddSalesType   Telia Projektijohtaminen jatkuva palvelu
    Create_Order for multiple products  ${prod_1}  ${prod_2}



Test scenario 3:Telia Consulting
    [Documentation]    Ordering TeliaConsulting continuous service and onetime Service with Case management request
    [Tags]  Trial Run
    ${prod_1}   set variable   Telia Konsultointi jatkuva palvelu
    ${prod_2}   set variable    Telia Konsultointi varallaolo ja matkustus
    General Setup    b2b
    Searching and adding product   Telia Konsultointi jatkuva palvelu
    update setting common   d    yes
    Searching and adding product  Telia Konsultointi varallaolo ja matkustus
    update setting common   h    yes
    clicking on next button
    UpdateAndAddSalesType   Telia Konsultointi jatkuva palvelu
    Create_Order for multiple products  ${prod_1}  ${prod_2}

Test scenario 7: Key Customer Service Desk Additional Work
    [Documentation]    Ordering Key Customer Service Desk Continuous Service with Case management request. Product Removed
    [Tags]  Trial Run
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 8: Key Customer Service Desk Additional Work
    [Documentation]    Ordering Key Customer Service Desk Additional work \ One Time Service
    [Tags]
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt kertapalvelu
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 9: Key Customer Service Desk
    [Documentation]    Ordering Key Customer Service Desk Additional Work Standby and Travel Service with Case management request
    [Tags]
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 10:Training
    [Documentation]    Ordering Training Continuous Service
    [Tags]    Trial Run
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product     Koulutus jatkuva palvelu
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 11:Training
    [Documentation]    Ordering Training \ One Time Service
    [Tags]
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product     Koulutus kertapalvelu
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 12:Training
    [Documentation]    Ordering Training Standby and Travel Service with Case management request
    [Tags]    BQA-9198    PO1    Rerun
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product     Koulutus varallaolo ja matkustus
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 13:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]  Trial Run
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add_child_product        Jatkuvuudenhallinta jatkuva palvelu
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 14:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add_child_product    Jatkuvuudenhallinta kertapalvelu
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 15:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add_child_product    Jatkuvuudenhallinta varallaolo ja matkustus
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 16:Service Lead Service
    [Documentation]    Ordering Service Lead Service Continuous Service
    [Tags]  Trial Run
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product   Palvelujohtaminen jatkuva palvelu
    update setting common   d    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 17:Service Lead Service
    [Documentation]    Ordering Service Lead Service Onetime Service
    [Tags]
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product   Palvelujohtaminen kertapalvelu
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 18: Service Lead Service
    [Documentation]    Ordering Service Lead Service Standby and Travel Service
    [Tags]

    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product   Palvelujohtaminen varallaolo ja matkustus
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 19:Operation and Support Service
    [Documentation]    Ordering Operation and Support Continuous Service
    [Tags]  Trial Run
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Hallinta ja Tuki
    Add Hallinta ja Tuki jatkuva palvelu
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 20:Operation and Support Service
    [Documentation]    Ordering Operation and Support Service Onetime Service
    [Tags]
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Hallinta ja Tuki
    Add Hallinta ja Tuki kertapalvelu
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 21:Operation and Support Service
    [Documentation]    Ordering Operation and Support Service Standby and Travel Service
    [Tags]
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Hallinta ja Tuki
    Add Hallinta ja Tuki varallaolo ja matkustus
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order

Test scenario 22 Other:Operation and Support Services
    [Documentation]    Ordering Other Operation and Support Services
    [Tags]  Trial Run
    General Setup    b2b
    Searching and adding product   Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Search and add product   Asiantuntijakäynti
    Search and add product   Pikatoimituslisä
    Searching and adding product   Events jatkuva palvelu
    update setting common   d    no
    Searching and adding product  Events jatkuva palvelu
    update setting common   h    no
    Add Hallinta ja Tuki
    Add Toimenpide XS
    update setting common   h    no
    Add Toimenpide S
    update setting common   h    no
    Add Toimenpide M
    update setting common   h    no
    Add Toimenpide L
    update setting common   h    no
    Add Toimenpide XL
    update setting common   h    no
    clicking on next button
    UpdateAndAddSalesType  Telia Palvelunhallintakeskus
    Create_Order