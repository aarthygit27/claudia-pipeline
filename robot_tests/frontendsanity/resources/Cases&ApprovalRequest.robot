*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Variables.robot
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Login.robot
*** Keywords ***

ApproveB2BGTMRequest
    [Arguments]  ${Approver_name}  ${oppo_name}
    swithchtouser  ${Approver_name}
    #Log to console  ${Approver_name} has to approve
    scrolluntillfound  //span[text()='Items to Approve']
    click element  //span[text()='Items to Approve']/ancestor::div[contains(@class,'card__header')]//following::a[text()='${oppo_name}']
    wait until page contains element   //span[text()='Opportunity Approval']  60s
    wait until element is visible  //div[text()='Approve']  60s
    click element  //div[text()='Approve']
    wait until page contains element  //h2[text()='Approve Opportunity']   30s
    wait until element is visible  //span[text()='Comments']/../following::textarea   30s
    #input text  //span[text()='Comments']/../following::textarea   1st level Approval Done By Leila
    input text  //span[text()='Comments']/../following::textarea   Approved
    click element  //span[text()='Approve']
    #Log to console      approved
    logoutAsUser  ${Approver_name}
    sleep  10s
    Login to Salesforce as System Admin


PM details
    [Documentation]  Login as PM. Search and select Case. Fill Pricing Manager Approval form and submit the case for approval.
    [Arguments]    ${oppo_name}   ${case_Number}  ${Account_Type}
    # Login and select the case
    Run Keyword If   '${Account_Type}'== 'B2O'    Login to Salesforce Lightning      ${B2O_PM_User}   ${B2O_PM_PW}
    Run Keyword Unless  '${Account_Type}' == 'B2O'   Login to Salesforce Lightning      ${PM_User}   ${PM_PW}
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}    ${case_Number}
    Press Enter On    ${SEARCH_SALESFORCE}
    Sleep    2s
    ${IsVisible}=    Run Keyword And Return Status    Element Should Be Visible    ${SEARCH_RESULTS}    60s
    run keyword unless    ${IsVisible}    Press Enter On    ${SEARCH_SALESFORCE}
    ${element_catenate} =    set variable    [@title='${case_Number}']
    Wait Until Page Contains element    ${TABLE_HEADER}${element_catenate}    120s
    Click Element    ${TABLE_HEADER}${element_catenate}
    #Verify it the opportunity details are visible
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number  and the status is ${Case_status}
    Wait until element is visible   //span/a[contains(text(),'Test Robot Order')]  30s
    ${oppo}  Run Keyword  Get Text  //span/a[contains(text(),'Test Robot Order')]
    Should be equal   ${oppo_name}   ${oppo}
    #Log to console  Linked Opportunity is ${oppo}
    ${More_actions}   set variable  //span[contains(text(),'more actions')]
    Wait until element is visible   ${More_actions}  30s
    set focus to element  ${More_actions}
    Force Click element  ${More_actions}
    Click element  //a[@title='Pricing Manager Approval']
    Sleep  5s
    Wait until element is visible  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe  30s
    select frame  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe
    Execute JavaScript    window.scrollTo(0,1000)
    Wait until element is visible   //textarea[@id='PricingComments']  30s
    Input Text  //textarea[@id='PricingComments']    ${Pricing Comments}
    Run Keyword If   '${Account_Type}'== 'B2O'     Submit Investment - B2O
    Run Keyword Unless  '${Account_Type}' == 'B2O'    Submit Investment - B2B
    sleep  3s
    Wait until element is visible   //p[text()='Save']  30s
    Click element  //p[text()='Save']
    Unselect frame
    Submit for approval  Investment Case


Submit for approval
    [Arguments]       ${case_type}
    sleep  10s
    #Required since wait is not working
    ${More_actions}   set variable  //span[contains(text(),'more actions')]
    Wait until element is visible   ${More_actions}  30s
    set focus to element  ${More_actions}
    Force Click element  ${More_actions}
    Click element  //a[@title='Submit for Approval']
    Wait until element is visible  //textarea[@class='inputTextArea cuf-messageTextArea textarea']   60s
    Input text  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  Submit
    Click element  //span[text()='Submit']
    Capture Page Screenshot
    sleep  5s
    Reload page
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number for ${case_type}  and the status is ${Case_status}
    logoutAsUser    ${PM_User}

