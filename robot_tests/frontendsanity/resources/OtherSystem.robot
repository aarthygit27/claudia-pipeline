*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Variables.robot
Resource          ../../frontendsanity/resources/Common.robot
*** Keywords ***
DDM Request Handling
    Login Workbench
    File Handling - Change Order id
    File Handling - Get Debug Line
    Execute Debug code
    Verify Response code
    Close opened windows


Login Workbench
    ${Env}  set variable   //label[text()='Environment:']//following::select[1]
    ${Environment_Option}  set variable  //label[text()='Environment:']//following::select[1]/option[text()='Sandbox']
    ${T&C}  set variable  //input[@type='checkbox'][@id='termsAccepted']
    ${login}  set variable  //input[@type='submit']
    Wait Until Keyword Succeeds    60s    1 second    Execute Javascript    window.open('https://workbench.developerforce.com');
    #Open Browser    https://workbench.developerforce.com    ${BROWSER}
    sleep    30s
    Switch between windows  1
    Wait until page contains element  //label[text()='Environment:']   60s
    Wait Until Element Is Visible    ${ENV}    30s
    Click element   ${Env}
    Click element  ${Environment_Option}
    Force Click element    ${T&C}
    Click element   ${login}
    sleep  5s
    ${title}    Get Title
    Run keyword if   '${title}'=='Login | Salesforce'   Login Salesforce to access Workbench   ${SYSTEM_ADMIN_USER}   ${SYSTEM_ADMIN_PWD}
    sleep  10s
    ${status}    Run keyword and return status   Page should contain element   //input[@title='Allow']
    Run Keyword If   ${status}   Click element   //input[@title='Allow']
    Run Keyword If   ${status}   sleep  5s
    ${status}    Run keyword and return status   Page should contain element    //span[text()='utilities']
    Run Keyword If    ${status} == False    Login Workbench

File Handling - Change Order id
    #${File_Path}   set variable    ${CURDIR}\\..\\resources\\DDM_Request.txt
    ${File_Path}   set variable    ${CURDIR}${/}DDM_Request.txt
    ${DDM_request}   get file    ${File_Path}
    ${No.of lines}    get line count    ${DDM_request}
    #Log to console   ${No.of lines}
    ${Line}   Get Line   ${DDM_request}  0
    #Log to console  ${Line}
    ${Existing_Order_Number}   Get Substring    ${Line}  11
    #Log to console  ${Existing_Order_Number}
    #${Replaced_line}   Replace String Using Regexp    ${Line}   ${Existing_Order_Number}   '${order_no}';
    ${Replaced_line}   Replace String Using Regexp    ${Line}   ${Existing_Order_Number}   '319103017660';
    #Log to console   ${Replaced_line}
    ${New_request}   Replace String Using Regexp    ${DDM_request}  ${Line}   ${Replaced_line}
    #Log to console   ${New_request}
    Execute DDM Request   ${New_request}

Execute DDM Request
    [Arguments]   ${New_request}
    ${Utilities}  set variable    //span[text()='utilities']
    ${Apex Execute}  set variable   //span[text()='utilities']//following::li[2]/a
    ${Submit}  set variable  //input[@type='submit']
    Wait until element is visible   ${Utilities}  30s
    Force Click element   ${Utilities}
    Force Click element  ${Apex Execute}
    Input Text   //textarea[@id='scriptInput']   ${New_request}
    Click element  ${Submit}

File Handling - Get Debug Line
    ${result}   Fetch Result
    Get Debug line   ${result}

Get Debug line
    [Arguments]   ${result}
    ${Debug_line}   Get Lines Containing String  ${result}  |DEBUG|
    #Log to console   ${Debug_line}
    ${Debug_Code}   Fetch From Right   ${Debug_line}  |DEBUG|
    Set Test Variable    ${DEBUG CODE}    ${Debug_Code}
    #Log to console    ${Debug_Code}

Fetch Result
    ${Result_Text}  set variable  //*[contains(text(),'Execute Anonymous')]
    Wait until element is visible   ${Result_Text}   30s
    ${Result}   Get Text   ${Result_Text}
    #Log to console  ${Result}
    [Return]   ${Result}

