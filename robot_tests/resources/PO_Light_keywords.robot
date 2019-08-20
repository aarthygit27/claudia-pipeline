*** Settings ***
Resource          ../resources/sales_app_light_keywords.robot
Resource          ../resources/common.robot
Resource          ../resource/multibella_keywords.robot
Resource          ../resources/PO_Lighting_variables.robot

*** Keywords ***
General Setup
    [Arguments]    ${price_list}
    Go To Salesforce and Login into Lightning    sitpo admin
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    Testing Chetan
    #${oppo_name}    set variable    Test Robot Order_ 20190809-150440
    #sleep    5s
    Go To Entity    ${oppo_name}
    sleep    5s
    #updating close date
    Edit Opportunity values     Price List  ${price_list}
    ClickingOnCPQ   ${oppo_name}
    sleep  15s

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
    #Click Element    ${setting}
    Wait Until Element Is Visible    ${street_add1}    60s
    Press Key    ${street_add1}    This is a test opportunity
    sleep    10s
    Press Key     ${street_add2}    This is a test opportunity
    sleep    10s
    Press Key    ${postal_code}    00100
    sleep    10s
    click element    ${closing}

Searching and adding product

    [Arguments]   ${pname}=${product_name}
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    sleep   5s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    sleep  15s
    Click Settings
    Unselect frame
    sleep  20s

Search and add product

   [Documentation]  Search and add products without clickings etting button
   [Arguments]   ${pname}=${product_name}
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    sleep   5s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    sleep  15s
    #Click Settings
    Unselect frame
    sleep  20s


Add Avainasiakaspalvelukeskus

    [Documentation]    This is to add Avainasiakaspalvelukeskus to cart
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product}=  set variable   //div[contains(text(),'Avainasiakaspalvelukeskus')]//following::button[1]
    sleep  10s
    click button  ${product}
    sleep   10s
    Unselect frame


Add Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu

    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep   15s
    Click Button    //div[contains(text(),'Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu')]//following::button[1]
    Unselect frame

Add Avainasiakaspalvelukeskus lisätyöt kertapalvelu

    [Documentation]    This is to add Avainasiakaspalvelukeskus lisätyöt kertapalvelu to cart and click grand child settings button

    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Avainasiakaspalvelukeskus lisätyöt kertapalvelu')]//following::button[1]
    sleep    15s
    click button    ${product_id}
    sleep  15s
    Click Button  //div[contains(text(),'Avainasiakaspalvelukeskus lisätyöt kertapalvelu')]//following::button[1]
    Unselect frame

Add Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep    15s
    click button    //div[contains(text(),'Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus')]//following::button[1]
    Unselect frame

Add Hallinta ja Tuki
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    [Documentation]    This is to add Hallinta ja Tuki to cart
    ${product}=  set variable   //div[contains(text(),'Hallinta ja Tuki')]//following::button[1]
    sleep  10s
    click button  ${product}
    sleep   10s
    Unselect frame

Add Hallinta ja Tuki jatkuva palvelu
    [Documentation]    This is to add Hallinta ja Tuki jatkuva palvelu
    ...    to cart and fill the required details for grand child product
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Hallinta ja Tuki jatkuva palvelu')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep    15s
    Click Button   //div[contains(text(),'Hallinta ja Tuki jatkuva palvelu')]//following::button[1]
    Unselect frame

Add Hallinta ja Tuki kertapalvelu
    [Documentation]    This is to add Hallinta ja Tuki kertapalvelu
    ...    to cart and fill the required details for grand child product
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Hallinta ja Tuki kertapalvelu')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep    15s
    Click button  //div[contains(text(),'Hallinta ja Tuki kertapalvelu')]//following::button[1]
    Unselect frame

Add Hallinta ja Tuki varallaolo ja matkustus
    [Documentation]    This is to add Hallinta ja Tuki varallaolo ja matkustus
    ...    to cart and fill the required details for grand child product

    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Hallinta ja Tuki varallaolo ja matkustus')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep    15s
    Click Button   //div[contains(text(),'Hallinta ja Tuki varallaolo ja matkustus')]//following::button[1]
    Unselect frame
    Unselect frame

Add Toimenpide XS
    [Documentation]    This is to Add Toimenpide XS
    ...    to cart and fill the required details
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide XS')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep   10s
    Click Button  //div[contains(text(),'Toimenpide XS')]//following::button[1]
    Unselect frame

