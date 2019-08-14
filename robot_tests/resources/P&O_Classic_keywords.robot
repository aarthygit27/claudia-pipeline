*** Settings ***
Resource          ..${/}resources${/}salesforce_keywords.robot
Resource          ..${/}resources${/}multibella_keywords.robot
Resource          P&O_Classic_variables.robot

*** Keywords ***
Go to Account2
    [Arguments]    ${target_account}
    ${account}=    Set Variable    //th/a[text()='${target_account}']
    ${details}=    Set Variable    //a[@class='optionItem efpDetailsView ']
    Log    Going to '${target_account}'
    Search Salesforce    ${target_account}
    sleep    10s
    Wait Until Element Is Visible    ${account}    60s
    Click Link    ${account}
    Unselect Frame
    Wait Until Element Is Visible    ${details}    60s
    Click Element    ${details}

create new opportunity
    [Arguments]    ${pricebook}
    ${create_new}=    set variable    //div[@id='createNewButton']
    ${new_opportunity}=    Set Variable    //a[contains(@class,'opportunityMru')]/img[@title='Opportunity']
    ${continue_button}=    Set Variable    //input[@class='btn'][@title='Continue']
    ${opportunity_id}=    Set Variable    //input[@id='opp3']
    ${description}=    set variable    //textarea[@id='opp14']
    ${stage}=    Set Variable    //select[@id='opp11']
    ${closing_date}=    Set Variable    //input[@id='opp9']
    ${pricing_list}=    Set Variable    //span/input[@id='CF00N5800000DyL67']
    ${DATE}=    Get Current Date    result_format=%d%m%Y%H%M
    ${contact}=    Set Variable    //input[@id='CF00N5800000CZNtx']
    ${opportunity_name}=    Set Variable    Test Robot Order_${DATE}
    log to console    new opportunity creation
    Click Element    ${create_new}
    Wait Until Element Is Visible    ${new_opportunity}
    Click Element    ${new_opportunity}
    Wait Until Element Is Visible    ${continue_button}    60s
    Capture Page Screenshot
    Click Element    ${continue_button}
    Wait Until Page Contains Element    //label[text()='Account Name']    120s
    Input Text    ${opportunity_id}    ${opportunity_name}
    Input Text    ${description}    ${opportunity_name}
    click element    ${stage}
    click element    ${stage}/option[@value='Analyse Prospect']
    input text    ${contact}    ${technical_contact}
    #contact_lookup
    sleep    5s
    ${close_date}=    Get Date From Future    30
    Input Text    ${closing_dat e}    ${close_date}
    Input Text    ${pricing_list}    ${pricebook}
    Click Save Button
    sleep    5s
    ${status}    Run Keyword and Return Status    Page Should contain Element    //h2[text()='Opportunity Edit']
    Run Keyword if    ${status}    Select from list by index    //select[@id='CF00N5800000CZNtx_lkid']    1
    ${status}    Run Keyword and Return Status    Page Should contain Element    //h2[text()='Opportunity Edit']
    Run Keyword if    ${status}    Click Save Button
    [Return]    ${opportunity_name}

Search Opportunity and click CPQ
    [Arguments]    ${opportunity_name}
    ${opportunity_search}=    Set Variable    //div[@id='Opportunity_body']/table/tbody//tr//th/a[text()='${opportunity_name}']
    ${cpq}=    Set Variable    //div[@id='customButtonMuttonButton']/span[text()='CPQ']
    sleep    10s
    #Search Salesforce    ${opportunity_name}
    #Wait Until Element Is Visible    ${opportunity_search}    30s
    #Click Element    ${opportunity_search}
    Wait Until Element Is Visible    ${cpq}    30s
    Click Element    ${cpq}

Search Products
    [Arguments]    ${product_name}
    #Wait Until Page Contains Element    //span[text()='PRODUCTS']    45s
    Log To Console    Search Products
    sleep    10s
    Wait Until Page Contains Element    //input[@placeholder='Search']    45s
    #click element    //input[@placeholder='Search']
    sleep    10s
    input text    //input[@placeholder='Search']    ${product_name}
    Capture Page Screenshot

Add Telia Arkkitehti jatkuva palvelu
    [Arguments]    ${env}=devpo
    [Documentation]    This is to add Telia Arkkitehti jatkuva palvelu to cart and fill the required details
    Adding Product    Telia Arkkitehti jatkuva palvelu
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Telia Arkkitehti jatkuva palvelu
    ...    ELSE    Click_Settings_new    Telia Arkkitehti jatkuva palvelu
    #Click_Settings_new    Telia Arkkitehti jatkuva palvelu
    Update_settings_3    d    yes

Fill Laskutuksen lisätieto_not in use
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



Fill Laskutuksen lisätieto
    ${Laskutuksen lisätieto 1}=    set variable    //input[@name='productconfig_field_1_0']
    ${Laskutuksen lisätieto 2}=    set variable    //input[@name='productconfig_field_1_1']
    ${Laskutuksen lisätieto 3}=    set variable    //input[@name='productconfig_field_1_2']
    ${Laskutuksen lisätieto 4}=    set variable    //input[@name='productconfig_field_1_3']
    ${Laskutuksen lisätieto 5}=    set variable    //input[@name='productconfig_field_1_4']
    input text    ${Laskutuksen lisätieto 1}    This is the test order created by robot framework.L1
    sleep    3s
    input text    ${Laskutuksen lisätieto 2}    This is the test order created by robot framework.L2
    sleep    3s
    input text    ${Laskutuksen lisätieto 3}    This is the test order created by robot framework.L3
    sleep    3s
    input text    ${Laskutuksen lisätieto 4}    This is the test order created by robot framework.L4
    sleep    3s
    input text    ${Laskutuksen lisätieto 5}    This is the test order created by robot framework.L5
    sleep    3s


Add Muut asiantuntijapalvelut
    [Arguments]    ${env}=devpo
    [Documentation]    This is to add Muut asiantuntijapalvelut to cart and fill the required details
    ${Laskutettava_toimenpide}=    Set Variable    //textarea[@name='productconfig_field_0_0']
    ${Kustannus}=    set variable    //input[@name='productconfig_field_0_1']
    ${Kilometrikorvaus}=    set variable    //div[contains(text(),'Kilometrikorvaus')]/../../../div/button[contains(@class,'slds-button slds-button_neutral')]
    #${Kilometrit}=    set variable    //input[contains(@class,'ng-valid')][@value='0']
    ${Kilometrit}=    set variable     //input[@name='productconfig_field_0_6']
    sleep    25s
    Adding Product    Muut asiantuntijapalvelut
    sleep    10s
    Capture Page Screenshot
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Muut asiantuntijapalvelut
    ...    ELSE    Click_Settings_new    Muut asiantuntijapalvelut
    #Click Button    ${SETTINGS}
    sleep    5s
    input text    ${Laskutettava_toimenpide}    This is the test order created by robot framework
    sleep    5s
    #input text    ${Kustannus}    10000
    Fill Laskutuksen lisätieto
    sleep    5s
    click element    ${X_BUTTON}
    sleep    10s
    click element    ${Kilometrikorvaus}
    Wait Until Element Is Not Visible    ${SPINNER_SMALL}    120s
    sleep    10s
    run keyword if    '${env}'=='sitpo'    click element    ${CHILD_SETTINGS}
    ...    ELSE    click element    ${CHILD_SETTINGS_new}

    input text    ${Kilometrit}    100
    sleep    5s
    Fill Laskutuksen lisätieto
    sleep    5s
    click element    ${X_BUTTON}

Name_lookup
    ${MAIN_WINDOW}=    Get Title
    sleep    5s
    Select Window    title=Search ~ Salesforce - Unlimited Edition
    Select Frame    id=resultsFrame
    Capture Page Screenshot
    sleep    3s
    click element    //table[@class='list']/tbody/tr[contains(@class,'dataRow')]/th/a
    sleep    5s
    Select Window    title=${MAIN_WINDOW}

Edit_fields
    [Arguments]    ${input}    ${data}    ${icon}
    [Documentation]    field location--> field which needs to be double clicked(generally ends with "ileinner") |
    ...    input location-->input text location |
    ...    data--> name of looked up
    ...    icon--> lookup icon
    sleep    5s
    Wait Until Element Is Visible    ${input}    60s
    Input Text    ${input}    ${data}
    Click Element    ${icon}

Edit Billing details
    Wait Until Element Is Visible    //div[@id='CF00N5800000DyLfz_ileinner']    120s
    Execute Javascript    window.scrollTo(0,750)
    Capture Page Screenshot
    Edit_fields    //input[@id='CF00N5800000DyLfz']    Billing Betonimestarit Oy    //a[@id='CF00N5800000DyLfzIcon']
    Name_lookup
    Edit_fields    //input[@id='CF00N5800000DyLg0']    Billing Betonimestarit Oy    //a[@id='CF00N5800000DyLg0Icon']
    Name_lookup
    Edit_fields    //input[@id='CF00N5800000DyLg1']    John Doe    //a[@id='CF00N5800000DyLg1Icon']
    Name_lookup
    Edit_fields    //input[@id='BillToContact']    John Doe    //a[@id='BillToContactIcon']
    Name_lookup
    Click Save Button

Go To Salesforce and Login2
    [Arguments]    ${user}
    Go To Salesforce
    Login To Salesforce And Close All Tabs2    ${user}

Login to Salesforce And Close All Tabs2
    [Arguments]    ${user}
    Run Keyword    Login to Salesforce as ${user}
    Run Keyword and Ignore Error    Wait For Load
    #Close All Tabs

Login to Salesforce as Digisales User devpo
    Login To Salesforce    ${B2B_DIGISALES_USER_DEVPO}    ${PASSWORD_DEVPO}

