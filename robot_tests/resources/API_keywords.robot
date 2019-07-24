*** Settings ***
Library            ../resources/API_keywords_library.py
Library           Collections
Library           SeleniumLibrary
Library           ../resources/API_variables.robot

*** Variables ***
# Set initial value for suite variable

*** Keywords ***
Authenticate To API
    ${return_value} =    API Authenticate
    Should Be Equal As Integers    ${return_value}    200

Authenticate To API ULM
    ${return_value} =    API Authenticate Ulm
    Should Be Equal As Integers    ${return_value}    200

Authenticate To API NGSF_DDM
    ${return_value} =    API Authenticate Ngsf Ddm
    Should Be Equal As Integers    ${return_value}    200

Authenticate To API SAP
    ${return_value} =   API_Authenticate_Sap
    Should be Equal As Integers    ${return_value}    200

Authenticate To API ECM
    ${return_value} =   API_Authenticate_Ecm
    Should be Equal As Integers    ${return_value}    200

Authenticate To Address Validation
    ${return_value} =   API_Authenticate_Address_validation
    Should be Equal As Integers    ${return_value}    200

Authenticate To resource available validation
    ${return_value} =   API_Authenticate_resource_availability
    Should be Equal As Integers    ${return_value}    200

Authenticate To check credit score
    ${return_value} =   API_Authenticate_credit_score
    Should be Equal As Integers    ${return_value}    200

Authenticate To ECM Notify
    ${return_value} =   Authenticate Ecm Notify
    Should be Equal As Integers    ${return_value}    200

Authenticate To Sproject Manual availability
    ${return_value} =   Authenticate Sproject
    Should be Equal As Integers    ${return_value}    200

Post Sproject Manual availability
    ${return_value} =    Sproject manual availability
    Should Be Equal As Integers    ${return_value}    200

Authenticate To create billing account
    ${return_value} =   Authenticate Create billing account
    Should be Equal As Integers    ${return_value}    200

Create Billing account for the business account
    ${return_value} =    Create Billing Account
    Should Be Equal As Integers    ${return_value}    200

Get Credit Scoring
    ${return_value} =    API Get Credit Scoring
    Should Be Equal As Integers    ${return_value}    200

#ULM Integrations

Create New User to Existing Company ULM
    ${return_value} =    Create New User Existing Company ULM
    Should Be Equal As Integers    ${return_value}    200

Update ULM Request
    ${return_value} =    Update Request ULM
    Should Be Equal As Integers    ${return_value}    200

Create Service DDM Order
    ${return_value} =    Create Service Order DDM
    Should Be Equal As Integers    ${return_value}    200

Get Address Validation
    ${return_value} =    Get Validate the address
    Should Be Equal As Integers    ${return_value}    200

Get resource availbility
    ${return_value} =    Get resource availability in address
    Should Be Equal As Integers    ${return_value}    200

Get credit score
    ${return_value} =    Check credit score
    Should Be Equal As Integers    ${return_value}    200

Notify Service NGSF Order
#    ${return_value} =    Notify NGSF change Order
#    Should Be Equal As Integers    ${return_value}    200

Notify Service DDM Order
#    ${return_value} =    Notify DDM change Order
#    Should Be Equal As Integers    ${return_value}    200

Create Service NGSF Order
    ${return_value} =    Create Service Order NGSF
    Should Be Equal As Integers    ${return_value}    200

Create SAP Product Order
    ${return_value} =   Create Product Order SAP
    Should be Equal As Integers     ${return_value}   200

Create ECM document
    ${return_value} =   Create Document ECM
    Should be Equal As Integers     ${return_value}   200

#Notify ECM document
#    ${return_value} =   Notify Document ECM
#    Should be Equal As Integers     ${return_value}   200