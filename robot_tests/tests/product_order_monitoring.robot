*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot

Test Setup          Run Keywords    Open Browser And Go To Login Page    AND    Go to Salesforce And Login
Test Teardown       Close Browser

Force Tags          Performance



*** Variables ***
${PRODUCT}          Telia Yritysinternet

*** Test Cases ***
Single Product Monitor: Telia Yritysinternet
    [Tags]      single_product      yritysinternet
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Create Product Order        ${PRODUCT}      Single

Single Product Monitor: Telia Maksupääte
    [Tags]      single_product
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Set Test Variable           ${PRODUCT}      Telia Maksupääte
    Create Product Order        ${PRODUCT}     Single

Single Product Monitor: Telia Verkkotunnuspalvelu
    [Tags]      single_product
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Set Test Variable           ${PRODUCT}      Telia Verkkotunnuspalvelu
    Create Product Order        ${PRODUCT}      Single

Single Product Monitor: DataNet Multi
    [Tags]      single_product
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Set Test Variable           ${PRODUCT}      DataNet Multi
    Create Product Order        ${PRODUCT}      Single

Create And Order With Many Products
    [Tags]      multiple_products
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Create Product Order        10 Products     Multiple

Open Different Tabs And Check Their Loading Times
    [Tags]      view_page_load
    [Documentation]     This test case does not really test anything, it is only used to measure the load times of different
    ...                 tabs from the top left corner menu
    [Template]      Open The Correct Page And Select View All
    Todays Page
    Accounts        New This Week
    Contacts        New This Week
    Opportunities   Closing Next Month
    Dashboards
    Activities
    Calendar For Sales Console
    Cases
    Ideas

*** Keywords ***
Create Product Order
    [Arguments]         ${test_product}    ${product_amount}
    Log To Console      ${\n} Product: ${PRODUCT}
    Go To Account       ${DEFAULT_TEST_ACCOUNT}
    Create New Opportunity For Customer
    Verify That Opportunity Is Found With Search And Go To Opportunity
    Add Price Book For Opportunity
    Run Keyword     Create CPQ ${product_amount}

Create CPQ Single
    Open Details View At Opportunity
    Click CPQ At Opportunity View
    Search And Add Product To Cart (CPQ)    ${PRODUCT}
    Fill Missing Required Information If Needed (CPQ)
    Click Next (CPQ)
    Select Sales Type For Order (CPQ)
    Click Next (CPQ)
    Handle Credit Score (CPQ)
    Click CPQ At Quote View
    Click Create Order (CPQ)

Create CPQ Multiple
    Open Details View At Opportunity
    Click CPQ At Opportunity View
    Add 50 Products To Order
    Click Next (CPQ)
    Select Sales Type For Order (CPQ)
    Click Next (CPQ)
    Handle Credit Score (CPQ)
    Click CPQ At Quote View
    Click Create Order (CPQ)

Add 50 Products To Order
    Search For Product (CPQ)      Telia
    Load More Products (CPQ)
    Load More Products (CPQ)
    Load More Products (CPQ)
    Load More Products (CPQ)
    Load More Products (CPQ)
    :FOR    ${i}    IN RANGE    50
    \   Add Nth Product To Cart (CPQ)   ${i+1}

Reset View To Default
    [Arguments]     ${default}
    Select Correct View Type    ${default}

Open The Correct Page And Select View All
    [Arguments]     ${page}     ${default}=${EMPTY}
    Run Keyword     Open ${page}
    Run Keyword Unless      '${default}'=='${EMPTY}'    Run Keyword     Select All ${page} View
    Run Keyword Unless      '${default}'=='${EMPTY}'    Reset View To Default   ${default}

Select All Accounts View
    Select Correct View Type    All Accounts

Select All Contacts View
    Select Correct View Type    All Contacts

Select All Opportunities View
    Select Correct View Type    All Opportunities