create_order_devpo
    create order    ${DEVPO_ACCOUNT}
    ${order_id}=    Complete Order
    checking the orchestration plan    ${order_id}

create order
    [Arguments]    ${target_account}
    [Documentation]    Used to create order after adding the products to the cart
    Log To Console    create order
    ${cart_next_button}=    Set Variable    //button/span[text()='Next']
    ${CPQ_next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    ${backCPQ}=    Set Variable    //button[@id='BackToCPQ']
    ${spinner}=    set variable    //div[contains(@class,'slds-spinner--brand')]
    ${submit_order}=    Set Variable    //span[text()='Yes']
    #${submit_order}=    Set Variable    //p[text()='Submit Order']
    ${sales_type}    set variable    //select[@ng-model='p.SalesType']
    sleep    10s
    Wait Until Element Is Visible    ${cart_next_button}    120s
    click element    ${cart_next_button}
    Wait Until Element Is Visible    ${backCPQ}    240s
    sleep    10s
    ${status}    Run Keyword And Return Status    wait until element is visible    ${sales_type}    30s
    Run Keyword If    ${status} == True    Select From List By Value    ${sales_type}    New Money-New Services
    Capture Page Screenshot
    click button    ${CPQ_next_button}
    sleep    10s
    Credit score validation
    View Open Quote
    Wait Until Element Is Enabled    ${CPQ_BUTTON}    120s
    click button    ${CPQ_BUTTON}
    Wait Until Element Is Visible    ${CREATE_ORDER}    120s
    click element    ${CREATE_ORDER}
    sleep    10s
    #Edit_Details
    Wait Until Element Is Visible    ${cart_next_button}    120s
    click element    ${cart_next_button}
    sleep    10s
    Wait Until Element Is Not Visible    ${spinner}    120s
    Account seletion
    sleep    3s
    select order contacts
    sleep    3s
    Addtional data
    sleep    3s
    Select Owner
    sleep    3s
    #wait until element is visible    ${submit_order}    120s
    #click element    ${submit_order}
    #sleep    10s
     ${status}    Run Keyword and Return Status    Page Should contain Element    ${submit_order}    30s
     Run Keyword if    ${status}    click elemComplete Orderent    ${submit_order}
     Run Keyword Unless    ${status}    Submit Order Page
     Capture Page Screenshot
     sleep  5s
     ${status}   Run Keyword and Return status  Page should contain Element     //button[contains(text(),'Continue')]
     Run Keyword if    ${status}    click element   //button[contains(text(),'Continue')]
     sleep  10s
     Wait until element is visible  //div[@id='Clone']//following::input[1] 60s
     click Visible Element  //div[@id='Clone']//following::input[1]


view order
    Wait Until Element Is Visible    ${VIEW_BUTTON}    120s
    Click Element    ${VIEW_BUTTON}
    Wait Until Element Is Visible    ${EDIT_BUTTON}    120s
    click element    ${EDIT_BUTTON}
    Edit Billing details
    sleep    10s
    Wait Until Element Is Visible    ${DECOMPOSE_ORDER}
    click button    ${DECOMPOSE_ORDER}
    Wait Until Element Is Visible    //h1[contains(text(),'Source Orders')]    120s
    Wait Until Element Is Visible    ${ORCHESTRATE_PLAN}    120s
    sleep    10s
    Click Element    ${ORCHESTRATE_PLAN}
    sleep    30s
    @{pages}    Get Window Titles
    Select Window    title=@{pages}[1]
    Wait Until Page Contains    Orchestration Plan Detail
    Capture Page Screenshot

Update_settings_3
    [Arguments]    ${option}    ${cbox}
    [Documentation]    ${option}= to select the option in \ Hinnoitteluperuste --> d or h
    ...    ${cbox}= to select the checkbox \ Työtilaus vaadittu \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ yes--> to check the check box
    ...    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ no--> not to check the checkbox
    ${Hinnoitteluperuste}=    Set Variable    //select[@name='productconfig_field_0_0']
    ${Henkilötyöaika}=    Set Variable    //input[@name='productconfig_field_0_3']
    ${Palveluaika}=    Set Variable    //select[contains(@name,'productconfig_field_0_1')]
    ${Laskuttaminen}=    Set Variable    //select[contains(@name,'productconfig_field_0_2')]
    ${Työtilaus vaadittu}=    Set Variable    //form[@name='productconfig']//span[@class='slds-form-element__label'][contains(text(),'Työtilaus vaadittu')]
    sleep    10s
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
    Fill Laskutuksen lisätieto
    click element    ${X_BUTTON}
    sleep    15s

Update_settings
    [Arguments]    ${option}    ${cbox}
    [Documentation]    ${option}= to select the option in \ Hinnoitteluperuste --> d or h
    ...    ${cbox}= to select the checkbox \ Työtilaus vaadittu \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ yes--> to check the check box
    ...    \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ no--> not to check the checkbox
    ${Hinnoitteluperuste}=    Set Variable    //select[@name='productconfig_field_0_0']
    ${Henkilötyöaika}=    Set Variable    //input[@name='productconfig_field_0_1']
    ${Palveluaika}=    Set Variable    //select[contains(@name,'productconfig_field_0_2')]
    ${Laskuttaminen}=    Set Variable    //select[contains(@name,'productconfig_field_0_3')]
    ${Työtilaus vaadittu}=    Set Variable    //form[@name='productconfig']//span[@class='slds-form-element__label'][contains(text(),'Työtilaus vaadittu')]
    sleep    10s
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
    Fill Laskutuksen lisätieto
    click element    ${X_BUTTON}
    sleep    15s

Add Telia Konsultointi jatkuva palvelu
    [Documentation]    This is to add Telia Konsultointi jatkuva palvelu to cart and fill the required details
    [Arguments]    ${env}=devpo
    Adding Product    Telia Konsultointi jatkuva palvelu
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Telia Konsultointi jatkuva palvelu
    ...    ELSE    Click_Settings_Telia Konsultointi jatkuva palvelu
    #Click_Settings_new    Telia Konsultointi jatkuva palvelu
    Update_settings    d    yes

Add Telia Konsultointi varallaolo ja matkustus
    [Documentation]    This is to Telia Konsultointi varallaolo ja matkustus to cart and fill the required details
    [Arguments]    ${env}=devpo
    Adding Product    Telia Konsultointi varallaolo ja matkustus
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Telia Konsultointi varallaolo ja matkustus
    ...    ELSE    Click_Settings_new    Telia Konsultointi varallaolo ja matkustus
    #Click_Settings_new    Telia Konsultointi varallaolo ja matkustus
    Update_settings    h    yes

Update_settings2
    ${Palvelunhallintakeskus}=    Set Variable    //select[@name='productconfig_field_0_1']
    ${Työtilaus vaadittu}=    Set Variable    //form[@name='productconfig']//span[@class='slds-form-element__label'][contains(text(),'Työtilaus vaadittu')]
    sleep    10s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${SETTINGS}    45s
    Click Button    ${SETTINGS_BTN}
    sleep    10s
    Wait Until Element Is Visible    ${Palvelunhallintakeskus}    30s
    click element    ${Palvelunhallintakeskus}
    click element    ${Palvelunhallintakeskus}//option[contains(text(),'Olemassaoleva avainasiakaspalvelukeskus')]
    sleep    5s
    click element    ${Työtilaus vaadittu}
    Fill Laskutuksen lisätieto
    click element    ${X_BUTTON}
    sleep    15s

Add Telia Projektijohtaminen jatkuva palvelu
    [Arguments]    ${env}=devpo
    [Documentation]    This is to add \ Telia Projektijohtaminen jatkuva palvelu to cart and fill the required details
    Adding Product      Telia Projektijohtaminen jatkuva palvelu
    #${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TvEUQA0']/div/div/div/div/div/button
    #sleep    10s
    #click button    ${product_id}
    #Click_Settings_new    Telia Projektijohtaminen jatkuva palvelu
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Telia Projektijohtaminen jatkuva palvelu
    ...    ELSE    Click_Settings_new    Telia Projektijohtaminen jatkuva palvelu
    Update_settings    d    yes

Add Telia Projektijohtaminen varallaolo ja matkustus
    [Documentation]    This is to add Telia Projektijohtaminen varallaolo ja matkustus to cart and fill the required details
    [Arguments]    ${env}=devpo
    Adding Product      Telia Projektijohtaminen varallaolo ja matkustus
    #${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TvEUQA0']/div/div/div/div/div/button
    #sleep    10s
    #click button    ${product_id}
    #Click_Settings_new    Telia Projektijohtaminen jatkuva palvelu
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Telia Projektijohtaminen varallaolo ja matkustus
    ...    ELSE    Click_Settings_new    Telia Projektijohtaminen varallaolo ja matkustus
    Update_settings    h    yes


Add Telia Palvelunhallintakeskus
    [Documentation]    This is to add \ Telia Palvelunhallintakeskus to cart and fill the required details
    [Arguments]    ${env}=devpo
    Adding Product  Telia Palvelunhallintakeskus
    #Click_Settings_new    Telia Palvelunhallintakeskus
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Telia Palvelunhallintakeskus
    ...    ELSE    Click_Settings_new    Telia Palvelunhallintakeskus
    Update_settings2

Add Hallinta ja Tuki

    [Documentation]    This is to add Hallinta ja Tuki to cart
    ${product}=  set variable   //div[contains(text(),'Hallinta ja Tuki')]//following::button[1]
    sleep  10s
    click button  ${product}
    sleep   10s

Add Hallinta ja Tuki jatkuva palvelu
    [Documentation]    This is to add Hallinta ja Tuki jatkuva palvelu
    ...    to cart and fill the required details for grand child product

    ${product_id}=    Set Variable    //div[contains(text(),'Hallinta ja Tuki jatkuva palvelu')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep    15s
    Click Button   //div[contains(text(),'Hallinta ja Tuki jatkuva palvelu')]//following::button[1]
    Update_settings    h    no

Add Hallinta ja Tuki kertapalvelu
    [Documentation]    This is to add Hallinta ja Tuki kertapalvelu
    ...    to cart and fill the required details for grand child product

    ${product_id}=    Set Variable    //div[contains(text(),'Hallinta ja Tuki kertapalvelu')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep    15s
    Click button  //div[contains(text(),'Hallinta ja Tuki kertapalvelu')]//following::button[1]
    Update_settings    h    no

Add Hallinta ja Tuki varallaolo ja matkustus
    [Documentation]    This is to add Hallinta ja Tuki varallaolo ja matkustus
    ...    to cart and fill the required details for grand child product

    ${product_id}=    Set Variable    //div[contains(text(),'Hallinta ja Tuki varallaolo ja matkustus')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep    15s
    Click Button   //div[contains(text(),'Hallinta ja Tuki varallaolo ja matkustus')]//following::button[1]
    Update_settings    h    no

Add Avainasiakaspalvelukeskus

    [Documentation]    This is to add Avainasiakaspalvelukeskus to cart
    ${product}=  set variable   //div[contains(text(),'Avainasiakaspalvelukeskus')]//following::button[1]
    sleep  10s
    click button  ${product}
    sleep   10s



Add Avainasiakaspalvelukeskus jatkuva palvelu
    [Documentation]    This is to add Avainasiakaspalvelukeskus jatkuva palvelu
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='${Avainasiakaspalvelukeskus jatkuva palvelu}']/div/div/div/div/div/button
    ${added_product}    Set Variable    //div[contains(@class,'cpq-item-no-children')]//span[text()='Avainasiakaspalvelukeskus jatkuva palvelu']
    sleep    10s
    click button    ${product_id}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${added_product}    20s
    Run Keyword If    ${status} == False    click button    ${product_id}
    Wait Until Element Is Visible    ${added_product}    20s
    Click_Settings_new    Avainasiakaspalvelukeskus jatkuva palvelu
    Update_settings    d    no

