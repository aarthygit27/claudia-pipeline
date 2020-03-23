*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Variables.robot
Resource          ../../frontendsanity/resources/Common.robot
*** Keywords ***

ChangeThePriceList
    [Arguments]      ${price_list_new}
    ${price_list_old}=     get text        //span[text()='Price List']//following::a
    ${B2B_Price_list_delete_icon}=    Set Variable    //span[contains(text(),'PriceList__c')]/following::button[@title='Clear Selection'][1]
    ScrollUntillFound    //button[@title="Edit Price List"]
    Execute JavaScript    window.scrollTo(0,200)
    page should contain element  //span[text()='Price Book']//following::a[text()='Standard Price Book']
    wait until page contains element    //button[@title="Edit Price List"]  60s
    click element    //button[@title="Edit Price List"]
    wait until page contains element  ${B2B_Price_list_delete_icon}   20s
    scroll page to element  ${B2B_Price_list_delete_icon}
    force click element    ${B2B_Price_list_delete_icon}
    wait until page contains element    //input[@placeholder='Search Price Lists...']    60s
    input text    //input[@placeholder='Search Price Lists...']    ${price_list_new}
    sleep    3s
    click element    //*[@title='${price_list_new}']/../../..
    sleep  5s
    Wait until element is visible  //label[text()='Price Book']//following::button[@title="Save"]  30s
    click element   //label[text()='Price Book']//following::button[@title="Save"]
    #click element       //span[text()='Products With Manual Pricing']//following::span[text()='Save']
    sleep    3s
    execute javascript    window.scrollTo(0,0)
    wait until page contains element  //span[@class='test-id__field-label' and text()='Price List']/../..//a[text()='${price_list_new}']  60s
    page should contain element  //span[@class='test-id__field-label' and text()='Price List']/../..//a[text()='${price_list_new}']
    sleep    5s

ClickingOnCPQ
    [Arguments]    ${b}=${oppo_name}
    ##clcking on CPQ
    #log to console    ClickingOnCPQ
    Wait until keyword succeeds     30s     5s      click element    xpath=//a[@title='CPQ']
    #wait until page contains element    xpath=//h1[text()='${b}']    30s
    sleep    30s


AddProductToCart
    [Arguments]   ${pname}=${product_name}
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div[2]   60s
    sleep   5s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div[2]
    sleep  20s
    wait until page contains element  //div[@class='cpq-item-product']/div[@class='cpq-item-base-product']//following::div[@class='cpq-item-no-children']/span[normalize-space(.)='${pname}']   60s
    scrolluntillfound  //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    validateThePricesInTheCart   ${pname}
    click element   //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    unselect frame
    sleep  40s

validateThePricesInTheCart
    [Arguments]    ${product}
    #${OTC} =  get text  //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,"product-title")]//following::div[contains(@class,"currency-value")][2]/div/div/span/span
    #${RC} =   get text   //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,"product-title")]//following::div[contains(@class,"currency-value")][1]/div/div/span/span
    wait until page contains element    //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,'base-product')]//div[3]//span[@class='cpq-underline']       45s
    ${rc}=  get text  //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,'base-product')]//div[3]//span[@class='cpq-underline']
    ${nrc}=  get text  //span[normalize-space(.)='${product}']//ancestor::div[contains(@class,'base-product')]//div[5]//span[@class='cpq-underline']
    page should contain element  //div[normalize-space(.)='Monthly Recurring Total']/..//div[@class='slds-text-heading--medium'][normalize-space(.)='${rc}']
    page should contain element  //div[normalize-space(.)='OneTime Total']/..//div[@class='slds-text-heading--medium'][normalize-space(.)='${nrc}']
    #log to console  ${OTC}.this is OTC--${RC}.this is RC

search products
    [Arguments]    ${product}
    #log to console    AddingProductToCartAndClickNextButton
    sleep    15s
    Wait Until Element Is Enabled    //div[contains(@class,'slds')]/iframe    60s
    Select Frame    //div[contains(@class,'slds')]/iframe
    wait until page contains element    //div[contains(@class,'cpq-searchbox')]//input[contains(@class,'ng-valid')]    60s
    #sleep    10s
    input text    //div[contains(@class,'cpq-searchbox')]//input[contains(@class,'ng-valid')]    ${product}


