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
${SEARCH_SALESFORCE}                        //*[@title='Search Salesforce' or @title='Search Opportunities and more']
${SEARCH_RESULTS}                           //div[contains(@class,'forceSearchScopesList')]//*[text()='Search Results']
${TABLE_HEADER}                             //div[@data-aura-class='forceInlineEditGrid']//tbody//tr//th//a
${ACCOUNT_HEADER}                           //header[@class='forceHighlightsPanel']
${OPPORTUNITY_NAME}                         TestOpportunity1
${NEW_ITEM_POPUP}                           //div[@class='modal-container slds-modal__container']
${SAVE_OPPORTUNITY}                         //div[@class='modal-container slds-modal__container']//div[@class='modal-footer slds-modal__footer']//span[contains(text(),'Save')]//parent::button
${ACCOUNT_RELATED}                          //div[contains(@class,'active')]//span[text()='Related']//parent::a
${RELATED_OPPORTUNITY}                      //*[@class='primaryField']


