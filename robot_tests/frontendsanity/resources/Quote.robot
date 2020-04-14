*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Variables.robot
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Login.robot
*** Keywords ***

preview and submit quote
    [Arguments]    ${oppo_FOR}
    ${preview_quote}    Set Variable    //div[@title='Preview Quote']
    ${send_quote}    Set Variable    //div[@title='Send Quote Email']
    ${quote_n}    Set Variable    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span
    ${send_mail}    Set Variable    //p[text()='Send Email']
    ${submitted}    Set Variable    //a[@aria-selected='true'][@title='Submitted']
    wait until page contains element    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span   60s
    ${quote_number}    get text    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span
    #Log To Console    preview and submit quote
    ${path}=  get location
    ${status}    Run Keyword And Return Status    Wait Until page contains element     ${preview_quote}    60s
    Run Keyword If    ${status} == True    Reload Page
    Run Keyword If    ${status} == True    Sleep  50s
    click element    ${preview_quote}
    sleep    10s
    Capture Page Screenshot
    #log to console  to view the quote
    Execute Javascript    window.scrollTo(0,400)
    sleep  5s
    Capture Page Screenshot
    #log to console  clicked
    Sleep  10
    #Go Back
    go to   ${path}
    wait until page contains element    ${send_quote}   60s
    Click Element    ${send_quote}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    Run Keyword If    ${status} == False    Reload Page
    sleep    10s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Capture Page Screenshot
    #Sleep  30s
    ${status}=  Run Keyword And Return Status  Wait until page contains element   ${send_mail}    100s
    Run Keyword If   ${status}   Click Visible Element    ${send_mail}
    Run Keyword unless   ${status}  approve the quote   ${oppo_FOR}
    #Click Element    ${send_mail}
    Unselect Frame
    sleep    10s
    ${Quote_Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${submitted}    60s
    #Log To Console    Quote is submitted: \ \ ${Quote_Status}
    [Return]    ${quote_number}


approve the quote
    [Arguments]    ${oppo_FOR}
    ${page}=  get location
    click visible element   //div/p[text()="Next"]
    unselect frame
    reload page
    sleep  60s
    logoutAsUser    ${B2B_DIGISALES_LIGHT_USER}
    sleep  30s
    Login To Salesforce Lightning   ${SYSTEM_ADMIN_USER}    ${SYSTEM_ADMIN_PWD}
    sleep  20s
	Search Salesforce    ${oppo_FOR}
    #Input Text    //input[@name="Quote-search-input"]
    Wait Until Element Is Visible       //a[contains(text(),"Quote")]//following::a[text()="${oppo_FOR}"]       60s
    Click Element   //a[contains(text(),"Quote")]//following::a[text()="${oppo_FOR}"]
    sleep  10s
    creditscoreapproving
    logoutAsUser  ${SYSTEM_ADMIN_USER}
    Login to Salesforce as B2B DigiSales
    sleep  30s
    go to   ${page}
    Sending quote as email

CreditScoreApproving
    ${details}=    set variable    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    ${edit_approval}=    Set Variable    //button[@title='Edit Approval Status']
    sleep    30s
    click element    ${details}
    sleep    20s
    ScrollUntillFound    ${edit_approval}
    Execute Javascript    window.location.reload(true)
    sleep    40s
    click element    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    sleep    10s
    ScrollUntillFound    ${edit_approval}
    sleep    20s
    wait until page contains element    //button[@title='Edit Approval Status']    45s
    click element    //button[@title='Edit Approval Status']
    sleep    20s
    wait until page contains element    //div[@class='uiMenu']/div[@class='uiPopupTrigger']/div/div/a[text()='Not Approved'][1]    45s
    wait until element is enabled    //div[@class='uiMenu']/div[@class='uiPopupTrigger']/div/div/a[text()='Not Approved'][1]    45s
    Set Focus To Element    //div[@class='uiMenu']/div[@class='uiPopupTrigger']/div/div/a[text()='Not Approved'][1]
    capture page screenshot
    force click element    //div[@class='uiMenu']/div[@class='uiPopupTrigger']/div/div/a[text()='Not Approved'][1]
    Execute Javascript    window.location.reload(true)
    sleep    50s
    click element    //li[@class='tabs__item uiTabItem']/a[@class='tabHeader']/span[text()='Details']
    sleep    10s
    ScrollUntillFound    //button[@title='Edit Approval Status']
    sleep    50s
    click element    //button[@title='Edit Approval Status']
    sleep    10s
    click element    //div[@class='uiMenu']/div[@class='uiPopupTrigger']/div/div/a[text()='Not Approved'][1]
    sleep    5s
    force click element    //a[@title='Approved']
    sleep    2s
    sleep    50s
    sleep    2s
    click element    //button[@title='Save']
    sleep    20s
    Execute JavaScript    window.scrollTo(0,0)
    sleep    10s

Sending quote as email
    ${spinner}    Set Variable    //div[contains(@class,'slds-spinner--large')]
    ${send_mail}    Set Variable    //p[text()='Send Email']
    ${iframe}    Set Variable    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Sleep  40s
    ${status}    Wait Until Element Is Enabled    ${iframe}    60s
    Run Keyword If    ${status} == False    Reload Page
    Wait Until Element Is Enabled    ${iframe}    60s
    select frame    ${iframe}
    Sleep  30s
    Wait Until Element Is Visible    ${send_mail}    60s
    Capture Page Screenshot
    Click Element    ${send_mail}
    Unselect Frame


Manual Credit enquiry Button
    ${send_quote}    Set Variable    //div[@title='Send Quote Email']
    select frame   xpath=//div[contains(@class,'slds')]/iframe
    Wait until page contains element  //div[@class="panel-heading"]//h1[contains(text(),"Credit Score Validation")]   60s
    Wait until page contains element  //div//*[text()="Credit Score Not Accepted - Result: MAN"]  60s
    page should contain element	 //div//button[contains(text(),"Create Manual Credit Inquiry")]
    click button    //div//button[contains(text(),"Create Manual Credit Inquiry")]
    wait until page contains element  //div//h1[contains(text(),"Input Manual Credit Inquiry information")]  60s
    Wait Until Element Is Visible  //ng-form//textarea[@id="Description"]   50s
    sleep  5s
    input text   //ng-form//textarea[@id="Description"]   approve
    click element  //div//button[contains(text(),"Done")]
    unselect frame
    wait until page contains element    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span   60s
    ${quote_number}    get text    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span
    wait until page contains element    ${send_quote}   60s
    click element  ${send_quote}
    sleep  10s
    Wait Until Element Is Enabled    //div[contains(@class,'slds')]/iframe    60s
    select frame   xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //div//h1[contains(text(),"Credit Score result: Manual Credit Inquiry Case is not complete")]  60s
    ${value}    get text  //div[@class="slds-form-element__control"]//p//h3
    ${value} =  remove string   ${value}  Related Manual Credit Inquiry Case:
    ${value} =  remove string   ${value}   is waiting for decision.
    ${String_count} =  Get Line Count  ${value}
    #${Ending_position} =  Evaluate  ${String_count}-1
    ${value}=  Get Substring  ${value}  1  9
    log to console  ${value}
    #${value}  convert to number  ${value}
    unselect frame
    #logoutAsUser
    [Return]   ${value}  ${quote_number}


Activate The Manual Credit enquiry with positive
    [Arguments]  ${value}   ${Decision}
    reload page
    sleep  30s
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}   ${value}
    Sleep    2s
    Press Enter On    ${SEARCH_SALESFORCE}
    Wait Until Page Contains element    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a[@title='${value}']    120s
    Sleep    15s
    Click Element    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a[@title='${value}']
    wait until page contains element  //span[text()="Case Number"]  60s
    wait until page contains element  //a[text()="Case Details"]   30s
    sleep  30s
    click element  ${DETAILS_TAB}
    wait until page contains element  ${CHANGE_OWNER}  20s
    click element   ${CHANGE_OWNER}
    wait until page contains element  //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]  30s
    input text   //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]  Credit Control
    sleep  3s
    Press Enter On  //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]
    wait until page contains element  //a[text()="Full Name"]//following::a[text()='Credit Control']  60s
    click element     //a[text()="Full Name"]//following::a[text()='Credit Control']
    sleep  10s
    click element   ${CHANGE_OWNER_BUTTON}
    sleep  30s
    page should contain element  //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="In Progress"]
    force click element  //button[@title="Edit Decision"]
    #click element  //div//span/span[text()="Decision"]/../../div//a[@class="select"]
    select option from dropdown  //lightning-combobox//label[text()="Decision"]/..//div/*[@class="slds-combobox_container"]/div  ${Decision}
    click element   //button[@title="Save"]
    wait until page contains element    //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="Closed"]   60s
    page should contain element  //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="Closed"]
    logoutAsUser    Credit Control
    sleep  20s


