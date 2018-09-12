*** Settings ***
Library           OperatingSystem
Library           String
Library           Collections
Library           BuiltIn
Resource          ${PROJECTROOT}${/}resources${/}API_keywords.robot
Resource          ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot
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
    [Tags]    APITests
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


