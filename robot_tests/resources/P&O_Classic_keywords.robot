*** Settings ***
Resource          ..${/}resources${/}salesforce_keywords.robot
Resource          ..${/}resources${/}multibella_keywords.robot
Resource          ../${/}resources${/}salesforce_variables.robot
Library           Selenium2Library
Resource          ../${/}resources${/}P&O_Classic_variables.robot

*** Keywords ***
Go to Account2
    [Arguments]    ${target_account}
    ${account}=    Set Variable    //th/a[contains(text(),'${target_account}')]
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
    [Arguments]    ${target_account}
    ${create_new}=    set variable    //div[@id='createNewButton']
    ${new_opportunity}=    Set Variable    //a[contains(@class,'opportunityMru')]/img[@title='Opportunity']
    ${continue_button}=    Set Variable    //input[@class='btn'][@title='Continue']
    ${opportunity_id}=    Set Variable    //input[@id='opp3']
    ${description}=    set variable    //textarea[@id='opp14']
    ${status}=    Set Variable    //select[@id='opp11']
    ${closing_date}=    Set Variable    //input[@id='opp9']
    ${pricing_list}=    Set Variable    //span/input[@id='CF00N5800000DyL67']
    sleep    5s
    Click Element    ${create_new}
    Wait Until Element Is Visible    ${new_opportunity}
    Click Element    ${new_opportunity}
    Wait Until Element Is Enabled    ${continue_button}
    Capture Page Screenshot
    Click Button    ${continue_button}
    Wait Until Page Contains Element    //label[text()='Account Name']    120s
    ${DATE}=    Get Current Date    result_format=%d%m%Y%H%M
    ${opportunity_name}=    Set Variable    Test Robot Order_${DATE}
    Input Text    ${opportunity_id}    ${opportunity_name}
    Input Text    ${description}    Test Robot Order_${DATE}
    click element    ${status}
    click element    ${status}/option[@value='Analyse Prospect']
    ${close_date}=    Get Date From Future    30
    Input Text    ${closing_date}    ${close_date}
    Input Text    ${pricing_list}    b2b
    Click Save Button
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
    sleep    10s

Search Products
    [Arguments]    ${product_name}
    Wait Until Page Contains Element    //span[text()='PRODUCTS']    45s
    sleep    10s
    input text    //input[@placeholder='Search']    ${product_name}
    Capture Page Screenshot

Add Telia Arkkitehti jatkuva palvelu
    [Documentation]    This is to add Telia Arkkitehti jatkuva palvelu to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    d    yes

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
    [Documentation]    This is to add Muut asiantuntijapalvelut to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TwOCQA0']/div/div/div/div/div/button
    ${Laskutettava_toimenpide}=    Set Variable    //textarea[@name='productconfig_field_0_0']
    ${Kustannus}=    set variable    //input[@name='productconfig_field_0_1']
    ${Kilometrikorvaus}=    set variable    //div[contains(text(),'Kilometrikorvaus')]/../../../div/button[contains(@class,'slds-button slds-button_neutral')]
    ${Kilometrikorvaus_settings}=    set variable    //div[@ng-if='!importedScope.isProvisioningStatusDeleted(childProd, attrs.provisioningStatus)']//button[@title='Settings']
    ${Kilometrit}=    set variable    //input[@name='productconfig_field_0_1']
    sleep    25s
    Wait Until Element Is Visible    ${product_id}    45s
    click button    ${product_id}
    sleep    10s
    Capture Page Screenshot
    Click Button    ${SETTINGS}
    sleep    5s
    input text    ${Laskutettava_toimenpide}    This is the test order created by robot framework
    sleep    5s
    input text    ${Kustannus}    10000
    Fill Laskutuksen lisätieto
    sleep    5s
    click element    ${X_BUTTON}
    sleep    10s
    click element    ${Kilometrikorvaus}
    Wait Until Element Is Not Visible    ${SPINNER_SMALL}    120s
    sleep    10s
    click element    ${Kilometrikorvaus_settings}
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
    [Arguments]    ${field}    ${input}    ${data}    ${icon}
    [Documentation]    field location--> field which needs to be double clicked(generally ends with "ileinner") |
    ...    input location-->input text location |
    ...    data--> name of looked up
    ...    icon--> lookup icon
    sleep    5s
    Double Click Element    ${field}
    sleep    2s
    Wait Until Element Is Visible    ${input}    60s
    Input Text    ${input}    ${data}
    Click Element    ${icon}

