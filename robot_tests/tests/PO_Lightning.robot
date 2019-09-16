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
    [Tags]    B2O_Lightning
    General Setup    B2O
    Search and add product    Telia Multiservice NNI
    clicking on next button
    UpdatePageNextButton
    Create_Order

Product2:Telia Ethernet Operator Subscription
    [Tags]    B2O_Lightning
    General Setup    B2O
    Searching and adding product    Telia Ethernet Operator Subscription
    Update Setting Ethernet Operator Subscription
    clicking on next button
    UpdatePageNextButton
    Create_Order

Product3:Ethernet Nordic Network Bridge
    [Tags]    B2O_Lightning
    General Setup    B2O
    Searching and adding product    Ethernet Nordic Network Bridge
    update_setting1
    clicking on next button
    UpdatePageNextButton
    Create_Order

Product4:Ethernet Nordic E-Line EPL
    [Tags]    Product not available
    General Setup    B2O
    Searching and adding product    Ethernet Nordic E-Line EPL
    update_setting2
    clicking on next button
    UpdatePageNextButton
    Create_Order

Product5: Ethernet Nordic E-LAN EVP-LAN
    [Tags]    B2O_Lightning
    General Setup    B2O
    Searching and adding product    Ethernet Nordic E-LAN EVP-LAN
    Update_setting_Ethernet Nordic E-LAN EVP-LAN
    clicking on next button
    UpdatePageNextButton
    Create_Order

Product6: Ethernet Nordic HUB/E-NNI
    [Tags]    B2O_Lightning
    General Setup    B2O
    Searching and adding product    Ethernet Nordic HUB/E-NNI
    update_setting_Ethernet Nordic HUB/E-NNI
    clicking on next button
    UpdatePageNextButton
    Create_Order

Product7: Telia Ethernet subscription
    [Tags]    B2O_Lightning
    General Setup    B2O
    Searching and adding product    Telia Ethernet Subscription
    update_setting_Telia Ethernet subscription
    clicking on next button
    UpdatePageNextButton
    Create_Order

Test : IP VPN

    [Tags]    B2O_Lightning
    General Setup    B2O
    Search and add product    Telia Unmanaged IP VPN
    clicking on next button
    UpdatePageNextButton
    Create_Order



Test : Telia IP VPN NNI
    [Tags]    IPVPN    BQA-9002  uNAVAILABLE - VERIFIED IN BOTH B2O AND B2B
    General Setup     B2O
    Search and add product    Telia IP VPN NNI
    clicking on next button
    UpdateAndAddSalesType    Telia IP VPN NNI
    Create_Order

Test : Telia IP VPN ACCESS
    [Tags]    IPVPN    BQA-9002  uNAVAILABLE - VERIFIED IN BOTH B2O AND B2B
    General Setup     B2O
    Search and add product    Telia IP VPN ACCESS
    clicking on next button
    UpdateAndAddSalesType    Telia IP VPN ACCESS
    Create_Order

Telia Ethernet capacity
    [Tags]    uNAVAILABLE - VERIFIED IN BOTH B2O AND B2B
    General Setup    B2O
    Searching and adding product    Telia Ethernet Capacity
    updating setting telia ethernet capacity
    Product_updation    Telia Ethernet Capacity
    Create_Order

Telia Domain Name Service - P&O create new order
    [Documentation]    To create new P&O order adding Telia Domain Name Service
    [Tags]    BQA-8513    PO  submit issue- contact
    General Setup    B2B
    Searching and adding product    Telia Domain Name Service
    update_setting_Telia Domain Name Service
    clicking on next button
    UpdateAndAddSalesType    Telia Domain Name Service
    Create_Order

Product8: Telia Robotics
    [Tags]    TeliaRobotics    B2B_other
    General Setup    B2B
    Searching and adding product    Telia Robotics
    update_setting_TeliaRobotics
    clicking on next button
    UpdateAndAddSalesType    Telia Robotics
    Create_Order

Product8: Telia Crowd Insights
    [Tags]    Telia Crowd Insights    B2B_other
    General Setup    B2B
    Searching and adding product    Telia Crowd Insights
    update_setting_TeliaRobotics
    clicking on next button
    UpdateAndAddSalesType    Telia Crowd Insights
    Create_Order

Product8: Telia Sign
    [Tags]    Telia Sign    B2B_other
    General Setup    B2B
    Searching and adding product    Telia Sign
    update_setting_TeliaSign
    clicking on next button
    UpdateAndAddSalesType    Telia Sign
    Create_Order

