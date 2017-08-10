*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}multibella_keywords.robot

#Suite Setup         Open Browser And Go To Login Page
Test Setup          Run Keywords    Open Browser And Go To Login Page    AND    Go to Salesforce And Login
Test Teardown       Close Browser

Test Template       Create Product Order And Verify It Was Created
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
    [Template]     Availability Check Test Case
    00510   Helsinki    Telekatu            1
    00580   Helsinki    Tuulensuunkuja      3
    00810   Helsinki    Hitsaajankatu       7

Sopiva Pro
    [Tags]      BQA-54
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Sopiva Pro L   Telia Sopiva Pro

Liikkuva Netti Pro
    [Tags]      BQA-55
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Liikkuva Netti Pro XXL    Liikkuva netti

Microsoft Office 365
    [Tags]      BQA-56
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Microsoft Office 365    Microsoft Office 365

Kodin Netti yrityksille
    [Tags]      BQA-57    wip    no-product-yet
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Kodin Netti yrityksille    Kodin Netti yrityksille

Maksupääte
    [Tags]      BQA-58
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Maksupääte    Maksupäätepalvelu

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
    Spotify Business Single Location     Mobiilin muut lisäpalvelut

Devices Phones
    [Tags]      BQA-62    wip    no-product-yet
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Palvelulaite Motorola Moto Z Black     Telia Palvelulaite

Control Subscriptions
    [Tags]      BQA-63
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    # Verify that this product is correct
    Telia Koneliittymä Plus    Koneliittymät (Control ja Control Plus)

Liikkuva Yritysverkko
    [Tags]      BQA-80
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Liikkuva Yritysverkko    Liikkuva Yritysverkko

Yritys WLAN
    [Tags]      BQA-81
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Yritys WLAN    Yritys WLAN

Sonera Talous
    [Tags]      BQA-82
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Taloushallinto M-paketti     Muu tuote

Telia Puheväylä
    [Tags]      BQA-83    wip    no-product-yet
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Puheväylä    Telia Puheväylä

Käyttötuki (DataInfo)
    [Tags]      BQA-84    wip    no-product-yet
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Käyttötuki (DataInfo)    Käyttötuki (DataInfo)

Käyttötuki
    [Tags]      BQA-85
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Käyttötuki    Muu tuote

Web Contact Center
    [Tags]      BQA-86    wip   test-next
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Kontakti L    Telia Kontakti

Palvelunumerot
    [Tags]      BQA-87    wip    no-product-yet
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Palvelunumerot    Palvelunumerot

Yritystietoturva
    [Tags]      BQA-88
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Yritystietoturva (tietoturvapaketti)    Palomuuri

Yritysinternet Plus
    [Tags]      BQA-89
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Yritysinternet Plus    Yritysinternet Plus

Yrityskiinteistökytkin
    [Tags]      BQA-90
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Yrityskiinteistökytkin    Yrityskiinteistökytkin

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
    iPad Air 2 32GB WiFi + Cellular Kulta    Muu tuote

Devices Laptops
    [Tags]      BQA-94    wip    no-product-yet
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Lenovo L460 LTE Heti Valmis Musta    Devices Laptops

Yritysinternet Langaton
    [Tags]      BQA-95
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Yritysinternet Langaton     Yritysinternet Langaton

Viestintäpalvelu VIP
    [Tags]      BQA-96
    [Documentation]    First parameter parameter is detailed product type, second parameter is common product name (title)
    Telia Viestintäpalvelu VIP (24 kk)     Viestintäpalvelu VIP

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
    Go To Account       ${OPPO_TEST_ACCOUNT}
    Create New Opportunity For Customer
    Verify That Opportunity Is Found With Search
    Create CPQ
    Verify Sales Case from Multibella to contain correct data

Create Parameterized Product Order And Verify It Was Created
    [Arguments]    ${test_product}
    Set Test Variable    ${PRODUCT}    ${test_product}
    Log To Console    ${\n} Product: ${PRODUCT}
    Create New Opportunity From main Page
    Create CPQ
    Close Browser
    MUBE Open Browser And Login As CM User
    MUBE Verify That Case Exists in MuBe

Create CPQ
    Open Details View At Opportunity
    Click CPQ At Opportunity View
    Search And Add Product To Cart (CPQ)    ${PRODUCT}
    Fill Missing Required Information If Needed (CPQ)
    Select Sales Type For Order (CPQ)
    Click View Quote And Go Back To CPQ
    Click Create Order (CPQ)
    Click Create Assets (CPQ)
    Add Contact Person To Product Order    ${OPPO_TEST_CONTACT}
    Submit Order To Delivery (CPQ)
    Wait Until Keyword Succeeds    60 s    5 s    Extract MuBe CaseID From Opportunity
    Close Browser

Verify Sales Case from Multibella to contain correct data
    MUBE Open Browser And Login As CM User
    MUBE Verify That Case Exists in MuBe
    MUBE Verify That Case Attributes Are Populated Correctly

# TODO
Verify All The Information Of Product Order
    Naming is correct (finnish)
    Structure is correct (parent as the offering, options/vas/included services as child)
    Business rules are correct (including mandatory, default products)
    Charasteristics (attributes) are correct
    Charasteristics values are correct
    Prices are correct

Availability Check Test Case
    [Arguments]     ${postal_code}=${EMPTY}
    ...             ${city}=${EMPTY}
    ...             ${address}=${EMPTY}
    ...             ${street_number}=${EMPTY}
    Log to Console    ${address} ${street_number}, ${postal_code} ${city}
    Go To Account       ${OPPO_TEST_ACCOUNT}
    Open Dashboard Tab At Account View
    Click Availability Check Button
    Fill Address Validation Information     ${postal_code}      ${city}     ${address}      ${street_number}
    Addresses Should Be Available           ${postal_code}      ${city}     ${address}      ${street_number}
    Select First Address and Verify Products Are Found