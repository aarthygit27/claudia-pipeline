*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot
Resource            ${PROJECTROOT}${/}resources${/}multibella_keywords.robot

#Suite Setup         Open Browser And Go To Login Page
Suite Teardown      Close All Browsers

Test Setup          Run Keywords    Open Browser And Go To Login Page    AND    Go to Salesforce And Login
Test Teardown       Close Browser
#Test Template       Create Product Order And Verify It Was Created
Test Timeout        20 minutes

Force Tags          products
Resource     resources/cpq_keywords.robot


*** Variables ***

*** Keywords ***

*** Test Cases ***
Test for ordering Telia Colocation + 12RU Cabinet(DDM Integration)
    [Tags]      BQA-5127    wip

#Create new Opportunity and set price book as HDC Pricebook
#Go to CPQ
#Order as in described in the subject
#Check Product Structure
#Check Attributes and Values
#Check Infotexts
#Check Pricing
#Create Quote and Order
#Submit order by Decomposing Order and Activating Orchestration Plan
#Check Fulfilment request
#Check Assets are 'In Progress'
#Check that Service Order is initiated
#Check that Assetize Order is completed
#Check that Order is provisioned in DDM and Assets are created in DDM
#Check that Order Events Update is completed
#Check that Service Assets are Updated
#Check that Call for Billing System is completed
#Check that Activate Billing on Assets is completed
#Go to Order and check that Order Status is 'Activated'
#Go to Account and check that Asset statuses are 'Active'
