*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot

Test Setup          Run Keywords    Open Browser And Go To Login Page    AND    Go to Salesforce And Login
Test Teardown       Close Browser


*** Test Cases ***
Single Product
    [Tags]      single_product
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Create Product Order        Telia Yritysinternet     Yritysinternet     Single

Multiple Products
    [Tags]      multiple_products
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Create Product Order        10 Products     Yritysinternet     Multiple


*** Keywords ***
Create Product Order
    [Arguments]         ${test_product}    ${test_product_type}     ${product_amount}
    Set Test Variable   ${PRODUCT}    ${test_product}
    Set Test Variable   ${PRODUCT_TYPE}    ${test_product_type}
    Log To Console      ${\n} Product: ${PRODUCT}
    Go To Account       ${OPPO_TEST_ACCOUNT}
    Create New Opportunity For Customer
    Verify That Opportunity Is Found With Search
    Run Keyword     Create CPQ ${product_amount}

Create CPQ Single
    Open Details View At Opportunity
    Click CPQ At Opportunity View
    Search And Add Product To Cart (CPQ)    ${PRODUCT}
    Fill Missing Required Information If Needed (CPQ)
    Select Sales Type For Order (CPQ)
    Click View Quote And Go Back To CPQ
    Click Create Order (CPQ)
    # Click View Record (CPQ)
    # Click Create Assets (CPQ)
    # Add Contact Person To Product Order    ${OPPO_TEST_CONTACT}
    # Submit Order To Delivery (CPQ)

Create CPQ Multiple
    Open Details View At Opportunity
    Click CPQ At Opportunity View
    Add 10 Products To Order
    Select Sales Type For Order (CPQ)
    Click View Quote And Go Back To CPQ
    Click Create Order (CPQ)
    # Click View Record (CPQ)
    # Click Create Assets (CPQ)
    # Add Contact Person To Product Order    ${OPPO_TEST_CONTACT}
    # Submit Order To Delivery (CPQ)

Add 10 Products To Order
    Search For Product (CPQ)      Telia
    Load More Products (CPQ)
    # Load More Products (CPQ)
    # Load More Products (CPQ)
    # Load More Products (CPQ)
    :FOR    ${i}    IN RANGE    10
    \   Add Nth Product To Cart (CPQ)   ${i+1}
    # \   Add Random Product To Cart (CPQ)
    # \   Search And Add Product To Cart (CPQ)    ${PRODUCT}      ${i+1}
    # \   Fill Missing Required Information If Needed (CPQ)