Add Toimenpide S
    [Documentation]    This is to Add Toimenpide S
    ...    to cart and fill the required details
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide S')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep   20s
    Click Button  //div[contains(text(),'Toimenpide S')]//following::button[1]
    Unselect frame

Add Toimenpide M
    [Documentation]    This is to Add Toimenpide M
    ...    to cart and fill the required details
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide M')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep   20s
    Click Button  //div[contains(text(),'Toimenpide M')]//following::button[1]
    Unselect frame


Add Toimenpide L
    [Documentation]    This is to Add Toimenpide L
    ...    to cart and fill the required details
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide L')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep   20s
    Click Button  //div[contains(text(),'Toimenpide L')]//following::button[1]
    Unselect frame

Add Toimenpide XL
    [Documentation]    This is to Add Toimenpide XL
    ...    to cart and fill the required details
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide XL')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep   20s
    Click Button  //div[contains(text(),'Toimenpide XL')]//following::button[1]
    Unselect frame


Add_child_product
    [Arguments]    ${child_product}
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${child_cart}=    set variable    //div[@class='cpq-item-no-children'][contains(text(),'${child_product}')]/../../../div/button
    sleep    10s
    Click Element    ${child_cart}
    Wait Until Element Is Not Visible    ${SPINNER_SMALL}    120s
    sleep    15s
    click button    ${CHILD_SETTINGS}
    sleep    15s
    Unselect frame

Click Settings

    #Reload page
    sleep  15s
    #Wait until element is visible   //div[contains(@class,'slds')]/iframe     60s
    #select frame  xpath=//div[contains(@class,'slds')]/iframe
    Wait until element is visible   ${SETTINGS}   60s
    Click Button    ${SETTINGS}
    sleep  10s

update setting common
    [Arguments]    ${option}    ${cbox}

    ${Hinnoitteluperuste}=    Set Variable    //select[@name='productconfig_field_0_0']
    ${Henkilötyöaika}=    Set Variable    //input[@name='productconfig_field_0_1']
    ${Palveluaika}=    Set Variable    //select[contains(@name,'productconfig_field_0_2')]
    ${Laskuttaminen}=    Set Variable    //select[contains(@name,'productconfig_field_0_3')]
    ${Työtilaus vaadittu}=    Set Variable    //form[@name='productconfig']//span[@class='slds-form-element__label'][contains(text(),'Työtilaus vaadittu')]
    sleep    25s
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    Capture Page Screenshot
    Wait until element is visible   ${Hinnoitteluperuste}  60s
    ${status}=     Run Keyword and Return status  Element should be enabled  ${Hinnoitteluperuste}
    Run Keyword IF   ${status}  click element    ${Hinnoitteluperuste}
    Run Keyword IF   ${status}  click element    ${Hinnoitteluperuste}/option[contains(text(),'${option}')]
    sleep   5s
    click element    ${Henkilötyöaika}
    input text    ${Henkilötyöaika}    10
    sleep    5s
    click element    ${Palveluaika}
    sleep    5s
    click element    ${Palveluaika}//option[contains(text(),'arkisin 8-16')]
    sleep    5s
    Run Keyword And Ignore Error    click element    ${Laskuttaminen}
    sleep    5s
    Run Keyword And Ignore Error    click element    ${Laskuttaminen}/option[contains(text(),'Laskutus heti')]
    sleep    5s
    ${compare}=    Run Keyword And Return Status    Should Be Equal As Strings    ${cbox}    yes
    Run Keyword If    ${compare}== True    click element    ${Työtilaus vaadittu}
    #Fill Laskutuksen lisätieto
    click element    ${X_BUTTON}
    unselect frame
    sleep    15s


