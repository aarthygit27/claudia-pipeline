*** Settings ***
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resources/multibella_keywords.robot
Resource          ../resources/PO_Lighting_variables.robot

*** Keywords ***
General Setup
    [Arguments]    ${price_list}
    Go To Salesforce and Login into Lightning    sitpo admin
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    #${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    Chetan
    ${oppo_name}    set variable    Test Robot Order_ 20190415-155717
    sleep    5s
    Go To Entity    ${oppo_name}
    sleep    5s
    updating close date
    Change Price list    ${price_list}
    ClickingOnCPQ

Login to Salesforce as sitpo admin
    Login To Salesforce Lightning    ${SALES_ADMIN_SITPO}    ${PASSWORD_SALESADMIN_SITPO}

Change Price list
    [Arguments]    ${price_lists}
    ${Price List}    set variable    //span[contains(text(),'Price List')]/../../button
    ${B2B_Price_list_delete_icon}=    Set Variable    //label/span[text()='Price List']/../../div//a[@class='deleteAction']
    Log To Console    Change Price list
    ${element_position}    Get Vertical Position    //button[@title="Edit Price List"]
    ${scroll_position}=    Evaluate    ${element_position}+40
    Log To Console    ${scroll_position}
    Scroll Page To Location    0    ${scroll_position}
    #ScrollUntillFound    //button[@title="Edit Price List"]
    click element    //button[@title="Edit Price List"]
    sleep    10s
    #ScrollUntillFound    ${B2B_Price_list_delete_icon}
    #Scroll Element Into View    ${B2B_Price_list_delete_icon}
    log to console    ${price_lists}
    click element    ${B2B_Price_list_delete_icon}
    sleep    3s
    input text    //input[@title='Search Price Lists']    ${price_lists}
    sleep    3s
    click element    //*[@title='${price_lists}']/../../..
    click element    //button[@title='Save']
    #execute javascript    window.scrollTo(0,0)
    sleep    5s

updating close date
    ${close_date}=    Get Date From Future    30
    ${Edit_close_date}    set variable    //span[contains(text(),'Edit Close Date')]/../../button
    ${closing_date}    Set Variable    //div[contains(@data-aura-class,'uiInput--datetime')]/div/input
    Log To Console    updating close date
    Scroll Page To Element    ${Edit_close_date}
    click element    ${Edit_close_date}
    Scroll Page To Element    ${closing_date}
    Clear Element Text    ${closing_date}
    input text    ${closing_date}    ${close_date}
    Scroll Page To Element    //button[@title='Save']
    click element    //button[@title='Save']
    sleep    10s
    #execute javascript    window.scrollTo(0,0)
    #sleep    5s

Review_page_sitpo
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${yes}    Set Variable    //input[@id='SubmitOrder'][@value='Yes']/../span[contains(@class,'radio')]
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Wait Until Element Is Visible    ${yes}    60s
    Click Element    ${yes}
    sleep    10s

Orchestration_plan_details
    ${orchestration plan name}    Set Variable    //th[@aria-label='Orchestration Plan Name']
    ${plan}    Set Variable    //th/div/a[contains(text(),'Plan')]
    ${orchestration plan}    Set Variable    //span[text()='Orchestration Plan']
    Wait Until Element Is Visible    ${orchestration plan name}    60s
    Scroll Page To Element    ${plan}
    Click Element    ${plan}
    sleep    10s
    Wait Until Element Is Visible    ${orchestration plan}    60s
    Capture Page Screenshot

update_setting1
    ${street_add1}    set variable    //input[@name='productconfig_field_1_0']
    ${street_add2}    set variable    //input[@name='productconfig_field_1_1']
    ${postal_code}    Set Variable    //input[@name='productconfig_field_1_3']
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${setting}    Set Variable    //button[@title='Settings']
    ${closing}    Set Variable    //span[text()='Close']
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Click Element    ${setting}
    Wait Until Element Is Visible    ${street_add1}    60s
    input text    ${street_add1}    This is a test opportunity
    sleep    10s
    input text    ${street_add2}    This is a test opportunity
    sleep    10s
    input text    ${postal_code}    00100
    sleep    10s
    click element    ${closing}

