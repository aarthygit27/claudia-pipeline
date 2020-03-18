*** settings ***
Library     Selenium2Library



*** Variables ***
${UAD_USERNAME}     F11685
${UAD_PASSWORD}     Wonder25
${SEARCH_FIELD}     HEADER_SEARC_FIELD


*** keywords ***
Login To UAD
    Open Browser    url=http://ua001colossus.ddc.teliasonera.net:8082/uad_b2b/    browser=ff
    Wait Until Page Contains Element    xpath=//input[@type='text']    timeout=10seconds
    Input Text       xpath=//input[@type='text']                  ${UAD_USERNAME}
    Set Log Level    level=NONE
    Input Text       xpath=//input[contains(@type,'password')]    ${UAD_PASSWORD}
    Set Log Level    level=DEBUG
    Click Element    xpath=//div[contains(@role,'button')]
    # Sleep    10 seconds
    Wait Until Page Contains Element    ${SEARCH_FIELD}     20s
    Capture Page Screenshot
    Close Browser

*** test cases ***
Login test
    Login To UAD