*** Settings ***
Library           Collections
Resource          ../../frontendsanity/resources/Common.robot
Resource          ../../frontendsanity/resources/Variables.robot

*** Keywords ***
Enter Random Data to Lead Web Form
    [Arguments]    ${fname}    ${lname}    ${email}    ${mobile}    ${title}    ${desc}
    wait until page contains element    //*[@id="00N1i000001wmJE"]    20s
    input text    //*[@id="00N1i000001wmJE"]    ${lead_business_id}
    input text    //*[@id="first_name"]    ${fname}
    input text    //*[@id="last_name"]    ${lname}
    input text    //*[@id="mobile"]    ${mobile}
    input text    //*[@id="email"]    ${email}
    input text    //*[@id="title"]    ${title}
    input text    //textarea[@name='description']    ${desc}
    input text    //*[@id="00N1i000001wmJH"]    ${email}
    click element    //*[@id="lead_source"]
    sleep    2s
    click element    //option[@value='Customer Service']
    click element    //input[@type='submit']
    sleep    3s
    #Location Should Contain    https://www.telia.fi/


Open_Todays_Leads
    sleep    3s
    wait until page contains element    //button[@class='slds-button']    30s
    click element    //button[@class='slds-button']
    wait until page contains element    //input[@placeholder="Search apps or items..."]    30s
    input text    //input[@placeholder="Search apps or items..."]    Leads
    wait until page contains element    //li/a[@title='Leads']    30s
    force click element    //li/a[@title='Leads']
    wait until page contains element    //li/span[text()='Leads']    30s
    force click element    //span[text()='Recently Viewed' and @data-aura-class='uiOutputText']
    #//a[@title="Select List View"]
    wait until page contains element    //span[text()="Today's Leads"]/..    30s
    force click element    //span[text()="Today's Leads"]/..
    wait until page contains element    //div/span[text()="Today's Leads"]    30s
    sleep    3s


validate_Created_Lead
    [Arguments]    ${fname}    ${lname}    ${email}    ${mobile}    ${title}    ${desc}
    reload page
    wait until page contains element    //span[@class='title' and text()='Details']    30s
    wait until element is enabled    //span[@class='title' and text()='Details']    30s
    click element    //span[@class='title' and text()='Details']
    wait until element is enabled    //span[@class='title' and text()='Details']    30s
    click element    //span[@class='title' and text()='Details']
    wait until page contains element    //span[text()='${fname} ${lname}']    30s
    page should contain element    //span[text()='Lead Owner']//ancestor::div[contains(@class,'form-element')]//span[text()='Lead Validation for Customer Service']
    page should contain element    //span[text()='Lead Status']//ancestor::div[contains(@class,'form-element')]//span[text()='Validate']
    page should contain element    //span[text()='Name']//ancestor::div[contains(@class,'form-element')]//span[text()='${fname} ${lname}']
    page should contain element    //span[text()='Mobile']Edit_and_Select_Contact //ancestor::div[contains(@class,'form-element')]//span[text()='${mobile}']
    page should contain element    //span[text()='Email']//ancestor::div[contains(@class,'form-element')]//span[contains(@class,'test-id')]//a[text()='${email}']
    page should contain element    //span[text()='Business ID']//ancestor::div[contains(@class,'form-element')]//span[text()='2733621-7']
    page should contain element    //span[text()='Company']//ancestor::div[contains(@class,'form-element')]//span[@class='test-id__field-value slds-form-element__static slds-grow ']/span[text()='Academic Work HR Services Oy']
    page should contain element    //span[text()='Description']//ancestor::div[contains(@class,'form-element')]//span[text()='${desc}']
    page should contain element    //span[text()='Lead Reporter Email']//ancestor::div[contains(@class,'form-element')]//span[contains(@class,'test-id')]//a[text()='${email}']



