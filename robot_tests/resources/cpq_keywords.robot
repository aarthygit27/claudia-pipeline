*** Settings ***
Documentation           CPQ is a part of Salesforce, which is used for product orders

Resource                ${PROJECTROOT}${/}resources${/}common.robot
Resource                ${PROJECTROOT}${/}resources${/}salesforce_variables.robot

*** Keywords ***
Add Nth Product To Cart (CPQ)
    [Arguments]     ${i}
    ${xpath}=       Set Variable    //div[@class='slds-col cpq-items-container scroll']//div[@data='card']
    ${target_product}=      Run Inside Iframe   ${OPPORTUNITY_FRAME}
    ...     Execute Javascript      return document.evaluate("${xpath}[${i}]//p[contains(@class,'product-name')]",document, null, XPathResult.ANY_TYPE, null).iterateNext().innerText;
    Run Inside Iframe   ${OPPORTUNITY_FRAME}        Click Element   ${xpath}[${i}]//button[contains(text(),'Add to Cart')]
    Wait Until Product Appears In Cart (CPQ)        ${target_product}       timeout=1 min


Add Random Product To Cart (CPQ)
    # ${count}=       Run Inside Iframe   ${OPPORTUNITY_FRAME}
    # ...     Execute Javascript      return document.evaluate("count(//div[@class='slds-col cpq-items-container scroll']//div[@data='card'])", document, null, XPathResult.ANY_TYPE, null).numberValue;
    # ${i}=           Evaluate    random.randint(0, ${count})    modules=random
    # ${xpath}=       Set Variable    //div[@class='slds-col cpq-items-container scroll']//div[./div[@data='card']]/div
    # ${target_product}=      Run Inside Iframe   ${OPPORTUNITY_FRAME}
    # ...     Execute Javascript      return document.evaluate("${xpath}[${i}]//p[contains(@class,'product-name')]",document, null, XPathResult.ANY_TYPE, null).iterateNext().innerText;
    # Run Inside Iframe   ${OPPORTUNITY_FRAME}        Click Element   ${xpath}[${i}]//button[contains(text(),'Add to Cart')]
    ${target_product}=      Run Inside Iframe    ${OPPORTUNITY_FRAME}       Add Random Product To Cart
    Wait Until Product Appears In Cart (CPQ)        ${target_product}

Click CPQ At Opportunity View
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${OPPORTUNITY_CPQ_BUTTON}    30 seconds
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Click Element    ${OPPORTUNITY_CPQ_BUTTON}
    # Wait Until Keyword Succeeds    20 s    3 s    Run Inside Iframe    ${OPPORTUNITY_FRAME}
    # ...    Page Should Not Contain Element    ${OPPORTUNITY_CPQ_BUTTON}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    //div[contains(@class,'cpq-product-cart')]//a[text()='Cart']    30s
    # Capture Page Screenshot

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
    # Wait Until Keyword Succeeds    20 s    3 s    Run Inside Iframe    ${OPPORTUNITY_FRAME}
    # ...    Page Should Not Contain Element    ${CPQ_CREATE_ORDER}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Does Not Contain Element    ${CPQ_CREATE_ORDER}     1 min

Click Create Quote (CPQ)
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${CPQ_CREATE_QUOTE}    30 seconds
    Wait Until Keyword Succeeds    20 s    3 s
    ...    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Click Element    ${CPQ_CREATE_QUOTE}

Click Next (CPQ)
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    //*[text()='Next']      10s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Element   //*[text()='Next']

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

Click View Quote And Go Back To CPQ
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element        View Quote      20s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds     30s     1s     Click Element    View Quote
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element        //td[@id='topButtonRow']//input[@title='CPQ']
    Sleep   2
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Element   //td[@id='topButtonRow']//input[@title='CPQ']
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element        ${CPQ_CREATE_ORDER}

Fill Missing Required Information
    ${close_button}=        Set Variable        //div[contains(@class,'slds-modal')]//button[contains(text(),'Close')]
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Element   //div[@class='cpq-cart-item-root-product']//button[@title='Details']
    Run Keyword     Fill Required Information For ${PRODUCT}
    Sleep   0.5
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Element Is Not Visible
    ...         //div[contains(@class,'slds-modal')]//div[@class='modal-content-position modal-spinner-position']   20s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Element Is Not Visible
    ...         //div[@class='cpq-cart-item-root-product-messages']//span[contains(text(),'Required attribute missing')]    30s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         20s   1s    Click Element   ${close_button}
    # For some strange reason clicking the "close" can result in another load and the close button needs to be pressed a second time
    ${hidden}=     Run Keyword and Return Status       Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Element Is Not Visible
    ...         ${close_button}      5s
    Run Keyword If      not ${hidden}      Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         20s   1s    Click Element   ${close_button}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Element Is Not Visible
    ...         //div[@class='slds-modal__container']   10s
    [Teardown]      Run Keyword And Ignore Error      Run Inside Iframe    ${OPPORTUNITY_FRAME}     Click Element   ${close_button}

