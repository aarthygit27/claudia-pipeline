*** Settings ***
Resource          ..${/}resources${/}salesforce_keywords.robot
Resource          ..${/}resources${/}multibella_keywords.robot
Resource          ../${/}resources${/}salesforce_variables.robot
Library           Selenium2Library
Resource          ../${/}resources${/}P&O_Classic_variables.robot

*** Keywords ***
Go to Account2
    [Arguments]    ${target_account}
    Log    Going to '${target_account}'
    Search Salesforce    ${target_account}
    #sleep    10s
    #Select Frame    //iframe[@title='sessionserver']
    Wait Until Element Is Visible    //th/a[contains(text(),'${target_account}')]    60s    //th/a[contains(text(),'${target_account}')]
    Click Link    //th/a[contains(text(),'${target_account}')]
    Unselect Frame
    Wait Until Element Is Visible    //a[@class='optionItem efpDetailsView ']    60s
    Click Element    //a[@class='optionItem efpDetailsView ']

create new opportunity
    [Arguments]    ${target_account}  ${future_date}
    sleep    5s
    Click Element    //div[@id='createNewButton']
    Wait Until Element Is Visible    //a[contains(@class,'opportunityMru')]/img[@title='Opportunity']
    Click Element    //a[contains(@class,'opportunityMru')]/img[@title='Opportunity']
    Wait Until Element Is Enabled    //input[@class='btn'][@title='Continue']
    Capture Page Screenshot
    Click Button    //input[@class='btn'][@title='Continue']
    Wait Until Page Contains Element    //label[text()='Account Name']    120s
    ${DATE}=    Get Current Date    result_format=%d%m%Y%H%M
    ${OPPORTUNITY_NAME_TEXT}=  catenate  Test_Opportunity_  ${DATE}
    Set Test Variable    ${opportunity_name}    ${OPPORTUNITY_NAME_TEXT}
    Input Text    ${CREATE_OPPORTUNITY_NAME_FIELD}    ${opportunity_name}
    Input Text        ${CREATE_OPPORTUNITY_DESCRIPTION}    This is a test opportunity
    click element    ${CREATE_OPPORTUNITY_STAGE}
    click element    ${CREATE_OPPORTUNITY_STAGE_SELECTION}
    ${close_date}=    Get Date From Future    ${future_date}
    Input Text    ${CREATE_OPPORTUNITY_DATE}    ${close_date}
    Input Text    ${CREATE_OPPORTUNITY_PRICE_LIST}    b2b
    Click Save Button
    sleep  5s
    #[Return]    ${opportunity_name}

Search Opportunity and click CPQ
    #[Arguments]    ${opportunity_name}
    Search Salesforce    ${opportunity_name}
    Wait Until Element Is Visible    //div[@id='Opportunity_body']/table/tbody//tr//th/a[text()='${opportunity_name}']    30s
    Click Element    //div[@id='Opportunity_body']/table/tbody//tr//th/a[text()='${opportunity_name}']
    Wait Until Element Is Visible    ${CPQ_BUTTON_CREATE_OPPORTUNITY}    30s
    Click Element    ${CPQ_BUTTON_CREATE_OPPORTUNITY}
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
    click button    //button[contains(text(),'Add to Cart')]
    sleep    10s
    Capture Page Screenshot
    Wait Until Element Is Visible    //button[@title='Settings']    45s
    Click Button    //button[@title='Settings']
    sleep    10s
    Wait Until Element Is Enabled    //select[@name='productconfig_field_0_0']    30s
    click element    //select[@name='productconfig_field_0_0']
    sleep    10s
    click element    //select[@name='productconfig_field_0_0']/option[contains(text(),'d')]
    input text    //input[@name='productconfig_field_0_1']    10
    sleep    5s
    click element    //select[contains(@name,'productconfig_field_0_2')]
    sleep    5s
    click element    //select[contains(@name,'productconfig_field_0_2')]/option[@value='10']
    sleep    5s
    click element    //select[contains(@name,'productconfig_field_0_3')]
    sleep    5s
    click element    //select[contains(@name,'productconfig_field_0_3')]/option[@value='10']
    sleep    5s
    click element    //form[@name='productconfig']//span[@class='slds-form-element__label'][contains(text(),'Työtilaus vaadittu')]
    Fill Laskutuksen lisätieto
    click element    //button[@class='slds-button slds-button--icon']
    sleep    15s

Fill Laskutuksen lisätieto
    input text    //input[@name='productconfig_field_1_0']    This is the test order created by robot framework.L1
    sleep    3s
    input text    //input[@name='productconfig_field_1_1']    This is the test order created by robot framework.L2
    sleep    3s
    input text    //input[@name='productconfig_field_1_2']    This is the test order created by robot framework.L3
    sleep    3s
    input text    //input[@name='productconfig_field_1_3']    This is the test order created by robot framework.L4
    sleep    3s
    input text    //input[@name='productconfig_field_1_4']    This is the test order created by robot framework.L5
    sleep    3s

Add Muut asiantuntijapalvelut
    [Documentation]    This is to add Muut asiantuntijapalvelut to cart and fill the required details
    sleep    25s
    Wait Until Element Is Visible    //div[@data-product-id='01u6E000003TwOCQA0']/div/div/div/div/div/button    45s
    click button    //div[@data-product-id='01u6E000003TwOCQA0']/div/div/div/div/div/button
    sleep    10s
    Capture Page Screenshot
    Click Button    //button[@title='Settings']
    sleep    5s
    input text    //textarea[@name='productconfig_field_0_0']    This is the test order created by robot framework
    sleep    5s
    input text    //input[@name='productconfig_field_0_1']    10000
    Fill Laskutuksen lisätieto
    sleep    5s
    click element    //button[@class='slds-button slds-button--icon']
    sleep    10s
    click element    //div[contains(text(),'Kilometrikorvaus')]/../../../div/button[contains(@class,'slds-button slds-button_neutral')]
    Wait Until Element Is Not Visible    //div[contains(@class,'small button-spinner')]    120s
    sleep    10s
    click element    //div[@ng-if='!importedScope.isProvisioningStatusDeleted(childProd, attrs.provisioningStatus)']//button[@title='Settings']
    input text    //input[@name='productconfig_field_0_1']    100
    sleep    5s
    Fill Laskutuksen lisätieto
    sleep    5s
    click element    //button[@class='slds-button slds-button--icon']

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

