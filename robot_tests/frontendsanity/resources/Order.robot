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
    ${location}=    Get Location
    set test variable   ${Order_url}   ${location}
    #log to console  ${order_no}.this is getorderstatusafgtersubmirting function
    Sleep  20s
    wait until page contains element    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Related']  60s
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
    #At times the Orchestration Plan is not visible in Related Page then get the Plan ID from Detail Page
    ${status} =    Run Keyword and Return status  Page should contain element   //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]
    Run Keyword if   ${status} == False    GetOrchestrationPlanfromDetail
#    scrolluntillfound    //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]
    #execute javascript    window.scrollTo(0,2000)
    sleep    10s
    #log to console    plan validation
#    wait until page contains element     //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]    30s
#    click element     //th[text()='Orchestration Plan Name']//ancestor::table//a[contains(@class,'textUnderline')]
     wait until page contains element   //span[text()='Orchestration Plan']   30s
#    click element   //span[text()='Orchestration Plan']
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




GetOrchestrationPlanfromDetail
   [Documentation]  In Orchestration Plan Page it capture the Plan ID from the Details TAB
    Reload page
    wait until page contains element    //span[@class='title' and text()='Details']    100s
    click element   //span[@class='title' and text()='Details']
    sleep  40s
    scrolluntillfound    //span[text()='Orchestration Plan']/following::div[1]//a[contains(@class,'textUnderline')]
    click element   //span[text()='Orchestration Plan']/following::div[1]//a[contains(@class,'textUnderline')]

Check the credit score result of the case with postive
    [Documentation]  Check the credit score result of the case with postive
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //button[contains(text(),"Create Order")]  60s
    page should contain element  //div//small[text()="Manual Credit Inquiry accepted. Decision: Positive"]
    page should contain element  //button[contains(text(),"Create Order")]
    click element  //button[contains(text(),"Create Order")]
    unselect frame
    Sleep  10s
    NextButtonOnOrderPage
    sleep  30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //section[@id='OrderTypeCheck']/section/div/div/div/h1  40s
    unselect frame
    OrderNextStepsPage

Check the credit score result of the case with Positive with Conditions
    [Documentation]  Check the credit score result of the case with Positive with Conditions
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //button[contains(text(),"Create Order")]  60s
    page should contain element  //div//small[text()="Manual Credit Inquiry accepted. Decision: Positive with Conditions"]
    page should contain element  //button[contains(text(),"Create Order")]
    click element  //button[contains(text(),"Create Order")]
    unselect frame
    Sleep  10s
    NextButtonOnOrderPage
    sleep  30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //section[@id='OrderTypeCheck']/section/div/div/div/h1  40s
    unselect frame
    OrderNextStepsPage

Change Order
    Initiate Change Order
    Request Date
    CPQ Page
    Order Post script


Initiate Change Order
     Go to entity   ${vLocUpg_TEST_ACCOUNT}
    #Go to entity   ${Account}
#    Page should contain element   //span[text()='Account ID']
#    Force Click element  //span[text()='Account ID']
    ${AssetHistory}   set variable   //button//span[text()='Asset History']
    Execute JavaScript    window.scrollTo(5000,4900)
    Page should contain element   ${AssetHistory}
    Log to console   Asset history found
    ${frame}  set variable  //button/span[text()='Asset History']/../../..//div[@class="content iframe-parent"]/iframe
    Page should contain element    ${frame}
    select frame  ${frame}
    ${status}   Run keyword and return status  Page should contain element   //li[@ng-repeat='prod in assetItems'][1]/div/div/input
    Run keyword if   ${status}   Page should contain element    //li[@ng-repeat='prod in assetItems'][1]/div/div/input
    Wait until page contains element   //li[@ng-repeat='prod in assetItems'][1]/div/div/input   60s
    page should contain checkbox    //li[@ng-repeat='prod in assetItems'][1]/div/div/input
    force Click element   //li[@ng-repeat='prod in assetItems'][1]/div/div/input
    sleep  5s
    Checkbox Should Be Selected   //li[@ng-repeat='prod in assetItems'][1]/div/div/input
    Capture Page Screenshot
    sleep  5s
    Log to console   Change Order Initiated
    ${status}   Run keyword and return status   Element Should Be Enabled   //button[text()='Change To Order']
    Force Click element  //button[text()='Change To Order']
    Unselect frame

