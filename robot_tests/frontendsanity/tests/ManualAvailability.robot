*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Login.robot
Resource          ../../frontendsanity/resources/Availability.robot
Resource          ../../frontendsanity/resources/Opportunity.robot
Resource          ../../frontendsanity/resources/Variables.robot


*** Test Cases ***

Manual Availability - B2O
    [Tags]   BQA-11380  Test    AvailabilityCheck
    [Documentation]    Create Opportunity and perform manual availability check
    Go To Salesforce and Login into Lightning       B2O User
    Go To Entity    ${B2O Account}
    Go To Entity    ${B2O Account}
    ${oppo_name}   run keyword  CreateAOppoFromAccount_HDC  Test RT
    Go To Entity    ${oppo_name}
    Click Manual Availabilty
    Fill Request Form
    Verify Opportunity after performing availability request