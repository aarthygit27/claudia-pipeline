*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Variables.robot
Library           ../resources/customPythonKeywords.py

*** Keywords ***
Create New Opportunity For Customer
    [Arguments]    ${Case}    ${opport_name}=${EMPTY}    ${stage}=Analyse Prospect    ${days}=1    ${expect_error}=${FALSE}
    Click New Item For Account    New Opportunity
    Fill Mandatory Opportunity Information    ${stage}    ${days}
    Fill Mandatory Classification
    Click Save Button
    Sleep    10s
    Run Keyword If    '${Case}'== 'PASSIVEACCOUNT'    Validate Opportunity cannot be created    PASSIVEACCOUNT
    ...    ELSE    Run Keyword Unless    ${expect_error}    Verify That Opportunity Creation Succeeded

Fill Mandatory Opportunity Information
    [Arguments]    ${stage}=Analyse Prospect    ${days}=1
    ${opport_name}=    Run Keyword    Create Unique Name    TestOpportunity
    Set Test Variable    ${OPPORTUNITY_NAME}    ${opport_name}
    ${date}=    Get Date From Future    ${days}
    Set Test Variable    ${OPPORTUNITY_CLOSE_DATE}    ${date}
    Sleep    5s
    Input Quick Action Value For Attribute    Opportunity Name    ${OPPORTUNITY_NAME}
    Sleep    5s
    Select Quick Action Value For Attribute    Stage    ${stage}
    Sleep    5s
    Input Quick Action Value For Attribute    Close Date    ${OPPORTUNITY_CLOSE_DATE}

Verify That Opportunity Creation Succeeded
    Sleep    10s
    Wait Until Element Is Visible    ${ACCOUNT_RELATED}    60s
    Force click element    ${ACCOUNT_RELATED}
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    //span[@title='Account Team Members']
    Run Keyword If    ${status}    Run Keyword With Delay    0.10s    Click Element    xpath=${ACCOUNT_RELATED}
    Sleep    15s
    ScrollUntillFound    //span[text()='Opportunities']/../../span/../../../a
    #Scroll element into view    xpath=//span[text()='Opportunities']/../../span/../../../a
    Run Keyword And Continue On Failure    Scroll Page To Element    //span[text()='Opportunities']/../../span/../../../a
    ${element_xpath}=    Replace String    //span[text()='Opportunities']/../../span/../../../a    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    #Click Visible Element    //span[text()='Opportunities']/../../span/../../../a
    Verify That Opportunity Is Saved And Data Is Correct    ${RELATED_OPPORTUNITY}


Fill Mandatory Classification
    [Arguments]    ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    Set Test Variable    ${OPPO_DESCRIPTION}    Test Automation opportunity description
    Input Text    xpath=//label//span[contains(text(),'Description')]//following::textarea    ${OPPO_DESCRIPTION}

Click Save Button
    Click Element    ${SAVE_OPPORTUNITY}


ChangeThePriceList
    [Arguments]      ${price_list_new}
    ${price_list_old}=     get text        //span[text()='Price List']//following::a
    ${B2B_Price_list_delete_icon}=    Set Variable    //span[contains(text(),'PriceList__c')]/following::button[@title='Clear Selection'][1]
    #${B2B_Price_list_delete_icon}=    Set Variable    //span[@class='pillText'][contains(text(),'${price_list_old}')]/following::span[@class='deleteIcon'][1]
    #log to console    this is to change the PriceList
    #sleep    30s
    #Execute JavaScript    window.scrollTo(0,600)
    #scroll page to element    //button[@title="Edit Price Book"]
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


Editing Win prob
    [Arguments]    ${save}
    [Documentation]    This is to edit the winning probability of a opportunity
    ...
    ...    ${save}--> yes if there is nothing else to edit
    ...    no --> if there are other fields to edit
    ${win_prob_edit}=    Set Variable    //span[contains(text(),'Win Probability %')]/../../button
    ${win_prob}    set variable    //label[text()='Win Probability %']
    ${save_button}    set variable    //span[text()='Save']
    sleep       20s
    ScrollUntillFound       ${win_prob_edit}
    click element    ${win_prob_edit}
    Select option from Dropdown  //lightning-combobox//label[text()="Win Probability %"]/..//div/*[@class="slds-combobox_container"]/div    10%