Create Investment Case
    [Documentation]  Click Create investmnet button anf fill details and check the status of case created
    [Arguments]   ${Account_Type}
    ${More}   set variable   //a[@title='CPQ']//following::a[contains(@title,'more actions')]
    ${Create Investment}   set variable  //div[@class='branding-actions actionMenu']//following::a[@title='Create Investment']
    Wait until element is visible  ${More}  30S
    ${count}  Run Keyword and Return Status  Get Element Count   ${More}
    #Log to console    ${count}
    Force click element    ${More}
    Wait until element is visible    ${Create Investment}   30s
    Click element  ${Create Investment}
    sleep  10s    # for the page to load
    Reload page
    sleep  10s
    Fill Investment Info   ${Account_Type}
    Unselect frame
    Wait until element is visible   //p[@title='Case Number']//following::lightning-formatted-text[1]   30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text    //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number for Investment Request and the status is ${Case_status}
    logoutAsUser    ${B2B_DIGISALES_LIGHT_USER}
    [Return]    ${case_number}


Fill Investment Info
    [Documentation]    Fill Investment Case Creation form
    [Arguments]   ${Account_Type}
    ${Type}   set variable  //select[@id='Type']
    ${Type_Option}  set variable   //select[@id='Type']/option[@label='Mobile']
    ${Subject}  set variable   //input[@id='Subject']
    ${Summary}   set variable    //textarea[@id='Summary']
    ${Full_Investment}  set variable    //input[@id='FullInvestmentEur']
    ${Contract_length}  set variable   //input[@id='ContractLength']
    ${Payment_Method}   set variable  //select[@id='PaymentMethod']
    ${Payment_Option}  set variable   //select[@id='PaymentMethod']/option[@label='Monthly payment']
    ${Payment_Option_2}   set variable   //select[@id='PaymentMethod']/option[@label='One time']
    ${Customer_Pays}  set variable  //input[@id='CustomerPaysMonthlyEur']
    ${Decision}   set variable  //textarea[@id='DecisionArgument']
    ${Mobile_Coverage}  set variable  //input[@id='MobileCoverageNo']
    ${Attachment}  set variable   //input[@type='file']
    #${File_Path}   set variable    C:\\Users\\Ram\\work\\aarthy\\claudia-pipeline_rt\\robot_tests\\resources\\Input.txt
    ${File_Path}   set variable    ${CURDIR}${/}Input.txt
    ${Button}  set variable   //div[@id='InvestmentInfo_nextBtn']
    ${Telia_Pays}  set variable  //input[@id='TeliaPaysOne']
    ${Full_Inv_Value}  set variable  2000
    ${contract_Len_Value}  set variable  ${${Account_Type}_Contract_Length}
    ${Cust_pay_val}  set variable  10
    ${Cust_pay_total}  Run keyword   evaluate  (${contract_Len_Value}*${Cust_pay_val})
    ${Telia_pay_expected_val}   Run keyword    evaluate   (${Full_Inv_Value}-${Cust_pay_total})
    #Log to console   ${Telia_pay_expected_val}
    sleep  10s
    Wait until element is visible  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe  30s
    select frame  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe
    ${count}  Run Keyword and Return Status  Get Element Count   ${Type}
    #Log to console    ${count}
    Force click element    ${Type}
    Click element  ${Type_Option}
    Input Text  ${Subject}  Test Subject
    Input Text  ${Summary}   Test Summary
    Input Text  ${Full_Investment}   ${Full_Inv_Value}
    Input Text  ${Contract_length}  ${contract_Len_Value}
    Click element   ${Payment_Method}
    Page should contain Element  ${Payment_Option}
    Page should contain Element  ${Payment_Option_2}
    #Log to console  Both Payment Options available
    Click element    ${Payment_Option}
    Input TExt  ${Customer_Pays}  ${Cust_pay_val}
    ${Value}  Get Value  //input[contains(@id,'TeliaPays')]
    ${str_Telia_pay_val}    Run Keyword  Convert to string   ${Telia_pay_expected_val}
    Should be equal    ${Value}   ${str_Telia_pay_val}
    #Log to console  Teli Pay value populated correctly
    Input Text  ${Decision}   Invest
    ${status}   Run Keyword and Return Status  Page should contain element  ${Mobile_Coverage}
    #Log to console   ${status}
    Run Keyword If   ${status}   Input Text  ${Mobile_Coverage}   25
    Choose File   ${Attachment}   ${File_Path}
    Wait until element is visible  ${Button}  30s
    Click element  ${Button}
    Wait until element is visible  //button[@id='alert-ok-button']  30s
    Click element  //button[@id='alert-ok-button']
    Page should contain element   //small[text()='Maximum contract length is ${${Account_Type}_Max_contract_len} months.']
    #Log to console   Contract length maximum validation is successful
    Clear Element text  ${Contract_length}
    Input Text  ${Contract_length}  100
    Wait until element is visible  ${Button}  30s
    Force Click element  ${Button}