General test setup
    [Arguments]    ${target_account}    ${pricebook}    ${env}=devpo
    Log To Console    General test setup
    Log To Console    login
    Run Keyword If    '${env}'=='sitpo'    Go To Salesforce and Login2    Sales admin User sitpo
    ...    ELSE    Run Keyword    Go To Salesforce and Login2    Sales admin User devpo
    switching to classic app
    Log To Console    selecting account
    Go to Account2    ${target_account}
    ${new_opportunity_name}=    Run Keyword If    '${env}'=='sitpo'    create new opportunity sitpo    ${pricebook}
    ...    ELSE    Run Keyword    create new opportunity    ${pricebook}
    sleep    10s
    Log    the opportunity id is ${new_opportunity_name}
    Search Opportunity and click CPQ    ${new_opportunity_name}

Add Avainasiakaspalvelukeskus kertapalvelu
    [Documentation]    This is to add Avainasiakaspalvelukeskus kertapalvelu to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='${Avainasiakaspalvelukeskus kertapalvelu}']/div/div/div/div/div/button
    ${added_product}    Set Variable    //div[contains(@class,'cpq-item-no-children')]//span[text()='Avainasiakaspalvelukeskus kertapalvelu']
    sleep    10s
    click button    ${product_id}
    sleep    15s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${added_product}    20s
    Run Keyword If    ${status} == False    click button    ${product_id}
    Wait Until Element Is Visible    ${added_product}    20s
    Click_Settings_new    Avainasiakaspalvelukeskus kertapalvelu
    Update_settings    h    no

Add Avainasiakaspalvelukeskus varallaolo ja matkustus
    [Documentation]    This is to add Avainasiakaspalvelukeskus varallaolo ja matkustus to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TvFzQAK']/div/div/div/div/div/button
    ${added_product}    Set Variable    //div[contains(@class,'cpq-item-no-children')]//span[text()='Avainasiakaspalvelukeskus varallaolo ja matkustus']
    sleep    10s
    click button    ${product_id}
    sleep    15s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${added_product}    20s
    Run Keyword If    ${status} == False    click button    ${product_id}
    Wait Until Element Is Visible    ${added_product}    20s
    Click_Settings_new    Avainasiakaspalvelukeskus varallaolo ja matkustus
    Update_settings    h    no

Add Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu

    [Documentation]    This is to add Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu to cart and fill the required details
    [Arguments]    ${env}=devpo
    #${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TvGJQA0']/div/div/div/div/div/button
    #${added_product}    Set Variable    //div[contains(@class,'cpq-item-no-children')]//span[text()='Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu']
    #${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${added_product}    20s
    #Run Keyword If    ${status} == False    click button    ${product_id}
    #Wait Until Element Is Visible    ${added_product}    20s
    ${product_id}=    Set Variable    //div[contains(text(),'Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep    10s
    Click Button  //div[contains(text(),'Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu')]//following::button[1]
    sleep   5s
    Update_settings    h    no




Add Avainasiakaspalvelukeskus lisätyöt kertapalvelu

    [Documentation]    This is to add Avainasiakaspalvelukeskus lisätyöt kertapalvelu to cart and fill the required details
    [Arguments]    ${env}=devpo
    ${product_id}=    Set Variable    //div[contains(text(),'Avainasiakaspalvelukeskus lisätyöt kertapalvelu')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep    15s
    Click Button   //div[contains(text(),'Avainasiakaspalvelukeskus lisätyöt kertapalvelu')]//following::button[1]
    Update_settings    h    no

Add Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus

    [Documentation]    This is to add Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus to cart and fill the required details
    [Arguments]    ${env}=devpo
    #${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TvG9QAK']/div/div/div/div/div/button
    #${added_product}    Set Variable    //div[contains(@class,'cpq-item-no-children')]//span[text()='Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus']
        #${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${added_product}    20s
    #Run Keyword If    ${status} == False    click button    ${product_id}
    #Wait Until Element Is Visible    ${added_product}    20s
    ${product_id}=    Set Variable    //div[contains(text(),'Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep    15s
    click button    //div[contains(text(),'Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus')]//following::button[1]
    Update_settings    h    no

Add Koulutus jatkuva palvelu
    [Documentation]    This is to add \ Koulutus jatkuva palvelu to cart and fill the required details
    [Arguments]    ${env}=devpo
    Adding Product  Koulutus jatkuva palvelu
    #Click_Settings_new    Koulutus jatkuva palvelu
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Koulutus jatkuva palvelu
    ...    ELSE    Click_Settings_new    Koulutus jatkuva palvelu
    Update_settings    h    no

Add Koulutus kertapalvelu
    [Documentation]    This is to Add Koulutus kertapalvelu to cart and fill the required details
    [Arguments]    ${env}=devpo
    Adding Product  Koulutus kertapalvelu
    #Click_Settings_new    Koulutus kertapalvelu
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Koulutus kertapalvelu
    ...    ELSE    Click_Settings_new    Koulutus kertapalvelu
    Update_settings    h    no

Add Koulutus varallaolo ja matkustus

    [Documentation]    This is to add Koulutus varallaolo ja matkustus to cart and fill the required details
    [Arguments]    ${env}=devpo
    #${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TvGnQAK']/div/div/div/div/div/button
    #sleep    10s
    #click button    ${product_id}
    #Click_Settings_new    Koulutus varallaolo ja matkustus
    Adding Product      Koulutus varallaolo ja matkustus
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Koulutus varallaolo ja matkustus
    ...    ELSE    Click_Settings_new    Koulutus varallaolo ja matkustus
    Update_settings    h    no

Add Jatkuvuudenhallinta jatkuva palvelu
    [Documentation]    This is to add Jatkuvuudenhallinta jatkuva palvelu
    ...    to cart and fill the required details
    sleep    10s
    click button    ${CHILD_SETTINGS}
    Update_settings    h    no

Add Jatkuvuudenhallinta kertapalvelu
    [Documentation]    This is to add Jatkuvuudenhallinta kertapalvelu
    ...    to cart and fill the required details
    sleep    10s
    click button    ${CHILD_SETTINGS}
    Update_settings    h    no

Add Jatkuvuudenhallinta varallaolo ja matkustus
    [Documentation]    This is to Add Jatkuvuudenhallinta varallaolo ja matkustus
    ...    to cart and fill the required details
    sleep    10s
    click button    ${CHILD_SETTINGS}
    Update_settings    h    no

Add Palvelujohtaminen jatkuva palvelu
    [Documentation]    This is to Add Palvelujohtaminen jatkuva palvelu
    ...    to cart and fill the required details
    [Arguments]    ${env}=devpo

    #${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TwNsQAK']/div/div/div/div/div/button
    #sleep    10s
    #click button    ${product_id}
    #Click_Settings_new    Palvelujohtaminen jatkuva palvelu
    #Click_Settings_new    Koulutus varallaolo ja matkustus
    Adding Product      Palvelujohtaminen jatkuva palvelu
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Palvelujohtaminen jatkuva palvelu
    ...    ELSE    Click_Settings_new    Palvelujohtaminen jatkuva palvelu
    Update_settings    d    no

Add Palvelujohtaminen kertapalvelu
    [Documentation]    This is to Add Palvelujohtaminen kertapalvelu
    ...    to cart and fill the required details
    [Arguments]    ${env}=devpo
    #${product_id}=    Set Variable    //div[@data-product-id='01u6E000004n5tYQAQ']/div/div/div/div/div/button
    #sleep    10s
    #click button    ${product_id}
    #Click_Settings_new    Palvelujohtaminen kertapalvelu
    Adding Product      Palvelujohtaminen kertapalvelu
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Palvelujohtaminen kertapalvelu
    ...    ELSE    Click_Settings_new    Palvelujohtaminen kertapalvelu
    Update_settings    h    no

