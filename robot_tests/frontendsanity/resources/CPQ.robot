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
    Sleep  20s

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

Add product to cart (CPQ)
    [Documentation]     In the CPQ cart search for the wanted product and add it to the cart
    [Arguments]    ${pname}=${product_name}
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    ${CPQ_SEARCH_FIELD}    60s
    input text    ${CPQ_SEARCH_FIELD}    ${pname}
    Wait element to load and click  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    wait until page contains element    //button/span[text()='${pname}']   60s
    #scrolluntillfound    ${CPQ_CART_NEXT_BUTTON}
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    #Log to console      ${status}
    wait until page contains element    //span[text()='Next']/..    100s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    #click element    ${CPQ_CART_NEXT_BUTTON}
    unselect frame
    sleep    30s


Update products
    [Documentation]     Create Quote in draft status in the post-CPQ omniscript
    ${iframe}   Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    ${Viwe_quote}=    Set Variable    //button[@title="View Quote"]
    ${open_quote}=    Set Variable   //button[@title="Open Quote"]
    Wait Until Element Is Enabled   ${iframe}   80s
    select frame    ${iframe}
    #Wait until page contains element    ${SERVICE_CONTRACT_WARNING}     60s
    Wait element to load and click      ${SALES_TYPE_DROPDOWN}
    Click element   ${NEW_MONEY_NEW_SERVICES}
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    sleep   50s
    unselect frame
    Wait until page contains element    //h1/div[@title='${OPPORTUNITY_NAME}']  30s


Adding Telia Colocation
    [Arguments]   ${pname}=${product_name}
    #Log to console      adding product
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    sleep   20s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    unselect frame
    #wait until page contains element  //div[@class='cpq-item-product']/div[@class='cpq-item-base-product']//following::div[@class='cpq-item-no-children']/span[normalize-space(.)='${pname}']   60s


Updating Setting Telia Colocation
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    xpath=//div[@class='cpq-item-product']/div[@class='cpq-item-base-product']/div/div/button[1]/span[@class='cpq-product-name' and text()='Telia Colocation']    60s
    click element    xpath=//span[@class='cpq-product-name' and text()='Telia Colocation']/..
    wait until page contains element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-actions slds-text-align_right']/button    60s
    click element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-actions slds-text-align_right']/button
    #wait until page contains element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-string cpq-item-text-value']/div[text()='Add']    60s
    ##page should contain element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-string cpq-item-text-value']/div[text()='Add']
    ##wait until page contains element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-string cpq-item-text-value']/div[text()='Add']    60s
    #wait until page contains element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']    60s
    #execute javascript    window.scrollTo(0,200)
    ##scroll page to element    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    scrolluntillfound    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    sleep    10s
    wait until page contains element    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']    60s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    #log to console    before teardiwn
    Unselect Frame
    sleep    60s

UpdateAndAddSalesType
    [Arguments]    ${products}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_list}=    Set Variable    //td[normalize-space(.)='${products}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    #log to console    UpdateAndAddSalesType
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    wait until page contains element    ${update_order}    60s
    #log to console    selected new frame
    wait until page contains element    ${product_list}    70s
    click element    ${product_list} //following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_list}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    click element    ${next_button}
    unselect frame
    sleep    60s

UpdateAndAddSalesTypeB2O
    [Arguments]    ${pname}=${product_name}
    ${spinner}    Set Variable    //div[@class='center-block spinner']
    ${status}=    Run Keyword And Return Status    wait until page contains element    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    #log to console    UpdateAndAddSalesTypeB2O
    run keyword if    ${status} == False    Reload Page
    wait until page contains element    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Wait Until Element Is Not Visible    ${spinner}    60s
    wait until page contains element    xpath=//h1[normalize-space(.) = 'Update Products']    60s
    sleep    10s
    wait until page contains element    xpath=//td[normalize-space(.)='${pname}']    70s
    click element    xpath=//td[normalize-space(.)='${pname}']//following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    xpath=//td[normalize-space(.)='${pname}']//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    Wait Until Element Is Visible    xpath=//button[normalize-space(.)='Next']    60s
    click element    xpath=//button[normalize-space(.)='Next']
    unselect frame
    sleep    60s

CPQ Page
    Sleep  10s
    Verify the Action of product  Telia Colocation   Existing
    Verify onetime total charge
    ${Toggle}  set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/button/span[2][text()='Telia Colocation']
    ${status}   Run keyword and return status   Element should be visible   ${Toggle}
    Log to console    Toggle status is ${status}
    Run keyword if  ${status}  Click element  ${Toggle}
    #Delete Product   Cabinet 52 RU
    #Verify the Action of child product  Cabinet 52 RU   Disconnect
    #Failing need to check.
    Add Product   Cabinet 12 RU
    Verify the Action of child product  Cabinet 12 RU   Add
    scrolluntillfound    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    sleep    10s
    wait until page contains element    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']    60s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']


