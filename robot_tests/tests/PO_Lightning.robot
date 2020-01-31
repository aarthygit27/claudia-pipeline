*** Settings ***
Documentation     PO Sanity Test cases are executed in ${ENVIRONMENT} sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../resources/PO_Light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
Resource          ../resources/PO_Lighting_variables.robot
#Library           AutoItLibrary

*** Test Cases ***
Product1:Telia Multiservice NNI
    [Tags]    BQA-9953      B2O_Lightning  Product not available
    General Setup    B2O
    Search and add product    Telia Multiservice NNI
    clicking on next button
    UpdatePageNextButton
    Create_Order
    log       Billing account is ${billingaccount}
    log       Order Number is ${Order_Id}

Product2:Telia Ethernet Operator Subscription
    [Tags]    BQA-9954      B2O_Lightning   Product not available
    General Setup    B2O
    Searching and adding product    Telia Ethernet Operator Subscription
    Update Setting Ethernet Operator Subscription
    clicking on next button
    UpdatePageNextButton
    Create_Order
    log       Billing account is ${billingaccount}
    log       Order Number is ${Order_Id}

Product3:Ethernet Nordic Network Bridge
    [Tags]    BQA-9955      B2O_Lightning   Product not available
    General Setup    B2O
    Searching and adding product    Ethernet Nordic Network Bridge
    update_setting1
    clicking on next button
    UpdatePageNextButton
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Product4:Ethernet Nordic E-Line EPL
    [Tags]    BQA-9956      Product not available
    General Setup    B2O
    Searching and adding product    Ethernet Nordic E-Line EPL
    update_setting2
    clicking on next button
    UpdatePageNextButton
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Product5: Ethernet Nordic E-LAN EVP-LAN
    [Tags]    BQA-9957      B2O_Lightning   Product not available
    General Setup    B2O
    Searching and adding product    Ethernet Nordic E-LAN EVP-LAN
    Update_setting_Ethernet Nordic E-LAN EVP-LAN
    clicking on next button
    UpdatePageNextButton
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Product6: Ethernet Nordic HUB/E-NNI
    [Tags]    BQA-9959      B2O_Lightning   Product not available
    General Setup    B2O
    Searching and adding product    Ethernet Nordic HUB/E-NNI
    update_setting_Ethernet Nordic HUB/E-NNI
    clicking on next button
    UpdatePageNextButton
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Product7: Telia Ethernet subscription
    [Tags]    BQA-9960      B2O_Lightning   Product not available
    General Setup    B2O
    Searching and adding product    Telia Ethernet Subscription
    update_setting_Telia Ethernet subscription
    clicking on next button
    UpdatePageNextButton
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test : IP VPN
    [Tags]    BQA-11508     B2O_Lightning   PO_Scripts
    General Setup    B2O
    Searching and adding product    Telia Unmanaged IP VPN
    clicking on next button
    UpdatePageNextButton
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}


Test : Telia IP VPN NNI
    [Tags]    IPVPN    BQA-9002  uNAVAILABLE - VERIFIED IN BOTH B2O AND B2B
    General Setup     B2O
    Search and add product    Telia IP VPN NNI
    clicking on next button
    Update Product Page    Telia IP VPN NNI
    Create_Order

Test : Telia IP VPN ACCESS
    [Tags]    IPVPN    BQA-9002  uNAVAILABLE - VERIFIED IN BOTH B2O AND B2B
    General Setup     B2O
    Search and add product    Telia IP VPN ACCESS
    clicking on next button
    Update Product Page    Telia IP VPN ACCESS
    Create_Order

Telia Ethernet capacity
    [Tags]    uNAVAILABLE - VERIFIED IN BOTH B2O AND B2B
    General Setup    B2O
    Searching and adding product    Telia Ethernet Capacity
    updating setting telia ethernet capacity
    Product_updation    Telia Ethernet Capacity
    Create_Order