Add Palvelujohtaminen varallaolo ja matkustus
    [Documentation]    This is to Add Palvelujohtaminen varallaolo ja matkustus
    ...    to cart and fill the required details
    [Arguments]    ${env}=devpo
    #${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TwO2QAK']/div/div/div/div/div/button
    #sleep    10s
    #click button    ${product_id}
    #Click_Settings_new    Palvelujohtaminen varallaolo ja matkustus
    Adding Product      Palvelujohtaminen varallaolo ja matkustus
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Palvelujohtaminen varallaolo ja matkustus
    ...    ELSE    Click_Settings_new    Palvelujohtaminen varallaolo ja matkustus
    Update_settings    h    no


Complete Order
    [Documentation]    Used to update the order and complete order
    Log To Console    Complete Order
    ${complete_order}=    Set Variable    //td[@id='topButtonRow']/input[@value='Complete Item']
    ${update_order}=    Set Variable    //th[@scope='row']//a[text()='Work Order Update']    #//a[text()='Work Order Update']    #//a[text()='Order Finished']
    ${Orchestration Plan}=    Set Variable    //table/tbody/tr/td[@class='dataCol col02']/a[contains(text(),'Plan')]
    ${order}=    Set Variable    //div[@id='CF00N5800000CYwbi_ileinner']/a
    Wait Until Element Is Visible    //h2[text()='Orchestration Plan Detail']    120s
    Capture Page Screenshot
    sleep    3s
    Wait Until Element Is Visible    ${update_order}    120s
    ${order_id}    Get Text    ${order}
    Click Element    ${update_order}
    sleep    10s
    Wait Until Element Is Visible    ${complete_order}    120s
    Capture Page Screenshot
    click element    ${complete_order}
    sleep    10s
    [Return]    ${order_id}

Add Asiantuntijakäynti
    [Documentation]    This is to Add Asiantuntijakäynti
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000003Tw07QAC']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}

Add Pikatoimituslisä
    [Documentation]    This is to Add Pikatoimituslisä
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TwJaQAK']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}



Add Events jatkuva palvelu_devpo
    [Arguments]    ${Hinnoitteluperuste}
    [Documentation]    This is to Add Events jatkuva palvelu for devpo
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TwJkQAK']/div/div/div/div/div/button
    sleep    10s
    click button    ${ADD_CART}
    Click_Settings_new    Events jatkuva palvelu
    Update_settings    ${Hinnoitteluperuste}    no

Add Events jatkuva palvelu
    [Arguments]    ${Hinnoitteluperuste}  ${env}=devpo
    [Documentation]    This is to Add Events jatkuva palvelu for sitpo
    ...    to cart and fill the required details
    Adding Product   Events jatkuva palvelu
    sleep  10s
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Events jatkuva palvelu
    ...    ELSE    Click_Settings_new    Events jatkuva palvelu
    Update_settings    ${Hinnoitteluperuste}    no

Add Toimenpide XS
    [Documentation]    This is to Add Toimenpide XS for devpo
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide XS ')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    Click_Settings_new    Toimenpide XS
    Update_settings    h    no

Add Toimenpide XS sitpo
    [Documentation]    This is to Add Toimenpide XS
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide XS')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep   10s
    Click Button  //div[contains(text(),'Toimenpide XS')]//following::button[1]
    Update_settings    h    no

Add Toimenpide S
    [Documentation]    This is to Add Toimenpide S
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000004jytEQAQ']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    Click_Settings_new    Toimenpide S
    Update_settings    h    no

Add Toimenpide S sitpo
    [Documentation]    This is to Add Toimenpide S
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide S')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep   10s
    Click Button  //div[contains(text(),'Toimenpide S')]//following::button[1]
    Update_settings    h    no

Add Toimenpide M
    [Documentation]    This is to Add Toimenpide M
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000004jytdQAA']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    Click_Settings_new    Toimenpide M
    Update_settings    h    no

Add Toimenpide M sitpo
    [Documentation]    This is to Add Toimenpide M
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide M')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep   10s
    Click Button  //div[contains(text(),'Toimenpide M')]//following::button[1]
    Update_settings    h    no

Add Toimenpide L
    [Documentation]    This is to Add Toimenpide L
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000004jyu2QAA']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    Click_Settings_new    Toimenpide L
    Update_settings    h    no

Add Toimenpide L sitpo
    [Documentation]    This is to Add Toimenpide L
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide L')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep   10s
    Click Button  //div[contains(text(),'Toimenpide L')]//following::button[1]
    Update_settings    h    no

Add Toimenpide XL
    [Documentation]    This is to Add Toimenpide XL
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000004jyugQAA']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    Click_Settings_new    Toimenpide XL
    Update_settings    h    no

Add Toimenpide XL sitpo
    [Documentation]    This is to Add Toimenpide XL
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[contains(text(),'Toimenpide XL')]//following::button[1]
    sleep    10s
    click button    ${product_id}
    sleep   10s
    Click Button  //div[contains(text(),'Toimenpide XL')]//following::button[1]
    Update_settings    h    no

Account seletion
    [Documentation]    This is to search and select the account
    ${account_name}=    Set Variable    //p[contains(text(),'Search')]
    ${account_checkbox}=    Set Variable    //td[@class='slds-cell-shrink']//span[@class='slds-checkbox--faux']
    ${search_account_next_button}=    Set Variable    //div[@id='SearchAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    sleep    3s
    Wait Until Element Is Visible    ${account_name}    120s
    click element    ${account_name}
    sleep    3s
    Wait Until Element Is Visible    ${account_checkbox}    120s
    click element    ${account_checkbox}
    sleep    3s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${search_account_next_button}    120s
    Click Element    ${search_account_next_button}

select order contacts
    #${contact_search_title}=    Set Variable    //h3[text()='Contact Search']
    ${contact_search}=    Set Variable    //input[@id='OrderContactTA']
    ${contact_next_button}=    Set Variable    //div[@id='SelectOrderLevelContacts_nextBtn']
    ${updateContactDR}=    Set Variable    //button[@class='slds-button slds-button--neutral ng-binding ng-scope'][@ng-click='nextRepeater(child.nextIndex, child.indexInParent)']
    #Wait Until Element Is Visible    ${contact_search_title}    120s
    Wait Until Element Is Visible    ${contact_search}    120s
    Input Text    ${contact_search}    ${technical_contact}
    sleep    15s

    Page should contain element    xpath=//ng-form[@id='OrderContactTA-Block']/div/div/div/child/div/ng-form/div[2]/div/ul/li/a    30s
    Click Element    xpath=//ng-form[@id='OrderContactTA-Block']/div/div/div/child/div/ng-form/div[2]/div/ul/li/a
    Sleep    10s
    #Wait until element is visible  //input[@id='OCEmail']   30s
    #Input Text   //input[@id='OCEmail']   primaryemail@noemail.com
    #${order_name}    set variable    //input[@id='OrderContactDetailsTypeAhead']
    #${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${order_name}    5s
    #run keyword if    ${status} == True    update order details
    Click Element    ${contact_next_button}
    sleep   10s
    ${Status}=    Run Keyword and Return Status    Page should contain element    ${updateContactDR}
    Run Keyword if    ${status}    Click Element    ${updateContactDR}

Addtional data - Professional Products
    [Arguments]   ${prod_1}   ${prod_2}
    [Documentation]    Used for selecting \ requested action date for each parent product
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    sleep    60s

    ${status}    Run Keyword and Return Status    Page should contain element    //div[@class='ProductName2 ng-binding ng-scope'][contains(text(),'${prod_1}')]//following::input[2]
    Log to console    ${prod_1}
    Run Keyword if    ${status}    Pick Action Date with product    ${prod_1}
    ${status}    Run Keyword and Return Status    Page should contain element    //div[@class='ProductName2 ng-binding ng-scope'][contains(text(),'${prod_2}')]//following::input[2]
    Log to console    ${prod_2}
    Run Keyword if    ${status}    Pick Action Date with product     ${prod_2}
    sleep  10s
    Click Element    ${additional_info_next_button}


Addtional data
    [Documentation]    Used for selecting \ requested action date
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    sleep    120s
    ${status}    Run Keyword and Return Status    Page should contain element    //input[@id='RequestedActionDate']
    Log to console    ${status}
    Run Keyword if    ${status}    Pick Action Date
    Run Keyword Unless    ${status}    Click Element    ${additional_info_next_button}


Addtional data_2
    [Arguments]   ${prod_1}   ${prod_2}
    [Documentation]    Used for selecting \ requested action date
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    sleep    30s
    ${status}    Run Keyword and Return Status    Page should contain element    //input[@id='RequestedActionDate']
    Log to console    ${status}
    Run Keyword if    ${status}    Pick Action Date     ${prod_1}

    Run Keyword Unless    ${status}    Click Element    ${additional_info_next_button}
    Sleep   20s
    Pick Action Date    ${prod_2}
    sleep  20s
    Click Element    ${additional_info_next_button}


Pick Action Date with product
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
    #Click Element    ${additional_info_next_button}

Pick Action Date
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

Select Owner
    [Documentation]    Used to select the owner of the order
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

Create billing Account
    [Arguments]    ${target_account}
    ${billing_name}=    Set Variable    //input[@id='BillingName']
    ${invoice_method}=    Set Variable    //select[@id='InvoiceDeliveryMethod']
    ${billing_account_next_button}=    Set Variable    //div[@id='CreateBillingAccount_nextBtn']/p[contains(text(),'Next')]
    Wait Until Element Is Visible    ${billing_name}    120s
    input text    ${billing_name}    ${target_account}
    sleep    3s
    click element    ${invoice_method}
    click element    ${invoice_method} /option[@label='Paper Invoice']
    sleep    3s
    Capture Page Screenshot
    Click Element    ${billing_account_next_button}

