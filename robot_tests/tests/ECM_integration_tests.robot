*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}multibella_keywords.robot

#Suite Setup         Open Browser And Go To Login Page
Suite Teardown      Close All Browsers

Test Setup          Run Keywords    Open Browser And Go To Login Page    AND    Go to Salesforce And Login
Test Teardown       Close Browser
#Test Template       Create Product Order And Verify It Was Created
Test Timeout        20 minutes

Force Tags          products
Resource     resources/cpq_keywords.robot


*** Variables ***

*** Keywords ***

Create CPQ
    Open Details View At Opportunity
    Click CPQ At Opportunity View
    Search And Add Product To Cart (CPQ)    ${PRODUCT}
    Fill Missing Required Information If Needed (CPQ)
    Click Next (CPQ)
    Select Sales Type For Order (CPQ)
    Click Next (CPQ) Button
    Handle Credit Score (CPQ)
    Check If Quote Needs To Be Approved And Approve If Necessary
    Click CPQ At Quote View
    Click Create Order (CPQ)
    Click Create Order After Credit Score Check (CPQ)    # Quote Approved for Submittal

Create Product Order And Verify It Was Created
    [Arguments]         ${test_product}    ${test_product_type}
    Set Test Variable   ${PRODUCT}    ${test_product}
    Set Test Variable   ${PRODUCT_TYPE}    ${test_product_type}
    Log To Console      ${\n} Product: ${PRODUCT}
    Go To Account       ${DEFAULT_TEST_ACCOUNT}
    Create New Opportunity For Customer
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Create CPQ

Click Add Attachment Button
    Run Inside Iframe   ${OPPORTUNITY_FRAME}    Click Element   ${ADD_ATTTACHMENT_BUTTON}
    Sleep   5
    Select Window  NEW


Add Name To Attachment
    Wait Until Element Is Enabled    ${ATTACHMENT_NAME}   60s
    Wait Until Element Is Visible    ${ATTACHMENT_NAME}
    Input Text   ${ATTACHMENT_NAME}    test attachment

Attachment Has Been Loaded Successfully
    Wait Until Page Contains   Attachment has been loaded successfully.    30s

Upload Attachment
    Choose File  ${ATTACHMENT_FILE}  ${CURDIR}\\..\\data\\DummyAttachment.png

Create And Select An Order
    Create Product Order And Verify It Was Created  Telia Maksupääte    Maksupäätepalvelu

Add Description
    Input Text   ${ATTACHMENT_DESCRIPTION}    attachment description...

Document Status Approved
    Select From List  ${DOCUMENT_STATUS}    Approved

Document Type Order
    Select From List  ${DOCUMENT_TYPE}    Order

Click Load Attachment Button
    Click Element   ${CREATE_ATTACHMENT}

Click Send Documents To ECM Button
    Run Inside Iframe   ${OPPORTUNITY_FRAME}   Click Element    ${SEND_DOCUMENTS_BUTTON}

Close Attachment Window
    Close Window

Select Attachment
    Wait Until Element Is Enabled    ${SELECT_BUTTON}
    Wait Until Element Is Visible    ${SELECT_BUTTON}
    Click Element   ${SELECT_BUTTON}

Send Documents To ECM
    Select Window  MAIN
    Click Send Documents To ECM Button
    Select Window   NEW
    Select Attachment
    Click Element   ${UPLOAD_DOCUMENTS_BUTTON}
    Pause Execution
    Page Should Not Contain   sending document failed:401
    Close Window

*** Test Cases ***
Creating single Document (to ECM) Order Without Metadata
    [Tags]      BQA-4932   ecm_integration
    Create And Select An Order
    Click Add Attachment Button
    Add Name To Attachment
    Upload Attachment
    Add Description
    Document Status Approved
    Document Type Order
    Click Load Attachment Button
    Attachment Has Been Loaded Successfully
    Close Attachment Window
    Send Documents To ECM

#Creating single Document (to ECM) Order With Metadata
#    [Tags]      BQA-4932    wip
    #Create opportunity and order first? use product keywords?
#    Select An Order
#    Click Add Attachment Button
#    Upload Attachment
#    Add Name To Attachment
#    Add decsription
#    Document Status Approved
#    Click Load Attachment Button
#    Attachment Has Been Loaded Successfully
#    Select Next To Update Metadata
#    Close Attachment Window
#    Click Send Documents To ECM Button

#Creating single Document (to ECM, manual) Contract Without Metadata
#    [Tags]      BQA-4933   wip
#    select an contract
#    click Add Attachment button
#    Upload attachment
#    add name to attachment
#    add decsription
#    document status Approved
#    click Load attachment button
#    Attachment has been loaded successfully
#    Close Attachment Window
#    click SEnd documents to ECM BUtton

#Creating single Document (to ECM, manual) Contract With Metadata
#    [Tags]      BQA-4933   wip
#    select an contract
#    click Add Attachment button
#    Upload attachment
#    add name to attachment
#    add decsription
#    document status Approved
#    click Load attachment button
#    Attachment has been loaded successfully
#    Close Attachment Window
#    click SEnd documents to ECM BUtton

#Creating multiple Documents (to ECM) Contract
#    [Tags]      BQA-5020   wip
#    select an contract
#    click Add Attachment button
#    Upload attachment
#    add name to attachment
#    add decsription
#    document status Approved
#    Attach Multiple Documents
#    click SEnd documents to ECM BUtton

