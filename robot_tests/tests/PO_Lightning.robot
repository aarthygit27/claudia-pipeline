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
