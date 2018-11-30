*** Variables ***
${BROWSER}                                  Firefox
${LOGIN_PAGE}                               https://test.salesforce.com/
${TEST_ENVIRONMENT}                         merge
${B2B_DIGISALES_LIGHT_USER}                 b2blight@teliacompany.com.${TEST_ENVIRONMENT}
${PASSWORD}                                 PahaPassu1
${LIGHTNING_TEST_ACCOUNT}                   Ambea Oy
${CLASSIC_MENU}                             //*[@id="userNav"]
${SWITCH_TO_LIGHTNING}                      //a[@title='Switch to Lightning Experience']
${LIGHTNING_ICON}                           //img[@class='icon noicon']
${SEARCH_SALESFORCE}                        //*[@title='Search Salesforce' or @title='Search Opportunities and more']
${TABLE_HEADER}                             //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//a
${TABS_OPENED}                              //*[@class='tabBarItems slds-grid']
${NEW_ITEM_POPUP}                           //div[@class='modal-container slds-modal__container']
${SAVE_OPPORTUNITY}                         //div[@class='modal-container slds-modal__container']//div[@class='modal-footer slds-modal__footer']//span[contains(text(),'Save')]//parent::button
${SUCCESS_MESSAGE}                         //div[@class='forceVisualMessageQueue']//div[@class='toastContainer slds-notify_container slds-is-relative']
${OPPORTUNITY_NAME}                         TestOpportunity
${ACCOUNT_RELATED}                         //span[text()='Related']//parent::a
${RELATED_OPPORTUNITY}                     //*[@class='primaryField']
${OPPORTUNITYNAME_TAB}                     //*[@id='primaryField']
${OPPORTUNITIES_SECTION}                   //li//span[text()='Opportunities']
${SEARCH_INPUT}                            //input[@name='search-input']
${RESULTS_TABLE}                            //table[contains(@class,'uiVirtualDataTable')]//tbody//tr//th//a
${SALES_CONSOLE_MENU}                       //*[@title='Show Navigation Menu']
${CONTACTS}                                 //*[@id='navMenuList']/div/ul/li[3]/div/a/span[1]/lightning-icon
${OPPORTUNITIES}                            //*[@id="navMenuList"]/div/ul/li[4]/div/a
${HOME}                                     //*[@id="oneHeader"]/div[3]/div/div[1]/div[2]/a
${SELECT_LIST_VIEW}                         //*[@id="navMenuList"]/div/ul/li[4]/div/a
${NEW_CONTACT}                              //*[@id='split-left']/div/div/div/div/div[1]/div[1]/div[2]/ul/li[1]/a/div
${CONTACT_ACCOUNTNAME}                      Aktia Fondbolag Ab
${CONTACT_FIRSTNAME}                        TESTFIVE
${CONTACT_LASTNAME}                         CONTACTFIVE
${CONTACT_EMAIL}                            noreply@teliasonera.com
${CONTACT_MOBILE}                            +3588881235
${MOBILE_NUM}                               //input[@class=' input' and @type='tel']
${FIRST_NAME}                               //input[@placeholder='First Name']
${LAST_NAME}                                //input[@placeholder='Last Name']
${ACCOUNT_NAME}                             //input[@title='Search Accounts']
${PRIMARY_EMAIL}                            //input[@type='email']
${SAVE_BUTTON}                              //button[@title="Save"]
${CONTACT_INFO}                             //span[text()='Contact Information']
${CONTACT_DETAILS}                          //section[@class='tabs__content active uiTab']