Activate The Manual Credit enquiry with positive with condition
    [Arguments]  ${value}   ${Decision}
    reload page
    sleep  30s
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}   ${value}
    Sleep    2s
    Press Enter On    ${SEARCH_SALESFORCE}
    Wait Until Page Contains element    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a[@title='${value}']    120s
    Sleep    15s
    Click Element    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a[@title='${value}']
    wait until page contains element  //span[text()="Case Number"]  60s
    wait until page contains element  //a[text()="Case Details"]   30s
    sleep  30s
    click element  ${DETAILS_TAB}
    wait until page contains element  ${CHANGE_OWNER}  20s
    click element   ${CHANGE_OWNER}
    wait until page contains element  //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]  30s
    input text   //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]  Credit Control
    sleep  3s
    Press Enter On  //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]
    wait until page contains element  //a[text()="Full Name"]//following::a[text()='Credit Control']  60s
    click element     //a[text()="Full Name"]//following::a[text()='Credit Control']
    sleep  10s
    click element   ${CHANGE_OWNER_BUTTON}
    sleep  30s
    page should contain element  //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="In Progress"]
    force click element  //button[@title="Edit Decision"]
    #click element  //div//span/span[text()="Decision"]/../../div//a[@class="select"]
    select option from dropdown  //lightning-combobox//label[text()="Decision"]/..//div/*[@class="slds-combobox_container"]/div  ${Decision}
    select option from dropdown   //lightning-combobox//label[text()="Conditions"]/..//div/*[@class="slds-combobox_container"]/div  Other
    click element  //lightning-textarea//label[text()="Other Condition"]/..//textarea
    input text  //lightning-textarea//label[text()="Other Condition"]/..//textarea   testing
    click element   //button[@title="Save"]
    wait until page contains element    //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="Closed"]   60s
    page should contain element  //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="Closed"]
    logoutAsUser    Credit Control
    sleep  20s


