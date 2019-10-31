*** Variables ***
${Multiservice NNI}    01u2600000Oy08YAAR
${Telia Ethernet Operator Subscription}    01u2600000OxiUNAAZ
${Ethernet Nordic Network Bridge}    01u2600000Ooy3jAAB
${Ethernet Nordic E-Line EPL}    01u2600000Ooy3eAAB
${Ethernet Nordic E-LAN EVP-LAN}    01u2600000Owhg2AAB
${Ethernet Nordic HUB/E-NNI}    01u2600000Ooy4NAAR
${Telia Ethernet subscription}    01u2600000Oy7hWAAR
${Telia Colocation}    01u5800000fKPwuAAG
${setting}        //button[@title='Settings']
${telia Robotics}    01u2600000Q4FybAAF
${Telia Crowd Insights}    01u2600000Q4E4MAAV
${Telia_Viestintäpalvelu_VIP}    01u58000005pgLrAAI    # Telia Viestintäpalvelu VIP
${Yritysinternet Plus}    01u58000005pgVpAAI
${DataNet Multi}    01u58000005pgURAAY
${Telia Ulkoistettu asiakaspalvelu}    01u58000005pgeSAAQ
${Telia Neuvottelupalvelut}    01u58000005pgSfAAI
${Telia Palvelunumero}    01u58000005pvIuAAI
${Telia Yritysliittymä}    01u58000005pgcWAAQ
${Telia Laskutuspalvelu}    01u58000005pgL3AAI
${Telia Sopiva Enterprise}    01u58000005pgUDAAY
${Telia Ulkoistettu asiakaspalvelu - Lisäkirjaus}    01u58000006Z4IRAA0
${Telia Neuvottelupalvelut - Lisäkirjaus}    01u58000006Z4IbAAK
${Telia Palvelunumero - Lisäkirjaus}    01u58000006Z4IqAAK
${Telia Yritysliittymä - Lisäkirjaus}    01u58000006Z4JAAA0
${Telia Laskutuspalvelu - Lisäkirjaus}    01u58000006Z4JUAA0
${Telia Sopiva Enterprise - Lisäkirjaus}    01u58000006Z4JeAAK
${Sopiva Pro-migraatio}    01u58000005pgUFAAY
${Sovelluskauppa 3rd Party Apps}    01u58000005pgeDAAQ
${VIP:n käytössä olevat Cid-numerot}    01u58000005pvIkAAI
${Ohjaus Telia Numeropalveluun}    01u58000005pgPzAAI
${Online Asiantuntijapalvelut}    01u58000005pgPjAAI
${PASSWORD_SALESADMIN_SITPO}    PahaPassu6
${SALES_ADMIN_SITPO}    saleadm@teliacompany.com.sitpo
${Telia Sign}     01u2600000Q4Is6AAF
#${SETTINGS}   //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/div/span[text()='${pname}']//following::button[3]
${X_BUTTON}       //span[contains(text(),'Close')]/..
${CHILD_SETTINGS}    //div[@ng-if='!importedScope.isProvisioningStatusDeleted(childProd, attrs.provisioningStatus)']//button[@title='Settings']
${SPINNER_SMALL}    //div[contains(@class,'small button-spinner')]
${sales_type}    set variable    //select[@ng-model='p.SalesType']
${CPQ_next_button}=    Set Variable    //button[contains(@class,'form-control')][contains(text(),'Next')]
${account_name}=    Set Variable    //p[contains(text(),'Search')]
${account_checkbox}=    Set Variable    //td[@class='slds-cell-shrink']//span[@class='slds-checkbox--faux']
${search_account_next_button}=    Set Variable    //div[@id='SearchAccount_nextBtn']//p[@class='ng-binding'][contains(text(),'Next')]
${technical_contact}    John Doe
${group_billing_id}    SALES FORCE TEST 2
${test_account}        Aacon Oy
${Hinnoitteluperuste}    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Hinnoitteluperuste']]//following::select[1]
${Henkilötyöaika}      //form[@name='productconfig']//following::label[text()[normalize-space() = 'Henkilötyöaika']]//following::input[1]
${Palveluaika}    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Palveluaika']]//following::select[1]
${Laskuttaminen}   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Laskuttaminen']]//following::select[1]
${Työtilaus vaadittu}    //form[@name='productconfig']//span[@class='slds-form-element__label'][contains(text(),'Työtilaus vaadittu')]
${Laskutettava_toimenpide}    //textarea[@name='productconfig_field_0_0']
${Kustannus}     //input[@name='productconfig_field_0_1']
${Kilometrikorvaus}   //div[contains(text(),'Kilometrikorvaus')]/../../../div/button[contains(@class,'slds-button slds-button_neutral')]
#${Kilometrit}=    set variable    //input[contains(@class,'ng-valid')][@value='0']
${Kilometrit}   //form[@name='productconfig']//following::label[text()[normalize-space() = 'Kilometrit']]//following::input[1]
${BROWSER}        Firefox

${Password_merge}    PahaPassu1
${LOGIN_PAGE}        https://test.salesforce.com/
${SALES_APP_NAME}    //*[contains(@class,'appName')]//span[text()='Sales']
${CLOSE_NOTIFICATION}    //button[@title='Dismiss notification']
${LIGHTNING_ICON}    //img[@class='icon noicon']
${B2B_DIGISALES_LIGHT_USER}    b2blight@teliacompany.com.${ENVIRONMENT}
${ENVIRONMENT}    release
${SALES_APP_HOME}    //a[@title='Home']
${APP_LAUNCHER}    //button[contains(@class,'salesforceIdentityAppLauncherHeader')]
${SALES_APP_NAME}    //*[contains(@class,'appName')]//span[text()='Sales']
${SALES_APP_LINK}    //a[@class='appTileTitle' and text()='Sales']
${SALES_APP_HOME}    //a[@title='Home']
${SEARCH_SALESFORCE}    //*[@data-aura-class="forceSearchInputEntitySelector"]/..//input[contains(@placeholder,"Search")]
${SEARCH_RESULTS}    //div[contains(@class,'forceSearchScopesList')]//*[text()='Search Results']
${TABLE_HEADERForEvent}    //div[@class="resultsMultiWrapper"]//div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//a
#//div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//a
${ENTITY_HEADER}    //header[@class='forceHighlightsPanel']
${Select task}       //*[@title="Start Date & Time"]
${TABLE_HEADER}    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a
${ACCOUNT_HEADER}    //header[@class='forceHighlightsPanel']
${NEW_ITEM_POPUP}    //div[@class='modal-container slds-modal__container']
${SAVE_OPPORTUNITY}    //div[@class='modal-container slds-modal__container']//div[@class='modal-footer slds-modal__footer']//span[contains(text(),'Save')]//parent::button
${ACCOUNT_RELATED}      //div[contains(@class,'active')]//span[text()='Related']//parent::a
#${RELATED_OPPORTUNITY}    //*[@class='primaryField']
${RELATED_OPPORTUNITY}    //tbody
${OPPORTUNITY_PAGE}    //*[contains(@class,'slds-page-header')]
${RESULTS_TABLE}    //table[contains(@class,'uiVirtualDataTable')]//tbody//tr//th//a
${SEARCH_INPUT}    //input[contains(@name,'search-input')]