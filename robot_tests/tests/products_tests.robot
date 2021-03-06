*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}multibella_keywords.robot

#Suite Setup         Open Browser And Go To Login Page
Suite Teardown      Close All Browsers

Test Setup          Run Keywords    Open Browser And Go To Login Page    AND    Go to Salesforce And Login
Test Teardown       Close Browser
Test Template       Create Product Order And Verify It Was Created
Test Timeout        20 minutes

Force Tags          products

*** Variables ***

${MUBE_CASE_ID}     1323424
#${PRODUCT}          Yritysinternet Plus

*** Test Cases ***
# MuBe Case Test
#     [Documentation]    Entry conditions: Yritysinternet configured in Product Catalog
#     [Tags]      MUBE

#     Verify That Case Exists in Multibella

# Parameterized Product Order
#     [Documentation]    Entry conditions: Yritysinternet configured in Product Catalog
#     [Tags]      common_product_order
#     [Template]    Create Parameterized Product Order And Verify It Was Created
#     ${PRODUCT}

Test Salesforce Address Validation And Availability Check
    [Tags]      BQA-10      BQA-1842    smoke
    [Timeout]   10 minutes
    [Template]     Availability Check Test Case
    00510   Helsinki    Telekatu            1
    00580   Helsinki    Tuulensuunkuja      3
    00810   Helsinki    Hitsaajankatu       7

Sopiva Pro
    [Tags]      BQA-54
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Sopiva Pro L   Telia Sopiva Pro    #todo: fix - fails on radio button click.

Liikkuva Netti Pro
    [Tags]      BQA-55
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Liikkuva Netti Pro XXL    Liikkuva netti

Microsoft Office 365
    [Tags]      BQA-56
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Microsoft Office 365    Microsoft Office 365    # product is "null" in MUBE

Telia Yhteys kotiin yrityksille
    [Tags]      BQA-57
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Yhteys kotiin yrityksille    Kodin Netti yrityksille   # product is only "Kodin Netti" in MUBE

Maksup????te
    [Tags]      BQA-58
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Muutos Telia Maksup????te    Maksup????tepalvelu

Verkkotunnuspalvelu
    [Tags]      BQA-59
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Verkkotunnuspalvelu    Verkkotunnuspalvelu

Yritysinternet
    [Tags]      BQA-60      BQA-1841    BQA-1821    smoke
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Yritysinternet     Yritysinternet

Spotify for Business
    [Tags]      BQA-61
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Spotify Business Single Location     Mobiilin muut lis??palvelut

Devices Phones
    [Tags]      BQA-62
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Palvelulaite Motorola Moto Z Black     Muu tuote

Control Subscriptions
    [Tags]      BQA-63
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    # Verify that this product is correct
    Telia Koneliittym?? Plus    Koneliittym??t (Control ja Control Plus)

Liikkuva Yritysverkko
    [Tags]      BQA-80
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Liikkuva Yritysverkko    Liikkuva Yritysverkko    # product is "null" in MUBE

Yritys WLAN
    [Tags]      BQA-81
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Yritys WLAN    Yritys WLAN

Sonera Talous
    [Tags]      BQA-82
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Taloushallinto M-paketti     Muu tuote

Telia Puhev??yl??
    [Tags]      BQA-83
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Puhev??yl?? (200 puheyhteytt??)    Telia Puhev??yl??

# K??ytt??tuki (DataInfo)
#     [Tags]      BQA-84    wip    no-product-yet
#     [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
#     Telia K??ytt??tuki    K??ytt??tuki (DataInfo)

K??ytt??tuki
    [Tags]      BQA-84      BQA-85
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia K??ytt??tuki    Muu tuote

Web Contact Center
    [Tags]      BQA-86
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Kontakti L    Telia Kontakti

Palvelunumerot
    [Tags]      BQA-87
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Palvelunumero    Palvelunumerot

Yritystietoturva
    [Tags]      BQA-88
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Yritystietoturva (tietoturvapaketti)    Palomuuri

Yritysinternet Plus
    [Tags]      BQA-89
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Yritysinternet Plus    Yritysinternet Plus

Yrityskiinteist??kytkin
    [Tags]      BQA-90
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Yrityskiinteist??kytkin    Yrityskiinteist??kytkin

Alerta
    [Tags]      BQA-91
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Alerta puitesopimus    Alerta

Devices-as-a-Service (DataInfo)
    [Tags]      BQA-92
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Datainfo Service    Datainfo Service

Devices Tablets
    [Tags]      BQA-93
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    iPad Air 2 32GB WiFi + Cellular Kulta Telia Laitesopimus    Muu tuote

Devices Laptops
    [Tags]      BQA-94
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Palvelulaite Lenovo ThinkPad L460 i5-6200U / 14" FHD / 8GB / 256SSD / W10P    Telia Palvelulaite

Yritysinternet Langaton
    [Tags]      BQA-95
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Yritysinternet Langaton     Yritysinternet Langaton

Viestint??palvelu VIP
    [Tags]      BQA-96
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Viestint??palvelu VIP (24 kk)     Viestint??palvelu VIP

Touchpoint
    [Tags]      BQA-97
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Touchpoint    Touchpoint

F-Secure Protection for Business
    [Tags]      BQA-98
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    F-Secure Protection for Business (PSB)    Muu tuote

CID
    [Tags]      BQA-99
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Cid    CID

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
    Verify Sales Case from Multibella to contain correct data

# Create Parameterized Product Order And Verify It Was Created
#     [Arguments]    ${test_product}
#     Set Test Variable    ${PRODUCT}    ${test_product}
#     Log To Console    ${\n} Product: ${PRODUCT}
#     Create New Opportunity From main Page
#     Create CPQ
#     Close Browser
#     MUBE Open Browser And Login As CM User
#     MUBE Verify That Case Exists in MuBe

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
    Wait Until Keyword Succeeds    5min    5 s    Extract MuBe CaseID From Opportunity
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

Verify Sales Case from Multibella to contain correct data
    MUBE Open Browser And Login As CM User
    MUBE Verify That Case Exists in MuBe
    MUBE Verify That Case Attributes Are Populated Correctly

Availability Check Test Case
    [Arguments]     ${postal_code}=${EMPTY}
    ...             ${city}=${EMPTY}
    ...             ${address}=${EMPTY}
    ...             ${street_number}=${EMPTY}
    ${passed}=      Set Variable        FAILED
    Log to Console    ${address} ${street_number}, ${postal_code} ${city}
    Go To Account       ${DEFAULT_TEST_ACCOUNT}
    Open Dashboard Tab At Account View
    Click Availability Check Button
    Fill Address Validation Information And Click Next     ${postal_code}      ${city}     ${address}      ${street_number}
    Verify That Products Are Found
    ${passed}=      Set Variable        PASSED
    [Teardown]      Log to Console      ${passed}