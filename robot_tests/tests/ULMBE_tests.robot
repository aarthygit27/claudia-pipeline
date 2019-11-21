*** Settings ***
Library           OperatingSystem
Library           String
Library           Collections
Library           BuiltIn
Resource          ../resources/ULMBE_keywords.robot

Documentation    Suite description

*** Test Cases ***
ULMBE_login
    [Documentation]     Test create CSR login endpoint.
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