Fill Missing Required Information If Needed (CPQ)
    ${xpath}=   Set Variable    //h2[contains(text(),'Required attribute missing')]
    ${s}=   Run Inside Iframe   ${OPPORTUNITY_FRAME}    Run Keyword And Return Status   Wait Until Element is Visible    ${xpath}   30s
    Run Keyword if    ${s}      Wait Until Keyword Succeeds     30s     1s      Fill Missing Required Information

Fill Required Information For Telia Sopiva Pro L
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         10s   1s    Click Element   //div[contains(@class,'slds-modal')]//input[@type='radio' and @value='1']

Fill Required Information For Telia Yritysinternet
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element
    ...     //div[@id='cpq-lineitem-details-modal-content']//div[@class='cpq-cart-item-root-product-details']/div[contains(@class,'cpq-cart-item-root-product-cfg-attr')]//label[text()[contains(.,'Liittymän nopeus')]]/abbr[@title='required']    10s
    Log     BQA-1821 test case ends here
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         20s   1s    Select From List By Value   //div[@id='cpq-lineitem-details-modal-content']//div[@class='cpq-cart-item-root-product-details']/div[contains(@class,'cpq-cart-item-root-product-cfg-attr')]//select    1

Fill Required Information For Telia Yritysinternet Langaton
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         20s   1s    Select From List By Value   //div[@id='cpq-lineitem-details-modal-content']//div[@class='cpq-cart-item-root-product-details']/div[contains(@class,'cpq-cart-item-root-product-cfg-attr')]//select    1

Fill Required Information For Telia Yritysinternet Plus
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         20s   1s    Select From List By Value   //div[@id='cpq-lineitem-details-modal-content']//div[@class='cpq-cart-item-root-product-details']/div[contains(@class,'cpq-cart-item-root-product-cfg-attr')]//select    1

Fill Required Information For Microsoft Office 365
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         20s   1s    Input Text   //label[text()[contains(.,'Lisenssien määrä')]]/following-sibling::div//input      1
    ${email}        Create Unique Email
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Keyword Succeeds
    ...         20s   1s    Input Text   //label[text()[contains(.,'Lisäsähköpostiosoite')]]/following-sibling::div//input      ${email}

Load More Products (CPQ)
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element       //a[contains(text(),'Load More')]    20s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Does Not Contain Element    //div[@class='slds-spinner_container']      20s
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Element       //a[contains(text(),'Load More')]
    Sleep   0.2
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    //a[contains(text(),'Load More')]
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Does Not Contain Element    //div[@class='slds-spinner_container']      20s
    Capture Page Screenshot

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
    # Run Keyword If    ${exact_product}      Wait Until Product Appears In Cart (CPQ)      ${target_product}

Search For Product (CPQ)
    [Arguments]     ${target_product}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element        ${CPQ_SEARCH_FIELD}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Input Text                              ${CPQ_SEARCH_FIELD}    ${target_product}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Press Enter On                          ${CPQ_SEARCH_FIELD}

Select Sales Type For Order (CPQ)
    ${status}=      Run Keyword And Return Status   Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    //select[contains(@class,'slds-select slds-required')]      10s
    # All products do not need a sales type
    Return From Keyword If    not ${status}
    ...     AND         Return From Keyword
    ${length}=      Run Inside Iframe   ${OPPORTUNITY_FRAME}    Execute Javascript
    ...     return document.evaluate("count(//tr//select[contains(@class,'slds-select slds-required')])", document, null, XPathResult.ANY_TYPE, null).numberValue;
    :FOR   ${i}     IN RANGE    ${length}
    \   Run Inside Iframe   ${OPPORTUNITY_FRAME}    Select From List By Label   //tr[${i+1}]//select[contains(@class,'slds-select slds-required')]      New Money-New Services

Set Prices For Unmodelled Product (CPQ)
    [Arguments]     ${product}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Input Text      //td[text()='DataNet Multi']/following-sibling::td[1]/input     50      # one time total
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Input Text      //td[text()='DataNet Multi']/following-sibling::td[2]/input     50      # recurring total

Submit Order To Delivery (CPQ)
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${SUBMIT_ORDER_TO_DELIVERY}
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Click Element    ${SUBMIT_ORDER_TO_DELIVERY}
    Wait Until Keyword Succeeds    20 s    1 s    Confirm Action

Verify That Product In Cart Is Correct
    [Arguments]    ${target_product}=${PRODUCT}
    ${product_in_cart}=    Set Variable
    ...    //div[contains(@class, 'cpq-cart-item-title')]//div[contains(text(), '${target_product}')]
    Run Inside Iframe    ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element    ${product_in_cart}    20 s

Wait Until Product Appears In Cart (CPQ)
    [Arguments]     ${target_product}   ${amount}=1     ${timeout}=20s
    # Wait Until Keyword Succeeds     20s     1s
    # ...     Run Inside Iframe   ${OPPORTUNITY_FRAME}    Locator Should Match X Times    //span[@class='cpq-product-name' and contains(text(),'${target_product}')]      ${amount}
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Wait Until Page Contains Element        //span[@class='cpq-product-name' and contains(text(),'${target_product}')]      ${timeout}