Product8: Telia Robotics
    [Tags]    BQA-9950      TeliaRobotics    B2B_other  PO_Scripts
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Robotics
    update_setting_TeliaRobotics
    clicking on next button
    Update Product Page    Telia Robotics
    #${contact_name}  set variable  Testing Contact_20200131-132503
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Product8: Telia Crowd Insights
    [Tags]    BQA-9952       Crowd Insights    B2B_other   PO_Scripts
    General Setup    B2B    ${vLocUpg_TEST_ACCOUNT}
    Searching and adding product    Telia Crowd Insights
    update_setting_TeliaRobotics
    clicking on next button
    Update Product Page    Telia Crowd Insights
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Product8: Telia Sign
    [Tags]    BQA-9951      Telia Sign    B2B_other  PO_Scripts
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Sign
    update_setting_TeliaSign
    clicking on next button
    Update Product Page    Telia Sign
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Product9: Telia ACE
    [Tags]    BQA-11480     Telia ACE    B2B_other   PO_Scripts
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia ACE
    clicking on next button
    Update Product Page    Telia ACE
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Product10: Genesys PureCloud
    [Tags]    BQA-11482     Genesys PureCloud   B2B_other   PO_Scripts
    General Setup    B2B    ${vLocUpg_TEST_ACCOUNT}
    Searching and adding product    Genesys PureCloud
    clicking on next button
    Update Product Page    Genesys PureCloud
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 1:Telia Architect
    [Documentation]    Ordering Telia Architect Continuous Service with Other Services Extra Service and Kilometer allowance
    [Tags]    BQA-11483     Run    sitpo22   PO_Scripts
    ${prod_1}    set variable    Telia Arkkitehti jatkuva palvelu
    ${prod_2}    set variable    Muut asiantuntijapalvelut
    General Setup    B2B    ${test_account}
    AddToCart with product_id    Telia Arkkitehti jatkuva palvelu   01u6E000007Roo5
    Update setting Telia Arkkitehti jatkuva palvelu    d    yes
    AddToCart with product_id    Muut asiantuntijapalvelut   01u6E000007RosF
    Update setting Muut asiantuntijapalvelut
    clicking on next button
    Update Product Page for 2 products    ${prod_1}    ${prod_2}
    Create_Order for multiple products    ${prod_1}    ${prod_2}
    log        Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 2: Telia Project management
    [Documentation]    Ordering Telia Project Management continuous service and one time Service with Case management request
    [Tags]    BQA-11485     Trial Run    sitpo22  PO_Scripts
    ${prod_1}    set variable    Telia Projektijohtaminen jatkuva palvelu
    ${prod_2}    set variable    Telia Projektijohtaminen varallaolo ja matkustus
    General Setup  B2B  ${test_account}
    Searching and adding product   Telia Projektijohtaminen jatkuva palvelu  # 01u6E000007Roon
    update setting common    d    yes
    Searching and adding product   Telia Projektijohtaminen varallaolo ja matkustus   # 01u6E000007RopK
    update setting common    h    yes
    clicking on next button
    Update Product Page for 2 products    ${prod_1}    ${prod_2}
    Create_Order for multiple products    ${prod_1}    ${prod_2}
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 3:Telia Consulting
    [Documentation]    Ordering TeliaConsulting continuous service and onetime Service with Case management request
    [Tags]    BQA-11486     Run    sitpo22  PO_Scripts
    ${prod_1}    set variable    Telia Konsultointi jatkuva palvelu
    ${prod_2}    set variable    Telia Konsultointi varallaolo ja matkustus
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Konsultointi jatkuva palvelu  # 01u6E000007Ror1
    update setting common    d    yes
    Searching and adding product    Telia Konsultointi varallaolo ja matkustus
    update setting common    h    yes
    clicking on next button
    Update Product Page for 2 products    ${prod_1}    ${prod_2}
    Create_Order for multiple products    ${prod_1}    ${prod_2}
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 7: Key Customer Service Desk Additional Work
    [Documentation]    Ordering Key Customer Service Desk Continuous Service with Case management request. Product Removed
    [Tags]    BQA-11491     Trial Run    B2B_Lightning_Rerun    sitpo22   PO_Scripts
    General Setup    B2B    ${test_account}
    #AddToCart with product_id    Telia Palvelunhallintakeskus   01u6E000007RotD
    Searching and adding product  Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu
    update setting common    h    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 8: Key Customer Service Desk Additional Work
    [Documentation]    Ordering Key Customer Service Desk Additional work \ One Time Service
    [Tags]      BQA-11492     PO_Scripts    sitpo22  Check      Rerun
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt kertapalvelu
    update setting common    h    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 9: Key Customer Service Desk
    [Documentation]    Ordering Key Customer Service Desk Additional Work Standby and Travel Service with Case management request
    [Tags]    BQA-11493     Run    B2B_ReRun    sitpo22  PO_Scripts
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Avainasiakaspalvelukeskus
    Add Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus
    update setting common    h    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 10:Training
    [Documentation]    Ordering Training Continuous Service
    [Tags]      BQA-11494   Trial Run    PO_Scripts    sitpo22
    General Setup    B2B   ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product    Koulutus jatkuva palvelu
    update setting common    h    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 11:Training
    [Documentation]    Ordering Training \ One Time Service
    [Tags]    BQA-11495     B2B_ReRun    sitpo22   PO_Scripts
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product    Koulutus kertapalvelu
    update setting common    h    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 12:Training
    [Documentation]    Ordering Training Standby and Travel Service with Case management request
    [Tags]    BQA-11496    PO_Scripts    Prof_Test    sitpo22
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product    Koulutus varallaolo ja matkustus
    update setting common    h    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 13:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]    BQA-11497     Trial Run    B2B_Lightning_ReRun    sitpo22  PO_Scripts
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add_child_product    Jatkuvuudenhallinta jatkuva palvelu
    update setting common    h    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 14:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]    BQA-11498     B2B_Lightning_ReRun    sitpo22  PO_Scripts
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add_child_product    Jatkuvuudenhallinta kertapalvelu
    update setting common    h    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 15:Continuity Management Service
    [Documentation]    Ordering Continuity Management Service Continuous Service
    [Tags]    BQA-11499     B2B_Lightning_ReRun    sitpo22  PO_Scripts
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add_child_product    Jatkuvuudenhallinta varallaolo ja matkustus
    update setting common    h    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 16:Service Lead Service
    [Documentation]    Ordering Service Lead Service Continuous Service
    [Tags]    BQA-11500     Trial Run    PO_Scripts    sitpo22
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product    Palvelujohtaminen jatkuva palvelu
    update setting common    d    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 17:Service Lead Service
    [Documentation]    Ordering Service Lead Service Onetime Service
    [Tags]    BQA-11501     B2B_Lightning_ReRun    sitpo22    PO_Scripts
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product    Palvelujohtaminen kertapalvelu
    update setting common    h    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 18: Service Lead Service
    [Documentation]    Ordering Service Lead Service Standby and Travel Service
    [Tags]    BQA-11502     B2B_Lightning_ReRun    sitpo22  PO_Scripts
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Searching and adding product    Palvelujohtaminen varallaolo ja matkustus
    update setting common    h    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 19:Operation and Support Service
    [Documentation]    Ordering Operation and Support Continuous Service
    [Tags]    BQA-11503     Trial Run    PO_Scripts    sitpo22  Rerun
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Hallinta ja Tuki
    Add Hallinta ja Tuki jatkuva palvelu
    update setting common    h    no
    clicking on next button
    Update Product Page     Telia Palvelunhallintakeskus
    #Update Product Page for 2 products    Telia Palvelunhallintakeskus    Hallinta ja Tuki jatkuva palvelu
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 20:Operation and Support Service
    [Documentation]    Ordering Operation and Support Service Onetime Service
    [Tags]    BQA-11504     B2B_Lightning_ReRun    sitpo22  PO_Scripts
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Hallinta ja Tuki
    Add Hallinta ja Tuki kertapalvelu
    update setting common    h    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 21:Operation and Support Service
    [Documentation]    Ordering Operation and Support Service Standby and Travel Service
    [Tags]    BQA-11505     PO_Scripts    sitpo22
    General Setup    B2B    ${test_account}
    Searching and adding product    Telia Palvelunhallintakeskus
    Update setting Telia Palvelunhallintakeskus
    Add Hallinta ja Tuki
    Add Hallinta ja Tuki varallaolo ja matkustus
    update setting common    h    no
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Test scenario 22 Other:Operation and Support Services
    [Documentation]    Ordering Other Operation and Support Services
    [Tags]      BQA-11507   PO_Scripts   Last_product  sitpo22      Rerun
    General Setup    B2B    ${test_account}
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
    Add Events jatkuva palvelu
    update setting common    d    no
    #Searching and adding product    Events jatkuva palvelu
    Add Events kertapalvelu
    update setting common    h    no
    Search and add product    Asiantuntijakäynti
    Search and add product    Pikatoimituslisä
    #Searching and adding product    Events jatkuva palvelu
    clicking on next button
    Update Product Page    Telia Palvelunhallintakeskus
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}




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

