*** Settings ***
Documentation     Professional services Test cases are executed in ${ENVIRONMENT} sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ../../p&o/resources/Common.robot
Resource          ../../p&o/resources/Variables.robot

*** Test Cases ***
Product1:Telia Multiservice NNI
    [Tags]    BQA-9953      B2O_Lightning  Product not available
    General Setup    B2O
    Search and add product    Telia Multiservice NNI
    clicking on next button
    UpdatePageNextButton
    Create_Order
    log       Billing account is ${billingaccount}
    log       Order Number is ${Order_Id}
