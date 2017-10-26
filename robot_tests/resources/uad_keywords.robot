*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}common.robot


*** Variables ***
${UAD_PAGE}                 http://ua001colossus.ddc.teliasonera.net:8082/uad_b2b/
${SEARCH_FIELD}             HEADER_SEARC_FIELD
${SEARCH_BUTTON}            HEADER_SEARC_BUTTON
${NEXT_BUTTON}              INTPAG_NEXT_BUTTON
${CLEAR_BUTTON}             HEADER_CLEAR_BUTTON
${UAD_USERNAME}             F11685
${UAD_PASSWORD}             Lr@i4P#yR
${UAD_USERNAME_FIELD}       gwt-uid-3
${UAD_PASSWORD_FIELD}       gwt-uid-5


*** Keywords ***

UAD Contact Person Should Be Found
    [Arguments]     ${pages}
    :FOR   ${i}  IN RANGE   ${pages}
    \   ${customer_found}=      Run Keyword And Return Status       Page Should Contain Element         //div[text()='${TEST_CONTACT_PERSON_LAST_NAME}']
    \   Run Keyword If      ${customer_found}   Exit For Loop
    \   UAD Click Next Button
    Run Keyword Unless      ${customer_found}       FAIL    ${TEST_CONTACT_PERSON_LAST_NAME} not found in MIT.

UAD Click Next Button
    # Clicking the element with Javascript works, but not with Click Element, because why not?
    Execute Javascript      document.getElementById("${NEXT_BUTTON}").click();
    # Click Element       ${NEXT_BUTTON}
    Sleep       0.5       The page needs a moment to reload

UAD Go to Main Page
    Go To               ${UAD_PAGE}
    UAD Page Should Be Open

UAD Go to Page And Log in
    Go To               ${UAD_PAGE}
    UAD Log In

UAD Log in
    Wait Until Page Contains Element    ${UAD_USERNAME_FIELD}      10s
    Input Text          ${UAD_USERNAME_FIELD}   ${UAD_USERNAME}
    Input password      ${UAD_PASSWORD_FIELD}   ${UAD_PASSWORD}
    Click Element       //span[text()='Kirjaudu sisään']
    Wait Until Page Contains Element    ${SEARCH_FIELD}     10s

UAD Open Browser And Go To Login Page
    Open Browser    ${UAD_PAGE}
    Maximize Browser Window

UAD Page Should Be Open
    Wait Until Page Contains Element        ${SEARCH_FIELD}

UAD Search for Customer
    [Arguments]         ${customer_id}
    Click Element       ${CLEAR_BUTTON}
    Wait Until Page Contains Element        FIRST_INFO_TITLE
    Click Element       ${SEARCH_FIELD}
    Sleep               0.5
    Input Text          ${SEARCH_FIELD}     ${customer_id}
    Sleep               0.5
    Click Element       ${SEARCH_BUTTON}
    ${search_failed}=   Run Keyword And Return Status       Page Should Contain Element        //h1[text()='Hakuarvo puuttuu']
    Run Keyword If      ${search_failed}    FAIL
    Wait Until Page Contains Element        //span[@class='v-captiontext' and text()='${customer_id}']

UAD Select Correct Tab
    [Arguments]         ${tab_name}
    ${element_visible}=      Run Keyword And Return Status          Element Should Be Visible       //div[text()='${tab_name}']
    Run Keyword If      not ${element_visible}    Click Element     //button[@class='v-tabsheet-scrollerNext']
    Click Element       //div[text()='${tab_name}']

UAD Verify That Contact Person Is Found For Customer
    [Arguments]         ${customer_id}
    UAD Search for Customer     ${customer_id}
    Wait Until Keyword Succeeds     10s     1s      UAD Select Correct Tab      Yritystiedot
    # We need to get the amount of pages in UAD so we don't try to press next a million times.
    Wait Until Page Contains Element    //div[contains(@class,'v-label-paging-range-displayer')]    10s
    ${range}=     Get Text    //div[contains(@class,'v-label-paging-range-displayer')]
    ${total_contacts}=    Get Regexp Matches    ${range}    \\(\\ (.*)\\ \\)      1     # Get the total amount of contact persons
    ${pages}=   Evaluate    @{total_contacts}[0] / 10   # 10 results per page
    UAD Contact Person Should Be Found      ${pages}