Add Telia Domain Service Name
    [Documentation]    This is to add Telia Domain Service Name to cart and fill the required details
    sleep    10s
    click button  ${ADD_TO_CART}
    sleep    10s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${SETTINGS_BTN}    45s
    Click Button    ${SETTINGS_BTN}
    sleep  10s
    Wait Until Element Is Enabled    ${Asiakkaan_verkkotunnus_Field}    30s
    click element    ${Asiakkaan_verkkotunnus_Field}
    input text       ${Asiakkaan_verkkotunnus_Field}  Testrobot.fi
    sleep    5s
    click element    ${Käyttäjä_lisätieto_field}
    sleep    5s
    input text       ${Käyttäjä_lisätieto_field}        This is the test order created by robot framework.L1
    sleep    5s
    click element    ${Linkittyvä_tuote_field}
    input text       ${Linkittyvä_tuote_field}   This is the test order created by robot framework.L2
    sleep    5s
    click element    ${Sisäinen_kommentti_field}
    sleep    5s
    input text       ${Sisäinen_kommentti_field}  This is the test order created by robot framework.L3
    sleep  5s
    click element    ${Finnish_Domain_Service_Add_To_Cart}
    sleep    10s
    force click element  ${Finnish_Domain_Service_Settings_Icon}
    sleep    10s
    press enter on  ${Verkotunnus_Field}
    sleep    5s
    click element   ${Verkotunnus_option}
    sleep  5s
    press enter on  ${Voimassaoloaika_Field}
    sleep    5s
    click element  ${Voimassaoloaika_option}
    sleep  10s
    click element  ${DNS_PRIMARY}
    sleep  10s


Place the order
    [Arguments]    ${account_name}
    force click element    ${NEXT_BUTTON_CART}
    sleep  10s
    wait until element is visible  ${NEXT_BUTTON_UPDATE_PRODUCT}  240s
    click element  ${NEXT_BUTTON_UPDATE_PRODUCT}
    sleep  5s
    wait until element is visible  ${OPEN_QUOTE_BUTTON}  240s
    click element  ${OPEN_QUOTE_BUTTON}
    wait until element is visible  ${CPQ_BTN}  240s
    click element  ${CPQ_BTN}
    sleep  5s
    wait until element is visible  ${CREATE_ORDER_BTN}  240s
    click element  ${CREATE_ORDER_BTN}
    sleep  10s
    wait until element is visible  ${NEXT_BUTTON_CART_PAGE}  240s
    click element  ${NEXT_BUTTON_CART_PAGE}
    sleep  5s
    wait until element is visible  ${SEARCH_BUTTON_ACCOUNT}  240s
    click element  ${SEARCH_BUTTON_ACCOUNT}
    wait until element is visible  //div[text()='${account_name}']/../..//label//span[@class='slds-checkbox--faux']  240s
    click element  //div[text()='${account_name}']/../..//label//span[@class='slds-checkbox--faux']
    wait until element is visible  ${NEXT_BUTTON_ACCOUNT_SEARCH}  240s
    click element  ${NEXT_BUTTON_ACCOUNT_SEARCH}
    wait until element is visible  ${CONTACT_NAME_FIELD}  240s
    click element  ${CONTACT_NAME_FIELD}
    input text  ${CONTACT_NAME_FIELD}  John Doe
    force click element  ${NEXT_BUTTON_SELECTCONTACT}
    wait until element is visible  ${REQUESTED_ACTION_DATE}  240s
    click element  ${REQUESTED_ACTION_DATE}
    wait until element is visible  ${next_month_arrow}  60s
    click element  ${next_month_arrow}
    wait until element is visible  ${CHOOSE_DATE_ONE}  240s
    click element  ${CHOOSE_DATE_ONE}
    sleep  2s
    click element  ${ADDITIONAL_DATA_NEXT_BTN}
    wait until element is visible  //div[contains(text(),'${account_name}') and contains(text(),'Billing')]/../..//label//input  240s
    force click element  //div[contains(text(),'${account_name}') and contains(text(),'Billing')]/../..//label//input
    sleep  2s
    click element  ${BUYER_IS_PAYER}
    wait until element is visible  ${SELECT_BUYER_NEXT_BUTTON}  240s
    click element  ${SELECT_BUYER_NEXT_BUTTON}
    wait until element is visible  ${submit_order_button}
    click element  ${submit_order_button}
    wait until element is visible  ${ORCHESTRATION_PLAN_IMAGE}  240s

Search for a given account and click on Account
     [Arguments]  ${ACCOUNT_NAME_SALES}  ${ACCOUNT_NAME}

     Sleep  10s
     Wait Until Page Contains Element  ${SEARCH_FIELD_SALES}
     Input Text  ${SEARCH_FIELD_SALES}  ${ACCOUNT_NAME_SALES}
     Click Element  ${SEARCH_BUTTON_SALES}
     Sleep  5s
     Force click element  //a[contains(text(),'${ACCOUNT_NAME}')]
     Sleep  5s
Force click element
    [Arguments]    ${elementToClick}
    ${element_xpath}=    Replace String    ${elementToClick}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Sleep    2s