Request date
    Wait until element is visible  //input[@id='RequestDate']   30s
    Click element  //input[@id='RequestDate']
    Wait until element is visible  //button[@title='Next Month']  30s
    Click element  //button[@title='Next Month']
    Click element  //tr[@id='week-0']/td[2]/span
    Click element  //div[@id='Request Date_nextBtn']

Verify the Action of child product
    [Arguments]  ${pname}  ${Value}
    ${Action_xpath}   set variable   //div[contains(text(),'${pname}')]//following::div[19]
    Wait until element is visible  ${Action_xpath}    60s
    ${Action}  Get Text  ${Action_xpath}
    Should be equal     ${Action}  ${Value}
    Log to console  The ACtion value for the product ${pname} is verified


Order Post script
    [Arguments]   ${contact_name}
    Select Account - no frame
    select contact - no frame   ${contact_name}
    Select Date - no frame
    Select account Owner - no frame
    Verify Order Type
    Submit Order Button
    ValidateTheOrchestrationPlan


Select Account - no frame
    [Documentation]    This is to search and select the account
    ${account_name}=    Set Variable    //div[@title='Search']
    ${account_checkbox}=    Set Variable    //td[@class='slds-cell-shrink']//span[@class='slds-checkbox--faux']
    ${search_account_next_button}=    Set Variable    //div[@id='SearchAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    sleep    5s
    Wait Until Element Is Visible    ${account_name}    120s
    click element    ${account_name}
    #sleep    3s
    Wait Until Element Is Visible    ${account_checkbox}    120s
    click element    ${account_checkbox}
    #sleep    3s
    Capture Page Screenshot
    Wait Until Element Is Visible    ${search_account_next_button}    120s
    Click Element    ${search_account_next_button}
    sleep  5s


select contact - no frame
    ${contact_search}=    Set Variable    //input[@id='OrderContactTA']
    ${contact_next_button}=    Set Variable    //div[@id='SelectOrderLevelContacts_nextBtn']
    ${updateContactDR}=    Set Variable    //button[@class='slds-button slds-button--neutral ng-binding ng-scope'][@ng-click='nextRepeater(child.nextIndex, child.indexInParent)']
    #Wait until element is visible   //div[contains(@class,'slds')]/iframe   30s
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    log to console    entering Technical COntact page
    Wait Until Element Is Visible    ${contact_search}    120s
    Input Text    ${contact_search}   ${contact_name}  # For Telia Communication Oy Account
    #sleep    15s
    Wait until element is visible   css=.typeahead .ng-binding   30s
    Click element   css=.typeahead .ng-binding
    ${status}=  Run keyword and return status   Element should be visible  //p[text()='Select Technical Contact:']
    Run Keyword if  ${status}  Enter technical contact
    Execute JavaScript    window.scrollTo(0,200)
    Sleep    5s
    ${status}=    Run Keyword and return status  Element should be visible  //p[text()='Copy technical contact from first product to other products']
    Run keyword if  ${status}  Click element   //p[text()='Copy technical contact from first product to other products']
    sleep  5s
    #sleep  10s
    Wait until element is visible   ${contact_next_button}  30s
    Click Element    ${contact_next_button}
    #unselect frame
    #sleep   10s


Select Date - no frame
    [Documentation]    Used for selecting \ requested action date
    ${additional_info_next_button}=    Set Variable    //div[@id='SelectRequestActionDate_nextBtn']//p
    #Wait until element is visible   //div[contains(@class,'slds')]/iframe  30s
    #select frame    xpath=//div[contains(@class,'slds')]/iframe
    #sleep    60s
    Wait until element is visible   ${additional_info_next_button}  60s
    ${status}    Run Keyword and Return Status    Page should contain element    //input[@id='RequestedActionDate']
    #Log to console    ${status}
    Run Keyword if    ${status}   Pick Date without product
    Run Keyword Unless    ${status}    Click Element    ${additional_info_next_button}
   # Unselect frame

Pick Date without product
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
    #sleep    5s
    Capture Page Screenshot
    Click Element    ${additional_info_next_button}


Select account Owner - no frame
    log to console    Select Owner Account FLow Chart Page
    log to console    entering Owner Account page
    ${owner_account}=    Set Variable    //ng-form[@id='BuyerAccount']//span[@class='slds-checkbox--faux']
    ${buyer_payer}=    Set Variable    //input[@id='BuyerIsPayer']/../span
    ${buyer_account_next_button}=    Set Variable    //div[@id='SelectedBuyerAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
    Wait Until Element Is Visible    ${buyer_payer}    120s
    sleep  10s
    #Click Element    ${owner_account}
    #Removing this as this will be ticked automatically as part fo feature delivered recently
    sleep    3s
    click element    ${buyer_payer}
    sleep    3s
    Wait Until Element Is Visible    ${buyer_account_next_button}    120s
    click element    ${buyer_account_next_button}
    sleep  3s
    log to console    Exiting owner Account page
    sleep    10s