Edit Billing details
    Wait Until Element Is Visible    //div[@id='CF00N5800000DyLfz_ileinner']    120s
    Execute Javascript    window.scrollTo(0,750)
    Capture Page Screenshot
    Edit_fields    //div[@id='CF00N5800000DyLfz_ileinner']    //input[@id='CF00N5800000DyLfz']    Billing Betonimestarit Oy    //a[@id='CF00N5800000DyLfzIcon']
    Name_lookup
    Edit_fields    //div[@id='CF00N5800000DyLg0_ileinner']    //input[@id='CF00N5800000DyLg0']    Billing Betonimestarit Oy    //a[@id='CF00N5800000DyLg0Icon']
    Name_lookup
    Edit_fields    //div[@id='CF00N5800000DyLg1_ileinner']    //input[@id='CF00N5800000DyLg1']    John Doe    //a[@id='CF00N5800000DyLg1Icon']
    Name_lookup
    Edit_fields    //div[@id='BillToContact_ileinner']    //input[@id='BillToContact']    John Doe    //a[@id='BillToContactIcon']
    Name_lookup
    Click Save Button

Go To Salesforce and Login2
    [Arguments]    ${user}
    Go to Salesforce
    Login To Salesforce And Close All Tabs2    ${user}

Login to Salesforce And Close All Tabs2
    [Arguments]    ${user}
    Run Keyword    Login to Salesforce as ${user}
    Run Keyword and Ignore Error    Wait For Load
    Close All Tabs

Login to Salesforce as Digisales User devpo
    Login To Salesforce    ${B2B_DIGISALES_USER_DEVPO}    ${PASSWORD_DEVPO}