Execute Debug code
    ${Utilities}  set variable    //span[text()='utilities']
    ${Rest Explorer}  set variable   //span[text()='utilities']//following::li[1]/a
    ${Submit}  set variable  //input[@id='execBtn']
    Wait until element is visible   ${Utilities}  30s
    Force Click element   ${Utilities}
    Force Click element  ${Rest Explorer}
    Wait until element is visible   //input[@value='POST']   30s
    Click Element  //input[@value='POST']
    clear element text   //input[@id='urlInput']
    Input Text  //input[@id='urlInput']   /services/apexrest/DDM/Events
    Input Text   //textarea[@name='requestBody']   ${DEBUG CODE}
    Click element  ${Submit}

Verify Response code
    Sleep  5s
    Wait until element is visible  //div[@id='codeViewPortContainer']//p[@id='codeViewPort']  30s
    ${Response}    Get Text  //div[@id='codeViewPortContainer']//p[@id='codeViewPort']
    ${Line}   Get Line   ${Response}  0
    Should contain  ${Line}    200
    Log to console   Recieved proper response code

Close opened windows
    ${title_var}        Get Window Titles
    ${Length}   Run keyword   Get length   ${title_var}
    : FOR    ${i}    IN RANGE    0   ${Length}
    \    Select Window       title=@{title_var}[${i}]
    \    close window


Validate Billing system response
    Reload page
    Wait until element is visible    //div[@class='content iframe-parent']/iframe   60s
    select frame    //div[@class='content iframe-parent']/iframe
    sleep    30s
    Element should be visible    //a[text()='Start']
    Element should be visible    //a[text()='Create Assets']
    Element should be visible    //a[text()='Deliver Service']
    Element should be visible    //a[text()='Order Events Update']
    Element should be visible   //a[text()='Call Billing System']
    #go back
    log to console    Validate Billing system Response
    force click element       //a[@class='item-label item-header' and text()='Call Billing System']
    unselect frame
    #sleep       80s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //div[@class="slds-form-element__control slds-grid itemBody"]//span[text()="Completed"]
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
    wait until page contains element    //div[@class="slds-form-element__control slds-grid itemBody"]//span[text()="Completed"]      300s
    #Go back

Validate Call case Management status
    Wait until element is visible    //div[@class='content iframe-parent']/iframe
    select frame    //div[@class='content iframe-parent']/iframe
    Wait until element is visible   //a[@class='item-label item-header' and text()='Call Case Management']   60s
    force click element       //a[@class='item-label item-header' and text()='Call Case Management']
    unselect frame
    #sleep       80s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //div[@class="slds-form-element__control slds-grid itemBody"]//span[text()="Completed"]
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
    wait until page contains element    //div[@class="slds-form-element__control slds-grid itemBody"]//span[text()="Completed"]      300s
    #Go back


ValidateSapCallout
    wait until page contains element        //div[@class='slds-page-header__title slds-m-right--small slds-align-middle fade-text']/span        30s
    ${order_number}   get text  //div[@class='slds-page-header__title slds-m-right--small slds-align-middle fade-text']/span
    log to console  ${order_number}.this is order numner
    Set test variable   ${order_no}      ${order_number}
    # Donot remove as reusing it for change plan - Aarthy
    ${Detail}=  set variable   //div[contains(@class,'active')]//span[text()='Details']//parent::a
    sleep  3s
    Wait until element is visible   ${Detail}  60s
    Force click element   ${Detail}
    Wait until element is visible  //span[text()='Orchestration Plan']//following::a[1]  30s
    Click element  //span[text()='Orchestration Plan']//following::a[1]
    sleep    10s
    Wait until element is visible  xpath=//*[@title='Orchestration Plan View']/div/iframe[1]   60s
    select frame    xpath=//*[@title='Orchestration Plan View']/div/iframe[1]
    Wait until element is visible  //a[text()='Start Order']  60s
    Element should be visible    //a[text()='Start Order']
    Element should be visible    //a[text()='Create Assets']
    sleep   3s
    force click element       //a[@class='item-label item-header' and text()='Callout to SAP Provisioning I']
    unselect frame
    #sleep       80s
    ${status_page}    Run Keyword And Return Status    Wait Until Element Is Visible    //div[@class="slds-form-element__control slds-grid itemBody"]//span[text()="Completed"]   200s
    Run Keyword If    ${status_page} == False    Reload Page
    Run Keyword If    ${status_page} == False    Sleep  60s
    wait until page contains element    //div[@class="slds-form-element__control slds-grid itemBody"]//span[text()="Completed"]      300s
