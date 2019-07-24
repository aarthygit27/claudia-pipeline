*** Settings ***
Documentation     Suite description
Test Setup        Open Browser And Go To Login Page
Test Teardown     #Logout From All Systems and Close Browser
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
Resource          ../resources/PO_Lighting_variables.robot
Resource          ../resources/PO_Light_keywords.robot
Library           AutoItLibrary

*** Test Cases ***
Product1:Telia Multiservice NNI
    General Setup    B2O
    Searching and adding product
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
    Searching and adding product    Ethernet Nordic E-LAN EVP-LAN
    update_setting_Ethernet Nordic E-LAN EVP-LAN
    clicking on next button
    UpdateAndAddSalesTypeB2O
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    Create_Order

Product6: Ethernet Nordic HUB/E-NNI
    General Setup    B2O
    Searching and adding product    Ethernet Nordic HUB/E-NNI
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
    UpdateAndAddSalesTypeB2O    Telia Crowd Insights
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    Create_Order

Product8: Telia Sign
    [Tags]    TeliaRobotics
    General Setup    B2B
    Searching and adding product    Telia Sign
    update_setting_TeliaSign
    update telia robotics price sitpo
    clicking on next button
    UpdateAndAddSalesTypeB2O    Telia Sign
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    Create_Order

calucation test
    ${b}    set variable    1,500.01
    ${d}    convert to number    ${b}
    ${a}    set variable    900.00
    ${e}    convert to number    ${a}
    ${c}    Evaluate    ${d} + ${e}
    log to console    ${c}

autoit test
    Go To Salesforce and Login into Lightning    sitpo admin
    sleep    10s
    Go To    https://telia-fi--sitpo.lightning.force.com/lightning/r/Opportunity/0062600000Eb2wnAAB/view
    sleep    10s
    click element    //span[text()='Related']
    sleep    20s
    Scroll Page To Element    //div[@title='Upload Files']
    Wait Until Element Is Visible    //div[@title='Upload Files']    20s
    click element    //div[@title='Upload Files']
    Win Wait Active    File Upload
    Send    C:\Users\meb5053\Desktop\Book.xlsx
    sleep    5s
    Mouse Click    [CLASS:Button; INSTANCE:1]
