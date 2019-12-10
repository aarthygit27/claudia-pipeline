*** Settings ***
Library           OperatingSystem
Library           String
Library           Collections
Library           BuiltIn
Resource          ../resources/ULMBE_keywords.robot

*** Test Cases ***
Admin functionality: CSR login and logout
    [Documentation]     Test create CSR login endpoint.
    [Tags]  APITests_run
    CSR Login
    CSR Logout

User's own details
    [Documentation]     Test create ULM login endpoint.
    [Tags]  APITests_run
    b2oadm login
    User details
    User group
    User group user details
    User group memberships
    CSR logout

User Management: user changes own information
    [Documentation]     Test create ULM login endpoint.
    [Tags]  APITests_run
    User sowmi login
    UserUpdateProfilebySelf session start
    UserUpdateProfilebySelf session execute
    CSR Logout

User Management: user resets/updates password
    [Documentation]     Test create ULM login endpoint.
    [Tags]  APITests

User Management: user changes own information
    [Documentation]     Test create ULM login endpoint.
    [Tags]  APITests

User Management: use changes own information
    [Documentation]     Test create ULM login endpoint.
    [Tags]  APITests

Admin functionality: CSR reads company data
    [Documentation]     Test create CSR login endpoint.
    [Tags]  APITests

Admin functionality: CSR reads user data
    [Documentation]     Test create CSR login endpoint.
    [Tags]  APITests

Admin functionality: CSR changes user data
    [Documentation]     Test create CSR login endpoint.
    [Tags]  APITests

Admin functionality: CSR resets password
    [Documentation]     Test create CSR login endpoint.
    [Tags]  APITests

Admin functionality: CSR adds a user to a group on behalf of primary/admin
    [Documentation]     Test create CSR login endpoint.
    [Tags]  APITests

Admin functionality: CSR changes role of a user on behalf of primary/admin
    [Documentation]     Test create CSR login endpoint.
    [Tags]  APITests