Product9: Telia ACE
    [Tags]    Telia ACE    B2B_other
    General Setup    B2B
    Searching and adding product    Telia ACE
    clicking on next button
    UpdateAndAddSalesType    Telia ACE
    Create_Order

Product10: Genesys PureCloud
    [Tags]    Genesys PureCloud   B2B_other
    General Setup    B2B
    Searching and adding product    Genesys PureCloud
    clicking on next button
    UpdateAndAddSalesType    Genesys PureCloud
    Create_Order

Test scenario 1:Telia Architect
    [Documentation]    Ordering Telia Architect Continuous Service with Other Services Extra Service and Kilometer allowance
    [Tags]    Run    sitpo22  testtime
    ${prod_1}    set variable    Telia Arkkitehti jatkuva palvelu
    ${prod_2}    set variable    Muut asiantuntijapalvelut
    General Setup    B2B
    AddToCart with product_id    Telia Arkkitehti jatkuva palvelu   01u6E000007Roo5
    Update setting Telia Arkkitehti jatkuva palvelu    d    yes
    AddToCart with product_id    Muut asiantuntijapalvelut   01u6E000007RosF
    Update setting Muut asiantuntijapalvelut
    clicking on next button
    UpdateAndAddSalesType for 2 products    ${prod_1}    ${prod_2}
    Create_Order for multiple products    ${prod_1}    ${prod_2}

Test scenario 2: Telia Project management
    [Documentation]    Ordering Telia Project Management continuous service and one time Service with Case management request
    [Tags]    Trial Run    sitpo22
    ${prod_1}    set variable    Telia Projektijohtaminen jatkuva palvelu
    ${prod_2}    set variable    Telia Projektijohtaminen varallaolo ja matkustus
    General Setup  B2B
    AddToCart with product_id    Telia Projektijohtaminen jatkuva palvelu  01u6E000007Roon
    update setting common    d    yes
    AddToCart with product_id    Telia Projektijohtaminen varallaolo ja matkustus    01u6E000007RopK
    update setting common    h    yes
    clicking on next button
    UpdateAndAddSalesType for 2 products    ${prod_1}    ${prod_2}
    Create_Order for multiple products    ${prod_1}    ${prod_2}

Test scenario 3:Telia Consulting
    [Documentation]    Ordering TeliaConsulting continuous service and onetime Service with Case management request
    [Tags]    Run    sitpo22
    ${prod_1}    set variable    Telia Konsultointi jatkuva palvelu
    ${prod_2}    set variable    Telia Konsultointi varallaolo ja matkustus
    General Setup    B2B
    AddToCart with product_id    Telia Konsultointi jatkuva palvelu   01u6E000007Ror1
    update setting common    d    yes
    Searching and adding product    Telia Konsultointi varallaolo ja matkustus
    update setting common    h    yes
    clicking on next button
    UpdateAndAddSalesType for 2 products    ${prod_1}    ${prod_2}
    Create_Order for multiple products    ${prod_1}    ${prod_2}

Test scenario 7: Key Customer Service Desk Additional Work
    [Documentation]    Ordering Key Customer Service Desk Continuous Service with Case management request. Product Removed
    [Tags]    Trial Run    B2B_Lightning_Rerun    sitpo22   Monitor
    General Setup    B2B
    AddToCart with product_id    Telia Palvelunhallintakeskus   01u6E000007RotD
    Update setting Telia Palvelunhallintakeskus
    Add Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 8: Key Customer Service Desk Additional Work
    [Documentation]    Ordering Key Customer Service Desk Additional work \ One Time Service
    [Tags]    Run    B2B_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt kertapalvelu
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 9: Key Customer Service Desk
    [Documentation]    Ordering Key Customer Service Desk Additional Work Standby and Travel Service with Case management request
    [Tags]    Run    B2B_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 10:Training
    [Documentation]    Ordering Training Continuous Service
    [Tags]    Trial Run    B2B_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product    Koulutus jatkuva palvelu
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 11:Training
    [Documentation]    Ordering Training \ One Time Service
    [Tags]    B2B_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product    Koulutus kertapalvelu
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 12:Training
    [Documentation]    Ordering Training Standby and Travel Service with Case management request
    [Tags]    BQA-9198    PO1    B2B_Lightning_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product    Koulutus varallaolo ja matkustus
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 13:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]    Trial Run    B2B_Lightning_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add_child_product    Jatkuvuudenhallinta jatkuva palvelu
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 14:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]    B2B_Lightning_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add_child_product    Jatkuvuudenhallinta kertapalvelu
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 15:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]    B2B_Lightning_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add_child_product    Jatkuvuudenhallinta varallaolo ja matkustus
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 16:Service Lead Service
    [Documentation]    Ordering Service Lead Service Continuous Service
    [Tags]    Trial Run    B2B_Lightning_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product    Palvelujohtaminen jatkuva palvelu
    update setting common    d    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 17:Service Lead Service
    [Documentation]    Ordering Service Lead Service Onetime Service
    [Tags]    B2B_Lightning_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product    Palvelujohtaminen kertapalvelu
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 18: Service Lead Service
    [Documentation]    Ordering Service Lead Service Standby and Travel Service
    [Tags]    B2B_Lightning_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product    Palvelujohtaminen varallaolo ja matkustus
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 19:Operation and Support Service
    [Documentation]    Ordering Operation and Support Continuous Service
    [Tags]    Trial Run    B2B_Lightning_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Hallinta ja Tuki
    Add Hallinta ja Tuki jatkuva palvelu
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType for 2 products    Telia Palvelunhallintakeskus    Hallinta ja Tuki jatkuva palvelu
    Create_Order

