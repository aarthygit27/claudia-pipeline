*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot
Suite Teardown      Close All Browsers

Test Setup          Run Keywords    Open Browser And Go To Login Page    AND    Go to Salesforce And Login
Test Teardown       Close Browser
Test Template       Create Product Order And Verify It Was Created
Test Timeout        15 minutes

*** Variables ***

*** Test Cases ***
Sanity Check - Microsoft Office 365
    [Tags]      sanity_check
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Microsoft Office 365    Microsoft Office 365

Sanity Check - Telia Yhteys kotiin yrityksille
    [Tags]       sanity_check
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Yhteys kotiin yrityksille    Kodin Netti yrityksille

Sanity Check - Maksupääte
    [Tags]         sanity_check
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Maksupääte    Maksupäätepalvelu

Sanity Check - Verkkotunnuspalvelu
    [Tags]      sanity_check
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Verkkotunnuspalvelu    Verkkotunnuspalvelu

*** Keywords ***
Create Product Order And Verify It Was Created
    [Arguments]         ${test_product}    ${test_product_type}
    Set Test Variable   ${PRODUCT}    ${test_product}
    Set Test Variable   ${PRODUCT_TYPE}    ${test_product_type}
    Log To Console      ${\n} Product: ${PRODUCT}
    Go To Account       ${DEFAULT_TEST_ACCOUNT}
    Create New Opportunity For Customer
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Create CPQ
    #Verify Sales Case from Multibella to contain correct data

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
    Add Contact Person To Product Order    ${DEFAULT_TEST_CONTACT}
    Submit Order To Delivery (CPQ)
    #Wait Until Keyword Succeeds    2min    5 s    Extract MuBe CaseID From Opportunity
    Close Browser

Check If Quote Needs To Be Approved And Approve If Necessary
    ${quote_page_open}=     Quote Should Be Open
    Run Keyword Unless  ${quote_page_open}      Go To Account   ${OPPORTUNITY_NAME}     Quote
    ${approval_not_needed}=     Check If Quote Needs Approval
    Run Keyword If      ${approval_not_needed}      Return From Keyword
    Submit Quote For Approval
    Close Tabs And Logout
    Login As Digisales Manager And Approve Quote
    Go To Salesforce And Login
    Go To Account   ${OPPORTUNITY_NAME}     Quote