Add Telia Domain Service Name
    [Documentation]    This is to add Telia Domain Service Name to cart and fill the required details
    ${Asiakkaan_verkkotunnus_Field}    set variable    //input[@name='productconfig_field_1_0']
    Wait for element to appear    3s
    Force click element    ${ADD_TO_CART}
    Capture Page Screenshot
    Wait Until Element Is Visible    ${SETTINGS_BTN}    240s
    Click Button    ${SETTINGS_BTN}
    Wait Until Element Is Visible    ${Asiakkaan_verkkotunnus_Field}    240s
    click element    ${Asiakkaan_verkkotunnus_Field}
    input text    ${Asiakkaan_verkkotunnus_Field}    Testrobot.fi
    Wait Until Element Is Visible    ${Käyttäjä_lisätieto_field}    240s
    click element    ${Käyttäjä_lisätieto_field}
    input text    ${Käyttäjä_lisätieto_field}    This is the test order created by robot framework.L1
    Wait Until Element Is Visible    ${Linkittyvä_tuote_field}    240s
    click element    ${Linkittyvä_tuote_field}
    input text    ${Linkittyvä_tuote_field}    This is the test order created by robot framework.L2
    Wait Until Element Is Visible    ${Sisäinen_kommentti_field}    240s
    click element    ${Sisäinen_kommentti_field}
    input text    ${Sisäinen_kommentti_field}    This is the test order created by robot framework.L3
    Wait Until Element Is Visible    ${Finnish_Domain_Service_Add_To_Cart}    240s
    click element    ${Finnish_Domain_Service_Add_To_Cart}
    Wait Until Element Is Visible    ${Finnish_Domain_Service_Settings_Icon}    240s
    force click element    ${Finnish_Domain_Service_Settings_Icon}
    Wait for element to appear    10s
    press enter on    ${Verkotunnus_Field}
    Wait for element to appear    2s
    click element    ${Verkotunnus_option}
    Wait for element to appear    5s
    press enter on    ${Voimassaoloaika_Field}
    Wait for element to appear    2s
    click element    ${Voimassaoloaika_option}
    Wait for element to appear    10s
    click element    ${DNS_PRIMARY}
    Wait for element to appear    10s

Place the order
    [Arguments]    ${account_name}
    [Documentation]    This is to submit the order after adding products to cart
    ${next_month_arrow}    set variable    //button[@title='Next Month']
    force click element    ${NEXT_BUTTON_CART}
    wait until element is visible    ${NEXT_BUTTON_UPDATE_PRODUCT}    240s
    click element    ${NEXT_BUTTON_UPDATE_PRODUCT}
    wait until element is visible    ${OPEN_QUOTE_BUTTON}    240s
    click element    ${OPEN_QUOTE_BUTTON}
    wait until element is visible    ${CPQ_BTN}    240s
    click element    ${CPQ_BTN}
    wait until element is visible    ${CREATE_ORDER_BTN}    240s
    click element    ${CREATE_ORDER_BTN}
    wait until element is visible    ${NEXT_BUTTON_CART_PAGE}    240s
    click element    ${NEXT_BUTTON_CART_PAGE}
    wait until element is visible    ${SEARCH_BUTTON_ACCOUNT}    240s
    click element    ${SEARCH_BUTTON_ACCOUNT}
    wait until element is visible    //div[text()='${account_name}']/../..//label//span[@class='slds-checkbox--faux']    240s
    click element    //div[text()='${account_name}']/../..//label//span[@class='slds-checkbox--faux']
    wait until element is visible    ${NEXT_BUTTON_ACCOUNT_SEARCH}    240s
    click element    ${NEXT_BUTTON_ACCOUNT_SEARCH}
    wait until element is visible    ${CONTACT_NAME_FIELD}    240s
    click element    ${CONTACT_NAME_FIELD}
    input text    ${CONTACT_NAME_FIELD}    John Doe
    Force click element    ${NEXT_BUTTON_SELECTCONTACT}
    wait until element is visible    ${REQUESTED_ACTION_DATE}    240s
    click element    ${REQUESTED_ACTION_DATE}
    wait until element is visible    ${next_month_arrow}    240s
    click element    ${next_month_arrow}
    wait until element is visible    ${CHOOSE_DATE_ONE}    240s
    click element    ${CHOOSE_DATE_ONE}
    sleep    2s
    click element    ${ADDITIONAL_DATA_NEXT_BTN}
    wait until element is visible    //div[contains(text(),'${account_name}') and contains(text(),'Billing')]/../..//label//input    240s
    Force click element    //div[contains(text(),'${account_name}') and contains(text(),'Billing')]/../..//label//input
    sleep    2s
    click element    ${BUYER_IS_PAYER}
    wait until element is visible    ${SELECT_BUYER_NEXT_BUTTON}    240s
    click element    ${SELECT_BUYER_NEXT_BUTTON}
    wait until element is visible    ${submit_order_button}
    click element    ${submit_order_button}
    wait until element is visible    ${ORCHESTRATION_PLAN_IMAGE}    240s

Search for a given account and click on Account
    [Arguments]    ${ACCOUNT_NAME_SALES}    ${ACCOUNT_NAME}
    Sleep    10s
    Wait Until Page Contains Element    ${SEARCH_FIELD_SALES}
    Input Text    ${SEARCH_FIELD_SALES}    ${ACCOUNT_NAME_SALES}
    Click Element    ${SEARCH_BUTTON_SALES}
    Sleep    5s
    Force click element    //a[contains(text(),'${ACCOUNT_NAME}')]
    Sleep    5s

Force click element
    [Arguments]    ${elementToClick}
    ${element_xpath}=    Replace String    ${elementToClick}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep    2s

click Visible Element
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    240 s
    Click Element    ${locator}

Wait for element to appear
    [Arguments]    ${time}
    sleep    ${time}

Edit_Details
    ${contact-name}=    set variable    //input[@id='CF00N5800000CZHUe']
    ${contact_name_lookup}=    set variable    //img[@title='Contact Name Lookup (New Window)']
    ${cpq}=    Set Variable    //input[@title='CPQ']
    Wait Until Element Is Visible    ${VIEW_BUTTON}    120s
    Click Element    ${VIEW_BUTTON}
    Wait Until Element Is Visible    ${EDIT_BUTTON}    120s
    click element    ${EDIT_BUTTON}
    Edit_fields    ${contact-name}    John Doe    ${contact_name_lookup}
    Name_lookup
    sleep    10s
    Click Save Button
    sleep    10s
    Click Element    ${cpq}
    sleep    10s

contact_lookup
    ${contact_name_lookup}=    set variable    //img[@title='Contact Lookup (New Window)']
    sleep    5s
    click element    ${contact_name_lookup}
    sleep    10s
    @{titles}=    Get Window Titles
    ${MAIN_WINDOW}=    Set Variable    @{titles}[0]
    ${child_window}=    set variable    @{titles}[1]
    Select Window    title=${child_window}
    sleep    10s
    Select Frame    id=resultsFrame
    Capture Page Screenshot
    sleep    3s
    Click Element    ${SHOW_ALL_RESULTS_BUTTON}
    sleep    7s
    click element    ${SELECT_CONTACT_NAME}
    sleep    5s
    Select Window    title=${MAIN_WINDOW}

Login to Salesforce as Sales admin User devpo
    Login To Salesforce    ${SALES_ADMIN_USER_DEVPO}    ${PASSWORD_DEVPO}

Add_child_product
    [Arguments]    ${child_product}
    ${child_cart}=    set variable    //div[@class='cpq-item-no-children'][contains(text(),'${child_product}')]/../../../div/button
    sleep    10s
    Click Element    ${child_cart}
    Wait Until Element Is Not Visible    ${SPINNER_SMALL}    120s
    sleep    10s

Click_Settings
    [Arguments]    ${product}
    ${added_product}    Set Variable    //div[contains(@class,'children')]//span[text()='${product}']
    sleep    15s
    Capture Page Screenshot
    Run Keyword And Continue On Failure    Wait Until Element Is Visible    ${added_product}    45s
    Capture Page Screenshot
    Click Button    ${SETTINGS}
    #@{locators}=    Get Webelements    xpath=${element}
    #${original}=    Create List
    #: FOR    ${locator}    IN    @{locators}
    #Click Element    xpath=${element}

Add Telia IP VPN NNI
    [Arguments]    ${product}
    ${product_id}=    Set Variable    //div[@data-product-id='${product}']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}

Add Telia IP VPN ACCESS
    [Arguments]    ${product}
    ${product_id}=    Set Variable    //div[@data-product-id='${product}']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}

checking the orchestration plan
    [Arguments]    ${order_id}
    Log To Console    checking the orchestration plan
    ${order_search}=    Set Variable    //div[@id='Order_body']/table/tbody//tr//th/a[text()='${order_id}']
    ${plan}=    set variable    //div[@id='CF00N5800000BWy1H_ileinner']/a
    Search Salesforce    ${order_id}
    Wait Until Element Is Visible    ${order_search}    30s
    Click Element    ${order_search}
    Wait Until Element Is Visible    ${plan}    60s
    Click Element    ${plan}
    sleep    15s
    Execute Javascript    window.scrollTo(0,250)
    Capture Page Screenshot

