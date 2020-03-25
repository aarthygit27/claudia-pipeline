*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Variables.robot
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Login.robot
*** Keywords ***

ClickonCreateOrderButton
    wait until page contains element        //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']       120s
    sleep  10s
    force click element    //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']
    #force click element       //a[@title='CPQ']
    sleep    30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #Log to console      Inside frame
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Create Order']/..    Create Order
    #Log to console      ${status}
    wait until page contains element    //span[text()='Create Order']/..    60s
    click element    //span[text()='Create Order']/..
    #Sleep  30s
    unselect frame
    Sleep  60s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #Sleep  60s
    ${status}=  Run Keyword And Return Status  wait until page contains element    //p[text()="Order Products must have a unit price."]    60s
    Run Keyword If   ${status}   Order Products must have a unit price
    #sleep    30s
    unselect frame
    Sleep  10s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${status}=  Run Keyword And Return Status  wait until page contains element    //div//button[contains(text(),"Open Order")]    60s
    Run Keyword If   ${status}   click button      //div//button[contains(text(),"Open Order")]
    unselect frame
    Sleep  30s

Order Products must have a unit price
    Sleep  30s
    wait until page contains element    //button[text()="Continue"]  60s
    click element   //button[text()="Continue"]
    Sleep  60s
    unselect frame

NextButtonOnOrderPage
    #log to console    NextButtonOnOrderPage
    sleep  30s
    #click on the next button from the cart
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${status}    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    Log to console      ${status}
    wait until page contains element    //span[text()='Next']/..    120s
    click element    //span[text()='Next']/..
    unselect frame
    sleep    30s

OrderNextStepsPage
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    //*[contains(text(),'close this window')]    60s
    wait until page contains element    //*[@id="Close"]    60s
    click element    //*[@id="Close"]
    unselect frame
    sleep    20s


getOrderStatusBeforeSubmitting
    wait until page contains element    //span[@class='title' and text()='Details']    100s
    : FOR    ${i}    IN RANGE    10
    \   ${status}=    Run Keyword And Return Status   wait until page contains element  //span[@class='title' and text()='Details']    60s
    \   Run Keyword If   ${status} == False      reload page
    \   Exit For Loop If    ${status}
    #click element    //span[text()="Processed"]//following::li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    #click element   //span[text()="Mark Status as Complete"]/following::span[@class='title' and text()='Details']
    #//li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    Wait Until Element Is Enabled   //a[@title='Details']   60s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //a[@title='Details']   60s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
    click element  //a[@title='Details']
    #sleep  30s
    wait until page contains element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Status']/../following-sibling::div/span/span[text()='Draft']    90s
    wait until page contains element    //div[contains(@class,'-flexi-truncate')]//following::span[text()='Fulfilment Status']/../following-sibling::div/span/span[text()='Draft']    60s

clickOnSubmitOrder
    wait until page contains element  //a[@title='Submit Order']   120s
    click element  //a[@title='Submit Order']
    sleep   20s
    click element   //button[text()='Submit']
    Sleep       20s
    execute javascript   window.location.reload(true)
    sleep   40s


getOrderStatusAfterSubmitting
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //a[@title='Details']   60s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
    click element  //a[@title='Details']
    #Sleep  20s
    wait until page contains element  //span[text()='Fulfilment Status']/../following-sibling::div/span/span  80s
    ${fulfilment_status} =  get text  //span[text()='Fulfilment Status']/../following-sibling::div/span/span
    wait until page contains element    //span[text()='Status']/../following-sibling::div/span/span   60s
    ${status} =  get text  //span[text()='Status']/../following-sibling::div/span/span
    should not be equal as strings  ${fulfilment_status}  Error
    should not be equal as strings  ${status}  Error
    ${order_no}   get text   //div[contains(@class,'-flexi-truncate')]//following::span[text()='Order Number']/../following-sibling::div/span/span
    #log to console  ${order_no}.this is getorderstatusafgtersubmirting function
    click element     //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Related']
    [Return]   ${order_no}