create order
    [Arguments]    ${target_account}
    [Documentation]    Used to create order after adding the products to the cart
    ${cart_next_button}=    Set Variable    //button/span[text()='Next']
    ${CPQ_next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    ${backCPQ}=    Set Variable    //button[@id='BackToCPQ']
    ${open_quote}=    Set Variable    //button[@id='Open Quote']
    ${spinner}=    set variable    //div[contains(@class,'slds-spinner--brand')]
    ${submit_order}=    Set Variable    //p[text()='Submit Order']
    sleep    10s
    Wait Until Element Is Visible    ${cart_next_button}    120s
    click element    ${cart_next_button}
    Wait Until Element Is Visible    ${backCPQ}    240s
    click button    ${CPQ_next_button}
    sleep    10s
    Wait Until Element Is Visible    ${open_quote}    240s
    Click Button    ${open_quote}
    Wait Until Element Is Enabled    ${CPQ_BUTTON}    120s
    click button    ${CPQ_BUTTON}
    Wait Until Element Is Visible    ${CREATE_ORDER}    120s
    click element    ${CREATE_ORDER}
    sleep    10s
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
    create billing account    ${target_account}
    sleep    3s
    wait until element is visible    ${submit_order}    120s
    click element    ${submit_order}
    sleep    10s
    Capture Page Screenshot

view order
    Wait Until Element Is Visible    ${VIEW_BUTTON}    120s
    Click Element    ${VIEW_BUTTON}
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
    Wait Until Element Is Visible    ${SETTINGS}    45s
    Click Button    ${SETTINGS}
    sleep    10s
    Wait Until Element Is Visible    ${Hinnoitteluperuste}    30s
    ${check}=    Run Keyword And Return Status    click element    ${Hinnoitteluperuste}
    Run Keyword If    ${check}== True    click element    ${Hinnoitteluperuste}/option[contains(text(),'${option}')]
    click element    ${Henkilötyöaika}
    input text    ${Henkilötyöaika}    10
    sleep    5s
    click element    ${Palveluaika}
    sleep    5s
    click element    ${Palveluaika}/option[@value='10']
    sleep    5s
    Run Keyword And Ignore Error    click element    ${Laskuttaminen}
    sleep    5s
    Run Keyword And Ignore Error    click element    ${Laskuttaminen}/option[@value='10']
    sleep    5s
    ${compare}=    Run Keyword And Return Status    Should Be Equal As Strings    ${cbox}    yes
    Run Keyword If    ${compare}== True    click element    ${Työtilaus vaadittu}
    Fill Laskutuksen lisätieto
    click element    ${X_BUTTON}
    sleep    15s

Add Telia Konsultointi jatkuva palvelu
    [Documentation]    This is to add Telia Konsultointi jatkuva palvelu to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    d    yes

Add Telia Konsultointi varallaolo ja matkustus
    [Documentation]    This is to Telia Konsultointi varallaolo ja matkustus to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    yes

Update_settings2
    ${Palvelunhallintakeskus}=    Set Variable    //select[@name='productconfig_field_0_0']
    ${Henkilötyöaika}=    Set Variable    //input[@name='productconfig_field_0_1']
    ${Palveluaika}=    Set Variable    //select[contains(@name,'productconfig_field_0_2')]
    ${Laskuttaminen}=    Set Variable    //select[contains(@name,'productconfig_field_0_2')]
    ${Työtilaus vaadittu}=    Set Variable    //form[@name='productconfig']//span[@class='slds-form-element__label'][contains(text(),'Työtilaus vaadittu')]
    sleep    10s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${SETTINGS}    45s
    Click Button    ${SETTINGS}
    sleep    10s
    Wait Until Element Is Visible    ${Palvelunhallintakeskus}    30s
    click element    ${Palvelunhallintakeskus}
    click element    ${Palvelunhallintakeskus}//option[@value='20']
    sleep    5s
    click element    ${Työtilaus vaadittu}
    Fill Laskutuksen lisätieto
    click element    ${X_BUTTON}
    sleep    15s

Add Telia Projektijohtaminen jatkuva palvelu
    [Documentation]    This is to add \ Telia Projektijohtaminen jatkuva palvelu to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    d    yes

Add Telia Projektijohtaminen varallaolo ja matkustus
    [Documentation]    This is to add Telia Projektijohtaminen varallaolo ja matkustus to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    yes

Add Telia Palvelunhallintakeskus
    [Documentation]    This is to add \ Telia Palvelunhallintakeskus to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings2

Add Avainasiakaspalvelukeskus jatkuva palvelu
    [Documentation]    This is to add Avainasiakaspalvelukeskus jatkuva palvelu
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TvFpQAK']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    Update_settings    d    yes

General test setup
    [Arguments]    ${target_account}
    Go To Salesforce and Login2    Digisales User devpo
    Go To    ${CLASSIC_APP}
    Go to Account2    ${target_account}
    ${new_opportunity_name}=    Run Keyword    create new opportunity    ${target_account}
    #${new_opportunity_name}=    Set Variable    Test Robot Order_160120192214
    sleep    10s
    Log    the opportunity id is \ ${new_opportunity_name}
    Search Opportunity and click CPQ    ${new_opportunity_name}

Add Avainasiakaspalvelukeskus kertapalvelu
    [Documentation]    This is to add Avainasiakaspalvelukeskus kertapalvelu to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000004jyzbQAA']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    Update_settings    h    no

Add Avainasiakaspalvelukeskus varallaolo ja matkustus
    [Documentation]    This is to add Avainasiakaspalvelukeskus varallaolo ja matkustus to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TvFzQAK']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    Update_settings    h    no

Add Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu
    [Documentation]    This is to add Avainasiakaspalvelukeskus lisätyöt jatkuva palvelu to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TvGJQA0']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    Update_settings    h    no

Add Avainasiakaspalvelukeskus lisätyöt kertapalvelu
    [Documentation]    This is to add Avainasiakaspalvelukeskus lisätyöt kertapalvelu to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000004jyzqQAA']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    Update_settings    h    no

Add Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus
    [Documentation]    This is to add Avainasiakaspalvelukeskus lisätyöt varallaolo ja matkustus to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000003TvG9QAK']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    Update_settings    h    no

Add Koulutus jatkuva palvelu
    [Documentation]    This is to add \ Koulutus jatkuva palvelu to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    no

Add Koulutus kertapalvelu
    [Documentation]    This is to add \ Koulutus jatkuva palvelu to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    no

Add Koulutus varallaolo ja matkustus
    [Documentation]    This is to add \ Koulutus jatkuva palvelu to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    no

Add Jatkuvuudenhallinta jatkuva palvelu
    [Documentation]    This is to add Jatkuvuudenhallinta jatkuva palvelu
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    no

Add Jatkuvuudenhallinta kertapalvelu
    [Documentation]    This is to add Jatkuvuudenhallinta kertapalvelu
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    no

Add Jatkuvuudenhallinta varallaolo ja matkustus
    [Documentation]    This is to Add Jatkuvuudenhallinta varallaolo ja matkustus
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    no

Add Palvelujohtaminen jatkuva palvelu
    [Documentation]    This is to Add Palvelujohtaminen jatkuva palvelu
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    d    no

Add Palvelujohtaminen kertapalvelu
    [Documentation]    This is to Add Palvelujohtaminen kertapalvelu
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    no

Add Palvelujohtaminen varallaolo ja matkustus
    [Documentation]    This is to Add Palvelujohtaminen kertapalvelu
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    no

Add Hallinta ja Tuki jatkuva palvelu
    [Documentation]    This is to Add Hallinta ja Tuki jatkuva palvelu
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    d    no

Add Hallinta ja Tuki kertapalvelu
    [Documentation]    This is to Add Hallinta ja Tuki kertapalvelu
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    no

Add Hallinta ja Tuki varallaolo ja matkustus
    [Documentation]    This is to Add Hallinta ja Tuki varallaolo ja matkustus
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    no

Complete Order
    [Documentation]    Used to update the order and complete order
    ${complete_order}=    Set Variable    //td[@id='topButtonRow']/input[@value='Complete Item']
    ${update_order}=    Set Variable    //a[text()='Work Order Update']
    ${Orchestration Plan}=    Set Variable    //table/tbody/tr/td[@class='dataCol col02']/a[contains(text(),'Plan')]
    Wait Until Element Is Visible    //h2[text()='Orchestration Plan Detail']    120s
    Capture Page Screenshot
    sleep    3s
    Wait Until Element Is Visible    ${update_order}    120s
    Click Element    ${update_order}
    sleep    10s
    Wait Until Element Is Visible    ${Orchestration Plan}    120s
    ${plan_id}=    Get Text    ${Orchestration Plan}
    Log    The plan created is ${plan_id}
    sleep    3s
    Wait Until Element Is Visible    ${complete_order}    120s
    click element    ${complete_order}
    sleep    10s

Add Asiantuntijakäynti
    [Documentation]    This is to Add Asiantuntijakäynti
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}

