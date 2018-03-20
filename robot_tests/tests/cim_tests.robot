*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}multibella_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}aida_keywords.robot

Suite Teardown      Close All Browsers

#Test Setup          Login to Salesforce
Test Teardown       Logout From All Systems
Force Tags          cim

*** Test Cases ***
Create new Business Customer in MultiBella and verify it shows in Salesforce
    [Tags]      BQA-79    multibella
    MUBE Open Browser And Login As CM User
    MUBE Create New Business Customer With Language    Finnish
    MUBE Get Customer AIDA ID
    MUBE Logout CRM
    Close Browser
    Open Browser And Go To Login Page
    Login To Salesforce as Digisales User
    Verify New Business Customer Is Found In Salesforce
    Store New Customer Id to Be Removed In Another Test

# Execute Customer Termination in MultiBella and verify it shows in Salesforce
#     [Tags]      BQA-76   multibella
#     MUBE Open Browser And Login As CIM User
#     Create New Customer Only If Previously Created Customer Is Not Found
#     MUBE Change Customer Legal Status To Passived       ${BUSINESS_CUSTOMER_TO_BE_REMOVED}
#     MUBE Terminate Customer     ${BUSINESS_CUSTOMER_TO_BE_REMOVED}
#     MUBE Verify That Business Customer Is Terminated    ${BUSINESS_CUSTOMER_TO_BE_REMOVED}
#     MUBE Logout CRM
#     Close Browser
#     Open Browser And Go To Login Page
#     Login To Salesforce as Digisales User
#     Verify New Business Customer is Found In Salesforce
#     Verify That Business Customer Is Terminated         ${BUSINESS_CUSTOMER_TO_BE_REMOVED}


*** Keywords ***
Verify New Business Customer Is Found In Salesforce
    Wait Until Keyword Succeeds    15 minutes    15 seconds     Search Should Find Business Customer

Search Should Find Business Customer
    [Arguments]         ${customer}=${NEW_CUSTOMER_NAME}
    Run Keyword and Ignore Error    Close All Tabs
    Search Salesforce   ${customer}
    Searched Item Should Be Visible     ${customer}

Store New Customer Id to Be Removed In Another Test
    [Documentation]     "NEW_CUSTOMER_BUSINESS_ID" is a test variable which will be stored into
    ...                 a suite variable so we can delete in another test
    Set Suite Variable    ${BUSINESS_CUSTOMER_TO_BE_REMOVED}    ${NEW_CUSTOMER_BUSINESS_ID}

Create New Customer Only If Previously Created Customer Is Not Found
    ${status}=      Run Keyword And Return Status    Variable Should Exist    ${BUSINESS_CUSTOMER_TO_BE_REMOVED}
    Run Keyword If    '${status}'=='False'    MUBE Create New Business Customer With Language     Finnish
    Run Keyword If    '${status}'=='False'    Store New Customer Id to Be Removed In Another Test