Order events update
    [Documentation]    Used to update the order and complete order
    ${complete_order}=    Set Variable    //td[@id='topButtonRow']/input[@value='Complete Item']
    ${order_events}=    Set Variable    //a[contains(text(),'Order Events Update')]    #//a[text()='Work Order Update']
    ${Orchestration Plan}=    Set Variable    //table/tbody/tr/td[@class='dataCol col02']/a[contains(text(),'Plan')]
    ${order}=    Set Variable    //div[@id='CF00N5800000CYwbi_ileinner']/a
    Wait Until Element Is Visible    //h2[text()='Orchestration Plan Detail']    120s
    Capture Page Screenshot
    sleep    3s
    Wait Until Element Is Visible    ${order_events}    120s
    Click Element    ${order_events}
    sleep    10s
    Wait Until Element Is Visible    ${complete_order}    120s
    Capture Page Screenshot
    click element    ${complete_order}
    sleep    10s

switching to classic app
    #//img[@class='icon noicon']
    ${settings_classic}    set variable    //span[@id='userNavLabel']
    ${switch_lighting}    Set Variable    //a[@title='Switch to Lightning Experience']
    ${setting_lighting}    Set Variable    //button[contains(@class,'userProfile-button')]
    ${switch_classic}    Set Variable    //a[text()='Switch to Salesforce Classic']
    ${search_button}    Set Variable    id=phSearchInput
    Log To Console    switching to classic app
    sleep    5s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${settings_classic}    60s
    run keyword if    ${status} == True    Click Element    ${settings_classic}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${switch_lighting}    30s
    run keyword if    ${status} == True    Click Element    ${switch_lighting}
    sleep    5s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${setting_lighting}    60s
    run keyword if    ${status} == True    Click Element    ${setting_lighting}
    sleep    10s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${switch_classic}    30s
    run keyword if    ${status} == True    Click Element    ${switch_classic}
    Wait Until Element Is Visible    ${search_button}    90s

Credit score validation
    ${next_but}    Set Variable    //form[@id='a1q6E000000SBKZQA4-27']//button[contains(text(),'Next')]
    ${central_spinner}    Set Variable    //div[@class='center-block spinner']
    wait until element is not visible    ${central_spinner}    120s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${next_but}    60s
    Run Keyword If    ${status} == True    click element    ${next_but}
    sleep    5s

View Open Quote
    ${open_quote}=    Set Variable    //button[@id='Open Quote']    #//button[@id='Open Quote']
    ${view_quote}    Set Variable    //button[@id='View Quote']
    ${quote}    Set Variable    //button[contains(@id,'Quote')]
    ${central_spinner}    Set Variable    //div[@class='center-block spinner']
    wait until element is not visible    ${central_spinner}    120s
    Wait Until Element Is Visible    ${quote}    120s
    ${quote_text}    get text    ${quote}
    ${open}    Run Keyword And Return Status    Should Be Equal As Strings    ${quote_text}    Open Quote
    ${view}    Run Keyword And Return Status    Should Be Equal As Strings    ${quote_text}    View Quote
    Run Keyword If    ${open} == True    click element    ${open_quote}
    Run Keyword If    ${view} == True    click element    ${view_quote}

Search and add Avainasiakaspalvelukeskus
    Search Products    Avainasiakaspalvelukeskus
    ${product_id}=    Set Variable    //div[@data-product-id='${Avainasiakaspalvelukeskus}']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    sleep    15s

Add Telia Crowd Insights
    [Arguments]    ${env}=devpo
    Adding Product    Telia Crowd Insights
    sleep    10s
    run keyword if    '${env}'=='sitpo'    Click_Settings    Telia Crowd Insights
    ...    ELSE    Click_Settings_new    Telia Crowd Insights
    Laskutuksen lisätieto_2
    click element    ${X_BUTTON}
    sleep    15s

Laskutuksen lisätieto_2
    ${Laskutuksen lisätieto_1}    Set Variable    //input[@name='productconfig_field_0_0']
    ${Laskutuksen lisätieto_2}    Set Variable    //input[@name='productconfig_field_0_1']
    ${Laskutuksen lisätieto_3}    Set Variable    //input[@name='productconfig_field_0_2']
    ${Laskutuksen lisätieto_4}    Set Variable    //input[@name='productconfig_field_0_3']
    ${Laskutuksen lisätieto_5}    Set Variable    //input[@name='productconfig_field_0_4']
    ${heading}    Set Variable    //h2[contains(text(),'Updated Telia')]
    Capture Page Screenshot
    Wait Until Element Is Visible    ${Laskutuksen lisätieto_1}    60s
    input text    ${Laskutuksen lisätieto_1}    L1
    Capture Page Screenshot
    ${update}    Run Keyword And Return Status    Wait Until Element Is Visible    ${heading}    60s
    Capture Page Screenshot
    Run Keyword If    ${update} == False    input text    ${Laskutuksen lisätieto_1}    L1
    sleep    3s
    Input Text    ${Laskutuksen lisätieto_2}    L2
    Capture Page Screenshot
    sleep    5s
    Capture Page Screenshot
    sleep    3s
    input text    ${Laskutuksen lisätieto_3}    L3
    sleep    3s
    input text    ${Laskutuksen lisätieto_4}    L4
    sleep    3s
    input text    ${Laskutuksen lisätieto_5}    L5
    sleep    3s

Add Telia Robotics
    [Arguments]    ${env}=devpo
    Adding Product    Telia Robotics
    run keyword if    '${env}'=='sitpo'    Click_Settings    Telia Robotics
    ...    ELSE    Click_Settings_new    Telia Robotics
    Laskutuksen lisätieto_2
    click element    ${X_BUTTON}
    sleep    15s

Add Telia Sign
    [Arguments]    ${env}=devpo
    log to console    adding products and updating configuration
    ${update}    Set Variable    //h2[contains(text(),'Updated Telia Sign')]
    ${Paketti}    set variable    //select[@name='productconfig_field_0_0']
    @{package}    Set Variable    paketti M    paketti L    paketti XL    paketti S
    @{cost}    Set Variable    62.00 €    225.00 €    625.00 €    10.00 €
    ${recurring_cost}    Set Variable    //span[contains(@ng-class,'cpq-item-discount-price')]
    sleep    10s
    Adding Product    Telia Sign
    run keyword if    '${env}'=='sitpo'    Click_Settings    Telia Sign
    ...    ELSE    Click_Settings_new    Telia Sign
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
    \    ${recurring_cost_value}    Get Text    ${recurring_cost}
    \    Log To Console    package name = ${package_name} | Package cost = ${package_cost} | Status = ${status} | \ The recurring cost displayed is ${recurring_cost_value}
    ${final package}    Evaluate    random.choice(${package})    random
    Log    the package selected is "${final package}"
    Select From List By Value    ${Paketti}    ${final package}
    click element    ${X_BUTTON}
    sleep    15s

Open Browser And Go To Login Page_PO
    [Arguments]    ${page}=${LOGIN_PAGE}
    #Create Webdriver    Firefox
    #Execute Manual Step    Change Proxy
    #Go to    ${page}
    Open Browser    ${page}    ${BROWSER}
    Maximize Browser Window
    log to console    browser open

Click_Settings_new
    [Arguments]    ${product}
    ${actions}    Set Variable    //div[@title='${product}']/../../../..//button[@title='Show Actions']
    ${configure}    set variable    //ul[@role='menu']/li[3]
    sleep    15s
    Capture Page Screenshot
    Wait until element is visible   ${actions}      60s
    click element    ${actions}
    Capture Page Screenshot
    Click Element    ${configure}
    #@{locators}=    Get Webelements    xpath=${element}
    #${original}=    Create List
    #: FOR    ${locator}    IN    @{locators}
    #Click Element    xpath=${element}

Login to Salesforce as Sales admin User sitpo
    Login To Salesforce    saleadm@teliacompany.com.sitpo    PahaPassu5

create new opportunity sitpo
    [Arguments]    ${pricebook}
    ${Details}    set variable    //span[@class='optionLabel'][text()='Details']
    ${opp_tab}    Set Variable    //span[text()='Opportunities']
    ${new_opportunity}=    set variable    //input[@name='newOpp']
    ${create_new}=    set variable    //div[@id='createNewButton']
    #${new_opportunity}=    Set Variable    //a[contains(@class,'opportunityMru')]/img[@title='Opportunity']
    ${continue_button}=    Set Variable    //input[@class='btn'][@title='Continue']
    ${opportunity_id}=    Set Variable    //input[@id='opp3']
    ${description}=    set variable    //textarea[@id='opp14']
    ${status}=    Set Variable    //select[@id='opp11']
    ${closing_date}=    Set Variable    //input[@id='opp9']
    ${pricing_list}=    Set Variable    //span/input[@id='CF00N5800000DyL67']
    ${DATE}=    Get Current Date    result_format=%d%m%Y%H%M
    ${contact}=    Set Variable    //input[@id='CF00N5800000CZNtx']
    ${opportunity_name}=    Set Variable    Test Robot Order_${DATE}
    log to console    new opportunity creation
    sleep    10s
    Wait Until Element Is Visible    ${Details}    60s
    click element    ${Details}
    Wait Until Element Is Visible    ${opp_tab}    60s
    Click Element    ${opp_tab}
    Wait Until Element Is Visible    ${new_opportunity}    60s
    Click Element    ${new_opportunity}
    Wait Until Element Is Visible    ${continue_button}    60s
    sleep    10s
    Capture Page Screenshot
    Click Element    ${continue_button}
    Wait Until Page Contains Element    //label[text()='Account Name']    120s
    Input Text    ${opportunity_id}    ${opportunity_name}
    Input Text    ${description}    ${opportunity_name}
    click element    ${status}
    click element    ${status}/option[@value='Analyse Prospect']
    input text    ${contact}    ${technical_contact}
    #contact_lookup
    sleep    5s
    ${close_date}=    Get Date From Future    30
    Input Text    ${closing_date}    ${close_date}
    Input Text    ${pricing_list}    ${pricebook}
    Click Save Button
    sleep    10s
    ${status}    Run Keyword and Return Status    Page Should contain Element    //h2[text()='Opportunity Edit']
    Run Keyword if    ${status}    Select from list by index    //select[@id='CF00N5800000CZNtx_lkid']    1
    ${status}    Run Keyword and Return Status    Page Should contain Element    //h2[text()='Opportunity Edit']
    Run Keyword if    ${status}    Click Save Button
    [Return]    ${opportunity_name}

