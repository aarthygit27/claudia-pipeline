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
    ${Action}   set variable   //span[text()='${pname}']//following::div[13]/div
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

Check prices are correct in quote line items
    sleep   10s
    Wait until page contains element   //a/span[text()='Quote Line Items']      30s
    Force click element   //a/span[text()='Quo
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

Adding Vula
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

Adding Products
    [Arguments]    ${product-id}
    ${product}=    Set Variable    //div[@class="cpq-product-list"]//div[@class="slds-tile cpq-product-item"]//span[normalize-space(.)="${product-id}"]/../../..//button
    wait until page contains element    ${product}    60s
    Click Element    ${product}
    unselect frame


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