Submit Investment - B2O
    [Documentation]  Fill the specifc fields for B2O to submit the investment
    Input Text   //input[@id='FirstYear']  100
    Click element  //select[@id='ApprovalActionB2O']
    Wait until element is visible  //select[@id='ApprovalActionB2O']/option[@label='Send for Approval']  30s
    Click element  //select[@id='ApprovalActionB2O']/option[@label='Send for Approval']
    Wait until element is visible  //input[@id='ApproverB2O']  30s
    Click element  //input[@id='ApproverB2O']
    Wait until element is visible  //li[contains(text(),'B2OApprover Automation')]  30s
    Click element  //li[contains(text(),'B2OApprover Automation')]
    Wait until element is visible  //input[@id='NotifyB2O']  30s
    Click element  //input[@id='NotifyB2O']
    Wait until element is visible  //li[contains(text(),'B2ONotify Automation')]  30s
    Force Click element  //li[contains(text(),'B2ONotify Automation')]
    sleep  3s

Submit Investment - B2B
    [Documentation]   Fill the specifc fields for B2B to submit the investment
    Input Text  //input[@id='Ebit']   ${Ebit Value}
    Click element  //select[@id='ApprovalActionB2B']
    Click element  //select[@id='ApprovalActionB2B']//option[@label='Prepare for Endorsement']
    Wait until element is visible  //input[@id='EndorserB2B']  30s
    Click element  //input[@id='EndorserB2B']
    Wait until element is visible  //li[contains(text(),'Endorser')]  30s
    Click element  //li[contains(text(),'Endorser')]
    Wait until element is visible  //input[@id='ApproverB2B']  30s
    Click element  //input[@id='ApproverB2B']
    Wait until element is visible  //li[contains(text(),'Approver')]  30s
    Click element  //li[contains(text(),'Approver')]
    Wait until element is visible  //input[@id='NotifyB2B']  30s
    Click element  //input[@id='NotifyB2B']
    Wait until element is visible  //li[contains(text(),'notifier')]  30s
    Force Click element  //li[contains(text(),'notifier')]


Case Approval By Endorser
    [Arguments]   ${Case_number}   ${oppo_name}
    Login to Salesforce Lightning  ${Endorser_User}  ${Endorser_PW}
    #Log to console  Logged in as Endorser
    Check for Notification  ${Case_number}  ${EMPTY}
    Select Options to Verify Chatter Box   ${Case_number}
    Page should contain element   //div[@class='slds-media__body forceChatterFeedItemHeader'][1]/div/p/span/a/span[text()='${Case_number}']
    Page should contain   requested approval for this case from
    Capture Page Screenshot
    #Log to console    There is an alert in the Chatter about new case
    Wait until element is visible  //span[text()='Items to Approve']  30s
    #Click element  //a[text()='00031101']
    Wait until element is visible  //a[text()='${Case_number}']  30s
    Click element  //a[text()='${Case_number}']
    sleep  10s
    Click element  //a[text()='${Case_number}']
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number and the status is ${Case_status}
    Wait until element is visible   //a[contains(text(),'Test Robot Order')]  30s
    ${oppo}  Run Keyword  Get Text  //a[contains(text(),'Test Robot Order')]
    Should be equal   ${oppo_name}   ${oppo}
    #Log to console  Linked Opportunity is ${oppo}
    Go back
    Sleep  10s
    Wait until element is visible  //div[@title='Approve']  30s
    Capture Page Screenshot
    Click element  //div[@title='Approve']
    Wait until element is visible  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  60s
    Input text  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  Approved by Endorser
    Click element  //span[text()='Approve']
    Capture Page Screenshot
    sleep  5s
    logoutAsUser    ${Endorser_User}