Verify Order Type
    ${ACCOUNT_DETAILS}  set variable   //div[contains(@class,'active')]//span[text()='Details']//parent::a
    Wait until element is visible   ${ACCOUNT_DETAILS}  60s
    Force Click element  ${ACCOUNT_DETAILS}
    ${Order_Type}  get text   //div[@class='test-id__field-label-container slds-form-element__label']/span[text()='Order Type']//following::span[2]
    Should be equal   ${Order_Type}  Change


Submit Order Button
    Reload page
    Wait until element is visible   //div[@title='Submit Order']    60s
    Log to console    submitted
    Click element  //div[@title='Submit Order']
    #sleep  10s
    Capture Page Screenshot
    Wait until element is visible     //h2[text()='Submit Order']   30s
    sleep  5s
    Capture Page Screenshot
    ${status} =    Run Keyword and Return status  Page should contain element   //div[text()='Please add Group Billing ID.']
    Run Keyword if   ${status}  Enter Group id and submit
    Run Keyword unless   ${status}   click element   //button[text()='Submit']
    sleep  15s

Enter Group id and submit
    ${cancel}=  set variable    //span[text()='Cancel']
    ${Detail}=  set variable   //div[contains(@class,'active')]//span[text()='Details']//parent::a
    #${Group id}=  set variable   //span[text()='Edit Group Billing ID']
    ${Group Billing ID}=  set variable   //div/span[text()='Group Billing ID']
    ${status}   Run keyword and return status   Wait until element is visible   ${cancel}   30s
    Run keyword if   ${status}  Click element   ${cancel}
    sleep  3s
    Wait until element is visible   ${Detail}  60s
    Force click element   ${Detail}
    #sleep  10s
    Wait until element is visible  //span[text()='Edit Status']     30s
    Force Click element  //span[text()='Edit Status']
    sleep  3s
    Page should contain element  //label/span[text()='Group Billing ID']
    ScrollUntillFound    //label/span[text()='Group Billing ID']
    Select from search List     //input[@title='Search Group Billing IDs']     ${group_id}
    Wait until element is visible  //label/span[text()='Desired Installation Date']/..//following::input[1]   30s
    Force Click element  //label/span[text()='Desired Installation Date']/..//following::input[1]
    Click element   //a[@title='Go to next month']
    Wait until element is visible      //tr[@class='calRow'][2]/td[1]/span  30s
    Click element  //tr[@class='calRow'][2]/td[1]/span
    # Contract id issue at times in Order submition SAP Contract ID is not visible  during the submittion of order
    ${status}    Run keyword and return status   Page should contain element   //label/span[text()='SAP Contract ID']/..//following::input[1]
    Run Keyword If    ${status} == True    Input Text  //label/span[text()='SAP Contract ID']/..//following::input[1]  1010004095
    Wait until element is visible   //button[@title='Save']  30s
    Click element  //button[@title='Save']
    sleep  5s
    Wait until element is visible   //div[@title='Submit Order']    60s
    Click element  //div[@title='Submit Order']/..
    sleep  5s
    Capture Page Screenshot
    Wait until element is visible     //h2[text()='Submit Order']   30s
    click element   //button[text()='Submit']
    sleep  15s


Validate Order status
    Wait until page contains element   //a[text()='${order_no}']  60s
    Click element   //a[text()='${order_no}']
    ${Order status}  set variable   //span[@title='Status']/../div/div/span
    Wait until element is visible  ${Order status}   60s
    ${Status}  Get text   ${Order status}
    Should be equal   ${Status}   Completed
    Log to console  The Order is completed

clickonopenorderbutton
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element    //div//button[contains(text(),"Open Order")]    60s
    click button      //div//button[contains(text(),"Open Order")]
    unselect frame
    Sleep  30s


