*** Variables ***
${BROWSER}                                  Firefox
${LOGIN_PAGE}                               https://test.salesforce.com/
${ENVIRONMENT_CONSOLE}                      rel
${B2B_DIGISALES_LIGHT_USER}                 b2blight@teliacompany.com.${ENVIRONMENT_CONSOLE}
${PASSWORDCONSOLE}                          PahaPassu3
${LIGHTNING_TEST_ACCOUNT}                   Aacon Oy
${CLASSIC_MENU}                             //*[@id="userNav"]
${SWITCH_TO_LIGHTNING}                      //a[@title='Switch to Lightning Experience']
${LIGHTNING_ICON}                           //img[@class='icon noicon']
${SEARCH_SALESFORCE}                        //*[@data-aura-class="forceSearchInputEntitySelector"]/..//input[contains(@placeholder,"Search")]
#//*[@title='Search Salesforce' or @title='Search Opportunities and more']
${TABLE_HEADER}                             //div[@data-aura-class='forceSearchResultsRegion']//div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//a
${TABS_OPENED}                              //*[@class='tabBarItems slds-grid']
${NEW_ITEM_POPUP}                           //div[@class='modal-container slds-modal__container']
${SAVE_OPPORTUNITY}                         //div[@class='modal-container slds-modal__container']//div[@class='modal-footer slds-modal__footer']//span[contains(text(),'Save')]//parent::button
${SUCCESS_MESSAGE}                          //div[@class='forceVisualMessageQueue']//div[@class='toastContainer slds-notify_container slds-is-relative']

#New Opportunity
#${OPPORTUNITY_NAME}                        TestOpportunity1
${ACCOUNT_RELATED}                         //span[text()='Related']//parent::a
#${RELATED_OPPORTUNITY}                     //*[@class='primaryField']
${RELATED_OPPORTUNITY}                      //tbody
${OPPORTUNITYNAME_TAB}                     //*[contains(@class,'slds-page-header')]
${OPPORTUNITIES_SECTION}                   //li//span[text()='Opportunities']
${SEARCH_INPUT}                            //input[contains(@name,'search-input')]
${RESULTS_TABLE}                            //table[contains(@class,'uiVirtualDataTable')]//tbody//tr//th//a
${SALES_CONSOLE_MENU}                       //*[@title='Show Navigation Menu']
${CONTACTS}                                 //div[@class="slds-context-bar__primary navLeft"]//span//span[text()="Contacts"]
#//*[@id='navMenuList']/div/ul/li[3]/div/a/span[1]/lightning-icon
${OPPORTUNITIES}                            //*[@id="navMenuList"]//a[@title='Opportunities']
${HOME}                                     //*[@id="navMenuList"]//a[@title='Home']
${SELECT_LIST_VIEW}                         //*[@id="navMenuList"]/div/ul/li[4]/div/a
${NEW_CONTACT}                              //*[@id='split-left']/div/div/div/div/div[1]/div[1]/div[2]/ul/li[1]/a/div

#NEW CONTACT - MASTER
${CONTACT_ACCOUNTNAME}                      Aacon Oy
#${CONTACT_FIRSTNAME}                        TEST1
#${CONTACT_LASTNAME}                         CONTACT1
#${CONTACT_EMAIL}                            master1@email.com
${CONTACT_MOBILE}                            +358222222222
${MOBILE_NUM}                               //input[@class=' input' and @type='tel']
${FIRST_NAME_FIELD}                         //input[@placeholder='First Name']
${LAST_NAME_FIELD}                          //input[@placeholder='Last Name']
${ACCOUNT_NAME}                             //input[@title='Search Accounts']
${PRIMARY_EMAIL}                            //input[@type='email']
${SAVE_BUTTON}                              //button[@title="Save"]
${CONTACT_INFO}                             //span[text()='Contact Information']
${CONTACT_DETAILS}                          //section[@class='tabs__content active uiTab']

#NEW CONTACT - Non-person
${NP_CONTACT_ACCOUNTNAME}                   Aktia Fondbolag Ab
#${NP_CONTACT_FIRSTNAME}                     NPTEST5
#${NP_CONTACT_LASTNAME}                      NPCONTACT5
#${NP_CONTACT_EMAIL}                         nptest5@email.com
${NP_CONTACT_MOBILE}                        +358333333333

#NEW CONTACT FROM ACCOUNTS PAGE
${AP_CONTACT_ACCOUNTNAME}                   Aktia Fondbolag Ab
${AP_NEW_CONTACT}                           //div[@title="New Contact"]
#${AP_CONTACT_FIRSTNAME}                     APTEST10
#${AP_CONTACT_LASTNAME}                      APCONTACT10
#${AP_CONTACT_EMAIL}                         aptest10@email.com
${AP_CONTACT_MOBILE}                        +358444444444

${APP_LAUNCHER}                             //*[contains(@class,'slds-icon-waffle')]
#//button[contains(@class,'salesforceIdentityAppLauncherHeader')]
${SALES_CONSOLE_LINK}                       //*[@id="visibleDescription_07p58000000POLIAA4"]
${SALES_APP_NAME}                           //*[contains(@class,'appName')]//span[text()='Sales Console']
${ACCOUNTS}                                 //span[text()="Accounts"]
${SEARCH_CONTACTS}                          //*[@title='Search Contacts and more']
${AP_SAVE_BUTTON}                           //div[@class='modal-container slds-modal__container']//div[@class='modal-footer slds-modal__footer']//span[contains(text(),'Save')]
${AP_MOBILE_NUM}                            //span[contains(text(),'Mobile')]/../following-sibling::input[@class=" input" and @type="tel"]
#${AP_TEL_NUM}                               //input[@class=' input' and @type='tel']
${AP_SAVE_BUTTON}                           //div[@class="modal-footer slds-modal__footer"]//span[contains(text(),"Save")]