Searching and adding product
    [Arguments]    ${products}
    ${iframe}    Set Variable    //div[contains(@class,'slds')]/iframe
    ${next_button}    set variable    //span[contains(text(),'Next')]
    ${prod}    Create List    ${products}
    Log To Console    Searching and adding product
    ${product_id}    Set Variable    ${${products}}
    Log To Console    product name ${products}
    search products    ${products}
    Log To Console    Product id ${product_id}
    Adding Products    ${product_id}
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    Scroll Page To Location    0    100
    #Click Element    ${next_button}
    #${status}    Run Keyword And Return Status    Wait Until Element Is Not Visible    ${next_button}    60s
    #Run Keyword If    ${status} == True    click element    ${next_button}
    Unselect Frame

clicking on next button
    ${iframe}    Set Variable    //div[contains(@class,'slds')]/iframe
    ${next_button}    set variable    //span[contains(text(),'Next')]
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    Scroll Page To Location    0    100
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${next_button}    60s
    Run Keyword If    ${status} == True    click element    ${next_button}
    Unselect Frame

Create_Order
    UpdateAndAddSalesTypeB2O
    OpenQuoteButtonPage_release
    ClickingOnCPQ
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    SearchAndSelectBillingAccount
    SelectingTechnicalContact    sitpo test
    #${contact_name}
    RequestActionDate
    SelectOwnerAccountInfo    Billing Aacon Oy
    #${billing_acc_name}
    Review_page_sitpo
    Orchestration_plan_details

update_setting2
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${setting}    Set Variable    //button[@title='Settings']
    ${closing}    Set Variable    //span[text()='Close']
    ${street_add1-a}    set variable    //input[@name='productconfig_field_1_1']
    ${street_add2-a}    set variable    //input[@name='productconfig_field_1_2']
    ${postal_code-a}    set variable    //input[@name='productconfig_field_1_4']
    ${city_town-a}    set variable    //input[@name='productconfig_field_1_5']
    ${street_add1-b}    set variable    //input[@name='productconfig_field_1_8']
    ${street_add2-b}    set variable    //input[@name='productconfig_field_1_9']
    ${postal_code-b}    set variable    //input[@name='productconfig_field_1_11']
    ${city_town-b}    set variable    //input[@name='productconfig_field_1_12']
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Click Element    ${setting}
    Wait Until Element Is Visible    ${street_add1-a}    60s
    input text    ${street_add1-a}    This is a test opportunity
    sleep    10s
    click element    ${street_add2-a}
    sleep    10s
    input text    ${street_add2-a}    This is a test opportunity
    sleep    10s
    click element    ${postal_code-a}
    sleep    10s
    input text    ${postal_code-a}    00100
    sleep    10s
    click element    ${city_town-a}
    sleep    10s
    input text    ${city_town-a}    helsinki
    sleep    10s
    input text    ${street_add1-a}    This is a test opportunity
    sleep    10s
    click element    ${street_add2-a}
    sleep    10s
    input text    ${street_add2-a}    This is a test opportunity
    sleep    10s
    click element    ${postal_code-a}
    sleep    10s
    input text    ${postal_code-a}    00100
    sleep    10s
    click element    ${city_town-a}
    sleep    10s
    input text    ${city_town-a}    helsinki
    sleep    10s
    click element    ${closing}

update_setting_Ethernet Nordic E-LAN EVP-LAN
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${setting}    Set Variable    //button[@title='Settings']
    ${closing}    Set Variable    //span[text()='Close']
    ${ Network bridge }    set variable    //input[@name='productconfig_field_0_5]
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Click Element    ${setting}
    Wait Until Element Is Visible    ${ Network bridge }    60s
    input text    ${ Network bridge }    This is a test opportunity
    helinsiki_address
    click element    ${closing}
    Unselect Frame

update_setting_Ethernet Nordic HUB/E-NNI
    ${Service level}    Set Variable    //select[@name='productconfig_field_0_4']
    ${platinum}    Set Variable    //select[@name='productconfig_field_0_4']//option[contains(text(),'Platinum')]
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${setting}    Set Variable    //button[@title='Settings']
    ${closing}    Set Variable    //span[text()='Close']
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Click Element    ${setting}
    Wait Until Element Is Visible    ${Service level}    60s
    click element    ${Service level}
    click element    ${platinum}
    sleep    5s
    helinsiki_address
    click element    ${closing}
    Unselect Frame