credit score status after approval
    ${send_quote}    Set Variable    //div[@title='Send Quote Email']
    ${quote_n}    Set Variable    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span
    ${send_mail}    Set Variable    //p[text()='Send Email']
    wait until page contains element    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span   60s
    wait until page contains element    ${send_quote}   60s
    click element  ${send_quote}
    sleep  50s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Click Visible Element    ${send_mail}
    unselect frame
    #ClickonCreateOrderButton
    wait until page contains element        //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']       60s
    sleep  10s
    ##${expiry} =    get text    //*[text()='Expiration Date']
    ##log to console    ${expiry}
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



Activate The Manual Credit enquiry with Negative
    [Arguments]  ${value}   ${Decision}
    reload page
    sleep  30s
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}   ${value}
    Sleep    2s
    Press Enter On    ${SEARCH_SALESFORCE}
    Wait Until Page Contains element    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a[@title='${value}']    120s
    Sleep    15s
    Click Element    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a[@title='${value}']
    wait until page contains element  //span[text()="Case Number"]  60s
    wait until page contains element  //a[text()="Case Details"]   30s
    sleep  30s
    click element  ${DETAILS_TAB}
    wait until page contains element  ${CHANGE_OWNER}  20s
    click element   ${CHANGE_OWNER}
    wait until page contains element  //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]  30s
    input text   //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]  Credit Control
    sleep  3s
    Press Enter On  //*[contains(text(),"Change Case Owner")]//following::input[@title="Search People"]
    wait until page contains element  //a[text()="Full Name"]//following::a[text()='Credit Control']  60s
    click element     //a[text()="Full Name"]//following::a[text()='Credit Control']
    sleep  10s
    click element   ${CHANGE_OWNER_BUTTON}
    sleep  30s
    page should contain element  //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="In Progress"]
    force click element  //button[@title="Edit Decision"]
    #click element  //div//span/span[text()="Decision"]/../../div//a[@class="select"]
    select option from dropdown  //lightning-combobox//label[text()="Decision"]/..//div/*[@class="slds-combobox_container"]/div  ${Decision}
    click element   //button[@title="Save"]
    wait until page contains element  //div/strong[text()="Review the following fields"]  60s
    page should contain element     //div[text()="Please provide comments of negative decision."]
    click element  //li//a[text()="Decision Comments"]
    input text  //label[text()="Decision Comments"]/..//textarea  testing
    click element   //button[@title="Save"]
    wait until page contains element    //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="Closed"]   60s
    page should contain element  //div[@role="list"]//div//span[text()="Status"]/../../div[2]//span[text()="Closed"]
    logoutAsUser    Credit Control
    sleep  20s



