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
    [Arguments]     ${email}=${DEFAULT_EMAIL}
    ${email_prefix}=            Create Unique Name    ${EMPTY}
    ${email}=       Set Variable If     '${email}' == '${DEFAULT_EMAIL}'    ${email_prefix}${email}     ${email}
    [Return]        ${email}

Create Unique Phone Number
    ${numbers}=     Generate Random String    4    [NUMBERS]
    [Return]        +358888${numbers}

Create Unique Name
    [Arguments]     ${prefix}
    ${timestamp}=   Get Current Date    result_format=%Y%m%d-%H%M%S
    ${name}=        Set Variable If  '${prefix}'=='${EMPTY}'     ${timestamp}      ${prefix} ${timestamp}
    ${length}=      Get Length      ${name}
    # The search does not work if the name is too long. Cut characters to fit the timestamp. The timestamp takes 16 characters.
    # For example 'Telia Palvelulaite Lenovo ThinkPad L460 i5-6200U / 14" FHD / 8GB / 256SSD / W10P Opportunity <timestamp>' is too long
    ${name}=        Set Variable If     ${length} > 100     ${name[:70]} ${timestamp}   ${name}
    [Return]        ${name}

Get Date From Future
    [Documentation]    Returns current date (format: day.month.year, e.g. 28.6.2020) + x days,
    ...                where x = ${days} given as argument
    [Arguments]    ${days}
    ${date}=    Get Current Date
    ${date_in_future}=    Add Time To Date    ${date}    ${days} days
    ${converted_date}=    Convert Date    ${date_in_future}    result_format=datetime
    ${converted_date}=    Set Variable    ${converted_date.day}.${converted_date.month}.${converted_date.year}
    [Return]    ${converted_date}

Get Date With Dashes
    [Arguments]    ${days}
    ${date}=    Get Current Date
    ${date_in_future}=    Add Time To Date    ${date}    ${days} days
    ${converted_date}=    Convert Date    ${date_in_future}      result_format=%d-%m-%Y
    [Return]    ${converted_date}

Get Current Date In Verbal Format
    ${current_date}=     Evaluate   time.strftime("%a, %B %#d, %Y.", time.localtime())     time
    [Return]    ${current_date}

Logout From All Systems
    [Documentation]     General logout keyword for test teardowns
    ${salesforce_open}=     Run Keyword And Return Status       Location Should Contain     salesforce.com
    Run Keyword If      ${salesforce_open}      Run Keyword and Ignore Error    Close Tabs And Logout   # Salesforce
    ${mube_open}=           Run Keyword And Return Status       Location Should Contain     replicator-mnt.stadi.sonera.fi/
    Run Keyword If      ${mube_open}            Run Keyword and Ignore Error    MUBE Logout CRM         # MultiBella

Logout From All Systems and Close Browser
    Logout From All Systems
    Close Browser

Open Browser And Go To Login Page
    [Arguments]     ${page}=${LOGIN_PAGE}
    Run Keyword If      '${BEHIND_PROXY}'=='True'     Open Browser And Go To Login Page (Proxy)     ${page}
    ...     ELSE        Open Browser        ${page}       ${BROWSER}
    # Run Keyword If      '${BEHIND_PROXY}'=='True'   Set Window Size     ${1920}     ${1080}
    # ...     ELSE        Maximize Browser Window
    Maximize Browser Window

Open Browser And Go To Login Page (Proxy)
    [Arguments]     ${page}=${LOGIN_PAGE}
    ${profile}=    Evaluate    selenium.webdriver.firefox.firefox_profile.FirefoxProfile(profile_directory="/home/jenkins/.mozilla/firefox/al34m1vz.default")    selenium
    ${proxy}=    Evaluate    sys.modules['selenium.webdriver'].Proxy()    sys, selenium.webdriver
    ${proxy.https_proxy}=    Set Variable    ${PROXY}
    Create Webdriver    ${BROWSER}    proxy=${proxy}    firefox_profile=${profile}
    Go To    ${page}

Press Enter On
    [Arguments]     ${locator}
    Press Key       ${locator}      \\13

Press ESC On
    [Arguments]     ${locator}
    Press Key       ${locator}      \\27

Press Tab On
    [Arguments]     ${locator}
    Press Key       ${locator}      \\9

Prolonged Input Text
    [Arguments]    ${locator}    ${text}    ${speed}=1.3 seconds
    [Documentation]    Setting input in crm with fast speed causes random special chars to appear in the input field.
    ...    We try to fix this by slowing selenium down when inputing text.
    ...    We return speed to normal after the text has been inputed.
    Run Keyword With Delay      ${speed}    Input Text      ${locator}      ${text}

Run Keyword With Delay
    [Arguments]     ${speed}    ${keyword}      @{args}
    ${old_speed_value}=    Set Selenium Speed    ${speed}
    ${ret}=     Run Keyword    ${keyword}    @{args}
    [Teardown]    Set Selenium Speed    ${old_speed_value}
    [Return]        ${ret}

Run Inside Iframe
    [Arguments]     ${frame}    ${keyword}      @{args}
    Wait Until Page Contains Element    ${frame}    10 seconds
    Run Keyword and Ignore Error    Select Frame    ${frame}
    ${ret}=     Run Keyword     ${keyword}      @{args}
    [Teardown]      Unselect Frame
    [Return]    ${ret}

Strip Area Code From Phone Number
    [Arguments]     ${number}
    ${stripped}=    Remove String       ${number}   +358
    [Return]    ${stripped}