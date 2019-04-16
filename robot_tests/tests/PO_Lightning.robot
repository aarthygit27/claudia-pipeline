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
    clicking on next button
    UpdateAndAddSalesTypeB2O
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    Create_Order

Product2:Telia Ethernet Operator Subscription
    General Setup    B2O
    Searching and adding product    Telia Ethernet Operator Subscription
    clicking on next button
    UpdateAndAddSalesTypeB2O
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    Create_Order

Product3:Ethernet Nordic Network Bridge
    General Setup    B2O
    Searching and adding product    Ethernet Nordic Network Bridge
    update_setting1
    clicking on next button
    UpdateAndAddSalesTypeB2O
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    Create_Order

Product4:Ethernet Nordic E-Line EPL
    General Setup    B2O
    Searching and adding product    Ethernet Nordic E-Line EPL
    update_setting2
    clicking on next button
    UpdateAndAddSalesTypeB2O
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    Create_Order

Product5: Ethernet Nordic E-LAN EVP-LAN
    General Setup    B2O
    Searching and adding product    Ethernet Nordic E-Line EPL
    update_setting_Ethernet Nordic E-LAN EVP-LAN
    clicking on next button
    UpdateAndAddSalesTypeB2O
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    Create_Order

Product6: Ethernet Nordic HUB/E-NNI
    General Setup    B2O
    Searching and adding product    Ethernet Nordic E-Line EPL
    update_setting_Ethernet Nordic HUB/E-NNI
    clicking on next button
    UpdateAndAddSalesTypeB2O
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    Create_Order

Product7: Telia Ethernet subscription
    General Setup    B2O
    Searching and adding product    Telia Ethernet subscription
    update_setting_Telia Ethernet subscription
    clicking on next button
    UpdateAndAddSalesTypeB2O
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    Create_Order

Product8: TeliaRobotics
    [Tags]    TeliaRobotics
    General Setup    B2B
    Searching and adding product    Telia Robotics
    update_setting_TeliaRobotics
    clicking on next button
    UpdateAndAddSalesTypeB2O
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    Create_Order

Product8: Telia Crowd Insights
    [Tags]    TeliaRobotics
    General Setup    B2B
    Searching and adding product    Telia Crowd Insights
    update_setting_TeliaRobotics
    clicking on next button
    UpdateAndAddSalesTypeB2O
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    Create_Order

Product8: Telia Sign
    [Tags]    TeliaRobotics
    General Setup    B2B
    Searching and adding product    Telia Sign
    update_setting_TeliaSign
    clicking on next button
    UpdateAndAddSalesTypeB2O
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    Create_Order