Adding Yritysinternet Plus
    [Arguments]    ${Yritysinternet_Plus}
    #${product}=    Set Variable    //div[@data-product-id='${Yritysinternet_Plus}']/div/div/div/div/div/button
    ${product}=    Set Variable    //span[@title='${Yritysinternet_Plus}']/../../..//button
    ${SETTINGS}=    Set Variable    //button[@title='Settings']
    ${Liittymän_nopeus}    Set Variable   //select[@name='productconfig_field_0_1']
    ${Palvelutaso}    Set Variable    //select[@name='productconfig_field_0_2']
    ${X_BUTTON}=    Set Variable    //button[@class='slds-button slds-button--icon']
    Wait Until Element Is Visible    ${product}    60s
    Click Element    ${product}
    Sleep  30s
    Wait Until Element Is Visible    ${SETTINGS}    60s
    click element    ${SETTINGS}
    wait until element is visible  //select[@name='productconfig_field_0_0']  60s
    Select From List By Value     //select[@name='productconfig_field_0_0']     EXTRA ETHERNET
    Wait Until Element Is Visible    ${Liittymän_nopeus}    60s
    Select From List By Value    ${Liittymän_nopeus}    2 Mbit/s / 1 Mbit/s
    wait until element is visible  //select[@name='productconfig_field_0_3']  60s
    Select From List By Value     //select[@name='productconfig_field_0_3']    4
    wait until element is visible  //select[@name='productconfig_field_0_4']  60s
    Select From List By Value     //select[@name='productconfig_field_0_4']     Saatavuustieto tarkistettu järjestelmästä
    sleep    3s
    wait until element is visible  //input[@name="productconfig_field_0_6"]   60s
    input text  //input[@name="productconfig_field_0_6"]   L1.robotframework
    sleep  2s
    wait until element is visible  //input[@name="productconfig_field_0_7"]  60s
    input text  //input[@name="productconfig_field_0_7"]  L2.robotframework
    wait until element is visible  //input[@name="productconfig_field_0_8"]  60s
    input text  //input[@name="productconfig_field_0_8"]  L3.robotframework
    Select From List By Value    ${Palvelutaso}    A24h
    sleep    3s
    click element    ${X_BUTTON}
    Sleep  30s
    unselect frame

Adding DataNet Multi
    [Arguments]    ${DataNet_Multi}
    #${product}=    Set Variable    //span[@title='${DataNet_Multi}']/../../..//button
    ${product}=    Set Variable  //span[text()="HUOM! Pilotointiryhmän käyttöön DataNet Multi tilauslomake (nk. Kevytmallinnettu)"]//following::span[3][@title='${DataNet_Multi}']/../../..//button
    ${next_button}=    set variable    //span[contains(text(),'Next')]
    Wait Until Element Is Visible    ${product}    60s
    Click Element    ${product}
    sleep    30s
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    #Log to console      ${status}
    wait until page contains element    //span[text()='Next']/..    60s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    #Click Visible Element   ${next_button}
    unselect frame


UpdateAndAddSalesType for 2 products
    [Arguments]    ${product1}    ${product2}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_1}=    Set Variable    //td[normalize-space(.)='${product1}']
    ${product_2}=    Set Variable    //td[normalize-space(.)='${product2}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    #log to console    UpdateAndAddSalesType for 2 products
    sleep    30s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe   60s
    Run Keyword If    ${status} == False    Reload Page
    sleep    60s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    wait until page contains element    ${update_order}    60s
    #log to console    selected new frame
    wait until page contains element    ${product_1}    70s
    click element    ${product_1}//following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_1}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    sleep    5s
    wait until page contains element    ${product_2}    70s
    click element    ${product_2}//following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_2}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    Unselect Frame
    sleep    20s