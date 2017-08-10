*** Settings ***
Library             Selenium2Library
Library             String
Library             Dialogs
Library             Screenshot
Library             DateTime
Library             Collections
Library             libs.selenium_extensions.SeleniumExtensions.SeleniumExtensions

Resource            ${PROJECTROOT}${/}resources${/}common_variables.robot

*** Keywords ***

Click Visible Element
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    15 s
    Click Element    ${locator}

Create Unique Email
    [Arguments]     ${email}=noreply@teliasonera.com
    ${email_prefix}=            Create Unique Name    ${EMPTY}
    ${email}=       Set Variable If     '${email}' == 'noreply@teliasonera.com'    ${email_prefix}${email}     ${email}
    [Return]        ${email}

Create Unique Phone Number
    ${numbers}=    Generate Random String    4    [NUMBERS]
    [Return]    +358888${numbers}

Create Unique Name
    [Arguments]    ${prefix}
    ${numbers}=    Generate Random String    8    [NUMBERS]
    ${email}=      Set Variable If  '${prefix}'=='${EMPTY}'     ${numbers}      ${prefix} ${numbers}
    [Return]    ${email}

Get Date From Future
    [Documentation]    Returns current date (format: day.month.year, e.g. 28.6.2020) + x days,
    ...                where x = ${days} given as argument
    [Arguments]    ${days}
    ${date}=    Get Current Date
    ${date_in_future}=    Add Time To Date    ${date}    ${days} days
    ${converted_date}=    Convert Date    ${date_in_future}    result_format=datetime
    ${converted_date}=    Set Variable    ${converted_date.day}.${converted_date.month}.${converted_date.year}
    [Return]    ${converted_date}

Logout From All Systems
    [Documentation]     General logout keyword for test teardowns
    ${salesforce_open}=     Run Keyword And Return Status       Location Should Contain     salesforce.com
    Run Keyword If      ${salesforce_open}      Run Keyword and Ignore Error    Close Tabs And Logout   # Salesforce
    Run Keyword and Ignore Error    MUBE Logout CRM         # MultiBella

Open Browser And Go To Login Page
    Run Keyword If    '${BEHIND_PROXY}'=='True'     Open Browser And Go To Login Page (Proxy)
    ...     ELSE        Open Browser        ${LOGIN_PAGE}       ${BROWSER}
    Wait Until Page Contains Element     id=username
    Maximize Browser Window

Open Browser And Go To Login Page (Proxy)
    ${profile}=    Evaluate    selenium.webdriver.firefox.firefox_profile.FirefoxProfile(profile_directory="/home/jenkins/.mozilla/firefox/al34m1vz.default")    selenium
    ${proxy}=    Evaluate    sys.modules['selenium.webdriver'].Proxy()    sys, selenium.webdriver
    ${proxy.https_proxy}=    Set Variable    ${PROXY}
    Create Webdriver    ${BROWSER}    proxy=${proxy}    firefox_profile=${profile}
    Go To    ${LOGIN_PAGE}

Press Enter On
    [Arguments]     ${locator}
    Press Key       ${locator}      \\13

Press Tab On
    [Arguments]     ${locator}
    Press Key       ${locator}      \\9

Prolonged Input Text
    [Arguments]    ${locator}    ${text}
    [Documentation]    Setting input in crm with fast speed causes random special chars to appear in the input field.
    ...    We try to fix this by slowing selenium down when inputing text.
    ...    We return speed to normal after the text has been inputed.
    ${old_speed_value}=    Set Selenium Speed    1.3 seconds
    Input Text    ${locator}    ${text}
    [Teardown]    Set Selenium Speed    ${old_speed_value}

Run Inside Iframe
    [Arguments]         ${frame}    ${keyword}     @{args}
    Wait Until Page Contains Element    ${frame}      10 seconds
    Run Keyword and Ignore Error    Select Frame        ${frame}
    ${ret}=     Run Keyword And Return      ${keyword}    @{args}
    [Teardown]          Unselect Frame
    [Return]    ${ret}

Strip Area Code From Phone Number
    [Arguments]     ${number}
    ${stripped}=    Remove String       ${number}   +358
    [Return]    ${stripped}