Verify the Action of product
      [Arguments]  ${pname}  ${Value}
    #${Action}   set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/button/span[2][text()='${pname}']//following::div[13]/div
    ${Action}   set variable   //span[text()='${pname}']//following::div[19]/div
    Wait until element is visible  ${Action}    60s
    ${Action Value}  Get Text  ${Action}
    Should be equal     ${Action Value}  ${Value}
    Log to console  The ACtion value for the product ${pname} is verified


Verify onetime total charge
    ${One Time Value}  get text  //div[contains(text(),'OneTime Total')]//following::div[1]
    Should be equal   '${One Time Value}'  '0.00 €'

Add Product
    [Arguments]  ${pname}
    ${Add_Product}  set variable   //div[contains(text(),'${pname}')]//following::button[1]
    Wait until element is visible  ${Add_Product}  60s
    Click element  ${Add_Product}
    #Wait until element is added
    Wait until element is visible   //div[contains(text(),'${pname}')]//following::button[4][@title='Delete Item']   50s


Updating Setting Telia Colocation without Next

    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    xpath=//div[@class='cpq-item-product']/div[@class='cpq-item-base-product']/div/div/button[1]/span[@class='cpq-product-name' and text()='Telia Colocation']    60s
    click element    xpath=//span[@class='cpq-product-name' and text()='Telia Colocation']/..
    wait until page contains element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-actions slds-text-align_right']/button    60s
    click element    xpath=//*[text()="Cabinet 52 RU"]/../../../../div[@class='cpq-item-base-product-actions slds-text-align_right']/button
    unselect frame


Adding Arkkitehti
    [Arguments]   ${pname}=${product_name}
    Log to console      adding product
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    sleep   20s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    unselect frame


Adding Telia Cid
    [Arguments]   ${pname}=${product_name}
    Log to console      adding product
    select frame  xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    sleep   20s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    unselect frame

updating setting Telia Cid
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${SETTINGS}=    Set Variable    //button[@title='Settings']
    ${X_BUTTON}=    Set Variable    //button[@class='slds-button slds-button--icon']
    wait until page contains element    xpath=//div[@class='cpq-item-product']/div[@class='cpq-item-base-product']/div/div/button[1]/span[@class='cpq-product-name' and text()='Telia Cid']     60s
    Wait Until Element Is Visible    ${SETTINGS}    60s
    click element    ${SETTINGS}
    wait until page contains element    //form[@name="productconfig"]//div[2]//input    60s
    input text  //form[@name="productconfig"]//div[2]//input      1
    click element    ${X_BUTTON}
    wait until element is not visible  //span[contains(text(),"Required attribute missing for Telia Cid.")]   60s
    unselect frame
    Wait Until Element Is Enabled    //div[contains(@class,'slds')]/iframe    60s
    Select Frame    //div[contains(@class,'slds')]/iframe
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    Log to console      ${status}
    Wait Until Element Is Visible    //span[text()='Next']/..    60s
    click element    //span[contains(text(),'Next')]
    #Wait Until Element Is Visible    ${Next_Button}    60s
    unselect frame
    sleep  40s

UpdateAndAddSalesType for 3 products and check contract
    [Arguments]    ${product1}    ${product2}   ${product3}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_1}=    Set Variable    //td[normalize-space(.)='${product1}']
    ${product_2}=    Set Variable    //td[normalize-space(.)='${product2}']
    ${product_3}=    Set Variable    //td[normalize-space(.)='${product3}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    log to console    UpdateAndAddSalesType for 3 products
    sleep    30s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe   60s
    Run Keyword If    ${status} == False    Reload Page
    #sleep    60s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    wait until element is visible    ${update_order}    60s
    log to console    selected new frame
    wait until element is visible   ${product_1}    70s
    click element    ${product_1} //following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_1}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    sleep    5s
    wait until element is visible    ${product_2}    70s
    click element    ${product_2} //following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_2}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    sleep  5s
    wait until element is visible    ${product_3}    70s
    click element    ${product_3} //following-sibling::td/select[contains(@class,'required')]
    sleep    2s
    click element    ${product_3}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    Unselect Frame
    sleep    5s


