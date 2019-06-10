*** Settings ***
Library           SeleniumLibrary

*** Test Cases ***
handle
    Open Browser    http://thawing-shelf-73260.herokuapp.com/listexpenses     ff
    input text    //*[@id='login']    defg
    Input Password    //*[@id='password']    1234
    click element    //*[@id='submit']
    sleep    10s
    Click Element    //*[@title='delete expense']
    sleep    3s
    Handle Alert