Check for Notification
    [Arguments]   ${Case_number}   ${status}=${EMPTY}
    Wait until element is visible  //div[@class='headerButtonBody']  60s
    Click element  //div[@class='headerButtonBody']
    Click element  //div[@class='headerButtonBody']
    Wait until element is visible  //div[@class='notification-content']/div/span[contains(text(),${Case_number})]   30s
    ${Notification}   Run keyword   Get text  //div[@class='notification-content']/span[contains(text(),${Case_number})]/../span
    ${Notification_2}  Run keyword   Get text  //div[@class='notification-content']/span[contains(text(),${Case_number})]
    Run Keyword If  '${status}' == 'Rejected'  Should end with     ${Notification}    is rejected
    Run Keyword If  '${status}' == '${EMPTY}'   Should end with     ${Notification}    is requesting approval for case
    Run Keyword If  '${status}' == 'Approved'   Should end with     ${Notification}    is approved
    Capture Page Screenshot
    #Log to console   ${Notification}
    #Log to console    ${Notification_2}
    Capture Page Screenshot
    sleep  2s
    Force Click element  //button[@title='Close']


Select Options to Verify Chatter Box
    [Arguments]   ${Case_number}
    ${sort}  set variable   //input[@name='sort']
    ${sort_option}  set variable   //span[@title='Latest Posts']
    ${Filter}   set variable  //span[text()='Filter Feed']
    ${Filter_option}  set variable  //span[text()='Filter Feed']//following::div[1]/div/slot/lightning-menu-item[1]/a/span
    WAit until element is visible    ${sort}  30s
    Click element    ${sort}
    Click element    ${sort_option}
    Page should contain element  ${Filter}
    Force Click element   ${Filter}
    Page should contain element  ${Filter_option}
    Force Click element  ${Filter_option}
    sleep  5s

Case Approval By Approver
     [Arguments]   ${Case_number}  ${oppo_name}  ${Account_Type}=${EMPTY}
    Run Keyword If   '${Account_Type}'== 'B2O'    Login to Salesforce Lightning   ${B2O_Approver_User}   ${B2O_Approver_PW}
    Run Keyword Unless  '${Account_Type}' == 'B2O'   Login to Salesforce Lightning   ${Approver_User}  ${Approver_PW}
    #Log to console  Logged in as Approver
    Check for Notification  ${Case_number}
    Select Options to Verify Chatter Box   ${Case_number}
    Page should contain element   //div[@class='slds-media__body forceChatterFeedItemHeader'][1]/div/p/span/a/span[text()='${Case_number}']
    Page should contain   requested approval for this case from
    Capture Page Screenshot
    #Log to console    There is an alert in the Chatter about new case
    Wait until element is visible  //span[text()='Items to Approve']  30s
    #Click element  //a[text()='00031101']
    Wait until element is visible  //a[text()='${Case_number}']  30s
    Click element  //a[text()='${Case_number}']
    sleep  10s
    Click element  //a[text()='${Case_number}']
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number  and the status is ${Case_status}
    Wait until element is visible   //a[contains(text(),'Test Robot Order')]  30s
    ${oppo}  Run Keyword  Get Text  //a[contains(text(),'Test Robot Order')]
    Should be equal   ${oppo_name}   ${oppo}
    #Log to console  Opportunity Validation is Sucessful
    sleep  5s
    #Log to console  Linked Opportunity is ${oppo}
    Go back
    Sleep  10s
    Page should contain element  //div[@class='approval-comments']/ul/li/article/div[2]/div/span
    Run Keyword if   '${Account_Type}'== 'B2B'   Endorser Verification
    Run Keyword Unless  '${Account_Type}' == '${EMPTY}'   Verify Pricing comments
    Capture Page Screenshot
    Wait until element is visible  //div[@title='Approve']  30s
    Capture Page Screenshot
    Click element  //div[@title='Approve']
    Wait until element is visible  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  30s
    Input text  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  Approved by Approver
    Click element  //span[text()='Approve']
    Capture Page Screenshot
    sleep  5s
    logoutAsUser    ${Approver_User}

Endorser Verification
    ${Endorser_Comments}   Get text   //div[@class='approval-comments']/ul/li/article/div[2]/div/span
    #Log to console  Endorser comment is visible and the comment given is ${Endorser_Comments}

Verify Pricing comments
    Page should contain element  //span[text()='Approval Details']//following::span[6][text()='Pricing Comments']//following::span[2]
    ${Pricing Comments}  Get text  //span[text()='Approval Details']//following::span[6][text()='Pricing Comments']//following::span[2]
    #Log to console  Pricing comments is visible and the comment is ${Pricing Comments}