openQuoteFromOppoRelated
    [Arguments]  ${oppo_no}  ${quote_no}
    go to entity  ${oppo_no}
    wait until page contains element  ${ACCOUNT_RELATED}   30s
    click element  ${ACCOUNT_RELATED}
    wait until page contains element   //a//span[@title='Opportunity Team']   30s
    scrolluntillfound  //a[text()='${quote_no}']
    click element  //a[text()='${quote_no}']
    #wait until page contains element  //span[text()='${quote_no}']/..//span[@class="uiOutputText"]   60s
    #page should contain element  //span[text()='${quote_no}']/..//span[@class="uiOutputText"]



Check prices are correct in quote line items
    sleep   10s
    Wait until page contains element   //a/span[text()='Quote Line Items']      30s
    Force click element   //a/span[text()='Quo


Validate the MRC and OTC and Opportunity total in CPQ
     [Arguments]    ${product1}  ${product2}  ${product3}
     Wait Until Element Is Enabled      //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product1}")]/../../../.././div[3]//span/span     60s
     ${mrc1}        get text    //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product1}")]/../../../.././div[3]//span/span
     ${mrc2}        get text   //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product2}")]/../../../.././div[3]//span/span
     ${mrc3}        get text   //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product3}")]/../../../.././div[3]//span/span
     ${otc1}        get text   //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product1}")]/../../../.././div[4]//div/span/span
     ${otc2}        get text   //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product2}")]/../../../.././div[4]//div/span/span
     ${otc3}        get text   //div[@class="cpq-product-cart-item"]//span[contains(text(),"${product3}")]/../../../.././div[4]//div/span/span
     ${rctotal}     get text   //div[@class="cpq-total-bar slds-col slds-no-flex"]/div//div//div[contains(text(),"Recurring Total")]/../div[2]
     ${otctotal}    get text   //div[@class="cpq-total-bar slds-col slds-no-flex"]/div//div//div[contains(text(),"OneTime Total")]/../div[2]
     ${oppo_total}  get text   //div[@class="cpq-total-bar slds-col slds-no-flex"]/div//div//div[contains(text(),"Opportunity Total")]/../div[2]
     #@{elements}    Set Variable    ${mrc1}    ${mrc2}    ${mrc3}    ${otc1}     ${otc2}     ${otc3}     ${rctotal}  ${otctotal}
     #${mrctotlacalculated_pratical}     remove string and convert to number    @{elements}
     ${mrc1} =  remove string  ${mrc1}  €
     ${mrc2} =  remove string  ${mrc2}  €
     ${mrc3} =  remove string  ${mrc3}  €
     ${otc1} =  remove string  ${otc1}  €
     ${otc2} =  remove string  ${otc2}  €
     ${otc3} =  remove string  ${otc3}  €
     ${rctotal} =  remove string  ${rctotal}  €
     ${otctotal} =  remove string  ${otctotal}  €
     ${oppo_total} =  remove string  ${oppo_total}  €
     ${otc1} =  convert to number   ${otc1}
     ${mrc1} =  convert to number   ${mrc1}
     ${mrc2} =  convert to number   ${mrc2}
     ${mrctotlacalculated_pratical} =  Evaluate   ${mrc1}+${mrc2}+${mrc3}
     #log to console     ${mrctotlacalculated_pratical}
     Should be equal as numbers     ${rctotal}      ${mrctotlacalculated_pratical}
     ${otctotalcalculated_pratical}=  evaluate  ${otc1} + ${otc2} + ${otc3}
     #log to console     ${otctotalcalculated_pratical}
     Should be equal as numbers     ${otctotal}      ${otctotalcalculated_pratical}
     ${oppototalcalculated_pratical} =  evaluate  ${mrctotlacalculated_pratical}+${otctotalcalculated_pratical}
     #log to console  ${oppototalcalculated_pratical}
     Should be equal as numbers     ${oppo_total}   ${oppototalcalculated_pratical}
     sleep  5s
     ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
     #Log to console      ${status}
     wait until page contains element    //span[text()='Next']/..    60s
     click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
     unselect frame
     Sleep  40s
     #${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe   60s
     #Run Keyword If    ${status} == False
     Reload Page
     sleep    40s
     Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
     select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
     page should contain element      //tr//td[contains(text(),"${product1}")]/../td[6]/span[contains(text(),"${otc1}")]
     page should contain element      //tr//td[contains(text(),"${product1}")]/../td[7]/span[contains(text(),"${mrc1}")]
     page should contain element     //tr//td[contains(text(),"${product2}")]/../td[7]/span[contains(text(),"${mrc2}")]
     #log to console  validation sucessful