searching and adding Telia Viestintäpalvelu VIP (24 kk)
    [Arguments]    ${product_name}
    search products    Telia Viestintäpalvelu VIP (24 kk)
    ${product}=    Set Variable    //span[@title='${product_name}']/../../..//button
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${status}    Run Keyword And Return Status      Wait Until Element Is Visible    ${product}    60s    80s
    Run Keyword If    ${status} == False    Reload Page
    Run Keyword If    ${status} == False    Sleep  60s
    Run Keyword If    ${status} == False    clear element text    //div[contains(@class,'cpq-searchbox')]//input[contains(@class,'ng-valid')]
    Run Keyword If    ${status} == False    search products    Telia Viestintäpalvelu VIP (24 kk)
    Click Element    ${product}

updating settings Telia Viestintäpalvelu VIP (24 kk)
    ${SETTINGS}=    Set Variable    //button[@title='Settings']
    ${Toimitustapa}=    set variable     //select[@name='productconfig_field_0_2']
    ${X_BUTTON}=    Set Variable    //button[@class='slds-button slds-button--icon']
    ${Next_Button}=    Set Variable    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    Wait Until Element Is Visible    ${SETTINGS}    60s
    click element    ${SETTINGS}
    sleep    4s
    Select From List By Value   //select[@name="productconfig_field_0_0"]   Paperilasku
    sleep  2s
    input text  //input[@name="productconfig_field_0_1"]   1
    sleep  2s
    Select From List By Value    ${Toimitustapa}    Vakiotoimitus
    sleep    5s
    click element    ${X_BUTTON}
    Wait Until Element Is Visible    ${Next_Button}    60s
    Click Element    ${Next_Button}
    sleep  30s
    unselect frame


UpdateAndAddSalesTypewith quantity
    [Arguments]    ${products}    ${quantity_value}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${reporting_products}=    Set Variable    //h1[contains(text(),'Suggested Reporting Products')]
    ${product_list}=    Set Variable    //td[normalize-space(.)='${products}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Previous')]/../..//button[contains(@class,'form-control')][contains(text(),'Next')]
    ${contract_length}=    Set Variable    ${product_list}/../td[9]/input
    ${quantity}=    Set Variable    ${product_list}//following-sibling::td/input[@ng-model='p.Quantity']
    #log to console    UpdateAndAddSalesType with quantity
    sleep    30s
    #${reporting}    Run Keyword And Return Status    Wait Until Page Contains    Suggested Reporting Products    60s
    #Run Keyword If    ${reporting} == True    Reporting Products
    Reporting Products
    #${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    #Run Keyword If    ${status} == False    Reload Page
    sleep    20s
    Wait Until Element Is Not Visible    //div[@class='center-block spinner']    120s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    wait until page contains element    ${update_order}    60s
    #log to console    selected new frame
    wait until page contains element   ${quantity}    60s
    Clear Element Text    ${quantity}
    Input Text    ${quantity}    ${quantity_value}
    wait until page contains element    ${product_list}    70s
    click element    ${product_list} //following-sibling::td/select[contains(@class,'required')]
    click element    ${product_list}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    sleep    2s
    click element    ${contract_length}
    clear element text   ${contract_length}
    input text   ${contract_length}  60
    Execute Javascript    window.scrollTo(0,400)
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    sleep    2s
    unselect frame
    sleep    60s

Reporting Products
    ${next_button}=    Set Variable    //div[@class='vlc-cancel pull-left col-md-1 col-xs-12 ng-scope']//following::div[1]/button[1]
    #${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe       60s
    #Log To Console    Reporting Products
    #Run Keyword If    ${status} == False    execute javascript    browser.runtime.reload()
    #Run Keyword If    ${status} == False    Reload Page
    Reload Page
    sleep  20s
    execute javascript    window.stop();
    #go to   https://telia-fi--release.lightning.force.com/one/one.app#eyJjb21wb25lbnREZWYiOiJvbmU6YWxvaGFQYWdlIiwiYXR0cmlidXRlcyI6eyJhZGRyZXNzIjoiaHR0cHM6Ly90ZWxpYS1maS0tcmVsZWFzZS5saWdodG5pbmcuZm9yY2UuY29tL2FwZXgvdmxvY2l0eV9jbXRfX09tbmlTY3JpcHRVbml2ZXJzYWxQYWdlP2lkPTAwNjZFMDAwMDA4U3VmNFFBQyZ0cmFja0tleT0xNTc1NTU1NzM2NDAxIy9PbW5pU2NyaXB0VHlwZS9PcHBvcnR1bml0eSUyMFByb2R1Y3QvT21uaVNjcmlwdFN1YlR5cGUvT0xJJTIwRmllbGRzL09tbmlTY3JpcHRMYW5nL0VuZ2xpc2gvQ29udGV4dElkLzAwNjZFMDAwMDA4U3VmNFFBQy9QcmVmaWxsRGF0YVJhcHRvckJ1bmRsZS8vdHJ1ZSJ9LCJzdGF0ZSI6e319
    #reload page
    sleep    30s
    #Wait Until Element Is Visible    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    #Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    sleep  30s
    #click element    ${next_button}
    unselect frame