helinsiki_address
    ${street_add1}    set variable    //input[@name='productconfig_field_1_0']
    ${street_add2}    set variable    //input[@name='productconfig_field_1_1']
    ${postal_code}    Set Variable    //input[@name='productconfig_field_1_3']
    ${city}    set variable    //input[@name='productconfig_field_1_4']
    sleep    10s
    click element    ${street_add1}
    sleep    10s
    input text    ${street_add1}    This is a test opportunity
    sleep    10s
    click element    ${street_add2}
    sleep    10s
    input text    ${street_add2}    99
    sleep    10s
    input text    ${postal_code}    00100
    sleep    10s
    click element    ${city}
    sleep    10s
    input text    ${city}    helsinki
    sleep    10s

update_setting_Telia Ethernet subscription
    ${E_NNI-ID}    Set Variable    //input[@name='productconfig_field_0_6']
    ${E-NNI S-Tag VLAN}    Set Variable    //input[@name='productconfig_field_0_7']
    ${Interface}    Set Variable    //select[@name='productconfig_field_0_8']
    ${option}    Set Variable    ${Interface}//option[contains(text(),'10/100Base-TX')]
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${closing}    Set Variable    //span[text()='Close']
    ${setting}    Set Variable    //button[@title='Settings']
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Click Element    ${setting}
    sleep    5s
    Wait Until Element Is Visible    ${E_NNI-ID}    60s
    Input Text    ${E_NNI-ID}    10
    sleep    5s
    Click Element    ${E-NNI S-Tag VLAN}
    sleep    10s
    input text    ${E-NNI S-Tag VLAN}    100
    sleep    5s
    Click Element    ${Interface}
    Click Element    ${option}
    helinsiki_address
    click element    ${closing}
    Unselect Frame

update_setting_TeliaRobotics
    #    Wait Until Element Is Visible    ${iframe}    60s
    #    Select Frame    ${iframe}
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${closing}    Set Variable    //span[text()='Close']
    ${setting}    Set Variable    //button[@title='Settings']
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Wait Until Element Is Visible    ${setting}    60s
    Click Element    ${setting}
    Fill Laskutuksen lisätieto
    click element    ${closing}
    Unselect Frame

Fill Laskutuksen lisätieto
    ${Laskutuksen lisätieto 1}=    set variable    //input[@name='productconfig_field_0_0']
    ${Laskutuksen lisätieto 2}=    set variable    //input[@name='productconfig_field_0_1']
    ${Laskutuksen lisätieto 3}=    set variable    //input[@name='productconfig_field_0_2']
    ${Laskutuksen lisätieto 4}=    set variable    //input[@name='productconfig_field_0_3']
    ${Laskutuksen lisätieto 5}=    set variable    //input[@name='productconfig_field_0_4']
    input text    ${Laskutuksen lisätieto 1}    test order by robot framework.L1
    sleep    3s
    input text    ${Laskutuksen lisätieto 2}    test order by robot framework.L2
    sleep    3s
    input text    ${Laskutuksen lisätieto 3}    test order by robot framework.L3
    sleep    3s
    input text    ${Laskutuksen lisätieto 4}    test order by robot framework.L4
    sleep    3s
    input text    ${Laskutuksen lisätieto 5}    test order by robot framework.L5
    sleep    3s

update_setting_TeliaSign
    #    Wait Until Element Is Visible    ${iframe}    60s
    #    Select Frame    ${iframe}
    @{package}    Set Variable    paketti M    paketti L    paketti XL    paketti S
    @{cost}    Set Variable    62.00 €    225.00 €    625.00 €    10.00 €
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${closing}    Set Variable    //span[text()='Close']
    ${setting}    Set Variable    //button[@title='Settings']
    ${Paketti}    set variable    //select[@name='productconfig_field_0_0']
    ${update}    Set Variable    //h2[contains(text(),'Updated Telia Sign')]
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Wait Until Element Is Visible    ${setting}    60s
    Click Element    ${setting}
    Wait Until Element Is Visible    ${Paketti}    60s
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > 3
    \    ${package_name}    set variable    @{package}[${i}]
    \    ${package_cost}    set variable    @{cost}[${i}]
    \    ${money}    Set Variable    //span[contains(text(),'${package_cost}')]
    \    Select From List By Value    ${Paketti}    ${package_name}
    \    Wait Until Element Is Visible    ${update}    60s
    \    #click element    //button[@ng-click='importedScope.close()']
    \    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${money}    60s
    \    Log To Console    package name = ${package_name} | Package cost = \ ${package_cost} | Status = ${status}
    click element    ${closing}
    Unselect Frame