validate createOPPO values against quote value
    [Arguments]    ${opportunity_quote}
    ${Revenue_Total} =  get text        //*[text()='Revenue Total' and @class='test-id__field-label']/../..//lightning-formatted-text
    ${fyr_total} =  get text           //*[text()='FYR Total' and @class='test-id__field-label']/../..//lightning-formatted-text
    ${onetime_total} =  get text         //*[text()='OneTime Total' and @class='test-id__field-label']/../..//lightning-formatted-text
    ${recurring_total} =  get text     //*[text()='Recurring Total' and @class='test-id__field-label']/../..//lightning-formatted-text
    ${opportunity_total} =  get text     //*[text()='Opportunity Total' and @class='test-id__field-label']/../..//lightning-formatted-text
    #log to console  open quote
    search salesforce    ${opportunity_quote}
    wait until page contains element  //div[@class="listViewContainer safari-workaround"]//div[@class="slds-cell-fixed"]//span[@title="Quote Name"]/../../../../../..//a[@title="${opportunity_quote}"]
    click element		//div[@class="listViewContainer safari-workaround"]//div[@class="slds-cell-fixed"]//span[@title="Quote Name"]/../../../../../..//a[@title="${opportunity_quote}"]
    sleep  15s
    wait until page contains element            //ul//span[@title="Quote Number"]
    Wait Until Element Is Visible       //div[contains(@class,'active')]//span[text()='Related']/../../../li[2]/a//span[@class="title"]     60s
    click element        //div[contains(@class,'active')]//span[text()='Related']/../../../li[2]/a//span[@class="title"]
    Sleep  10s
    scrolluntillfound   //span[text()="Quote Value and FYR"]//following::span[text()='Revenue Total' and @class='test-id__field-label']/../../div[2]/span/span
    wait until page contains element    //span[text()="Quote Value and FYR"]//following::span[text()='Revenue Total' and @class='test-id__field-label']/../../div[2]/span/span
    Element text should be  //span[text()="Quote Value and FYR"]//following::span[text()='Revenue Total' and @class='test-id__field-label']/../../div[2]/span/span      ${Revenue_Total}
    Element text should be  //span[text()="Quote Value and FYR"]//following::span[text()='FYR Total' and @class='test-id__field-label']/../../div[2]/span/span          ${fyr_total}
    Element text should be  //span[text()="Quote Value and FYR"]//following::span[text()='OneTime Total' and @class='test-id__field-label']/../../div[2]/span/span      ${onetime_total}
    Element text should be  //span[text()="Quote Value and FYR"]//following::span[text()='Recurring Total' and @class='test-id__field-label']/../../div[2]/span/span    ${recurring_total}
    Element text should be  //span[text()="Quote Value and FYR"]//following::span[text()='Quote Total' and @class='test-id__field-label']/../../div[2]/span/span        ${opportunity_total}
    [Return]    ${Revenue_Total}    ${fyr_total}


