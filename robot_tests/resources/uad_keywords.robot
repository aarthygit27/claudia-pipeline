*** Settings ***
Resource            ${PROJECTROOT}${/}resources${/}common.robot


*** Variables ***
${UAD_PAGE}         http://ua001colossus.ddc.teliasonera.net:8082/uad_b2b/
${SEARCH_FIELD}     HEADER_SEARC_FIELD
${SEARCH_BUTTON}    HEADER_SEARC_BUTTON
${NEXT_BUTTON}      INTPAG_NEXT_BUTTON
${CLEAR_BUTTON}     HEADER_CLEAR_BUTTON


*** Keywords ***

UAD Contact Person Should Be Found
    [Arguments]     ${pages}
    :FOR   ${i}  IN RANGE   ${pages}
    \   ${customer_found}=      Run Keyword And Return Status       Page Should Contain Element         //div[text()='${TEST_CONTACT_PERSON_LAST_NAME}']
    \   Run Keyword If      ${customer_found}   Exit For Loop
    \   Run Keyword Unless      ${customer_found}       UAD Click Next Button
    Run Keyword Unless      ${customer_found}       FAIL    ${TEST_CONTACT_PERSON_LAST_NAME} not found in MIT.

UAD Click Next Button
    # Clicking the element with Javascript works, but not with Click Element, because why not?
    Execute Javascript      document.getElementById("${NEXT_BUTTON}").click();
    # Click Element       ${NEXT_BUTTON}
    Sleep       0.5       The page needs a moment to reload

UAD Go to Main Page
    Go To               ${UAD_PAGE}
    UAD Page Should Be Open

UAD Page Should Be Open
    Wait Until Page Contains Element        ${SEARCH_FIELD}

UAD Search for Customer
    [Arguments]         ${customer_id}
    Click Element       ${CLEAR_BUTTON}
    Sleep               0.5
    Input Text          ${SEARCH_FIELD}     ${customer_id}
    Click Element       ${SEARCH_BUTTON}
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
    ${range}=     Get Text    //div[contains(@class,'v-label-paging-range-displayer')]
    ${total_contacts}=    Get Regexp Matches    ${range}    \\(\\ (.*)\\ \\)      1     # Get the total amount of contact persons
    ${pages}=   Evaluate    @{total_contacts}[0] / 10   # 10 results per page
    UAD Contact Person Should Be Found      ${pages}
