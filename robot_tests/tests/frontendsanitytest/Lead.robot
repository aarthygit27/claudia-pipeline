*** Settings ***
Documentation     Sanity Test cases are executed in ${ENVIRONMENT} Sandbox
Test Setup        Open Browser And Go To Login Page
Test Teardown     Logout From All Systems and Close Browser
Resource          ..${/}resources${/}sales_app_light_keywords.robot
Resource          ..${/}resources${/}common.robot
Resource          ..${/}resources${/}multibella_keywords.robot
#Library             test123.py


*** Test Cases ***

Lead_Creation
    [Documentation]    This TC creates lead from the Web-to-lead form and validate the same in Claudia leads tab,
    ...    convert it to opportunity
    [Tags]    SreeramE2E    Lightning
    ${lead_file}    run keyword    open file from resources    lead_Release.html
    go to    file:///${lead_file}
    ${fname}    generate random string    3    [NUMBERS]F
    ${lname}    generate random string    3    [NUMBERS]L
    ${mobile}    create unique mobile number
    ${title}    generate random string    5    [NUMBERS]abcdefghi
    ${desc}    generate random string    10    [NUMBERS]abcdef
    sleep    5s
    enter random data to lead web form    ${fname}    ${lname}    ${lead_email}    ${mobile}    ${title}    ${desc}
    go to    ${LOGIN_PAGE_APP}
    Go To Salesforce and Login into Lightning       B2B DigiSales
    #login to salesforce as digisales lightning user vlocupgsandbox
    go to entity    ${lead_account_name}
    ${contact_name}    run keyword    CreateAContactFromAccount_HDC
    open_todays_leads
    force click element    //a[@title='${fname} ${lname}']
    wait until page contains element    //span[text()='${fname} ${lname}']    30s
    validate_Created_Lead    ${fname}    ${lname}    ${lead_email}    ${mobile}    ${title}    ${desc}
    Edit_and_Select_Contact    ${contact_name}
    scroll page to location    0    0
    click element    ${convert_lead_btn}
    wait until page contains element    ${converting_lead_header}    30s
    input text    ${lead_name_input}    Lead_${fname}_${lname}
    input text    ${lead_desc_textarea}    ${desc}
    ${close_date}    get date from future    10
    sleep    3s
    input text    ${lead_close_date}    ${close_date}
    click element    ${converting_lead_dialogue}
    click element    ${converting_lead_overlay}
    wait until page contains element    ${lead_converted_h4}    60s
    wait until page contains element    //span[text()='Opportunity']//ancestor::div[@class="slds-box"]//a[text()='Lead_${fname}_${lname}']    30s
    click element    //span[text()='Opportunity']//ancestor::div[@class="slds-box"]//a[text()='Lead_${fname}_${lname}']
    wait until page contains element    //span[text()='Opportunity ID']    30s
    scrolluntillfound    //span[text()='Opportunity Record Type']/../..//span[text()='Opportunity']
    page should contain element    //span[text()='Opportunity Record Type']/../..//span[text()='Opportunity']