Check Case Status
    [Arguments]   ${Case_number}  ${Account_Type}
    Run Keyword If   '${Account_Type}'== 'B2O'   Login to Salesforce as B2O User
    Run Keyword If   '${Account_Type}'== 'B2B'   Login to Salesforce as B2B DigiSales
    Select Options to Verify Chatter Box    ${Case_number}
    Page should contain element   //div[@class='slds-media__body forceChatterFeedItemHeader'][1]/div/p/span/a/following::span[contains(text(),'${Case_number}')]
    #Page should contain   created an attachment
    Capture Page Screenshot
    #Log to console    There is an alert in the Chatter about new case pdf generation
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}    ${case_Number}
    Press Enter On    ${SEARCH_SALESFORCE}
    Sleep    2s
    ${IsVisible}=    Run Keyword And Return Status    Element Should Be Visible    ${SEARCH_RESULTS}    60s
    run keyword unless    ${IsVisible}    Press Enter On    ${SEARCH_SALESFORCE}
    ${element_catenate} =    set variable    [@title='${case_Number}']
    Wait Until Page Contains element    ${TABLE_HEADER}${element_catenate}    120s
    Click Element    ${TABLE_HEADER}${element_catenate}
    #Verify it the opportunity details are visible
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number and the status is ${Case_status}


Create Pricing Request
    ${More}   set variable   //a[@title='CPQ']//following::a[contains(@title,'more actions')]
    ${Create Pricing List}   set variable  //div[@class='branding-actions actionMenu']//following::a[@title='Create Pricing Request']
    Wait until element is visible  ${More}  30S
    cLICK ELEMENT   ${More}
    Wait until element is visible    ${Create Pricing List}   30s
    Click element  ${Create Pricing List}
    sleep  5s    # for the page to load
    Wait until element is visible  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe  30s
    select frame  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe
    #Wait until element is visible  //section[@class='slds-page-header vlc-slds-page--header ng-scope']//following::h1[contains(text(),'Pricing Request')]  60s
    Wait until element is visible   //input[@id='Subject']  30s
    Input Text   //input[@id='Subject']  Test Pricing Request
    Click element   //label[@class='slds-checkbox']/span[1]
    Input Text  //input[@id='OtherReason']  Test
    execute javascript    window.scrollTo(0,200)
    Click Element  //input[@id='PricingNeededBy']
    Wait until element is visible  //button[@title='Next Month']  30s
    Click element  //button[@title='Next Month']
    Click element  //table[@class='slds-datepicker__month nds-datepicker__month']/tbody/tr[1]/td[1]/span[1]
    Wait until element is visible   //p[text()='Create Pricing Request']  30s
    Click element  //p[text()='Create Pricing Request']
    Unselect Frame
    Wait until element is visible   //p[@title='Case Number']//following::lightning-formatted-text[1]   30s
    ${Case_number}     get text   //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text    //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number for Pricing Request and the status is ${Case_status}
    Capture Page Screenshot


Create Pricing Escalation
    ${More_actions}   set variable  //a[@title='CPQ']//following::a[contains(@title,'more actions')]
    ${CPE}    set variable   //a[@title='Create Pricing Escalation']
    Reload Page
    Wait until element is visible   ${More_actions}  30s
    set focus to element  ${More_actions}
    Force Click element  ${More_actions}
    Wait until element is visible  ${CPE}   30s
    Click element  ${CPE}
    sleep  5s
    Wait until element is visible  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe
    Select frame  //div[@class='iframe-parent slds-template_iframe slds-card']/iframe
    Wait until element is visible  //input[@id='Subject']  20s
    Input Text   //input[@id='Subject']  Test Subject
    Click element  //input[@id='Type'][@type='checkbox']//following::span[text()='Mobile']
    Click element  //input[@id='ReasonCategories'][@type='checkbox']//following::span[text()='Revenue']
    Input text  //textarea[@id='Comments']  Test Comments
    Click element  //input[@id='EndorserLookup']
    Wait until element is visible  //li[contains(text(),'Endorser Automation')]  30s
    Click element  //li[contains(text(),'Endorser Automation')]
    Click element  //input[@id='ApproverLookup']
    Wait until element is visible  //li[contains(text(),'Approver Automation')]  30s
    Click element  //li[contains(text(),'Approver Automation')]
    Click element     //input[@id='NotifyLookup']
    Wait until element is visible  //li[contains(text(),'notifier Automation')]  30s
    Click element  //li[contains(text(),'notifier Automation')]
    execute javascript    window.scrollTo(0,300)
    Wait until element is visible  //p[text()='Create Pricing Escalation']  30s
    Click element  //p[text()='Create Pricing Escalation']
    Unselect frame
    Sleep  5s
    execute javascript    window.scrollTo(0,200)
    Capture Page Screenshot
    Reload Page
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number and the status is ${Case_status}
    [Return]  ${Case_number}


