*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Variables.robot
Resource          ../../frontendsanity/resources/Common.robot

*** Keywords ***
Check service contract is on Draft Status
    [Documentation]    On account page check service contracts and verify that created one is on draft status
    Wait element to load and click    ${ACCOUNT_RELATED}
    Wait element to load and click    //h2/a/span[text()='Contracts']
    Wait until page contains element    //table/tbody/tr[2]/td[2]/span/span[@title="Service Contract"]    30s
    Wait until page contains element    //table/tbody/tr[2]/td[4]/span/a[text()='Telia Verkkotunnuspalvelu']    30s
    Wait until page contains element    //table/tbody/tr[2]/td[5]/span/span[text()='Draft']    30s


Create contract Agreement
    [Documentation]  Create contract(service/Customership) based on the contract type
    [Arguments]   ${Contract_Type}   ${Linked Customer Contract}=${EMPTY}
    ${Create Agreement}  set variable  //div[@title='Create Agreement']
    ${Frame}  set variable  //div[contains(@class,'slds')]/iframe
    ${Agreement_Type}  set variable  //select[@id='AgreementType']
    ${option}  set variable  //select[@id='AgreementType']/option[@label='${Contract_Type} Agreement']
    ${Next_Button}  set variable  //p[text()='Next']
    ${Create_Agreement_Button}  set variable    //p[text()='Create Agreement']
    ${contact_name}   run keyword    Create New Contact for Account
    sleep  40s
    #Wait Until Page Contains element  //ul/li//a[@title="Show 2 more actions"]  60s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible      //li//a[@title="Create Agreement"]   60s
    #Run Keyword If    ${status_page} == True    force click element    //li/a/div[@title='Billing Account']
    Run Keyword If    ${status_page} == False   force click element     //a[@title="Show 2 more actions"]
    sleep  20s
    click element     //li//a[@title="Create Agreement"]
    sleep   10s   # Required for loading
    Reload page
    sleep  30s
    Wait until element is visible  ${Frame}  30s
    Select frame  ${Frame}
    ${count}  Run Keyword and Return Status  Get Element Count   ${Agreement_Type}
    #Log to console    ${count}
    Force click element   ${Agreement_Type}
    Wait until element is visible  ${option}  30s
    Click element   ${option}
    Click element    ${Next_Button}
    Run keyword if   '${Contract_Type}' == 'Service'    Select Offerings
    Wait until element is visible  ${Create_Agreement_Button}   30s
    Click element  ${Create_Agreement_Button}
    unselect frame
    sleep  10s
    Fill Contract Details  ${Contract_Type}  ${contact_name}  ${Linked Customer Contract}
    Activate Contract  ${Contract_Type}