Update setting Telia Arkkitehti jatkuva palvelu
    [Arguments]    ${option}    ${cbox}
    [Documentation]    ${option}= to select the option in \ Hinnoitteluperuste --> d or h
    ...    ${cbox}= to select the checkbox \ Työtilaus vaadittu \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ yes--> to check the check box
    ...    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ no--> not to check the checkbox

    ${Hinnoitteluperuste}=    Set Variable    //select[@name='productconfig_field_0_0']
    ${Henkilötyöaika}=    Set Variable    //input[@name='productconfig_field_0_3']
    ${Palveluaika}=    Set Variable    //select[contains(@name,'productconfig_field_0_1')]
    ${Laskuttaminen}=    Set Variable    //select[contains(@name,'productconfig_field_0_2')]
    ${Työtilaus vaadittu}=    Set Variable    //form[@name='productconfig']//span[@class='slds-form-element__label'][contains(text(),'Työtilaus vaadittu')]
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    Capture Page Screenshot
    sleep    10s
    Wait Until Element Is Visible    ${Hinnoitteluperuste}    30s
    click element    ${Hinnoitteluperuste}
    click element    ${Hinnoitteluperuste}/option[contains(text(),'${option}')]
    sleep   5s
    click element    ${Henkilötyöaika}
    input text    ${Henkilötyöaika}    10
    sleep    5s
    click element    ${Palveluaika}
    sleep    5s
    click element    ${Palveluaika}//option[contains(text(),'arkisin 8-16')]
    sleep    5s
    Run Keyword And Ignore Error    click element    ${Laskuttaminen}
    sleep    5s
    Run Keyword And Ignore Error    click element    ${Laskuttaminen}/option[contains(text(),'Laskutus heti')]
    sleep    5s
    ${compare}=    Run Keyword And Return Status    Should Be Equal As Strings    ${cbox}    yes
    Run Keyword If    ${compare}== True    click element    ${Työtilaus vaadittu}
    #Fill Laskutuksen lisätieto -- Not Mandatory
    click element    ${X_BUTTON}
    sleep    15s
    Unselect frame

Update setting Muut asiantuntijapalvelut


    ${Laskutettava_toimenpide}=    Set Variable    //textarea[@name='productconfig_field_0_0']
    ${Kustannus}=    set variable    //input[@name='productconfig_field_0_1']
    ${Kilometrikorvaus}=    set variable    //div[contains(text(),'Kilometrikorvaus')]/../../../div/button[contains(@class,'slds-button slds-button_neutral')]
    #${Kilometrit}=    set variable    //input[contains(@class,'ng-valid')][@value='0']
    ${Kilometrit}=    set variable     //input[@name='productconfig_field_0_4']
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    sleep    5s
    input text    ${Laskutettava_toimenpide}    This is the test order created by robot framework
    sleep    5s
    click element    ${X_BUTTON}
    sleep    10s
    click element    ${Kilometrikorvaus}
    Wait Until Element Is Not Visible    ${SPINNER_SMALL}    120s
    sleep    10s
    click element    ${CHILD_SETTINGS}
    sleep    10s
    Wait until element is visible  ${Kilometrit}  60s
    input text    ${Kilometrit}    100
    sleep    5s
    #Fill Laskutuksen lisätieto
    sleep    5s
    click element    ${X_BUTTON}
    Unselect frame

Update setting Telia Palvelunhallintakeskus

    select frame  xpath=//div[contains(@class,'slds')]/iframe
    ${Palvelunhallintakeskus}=    Set Variable    //select[@name='productconfig_field_0_1']
    ${Työtilaus vaadittu}=    Set Variable    //form[@name='productconfig']//span[@class='slds-form-element__label'][contains(text(),'Työtilaus vaadittu')]
    sleep  15s
    Wait Until Element Is Visible    ${Palvelunhallintakeskus}    30s
    click element    ${Palvelunhallintakeskus}
    click element    ${Palvelunhallintakeskus}//option[contains(text(),'Olemassaoleva avainasiakaspalvelukeskus')]
    sleep    5s
    click element    ${Työtilaus vaadittu}
    #Fill Laskutuksen lisätieto
    click element    ${X_BUTTON}
    unselect frame
    sleep    15s

clicking on next button
    ${iframe}    Set Variable    //div[contains(@class,'slds')]/iframe
    ${next_button}    set variable    //span[contains(text(),'Next')]
    Reload page
    Wait Until Element Is Enabled    ${iframe}    90s
    select frame    ${iframe}
    Scroll Page To Location    0    100
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${next_button}    60s
    Run Keyword If    ${status} == True    click element    ${next_button}
    Unselect Frame
    sleep  10s