Verify case Status by PM
    [Arguments]   ${Case_number}
    Login to Salesforce Lightning   ${PM_User}  ${PM_PW}
    #Log to console  Logged in as Pm to verify the Case Status
    #Reload page
    Search Salesforce    ${Case_number}
    ${element_catenate} =    set variable    [@title='${Case_number}']
    Wait Until Page Contains element    ${TABLE_HEADER}${element_catenate}    120s
    #Sleep    15s
    Click Element    ${TABLE_HEADER}${element_catenate}
    sleep  10s
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number and the status is ${Case_status}
    logoutAsUser    ${PM_User}


Verify case Status by Endorser
    [Arguments]   ${Case_number}  ${status}=${EMPTY}
    Login to Salesforce Lightning   ${Endorser_User}  ${Endorser_PW}
    #Log to console  Logged in as Endorser to verify the Case Status
    Check for Notification  ${Case_number}   ${status}
    #Reload page
    Search Salesforce    ${Case_number}
    ${element_catenate} =    set variable    [@title='${Case_number}']
    Wait Until Page Contains element    ${TABLE_HEADER}${element_catenate}    120s
    #Sleep    15s
    Click Element    ${TABLE_HEADER}${element_catenate}
    sleep  10s
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number and the status is ${Case_status}
    logoutAsUser    ${Endorser_User}


Case Not visible to Normal User
    [Arguments]   ${Case_number}
    Login to Salesforce Lightning       ${B2B_DIGISALES_LIGHT_USER}   ${Password_merge}
    Wait Until Page Contains element    xpath=${SEARCH_SALESFORCE}    60s
    Input Text    xpath=${SEARCH_SALESFORCE}    ${Case_number}
    Press Enter On    ${SEARCH_SALESFORCE}
    sleep  10s
    Page should not contain  //span[@class='slds-form-element__label slds-truncate'][@title='Case Number']//following::div[1]/div/span[text()='${Case_number}']
    #Log to console  Case Not visible to Normal User
    Capture Page Screenshot


Case Rejection By Approver
     [Arguments]   ${Case_number}  ${oppo_name}
    Login to Salesforce Lightning   ${Approver_User}  ${Approver_PW}
    #Log to console  Logged in as Approver
    Check for Notification  ${Case_number}
    Wait until element is visible  //span[text()='Items to Approve']  30s
    #Click element  //a[text()='00031101']
    Wait until element is visible  //a[text()='${Case_number}']  30s
    Click element  //a[text()='${Case_number}']
    sleep  10s
    Click element  //a[text()='${Case_number}']
    Wait until element is visible  //p[@title='Case Number']//following::lightning-formatted-text[1]  30s
    ${Case_number}     get text  //p[@title='Case Number']//following::lightning-formatted-text[1]
    ${Case_status}      get text   //p[@title='Status']//following::lightning-formatted-text[1]
    #Log to console   ${Case_number} is the Case number and the status is ${Case_status}
    Wait until element is visible   //a[contains(text(),'Test Robot Order')]  30s
    ${oppo}  Run Keyword  Get Text  //a[contains(text(),'Test Robot Order')]
    Should be equal   ${oppo_name}   ${oppo}
    #Log to console  Opportunity Validation is Sucessful
    sleep  5s
    #Log to console  Linked Opportunity is ${oppo}
    Go back
    Wait until element is visible  //div[@title='Reject']  30s
    Capture Page Screenshot
    Click element  //div[@title='Reject']
    Wait until element is visible  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  30s
    Input text  //textarea[@class='inputTextArea cuf-messageTextArea textarea']  Rejected
    Click element  //span[text()='Reject']
    Capture Page Screenshot
    sleep  5s
    logoutAsUser    ${Approver_User}