Update products OTC and RC
    ${iframe}   Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']//div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${Viwe_quote}=    Set Variable    //button[@title="View Quote"]
    ${open_quote}=    Set Variable   //button[@title="Open Quote"]
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    Wait Until Element Is Enabled   ${iframe}   80s
    select frame    ${iframe}
    Wait until page contains element    //div[@id="OpportunityLineItems"]/ng-include/div/table/tbody/tr[3]/td[4]/input  60s
    Input Text  //div[@id="OpportunityLineItems"]/ng-include/div/table/tbody/tr[3]/td[4]/input      200
    Input Text  //div[@id="OpportunityLineItems"]/ng-include/div/table/tbody/tr[3]/td[5]//input      200
    Wait element to load and click      //div[@id="OpportunityLineItems"]/ng-include/div/table/tbody/tr[3]/td[8]/select
    Click element   //table[@class='tg']/tbody//tr[3]/td[8]/select/option[@value='New Money-New Services']
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    Unselect Frame
    sleep    80s
    #Reload Page
    #Wait element to load and click  //form[@id="a1q4E000002zpz1QAA-12"]/div/div/button
#    select frame    ${iframe}
#    Sleep  2s
#    ${status}=  Run Keyword And Return Status  Element Should Be Visible   ${open_quote}    100s
#    Run Keyword If   ${status}   Click element    ${open_quote}
#    Run Keyword unless   ${status}    Click element   ${Viwe_quote}
#    #Wait element to load and click  //button[@id="View Quote"]
#    unselect frame
#    sleep   10s

Adding Products for Telia Sopiva Pro N
    [Arguments]    ${product-id}
    ${SETTINGS}=    Set Variable    //button[@title='Settings']
    ${X_BUTTON}=    Set Variable    //button[@class='slds-button slds-button--icon']
    ${Numeron siirto}=   Set Variable    //div[@class="slds-grid slds-grid--align-end"]/../..//div[13]/../fieldset//label[contains(text(),"Numeron siirto")]
    ${product}=    Set Variable    //span[normalize-space(.)= '${product-id}']/../../../div[@class='slds-tile__detail']/div/div/button
    Wait Until Element Is Visible    ${product}    60s
    Click Element    ${product}
    Wait Until Element Is Visible    ${SETTINGS}    100s
    click element    ${SETTINGS}
    scrolluntillfound  ${Numeron siirto}
    Wait Until Element Is Visible    ${Numeron siirto}    60s
    click element   //div[@class="slds-grid slds-grid--align-end"]/../..//div[13]/../fieldset//label//input[@value="Yes"]/../span
    sleep    3s
    click element    ${X_BUTTON}
    Sleep  5s
    Wait Until Element Is Visible    //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product-id}")]/../../../.././div[3]//span/span  30s
    click element       //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product-id}")]/../../../.././div[3]//span/span
    Sleep  5s
    Wait Until Element Is Visible   //div[text()="Recurring Charge"]/..//input[@type="number"]   20s
    Input Text       //div[text()="Recurring Charge"]/..//input[@type="number"]     50
    Wait Until Element Is Visible       //button[contains(text(),"Apply")]      10s
    click element   //button[contains(text(),"Apply")]
    Sleep  25s
    Wait Until Element Is Enabled       //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product-id}")]/../../../.././div[5]//div/span/span   60s
    click element                       //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product-id}")]/../../../.././div[5]//div/span/span
    Sleep  5s
    Wait Until Element Is Visible       //div[text()="One Time Charge"]/..//input[@type="number"]   20s
    Input Text       //div[text()="One Time Charge"]/..//input[@type="number"]     10
    Wait Until Element Is Visible       //button[contains(text(),"Apply")]      10s
    click element   //button[contains(text(),"Apply")]
    Sleep  20ste Line Items']
    Wait until element is visible   //table/tbody/tr/td[5]/span/span[text()='200,00 €']     30s
    Wait until element is visible   //table/tbody/tr/td[6]/span/span[text()='200,00 €']     30s


