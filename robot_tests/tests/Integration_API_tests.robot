*** Settings ***
Library           OperatingSystem
Library           String
Library           Collections
Library           BuiltIn
Resource          ../resources/Integartion_API_keywords.robot
Resource          ../resources/salesforce_keywords.robot
Test Timeout      9 minutes

*** Variables ***


*** Test Cases ***

API_credit_scoring
    [Documentation]    Test credit scoring endpoint.
    [Tags]    APITests
    Authenticate To API
    Get Credit Scoring

ULM_Add_User
    [Documentation]    Test create, update ULM endpoint.
    [Tags]    APITests  wip
    Authenticate To API ULM
    Create New User to Existing Company ULM
    Update ULM Request

NGSF_Create_Service_Order
    [Documentation]    Test create NGSF endpoint.
    [Tags]    APITests
    Authenticate To API NGSF_DDM
    Create Service DDM Order

DDM_Create_Service_Order
    [Documentation]    Test create NGSF endpoint.
    [Tags]    APITests
    Authenticate To API NGSF_DDM
    Create Service NGSF Order

NGSF_Notification_Service_Order
    [Documentation]    Test create NGSF endpoint.
    [Tags]    APITests
    Authenticate To API NGSF_DDM
#    Notify Service NGSF Order

DDM_Notification_Service_Order
    [Documentation]    Test create NGSF endpoint.
    [Tags]    APITests  wip
    Authenticate To API NGSF_DDM
    Notify Service DDM Order

SAP_Create_Product_Order
   [Documentation]     Test create SAP endpoint.
   [Tags]  APITests wip
    Authenticate To API SAP
    Create SAP Product Order

ECM_Create_document
    [Documentation]     Test create ECM endpoint.
    [Tags]  APITests
    Authenticate To API ECM
    Create ECM document

Address_validation
    [Documentation]     Test create address endpoint.
    [Tags]  APITests
    Authenticate To Address validation
    Get address validation

Resource_availability
    [Documentation]     Test search for resources avilable in the address.
    [Tags]  APITests
    Authenticate To resource available validation
    Get resource availbility

Credit_score
    [Documentation]     Test to get credit score.
    [Tags]  APITests
    Authenticate To check credit score
    Get credit score

ECM_Notify_document
    [Documentation]     Test create SAP endpoint.
    [Tags]  APITests
    Authenticate To ECM Notify
#    Notify ECM document

Manual_availibility
    [Documentation]     Test create SAP endpoint.
    [Tags]  APITests
    Authenticate To Sproject Manual availability
    Post Sproject Manual availability

Create_Billing_Account
    [Documentation]     Test create SAP endpoint.
    [Tags]  APITests
    Authenticate To create billing account
    Create Billing account for the business account

ULMBE_login
    [Documentation]     Test create ULM login endpoint.
    [Tags]  APITests
    CSR Login
    CSR Logout

ULMBE user views own details
    [Documentation]     Test create ULM login endpoint.
    [Tags]  APITests
    User login
    User details
    User group
    User group user details
    User group memberships
    CSR logout

ULMBE user changes own details

    UserUpdateProfilebySelfCare session start
    UserUpdateProfilebySelfCare session step




