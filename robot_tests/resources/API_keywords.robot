*** Settings ***
Library            ${PROJECTROOT}${/}resources${/}/API_keywords_library.py
Library           Collections
Library           SeleniumLibrary

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

Create Service NGSF Order
    ${return_value} =    Create Service Order NGSF
    Should Be Equal As Integers    ${return_value}    200