Opportunity status
    ${oppo_status}    Set Variable    //a[@aria-selected='true'][@title='Negotiate and Close']
    sleep    10s
    Reload Page
    ${Oppo_Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${oppo_status}    60s

Closing the opportunity
    [Arguments]    ${stage1}
    #${stage_complete}=    set variable    //span[text()='Mark Stage as Complete']
    ${current_stage}=    set variable    //div[contains(@class,'test-id__field')]/span[contains(text(),'Stage')]/../../div/span[contains(@class,'field-value')]
    ${edit_stage}=    set variable    //button[@title='Edit Stage']
    #Wait Until Element Is Visible     ${stage_complete}    60s
    ${stage}=    Get Text    ${current_stage}
    Log To Console    The current stage is ${stage}
    Capture Page Screenshot
    click element    ${EDIT_STAGE_BUTTON}
    Sleep  30s
    Select option from Dropdown    //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   ${stage1}
    scrolluntillfound    //lightning-combobox//label[text()="Close Reason Category"]/..//div/*[@class="slds-combobox_container"]/div
    Scroll Page To Location    0    3000
    Sleep  20s
    Click element    //lightning-textarea//label[text()="Close Comment"]/../div/textarea
    Input Text    //lightning-textarea//label[text()="Close Comment"]/../div/textarea    this is a test opportunity to closed won
    #Execute Javascript    window.scrollTo(0,3000)
    Wait Until Page Contains Element    //lightning-combobox//label[text()="Close Reason Category"]/..//div/*[@class="slds-combobox_container"]/div   60s
    #Get Text    //span[contains(text(),'Service Address Street')]/../../span
    Select option from Dropdown     //lightning-combobox//label[text()="Relationship"]/..//div/*[@class="slds-combobox_container"]/div           Long
    Select option from Dropdown    //lightning-combobox//label[text()="Close Reason Category"]/..//div/*[@class="slds-combobox_container"]/div    Solution
    wait until page contains element  //lightning-combobox//label[text()="Close Reason"]/..//div/*[@class="slds-combobox_container"]/div   60s
    Select option from Dropdown  //lightning-combobox//label[text()="Close Reason"]/..//div/*[@class="slds-combobox_container"]/div   05 Availability
    Select option from Dropdown    //lightning-combobox//label[text()="Secondary Close Reason Category"]/..//div/*[@class="slds-combobox_container"]/div   Quality
    Select option from Dropdown    //lightning-combobox//label[text()="Secondary Close Reason"]/..//div/*[@class="slds-combobox_container"]/div    Service quality
    Wait Until Page Contains Element     //button[@title="Save"]   60s
    click element   //button[@title="Save"]
    sleep  30s

verifying quote and opportunity status
    [Arguments]    ${oppo_name}
    ${quote_status}    Set Variable    //a[@title='Submitted'][@aria-selected='true']
    ${oppo_stage}    Set Variable    //a[@title='Negotiate and Close'][@aria-selected='true']
    ${oppo_status}  Set Variable   //section[@class="tabs__content active uiTab"]//div[@class="slds-form-element__control slds-grid itemBody"]//span[text()="Offer Sent"]
    sleep    7s
    ${quote_s}    Run Keyword And Return Status    Page Should Contain Element    ${quote_status}
    Run Keyword If    ${quote_s} == True    Log To Console    The status of quote is Submitted
    Go To Entity    ${oppo_name}
    Reload Page
    sleep    7s
    ${oppo_s}    Run Keyword And Return Status    Page Should Contain Element    ${oppo_stage}
    Run Keyword If    ${oppo_s} == True    Log To Console    The status of opportunity is Negotiate and Close
    ${oppo_sent}   Run Keyword And Return Status    Page Should Contain Element    ${oppo_status}
    Run Keyword If    ${oppo_s} == True    Log To Console    The status of opportunity is opportunity sent


Closing the opportunity with reason
    [Arguments]    ${stage1}
    #${stage_complete}=    set variable    //span[text()='Mark Stage as Complete']
    ${current_stage}=    set variable    //div[contains(@class,'test-id__field')]/span[contains(text(),'Stage')]/../../div/span[contains(@class,'field-value')]
    ${edit_stage}=    set variable    //button[@title='Edit Stage']
    #Wait Until Element Is Visible     ${stage_complete}    60s
    ${stage}=    Get Text    ${current_stage}
    Log To Console    The current stage is ${stage}
    Capture Page Screenshot
    click element    ${EDIT_STAGE_BUTTON}
    Sleep  30s
    Select option from Dropdown    //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   ${stage1}
    scrolluntillfound    //lightning-combobox//label[text()="Close Reason Category"]/..//div/*[@class="slds-combobox_container"]/div
    Scroll Page To Location    0    3000
    Sleep  20s
    Click element    //lightning-textarea//label[text()="Close Comment"]/../div/textarea
    Input Text    //lightning-textarea//label[text()="Close Comment"]/../div/textarea    this is a test opportunity to closed won
    #Execute Javascript    window.scrollTo(0,3000)
    Wait Until Page Contains Element    //lightning-combobox//label[text()="Close Reason Category"]/..//div/*[@class="slds-combobox_container"]/div   60s
    #Get Text    //span[contains(text(),'Service Address Street')]/../../span
    Select option from Dropdown     //lightning-combobox//label[text()="Relationship"]/..//div/*[@class="slds-combobox_container"]/div           Long
    Select option from Dropdown    //lightning-combobox//label[text()="Close Reason Category"]/..//div/*[@class="slds-combobox_container"]/div    Solution
    wait until page contains element  //lightning-combobox//label[text()="Close Reason"]/..//div/*[@class="slds-combobox_container"]/div   60s
    Select option from Dropdown  //lightning-combobox//label[text()="Close Reason"]/..//div/*[@class="slds-combobox_container"]/div   05 Availability
    Select option from Dropdown    //lightning-combobox//label[text()="Secondary Close Reason Category"]/..//div/*[@class="slds-combobox_container"]/div   Quality
    Select option from Dropdown    //lightning-combobox//label[text()="Secondary Close Reason"]/..//div/*[@class="slds-combobox_container"]/div    Service quality
    Wait Until Page Contains Element     //button[@title="Save"]   60s
    click element   //button[@title="Save"]
    sleep  30s
    log to console   Check that opportunity cannot be updated after status has been set to Won.
    Scroll Page To Location    0   0
    wait until page contains element   ${EDIT_STAGE_BUTTON}    60s
    click element    ${EDIT_STAGE_BUTTON}
    Select option from Dropdown   //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   ${stage1}
    Wait Until Page Contains Element     //button[@title="Save"]   60s
    click element  //button[@title="Save"]
    Wait Until Page Contains Element   //div/strong[text()='Review the errors on this page.']    60s
    Click element   //button[@title="Close error dialog"]//*[@data-key="close"]
    Sleep  10s
    #Press ESC On    //span[text()='Review the following errors']
    click element   //button[@title="Cancel"]
    sleep  30s
    wait until page contains element  //*[text()="Create Continuation Sales Opportunity?"]   30s
    Page Should Contain Element   //*[text()="Create Continuation Sales Opportunity?"]
    log to console   Create Continuation Sales Opportunity is visible



Verify That Opportunity is Found From My All Opportunities
    [Arguments]    ${OPPORTUNITY_NAME}
    Open Tab    Opportunities
    Select Correct View Type  All Opportunities
    Filter Opportunities By    Opportunity Name    ${OPPORTUNITY_NAME}

Select Correct View Type
    [Arguments]    ${type}
    Sleep    20s
    #click element    //span[contains(@class,'selectedListView')]
    #Wait Until Page Contains Element    //span[@class=' virtualAutocompleteOptionText' and text()='${type}']    60s
    #Click Element    //span[@class=' virtualAutocompleteOptionText' and text()='${type}']//parent::a
    Select option from Dropdown with Force Click Element    //span[contains(@class,'selectedListView')]    //span[@class=' virtualAutocompleteOptionText' and text()='${type}']//parent::a
    Sleep    10s

Filter Opportunities By
    [Arguments]    ${field}    ${value}
    #${Count}=    get element count    ${RESULTS_TABLE}
    Click Element    //input[contains(@name,'search-input')]
    Wait Until Page Contains Element    ${SEARCH_INPUT}    60s
    Input Text    xpath=${SEARCH_INPUT}    ${value}
    Press Key    xpath=${SEARCH_INPUT}    \\13
    Sleep    10s
    #get_all_links
    Force click element    //table[contains(@class,'uiVirtualDataTable')]//tbody//tr//th//a[contains(@class,'forceOutputLookup') and (@title='${value}')]
    #Run Keyword If    ${Count} > 1    click visible element    xpath=${RESULTS_TABLE}[contains(@class,'forceOutputLookup') and (@title='${value}')]


Verify that warning banner is displayed on opportunity page
    [Arguments]    ${OPPORTUNITY_NAME}
    [Documentation]    After creating opportunity without service contract make sure warning banner is displayed on the opportunity page
    Go To Entity   ${OPPORTUNITY_NAME}
    #Wait until element is visible    ${OPPORTUNITY_WARNING_BANNER}  30s

Verify that warning banner is displayed on opportunity page sevice contract
    [Arguments]    ${OPPORTUNITY_NAME}
    [Documentation]    After creating opportunity without service contract make sure warning banner is displayed on the opportunity page
    Go To Entity   ${OPPORTUNITY_NAME}
    Wait until element is visible    ${SERVICE_CONTRACT_WARNING_oppo}  30s


Verify that warning banner is not displayed on opportunity page
    [Arguments]    ${oppo_name}
    [Documentation]    After creating oppotunity which has an active cutomer ship contract, the banner should not be available
    Go To Entity    ${oppo_name}
    Wait until element is visible   //div[@class='entityNameTitle slds-line-height_reset'][text()='Opportunity']   30s
    Page should not contain element    ${OPPORTUNITY_WARNING_BANNER}


Verify Warning banner about existing of duplicate contract
    [Arguments]    ${oppo_name}
    [Documentation]  This warning should Add product to cart (CPQ)be visible when multiple customer ship contract are available for the oppo
    Go To Entity    ${oppo_name}
    Wait until element is visible   //div[@class='entityNameTitle slds-line-height_reset'][text()='Opportunity']   30s
    Page should contain element     //div[@class="slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_info cContractStatusToasts"]//h2[text()='Note! Selected Account has multiple active customership contracts, please confirm that the pre-populated customership contract is valid for this opportunity.']

Verify Warning banner about Manual selection of contract
    [Arguments]    ${oppo_name}
    [Documentation]  This warning should be visible when multiple customer ship contract are available for the oppo
    Go To Entity    ${oppo_name}
    Wait until element is visible   //div[@class='entityNameTitle slds-line-height_reset'][text()='Opportunity']   30s
    Page should contain element     //div[@class="slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_info cContractStatusToasts"]//h2[text()='Note! Selected Account has multiple active customership contracts, please select the preferred customership contract manually on the record.']


CreateAOppoFromAccount_HDC
    [Arguments]    ${b}=${contact_name}
    #log to console    this is to create a Oppo from contact for HDC flow.${b}.contact
    Sleep  10s
    ${oppo_name}    create unique name    Test Robot Order_
    wait until page contains element    //li/a[@title="New Opportunity"]   60s
    #force click element    //li/a/div[text()='New Opportunity']
    click element    //li/a[@title="New Opportunity"]
    #sleep    30s
    wait until page contains element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[1]    60s
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[1]    ${oppo_name}
    sleep    3s
    ${close_date}    get date from future    10
    input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[2]    ${close_date}
    sleep    10s
    click element    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[3]
    Capture Page Screenshot
    Select from search List   //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[3]    ${b}
    #input text    //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[3]    ${b}
    #wait until page contains element    //*[@title='${b}']/../../..    10s
    #press enter on  //div[@class='modal-body scrollable slds-modal__content slds-p-around--medium']//following::label/span[text()='Opportunity Name']/following::input[3]
    #click element   //h2[contains(text(),"Contact Results")]//following::*[@title='Testing Contact_ 20190731-171453']/../../..
    #click element    //*[@title='${b}']/../../..
    sleep    2s
    input text    //textarea    ${oppo_name}.${close_date}.Description Testing
    click element    //button[@data-aura-class="uiButton"]/span[text()='Save']
    sleep    30s
    [Return]    ${oppo_name}


Adding partner and competitor
    [Documentation]    Used to add partner and competitor for a existing opportunity
    ${save_button}    set variable      //button[@title="Save"]
    ${competitor_list}    set variable    //ul[contains(@id,'source-list')]/li/div/span/span[text()='Accenture']
    ${partner_list}=    set variable    //ul[contains(@id,'source-list')]/li/div/span/span[text()='Accenture Oy']
    ${competitor_list_add}    set variable    //div[text()='Competitor']/../div/div/div/lightning-button-icon/button[@title='Move selection to Chosen']
    ${partner_list_add}    set variable    //div[text()='Partner']/../div/div/div/lightning-button-icon/button[@title='Move selection to Chosen']
    Execute Javascript    window.scrollTo(0,1700)
    Sleep  10s
    click element    ${competitor_list}
    click element    ${competitor_list_add}
    Capture Page Screenshot
    Execute Javascript    window.scrollTo(0,1900)
    Sleep  10s
    click element    ${partner_list}
    click element    ${partner_list_add}
    Capture Page Screenshot
    click element    ${save_button}
    Sleep  30s
    Capture Page Screenshot


Verify That Opportunity Is Found With Search And Go To Opportunity
    [Arguments]    ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    Go to Entity    ${OPPORTUNITY_NAME}
    Wait until Page Contains Element    ${OPPORTUNITY_PAGE}//*[text()='${OPPORTUNITY_NAME}']    60s
    Verify That Opportunity Is Saved And Data Is Correct    ${OPPORTUNITY_PAGE}

Verify That Opportunity is Found From My All Open Opportunities
    [Arguments]    ${account_name}=${LIGHTNING_TEST_ACCOUNT}    ${days}=1
    ${date}=    Get Date From Future    ${days}
    #${oppo_name}=    Set variable    TestOpportunity 20181228-103642
    ${oppo_name}=    Set Variable    //*[text()='${OPPORTUNITY_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']/../..//a[text()='${LIGHTNING_TEST_ACCOUNT}']
    ${oppo_date}=    Set Variable    //span[text()='Close Date']/../..//lightning-formatted-text[text()='${date}']
    Open Tab    Opportunities
    Select Correct View Type    My All Open Opportunities
    Filter Opportunities By    Opportunity Name    ${OPPORTUNITY_NAME}
    Sleep    10s
    Wait Until Page Contains Element    ${OPPORTUNITY_PAGE}${oppo_name}    60s
    Wait Until Page Contains Element    ${account_name}    60s
    Wait Until Page Contains Element    ${oppo_date}    60s

Verify That Opportunity Is Saved And Data Is Correct
    [Arguments]    ${element}    ${account_name}=${LIGHTNING_TEST_ACCOUNT}
    ${oppo_name}=    Set Variable    //*[text()='${OPPORTUNITY_NAME}']
    ${account_name}=    Set Variable    //span[text()='Account Name']/../..//a[text()='${LIGHTNING_TEST_ACCOUNT}']
    ${oppo_date}=    Set Variable    //span[text()='Close Date']/../..//lightning-formatted-text[text()='${OPPORTUNITY_CLOSE_DATE}']
    ScrollUntillFound    ${element}${oppo_name}
    Run Keyword And Continue On Failure    Scroll Page To Element    ${element}${oppo_name}
    Wait Until Page Contains Element    ${element}${oppo_name}    60s
    Run keyword and ignore error    Click element    ${element}${oppo_name}
    Sleep    10s
    Wait Until Page Contains Element    ${oppo_name}    60s
    Wait Until Page Contains Element    ${account_name}    60s
    Wait Until Page Contains Element    ${oppo_date}    60s


Validate Opportunity cannot be created
    [Arguments]    ${case}
    Run Keyword If    '${Case}'== 'PASSIVEACCOUNT'    Wait Until Element is Visible    ${NEW_ITEM_POPUP}//*[text()='Account is either not a Business Account or Legal Status is not Active! Please review the Account information.']
    ...    ELSE    element should not be visible   //a[@title='New Opportunity']


Cancel Opportunity and Validate
    [Arguments]    ${opportunity}    ${stage}
    Go to Entity    ${opportunity}
    click visible element    ${EDIT_STAGE_BUTTON}
    sleep    5s
    Select option from Dropdown    //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   ${stage}
    #click visible element    //div[@class="uiInput uiInput--default"]//a[@class="select"]
    #Press Key    //div[@class="uiInput uiInput--default"]//a[@class="select"]    ${stage}
    #Click Element    //a[@title="${stage}"]
    Sleep  30s
    Click element   //button[@title="Save"]
    Sleep  10s
    Validate error message
    Cancel and save
    Validate Closed Opportunity Details    ${opportunity}    ${stage}
    Verify That Opportunity is Not Found under My All Open Opportunities    ${opportunity}

Validate Closed Opportunity Details
    [Arguments]    ${opportunity_name}    ${stage}
    #${current_date}=    Get Current Date    result_format=%d.%m.%Y
    ${current_ts}=    Get Current Date
    ${c_date} =    Convert Date    ${current_ts}    datetime
    ${oppo_close_date}=    Set Variable    //div//span[text()='Close Date']/../../div[2]/span//lightning-formatted-text[text()='${c_date.day}.${c_date.month}.${c_date.year}']
    Go to Entity    ${opportunity_name}
    Scroll Page To Element    ${oppo_close_date}
    Wait Until Page Contains Element    ${oppo_close_date}    60s
    #Scroll Page To Element    ${OPPORTUNITY_CLOSE_DATE}
    #Wait Until Page Contains Element    ${OPPORTUNITY_CLOSE_DATE}    60s
    Wait Until Page Contains Element    //div//div/span[text()="Stage"]/../../div[2]/span//lightning-formatted-text[text()="${stage}"]    60s
    ${oppo_status}=    set variable if    '${stage}'== 'Closed Lost'    Lost    Cancelled
    ${buttonNotAvailable}=    Run Keyword And Return Status    element should not be visible    ${EDIT_STAGE_BUTTON}
    Run Keyword If    ${buttonNotAvailable}    reload page
    Click Visible Element    ${EDIT_STAGE_BUTTON}
    Select option from Dropdown     //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   Closed Won
    Save
    Wait Until Page Contains Element   //div/strong[text()='Review the following fields']    60s
    Click element   //button[@title="Close error dialog"]//*[@data-key="close"]
    Sleep  10s
    #Press ESC On    //span[text()='Review the following errors']
    click element   //button[@title="Cancel"]
     #Click element   //div[@class="riseTransitionEnabled test-id__inline-edit-record-layout-container risen"]//div[@class="actionsContainer"]//*[contains(text(),"Cancel")]

Save
    click element    //button[@title='Save']
    sleep    2s


Validate error message
    wait until element is visible    //li//a[text()="Close Comment"]    60s
    wait until element is visible   //li//a[text()="Close Reason"]    15s
    #element should be visible    //a[contains(text(),"Close Comment")]
    #element should be visible    //a[contains(text(),"Close Reason")]
    #element should be visible    //div[@data-aura-class="forcePageError"]

Cancel and save
    Scroll Page To Location    0    3000
    Click element    //lightning-textarea//label[text()="Close Comment"]/../div/textarea
    Input Text    //lightning-textarea//label[text()="Close Comment"]/../div/textarea    Cancelling the opportunity
    click element    //li//a[text()="Close Reason"]
    Scroll Page To Location     0  1400
    Sleep   10s
    Select option from Dropdown  //lightning-combobox//label[text()="Close Reason"]/..//div/*[@class="slds-combobox_container"]/div     09 Customer Postponed
    #sleep  3s
    #click element    //a[@title="09 Customer Postponed"]
    Sleep  10s
    Click element  //button[@title="Save"]
    Sleep    10s

Edit Opportunity
    [Arguments]    ${opportunity}
    Go to Entity    ${opportunity}

Verify That Opportunity is Not Found under My All Open Opportunities
    [Arguments]    ${opportunity}
    ${oppo_name}=    Set Variable    //*[text()='${opportunity}']    #${OPPORTUNITY_NAME}
    Open Tab    Opportunities
    Select Correct View Type    My All Open Opportunities
    Wait Until Page Contains Element    ${SEARCH_INPUT}    60s
    Input Text    ${SEARCH_INPUT}    ${opportunity}
    Press Key    ${SEARCH_INPUT}    \\13
    Sleep    10s
    Page should contain element    //*[text()='No items to display.']

Validate that Tellu login page opens
    [Documentation]     Validate that Tellu login page opens in new window.
    sleep   10s
    Select Window   NEW
    Maximize browser window
    Execute Javascript    window.location.reload(false);
    # Title should be     Teamworks Process Server Console
    Wait until page contains element    //form[@name='login']       30s


AddOppoTeamMember
    [Arguments]   ${oppo_name}      ${team_mem_1}
    go to entity  ${oppo_name}
    wait until page contains element  //li[@title="Related"]//a[text()="Related"]  30s
    click element  //li[@title="Related"]//a[text()="Related"]
    scrolluntillfound  //div[text()='Add Opportunity Team Members']
    wait until page contains element  //a/span[text()='Opportunity Team']  30s
    wait until page contains element  //div[text()='Add Opportunity Team Members']  30s
    force click element  //div[text()='Add Opportunity Team Members']
    wait until page contains element  //h2[text()='Add Opportunity Team Members']   30s
    wait until page contains element   //span[text()='Edit Team Role: Item 1']/..   30s
    force click element  //span[text()='Edit Team Role: Item 1']/..
    wait until page contains element  //a[@class='select' and text()='--None--']  30s
    force click element   //a[@class='select' and text()='--None--']
    wait until page contains element   //a[@title='Account Owner']   30s
    force click element  //a[@title='Account Owner']
    wait until page contains element  //span[text()='Edit User: Item 1']/..   30s
    force click element  //span[text()='Edit User: Item 1']/..
    sleep  3s
    wait until page contains element    //input[@title='Search People']   30s
    input text  //input[@title='Search People']   ${team_mem_1}
    sleep  3s
    wait until page contains element   //div[@title='${team_mem_1}']   30s
    force click element  //div[@title='${team_mem_1}']
    wait until page contains element   //span[text()='Edit Opportunity Access: Item 1']/..  30s
    force click element  //span[text()='Edit Opportunity Access: Item 1']/..
    sleep  3s
    wait until page contains element   //a[@class='select' and text()='Read Only']   30s
    force click element   //a[@class='select' and text()='Read Only']
    wait until page contains element   //a[@title='Read/Write']   30s
    force click element  //a[@title='Read/Write']
    wait until page contains element  //div[@class="modal-footer slds-modal__footer"]//button[@title="Save"]  30s
    force click element  //div[@class="modal-footer slds-modal__footer"]//button[@title="Save"]
    Sleep  20s
    #click element   //div//span[text()="View All"]
    ${status_page}    Run Keyword And Return Status    wait until page contains element   //a[text()='${team_mem_1}']   60s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False   wait until page contains element    //span[@class='title' and text()='Related']    60s
    Run Keyword If    ${status_page} == False   click element  //span[@class='title' and text()='Related']
    wait until page contains element    //a[text()='${team_mem_1}']   30s
    page should contain element   //a[@title='${team_mem_1}']
    #logoutAsUser  Sales Admin
    #login to salesforce as digisales lightning user vlocupgsandbox
    #swithchtouser  B2B DigiSales


SalesProjectOppurtunity
    [Arguments]  ${case_number}
    reload page
    sleep  25s
    click element  ${DETAILS_TAB}
    wait until page contains element  //button[@title='Edit Subject']     60s
    click element  //button[@title='Edit Subject']
    #wait until element is visible  //a[@class='select' and text()='New']   30
    #click element  //a[@class='select' and text()='New']
    #sleep  3s
    #click element  //a[@title="In Case Assessment"]
    ${date}  get date from future  7
    Wait Until Element Is Visible    //div//label[text()='Offer Date']/..//following-sibling::div/input    60s
    Input Text    //div//label[text()='Offer Date']/..//following-sibling::div/input    ${date}
    #Input Quick Action Value For Attribute    Offer Date    ${date}
    #input text   //span[text()='Offer Date']/../following-sibling::div/input   ${date}
    Scroll Page To Location    0    2500
    select checkbox  //input[@name="telia_support_functions_sales_project__c"]
    Scroll Page To Location    0    1400
    select option from dropdown  //lightning-combobox//label[text()="Case Assessment Outcome"]/..//div/*[@class="slds-combobox_container"]/div  Sales Project
    #force click element  //a[@class='select' and text()='--None--']
    #click element   //a[@title='Sales Project']
    Sleep   10s
    force click element     //button[@title='Save']
    #Log to console      Case Saved
    Scroll Page To Location    0    0
    force click element  //a[text()="Feed"]
    wait until page contains element  //span[text()='Assign Support Resource' and @class="title"]   30s
    force click element  //span[text()='Assign Support Resource' and @class='title']
    wait until page contains element  //span[text()='Assigned Resource']  30s
    input text   //span[text()='Assigned Resource']/../following::input[@title="Search People"]   B2B DigiSales
    sleep  10s
    click element  //div[@title="B2B DigiSales"]
    #wait until element is visible  //a[@class='select' and text()='Solution Design']   20s
    #click element  //a[@class='select' and text()='Solution Design']
    sleep   10s
    #wait until element is visible   //div[@class='select-options']//ul//li[5]/a  60s
    #force click element  //div[@class='select-options']//ul//li[5]/a
    Select option from Dropdown with Force Click Element    //a[@class='select']   //div[@class='select-options']//ul//li[6]/a[@title='Sales Project']
    #log to console      dropdown selected
    sleep  5s
    click element  //span[text()='Sales Support Case Lead']/../..//input[@type="checkbox"]
    scroll page to location  0  200
    wait until page contains element  //div[@class='bottomBarRight slds-col--bump-left']//span[text()="Save"][1]/..  20s
    wait until element is visible  //div[@class='bottomBarRight slds-col--bump-left']//span[text()="Save"][1]/..  20s
    click element  //div[@class='bottomBarRight slds-col--bump-left']//span[text()="Save"][1]/..
    capture page screenshot
    #Log to console      enter comments
    sleep   10s
    Force click element     //span[text()='Comment']
    sleep   10s
    Input Text      //textarea[@class=' textarea']      Test Comments
    #Log to console      save comments
    sleep   10s
    Force click element  //button[@class='slds-button slds-button--brand cuf-publisherShareButton MEDIUM uiButton']/span
    sleep   10s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible   //span[text()='Commit Decision']  60s
    Run Keyword If    ${status_page} == False    Reload Page
    sleep    60s
    #Wait until element is visible   //span[text()='Commit Decision']    60s
    Force click element  //span[text()='Commit Decision']
    sleep   15s
    Wait until element is visible   //button[@title='Next']     30s
    force click element  //button[@title='Next']


Closing Opportunity as Won with FYR
    [Arguments]    ${quantity}    ${continuation}
    ${FYR}=    set variable    //p[@title='FYR Total']/..//lightning-formatted-text
    Go To Salesforce and Login into Lightning       B2B DigiSales
    Go To Entity    ${TEST_ACCOUNT_CONTACT}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    #log to console    ${contact_name}.this is name
    sleep    10s
    ${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    ${contact_name}
    #${oppo_name}    run keyword    CreateAOppoFromAccount_HDC    Chetan
    #${oppo_name}    set variable    Test Robot Order_ 20191205-162925
    #Log to console    ${oppo_name}
    Go To Entity    ${oppo_name}
    ClickingOnCPQ   ${oppo_name}
    #go to  https://telia-fi--release.lightning.force.com/one/one.app#eyJjb21wb25lbnREZWYiOiJvbmU6YWxvaGFQYWdlIiwiYXR0cmlidXRlcyI6eyJhZGRyZXNzIjoiaHR0cHM6Ly90ZWxpYS1maS0tcmVsZWFzZS5saWdodG5pbmcuZm9yY2UuY29tL2FwZXgvdmxvY2l0eV9jbXRfX09tbmlTY3JpcHRVbml2ZXJzYWxQYWdlP2lkPTAwNjZFMDAwMDA4VE5UNlFBTyZ0cmFja0tleT0xNTc1NjM1NjQ0OTA5Iy9PbW5pU2NyaXB0VHlwZS9PcHBvcnR1bml0eSUyMFByb2R1Y3QvT21uaVNjcmlwdFN1YlR5cGUvT0xJJTIwRmllbGRzL09tbmlTY3JpcHRMYW5nL0VuZ2xpc2gvQ29udGV4dElkLzAwNjZFMDAwMDA4VE5UNlFBTy9QcmVmaWxsRGF0YVJhcHRvckJ1bmRsZS8vdHJ1ZSJ9LCJzdGF0ZSI6e319
    searching and adding Telia Viestintäpalvelu VIP (24 kk)    Telia Viestintäpalvelu VIP (24 kk)
    updating settings Telia Viestintäpalvelu VIP (24 kk)
    #search products    Telia Taloushallinto XXL-paketti
    #Adding Telia Taloushallinto XXL-paketti
    UpdateAndAddSalesTypewith quantity    Telia Viestintäpalvelu VIP (24 kk)    ${quantity}
    #OpenQuoteButtonPage_release
    Go To Entity    ${oppo_name}
    #Closing the opportunity    ${continuation}
    sleep    15s
    Capture Page Screenshot
    ${FYR_value}=    get text    ${FYR}
    #Log to console    The FYR value is ${FYR_value}


Closing the opportunity and check Continuation
    [Arguments]    ${stage1}
    #${stage_complete}=    set variable    //span[text()='Mark Stage as Complete']
    ${current_stage}=    set variable    //div[contains(@class,'test-id__field')]/span[contains(text(),'Stage')]/../../div/span[contains(@class,'field-value')]
    ${edit_stage}=    set variable    //button[@title='Edit Stage']
    #Wait Until Element Is Visible    ${stage_complete}    60s
    ${stage}=    Get Text    ${current_stage}
    Log To Console    The current stage is ${stage}
    Capture Page Screenshot
    click element    ${EDIT_STAGE_BUTTON}
    Sleep  30s
    Select option from Dropdown   //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   ${stage1}
    #Wait Until Page Contains Element    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Close Reason')]/../../div/div/div/div/a    60s
    Execute Javascript    window.scrollTo(0,7000)
    #Get Text    //span[contains(text(),'Service Address Street')]/../../span
    Select option from Dropdown    //lightning-combobox//label[text()="Close Reason"]/..//div/*[@class="slds-combobox_container"]/div    08 Other
    Scroll Page To Location    0    3000
    Click element    //lightning-textarea//label[text()="Close Comment"]/../div/textarea
    Input Text    //lightning-textarea//label[text()="Close Comment"]/../div/textarea    this is a test opportunity to closed won
    #sleep  30s
    Wait Until Page Contains Element     //button[@title="Save"]   60s
    click element    //button[@title="Save"]
    sleep  30s
    wait until page contains element  //*[text()="Create Continuation Sales Opportunity?"]   30s
    Page Should Contain Element   //*[text()="Create Continuation Sales Opportunity?"]
    log to console   Create Continuation Sales Opportunity is visible

Check opportunity value is correct
    ScrollUntillFound    //h3/button/span[text()='Opportunity Value and FYR']
    Wait until page contains element    //span[text()='OneTime Total']/../../../div/div[2]/span//lightning-formatted-text[text()='200,00 €']    30s
    Wait until page contains element    //span[text()='Monthly Recurring Total']/../../../div/div[2]/span//lightning-formatted-text[text()='200,00 €']   30s


validate createdOPPO for products
    [Arguments]    ${opportunity_product}
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible   //li[@title="Related"]//a[text()="Related"]   60s
    Run Keyword If    ${status_page} == False    Reload Page
    wait until page contains element    //li[@title="Related"]//a[text()="Related"]    60s
    click element    //li[@title="Related"]//a[text()="Related"]
    sleep  20s
    ScrollUntillFound    //div[@class="container rlvm forceRelatedListSingleContainer"]/../div[3]//div[@class="slds-card__footer"]/span
    page should contain element    //div[@class="container rlvm forceRelatedListSingleContainer"]/../div[3]//div[@class="slds-card__footer"]/span
    ${pageurl} =  get location
    click element       //div[@class="container rlvm forceRelatedListSingleContainer"]/../div[3]//div[@class="slds-card__footer"]/span
    wait until page contains element    //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr1}"]      60s
    page should contain element     //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr1}"]
    page should contain element      //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr2}"]
    page should contain element     //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr3}"]
    ${otc1} =    get text  //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr1}"]//following::td[4]/span/span
    ${otc2}=     get text  //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr2}"]//following::td[4]/span/span
    ${otc3}=     get text  //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr3}"]//following::td[4]/span/span
    ${rc1}=      get text  //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr1}"]//following::td[5]/span/span
    ${rc2}=      get text  //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr2}"]//following::td[5]/span/span
    ${rc3}       get text  //a[@title="${opportunity_product}"]//following::a[@title="${B2bproductfyr3}"]//following::td[5]/span/span
    ${otc1}=  remove string  ${otc1}  €
    ${otc2}=  remove string  ${otc2}  €
    ${otc3}=  remove string  ${otc3}  €
    ${rc1} =  remove string  ${rc1}  €
    ${rc2} =  remove string  ${rc2}  €
    ${rc3} =  remove string  ${rc3}  €
    ${otc1}=  replace string  ${otc1}  ,  .
    ${otc2}=  replace string  ${otc2}  ,  .
    ${otc3}=  replace string  ${otc3}  ,  .
    ${rc1}=  replace string  ${rc1}  ,  .
    ${rc2}=  replace string  ${rc2}  ,  .
    ${rc3}=  replace string  ${rc3}  ,  .
    ${otc1}=  convert to number   ${otc1}
    #${otc2}=  convert to integer   ${otc2}
    ${otc3}=  convert to number   ${otc3}
    ${rc1} =  convert to number   ${rc1}
    ${rc2} =  convert to number   ${rc2}
    ${rc3} =  convert to number   ${rc3}
    ${fyr1m}=  evaluate  ${fixed_charge for_Telia Sopiva Pro N}*${contract_lenght}
    ${fyr1ma} =  evaluate  ${fyr1m}+${otc1}
    ${fyr1}=  evaluate  ${fyr1ma}*${product_quantity}
    ${fyr2m}=  evaluate  ${rc2}*${contract_lenght}
    ${fyr2ma} =  evaluate  ${fyr2m}+${otc2}
    ${fyr2}=  evaluate  ${fyr2ma}*${product_quantity}
    ${lineitem1m} =   evaluate  ${rc1}* ${contract_lenght}+ ${otc1}
    ${lineitem1}=  evaluate  ${lineitem1m}*${product_quantity}
    ${lineitem2m} =   evaluate  ${rc2}* ${contract_lenght}+ ${otc2}
    ${lineitem2}=  evaluate  ${lineitem2m}*${product_quantity}
    ${lineitem3m} =   evaluate  ${rc3}* ${contract_lenght}+ ${otc3}
    ${lineitem3}=  evaluate  ${lineitem3m}*${product_quantity}
    ${lineitem_total}=  evaluate  ${lineitem1}+ ${lineitem2} +${lineitem3}
    ${fyr_total} =   evaluate  ${fyr1}+ ${fyr2}
    Capture Page Screenshot
    sleep  10s
    go to  ${pageurl}
    Sleep  40s
    log to console  1
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible   ${DETAILS_TAB}   40s
    Run Keyword If    ${status_page} == False    Reload Page
    sleep    60s
    click element  ${DETAILS_TAB}
    scrolluntillfound  //*[text()='Revenue Total' and @class='test-id__field-label']/../..
    #${lineitem_totalt}   get text  //span[text()='Revenue Total' and @class='test-id__field-label']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span
    ${fyr_totalt}    get text     //*[text()='FYR Total' and @class='test-id__field-label']/../..//lightning-formatted-text
    #${lineitem_totalt}=  remove string  ${lineitem_totalt}  €
    ${fyr_totalt}=  remove string  ${fyr_totalt}  €
    #${lineitem_totalt}=  replace string  ${lineitem_totalt}  ' '  ''
    #${lineitem_totalt}=  replace string  ${lineitem_totalt}  ,  .
    ${fyr_totalt}=  replace string  ${fyr_totalt}  ,  .
    ${fyr_totalt}=  convert to number  ${fyr_totalt}
    #Should be equal as strings  ${lineitem_totalt}  ${lineitem_total}
    page should contain element     //*[text()='Revenue Total' and @class='test-id__field-label']/../..//lightning-formatted-text[text()=normalize-space(.)="${lineitem_total}€"]
    Should be equal as strings  ${fyr_totalt}    ${fyr_total}
    log to console  2
    [Return]  ${lineitem_total}  ${fyr_total}



validateCreatedOppoForFYR
    [Arguments]   ${product_name}  ${fyr_value_oppo}= ${fyr_value}
    #wait until page contains element    //span[@title='Revenue Total']/../div[@class='slds-form-element__control']/Div/span[text()='${fyr_value_oppo},00 €']    60s
    wait until page contains element    //p[text()="Revenue Total"]/../..//lightning-formatted-text[text()=normalize-space(.)="${fyr_value_oppo},00 €"]  60s
    page should contain element    //p[text()="Revenue Total"]/../..//lightning-formatted-text[text()=normalize-space(.)="${fyr_value_oppo},00 €"]
    page should contain element    //p[text()="FYR Total"]/../..//lightning-formatted-text[text()=normalize-space(.)="${fyr_value_oppo},00 €"]
    ScrollUntillFound    //*[text()='Revenue Total' and @class='test-id__field-label']/../..
    sleep    5s
    page should contain element    //*[text()='Revenue Total' and @class='test-id__field-label']/../..//lightning-formatted-text[text()=normalize-space(.)="${fyr_value_oppo},00 €"]
    page should contain element    //*[text()='FYR Total' and @class='test-id__field-label']/../..//lightning-formatted-text[text()=normalize-space(.)="${fyr_value_oppo},00 €"]
    ${monthly_charge_total}=    evaluate    (${RC}*${product_quantity})
    #${mrc_form}=    get text    //span[@title='Revenue Total']/../div[@class='slds-form-element__control']/div/span
    #should be equal as strings    ${monthly_charge_total}    ${mrc_form}
    page should contain element    //*[text()='Monthly Recurring Total' and @class='test-id__field-label']/../..//lightning-formatted-text[text()=normalize-space(.)="${monthly_charge_total},00 €"]
    ${one_time_total}=    evaluate    (${NRC}*${product_quantity})
    #${nrc_form}=    get text    //span[@title='FYR Total']/../div[@class='slds-form-element__control']/div/span
    #should be equal as strings    ${one_time_total}    ${nrc_form}
    page should contain element    //*[text()='OneTime Total' and @class='test-id__field-label']/../..//lightning-formatted-text[text()=normalize-space(.)="${one_time_total},00 €"]
    ${status}=    Run Keyword And Return Status    wait until page contains element    //li//a[text()='Related']     60s
    run keyword if    ${status} == False    Reload Page
    run keyword if    ${status} == False    sleep  30s
    click element    //li//a[text()='Related']
    sleep    10s
    ScrollUntillFound    //a[text()='${product_name}']
    page should contain element    //a[text()='${product_name}']
    page should contain element    //lightning-formatted-text[contains(text(),'New Money-New Services')]
    page should contain element    //lightning-formatted-text[contains(text(),'New Money-New Services')]//following::lightning-formatted-number[text()="${product_quantity},00"]


Move the Opportunity to next stage
    [Arguments]    ${opportunity}    ${stage1}  ${stage2}
    ${current_stage}=    set variable    //div[contains(@class,'test-id__field')]/span[contains(text(),'Stage')]/../../div/span[contains(@class,'field-value')]
    Go to Entity    ${opportunity}
    ${stage}=    Get Text    ${current_stage}
    log to console   ${stage}
    log to console   Move tha opportunity from ${stage} to ${stage1}
    click visible element    ${EDIT_STAGE_BUTTON}
    Sleep  10s
    Select option from Dropdown    //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div    ${stage1}
    Sleep  10s
    Click element   //button[text()="Save"]
    sleep  5s
    ${stage}=    Get Text    ${current_stage}
    log to console   ${stage}
    log to console   Move tha opportunity from ${stage1} to ${stage2}
    click visible element    ${EDIT_STAGE_BUTTON}
    Select option from Dropdown    //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   ${stage2}
    Sleep  10s
    Click element   //button[text()="Save"]
    Sleep  10s

validateproductsbasedonsalestype
   [Arguments]     @{items}
    ${list_Prd}    Create List    @{items}
    @{list_with prod and sales}     create list
    ${count}    Get Length    ${list_Prd}
    Wait until element is visible   ${Oppo_Related_Tab}   10s
    Force click element     ${Oppo_Related_Tab}
    Wait until element is visible   ${Oppo_Product_panel}   10s
    Wait until element is visible   ${Product_viewall_button}   30s
    Click Button    ${Product_viewall_button}
    sleep  30s
    switch between windows  1
    sleep  30s
    :FOR    ${i}    IN RANGE    ${count}
    \    ${i} =    Set Variable    ${i + 1}
    \   ${sales_type}  get text   //table[@role="treegrid"]/tbody/tr[${i}]/th/following::td[2]//div
    \   ${sales_value}  get text  //table[@role="treegrid"]/tbody/tr[${i}]/th/following::td[8]//div
    \   Append To List  ${list_with prod and sales}    ${sales_type}    ${sales_value}
    ${add_new}  ${add_ren}  ${add_frame} =   addFYRbasedonSalesType  ${list_with prod and sales}
    switch between windows  0
    [Return]   ${add_new}  ${add_ren}  ${add_frame}


Validating FYR values in Opportunity Header
     [Arguments]    ${fyr_total}   ${new}   ${ren}   ${frame}
     sleep  90s
     page should contain element    //p[text()="FYR Total"]/../..//lightning-formatted-text[text()=normalize-space(.)=" ${fyr_total},00 €"]
     page should contain element    //p[text()="FYR New Sales"]/../..//lightning-formatted-text[text()=normalize-space(.)=" ${new},00 €"]
     page should contain element   //p[text()="FYR Continuation Sales"]/../..//lightning-formatted-text[text()=normalize-space(.)="${ren},00 €"]
     page should contain element    //p[text()="FYR Total Frame Agreement"]/../..//lightning-formatted-text[text()=normalize-space(.)="${frame},00 €"]


Validate the HDc Related fields are non editable after closing Opportunity
    [Documentation]  This is to validate the  closed opportunity HDC fields non editable
    ScrollUntillFound  ${Additional_Details}
    wait until page contains element  ${HDC Total}   60s
    page should contain element    ${HDC Total KW_investment}
    page should contain element   ${HDC Rack Amount_investment}
    Page should Not contain element     ${Edit HDC Rack Amount}
    page should Not contain element   ${Edit HDC Total KW}

Validate the HDc Related fields aeditable if the profile is admin after closing Opportunity
    [Documentation]  This is to validate the closed opportunity HDC fields are editable
    ScrollUntillFound  ${Additional_Details}
    wait until page contains element  ${HDC Total}   60s
    page should contain element    ${HDC Total KW_investment}
    page should contain element   ${HDC Rack Amount_investment}
    Page should contain element     ${Edit HDC Rack Amount}
    page should contain element   ${Edit HDC Total KW}