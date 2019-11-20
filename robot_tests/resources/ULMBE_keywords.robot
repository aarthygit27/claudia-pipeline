*** Settings ***
Documentation    Suite description
Library           Collections
Library           SeleniumLibrary
Library           ../resources/ULMBE_functionalities.py
Library           ../tests/ULMBE_tests.robot
*** Test Cases ***
CSR Login
    ${return_value} =   CSR Session start
    Should be Equal As Integers     ${return_value}   200

User Login
    ${return_value} =   User Session start
    Should be Equal As Integers     ${return_value}   200

User details
    ${return_value} =   User account details
    Should be Equal As Integers     ${return_value}   200

User group
    ${return_value} =   User group details
    Should be Equal As Integers     ${return_value}   200

User group user details
    ${return_value} =   User group user list
    Should be Equal As Integers     ${return_value}   200

User group memberships
    ${return_value} =   User group membership details
    Should be Equal As Integers     ${return_value}   200

CSR Logout
    ${return_value} =   Session end
    Should be Equal As Integers     ${return_value}   200