Adding Products for Telia Sopiva Pro N child products
    [Arguments]    ${product1}  ${product2}
    ${addproduct1}=     Set Variable    //div[contains(text(),"${product1}")]/../../../..//div[7]//button
    ${addproduct2}=     Set Variable    //div[contains(text(),"${product2}")]/../../../div[@class="cpq-item-base-product-actions slds-text-align_right"]/button
    Click Element     //div[@class="cpq-item-base-product"]//button
    Wait Until Element Is Enabled    ${addproduct1}    60s
    Click Element    ${addproduct1}
    Sleep  20s
    Wait Until Element Is Enabled   ${addproduct2}     60s
    click element    ${addproduct2}
    Wait Until Element Is Enabled     //div[contains(text(),"${product2}")]/../../..//span[@class="cpq-underline"]/span       60s
    click element     //div[contains(text(),"${product2}")]/../../..//span[@class="cpq-underline"]/following::span[1]/span
    Sleep  5s
    Wait Until Element Is Visible   //div[text()="One Time Charge"]/..//input[@type="number"]   20s
    Input Text  //div[text()="One Time Charge"]/..//input[@type="number"]     10
    Wait Until Element Is Visible       //button[contains(text(),"Apply")]      30s
    click element   //button[contains(text(),"Apply")]
    Sleep  15s
    Wait Until Element Is Enabled   //div[contains(text(),"${product2}")]/../../..//span[@class="cpq-underline"]/span     60s
    click element   //div[contains(text(),"${product2}")]/../../..//span[@class="cpq-underline"]/span
    sleep  10s
    Wait Until Element Is Visible   //div[text()="Recurring Charge"]/..//input[@type="number"]  10s
    Input Text      //div[text()="Recurring Charge"]/..//input[@type="number"]       30
    Wait Until Element Is Visible       //button[contains(text(),"Apply")]      10s
    click element   //button[contains(text(),"Apply")]
    Sleep  20s
    log  display the cpq page for verfication
    Capture Page Screenshot


UpdateAndAddSalesType for B2b products
    [Arguments]    ${product1}    ${product2}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_1}=    Set Variable    //td[normalize-space(.)='${product1}']
    ${product_2}=    Set Variable    //td[normalize-space(.)='${product2}']
    ${Viwe_quote}=    Set Variable    //button[@title="View Quote"]
    ${open_quote}=    Set Variable   //button[@title="Open Quote"]
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    #log to console    UpdateAndAddSalesType for 2 products
    sleep    10s
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
    sleep    60s
    #Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    #select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    #${status}=  Run Keyword And Return Status  Element Should Be Visible   ${Viwe_quote}    60s
    #Run Keyword If   ${status}   click visible element    ${Viwe_quote}
    #Run Keyword unless   ${status}    click visible element   ${open_quote}
    #log to console  quote created
    #Unselect frame


Adding prouct To cart (cpq) without Next
    [Arguments]   ${pname}=${product_name}
    Log to console      adding product
    select frame  ${iframe}
    wait until page contains element  xpath=//div[contains(@class, 'cpq-searchbox')]//input    60s
    wait until page contains element    //div[contains(@class,'cpq-products-list')]     60s
    input text   //div[contains(@class, 'cpq-searchbox')]//input  ${pname}
    wait until page contains element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button   60s
    sleep   20s
    click element  xpath=//span[normalize-space(.) = '${pname}']/../../../div[@class='slds-tile__detail']/div/div/button
    unselect frame


Update Setting Vula
    [Arguments]        ${pname}
    ${Nopeus}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Nopeus']]//following::select[1]
    ${Asennuskohde}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Asennuskohde']]//following::select[1]
    ${Toimitustapa}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Toimitustapa']]//following::select[1]
    ${VLAN}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'VLAN']]//following::input[1]
    ${VULA NNI}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'VULA NNI']]//following::input[1]
    ${Yhteyshenkilön nimi}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Yhteyshenkilön nimi']]//following::input[1]
    ${Yhteyshenkilön puhelinnumero}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Yhteyshenkilön puhelinnumero']]//following::input[1]
    ${Katuosoite}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Katuosoite']]//following::input[1]
    ${Katuosoite numero}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Katuosoite numero']]//following::input[1]
    ${Postinumero}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Postinumero']]//following::input[1]
    ${Postitoimipaikka}  set variable   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Postitoimipaikka']]//following::input[1]
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${SETTINGS}   set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/div/span[text()='${pname}']//following::button[@title='Settings']
    Wait until element is visible   ${SETTINGS}   60s
    Click Button    ${SETTINGS}
    sleep  10s
    Click element  ${Nopeus}
    Click element  ${Nopeus}/option[2]
    Click element   ${Asennuskohde}
    Click element   ${Asennuskohde}/option[2]
    Click element   ${Toimitustapa}
    Click element   ${Toimitustapa}/option[2]
    Input Text  ${VLAN}  1
    Input Text   ${VULA NNI}    Test
    Input Text   ${Yhteyshenkilön nimi}    Test
    Input Text    ${Yhteyshenkilön puhelinnumero}   Test
    Input Text   ${Katuosoite}   Test
    Input Text    ${Katuosoite numero}  Test
    Input Text  ${Postinumero}  00510
    Input Text    ${Postitoimipaikka}  Test
    sleep  3s
    Click element  //*[@alt='close'][contains(@size,'large')]
    sleep  10s
    Reload page
    sleep  10s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    scrolluntillfound    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    #sleep    10s
    wait until page contains element    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']    60s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    Unselect Frame