Update Product
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${Count}=  GetElement Count     ${sales_type}
    Log to console      No of products is ${count}
    Run Keyword IF  ${Count} != 1   Select From List By Value    (//select[@ng-model='p.SalesType'])[1]    New Money-New Services
    Run Keyword IF  ${Count} != 1     Select From List By Value    (//select[@ng-model='p.SalesType'])[2]    New Money-New Services
    Run Keyword IF  ${count} == 1     Select From List By Value    ${sales_type}    New Money-New Services
    Capture Page Screenshot
    click button    ${CPQ_next_button}

UpdatePageNextButton

    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    log to console    UpdateAndAddSalesType
    sleep    30s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    click element    ${next_button}
    unselect frame
    sleep    60s

Create_Order

    View Open Quote
    Reload page
    Wait Until Element Is Visible    //ul[@class='branding-actions slds-button-group slds-m-left--xx-small oneActionsRibbon forceActionsContainer']/li[4]/a    120s
    Click element   //ul[@class='branding-actions slds-button-group slds-m-left--xx-small oneActionsRibbon forceActionsContainer']/li[4]/a
    ClickonCreateOrderButton
    OpenOrderPage
    NextButtonOnOrderPage


    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${Status}=    Run Keyword and Return Status    Element should be visible     //section[@id='OrderTypeCheck']/section/div/div/div/h1
    Run Keyword if    ${Status}    Close and Submit
    Unselect frame
    Run Keyword Unless    ${Status}    Enter Details

Close and Submit

    ${submit_order}=    Set Variable    //span[text()='Yes']
    Click Element    //div[@id='Close']/p
    sleep  15s
    ${status}    Run Keyword and Return Status    Page Should contain Element    ${submit_order}    30s
    Run Keyword if    ${status}    click element    ${submit_order}
    Run Keyword Unless    ${status}    Submit Order Button


Enter Details

    Select Account
    sleep  5s
    select contact
    sleep  5s
    Select Date
    sleep  5s
    Select account Owner
    Submit Order Button
    view orchestration plan details

Create_Order for multiple products
    [Arguments]    ${prod_1}  ${prod_2}
    View Open Quote
    Reload page
    Wait Until Element Is Visible    //ul[@class='branding-actions slds-button-group slds-m-left--xx-small oneActionsRibbon forceActionsContainer']/li[4]/a    120s
    Click element   //ul[@class='branding-actions slds-button-group slds-m-left--xx-small oneActionsRibbon forceActionsContainer']/li[4]/a
    ClickonCreateOrderButton
    OpenOrderPage
    NextButtonOnOrderPage
    Select Account
    sleep  5s
    select contact
    sleep  5s
    Select Date for multiple products    ${prod_1}  ${prod_2}
    sleep  5s
    Select account Owner
    Submit Order Button
    view orchestration plan details


Select Account

    [Documentation]    This is to search and select the account
    ${account_name}=    Set Variable    //p[contains(text(),'Search')]
    ${account_checkbox}=    Set Variable    //td[@class='slds-cell-shrink']//span[@class='slds-checkbox--faux']
    ${search_account_next_button}=    Set Variable    //div[@id='SearchAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    sleep    3s
    wait until element is visible   //div[@class='iframe-parent slds-template_iframe slds-card']/iframe    60s
    select frame  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe

    Wait Until Element Is Visible    ${account_name}    120s
    click element    ${account_name}
    sleep    3s
    Wait Until Element Is Visible    ${account_checkbox}    120s
    click element    ${account_checkbox}
    sleep    3s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${search_account_next_button}    120s
    Click Element    ${search_account_next_button}
    Unselect frame
    sleep  10s


select contact

    ${Technical_contact_search}=  set variable    //input[@id='TechnicalContactTA']
    ${contact_search}=    Set Variable    //input[@id='OrderContactTA']
    ${contact_next_button}=    Set Variable    //div[@id='SelectOrderLevelContacts_nextBtn']
    ${updateContactDR}=    Set Variable    //button[@class='slds-button slds-button--neutral ng-binding ng-scope'][@ng-click='nextRepeater(child.nextIndex, child.indexInParent)']
    Wait until element is visible   //div[contains(@class,'slds')]/iframe   30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    log to console    entering Technical COntact page
    Wait Until Element Is Visible    ${contact_search}    120s
    Input Text    ${contact_search}   ${technical_contact}
    sleep    15s
    Wait until element is visible   css=.typeahead .ng-binding   30s
    Click element   css=.typeahead .ng-binding
    sleep   10s
    Wait until element is visible  //input[@id='OCEmail']   30s
    Input Text   //input[@id='OCEmail']   primaryemail@noemail.com
    Sleep    5s
    Execute JavaScript    window.scrollTo(0,200)
    sleep  10s
    Click Element    ${contact_next_button}
    unselect frame
    sleep   10s

Select Date

    [Documentation]    Used for selecting \ requested action date
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    sleep    60s
    ${status}    Run Keyword and Return Status    Page should contain element    //input[@id='RequestedActionDate']
    Log to console    ${status}
    Run Keyword if    ${status}   Pick Date without product
    Run Keyword Unless    ${status}    Click Element    ${additional_info_next_button}
    Unselect frame

Pick Date without product

    Log to console    picking date
    ${date_id}=    Set Variable    //input[@id='RequestedActionDate']
    ${next_month}=    Set Variable    //button[@title='Next Month']
    ${firstday}=    Set Variable    //span[contains(@class,'slds-day nds-day')][text()='01']
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    #${additional_info_next_button}=    Set Variable    //div[@id='Additional data_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    Wait Until Element Is Visible    ${date_id}    120s
    Click Element    ${date_id}
    Wait Until Element Is Visible    ${next_month}    120s
    Click Button    ${next_month}
    click element    ${firstday}
    sleep    10s
    Capture Page Screenshot
    Click Element    ${additional_info_next_button}

select Date for multiple products

    [Arguments]   ${prod_1}   ${prod_2}
    [Documentation]    Used for selecting \ requested action date for each parent product
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    sleep    30s
    ${status}    Run Keyword and Return Status    Element should be visible    //div[@class='ProductName2 ng-binding ng-scope'][contains(text(),'${prod_1}')]//following::input[2]
    Log to console    ${prod_1}
    Run Keyword if    ${status}    Pick Date with product    ${prod_1}
    ${status}    Run Keyword and Return Status    Element should be visible   //div[@class='ProductName2 ng-binding ng-scope'][contains(text(),'${prod_2}')]//following::input[2]
    Log to console    ${prod_2}
    Run Keyword if    ${status}    Pick Date with product     ${prod_2}
    sleep  10s
    Click Element    ${additional_info_next_button}
    Unselect frame

Pick date with product

    [Arguments]    ${product}
    Log to console    picking date
    ${date_id}=    Set Variable    //div[@class='ProductName2 ng-binding ng-scope'][contains(text(),'${product}')]//following::input[2]
    ${next_month}=    Set Variable    //button[@title='Next Month']
    ${firstday}=    Set Variable    //span[contains(@class,'slds-day nds-day')][text()='01']
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    #${additional_info_next_button}=    Set Variable    //div[@id='Additional data_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    Wait Until Element Is Visible    ${date_id}    120s
    Click Element    ${date_id}
    Wait Until Element Is Visible    ${next_month}    120s
    Click Button    ${next_month}
    click element    ${firstday}
    sleep    10s
    Capture Page Screenshot



Select account Owner

    log to console    Select Owner Account FLow Chart Page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    log to console    entering Owner Account page
    ${owner_account}=    Set Variable    //ng-form[@id='BuyerAccount']//span[@class='slds-checkbox--faux']
    ${buyer_payer}=    Set Variable    //input[@id='BuyerIsPayer']/../span
    ${buyer_account_next_button}=    Set Variable    //div[@id='SelectedBuyerAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    Wait Until Element Is Visible    ${buyer_payer}    120s
    Click Element    ${owner_account}
    sleep    3s
    click element    ${buyer_payer}
    sleep    3s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${buyer_account_next_button}    120s
    click element    ${buyer_account_next_button}
    unselect frame
    log to console    Exiting owner Account page
    sleep    30s



Submit for Approval

    sleep    40s
    ${status}   set variable  Run keyword and return status   Page contains element   //div[text()='Submit for Approval']
    Run Keyword if   {status}   Click element   //div[text()='Submit for Approval']
    Wait until page contains element  //h2[text()='Submit for Approval']
    Input Text   //textarea[@role='textbox']  submit
    click element  //span[text()='Submit']

Submit Order Button
    Reload page
    Wait until element is visible   //div[@title='Submit Order']    60s
    Log to console    submitted
    Click element  //div[@title='Submit Order']
    sleep  10s
    Capture Page Screenshot
    ${status} =  Run Keyword and Return Status   Page should contain element     //h2[text()='Submit Order']
    Run Keyword if  ${status}   click element   //button[text()='Submit']
    sleep  90s

view orchestration plan details
    Reload page
    sleep  20s
    ${plan}     set variable    //a[@class='textUnderline outputLookupLink slds-truncate forceOutputLookup'][contains(text(),'Plan')]
    Scroll Page to element   ${plan}
    sleep  15s
    Page should contain element   ${plan}
    Click element   ${plan}
    sleep  20s
    Execute Javascript    window.scrollTo(0,200)
    sleep    10s
    Capture Page Screenshot

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
    #Click Element    ${setting}
    Wait Until Element Is Visible    ${street_add1-a}    60s
    Press Key     ${street_add1-a}    This is a test opportunity
    sleep    10s
    click element    ${street_add2-a}
    sleep    10s
    Press Key    ${street_add2-a}    This is a test opportunity
    sleep    10s
    click element    ${postal_code-a}
    sleep    10s
    Press Key     ${postal_code-a}    00100
    sleep    10s
    click element    ${city_town-a}
    sleep    10s
    Press Key     ${city_town-a}    helsinki
    sleep    10s
    Press Key    ${street_add1-a}    This is a test opportunity
    sleep    10s
    click element    ${street_add2-a}
    sleep    10s
    Press Key    ${street_add2-a}    This is a test opportunity
    sleep    10s
    click element    ${postal_code-a}
    sleep    10s
    Press Key    ${postal_code-a}    00100
    sleep    10s
    click element    ${city_town-a}
    sleep    10s
    Press Key     ${city_town-a}    helsinki
    sleep    10s
    click element    ${closing}

update_setting_Ethernet Nordic E-LAN EVP-LAN
    ${iframe}    set variable    xpath=//div[contains(@class,'slds')]/iframe
    ${setting}    Set Variable    //button[@title='Settings']
    ${closing}    Set Variable    //*[@alt='close'][contains(@size,'large')]
    ${ Network bridge }    set variable    //input[@name='productconfig_field_0_5']

    Wait Until Element Is Visible    ${iframe}    60s
    Select Frame    ${iframe}
    #Click Element    ${setting}
    Wait Until Element Is Visible    ${ Network bridge }    60s
    Press Key    ${ Network bridge }    This is a test opportunity
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
    #Click Element    ${setting}
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
    Press Key     ${street_add1}    This is a test opportunity
    sleep    10s
    click element    ${street_add2}
    sleep    10s
    Press Key     ${street_add2}    99
    sleep    10s
    Press Key     ${postal_code}    00100
    sleep    10s
    click element    ${city}
    sleep    10s
    Press Key    ${city}    helsinki
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
    #Click Element    ${setting}
    sleep    5s
    Wait Until Element Is Visible    ${E_NNI-ID}    60s
    Press Key     ${E_NNI-ID}    10
    sleep    5s
    Click Element    ${E-NNI S-Tag VLAN}
    sleep    10s
    Press Key     ${E-NNI S-Tag VLAN}    100
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
    #Click Element    ${setting}
    Fill Laskutuksen lisätieto
    click element    ${closing}
    Unselect Frame

Fill Laskutuksen lisätieto
    ${Laskutuksen lisätieto 1}=    set variable    //input[@name='productconfig_field_0_0']
    ${Laskutuksen lisätieto 2}=    set variable    //input[@name='productconfig_field_0_1']
    ${Laskutuksen lisätieto 3}=    set variable    //input[@name='productconfig_field_0_2']
    ${Laskutuksen lisätieto 4}=    set variable    //input[@name='productconfig_field_0_3']
    ${Laskutuksen lisätieto 5}=    set variable    //input[@name='productconfig_field_0_4']
    Press Key     ${Laskutuksen lisätieto 1}    test order by robot framework.L1
    sleep    3s
    Press Key    ${Laskutuksen lisätieto 2}    test order by robot framework.L2
    sleep    3s
    Press Key     ${Laskutuksen lisätieto 3}    test order by robot framework.L3
    sleep    3s
    Press Key    ${Laskutuksen lisätieto 4}    test order by robot framework.L4
    sleep    3s
    Press Key   ${Laskutuksen lisätieto 5}    test order by robot framework.L5
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
    #Click Element    ${setting}
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
    #Click Element    ${setting}
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
