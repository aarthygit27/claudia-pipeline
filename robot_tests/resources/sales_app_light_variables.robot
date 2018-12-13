*** Variables ***
${BROWSER}                                  Firefox
${LOGIN_PAGE}                               https://test.salesforce.com/
${TEST_ENVIRONMENT}                         merge
${B2B_DIGISALES_LIGHT_USER}                 b2blight@teliacompany.com.${TEST_ENVIRONMENT}
${PASSWORD}                                 PahaPassu1
${LIGHTNING_TEST_ACCOUNT}                   AKK Sports Oy
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
${TABLE_HEADER}                             //div[@class="resultsMultiWrapper"]//div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//a
#//div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//a
${ENTITY_HEADER}                            //header[@class='forceHighlightsPanel']
${OPPORTUNITY_NAME}                         TestOpportunity3
${TABLE_HEADER}                             //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//a
${ACCOUNT_HEADER}                           //header[@class='forceHighlightsPanel']
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
${NON-PERSON}                               //span[contains(text(),'Non-person')]
${NEXT}                                     //span[contains(text(),'Next')]
${CONTACT_INFO}                             //span[text()='Contact Information']
${MASTER_MOBILE_NUM_FIELD}                  //span[contains(text(),'Mobile')]/../following-sibling::input[@type="tel"]
${MASTER_FIRST_NAME_FIELD}                  //input[@placeholder='First Name']
${MASTER_LAST_NAME_FIELD}                   //input[@placeholder='Last Name']
${ACCOUNT_NAME_FIELD}                       //input[@title='Search Accounts']
${MASTER_PHONE_NUM_FIELD}                   //span[contains(text(),'Phone')]/../following-sibling::input[@type="tel"]
${MASTER_PRIMARY_EMAIL_FIELD}               //span[contains(text(),'Primary eMail')]/../following-sibling::input[@type='email']
${MASTER_EMAIL_FIELD}                       //div[@id='email']
${SAVE_BUTTON}                              //div[@class="modal-footer slds-modal__footer"]//button[@title='Save']
${CONTACT_DETAILS}                          //section[@class='tabs__content active uiTab']

${DEFAULT_EMAIL}                            d@email.com
#${MASTER_MOBILE_NUM}                        +358999888001
#${MASTER_FIRST_NAME}                        SATEST
#${MASTER_LAST_NAME}                         SACONTACT
${MASTER_ACCOUNT_NAME}                      Aktia Fondbolag Ab
${MASTER_PHONE_NUM}                         +358968372101
#${MASTER_PRIMARY_EMAIL}                     saprimary@telia.com
${MASTER_EMAIL}                             saemail@telia.com

${NP_EMAIL_FIELD}                           //input[@type='email']
#${NP_MOBILE_NUM}                            +358999888111
#${NP_FIRST_NAME}                            SANPTEST
#${NP_LAST_NAME}                             SANPCONTACT
${NP_ACCOUNT_NAME}                          Gavetec Oy
${NP_PHONE_NUM}                             +358968372111
#${NP_EMAIL}                                 sanpemail@telia.com

${AP_ACCOUNT_NAME}                          Ambea Oy
${AP_NEW_CONTACT}                           //div[@title="New Contact"]
#${AP_CONTACT_FIRSTNAME}                     SAAPFN
#${AP_CONTACT_LASTNAME}                      SAAPLN
#${AP_CONTACT_EMAIL}                         saap@email.com
#${AP_CONTACT_MOBILE}                        +358888123021
${AP_MOBILE_FIELD}                          //span[contains(text(),'Mobile')]/../following-sibling::input[@type="tel"]
${AP_SAVE_BUTTON}                           //div[@class="modal-footer slds-modal__footer"]//span[contains(text(),"Save")]

#OPPORTUNITY
${EDIT_STAGE_BUTTON}                        //button[@title="Edit Stage"]
${OPPORTUNITY_CANCELLED}                    //span[text()='Opportunity Status']/../following::span[text()='Cancelled']