validate lineitem totals in quote
    [Arguments]     ${oppo_name}    ${lineitem_total}  ${fyr_total}
    click element  //div[contains(@class,'active')]//span[text()='Related']
    wait until page contains element     //span[@title="Quote Line Items"]
    click visible element  //span[@title="Quote Line Items"]//following::span[text()="View All"]
    Sleep  10s
    wait until page contains element    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr1}"]/../../..//td[9]/span/span
    ${fyr1}     get text    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr1}"]/../../..//td[9]/span/span
    ${fyr2}     get text    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr2}"]/../../..//td[9]/span/span
    #${fyr3}     get text    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr3}"]/../../..//td[9]/span/span
    ${lineitem1}    get text    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr1}"]/../../..//td[10]/span/span
    ${lineitem3}  get text    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr3}"]/../../..//td[10]/span/span
    ${lineitem2}    get text    //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]/../../../../../../../../..//a[@title="${B2bproductfyr2}"]/../../..//td[10]/span/span
    ${fyr1} =  remove string  ${fyr1}  €
    ${fyr2} =  remove string  ${fyr2}  €
    #${fyr3} =  remove string  ${fyr3}  €
    ${lineitem1}=  remove string  ${lineitem1}  €
    ${lineitem2}=  remove string  ${lineitem2}  €
    ${lineitem3}=  remove string  ${lineitem3}  €
    ${lineitem1}=  replace string  ${lineitem1}  ,  .
    ${lineitem2}=  replace string  ${lineitem2}  ,  .
    ${lineitem3}=  replace string  ${lineitem3}  ,  .
    ${fyr1} =  replace string  ${fyr1}  ,  .
    ${fyr2} =  replace string  ${fyr2}  ,  .
    #${lineitem_total}=  remove string  ${lineitem_total}  €
    #${lineitem_total}=  replace string  ${lineitem_total}  ,  .
    #${fyr_total}=  remove string  ${fyr_total}  €
    #${fyr_total}=  replace string  ${fyr_total}  ,  .
    ${fyr1} =  convert to number   ${fyr1}
    ${fyr2} =  convert to number   ${fyr2}
    ${lineitem1} =  convert to number   ${lineitem1}
    ${lineitem2} =  convert to number   ${lineitem2}
    ${lineitem3} =  convert to number   ${lineitem3}
    ${lineitem_total1}=  evaluate  ${lineitem1}+ ${lineitem2} +${lineitem3}
    #${lineitem_total1}  Set Variable    ${lineitem_total1}€
    ${fyr_total1} =   evaluate  ${fyr1}+ ${fyr2}
    #${fyr_total1} =  Set Variable  ${fyr_total1}€
    Should be equal as strings  ${lineitem_total1}  ${lineitem_total}
    Should be equal as strings  ${fyr_total1}   ${fyr_total}
    #log to console  line item total verfied sucessfully
    click element  //span[text()="Quotes"]/../../..//a[@title="${oppo_name}"]
    sleep  60s



UpdatePageNextButton
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    log to console    UpdateAndAddSalesType
    sleep    20s
    #Requires sleep to overcome dead object issue
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    Wait until element is visible  ${next_button}  30s
    click element    ${next_button}
    unselect frame


