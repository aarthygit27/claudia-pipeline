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
    Sending quote as email
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