Fill Contract Details
    [Documentation]  To fill form while creating SErvice and customership contract
    [Arguments]  ${Contract_Type}  ${contact_name}   ${Linked Customer Contract}=${EMPTY}
    ${Edit Contractual Contact Person}   set variable   //button[@title='Edit Contractual Contact Person']
    ${Search Contracts}    set variable  //span[text()='Contractual Contact Person']//following::div[1]/div/div/div/input[@title='Search Contacts']
    ${contact}  set variable  //div[@title='${contact_name}']
    ${Customer Signed By}  set variable   //span[text()='Customer Signed By']//following::div[1]/div/div/div/input[@title='Search Contacts']
    ${Customer Signed Date}   set variable   //label[@class='label inputLabel uiLabel-left form-element__label uiLabel']/span[text()='Customer Signed Date']//following::input[1]
    ${Customer Signature Place}  set variable   //label[@class='label inputLabel uiLabel-left form-element__label uiLabel']/span[text()='Customer Signature Place']//following::textarea[1]
    ${Telia Signed By}  set variable   //label[@class='label inputLabel uiLabel-left form-element__label uiLabel']/span[text()='Telia Signed By']//following::input[1]
    ${Telia Signed Date}   set variable  //label[@class='label inputLabel uiLabel-left form-element__label uiLabel']/span[text()='Telia Signed Date']//following::input[1]
    ${Attachment_Button}  set variable   //a[@title='Add Attachment']
    ${File_Path}   set variable    ${CURDIR}${/}input.txt
    #${filepath}     set variable   ${CURDIR}\\Input.txt
    ${save}  set variable  //button[@title='Save']
    ${ATTACHMENT_NAME}  set variable  //input[@id='name']
    ${File}  set variable   //input[@type='file']
    ${Type}  set variable   //select[@id='type']
    ${Type_Option}  set variable   //select[@id='type']/option[@value='Customership Agreement']
    ${Document}  set variable   //select[@id='Document_Stage']
    ${Document_option}  set variable   //select[@id='Document_Stage']/option[@value='Approved']
    ${Frame}  set variable  //div[contains(@class,'slds')]/iframe
    Run keyword if   '${Contract_Type}' == 'Service'      Verify if Customer Contract is linked  ${Linked Customer Contract}
    #Run keyword if   '${Contract_Type}' == 'Service'
    Wait Until Page Contains element        //div[text()="Contract"]        60s
    ${Telia party}  get text  //span[text()="Telia Party"]/../../div[@class="slds-form-element__control slds-grid itemBody"]//span[@class="test-id__field-value slds-form-element__static slds-grow "]
    #${itrm}     get length   ${Telia party}
    #${status}   Run keyword and return status   should not be empty   ${itrm}
    #Run Keyword Unless   ${status}  click element  //button[@title="Edit Telia Party"]
    #Run Keyword Unless   ${status}  Wait until element is visible   //div//span[text()="Telia Party"]/../..//input[@title="Search Accounts"]     60s
    #Run Keyword Unless   ${status}     Select from search List  //div//span[text()="Telia Party"]/../..//input[@title="Search Accounts"]        Telia Communication Oy
    #Run Keyword Unless   ${status}     click element  ${save}
    #Run Keyword Unless   ${status}     sleep   20s
    #ScrollUntillFound     //span[text()="Telia Party"]/../..//input[@title="Search Accounts"]
    ScrollUntillFound   //button[@title='Edit Customer Signed By']
    Wait until element is visible  //button[@title='Edit Customer Signed By']  30s
    Force Click element  //button[@title='Edit Customer Signed By']
    Wait until element is visible   ${Customer Signed By}  30s
    Press Key   ${Customer Signed By}   ${contact_name}
    sleep  3s
    ${Count}  run keyword and return status   Page should contain element ${contact}
    Run Keyword Unless   ${Count}   clear element text   ${Customer Signed By}
    Run keyword Unless   ${Count}   Press Key   ${Customer Signed By}    ${contact_name}
    #sleep  5s
    Page should contain element  ${contact}
    Force Click element  ${contact}
    ${status}   Run keyword and return status  Page should contain element  //li[text()='An invalid option has been chosen.']
    Run Keyword If  ${status}  Force Click element   //span[text()='Undo Customer Signed By']
    Run Keyword If  ${status}   Force Click element  ${contact}
    Capture Page Screenshot
    #sleep  5s
    scrolluntillfound       ${Customer Signed Date}
    Wait until element is visible  ${Customer Signed Date}  30s
    Force Click element   ${Customer Signed Date}
    Wait until element is visible   //a[@title='Go to next month']   30s
    Click element   //a[@title='Go to next month']
    Click element   //table[@class='calGrid']/tbody/tr[1]/td[1]/span[1]
    Input Text   ${Customer Signature Place}  Helsinsiki
    Execute JavaScript    window.scrollTo(0,1700)
    ScrollUntillFound       ${Telia Signed By}
    input text    ${Telia Signed By}   Automation Admin
    Wait until element is visible    //div[@title='Automation Admin']    30s
    Click element  //div[@title='Automation Admin']
    ScrollUntillFound       ${Telia Signed Date}
    Force Click element   ${Telia Signed Date}
    Click element   //a[@title='Go to next month']
    Click element   //table[@class='calGrid']/tbody/tr[1]/td[1]/span[1]
    #Wait until element is visible    ${Edit Contractual Contact Person}  60s
    #Click element    ${Edit Contractual Contact Person}
    Wait until element is visible    ${Search Contracts}  30s
    Click element  ${Search Contracts}
    Input Text  ${Search Contracts}  ${contact_name}
    sleep   4s
    ${status}  run keyword and return status   Element should be visible  ${contact}
    Run Keyword Unless   ${status}   clear element text   ${Search Contracts}
    Run keyword Unless   ${status}   Press Key   ${Search Contracts}   ${contact_name}
    Wait until element is visible    ${contact}  30s
    Force Click element  ${contact}
    Execute JavaScript    window.scrollTo(0,1700)
    sleep  8s
    ${status}   Run keyword and return status  Page should contain element  ${save}
    Run keyword unless    ${status}   Reload page
    Run keyword unless    ${status}   sleep  10s
    Run keyword unless    ${status}   Fill Contract Details   ${Contract_Type}  ${Linked Customer Contract}
    ${status}   Run keyword and return status  Element should be visible  ${save}
    Run keyword unless    ${status}   Reload page
    Run keyword unless    ${status}   sleep  10s
    Run keyword unless    ${status}   Fill Contract Details   ${Contract_Type}  ${Linked Customer Contract}
    click element  ${save}
    sleep  10s
    ${status}  Run keyword and return status  Element should not be visible  ${save}
    Reload page
    sleep  10s
    Run keyword Unless    ${status}   Fill Contract Details   ${Contract_Type}  ${Linked Customer Contract}
    ${page}  get location
    #Attachment
    Wait until element is visible  ${Attachment_Button}  60s
    Click Link  ${Attachment_Button}
    sleep  30s
    Reload page
    sleep  30s
    #Click element   ${Attachment_Button}
    Wait until element is visible  ${Frame}  30s
    Select frame  ${Frame}
    sleep  15s
    #Wait until element is visible  ${File}  60s  - Not working
    log to console  file path started
    ${status}  Run keyword and return status  Element should be visible  ${File}
    Choose File   ${File}   ${File_Path}
    Wait until element is visible  //textarea[@id='description']  30s
    Force Click element  //textarea[@id='description']
    Input text  //textarea[@id='description']  Test Description
    Click element  ${Type}
    Click element  ${Type_Option}
    Click element  ${Document}
    Click element  ${Document_option}
    sleep  10s
    wait until page contains element  //label[@class="slds-checkbox"]//input[@id="sync_to_ecm"]  60s
    select checkbox  //label[@class="slds-checkbox"]//input[@id="sync_to_ecm"]
    sleep  2s
    Click element  //p[text()='Load Attachment']
    Wait until element is visible  //p[contains(text(),'Attachment has been loaded successfully.')]  60s
    Unselect Frame
    sleep  2s
    go to   ${page}
    sleep  30s
    log to console  file contracts details ended

