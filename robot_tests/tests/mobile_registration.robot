*** Settings ***
Documentation       The point of this suite is to login with all test users and select that the user never wants to register mobile phone.
...                 After this suite has been run, the rest of the suites can be run without getting stuck on mobile registration.
Resource            ${PROJECTROOT}${/}resources${/}salesforce_keywords.robot

Suite Setup         Open Browser And Go To Login Page
Suite Teardown      Close All Browsers

Test Template       Login To Salesforce And Handle Mobile Phone Registration
Test Teardown       Logout From Salesforce

Force Tags          dismiss_phone

*** Test Cases ***
Sales Admin
    ${SALES_ADMIN_USER}

Customer Care
    ${CUSTOMER_CARE_USER}

B2B DigiSales
    ${B2B_DIGISALES_USER}

Product Manager
    ${PRODUCT_MANAGER_USER}
