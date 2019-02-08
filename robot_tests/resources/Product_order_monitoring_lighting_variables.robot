*** Variables ***
${B2B_LIGHT_USER}    B2blight@teliacompany.com.release
${PASSWORD_LIGHT}    PahaPassu2
${contact_name}    John Doe
${Telia_yritysinternet}    01u58000005pgZ8AAI
${Telia_Colocation}    01u5800000fKPxxAAG
${SALEADM_PASSWORD_RELEASE}    PahaPassu3
${B2O_Other_services}    01u5800000eLeiCAAS
${SALEADM_USER_MERGE}    saleadm@teliacompany.com.merge
${Telia_yritysinternet_merge}    01u1q000001CbtVAAS

*** Keywords ***
update sales products
    [Arguments]    ${products}
    ${update_order}=    Set Variable    //h1[contains(text(),'Update Products')]
    ${product_list}=    Set Variable    //td[normalize-space(.)='${products}']
    ${next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
    ${sales_type}=    Set Variable    ${product_list} //following-sibling::td/select[contains(@class,'required')]
    log to console    UpdateAndAddSalesType
    sleep    30s
    Reload Page
    Wait Until Page Contains Element    //div[contains(@class,'slds')]/iframe    60s
    #Select Window
    Select Frame    //div[contains(@class,'slds')]/iframe
    sleep    20s
    wait until page contains element    ${product_list}    70s
    click element    ${sales_type}
    sleep    5s
    click element    ${sales_type}/option[contains(@value,'New Money-New Services')]
    sleep    10s
    click element    ${next_button}
    Unselect Frame