validatation on order page
    [Arguments]  ${fyr_total}    ${Revenue_Total}
    scrolluntillfound  //div[@class="container forceRelatedListSingleContainer"]//span[@title="Order Products"]//following::a[11]//span[text()="View All"]
    page should contain element     //div[@class="container forceRelatedListSingleContainer"]//span[@title="Order Products"]//following::a[text()="${B2bproductfyr1}"]
    page should contain element     //div[@class="container forceRelatedListSingleContainer"]//span[@title="Order Products"]//following::a[text()="${B2bproductfyr2}"]
    page should contain element     //div[@class="container forceRelatedListSingleContainer"]//span[@title="Order Products"]//following::a[text()="${B2bproductfyr3}"]
    sleep  20s
    Wait Until Element Is Enabled   //a[@title='Details']   60s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //a[@title='Details']   60s
    Run Keyword If    ${status_page} == False    Reload Page
    sleep    60s
    click element   //a[@title='Details']
    sleep  5s
    #${fyr_total1} =  Set Variable  ${fyr_total}€
    scrolluntillfound  //span[text()='FYR Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span
    Element text should be  //span[text()='FYR Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span  ${fyr_total}
    Element text should be  //span[text()='Revenue Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span    ${Revenue_Total}
    #log to console  validatation sucessfull on order page

Close and submit
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${status}   set variable   Run Keyword and Return Status   Frame should contain   //div[@id='Close']/p   Close
    Run Keyword if   ${status}   Click Element    //div[@id='Close']/p
    sleep  10s
    #sleep  15s
    Unselect frame
    Capture Page Screenshot
    Wait until element is visible     //h2[text()='Submit Order']   30s
    sleep  5s
    Capture Page Screenshot
    Enter Group id and submit


getMultibellaCaseGUIID
    [Arguments]  ${order_no}
    #go to entity  ${order_no}
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //span[text()='Details']  60s
    Run Keyword If    ${status_page} == False    Reload Page
    sleep    60s
    click element  //span[text()='Details']
    wait until page contains element  //span[text()='Fulfilment Status']/../following-sibling::div/span/span  60s
    Sleep  10s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible   //span[text()='MultibellaCaseGuiId']/../..//span[@class='uiOutputText']  60s
    Run Keyword If    ${status_page} == False    Reload Page
    sleep    60s
    ${case_GUI_id}  get text  //span[text()='MultibellaCaseGuiId']/../..//span[@class='uiOutputText']
    ${case_id}  get text  //span[text()='MultibellaCaseId']/../..//span[@class='uiOutputText']
    should not be equal as strings  ${case_GUI_id}  ${EMPTY}
    should not be equal as strings  ${case_id}  ${EMPTY}
    #log to console  ${case_GUI_id}.this is GUIId
    #log to console  ${case_id} .this is case id
    [return]  ${case_GUI_id}


Preview order summary and verify order
    [Arguments]    @{products}
    ${preview_order_summary}    Set Variable    //div[@title='Preview Order Summary']
    ${frame}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    ${prod}    Create List    @{products}
    ${count}    Get Length    ${prod}
    Wait Until Element Is Visible    ${preview_order_summary}    120s
    ${page} =  get location
    Click Element    ${preview_order_summary}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    ${frame}
    Run Keyword If    ${status} == False    Reload Page
    sleep    20s
    Wait Until Element Is Enabled    ${frame}    60s
    select frame    ${frame}
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > ${count}-1
    \    ${product_name}    Set Variable    @{products}[${i}]
    \    ${status}    Run Keyword And Return Status    ${product_name}
    \    Log    ${product_name} is present in order summary ${status}
    unselect frame
    sleep  10s
    go to  ${page}
    sleep  30s


FetchfromOrderproduct
    [Documentation]    Go to OrderProductPage and fetch the subscription ID
    [Arguments]    ${Ordernumber}
    Go To Entity    ${Ordernumber}
    wait until page contains element      ${Order_Related_Tab}   45s
    Force Click Element    ${Order_Related_Tab}
    sleep    10s
    wait until page contains element    ${Order_Products_Tab}    20s
    Force Click Element  ${Order_Products_Tab}
    sleep    10s
    sleep  10s
    click element  ${Order_Products_Select}
    sleep  20s
    Reload page
    wait until page contains element     ${Order_Products_Related_Tab}   60s
    Force Click Element   ${Order_Products_Related_Tab}
    log to console  related is clicked
    sleep  20s
    wait until page contains element  ${Order_Products_Assets_Tab}  60s
    click element  ${Order_Products_Assets_Tab}
    sleep  10s
    ${subscription_ID}   get text   ${Order_Products_SubID}
    sleep  3s
    [Return]   ${subscription_ID}