Create Order from quote
    [Arguments]    ${quote_number}    ${oppo_name}
    ${CPQ}    Set Variable    //div[@title='CPQ']
    ${frame}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${create_order}    Set Variable    //button/span[text()='Create Order']
    ${view_button}    Set Variable    //button[@title='View']
    sleep    10s
    Search Salesforce    ${quote_number}
    Select Entity    ${oppo_name}    ${EMPTY}
    Wait Until Element Is Visible    ${CPQ}    60s
    click element    ${CPQ}
    sleep    10s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    ${frame}
    Run Keyword If    ${status} == False    Reload Page
    sleep    20s
    Wait Until Element Is Enabled    ${frame}    60s
    select frame    ${frame}
    Wait Until Element Is Visible    ${create_order}    60s
    click element    ${create_order}
    Unselect Frame
    sleep  60s
    select frame    ${frame}
    ${status}    Run Keyword And Return Status      Wait Until Element Is Visible    //button[contains(text(),"Open Order")]    60s
    Run Keyword If    ${status} == True    Click Element    //button[contains(text(),"Open Order")]
    Sleep   20s
    Unselect Frame

View order and send summary
    ${frame}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${view_button}    Set Variable    //div[@class="slds-button-group"]//button[@title="View"]
    ${preview_order}    Set Variable    //a/div[@title='Preview Order Summary']
    ${send_order_summary}    Set Variable    //a/div[@title='Send Order Summary Email']
    ${submit_order}    Set Variable    //a/div[@title='Submit Order']
    ${order_progress}    Set Variable    //a[@title='In Progress']/span[2]
    Sleep  30s
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    ${frame}
    Run Keyword If    ${status} == False    Reload Page
    Wait Until Element Is Enabled    ${frame}    60s
    select frame    ${frame}
    ${status}   set variable    Run Keyword and return status    Frame should contain    ${view_button}    View
    wait until page contains element    ${view_button}     120s
    click element   ${view_button}
    Unselect Frame
    Wait Until Element Is Enabled   ${preview_order}    120s
    ${page}=  get location
    click element    ${preview_order}
    sleep    7s
    Capture Page Screenshot
    sleep  10s
    go to  ${page}
    #Go Back
    Wait Until Element Is Visible    ${send_order_summary}    60s
    click element    ${send_order_summary}
    #Sending quote as email
    Sleep  20s
    Wait Until Element Is Enabled    ${submit_order}    60s
    click element    ${submit_order}
    Sleep  20s
    Wait Until Element Is Visible     //div/p[text()="Are you sure you want to submit this order?"]/..//button[text()="Submit"]     60s
    #Sleep  20s
    click element   //div/p[text()="Are you sure you want to submit this order?"]/..//button[text()="Submit"]
    #sleep    40s
    wait until page contains element    ${order_progress}    80s
    Capture Page Screenshot


SearchAndSelectBillingAccount
    [Arguments]   ${vLocUpg_TEST_ACCOUNT}
    execute javascript    window.location.reload(true)
    sleep    30s
    Wait until element is visible    //div[contains(@class,'slds')]/iframe   60s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until element is visible    //*[@id="ExtractAccount"]    60s
    click element    //*[@id="ExtractAccount"]
    wait until element is visible    //label[normalize-space(.)='Select Account']    30s
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until element is visible    //div[text()='${vLocUpg_TEST_ACCOUNT}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']    30s
    force click element    //div[text()='${vLocUpg_TEST_ACCOUNT}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    sleep    2s
    click element    //*[@id="SearchAccount_nextBtn"]
    unselect frame
    sleep    30s

select order contacts- HDC
    [Arguments]    ${d}= ${contact_technical}
    #${contact_search_title}=    Set Variable    //h3[text()='Contact Search']
    ${Technical_contact_search}=  set variable    //input[@id='TechnicalContactTA']
    ${contact_search}=    Set Variable    //input[@id='OrderContactTA']
    ${contact_next_button}=    Set Variable    //div[@id='SelectOrderLevelContacts_nextBtn']
    ${updateContactDR}=    Set Variable    //button[@class='slds-button slds-button--neutral ng-binding ng-scope'][@ng-click='nextRepeater(child.nextIndex, child.indexInParent)']
    ${primary_email}=    Run Keyword    Create Unique Email    ${DEFAULT_EMAIL}
    #Wait Until Element Is Visible    ${contact_search_title}    120s
    #Reload page
    #sleep   15s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #log to console    entering Technical COntact page
    Wait Until Element Is Visible    ${contact_search}    120s
    Input Text    ${contact_search}   ${d}
    sleep    15s
    Wait until element is visible   css=.typeahead .ng-binding   30s
    Click element   css=.typeahead .ng-binding
    sleep   10s
    Wait until element is visible  //input[@id='OCEmail']   30s
    Input Text   //input[@id='OCEmail']   ${primary_email}
    #Wait until element is visible    xpath=//ng-form[@id='OrderContactTA-Block']/div/div/div/child/div/ng-form/div[2]/div/ul/li/a    30s
    #Click Element    xpath=//ng-form[@id='OrderContactTA-Block']/div/div/div/child/div/ng-form/div[2]/div/ul/li/a
    Sleep    5s
    Execute JavaScript    window.scrollTo(0,200)
    Wait Until element is visible   ${Technical_contact_search}     30s
    Input text   ${Technical_contact_search}  ${d}
    sleep  10s
    Wait until element is visible   css=.typeahead .ng-binding  30s
    Click element   css=.typeahead .ng-binding
    sleep  10s
    Wait until element is visible  //input[@id='TCEmail']   30s
    Input Text   //input[@id='TCEmail']   ${primary_email}
    Execute JavaScript    window.scrollTo(0,200)
    #Wait until element is visible       xpath=//ng-form[@id='TechnicalContactTA-Block']/div/div/div/child/div/ng-form/div[2]/div/ul/li/a    30s
    #click element   xpath=//ng-form[@id='TechnicalContactTA-Block']/div/div/div/child/div/ng-form/div[2]/div/ul/li/a
    sleep  10s
    #${order_name}    set variable    //input[@id='OrderContactDetailsTypeAhead']
    #${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${order_name}    5s
    #run keyword if    ${status} == True    update order details
    Click Element    ${contact_next_button}
    unselect frame
    sleep   30s

