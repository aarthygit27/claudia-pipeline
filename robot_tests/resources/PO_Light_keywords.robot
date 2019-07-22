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
    ${oppo_name}    set variable    Test Robot Order_ 20190516-070324
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
    #${Price List}    set variable    //span[contains(text(),'Price List')]/../../button
    ${Price List}    set variable    //span[contains(text(),'Edit Close Date')]/../../button
    ${B2B_Price_list_delete_icon}=    Set Variable    //label/span[text()='Price List']/../../div//a[@class='deleteAction']
    ${edit pricelist}    Set Variable    //button[@title='Edit Price List']
    Log To Console    Change Price list
    sleep    10s
    Scroll Page To Element    ${edit pricelist}
    ${element_position}    Get Vertical Position    ${edit pricelist}
    ${scroll_position}=    Evaluate    ${element_position}+1
    Log To Console    ${scroll_position}as
    Scroll Page To Location    0    ${scroll_position}
    ScrollUntillFound    ${edit pricelist}
    Click Element    ${edit pricelist}
    sleep    10s
    #ScrollUntillFound    ${B2B_Price_list_delete_icon}
    #Scroll Element Into View    ${B2B_Price_list_delete_icon}
    log to console    ${price_lists}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${B2B_Price_list_delete_icon}    15s
    log to console    ${status}
    Run Keyword If    ${status} == False    Click Element    ${edit pricelist}
    log to console    waiting for delete icon
    Wait Until Element Is Visible    ${B2B_Price_list_delete_icon}    15s
    Capture Page Screenshot
    sleep    3s
    Capture Page Screenshot
    click element    ${B2B_Price_list_delete_icon}
    sleep    3s
    Capture Page Screenshot
    Log To Console    searching for price list
    ${search}    Get Vertical Position    //input[@title='Search Price Lists']
    ${vert_post}    Evaluate    ${search}+3
    Scroll Page To Location    0    ${vert_post}
    #Scroll Page To Element    //input[@title='Search Price Lists']
    log to console    scrolling
    Wait Until Element Is Visible    //input[@title='Search Price Lists']    15s
    Capture Page Screenshot
    Log To Console    ${price_lists}
    input text    //input[@title='Search Price Lists']    ${price_lists}
    sleep    3s
    click element    //*[@title='${price_lists}']/../../..
    Log To Console    saving
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
    Scroll Page To Location    0    50
    Capture Page Screenshot

update_setting1
    ${street_add1}    set variable    //input[@name='productconfig_field_1_0']
    ${street_add2}    set variable    //input[@name='productconfig_field_1_1']
    ${postal_code}    Set Variable    //input[@name='productconfig_field_1_3']
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${setting}    Set Variable    //button[@title='Settings']
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
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
    Log To Console    product name ${products}
    search products    ${products}
    Adding Products    ${products}
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
    #UpdateAndAddSalesTypeB2O
    #OpenQuoteButtonPage_release
    #ClickingOnCPQ
    Wait Until Element Is Visible    //div[@title='CPQ']    120s
    ${status}    Run Keyword And Return Status    Force click element    //div[@title='CPQ']
    run keyword if    ${status} == False    Run Keywords    reload page    Wait Until Element Is Visible    //div[@title='CPQ']    60s
    ...    Click Element    //div[@title='CPQ']
    ClickonCreateOrderButton
    NextButtonOnOrderPage
    account selection
    select order contacts    sitpo test
    #SelectingTechnicalContact    sitpo test
    #${contact_name}
    RequestActionDate
    Select owner    Billing Aacon Oy
    #${billing_acc_name}
    submit order
    Orchestration_plan_details

update_setting2
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${setting}    Set Variable    //button[@title='Settings']
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
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
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
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
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
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
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
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
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
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
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
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
    Wait Until Element Is Enabled    ${closing}    60s
    Scroll Page To Element    ${closing}
    click element    ${closing}
    Unselect Frame