View Open Quote
    ${open_quote}=    Set Variable    //button[@id='Open Quote']    #//button[@id='Open Quote']
    ${view_quote}    Set Variable    //button[@id='View Quote']
    ${quote}    Set Variable    //button[contains(@id,'Quote')]
    ${central_spinner}    Set Variable    //div[@class='center-block spinner']
    wait until element is not visible    ${central_spinner}    120s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    #log to console    selected Create Quotation frame
    Wait Until Element Is Visible    ${quote}    120s
    ${quote_text}    get text    ${quote}
    ${open}    Run Keyword And Return Status    Should Be Equal As Strings    ${quote_text}    Open Quote
    ${view}    Run Keyword And Return Status    Should Be Equal As Strings    ${quote_text}    View Quote
    Run Keyword If    ${open} == True    click element    ${open_quote}
    Run Keyword If    ${view} == True    click element    ${view_quote}
    unselect frame
    sleep    20s



create another quote with same opportunity
    Wait Until Element Is Enabled    //div[contains(@class,'slds')]/iframe    60s
    Select Frame    //div[contains(@class,'slds')]/iframe
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Next']/..    Next
    Log to console      ${status}
    wait until page contains element    //span[text()='Next']/..    60s
    click element    xpath=//button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
    unselect frame
    sleep  30s
    Wait Until Element Is Enabled    //div[contains(@class,'slds')]/iframe    60s
    Select Frame    //div[contains(@class,'slds')]/iframe
    ${status}   set variable    Run Keyword and return status    Frame should contain    //button[contains(text(),"Next")]    Next
    Log to console      ${status}
    wait until page contains element    //button[contains(text(),"Next")]   60s
    click button    //button[contains(text(),"Next")]
    unselect frame
    #OpenQuoteButtonPage_release
    log to console  2

Sync quote
    wait until page contains element        //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']       60s
    sleep  10s
    force click element    //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']
    sleep    30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    Wait until page contains element   //button[@title="Sync Quote"]    60s
    click button  //button[@title="Sync Quote"]
    unselect frame
    #wait until page contains element    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span   60s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //a[@title='Details']   60s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
    Force Click element  //a[@title='Details']
    wait until page contains element  //div[@role="listitem"]//span[text()="Syncing"]    60s
    page should contain element   //div[@role="listitem"]//span[text()="Syncing"]/../../div[2]/span/span/img


Validation of Telia Domain Name Service
    [Documentation]  this is to validate the annnual,monthly,one time total charges in the quote page
    [Arguments]     ${Annual Recurring charge}  ${Monthly recurring chage}  ${One time total}
    wait until page contains element      ${quote_number}   60s
    click element  ${DETAILS}
    scrolluntillfound  ${Recurring Total(Exc. Reporting)}
    page should contain element   //div[@class="test-id__section-content slds-section__content section__content"]//span[text()="Annual Recurring Total"]/../..//div[2]/span/span[normalize-space(.)=text()="${Annual Recurring charge}"]
    page should contain element     //div[@class="test-id__section-content slds-section__content section__content"]//span[text()="Monthly Recurring Total"]/../..//div[2]/span/span[normalize-space(.)=text()="${Monthly recurring chage}"]
    page should contain element       //div[@class="test-id__section-content slds-section__content section__content"]//span[text()="OneTime Total"]/../..//div[2]/span/span[normalize-space(.)=text()="${One time total}"]
    ${Annual Recurring charge}=  remove string  ${Annual Recurring charge}  €
    ${Monthly recurring chage}=  remove string  ${Monthly recurring chage}  €
    ${One time total}=  remove string  ${One time total}  €
    ${Fyr_value} =  Evaluate   ${One time total}+(${Monthly recurring chage}*12)+${Annual Recurring charge}
    page should contain element     //div[@class="test-id__section-content slds-section__content section__content"]//span[text()="FYR Total"]/../..//div[2]/span/span[normalize-space(.)=text()="${Fyr_value} €"]


