*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Variables.robot

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
    [Arguments]    ${continuation}
    ${current_stage}=    set variable    //div[contains(@class,'test-id__field')]/span[contains(text(),'Stage')]/../../div/span[contains(@class,'field-value')]
    ${edit_stage}=    set variable    //button[@title='Edit Stage']
    ${stage}=    Get Text    ${current_stage}
    Capture Page Screenshot
    click element    ${EDIT_STAGE_BUTTON}
    Sleep  30s
    Select option from Dropdown    //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div    Closed Won
    Execute Javascript    window.scrollTo(0,600)
    Select option from Dropdown if not able to edit the element from the list    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Create Continuation Sales Opportunity?')]/../../div/div/div/div/a    ${continuation}   Closed Won
    Select option from Dropdown   //span[contains(@class,'label inputLabel')]/span[contains(text(),'Create Continuation Sales Opportunity?')]/../../div/div/div/div/a    ${continuation}
    Wait Until Page Contains Element    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Close Reason')]/../../div/div/div/div/a    60s
    Execute Javascript    window.scrollTo(0,9000)
    #Get Text    //span[contains(text(),'Service Address Street')]/../../span
    Select option from Dropdown    //span[contains(@class,'label inputLabel')]/span[contains(text(),'Close Reason')]/../../div/div/div/div/a    08 Other
    input text    //span[text()='Close Comment']/../../textarea    this is a test opportunity to closed won
    #sleep  30s
    Wait Until Page Contains Element     //button[@title="Save"]   60s
    click element   //button[@title="Save"]

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
    #Wait Until Element Is Visible    ${stage_complete}    60s
    ${stage}=    Get Text    ${current_stage}
    Log To Console    The current stage is ${stage}
    Capture Page Screenshot
    click element    ${EDIT_STAGE_BUTTON}
    Sleep  30s
    Select option from Dropdown    //lightning-combobox//label[text()="Stage"]/..//div/*[@class="slds-combobox_container"]/div   ${stage1}
    Execute Javascript    window.scrollTo(0,7000)
    Wait Until Page Contains Element    //lightning-combobox//label[text()="Close Reason"]/..//div/*[@class="slds-combobox_container"]/div   60s
    #Get Text    //span[contains(text(),'Service Address Street')]/../../span
    Select option from Dropdown    //lightning-combobox//label[text()="Close Reason"]/..//div/*[@class="slds-combobox_container"]/div    08 Other
    Scroll Page To Location    0    3000
    Click element    //lightning-textarea//label[text()="Close Comment"]/../div/textarea
    Input Text    //lightning-textarea//label[text()="Close Comment"]/../div/textarea    this is a test opportunity to closed won
    #sleep  30s
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