Domain name service with Other Domain Complete Order RU
    [Documentation]    To create new P&O order adding Telia Domain Name Service, Other Domain name and DNS Primary
    [Tags]    BQA-11509     PO_Scripts     RunTest
    General Setup    B2B    ${Account_test}
    Searching and adding product    Telia Domain Name Service
    Update Setting for Telia Domain Name Service     russianpupu.ru
    Add Other Domain Name and update settings       .RU     1       35.00
    Add DNS Primary
    #update_setting_Telia Domain Name Service
    clicking on next button
    Update Product Page    Telia Domain Name Service
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Domain name service with Other Domain Complete Order EU
    [Documentation]    To create new P&O order adding Telia Domain Name Service, Other Domain name, DNS Primary and Office 365 Configuration
    [Tags]    BQA-11730     PO_Scripts       RunTest
    General Setup    B2B    ${Account_test}
    Searching and adding product    Telia Domain Name Service
    Update Setting for Telia Domain Name Service     pupubryssel.eu
    Add Other Domain Name and update settings       .EU     existing       5.00
    Add DNS Primary
    Add Office 365 Configuration
    #update_setting_Telia Domain Name Service
    clicking on next button
    Update Product Page    Telia Domain Name Service
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Domain name service with Finnish Domain - Complete Order
    [Documentation]    To create new P&O order adding Telia Domain Name Service
    [Tags]    BQA-11731   PO_Scripts        Rerun
    General Setup    B2B    ${Account_test}
    Searching and adding product    Telia Domain Name Service
    update_setting_Telia Domain Name Service
    Add Finnish_Domain_Service
    Add DNS Primary
    Add DNS Security
    Add Redirect
    Add Express Delivery
    clicking on next button
    Update Product Page    Telia Domain Name Service
    Create_Order
    log      Billing account is ${billingaccount}
    log      Order Number is ${Order_Id}

Telia ACE Complete Order
    [Tags]    BQA-11732     Telia ACE    B2B_other     RunTest          TestingMail
    #General Setup    B2B
    Open Salesforce and Login into Lightning
    Go to Entity      Test Robot Order_ 20191209-152542
    ClickingOnCPQ    Test Robot Order_ 20191209-152542
    Searching and adding product    Telia ACE
    #log     ${oppo_name}
    Add all child products
    Update Setting      Agent Interact Workplace            productconfig_field_0_0     100
    Update Setting      Mobile Agent Workplace              productconfig_field_0_0     200
    #Overrride Prices in CPQ
    #clicking on next button
    #Update Product Page    Telia ACE
    #Create_Order