Adding Products
    [Arguments]    ${product-id}
    ${product}=    Set Variable    //div[@class="cpq-product-list"]//div[@class="slds-tile cpq-product-item"]//span[normalize-space(.)="${product-id}"]/../../..//button
    wait until page contains element    ${product}    60s
    Click Element    ${product}
    unselect frame



Searching and adding multiple products
    [Arguments]    @{products}
    [Documentation]    This is used to search and add multiple products
    ...
    ...    In order to add the product we are using the product-id
    ...
    ...    the tag used to extract the product-id is "data-product-id"
    ${iframe}    Set Variable    //div[contains(@class,'slds')]/iframe
    ${next_button}    set variable    //span[contains(text(),'Next')]
    ${prod}    Create List    @{products}
    ${count}    Get Length    ${prod}
    #Log To Console    ${count}
    #Log To Console    Searching and adding multiple products
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > ${count}-1
    \    ${product_name}    Set Variable    @{products}[${i}]
    \    ${product_id}    Set Variable    ${product_name}
    \    Log To Console    product name ${product_name}
    \    search products    ${product_name}
    \    Log To Console    Product id ${product_id}
    \    Adding Products    ${product_id}
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    Scroll Page To Location    0    100
    wait until page contains element  ${next_button}  60s
    Click Element    ${next_button}
    #${status}    Run Keyword And Return Status    Wait Until Element Is Not Visible    ${next_button}    60s
    #Run Keyword If    ${status} == True    click element    ${next_button}
    Unselect Frame
    Sleep  60s


Updating sales type multiple products
    [Arguments]    @{products}
    [Documentation]    This is used to Update sales type for multiple products
    ...
    ...    The input for this keyword is \ list of products
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    ${frame}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${prod}    create list    @{products}
    ${count}    Get Length    ${prod}
    #Sleep  20s
    #log to console    Updating sales type multiple products
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    ${frame}    60s
    Run Keyword If    ${status} == False    Reload Page
    sleep    20s
    Wait Until Element Is Enabled    ${frame}    60s
    select frame    ${frame}
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > ${count}-1
    \    ${product_name}    Set Variable    @{products}[${i}]
    \    ${product_list}    Set Variable    //td[normalize-space(.)='${product_name}']
    \    wait until page contains element    ${update_order}    60s
    \    log to console    selected new frame
    \    Wait Until Element Is Visible    ${product_list}//following-sibling::td/select[contains(@class,'required')]    120s
    \    click element    ${product_list} //following-sibling::td/select[contains(@class,'required')]
    \    sleep    2s
    \    click element    ${product_list}//following-sibling::td/select[contains(@class,'required')]/option[@value='New Money-New Services']
    log    Completed updating the sales type
    sleep    5s
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    Capture Page Screenshot
    Unselect Frame
    sleep    5s


Update Setting Vula without Next
    [Documentation]    Go to CPQPage and Update Setting Vula without going Next
    [Arguments]        ${pname}
    select frame    ${Page_iframe}
    ${SETTINGS}   set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/div/span[text()='${pname}']//following::button[@title='Settings']
    Wait until element is visible   ${SETTINGS}   60s
    Click Button    ${SETTINGS}
    sleep  30s
    Click element  ${Nopeus}
    Click element  ${Nopeus}/option[2]
    Click element   ${Asennuskohde}
    Click element   ${Asennuskohde}/option[2]
    Click element   ${Toimitustapa}
    Click element   ${Toimitustapa}/option[2]
    Input Text  ${VLAN}  1
    Input Text   ${VULA NNI}    Test
    Input Text   ${Yhteyshenkilön nimi}    Test
    Input Text    ${Yhteyshenkilön puhelinnumero}   Test
    Input Text   ${Katuosoite}   Test
    Input Text    ${Katuosoite numero}  Test
    sleep  3s
    Input Text  ${Postinumero}   00510
    sleep  3s
    Input Text    ${Postitoimipaikka}   Test
    sleep  4s
    Click element    ${Postitoimipaikka}
    sleep  5s
    Click element   //div[@class="slds-grid slds-grid--vertical cpq-product-cart-config"]
    sleep  10s
    Click element  ${Setting_Close}
    sleep  10s
    Reload page
    sleep  10s