Add Pikatoimituslisä
    [Documentation]    This is to Add Pikatoimituslisä
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}

Add Events jatkuva palvelu
    [Arguments]    ${Hinnoitteluperuste}
    [Documentation]    This is to Add Events jatkuva palvelu
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    ${Hinnoitteluperuste}    no

Add Toimenpide XS
    [Documentation]    This is to Add Toimenpide XS
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    no

Add Toimenpide S
    [Documentation]    This is to Add Toimenpide S
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000004jytEQAQ']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    Update_settings    h    no

Add Toimenpide M
    [Documentation]    This is to Add Toimenpide M
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000004jytdQAA']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    Update_settings    h    no

Add Toimenpide L
    [Documentation]    This is to Add Toimenpide L
    ...    to cart and fill the required details
    ${product_id}=    Set Variable    //div[@data-product-id='01u6E000004jyu2QAA']/div/div/div/div/div/button
    sleep    10s
    click button    ${product_id}
    Update_settings    h    no

Add Toimenpide XL
    [Documentation]    This is to Add Toimenpide XL
    ...    to cart and fill the required details
    sleep    10s
    click button    ${ADD_CART}
    Update_settings    h    no
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
    Wait Until Element Is Visible    ${search_account_next_button}    120s
    Click Element    ${search_account_next_button}

select order contacts
    ${contact_search_title}=    Set Variable    //h3[text()='Contact Search']
    ${contact_search}=    Set Variable    //input[@id='ContactName2']
    ${contact_next_button}=    Set Variable    //div[@id='SelectOrderLevelContacts_nextBtn']
    Wait Until Element Is Visible    ${contact_search_title}    120s
    Wait Until Element Is Visible    ${contact_search}    120s
    Input Text    ${contact_search}    ${technical_contact}
    Click Element    ${contact_next_button}

Addtional data
    [Documentation]    Used for selecting \ requested action date
    ${date_id}=    Set Variable    id=RequestedActionDate
    ${next_month}=    Set Variable    //button[@title='Next Month']
    ${firstday}=    Set Variable    //span[contains(@class,'slds-day nds-day')][text()='01']
    ${additional_info_next_button}=    Set Variable    //div[@id='Additional data_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    Wait Until Element Is Visible    ${date_id}    120s
    Click Element    ${date_id}
    Wait Until Element Is Visible    ${next_month}    120s
    Click Button    ${next_month}
    click element    ${firstday}
    sleep    3s
    Click Element    ${additional_info_next_button}

Select Owner
    [Documentation]    Used to select the owner of the order
    ${buyer_payer}=    Set Variable    //input[@id='BuyerIsPayer']/../span
    ${buyer_account_next_button}=    Set Variable    //div[@id='SelectedBuyerAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    Wait Until Element Is Visible    ${buyer_payer}    120s
    click element    ${buyer_payer}
    sleep    3s
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
    Click Element    ${billing_account_next_button}
