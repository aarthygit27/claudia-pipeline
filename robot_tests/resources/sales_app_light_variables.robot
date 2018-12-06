*** Variables ***
${BROWSER}                                  Firefox
${LOGIN_PAGE}                               https://test.salesforce.com/
${TEST_ENVIRONMENT}                         merge
${B2B_DIGISALES_LIGHT_USER}                 b2blight@teliacompany.com.${TEST_ENVIRONMENT}
${PASSWORD}                                 PahaPassu1
${LIGHTNING_TEST_ACCOUNT}                   Carend Oy
${CLASSIC_MENU}                             //*[@id="userNav"]
${SWITCH_TO_LIGHTNING}                      //a[@title='Switch to Lightning Experience']
${LIGHTNING_ICON}                           //img[@class='icon noicon']
${APP_LAUNCHER}                             //button[contains(@class,'salesforceIdentityAppLauncherHeader')]
${SALES_APP_NAME}                           //*[contains(@class,'appName')]//span[text()='Sales']
${SALES_APP_LINK}                           //a[@class='appTileTitle' and text()='Sales']
${SALES_APP_HOME}                           //a[@title='Home']
#${SEARCH_SALESFORCE}                        //*[@title='Search Salesforce' or @title='Search Opportunities and more']
${SEARCH_SALESFORCE}                        //*[@data-aura-class="forceSearchInputEntitySelector"]/..//input[contains(@placeholder,"Search")]
${SEARCH_RESULTS}                           //div[contains(@class,'forceSearchScopesList')]//*[text()='Search Results']
${TABLE_HEADER}                             //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//a
${ACCOUNT_HEADER}                           //header[@class='forceHighlightsPanel']
${OPPORTUNITY_NAME}                         TestOpportunity3
${NEW_ITEM_POPUP}                           //div[@class='modal-container slds-modal__container']
${SAVE_OPPORTUNITY}                         //div[@class='modal-container slds-modal__container']//div[@class='modal-footer slds-modal__footer']//span[contains(text(),'Save')]//parent::button
${ACCOUNT_RELATED}                          //div[contains(@class,'active')]//span[text()='Related']//parent::a
${RELATED_OPPORTUNITY}                      //*[@class='primaryField']
${OPPORTUNITY_PAGE}                         //*[contains(@class,'slds-page-header')]
${RESULTS_TABLE}                            //table[contains(@class,'uiVirtualDataTable')]//tbody//tr//th//a
${SEARCH_INPUT}                             //input[@name='search-input']

#CONTACTS
${CONTACTS_TAB}                             //div[@class='bBottom']//a[@title='Contacts']
${CONTACTS_ICON}                            //div[@class="slds-grid"]//nav[@role="navigation"]//span[contains(text(),'Contacts')]
${NEW_BUTTON}                               //div[@class="slds-truncate" and @title="New"]
${MASTER}                                   //span[contains(text(),'Master')]
${NEXT}                                     //span[contains(text(),'Next')]
${CONTACT_INFO}                             //span[text()='Contact Information']
${MASTER_MOBILE_NUM_FIELD}                  //span[contains(text(),'Mobile')]/../following-sibling::input[@type="tel"]
${MASTER_FIRST_NAME_FIELD}                  //input[@placeholder='First Name']
${MASTER_LAST_NAME_FIELD}                   //input[@placeholder='Last Name']
${ACCOUNT_NAME_FIELD}                       //input[@title='Search Accounts']
${MASTER_PHONE_NUM_FIELD}                   //span[contains(text(),'Phone')]/../following-sibling::input[@type="tel"]
${MASTER_PRIMARY_EMAIL_FIELD}               //span[contains(text(),'Primary eMail')]/../following-sibling::input[@type='email']
${MASTER_EMAIL_FIELD}                       //div[@id='email']
${SAVE_BUTTON}                              //button[@title='Save']
${CONTACT_DETAILS}                          //section[@class='tabs__content active uiTab']

${MASTER_MOBILE_NUM_VALUE}                  +358999888001
${MASTER_FIRST_NAME_VALUE}                  SATEST
${MASTER_LAST_NAME_VALUE}                   SACONTACT
${ACCOUNT_NAME_VALUE}                       Aktia Fondbolag Ab
${MASTER_PHONE_NUM_VALUE}                   +358968372101
${MASTER_PRIMARY_EMAIL_VALUE}               saprimary@telia.com
${MASTER_EMAIL_VALUE}                       saemail@telia.com