Adding Product
    [Arguments]    ${product_name}
    ${product}    set variable    //span[@title='${product_name}']/../../..//button
    log to console    adding products and updating configuration
    sleep    10s
    click button    ${product}

update order details
    ${order_name}    set variable    //input[@id='OrderContactDetailsTypeAhead']
    ${order_email}    set variable    //input[@id='ContactEmail']
    input text    ${order_name}    John Doe
    input text    ${order_email}    abc@test.com

create order sitpo
    [Arguments]    ${target_account}
    [Documentation]    Used to create order after adding the products to the cart
    ${cart_next_button}=    Set Variable    //button/span[text()='Next']
    ${CPQ_next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    ${backCPQ}=    Set Variable    //button[@id='BackToCPQ']
    ${spinner}=    set variable    //div[contains(@class,'slds-spinner--brand')]
    ${sales_type}    set variable    //select[@ng-model='p.SalesType']
    Wait Until Element Is Visible    ${cart_next_button}    120s
    click element    ${cart_next_button}
    Wait Until Element Is Visible    ${backCPQ}    240s
    sleep    10s

    ${Count}=  GetElement Count    //select[@ng-model='p.SalesType']
    Log to console      No of products is ${count}
    Run Keyword IF  ${Count} != 1   Select From List By Value    (//select[@ng-model='p.SalesType'])[1]    New Money-New Services
    Run Keyword IF  ${Count} != 1     Select From List By Value    (//select[@ng-model='p.SalesType'])[2]    New Money-New Services
    ...     ELSE    Select From List By Value    ${sales_type}    New Money-New Services


    Capture Page Screenshot
    click button    ${CPQ_next_button}
    sleep    10s
    Credit score validation
    View Open Quote
    sleep  20s


    ${status}   set variable   Wait Until Element Is Enabled    //td[@id='topButtonRow']//input[@title='CPQ']    120s
    Run Keyword if   ${status}  click button    //td[@id='topButtonRow']//input[@title='CPQ']

    ${url}=    Get Location
    ${contains}=    Evaluate    'lightning' in '${url}'
    Run Keyword if    ${contains}    go to classic

    Log To Console    create order
    sleep    10s
    Wait Until Element Is Visible    ${CREATE_ORDER}    120s
    click element    ${CREATE_ORDER}
    sleep    10s
    Wait Until Element is Visible    //div[@class='col-md-3 col-sm-3 col-xs-12 vlc-next pull-right']//button    60s
    Click element    //div[@class='col-md-3 col-sm-3 col-xs-12 vlc-next pull-right']//button
    #Edit_Details
    Wait Until Element Is Visible    ${cart_next_button}    120s
    click element    ${cart_next_button}
    sleep    10s
    Wait Until Element Is Not Visible    ${spinner}    120s
    ${Status}=    Run Keyword and Return Status    Page should Contain element    //section[@id='OrderTypeCheck']/section/div/div/div/h1
    Run Keyword if    ${Status}    Close and Submit
    Run Keyword Unless    ${Status}    Enter Details

go to classic

    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${setting_lighting}    60s
    run keyword if    ${status} == True    Click Element    ${setting_lighting}
    sleep    10s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${switch_classic}    30s
    run keyword if    ${status} == True    Click Element    ${switch_classic}
    sleep  30s
    Wait until element is visible      //input[@id='phSearchInput']     60s
    Input Text  //input[@id='phSearchInput']  Test Robot Order_130820191648
    wait until element is visible   //div[@id='searchButtonContainer']  30s
    click Visible Element  //div[@id='searchButtonContainer']
    sleep  10s
    wait until element is visible   //tr[@class='dataRow even last first highlight']/th/a[text()='Test Robot Order_130820191648']   30s
    click element   //tr[@class='dataRow even last first highlight']/th/a[text()='Test Robot Order_130820191648']
    Wait Until Element Is Visible    ${cpq}    30s
    Click Element    ${cpq}



create order sitpo - Professional Products
    [Arguments]    ${target_account}    ${Product_count}    ${prod_1}   ${prod_2}
    [Documentation]    Used to create order after adding the products to the cart. Tackles Request Action date for each parent product
    ${cart_next_button}=    Set Variable    //button/span[text()='Next']
    ${CPQ_next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    ${backCPQ}=    Set Variable    //button[@id='BackToCPQ']
    ${spinner}=    set variable    //div[contains(@class,'slds-spinner--brand')]
    ${sales_type}    set variable    //select[@ng-model='p.SalesType']
    Wait Until Element Is Visible    ${cart_next_button}    120s
    click element    ${cart_next_button}
    Wait Until Element Is Visible    ${backCPQ}    240s
    sleep    10s
    ${Count}=  GetElement Count    //select[@ng-model='p.SalesType']
    Log to console      No of products is ${count}
    Run Keyword IF  ${Count} != 1   Select From List By Value    (//select[@ng-model='p.SalesType'])[1]    New Money-New Services
    Run Keyword IF  ${Count} != 1     Select From List By Value    (//select[@ng-model='p.SalesType'])[2]    New Money-New Services
    ...     ELSE    Select From List By Value    ${sales_type}    New Money-New Services
    Capture Page Screenshot
    click button    ${CPQ_next_button}
    sleep    10s
    Credit score validation
    View Open Quote
    sleep  10s

    ${url}=    Get Location
    ${contains}=    Evaluate    'lightning' in '${url}'
    Run Keyword if    ${contains}    go to classic

    Wait Until Element Is Enabled    //td[@id='topButtonRow']//input[@title='CPQ']    120s
    click button    //td[@id='topButtonRow']//input[@title='CPQ']
    Log To Console    create order
    sleep    10s
    Wait Until Element Is Visible    ${CREATE_ORDER}    120s
    click element    ${CREATE_ORDER}
    sleep    10s
    Wait Until Element is Visible    //div[@class='col-md-3 col-sm-3 col-xs-12 vlc-next pull-right']//button    60s
    Click element    //div[@class='col-md-3 col-sm-3 col-xs-12 vlc-next pull-right']//button
    #Edit_Details
    Wait Until Element Is Visible    ${cart_next_button}    120s
    click element    ${cart_next_button}
    sleep    10s
    Wait Until Element Is Not Visible    ${spinner}    120s
    ${Status}=    Run Keyword and Return Status    Page should Contain element    //section[@id='OrderTypeCheck']/section/div/div/div/h1
    Run Keyword if    ${Status}    Close and Submit
    Run Keyword Unless    ${Status}    Enter Details -Professional Products  ${Product_count}  ${prod_1}   ${prod_2}


Close and Submit

    ${submit_order}=    Set Variable    //span[text()='Yes']
    Click Element    //div[@id='Close']/p

    ${status}    Run Keyword and Return Status    Page Should contain Element    ${submit_order}    30s
    Run Keyword if    ${status}    click element    ${submit_order}
    sleep   10s

    ${status}    Run Keyword and Return Status    Page Should contain Element   //div[@id='Clone']//following::input[1]
    Run Keyword if  ${status}  click element  //div[@id='Clone']//following::input[1]

    ${url}=    Get Location
    ${contains}=    Evaluate    'lightning' in '${url}'
    Run Keyword if    ${contains}    click element    //div[@title='Submit Order']

Enter Details -Professional Products
    [Arguments]        ${Product_count}     ${prod_1}   ${prod_2}
    ${submit_order}=    Set Variable    //span[text()='Yes']
    Account seletion
    sleep    3s
    select order contacts
    sleep    3s
    Addtional data - Professional Products   ${prod_1}   ${prod_2}

    #Run Keyword IF    '${Product_count}' == '2'    Addtional data_2  ${prod_1}   ${prod_2}
    #...    ELSE    Run Keyword   Addtional data

    sleep    3s
    Select Owner
    sleep    10s

    ${status}    Run Keyword and Return Status    Page Should contain Element    ${submit_order}    30s
    Run Keyword if    ${status}    click element    ${submit_order}
    sleep   10s

    ${status}    Run Keyword and Return Status    Page Should contain Element   //div[@id='Clone']//following::input[1]
    Run Keyword if  ${status}  click element  //div[@id='Clone']//following::input[1]

    ${url}=    Get Location
    ${contains}=    Evaluate    'lightning' in '${url}'
    Run Keyword if    ${contains}    click element    //div[@title='Submit Order']

Enter Details
    ${submit_order}=    Set Variable    //span[text()='Yes']
    Account seletion
    sleep    3s
    select order contacts
    sleep    3s
    Addtional data
    sleep    3s
    Select Owner
    sleep    10s

    ${status}    Run Keyword and Return Status    Page Should contain Element    ${submit_order}    30s
    Run Keyword if    ${status}    click element    ${submit_order}
    sleep   10s

    ${status}    Run Keyword and Return Status    Page Should contain Element   //div[@id='Clone']//following::input[1]
    Run Keyword if  ${status}  click element  //div[@id='Clone']//following::input[1]

    ${url}=    Get Location
    ${contains}=    Evaluate    'lightning' in '${url}'
    Run Keyword if    ${contains}    click element    //div[@title='Submit Order']




select order contacts sitpo
    #${contact_search_title}=    Set Variable    //h3[text()='Contact Search']
    ${contact_search}=    Set Variable    //input[@id='OrderContactTA']
    ${contact_next_button}=    Set Variable    //div[@id='Select Contact_nextBtn']
    #Wait Until Element Is Visible    ${contact_search_title}    120s
    Wait Until Element Is Visible    ${contact_search}    120s
    Input Text    ${contact_search}    ${technical_contact}
    sleep    3s
    Capture Page Screenshot
    #${order_name}    set variable    //input[@id='OrderContactDetailsTypeAhead']
    #${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${order_name}    5s
    #run keyword if    ${status} == True    update order details
    Click Element    ${contact_next_button}

Submit Order Page
    sleep    40s
    ${url}=    Get Location
    ${contains}=    Evaluate    'lightning' in '${url}'
    Run Keyword unless    ${contains}    click element    //a[@class='switch-to-lightning']
    sleep    40s
    click element    //div[@title='Submit Order']
    Log to console    submitted
    Capture Page Screenshot

view orchestration plan sitpo
    sleep    30s
    #${orchestration_plans}    set variable    //span[@class='listTitle'][text()='Orchestration Plans']
    # ${orchestration_plans}    set variable    //li[@class='slds-breadcrumb__item']/span
    #${orchestraion_plan_details}    set variable    //h2[text()='Orchestration Plan Detail']
    #${orchestraion_plan_details}    set variable    //span[text()='Details']
    #${orchestration_plan_name}    set variable    //th[text()='Orchestration Plan Name']/../../tr/th[contains(@class,'dataCell')]/a
    Log To Console    view orchestration plan sitpo
    # Wait Until Element Is Visible    ${orchestration_plans}    120s
    # click element    ${orchestration_plans}
    # Wait Until Element Is Visible    ${orchestration_plan_name}    20s
    # click element    ${orchestration_plan_name}
    #sleep    10s
    #Wait Until Element Is Visible    ${orchestraion_plan_details}    60s
    Execute Javascript    window.scrollTo(0,100)
    sleep    10s
    Capture Page Screenshot

update telia robotics price sitpo
    ${recurring charge}    Set Variable    //span[contains(@ng-class,'switchpaymentmode')]
    ${adjustments}    Set Variable    //h2[text()='Adjustment']
    ${price}    Set Variable    //input[@id='adjustment-input-01']
    ${apply button}    Set Variable    //button[contains(text(),'Apply')]
    Log To Console    update telia robotics price sitpo
    Wait Until Element Is Visible    ${recurring charge}    60s
    click element    ${recurring charge}
    Wait Until Element Is Visible    ${adjustments}    60s
    Wait Until Element Is Visible    ${price}    60s
    input text    ${price}    30
    click element    ${apply button}
    sleep    10s
    Capture Page Screenshot

update telia robotics price devpo
    ${recurring charge}    Set Variable    //span[contains(@ng-class,'switchpaymentmode')]
    ${recurring_charge_edit}    Set Variable    //button[contains(@ng-click,'applyadjustment')]
    ${adjustments}    Set Variable    //h2[text()='Adjustment']
    ${price}    Set Variable    //input[@id='adjustment-input-01']
    ${apply button}    Set Variable    //button[contains(text(),'Apply')]
    ${charge_type_selector}    Set Variable    //button[contains(@ng-click,'dropdownAdjustmentOpen')]
    ${amount}    set variable    //span[text()='Amount']
    log to console    update telia robotics price devpo
    Wait Until Element Is Visible    ${recurring charge}    60s
    click element    ${recurring charge}
    Wait Until Element Is Visible    ${recurring_charge_edit}    60s
    click element    ${recurring_charge_edit}
    Wait Until Element Is Visible    ${adjustments}    60s
    sleep    5s
    click element    ${charge_type_selector}
    click element    ${amount}
    Wait Until Element Is Visible    ${price}    60s
    input text    ${price}    30
    click element    ${apply button}
    sleep    10s
    Capture Page Screenshot

update_setting1
    ${street_add1}    set variable    //input[@name='productconfig_field_1_0']
    ${street_add2}    set variable    //input[@name='productconfig_field_1_1']
    ${postal_code}    Set Variable    //input[@name='productconfig_field_1_3']
    Wait Until Element Is Visible    ${street_add1}    60s
    Press Key    ${street_add1}    This is a test opportunity
    sleep    10s
    Press Key    ${street_add2}    This is a test opportunity
    sleep    10s
    Press Key    ${postal_code}    00100
    sleep    10s
    Capture Page Screenshot

update_setting2
    ${street_add1-a}    set variable    //input[@name='productconfig_field_1_1']
    ${street_add2-a}    set variable    //input[@name='productconfig_field_1_2']
    ${postal_code-a}    set variable    //input[@name='productconfig_field_1_4']
    ${city_town-a}    set variable    //input[@name='productconfig_field_1_5']
    ${street_add1-b}    set variable    //input[@name='productconfig_field_1_8']
    ${street_add2-b}    set variable    //input[@name='productconfig_field_1_9']
    ${postal_code-b}    set variable    //input[@name='productconfig_field_1_11']
    ${city_town-b}    set variable    //input[@name='productconfig_field_1_12']
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
    Capture Page Screenshot

update_setting_Ethernet Nordic E-LAN EVP-LAN
    ${ Network bridge }    set variable    //input[@name='productconfig_field_0_5']
    Wait Until Element Is Visible    ${ Network bridge }    60s
    Press Key    ${ Network bridge }    This is a test opportunity
    helinsiki_address
    Capture Page Screenshot

update_setting_Ethernet Nordic HUB/E-NNI
    ${Service level}    Set Variable    //select[@name='productconfig_field_0_3']
    ${platinum}    Set Variable    //select[@name='productconfig_field_0_3']//option[contains(text(),'Platinum')]
    Wait Until Element Is Visible    ${Service level}    60s
    click element    ${Service level}
    click element    ${platinum}
    sleep    5s
    helinsiki_address
    Capture Page Screenshot

helinsiki_address
    ${street_add1}    set variable    //input[@name='productconfig_field_1_0']
    ${street_add2}    set variable    //input[@name='productconfig_field_1_1']
    ${postal_code}    Set Variable    //input[@name='productconfig_field_1_3']
    ${city}    set variable    //input[@name='productconfig_field_1_4']
    sleep    10s
    click element    ${street_add1}
    sleep    10s
    Press Key    ${street_add1}    This is a test opportunity
    sleep    10s
    click element    ${street_add2}
    sleep    10s
    Press Key    ${street_add2}    99
    sleep    10s
    Press Key    ${postal_code}    00100
    sleep    10s
    click element    ${city}
    sleep    10s
    Press Key    ${city}    helsinki
    sleep    30s

update_setting_Telia Ethernet subscription
    ${E_NNI-ID}    Set Variable    //input[@name='productconfig_field_0_6']
    ${E-NNI S-Tag VLAN}    Set Variable    //input[@name='productconfig_field_0_7']
    ${Interface}    Set Variable    //select[@name='productconfig_field_0_8']
    ${option}    Set Variable    ${Interface}//option[contains(text(),'10/100Base-TX')]
    sleep    5s
    Wait Until Element Is Visible    ${E_NNI-ID}    60s
    Press Key    ${E_NNI-ID}    10
    sleep    5s
    Click Element    ${E-NNI S-Tag VLAN}
    sleep    10s
    Press Key    ${E-NNI S-Tag VLAN}    100
    sleep    5s
    Click Element    ${Interface}
    Click Element    ${option}
    helinsiki_address
    Capture Page Screenshot


Add Ethernet Nordic Network Bridge
    [Arguments]    ${env}=devpo
    Adding Product    Ethernet Nordic Network Bridge
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Ethernet Nordic Network Bridge
    ...    ELSE    Click_Settings_new    Ethernet Nordic Network Bridge
    update_setting1
    click element    ${X_BUTTON}
    sleep    15s

Add Ethernet Nordic E-Line EPL
    [Arguments]    ${env}=devpo
    Adding Product    Ethernet Nordic E-Line EPL
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Ethernet Nordic E-Line EPL
    ...    ELSE    Click_Settings_new    Ethernet Nordic E-Line EPL
    update_setting2
    click element    ${X_BUTTON}
    sleep    15s

Add Ethernet Nordic E-LAN EVP-LAN
    [Arguments]    ${env}=devpo
    Adding Product    Ethernet Nordic E-LAN EVP-LAN
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Ethernet Nordic E-LAN EVP-LAN
    ...    ELSE    Click_Settings_new    Ethernet Nordic E-LAN EVP-LAN
    update_setting_Ethernet Nordic E-LAN EVP-LAN
    click element    ${X_BUTTON}
    sleep    15s

Add Ethernet Nordic HUB/E-NNI
    [Arguments]    ${env}=devpo
    Adding Product    Ethernet Nordic HUB/E-NNI
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Ethernet Nordic HUB/E-NNI
    ...    ELSE    Click_Settings_new    Ethernet Nordic HUB/E-NNI
    update_setting_Ethernet Nordic HUB/E-NNI
    click element    ${X_BUTTON}
    sleep    15s

Add Telia Ethernet subscription
    [Arguments]    ${env}=devpo
    Adding Product    Telia Ethernet Subscription
    run keyword if    '${env}'=='sitpo'    Click_Settings_sitpo_SAP    Telia Ethernet Subscription
    ...    ELSE    Click_Settings_new    Telia Ethernet Subscription
    update_setting_Telia Ethernet subscription
    click element    ${X_BUTTON}
    sleep    15s

Click_Settings_sitpo_SAP
    [Arguments]    ${product}
    ${added_product}    Set Variable    //button[contains(@class,'children')]//span[text()='${product}']
    sleep    20s
    Capture Page Screenshot
    #Wait Until Element Is Visible    ${added_product}    45s
    Capture Page Screenshot
    Click Button    ${SETTINGS}
    #@{locators}=    Get Webelements    xpath=${element}
    #${original}=    Create List
    #: FOR    ${locator}    IN    @{locators}
    #Click Element    xpath=${element}