Activate Contract
    [Documentation]  Activate the created contract and check the status of the contract
    [Arguments]   ${Contract_Type}
    Execute JavaScript    window.scrollTo(0,200)
    sleep  5s
    Page should contain element  //span[text()='Agreement Data Complete']
    Reload page
    Wait until element is visible  //img[@alt='Ready']  60s
    Wait until element is visible  //div[@title='Activate']  30s
    Click element  //div[@title='Activate']
    Wait until element is visible  //button[@title='Yes']
    Click element  //button[@title='Yes']
    sleep  3s
    Wait until element is visible   //span[@class='slds-form-element__label slds-truncate'][@title='Contract Number']//following::div[9]/span[text()='Activated']   60s
    #Log to console   ${Contract_Type} Contract is activated
    ${Contract Agreement}  Run keyword   Get text  //span[@class='slds-form-element__label slds-truncate'][@title='Contract Number']//following::div[2]/span
    ${Contract Agreement_No}   Convert to integer   ${Contract Agreement}
    ${Contract}=   Evaluate   ${Contract Agreement_No}+ 1
    ${Contract Number}    Convert to String    ${Contract}
    set test variable  ${Customer_contract}     ${Contract Number}
    #Log to console  The ${Contract_Type} Contract Number is ${Customer_contract}
    click element  //a[@title="Related"]
    wait until page contains element  //a//span[@title="Attached Documents"]  60s
    sleep  20s
    scrolluntillfound  //div//span[text()="View All"]
    click element  //div//span[text()="View All"]
    wait until page contains element  //div//h1[@title="Attached Documents"]  60s
    wait until page contains element  //table[@role="grid"]//td[10]//span/span   60s
    ${ecm-id}  get text  //table[@role="grid"]//td[10]//span/span
    #${ecm-id}   convert to number   ${Contract Agreement}
    page should contain element  //table[@role="grid"]//td[10]//span/span[@title="${ecm-id}"]


Delete all existing contracts from Accounts Related tab
    wait until element is visible    ${ACCOUNT_RELATED}    60s
    Force click element    ${ACCOUNT_RELATED}
    #${status}=    run keyword and return status    Element Should Be Visible    //span[@title='Contracts']
    #run keyword if    ${status}    Run Keyword With Delay    0.10s    Click Element    xpath=${ACCOUNT_RELATED}
    #Sleep    15s
    ScrollUntillFound  //span[text()='View All']/span[text()='Opportunities']
    #Log to console   found element
    sleep  5s
    ${Status}   Run keyword and return status   Page should contain element  //span[text()='View All']/span[text()='Contracts']
    #Log to console  ${Status}
    Return From Keyword if  '${Status}' == 'False'
    Capture Page Screenshot
    ScrollUntillFound   //span[text()='View All']/span[text()='Contracts']
    ${display}=    run keyword and return status    Element Should Be Visible    //span[text()='View All']/span[text()='Contracts']
    run keyword if    ${display}    Force Click element    //span[text()='View All']/span[text()='Contracts']
    Sleep    10s
    Wait Until Element Is Visible    ${table_row}    60s
    Select rows to delete the contract


Select rows to delete the contract
    [Documentation]    Used to delete all the existing contracts for the business account

    ${count}=    get element count    ${table_row}
    #log to console    ${count}
    : FOR    ${i}    IN RANGE    9999
    \    Exit For Loop If    ${i} > ${count}-1
    \    Delete all Contracts    ${table_row}
    ${count}=    get element count    ${table_row}
    Run Keyword Unless   '${count}'=='0'  Select rows to delete the contract

