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
${PASSIVE_TEST_ACCOUNT}                      Airmec Oy
${GROUP_TEST_ACCOUNT}                        Atria

#CONTACTS
${CONTACTS_TAB}                             //div[@class='bBottom']//a[@title='Contacts']
${CONTACTS_ICON}                            //div[@class="slds-grid"]//nav[@role="navigation"]//span[contains(text(),'Contacts')]
${NEW_BUTTON}                               //div[@class="slds-truncate" and @title="New"]
${MASTER}                                   //span[contains(text(),'Master')]
${NON-PERSON}                               //span[contains(text(),'Non-person')]
${NEXT}                                     //span[contains(text(),'Next')]
${CONTACT_INFO}                             //span[text()='Contact Information']
${MOBILE_NUM_FIELD}                         //span[contains(text(),'Mobile')]/../following-sibling::input[@type="tel"]
${FIRST_NAME_FIELD}                         //input[@placeholder='First Name']
${LAST_NAME_FIELD}                          //input[@placeholder='Last Name']
${ACCOUNT_NAME_FIELD}                       //input[@title='Search Accounts']
${MASTER_PHONE_NUM_FIELD}                   //span[contains(text(),'Phone')]/../following-sibling::input[@type="tel"]
${MASTER_PRIMARY_EMAIL_FIELD}               //span[contains(text(),'Primary eMail')]/../following-sibling::input[@type='email']
${MASTER_EMAIL_FIELD}                       //div[@id='email']
${SAVE_BUTTON}                              //div[@class="modal-footer slds-modal__footer"]//button[@title='Save']
${CONTACT_DETAILS}                          //section[@class='tabs__content active uiTab']
${DETAILS_TAB}                              //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']

${DEFAULT_EMAIL}                            d@email.com
#${MASTER_MOBILE_NUM}                        +358999888001
#${MASTER_FIRST_NAME}                        SATEST
#${MASTER_LAST_NAME}                         SACONTACT
${MASTER_ACCOUNT_NAME}                      Aktia Fondbolag Ab
${MASTER_PHONE_NUM}                         +358968372101
${MASTER_EMAIL}                             saemail@telia.com

${NP_EMAIL_FIELD}                           //input[@type='email']
${NP_ACCOUNT_NAME}                          Gavetec Oy
${NP_PHONE_NUM}                             +358968372111

${AP_ACCOUNT_NAME}                          Ambea Oy
${AP_NEW_CONTACT}                           //div[@title="New Contact"]
${AP_MOBILE_FIELD}                          //span[contains(text(),'Mobile')]/../following-sibling::input[@type="tel"]
${AP_SAVE_BUTTON}                           //div[@class="modal-footer slds-modal__footer"]//span[contains(text(),"Save")]

#OPPORTUNITY
${EDIT_STAGE_BUTTON}                        //button[@title="Edit Stage"]


#Meeting, Call, Event, Task
${NEW_EVENT_LABEL}                          //*[(text()='New Event')]
${NEW_TASK_LABEL}                           //*[(text()='New Task')]
${SUBJECT_INPUT}                            //div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[1]/div[1]/div/div/lightning-grouped-combobox/div/div/lightning-base-combobox/div/div[1]/input
${EVENT_TYPE}                               //div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[2]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/a
${subject_select_dropdown_value}            //*[@title='${Meeting}' and @class="slds-truncate"]
${subject_call_type}                        //*[@title='${customer_Call}']
${Meeting}                                  Meeting
${customer_Call}                            Customer Call
${name_input}                               Helinä Keiju
${meeting_text}                             //*[(text()='Meeting')]
${meeting_select_dropdown}                  //div/ul/li[2]/a[(text()='Meeting')]
${reason_select_dropdown}                   //div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[3]/div[1]/div/div/div/div/div/div/div/a
${reason_select_dropdown_value}             //a[(text()='Solution Design')]
${meeting_start_time}                       9:00
${meeting_end_time}                         10:00
${meeting_start_date_input}                 //div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[5]/div[1]/div/div/fieldset/div/div[1]/input
${meeting_start_time_input}                 //div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[5]/div[1]/div/div/fieldset/div/div[2]/div[1]/input
${meeting_end_date_input}                   //div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[6]/div[1]/div/div/fieldset/div/div[1]/input
${meeting_end_time_input}                   //div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[6]/div[1]/div/div/fieldset/div/div[2]/div/input
${city_input}                               //div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[8]/div[1]/div/div/div/input
${contact_name_input}                       //div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[9]/div[1]/div/div/div/div/div/div[1]/div[2]/input
${contact_name_select}                      //*[@title='${name_input}']/../../..
${start_date_form_span}                     //div[@class='slds-form-element slds-form-element_readonly slds-hint-parent']/span[text()='Start']/../div/div[@class='slds-form-element__static slds-truncate']/span
${end_date_form_span}                       //div[@class='slds-form-element slds-form-element_readonly slds-hint-parent']/span[text()='End']/../div/div[@class='slds-form-element__static slds-truncate']/span
${location_form_span}                       //div[@class='slds-form-element slds-form-element_readonly slds-hint-parent']/span[text()='Location']/../div/div[@class='slds-form-element__static slds-truncate']/span
${save_button_create}                                         //div/div[3]/div/div/div[2]/div[2]/button
${success_message_anchor}                   //*[contains(text(),'You have an upcoming Event with')]/../../../div/div/div/div[@class='primaryField slds-media__body']/div/div/a
${meeting_outcome_edit_button}              //*[text()='Meeting Outcome']/../../div[@class='slds-form-element__control slds-grid itemBody']/button
${meeting_outcome_select}                   //*[text()='Meeting Outcome']/../../div[@class='uiMenu']/div/div
${meeting_status_select}                    //*[text()='Meeting Status']/../../div[@class='uiMenu']/div/div/div
${meeting_status_value}                     //a[@title='Done']
${meeting_outcome_dropdown_value}           //div/ul/li[2]/a[@title='Positive']
${description_textarea}                     //div/div/div[@class='slds-grid slds-col slds-is-editing slds-has-flexi-truncate full forcePageBlockItem forcePageBlockItemEdit']/div/div/div/textarea
${save_button_editform}                     //*[@class='slds-button slds-button--neutral uiButton--brand uiButton forceActionButton' and @title='Save']
${description_span}                         //*[text()='Description']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span
${meeting_outocme_span}                     //*[text()='Meeting Outcome']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span
${task_name_span}                           //*[@class='slds-grid primaryFieldRow']/div[@class='slds-grid slds-col slds-has-flexi-truncate slds-media--center']/div[@class='slds-media__body']/h1[@class='slds-page-header__title slds-m-right--small slds-truncate slds-align-middle']/span[contains(text(),'Task')]
${task_subject_input}                       //div/div[1]/div[1]/div/div/lightning-grouped-combobox/div/div/lightning-base-combobox/div/div[1]/input
${name_input_task}                          //div/div[3]/div[1]/div/div/div/div/div/div[1]/div[2]/input
${save_task_button}                         //div/div[3]/div/div/div[2]/div[2]/button
${suucess_msg_task_anchor}                  //*[contains(text(),'You have an upcoming Task with')]/../../../div/div/div/div[@class='primaryField slds-media__body']/div/div/a
${TEST_ACCOUNT_CONTACT}                     Aacon Oys