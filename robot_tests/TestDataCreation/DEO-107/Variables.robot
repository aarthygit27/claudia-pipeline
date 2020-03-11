*** Variables ***
${BROWSER}        Firefox
${LOGIN_PAGE}       https://test.salesforce.com/
${LOGIN_PAGE_APP}    https://test.salesforce.com/
${ENVIRONMENT}    fesit
${B2B_DIGISALES_LIGHT_USER}    b2blight@teliacompany.com.${ENVIRONMENT}
${Password_merge}    PahaPassu3
${SYSTEM_ADMIN_USER}        autoadmin@teliacompany.com.${ENVIRONMENT}
${SYSTEM_ADMIN_PWD}          PahaPassu1
#Digia Oyj
${CLASSIC_MENU}    //*[@id="userNav"]
${SWITCH_TO_LIGHTNING}    //a[@title='Switch to Lightning Experience']
${LIGHTNING_ICON}    //img[@class='icon noicon']
${APP_SEARCH}       //div[@class="container"]//input[@type="search"]
${APP_LAUNCHER}    //nav[contains(@class,'appLauncher ')]//button
${SALES_APP_NAME}    //*[contains(@class,'appName')]//span[text()='Sales']
${SALES_APP_LINK}    //a[@class='appTileTitle' and text()='Sales']
${SALES_APP_HOME}    //a[@title='Home']
#${SEARCH_SALESFORCE}    //*[@title='Search Salesforce' or @title='Search Opportunities and more']
${SEARCH_SALESFORCE}    //*[@data-aura-class="forceSearchInputEntitySelector"]/..//input[contains(@placeholder,"Search")]
${SEARCH_RESULTS}    //div[contains(@class,'forceSearchScopesList')]//*[text()='Search Results']
${TABLE_HEADERForEvent}    //div[@class="resultsMultiWrapper"]//div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//a
${TABLE_HEADERForEvent}    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//a
${ENTITY_HEADER}    //header[@class='forceHighlightsPanel']
${Select task}       //*[@title="Start Date & Time"]
${TABLE_HEADER}    //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//following::a
${ACCOUNT_HEADER}    //header[@class='forceHighlightsPanel']
${NEW_ITEM_POPUP}    //div[@class='modal-container slds-modal__container']
${SAVE_OPPORTUNITY}    //div[@class='modal-container slds-modal__container']//div[@class='modal-footer slds-modal__footer']//span[contains(text(),'Save')]//parent::button
${ACCOUNT_RELATED}      //li[@title="Related"]//a[text()="Related"]
#${RELATED_OPPORTUNITY}    //*[@class='primaryField']
${RELATED_OPPORTUNITY}    //tbody
${OPPORTUNITY_PAGE}    //*[contains(@class,'slds-page-header')]
${RESULTS_TABLE}    //table[contains(@class,'uiVirtualDataTable')]//tbody//tr//th//a
${SEARCH_INPUT}    //input[contains(@name,'search-input')]
${PASSIVE_TEST_ACCOUNT}    Airmec Oy
${GROUP_TEST_ACCOUNT}    Abloy
#CONTACTS
${CONTACTS_TAB}    //div[@class='bBottom']//a[@title='Contacts']
#${CONTACTS_ICON}    //div[@class="slds-grid"]//nav[@role="navigation"]//span[contains(text(),'Contacts')]
${CONTACTS_ICON}    //img[@title="Contacts"]
${NEW_BUTTON}     //div[@class="slds-truncate" and @title="New"]
${MASTER}        //span[contains(text(),'Master')]/../../div/input/../span
${NEXT}           //span[contains(text(),'Next')]
${CONTACT_INFO}    //span[text()='Contact Information']
${MOBILE_NUM_FIELD}    //span[contains(text(),'Mobile')]/../following-sibling::input[@type="tel"]
${FIRST_NAME_FIELD}    //input[@placeholder='First Name']
${LAST_NAME_FIELD}    //input[@placeholder='Last Name']
${ACCOUNT_NAME_FIELD}    //input[@title='Search Accounts']
${MASTER_PHONE_NUM_FIELD}    //span[contains(text(),'Phone')]/../following-sibling::input[@type="tel"]
${MASTER_PRIMARY_EMAIL_FIELD}    //span[contains(text(),'Primary eMail')]/../following-sibling::input[@type='email']
${MASTER_EMAIL_FIELD}    //span[contains(text(),'Email')]/../following-sibling::input[@type='email']
#${SAVE_BUTTON}    //div[@class="modal-footer slds-modal__footer"]//button[@title='Save']
${SAVE_BUTTON}    //div[@class="actionsContainer"]//button[@title='Save']
${CONTACT_DETAILS}    //section[@class='tabs__content active uiTab']
${DETAILS_TAB}    //li[@title="Details"]//a[text()="Details"]
${DEFAULT_EMAIL}    d@email.com
#${MASTER_MOBILE_NUM}    +358999888001
#${MASTER_FIRST_NAME}    SATEST
#${MASTER_LAST_NAME}    SACONTACT
${MASTER_ACCOUNT_NAME}    Aktia Fondbolag Ab
${MASTER_PHONE_NUM}    +358968372101
${MASTER_EMAIL}    saemail@telia.com
${AP_ACCOUNT_NAME}    Ambea Oy
${AP_NEW_CONTACT}    //div[@title="New Contact"]
${AP_MOBILE_FIELD}    //span[contains(text(),'Mobile')]/../following-sibling::input[@type="tel"]
${AP_SAVE_BUTTON}    //div[@class="modal-footer slds-modal__footer"]//span[contains(text(),"Save")]
#OPPORTUNITY
${EDIT_STAGE_BUTTON}    //*[@title="Edit Stage"]
${SALES_ADMIN_APP_USER}    saleadm@teliacompany.com.${ENVIRONMENT}
${PASSWORD-SALESADMIN}    PahaPassu2