update telia robotics price sitpo
    ${iframe}    Set Variable    xpath=//div[contains(@class,'slds')]/iframe
    ${recurring charge}    Set Variable    //span[contains(@ng-class,'switchpaymentmode')]
    ${adjustments}    Set Variable    //h2[text()='Adjustment']
    ${price}    Set Variable    //input[@id='adjustment-input-01']
    ${apply button}    Set Variable    //button[contains(text(),'Apply')]
    Log To Console    update telia robotics price sitpo
    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    Wait Until Element Is Visible    ${recurring charge}    60s
    click element    ${recurring charge}
    Wait Until Element Is Visible    ${adjustments}    60s
    Wait Until Element Is Visible    ${price}    60s
    input text    ${price}    30
    click element    ${apply button}
    sleep    10s
    Capture Page Screenshot
    Unselect Frame

account selection
    ${iframe}    Set Variable    xpath=//div[contains(@class,'slds')]/iframe
    ${account_name}=    Set Variable    //p[contains(text(),'Search')]
    ${account_checkbox}=    Set Variable    //td[@class='slds-cell-shrink']//span[@class='slds-checkbox--faux']
    ${search_account_next_button}=    Set Variable    //div[@id='SearchAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    sleep    3s
    select frame    ${iframe}
    Wait Until Element Is Visible    ${account_name}    120s
    click element    ${account_name}
    sleep    3s
    Wait Until Element Is Visible    ${account_checkbox}    120s
    click element    ${account_checkbox}
    sleep    3s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${search_account_next_button}    120s
    Click Element    ${search_account_next_button}
    Unselect Frame

select order contacts
    [Arguments]    ${technical_contact}=sitpo test
    ${iframe}    Set Variable    //div[contains(@class,'slds')]/iframe
    ${contact_search}=    Set Variable    //input[@id='ContactName']
    ${contact_next_button}=    Set Variable    //div[@id='Select Contact_nextBtn']
    #Wait Until Element Is Visible    ${contact_search_title}    120s
    select frame    ${iframe}
    Wait Until Element Is Visible    ${contact_search}    120s
    Input Text    ${contact_search}    ${technical_contact}
    sleep    3s
    Capture Page Screenshot
    wait until page contains element    //div[text()='${technical_contact}']/..//preceding-sibling::td[2]    30s
    click element    //div[text()='${technical_contact}']/..//preceding-sibling::td[2]
    sleep    5s
    #${order_name}    set variable    //input[@id='OrderContactDetailsTypeAhead']
    #${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${order_name}    5s
    #run keyword if    ${status} == True    update order details
    Click Element    ${contact_next_button}
    Unselect Frame

Select owner
    [Arguments]    ${billing_account}
    ${iframe}    Set Variable    //div[contains(@class,'slds')]/iframe
    ${owner_account}=    Set Variable    //td/div[text()='${billing_account}']/../../td[@data-label='Select']
    ${buyer_payer}=    Set Variable    //input[@id='BuyerIsPayer']/../span
    ${buyer_account_next_button}=    Set Variable    //div[@id='SelectedBuyerAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    select frame    ${iframe}
    Wait Until Element Is Visible    ${buyer_payer}    120s
    Click Element    ${owner_account}
    sleep    3s
    click element    ${buyer_payer}
    sleep    3s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${buyer_account_next_button}    120s
    click element    ${buyer_account_next_button}
    Unselect Frame

submit order
    ${submit_order}=    Set Variable    //span[text()='Yes']
    ${iframe}    Set Variable    //div[contains(@class,'slds')]/iframe
    select frame    ${iframe}
    wait until element is visible    ${submit_order}    120s
    click element    ${submit_order}
    sleep    10s
    Unselect Frame

Product_updation
    [Arguments]    ${product_name}
    clicking on next button
    UpdateAndAddSalesType    ${product_name}
    OpenQuoteButtonPage_release

updating setting telia ethernet capacity
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${setting}    Set Variable    //button[@title='Settings']
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    ${street_add1-a}    set variable    //input[@name='productconfig_field_1_0']
    ${street_add2-a}    set variable    //input[@name='productconfig_field_1_1']
    ${postal_code-a}    set variable    //input[@name='productconfig_field_1_3']
    ${city_town-a}    set variable    //input[@name='productconfig_field_1_4']
    ${street_add1-b}    set variable    //input[@name='productconfig_field_1_6']
    ${street_add2-b}    set variable    //input[@name='productconfig_field_1_7']
    ${postal_code-b}    set variable    //input[@name='productconfig_field_1_9']
    ${city_town-b}    set variable    //input[@name='productconfig_field_1_10']
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