Verify that Credit Score Validation step is skipped
    [Documentation]  verify the quote page after update sales type is it  redirectly to quote page and the result of credit score.
    ${send_quote}    Set Variable    //div[@title='Send Quote Email']
    ${send_mail}    Set Variable    //p[text()='Send Email']
    ${submitted}    Set Variable    //a[@aria-selected='true'][@title='Submitted']
    wait until page contains element   //div[text()="Quote"]   60s
    wait until page contains element  //li//a[@title="Details"]  60s
    force click element  //li//a[@title="Details"]
    scrolluntillfound   //span[text()="Credit Score"]
    page should contain element    //span[text()="Credit Score"]//preceding::div[@class="test-id__field-label-container slds-form-element__label"]//following::span[text()="OK"]
    ${quote_number}    get text    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span
    wait until page contains element    ${send_quote}   60s
    click element  ${send_quote}
    sleep  10s
    Wait Until Element Is Enabled    //div[contains(@class,'slds')]/iframe    60s
    select frame   xpath=//div[contains(@class,'slds')]/iframe
    ${status}=  Run Keyword And Return Status  Wait until page contains element   ${send_mail}    100s
    Run Keyword If   ${status}   Click Visible Element    ${send_mail}
    Run Keyword unless   ${status}  Upadte the contact details for sending mail
    Unselect Frame
    sleep    30s
    ${Quote_Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${submitted}    60s


Upadte the contact details for sending mail
    [Documentation]   Upadte the existing contact details for sending mail if the email filed is missing in the sending quote mail page .
    ${page}  get location
    page should contain elementv    //span[contains(text(),"Email is missing on")]
    click element  //div[contains(text(),"Cancel")]
    wait until page contains element  //h2[contains(text(),"Confirm")]   60s
    click element  //button[@id="alert-ok-button"]
    wait until page contains element  //li//a[@title="Details"]  60s
    force click element  //li//a[@title="Details"]
    scrolluntillfound  //span[text()="Contact Name"]
    click element  //span[text()="Contact Name"]//following::div[1]//a
    wait until page contains element  //span[text()="Primary eMail"]//following::div[1]//a   60s
    ${mail_name}  get text  //span[text()="Primary eMail"]//following::div[1]//a
    click visible element  //span[text()="Email"]//following::div[1]//button
    click visible element  //input[@name="Email"]
    input text  //input[@name="Email"]   ${mail_name}
    click visible element    //button[@title="Save"]
    sleep  30s
    go to  ${page}
    click visible element  //p[text()='Send Email']


Check the credit score result of the Negative cases
    [Documentation]  Check the credit score result of the Negative cases
    ${send_quote}    Set Variable    //div[@title='Send Quote Email']
    ${quote_n}    Set Variable    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span
    ${send_mail}    Set Variable    //p[text()='Send Email']
    wait until page contains element    //div[contains(@class,'oneContent active')]//span[@title='Quote Number'][contains(text(),'Quote Number')]/../div/div/span   60s
    wait until page contains element    ${send_quote}   60s
    click element  ${send_quote}
    sleep  50s
    Wait Until Element Is Enabled    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe    60s
    select frame    //div[@class='windowViewMode-normal oneContent active lafPageHost']/div[@class='oneAlohaPage']/force-aloha-page/div/iframe
    page should contain element   //span[contains(text(),"Credit Score result: Manual Credit Inquiry Case is not approved")]
    page should contain element  //p//h3[text()="Decision: Negative"]
    click element  //div//p[text()="Next"]
    unselect frame
    wait until page contains element        //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']       60s
    sleep  10s
    force click element    //*[text()='Quote']//following::div[@role='group'][1]/ul/li/a/div[text()='CPQ']
    sleep    30s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    ${status}   set variable    Run Keyword and return status    Frame should contain    //span[text()='Create Order']/..    Create Order
    wait until page contains element    //span[text()='Create Order']/..    60s
    click element    //span[text()='Create Order']/..
    unselect frame
    Sleep  60s
    select frame    xpath=//div[contains(@class,'slds')]/iframe
    wait until page contains element  //h1[contains(text(),"Credit Score Validation")]   60s
    page should contain element     //div/small[text()="Manual Credit Inquiry case is not accepted. Decision: Negative"]

Validate the credit score is NO
    [Documentation]  Validate the credit score is NO
    select frame   xpath=//div[contains(@class,'slds')]/iframe
    Wait until page contains element  //div[@class="panel-heading"]//h1[contains(text(),"Credit Score Validation")]   60
    wait until page contains element  //div//small[text()="Quote Not Approved"]   60s
    page should contain element    //li//span[text()="You are not able to proceed with Quote or Order"]
    unselect frame

