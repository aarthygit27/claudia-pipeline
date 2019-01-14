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
    get time
    sleep    10s
    Take Screenshot
    Wait Until Element Is Visible    //table[@class='list']/tbody/tr[contains(@class,'dataRow')]/th/a[contains(text(),'${target_account}')]    600s
    get time
    Click Link    //table[@class='list']/tbody/tr[contains(@class,'dataRow')]/th/a[contains(text(),'${target_account}')]
    Unselect Frame
    Wait Until Element Is Visible    //a[@class='optionItem efpDetailsView ']    600s
    Click Element    //a[@class='optionItem efpDetailsView ']
    get time

create new opportunity
    [Arguments]    ${target_account}
    sleep    5s
    Click Element    //div[@id='createNewButton']
    Wait Until Element Is Visible    //a[contains(@class,'opportunityMru')]/img[@title='Opportunity']
    Click Element    //a[contains(@class,'opportunityMru')]/img[@title='Opportunity']
    Wait Until Element Is Enabled    //input[@class='btn'][@title='Continue']
    Capture Page Screenshot
    Click Button    //input[@class='btn'][@title='Continue']
    Wait Until Page Contains Element    //label[text()='Account Name']    120s
    ${DATE}=    Get Current Date    result_format=%d%m%Y%H%M
    ${opportunity_name}=    Set Variable    Test_Opportunity_${DATE}
    Input Text    //input[@id='opp3']    ${opportunity_name}
    Input Text    //textarea[@id='opp14']    This is a test opportunity
    click element    //select[@id='opp11']
    click element    //select[@id='opp11']/option[@value='Analyse Prospect']
    ${close_date}=    Get Date From Future    1
    Input Text    //input[@id='opp9']    ${close_date}
    Input Text    //span/input[@id='CF00N5800000DyL67']    b2b
    Click Save Button
    [Return]    ${opportunity_name}

Search Opportunity and click CPQ
    [Arguments]    ${opportunity_name}
    Search Salesforce    ${opportunity_name}
    Wait Until Element Is Visible    //div[@id='Opportunity_body']/table/tbody//tr//th/a[text()='${opportunity_name}']    30s
    Click Element    //div[@id='Opportunity_body']/table/tbody//tr//th/a[text()='${opportunity_name}']
    Wait Until Element Is Visible    //div[@id='customButtonMuttonButton']/span[text()='CPQ']    30s
    Click Element    //div[@id='customButtonMuttonButton']/span[text()='CPQ']
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
