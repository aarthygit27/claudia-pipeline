*** Settings ***
Documentation           CPQ is a part of Salesforce, which is used for product orders

Resource                ${PROJECTROOT}${/}resources${/}common.robot
Resource                ${PROJECTROOT}${/}resources${/}salesforce_variables.robot

*** Variables ***
${CLOSE_BUTTON}         //div[contains(@class,'slds-modal')]//button[contains(text(),'Close')]
${SHOPPING_CART}        //div[contains(@class,'cpq-product-cart')]//a[text()='Cart']
#${CREDIT_SCORE_SUCCESS}     (normalize-space()='Credit Score Check Passed' and @msg='Success')
${CREDIT_SCORE_SUCCESS}     (normalize-space()='Credit Score Check Passed')
#${CREDIT_SCORE_FAILURE}     (contains(normalize-space(),'Credit Score Not Accepted') and @msg='Warning')
${CREDIT_SCORE_FAILURE}     (contains(normalize-space(),'Credit Score Not Accepted')
${ATTRIBUTE_EDIT_WINDOW}    //div[@id='cpq-lineitem-details-modal-content']
${REQUIRED_ATTRIBUTE}       //div[@class='cpq-cart-item-root-product-details']/div[contains(@class,'cpq-cart-item-root-product-cfg-attr')]
#${CREDIT_SCORE_NEXT_BUTTON}  /html/body/span/div/span/div/ng-view/bptree/div/accordion/div/child[18]/div/div[2]/div/form/div[2]/div[2]/button
${CREDIT_SCORE_NEXT_BUTTON}  //child[18]//button

*** Keywords ***

Add modelled product and unmodelled product to cart (CPQ)
    [Arguments]    ${modelled_product}=Telia Yritysinternet Plus   ${unmodelled_product}=DataNet Multi
    Search And Add Product To Cart (CPQ)    ${modelled_product}
    Set Test Variable   ${PRODUCT}      ${modelled_product}
    Fill Missing Required Information If Needed (CPQ)
    Search And Add Product To Cart (CPQ)    ${unmodelled_product}

Add Nth Product To Cart (CPQ)
    [Arguments]     ${i}
    ${xpath}=       Set Variable    //div[@class='slds-col cpq-items-container scroll']//div[@data='card']
    ${target_product}=      Run Inside Iframe   ${OPPORTUNITY_FRAME}
    ...     Execute Javascript      return document.evaluate("${xpath}[${i}]//p[contains(@class,'product-name')]",document, null, XPathResult.ANY_TYPE, null).iterateNext().innerText;
    Run Inside Iframe   ${OPPORTUNITY_FRAME}        Click Element   ${xpath}[${i}]//button[contains(text(),'Add to Cart')]
    Wait Until Product Appears In Cart (CPQ)        ${target_product}       timeout=1 min


Add Random Product To Cart (CPQ)
    ${target_product}=      Run Inside Iframe    ${OPPORTUNITY_FRAME}       Add Random Product To Cart
    Wait Until Product Appears In Cart (CPQ)        ${target_product}

Click CPQ At Opportunity View
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${OPPORTUNITY_CPQ_BUTTON}    30 seconds
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Element    ${OPPORTUNITY_CPQ_BUTTON}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${SHOPPING_CART}    30s

Click CPQ At Quote View
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${QUOTE_CPQ_BUTTON}    30 seconds
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Element    ${QUOTE_CPQ_BUTTON}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${SHOPPING_CART}    30s

Click Create Assets (CPQ)
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${CPQ_CREATE_ASSETS}    30 seconds
    Wait Until Keyword Succeeds    20 s    3 s
    ...    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Click Element    ${CPQ_CREATE_ASSETS}
    Wait Until Keyword Succeeds    20 s    3 s    Run Inside Iframe    ${OPPORTUNITY_FRAME}
    ...    Page Should Not Contain Element    ${CPQ_CREATE_ASSETS}

Click Create Order (CPQ)
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${CPQ_CREATE_ORDER}    30 seconds
    Wait Until Keyword Succeeds    20 s    3 s
    ...    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Click Element    ${CPQ_CREATE_ORDER}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Does Not Contain Element    ${CPQ_CREATE_ORDER}     1 min

Click Create Order After Credit Score Check (CPQ)
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    id=Create Order    30 seconds
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Element       id=Create Order
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${EDIT_BUTTON}      30s

Click Create Quote (CPQ)
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${CPQ_CREATE_QUOTE}    30 seconds
    Wait Until Keyword Succeeds    20 s    3 s
    ...    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Click Element    ${CPQ_CREATE_QUOTE}

Click Next (CPQ)
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    //*[text()='Next']      20s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds     20s     1s      Click Element   //*[text()='Next']

Click Next (CPQ) Button
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds     30s     1s    Click Button  Next

Click Next After Successful Credit Score (CPQ)
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    Credit Score Validation_nextBtn      20s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds     20s     1s      Click Element   Credit Score Validation_nextBtn


Click Save Order (CPQ)
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${SAVE_ORDER_BUTTON}    30 seconds
    Wait Until Keyword Succeeds    20 s    3 s
    ...    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Click Element    ${SAVE_ORDER_BUTTON}

Click View Record (CPQ)
    [Documentation]     Opens a new new window and selects the window. The main window must be
    ...                 selected later in the test case again.
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${VIEW_RECORD_BUTTON}    30 seconds
    Wait Until Keyword Succeeds    20 s    3 s
    ...    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Click Element    ${VIEW_RECORD_BUTTON}
    # Wait Until Keyword Succeeds    5 s     1 s      Select Window    new

Click View Quote (CPQ)
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element        View Quote      20s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds     30s     1s     Click Element    View Quote
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    //h1[@class='pageType' and text()='Quote']
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    //td[@id='topButtonRow']//input[@title='CPQ']

Click View Quote And Go Back To CPQ
    Click View Quote (CPQ)
    Sleep   2
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Element   //td[@id='topButtonRow']//input[@title='CPQ']
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element        ${CPQ_CREATE_ORDER}     15s

Close Missing Information Popup (CPQ)
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         20s   1s    Click Element   ${CLOSE_BUTTON}
    # For some strange reason clicking the "close" can result in another load and the close button needs to be pressed a second time
    ${hidden}=     Run Keyword and Return Status       Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Element Is Not Visible
    ...         ${CLOSE_BUTTON}      5s
    Run Keyword If      not ${hidden}      Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         20s   1s    Click Element   ${CLOSE_BUTTON}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Element Is Not Visible
    ...         //div[@class='slds-modal__container']   10s

Fill Additional Attributes For Telia Yritysinternet (CPQ)
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Select From List By Label   ${ATTRIBUTE_EDIT_WINDOW}//div[./label[text()[contains(.,'Palvelutaso')]]]//select   A8h
    Wait Until Keyword Succeeds     30s     1s      Wait Until Additional Attributes Are Updated (CPQ)
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Select From List By Label   ${ATTRIBUTE_EDIT_WINDOW}//div[./label[text()[contains(.,'Dynaamiset julkiset IP-osoitteet')]]]//select      1-36 kpl
    Wait Until Keyword Succeeds     30s     1s      Wait Until Additional Attributes Are Updated (CPQ)
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Select From List By Label   ${ATTRIBUTE_EDIT_WINDOW}//div[./label[text()[contains(.,'Toimitus')]]]//select      Toimitus arkisin 16:00-20:00
    Wait Until Keyword Succeeds     30s     1s      Wait Until Additional Attributes Are Updated (CPQ)

Fill Missing Required Information
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Element   //div[@class='cpq-cart-item-root-product']//button[@title='Details']
    Wait Until Keyword Succeeds     30s     1s      Run Keyword     Fill Required Information For ${PRODUCT}
    Wait Until Keyword Succeeds     30s     1s      Wait Until Filled Information Is Recognized (CPQ)
    Close Missing Information Popup (CPQ)
    [Teardown]      Run Keyword And Ignore Error      Run Inside Iframe    ${OPPORTUNITY_FRAME}     Click Element   ${CLOSE_BUTTON}

Fill Missing Required Information If Needed (CPQ)
    ${s}=   Recognize Product Needs Additional Information (CPQ)
    Run Keyword if    ${s}      Fill Missing Required Information

Fill Required Information For Telia Cid
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         10s     1s      Input Text      ${ATTRIBUTE_EDIT_WINDOW}${REQUIRED_ATTRIBUTE}//input    1
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Press Tab On    ${ATTRIBUTE_EDIT_WINDOW}${REQUIRED_ATTRIBUTE}//input

Fill Required Information For Telia Sopiva Pro L
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         10s   1s    Click Element   //div[contains(@class,'slds-modal')]//input[@type='radio' and @value='1']

Fill Required Information For Telia Yritysinternet
    ${xpath}=   Set Variable   ${ATTRIBUTE_EDIT_WINDOW}${REQUIRED_ATTRIBUTE}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element
    ...     ${xpath}//label[text()[contains(.,'Liittymän nopeus')]]/abbr[@title='required']    10s
    Log     BQA-1821 test case ends here
    ${visible}=     Run Inside Iframe   ${OPPORTUNITY_FRAME}    Run Keyword And Return Status   Element Should Be Visible   ${xpath}//label[text()[contains(.,'Liittymän nopeus')]]/abbr[@title='required']
    Run Keyword Unless      ${visible}      Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Element   ${ATTRIBUTE_EDIT_WINDOW}//span[text()='Telia Yritysinternet']
    Run Keyword Unless      ${visible}      Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Element   ${ATTRIBUTE_EDIT_WINDOW}//a[text()[contains(.,'Product Configuration')]]
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         20s   1s    Select From List By Value   ${xpath}//select    1

Fill Required Information For Telia Yritysinternet Langaton
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         20s   1s    Select From List By Value   ${ATTRIBUTE_EDIT_WINDOW}${REQUIRED_ATTRIBUTE}//select    1

Fill Required Information For Telia Yritysinternet Plus
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         20s   1s    Select From List By Value   ${ATTRIBUTE_EDIT_WINDOW}${REQUIRED_ATTRIBUTE}//div[./label[text()[contains(.,'Liittymän nopeus')]]]//select    1

Fill Required Information For Microsoft Office 365
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         20s   1s    Input Text   //label[text()[contains(.,'Lisenssien määrä')]]/following-sibling::div//input      1
    ${email}=       Create Unique Email
    #Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    #...         20s   1s    Input Text   //label[text()[contains(.,'Lisäsähköpostiosoite')]]/following-sibling::div//input      ${email}

Handle Credit Score (CPQ)
    [Documentation]     Wait until either a success message or error message is visible and then either click "next" or "return to quote"
    Run Keyword And Ignore Error  Wait Until Keyword Succeeds   60s   3s   Page Should Contain   Credit Score Check Passed
    #${xpath}=   Set Variable    //div[${CREDIT_SCORE_SUCCESS} or ${CREDIT_SCORE_FAILURE}]
    #Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Element Is Visible   ${xpath}    60s
    #${credit_score_passed}=     Run Keyword And Return Status   Run Inside Iframe   ${OPPORTUNITY_FRAME}     Element Should Be Visible   //div[${CREDIT_SCORE_SUCCESS}]
    ${credit_score_passed}=   Run Keyword And Return Status  Page Should Contain  Credit Score Check Passed
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds     60s     3s    Click Element   ${CREDIT_SCORE_NEXT_BUTTON}
    #Run Keyword If      ${credit_score_passed}      Click Next After Successful Credit Score (CPQ)
    Run Keyword If      ${credit_score_passed}      Click View Quote (CPQ)  # And Go Back To CPQ
    Run Keyword If      ${credit_score_passed}      Return From Keyword
    Return To Quote (CPQ)

Load More Products (CPQ)
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element       //a[contains(text(),'Load More')]    20s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Does Not Contain Element    //div[@class='slds-spinner_container']      20s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Element       //a[contains(text(),'Load More')]
    Sleep   0.2
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    //a[contains(text(),'Load More')]
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Does Not Contain Element    //div[@class='slds-spinner_container']      20s

Recognize Product Needs Additional Information (CPQ)
    ${xpath}=   Set Variable    //h2[contains(text(),'Required attribute missing')]
    ${s}=    Run Keyword And Return Status   Run Inside Iframe   ${OPPORTUNITY_FRAME}   Wait Until Element is Visible    ${xpath}   30s
    [Return]    ${s}

Return To Quote (CPQ)
    #Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    //p[text()='Return to Quote']   30s
    #Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    //[text()='View Quote']   30s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Button    Open Quote

Search And Add Product To Cart (CPQ)
    [Arguments]    ${target_product}=${PRODUCT}     ${nth}=1
    Search For Product (CPQ)    ${target_product}
    Wait Until Keyword Succeeds     30s    1s   Select Exact Product                    ${target_product}
    Wait Until Product Appears In Cart (CPQ)      ${target_product}     ${nth}

Select Exact Product
    [Arguments]    ${target_product}
    [Documentation]    Because exact match search doesn't exist, to avoid partial matches
    ...    (e.g. Telia Yritysinternet != Telia Yritysinternet Plus), product will be selected by matching ${target_product}
    ...    to every matching row starting from top to bottom until row contains exact match. ${i} selects row. ${i}=1 is the first row
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element
    ...    //ng-include/div/div[1]//p[contains(text(), '${target_product}')]    20 s
    ${length}=      Run Inside Iframe   ${OPPORTUNITY_FRAME}    Execute Javascript
    ...     return document.evaluate("count(//div[@layout-name='cpq-product-list']//p)", document, null, XPathResult.ANY_TYPE, null).numberValue;
    :FOR   ${i}     IN RANGE    ${length}
    \    ${exact_product}=    Run Keyword And Return Status    Run Inside Iframe    ${OPPORTUNITY_FRAME}
    ...    Element Text Should Be    //div[@layout-name='cpq-product-list']/ng-include/div/div[@index='${i}']//p[normalize-space()='${target_product}']     ${target_product}
    \    Exit For Loop If    ${exact_product}
    Run Keyword If    ${exact_product}    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds     20s     1s    Click Element
    ...    //div[@layout-name='cpq-product-list']/ng-include/div/div[@index='${i}']//p[normalize-space()='${target_product}']/../../following-sibling::div//button[contains(text(),'Add to Cart')]
    ...     ELSE    Fail    ${target_product} not found from search results

Search For Product (CPQ)
    [Arguments]     ${target_product}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element        ${CPQ_SEARCH_FIELD}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Prolonged Input Text                    ${CPQ_SEARCH_FIELD}    ${target_product}    0.5s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Press Enter On                          ${CPQ_SEARCH_FIELD}

Select Sales Type For Order (CPQ)
    #${status}=      Run Keyword And Return Status   Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    //select[contains(@class,'slds-select slds-required')]      10s
    ${status}=      Run Keyword And Return Status   Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    //select[contains(@ng-model,'p.SalesType')]      10s
    # All products do not need a sales type
    Pause Execution
    Return From Keyword If    not ${status}
    ...     AND         Return From
    #...     return document.evaluate("count(//tr//select[contains(@class,'slds-select slds-required')])", document, null, XPathResult.ANY_TYPE, null).numberValue;
    ${length}=      Run Inside Iframe   ${OPPORTUNITY_FRAME}    Execute Javascript
    ...     return document.evaluate("count(//tr//select[contains(@ng-model,'p.SalesType')])", document, null, XPathResult.ANY_TYPE, null).numberValue;
    Run Keyword If  '${length}'=='1'  Run Inside Iframe   ${OPPORTUNITY_FRAME}    Select From List By Label   //select[contains(@ng-model,'p.SalesType')]     New Money-New Services
    Run Keyword If  '${length}'=='1'   Return From Keyword
    :FOR   ${i}     IN RANGE    ${length}
    \   Wait Until Keyword Succeeds     10s     1s
    ...     Run Inside Iframe   ${OPPORTUNITY_FRAME}    Select From List By Label   //tr[${i+2}]/td[8]//select[contains(@ng-model,'p.SalesType')]      New Money-New Services
    #...     Run Inside Iframe   ${OPPORTUNITY_FRAME}    Select From List By Label   //tr[${i+2}]//select[contains(@class,'slds-select slds-required')]      New Money-New Services


Set Prices For Unmodelled Product (CPQ)
    [Arguments]     ${product}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Input Text      //td[text()='${product}']/following-sibling::td[1]/input     50      # one time total
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Input Text      //td[text()='${product}']/following-sibling::td[2]/input     50      # recurring total

Submit Order To Delivery (CPQ)
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${SUBMIT_ORDER_TO_DELIVERY}
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Click Element    ${SUBMIT_ORDER_TO_DELIVERY}
    Wait Until Keyword Succeeds    20 s    1 s    Confirm Action

Update Sales Type and Prices For unmodelled Product (CPQ)
    [Arguments]     ${unmodelled_product}=DataNet Multi
    Click Next (CPQ)
    Select Sales Type For Order (CPQ)
    Set Prices For Unmodelled Product (CPQ)     ${unmodelled_product}
    Click Next (CPQ)

Verify That Product In Cart Is Correct
    [Arguments]    ${target_product}=${PRODUCT}
    ${product_in_cart}=    Set Variable
    ...    //div[contains(@class, 'cpq-cart-item-title')]//div[contains(text(), '${target_product}')]
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${product_in_cart}    20 s

Wait Until Additional Attributes Are Updated (CPQ)
    [Documentation]     If we wait to see the spinner, Robot will probably complain about StaleElementException
    # Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Element Is Visible
    # ...         //div[contains(@class,'slds-modal')]//div[@class='modal-content-position modal-spinner-position']
    Sleep   0.5
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Element Is Not Visible
    ...         //div[contains(@class,'slds-modal')]//div[@class='modal-content-position modal-spinner-position']   20s

Wait Until Filled Information Is Recognized (CPQ)
    # Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Element Is Visible
    # ...         //div[contains(@class,'slds-modal')]//div[@class='modal-content-position modal-spinner-position']
    Sleep   0.5
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Element Is Not Visible
    ...         //div[contains(@class,'slds-modal')]//div[@class='modal-content-position modal-spinner-position']   20s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Element Is Not Visible
    ...         //div[@class='cpq-cart-item-root-product-messages']//span[contains(text(),'Required attribute missing')]    30s

Wait Until Product Appears In Cart (CPQ)
    [Arguments]     ${target_product}   ${amount}=1     ${timeout}=30s
    # Wait Until Keyword Succeeds     20s     1s
    # ...     Run Inside Iframe   ${OPPORTUNITY_FRAME}    Locator Should Match X Times    //span[@class='cpq-product-name' and contains(text(),'${target_product}')]      ${amount}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element        //span[@class='cpq-product-name' and contains(text(),'${target_product}')]      ${timeout}
