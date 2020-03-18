*** Settings ***
Suite Teardown
Test Setup
Test Teardown     close browser
Resource          ..${/}resources${/}salesforce_keywords.robot
Resource          ..${/}resources${/}multibella_keywords.robot
Resource          ..${/}resources${/}uad_keywords.robot
Resource          ..${/}resources${/}tellu_keywords.robot
Resource          ..${/}resources${/}P&O_Classic_keywords.robot
Resource          ..${/}resources${/}P&O_Classic_variables.robot
Resource          ..${/}resources${/}common_variables.robot
Resource          ..${/}resources${/}common.robot

*** Test Cases ***
test for iframe
    [Tags]    iframe_test
    ${iframe}    Set Variable    //div[@class='panel-h panel resultsPanel']/iframe
    Open Browser    https://jsfiddle.net/westonruter/6mSuK/    firefox
    wait until element is visible    ${iframe}    60s
    Select Frame    ${iframe}
    Capture Page Screenshot
    unselect frame