Test scenario 20:Operation and Support Service
    [Documentation]    Ordering Operation and Support Service Onetime Service
    [Tags]    B2B_Lightning_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Hallinta ja Tuki
    Add Hallinta ja Tuki kertapalvelu
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 21:Operation and Support Service
    [Documentation]    Ordering Operation and Support Service Standby and Travel Service
    [Tags]    B2B_Lightning_ReRun    sitpo22
    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Hallinta ja Tuki
    Add Hallinta ja Tuki varallaolo ja matkustus
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

Test scenario 22 Other:Operation and Support Services
    [Documentation]    Ordering Other Operation and Support Services
    [Tags]      B2B_Lightning_ReRun   Last_product

    General Setup    B2B
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Hallinta ja Tuki
    Add Toimenpide XS
    update setting Toimenpide    h    no
    Add Toimenpide S
    update setting Toimenpide    h    no
    Add Toimenpide M
    update setting Toimenpide    h    no
    Add Toimenpide L
    update setting Toimenpide   h    no
    Add Toimenpide XL
    update setting Toimenpide    h    no
    Search and add product    Asiantuntijakäynti
    Search and add product    Pikatoimituslisä
    #Searching and adding product    Events jatkuva palvelu
    Add Events jatkuva palvelu
    update setting common    d    no
    #Searching and adding product    Events jatkuva palvelu
    Add Events kertapalvelu
    update setting common    h    no
    clicking on next button
    UpdateAndAddSalesType    Telia Palvelunhallintakeskus
    Create_Order

testing
    Wait Until element is visible   id=username     30s
    Input Text  id=username   saleadm@teliacompany.com.sitpo
    Input Text   id =password  PahaPassu6
    Click Element  id=Login
    Execute Manual step  pages
    view orchestration plan details


Product Monitor - B2B
    [Documentation]    Monitor time taken to add product to cart through Keyword_Monitor.py script
    [Tags]      Monitor_B2B
    General Setup    B2B
    Search and add product      Telia Palvelunhallintakeskus
    Search and add product      Telia Projektijohtaminen jatkuva palvelu
    Search and add product      Muut asiantuntijapalvelut
    Search and add product	    Telia Arkkitehti jatkuva palvelu
    Search and add product	    Telia Projektijohtaminen varallaolo ja matkustus
    Search and add product		Telia Konsultointi jatkuva palvelu
    Search and add product		Telia Konsultointi varallaolo ja matkustus
    Search and add product		Telia Crowd Insights
    Search and add product		Telia Sign
    Search and add product		Telia Robotics


Product Monitor - B2O
    [Documentation]    Monitor time taken to add product to cart through Keyword_Monitor.py script
    [Tags]      Monitor_B2O
    General Setup    B2O
    Search and add product      Telia Multiservice NNI
    Search and add product      Telia Ethernet Operator Subscription
    Search and add product      Ethernet Nordic Network Bridge
    Search and add product	    Ethernet Nordic E-LAN EVP-LAN
    Search and add product	    Ethernet Nordic HUB/E-NNI
    Search and add product		Telia Ethernet Subscription

Product Monitor - Single Product
    [Documentation]    Monitor time taken to add product to cart through Keyword_Monitor.py script
    [Tags]      Monitor_B2B
    General Setup    B2B
    Search and add product      Telia Palvelunhallintakeskus

Delete old orders

