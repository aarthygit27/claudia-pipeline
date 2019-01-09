*** Settings ***
Resource          ..${/}resources${/}salesforce_keywords.robot
Resource          ..${/}resources${/}multibella_keywords.robot
Resource          ../${/}resources${/}salesforce_variables.robot
Library           Selenium2Library

*** Keywords ***
Go to Account2
    [Arguments]    ${target_account}
    Log    Going to '${target_account}'
    Search Salesforce    ${target_account}
    #sleep    10s
    #Select Frame    //iframe[@title='sessionserver']
    Wait Until Element Is Visible    //table[@class='list']/tbody/tr[contains(@class,'dataRow')]/th/a[contains(text(),'${target_account}')]    45s
    Click Link    //table[@class='list']/tbody/tr[contains(@class,'dataRow')]/th/a[contains(text(),'${target_account}')]
    Unselect Frame
    Wait Until Element Is Visible    //a[@class='optionItem efpDetailsView ']
    Click Element    //a[@class='optionItem efpDetailsView ']

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
    Click Button    //button[@title='Settings']
    sleep    10s
    Wait Until Element Is Enabled    //select[@name='productconfig_field_0_0']
    click element    //select[@name='productconfig_field_0_0']
    click element    //select[@name='productconfig_field_0_0']/option[contains(text(),'d')]
    input text    //input[@name='productconfig_field_0_1']    10
    click element    //select[contains(@name,'productconfig_field_0_2')]
    click element    //select[contains(@name,'productconfig_field_0_2')]/option[@value='10']
    click element    //select[contains(@name,'productconfig_field_0_3')]
    click element    //select[contains(@name,'productconfig_field_0_3')]/option[@value='10']
    click element    //form[@name='productconfig']//span[@class='slds-form-element__label'][contains(text(),'Työtilaus vaadittu')]
    Fill Laskutuksen lisätieto
    click element    //button[@class='slds-button slds-button--icon']
    sleep    15s

Fill Laskutuksen lisätieto
    input text    //input[@name='productconfig_field_1_0']    This is the test order created by robot framework.L1
    input text    //input[@name='productconfig_field_1_1']    This is the test order created by robot framework.L2
    input text    //input[@name='productconfig_field_1_2']    This is the test order created by robot framework.L3
    input text    //input[@name='productconfig_field_1_3']    This is the test order created by robot framework.L4
    input text    //input[@name='productconfig_field_1_4']    This is the test order created by robot framework.L5

Add Muut asiantuntijapalvelut
    [Documentation]    This is to add Muut asiantuntijapalvelut to cart and fill the required details
    sleep    10s
    Wait Until Element Is Visible    //div[@data-product-id='01u6E000003TwOCQA0']/div/div/div/div/div/button    45s
    click button    //div[@data-product-id='01u6E000003TwOCQA0']/div/div/div/div/div/button
    sleep    10s
    Capture Page Screenshot
    Click Button    //button[@title='Settings']
    input text    //textarea[@name='productconfig_field_0_0']    This is the test order created by robot framework
    input text    //input[@name='productconfig_field_0_1']    10000
    Fill Laskutuksen lisätieto
    click element    //button[@class='slds-button slds-button--icon']
    sleep    10s
    click element    //div[contains(text(),'Kilometrikorvaus')]/../../../div/button[contains(@class,'slds-button slds-button_neutral')]
    Wait Until Element Is Not Visible    //div[contains(@class,'small button-spinner')]    120s
    sleep    10s
    click element    //div[@ng-if='!importedScope.isProvisioningStatusDeleted(childProd, attrs.provisioningStatus)']//button[@title='Settings']
    input text    //input[@name='productconfig_field_0_1']    100
    Fill Laskutuksen lisätieto
    click element    //button[@class='slds-button slds-button--icon']

Name_lookup
    ${main_window}=    Get Title
    sleep    5s
    Select Window    title=Search ~ Salesforce - Unlimited Edition
    Select Frame    id=resultsFrame
    Capture Page Screenshot
    sleep    3s
    click element    //table[@class='list']/tbody/tr[contains(@class,'dataRow')]/th/a
    sleep    5s
    Select Window    title=${main_window}

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