RequestActionDate
    #log to console    selecting Requested Action Date FLow chart page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #log to console    entering Requested action date page
    wait until page contains element    //*[@id="RequestedActionDateSelection"]     30s
    click element   //*[@id="RequestedActionDateSelection"]
    ${date_requested}=    Get Current Date    result_format=%d-%m-%Y
    #${date_requested}=  Get Date From Future        1
    #log to console    ${d}
    input text    //*[@id="RequestedActionDateSelection"]     ${date_requested}
    sleep  10s
    #click element    //*[@id="Additional data_nextBtn"]
    Click element       //*[@id="SelectRequestActionDate_nextBtn"]
    unselect frame
    #log to console    Exiting    Requested Action Date page
    sleep    30s


SelectOwnerAccountInfo
    [Arguments]    ${e}= ${billing_account}
    #log to console    Select Owner Account FLow Chart Page
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    #log to console    entering Owner Account page
    Scrolluntillfound   //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
#    wait until element is visible    //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']    30s
    sleep   10s
    force click element   //div[text()='${e}']/..//preceding-sibling::td[2]/label/input[@type='checkbox']
    sleep  10s
#    unselect frame
    Scroll Page To Element       //*[@id="BuyerIsPayer"]//following-sibling::span
    sleep  10s
#    select frame   xpath=//div[contains(@class,'slds')]/iframe
    Wait until element is visible   //*[@id="BuyerIsPayer"]//following-sibling::span   30s
    #Log to console   Click BIP
    force click element  //*[@id="BuyerIsPayer"]//following-sibling::span
    ScrollUntillFound       //*[@id="SelectedBuyerAccount_nextBtn"]
    click element    //*[@id="SelectedBuyerAccount_nextBtn"]
    unselect frame
    sleep    30s

ValidateTheOrchestrationPlan
    wait until page contains element        //div[@class='slds-page-header__title slds-m-right--small slds-align-middle fade-text']/span        30s
    ${order_number}   get text  //div[@class='slds-page-header__title slds-m-right--small slds-align-middle fade-text']/span
    log to console  ${order_number}.this is order numner
    set test variable  ${order_no}   ${order_number}
    #Do not remove. Required for change order
    scrolluntillfound    //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]
    #execute javascript    window.scrollTo(0,2000)
    #sleep    10s
    #log to console    plan validation
    wait until page contains element     //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]    30s
    click element     //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]
    sleep    10s
    ${location}=    Get Location
    set test variable   ${url}   ${location}
    Wait until element is visible  xpath=//iframe[@title='accessibility title'][@scrolling='yes']   60s
    select frame    xpath=//iframe[@title='accessibility title'][@scrolling='yes']
    sleep    30s
    Element should be visible    //a[text()='Start']
    Element should be visible    //a[text()='Create Assets']
    Element should be visible    //a[text()='Deliver Service']
    Element should be visible    //a[text()='Order Events Update']
    Element should be visible   //a[text()='Call Billing System']
    #go back
    sleep   3s
    force click element       //a[@class='item-label item-header' and text()='Deliver Service']
    unselect frame
    #sleep       80s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //lightning-formatted-text[text()="Completed"]    60s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
    wait until page contains element    //lightning-formatted-text[text()="Completed"]     60s
    [Return]  ${order_number}