Validate that HDC Rack Amount and HDC Total KW fields and Edit the value
   [Documentation]  To Validate that HDC Rack Amount and HDC Total KW fields and Edit the values in the opportunity page
   ${Amount_validation_HDC_Total_KW}          Set Variable  //div//span[text()="HDC Total KW"]//following::lightning-formatted-number[text()=normalize-space(.)="${HDC_Total_KW},00"]
   ${Amount_validation_HDC_Rack_Amount}       Set Variable          //div//span[text()="HDC Rack Amount"]//following::lightning-formatted-number[text()=normalize-space(.)="${HDC_Rack_Amount},00"]
   scrolluntillfound  ${Additional_Details}
   wait until page contains element  ${HDC Total}   60s
   page should contain element    ${HDC Total KW_investment}
   page should contain element   ${HDC Rack Amount_investment}
   click element  ${Edit HDC Rack Amount}
   Scroll Page To Location    0    2000
   sleep  20s
   click element   ${input_HDC_Total_KW}
   input text  ${input_HDC_Total_KW}     ${HDC_Total_KW}
   input text  ${input_HDC_Rack_Amount}   ${HDC_Rack_Amount}
   wait until page contains element  ${Save_OPPO}    60s
   click element  ${Save_OPPO}
   wait until page contains element  ${Amount_validation_HDC_Total_KW}   60s
   page should contain element      //div//span[text()="HDC Rack Amount"]//following::lightning-formatted-number[text()=normalize-space(.)="${HDC_Rack_Amount},00"]
   scroll page to element  ${System Information}
   page should contain element   ${Migration}

updateandaddsalestype for multiple products with different salestype
    [Arguments]    @{products}
    [Documentation]    This is used to Update sales type for multiple products with different salestype
    ...
    ...    The input for this keyword is \ list of products
    ${one time total}    Set Variable   0
    ${recurring_total}   Set Variable   0
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    ${frame}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${prod}    create list    @{products}
    ${count}    Get Length    ${prod}
    #Sleep  20s
    #log to console    Updating sales type multiple products
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    ${frame}    60s
    Run Keyword If    ${status} == False    Reload Page
    Run Keyword If    ${status} == False     Sleep     20s
    Wait Until Element Is Enabled    ${frame}    60s
    select frame    ${frame}
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > ${count}-1
    \    ${product_name}    Set Variable    @{products}[${i}]
    \    ${product_list}    Set Variable    //td[normalize-space(.)='${product_name}']
    \    wait until page contains element    ${update_order}    60s
    \    log to console    selected new frame
    \    wait until page contains element  //div[normalize-space(.)='Update Products']//following::td[normalize-space(.)='${product_name}']/../td[4]   60s
    \    Wait Until Element Is Visible    ${product_list}//following-sibling::td/select[contains(@class,'required')]    120s
    \    click element    ${product_list} //following-sibling::td/select[contains(@class,'required')]
    \    sleep    2s
    \    click element    ${product_list}//following-sibling::td/select[contains(@class,'required')]/option[${i+1}]
    \    Sleep  5s
    \    ${status}    Run Keyword And Return Status    wait until page contains element    //Select/*[contains(text(),"New Money")]    60s
    \    Run Keyword If    ${status} == True    Reload Page
    \    ${ot charge}  get text   //div[normalize-space(.)='Update Products']//following::td[normalize-space(.)='${product_name}']/../td[6]
    \    ${recurring_charge}  get text  //div[normalize-space(.)='Update Products']//following::td[normalize-space(.)='${product_name}']/../td[7]
    \    ${one time total}  evaluate  ${ot charge}+${one time total}
    \    ${recurring_total}  evaluate  ${recurring_charge}+${recurring_total}
    sleep    20s
    Wait Until Element Is Visible    ${next_button}    60s
    click element    ${next_button}
    Capture Page Screenshot
    Unselect Frame

Mofify the contract length and validate in the opportunity page
     [Documentation]  Mofify the contract length in the solution value estimate and validate in the opportunity page
     select frame  ${iframe}
     wait until page contains element  ${contractLength_Sve}   60s
     click element  ${contractLength_Sve}
     input text  ${contractLength_Sve}   ${contract_lenght_updated}
     ${fyr_value}=      evaluate  ((${RC}*${contract_lenght})+ ${NRC}) * ${product_quantity} +${ARC}
     ${revenue_value}=  evaluate  ((${RC}*${contract_lenght_updated})+ ${NRC}) * ${product_quantity} +(${ARC}*2)
     page should contain element  //th[normalize-space(.)='FYR']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model="p.RecurringTotalt"]/../following-sibling::td[normalize-space(.)='${fyr_value}.00'][1]
     page should contain element  //th[normalize-space(.)='FYR']//following::tr[@class='parent-product ng-scope'][1]/td/input[@ng-model="p.RecurringTotalt"]/../following-sibling::td[normalize-space(.)='${revenue_value}.00']
     wait until page contains element  ${Save_sve}  60s
     click element  ${Save_sve}
     unselect frame
     [Return]   ${fyr_value}


Add Finnish_Domain_Service
    [Documentation]  Add Finnish_Domain_Service  in the cpq page
    select frame   ${iframe}
    wait until page contains element  ${Child_product_Dns_finish doamin}  60s
    click element  ${Child_product_Dns_finish doamin}
    Wait until element is visible  ${Internet Domain_Toggle}   60s
    Click element  ${Internet Domain_Toggle}
    Wait Until Element Is Visible    ${Finnish_Domain_Service_Add_To_Cart}    240s
    click element    ${Finnish_Domain_Service_Add_To_Cart}
    Wait Until Element Is Visible    ${Finnish_Domain_Service_Settings_Icon}    240s
    force click element    ${Finnish_Domain_Service_Settings_Icon}
    Wait Until Element Is Visible   ${Verkotunnus_Field}   10s
    press enter on    ${Verkotunnus_Field}
    Wait Until Element Is Visible   ${Verkotunnus_option}   2s
    click element    ${Verkotunnus_option}
    Wait Until Element Is Visible    ${Voimassaoloaika_Field}  5s
    press enter on    ${Voimassaoloaika_Field}
    Wait Until Element Is Visible    ${Voimassaoloaika_option}    2s
    click element    ${Voimassaoloaika_option}
    Wait Until Element Is Visible  ${closing}  10s
    click element    ${closing}
    Sleep  40s
    wait until page contains element  ${Annual Recurring charge_finish_time}  60s
    ${value}  get text  ${Annual Recurring charge_finish_time}
    ${value}=  remove string  ${value}  /year
    wait until page contains element  ${Child_product_Dns_finish doamin_child}   60s
    click visible element  ${Child_product_Dns_finish doamin_child}
    Wait until element is visible  ${Finnish Domain Name Registrant}   60s
    click visible element  ${Finnish Domain Name Registrant}
    sleep  40s
    wait until page contains element    //div[@class="slds-grid slds-nowrap cpq-total-card"]/div[2]/div[normalize-space(.)="${value}"]   60s
    ${value1}  get text   ${Monthly recurring chage_finish_time}
    ${value2}  get text    ${one time_charge_finish_doamin}
    Page should contain element    //div[@class="slds-grid slds-nowrap cpq-total-card"]/div[2]/div[normalize-space(.)="${value}"]
    Unselect Frame
    [Return]  ${value}  ${value1}   ${value2}

updating setting Telia Domain Name space
    [Documentation]  This is to update the settings in Telia domain name service
    [Arguments]   ${pname}=${product_name}
    select frame    ${iframe}
    ${SETTINGS}   set variable   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/div/span[text()='${pname}']//following::button[@title='Settings']
    Wait until element is visible   ${SETTINGS}   60s
    Click Button    ${SETTINGS}
    sleep  10s
    Input Text   ${Asiakkaan verkkotunnus}     Test
    Input Text   ${Linkittyvä tuote}    Test
    sleep  3s
    Click element  //*[@alt='close'][contains(@size,'large')]
    sleep  10s
    Reload page
    sleep  10s
    select frame    ${iframe}
    scrolluntillfound    ${CPQ_CART_NEXT_BUTTON}
    #sleep    10s
    wait until page contains element   ${CPQ_CART_NEXT_BUTTON}    60s
    click element    ${CPQ_CART_NEXT_BUTTON}
    Unselect Frame
    sleep    10s