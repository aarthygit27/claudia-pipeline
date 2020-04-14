*** Variables ***
${BROWSER}        Firefox
${LOGIN_PAGE_APP}    https://test.salesforce.com/
${ENVIRONMENT}    rel
${B2B_DIGISALES_LIGHT_USER}    b2blight@teliacompany.com.${ENVIRONMENT}
${Password_merge}    PahaPassu2
${SYSTEM_ADMIN_USER}        autoadmin@teliacompany.com.${ENVIRONMENT}
${SYSTEM_ADMIN_PWD}          PahaPassu1
${PM_User}  pm@teliacompany.com.${ENVIRONMENT}
${PM_PW}  PahaPassu1
${B2O_PM_User}   b2opmauto@teliacompany.com.${ENVIRONMENT}
${B2O_Approver_User}  b2oapproverauto@teliacompany.com.${ENVIRONMENT}
${B2O_PM_PW}   PahaPassu1
${B2O_Approver_PW}  PahaPassu1
${Endorser_User}  endorser@teliacompany.com.${ENVIRONMENT}
${Endorser_PW}  PahaPassu1
${Approver_User}  approver@teliacompany.com.${ENVIRONMENT}
${Approver_PW}  PahaPassu3
${LIGHTNING_TEST_ACCOUNT}     Telia Communication Oy
${vLocUpg_TEST_ACCOUNT}    Aarsleff Oy
${CONTRACT_ACCOUNT}     Telia Communication Oy
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
${NON-PERSON}     //span[contains(text(),'Non-person')]/../../div/input/../span
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
${DEFAULT_NAME}    TEST


#${MASTER_MOBILE_NUM}    +358999888001
#${MASTER_FIRST_NAME}    SATEST
#${MASTER_LAST_NAME}    SACONTACT
${MASTER_ACCOUNT_NAME}    Aktia Fondbolag Ab
${MASTER_PHONE_NUM}    +358968372101
${MASTER_EMAIL}    saemail@telia.com
${NP_EMAIL_FIELD}    //input[@type='email']
${NP_ACCOUNT_NAME}    Aktia Fondbolag Ab
${NP_PHONE_NUM}    +358968372111
${AP_ACCOUNT_NAME}    Ambea Oy
${AP_NEW_CONTACT}    //div[@title="New Contact"]
${AP_MOBILE_FIELD}    //span[contains(text(),'Mobile')]/../following-sibling::input[@type="tel"]
${AP_SAVE_BUTTON}    //div[@class="modal-footer slds-modal__footer"]//span[contains(text(),"Save")]
#OPPORTUNITY
${EDIT_STAGE_BUTTON}    //*[@title="Edit Stage"]
#Meeting, Call, Event, Task
${NEW_EVENT_LABEL}    //*[(text()='New Event')]/..
${NEW_TASK_LABEL}    //*[(text()='New Task')]
${SUBJECT_INPUT}    //*[text()='Subject']/../div/div/lightning-base-combobox/div/div/input
#//label[text()='Subject']//following::input[@class='slds-input slds-combobox__input']
#//div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[1]/div[1]/div/div/lightning-grouped-combobox/div/div/lightning-base-combobox/div/div[1]/input
${EVENT_TYPE}     //*[text()='Event Type']/..//following::div/div/div/div/a
#//div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[2]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/a
${subject_select_dropdown_value}    //*[@title='${Meeting}' and @class="slds-truncate"]
${subject_call_type}    //*[@title='${customer_Call}']
${Meeting}        Meeting
${customer_Call}    Customer Call
${meeting_text}    //*[(text()='Meeting')]
#${meeting_select_dropdown}    //div/ul/li[2]/a[(text()='Meeting')]
${meeting_select_dropdown}      //a[contains(text(),"Meeting")]
${reason_select_dropdown}    //*[text()='Reason']/..//following::div/div/div/div/a
${reason_select_dropdown_value}    //a[(text()='Solution Design')]
${meeting_start_time}    9:00
${meeting_end_time}    10:00
#${meeting_start_date_input}    //div/div[5]/div[1]/div/div/fieldset/div/div[1]/label//following-sibling::input
${meeting_start_date_input}    //legend[contains(text(),"Start")]//following::input[@class="slds-input"]
#${meeting_start_time_input}    //div/div[5]/div[1]/div/div/fieldset/div/div[2]/div/label//following-sibling::input
${meeting_start_time_input}     //legend[contains(text(),"Start")]//following::input[@class="slds-input slds-combobox__input"]
#//div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[5]/div[1]/div/div/fieldset/div/div[2]/div[1]/input
#${meeting_end_date_input}    //*[text()='End']//following::div/div/label[text()='Date']//following-sibling::input
#//div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[6]/div[1]/div/div/fieldset/div/div[1]/input
${meeting_end_date_input}   //*[text()='End']//following::input[@class="slds-input"]
${meeting_end_time_input}   //*[text()='End']//following::input[@class="slds-input slds-combobox__input"]
#${meeting_end_time_input}    //*[text()='End']//following::div/div/label[text()='Time']//following-sibling::input
#//div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[6]/div[1]/div/div/fieldset/div/div[2]/div/input
${city_input}     //span[text()='Location']//following::input[@class=' input']
#//*[@class='label inputLabel uiLabel-left form-element__label uiLabel']//span[text()='Location']//following::input[@class=' input']
#//div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[8]/div[1]/div/div/div/input
${contact_name_input}    //*[text()='Name']//following::div/div/div[@class='inputWrapper slds-grid slds-grid_vertical-align-center slds-p-right_x-small']/div[@class='autocompleteWrapper slds-grow']/input
#//div/div[3]/div/div/div[1]/section/div/section/div/div/section/div[9]/div[1]/div/div/div/div/div/div[1]/div[2]/input
${start_date_form_span}    //div[@class='slds-form-element slds-form-element_readonly slds-hint-parent']/span[text()='Start']/../div/div[@class='slds-form-element__static slds-truncate']/span
${end_date_form_span}    //div[@class='slds-form-element slds-form-element_readonly slds-hint-parent']/span[text()='End']/../div/div[@class='slds-form-element__static slds-truncate']/span
${location_form_span}    //div[@class='slds-form-element slds-form-element_readonly slds-hint-parent']/span[text()='Location']/../div/div[@class='slds-form-element__static slds-truncate']/span
${save_button_create}    //div/div[3]/div/div/div[2]/div[2]/button
${success_message_anchor}     //*[contains(text(),'You have an upcoming event with ')]
#//*[contains(text(),'You have an upcoming Event with')]/../../../div/div/div/div[@class='primaryField slds-media__body']/div/div/a
${meeting_outcome_edit_button}    //*[text()='Meeting Outcome']/../../div[@class='slds-form-element__control slds-grid itemBody']/button
${meeting_outcome_select}    //*[text()='Meeting Outcome']/../../div[@class='uiMenu']/div/div/div/a
#//*[text()='Meeting Outcome']/../../div[@class='uiMenu']/div/div
${meeting_status_edit_button}    //*[@title='Edit Meeting Status']
${meeting_status_select}    //*[text()='Meeting Status']/../../div[@class='uiMenu']/div/div/div/a
${meeting_status_value}    //*[@title='Done']
${meeting_outcome_dropdown_value}    //a[@title='Positive']
#${description_heading}  //h3/span[text()='Description Information']
#${description_textarea}    //div/div/div[@class='slds-grid slds-col slds-is-editing slds-has-flexi-truncate full forcePageBlockItem forcePageBlockItemEdit']/div/div/div/textarea
#${description_textarea}    //button[@title='Insert quick text']/../../textarea[@class="textarea textarea uiInput uiInputTextArea uiInput--default uiInput--textarea"]
${save_button_editform}    //*[@class='slds-button slds-button--neutral uiButton--default uiButton--brand uiButton forceActionButton' and @title='Save']
${description_span}    //*[text()='Description']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span
${meeting_outocme_span}    //*[text()='Meeting Outcome']/../../div[@class='slds-form-element__control slds-grid itemBody']/span/span
${task_name_span}    //*[@class='slds-grid primaryFieldRow']/div[@class='slds-grid slds-col slds-has-flexi-truncate slds-media--center']/div[@class='slds-media__body']/h1[@class='slds-page-header__title slds-m-right--small slds-truncate slds-align-middle']/span[contains(text(),'Task')]
${task_subject_input}    //div/div[1]/div[1]/div/div/lightning-grouped-combobox/div/div/lightning-base-combobox/div/div[1]/input
${name_input_task}    //*[text()='Name']//following::div/div/div[@class='inputWrapper slds-grid slds-grid_vertical-align-center slds-p-right_x-small']/div[@class='autocompleteWrapper slds-grow']/input
${save_task_button}    //div/div[3]/div/div/div[2]/div[2]/button
${suucess_msg_task_anchor}    //div[contains(text(),'You have an upcoming Task with')]
#//*[contains(text(),'You have an upcoming Task with')]/../../../div/div/div/div[@class='primaryField slds-media__body']/div/div/a
${TEST_ACCOUNT_CONTACT}    Aacon Oy
${TEST_CONTACT}     Aarsleff Oy
#${contact_name_form}    //*[@class='slds-form-element__control']/div/div[@class='runtime_sales_activitiesManyWhoName']/div/div/a
${related_to}     //span[@class='data-social-photo-guid-0c81cbe7-ad99-4592-a537-f11c4b51aaee photoContainer forceSocialPhoto_v2 forceOutputLookup']/../a[text()]
${contact_name_form}    //span[@class="title"]//following::div[@class="runtime_sales_activitiesManyWhoName"]
${DEFAULT_CITY}    HELSINKI
#CPQ
${CPQ_BUTTON}     //a[@title='CPQ']
${SHOPPING_CART}    //li[@title='Cart']
${CPQ_SEARCH_FIELD}    //div[contains(@class,'cpq-searchbox')]//input
#Contacts-Attribute
${BUSINESS_CARD_FIELD}    //span[text()='Business Card Title']/ancestor::label/../input
${STATUS}         //div[contains(@class,'modal-body')]//*[text()='Status']/parent::span/../div//a
${STATUS_ACTIVE}    //a[@title='Active']
${PREFERRED_CONTACT_CHANNEL}    //div[contains(@class,'modal-body')]//*[text()='Preferred Contact Channel']/parent::span/../div//a
${PREFERRED_CONTACT_CHANNEL_LETTER}    //a[@title='Letter']
${GENDER}         //div[contains(@class,'modal-body')]//*[text()='Gender']/parent::span/../div//a
${GENDER_MALE}    //a[@title='1 - male']
${COMMUNICATION_LANGUAGE}    //div[contains(@class,'modal-body')]//*[text()='Communication Language']/parent::span/../div//a
${COMMUNICATION_LANG_ENGLISH}    //a[@title='English']
${LAST_CONTACTED_DATE}    //div[contains(@class,'modal-body')]//span[text()='Last Contacted Date']/parent::div/..//span[@class='uiOutputDate']
${SALES_ROLE}     //div[contains(@class,'modal-body')]//*[text()='Sales Role']/parent::span/../div//a
${SALES_ROLE_BUSINESS_CONTACT}    //a[@title='Business Contact']
${JOB_TITLE_CODE}    //div[contains(@class,'modal-body')]//*[text()='Job Title Code']/parent::span/../div//a
${JOB_TITLE_CODE_NAME}    //a[@title='verojohtaja - 8715']
${OFFICE_NAME_FIELD}    //span[text()='Office Name']/ancestor::label/../input
${MONTH_TEXT}     //h2[@class='monthYear']
${NEXT_BUTTON_MONTH}    //a[@title='Go to next month']
${YEAR_DROPDOWN}    //select[contains(@class,'slds-select')]
${DETAILS}    //div[@class='tabset slds-tabs_card uiTabset--base uiTabset--default uiTabset--dense uiTabset flexipageTabset']//a[@title='Details']
${DATE_PICKER}    //span[text()='Date Picker']/..
${EMAIL_ID_FIELD}    //span[contains(text(),'Email')]/../following-sibling::input[@type='email']
#//div[@id='email']//input
${MASTER_PHONE_NUM_FIELD}    //span[contains(text(),'Phone')]/../following-sibling::input[@type="tel"]
${MASTER_MOBILE_NUM_FIELD}    //span[contains(text(),'Mobile')]/../following-sibling::input[@type="tel"]
${OFFICE_NAME}    My Office
${BUSINESS_CARD}    My Card
${STATUS_TEXT}    Active
${PREFERRED_CONTACT}    Letter
${COMMUNICATION_LANG}    English
${year}           1992
${to_select_month}    JANUARY
${month_digit}    1
${day}            12
${gender}         1 - male
${sales_role_text}    Business Contact
${job_title_text}    verojohtaja - 8715
${SYSTEM_ADMIN_USER}        autoadmin@teliacompany.com.${ENVIRONMENT}
${SYSTEM_ADMIN_PWD}          PahaPassu2
${SALES_ADMIN_APP_USER}    saleadm@teliacompany.com.${ENVIRONMENT}
${PASSWORD-SALESADMIN}    PahaPassu2
${Credit_control_user}     creditcontrol@teliacompany.com.${ENVIRONMENT}
${Credit_control_password}  PahaPassu1
${REMOVE_ACCOUNT}    GESB Integration
${ownername}      //div//p[text()="Account Owner"]/..//a
${ACCOUNT_OWNER}    Sales Admin
${ACCOUNT_LIST}    //a[@data-refid='recordId']/../../parent::tr
${ACCOUNT_NAME}    (//tr//a[@data-refid='recordId'])
${ACCOUNTS_LINK}    //div[@class='bBottom']//span[text()='Accounts']
${CHANGE_OWNER}   //button[@title='Change Owner']
${SEARCH_PEOPLE}  //*[contains(text(),"Change Account Owner")]//following::input[@title="Search People"]
#${OWNER_NAME}    //div[contains(@class,'primaryLabel')]
${CHANGE_OWNER_BUTTON}    //button[text()='Change Owner']
#//button[@title='Cancel']/following-sibling::button
#${CHANGE_OWNER_BUTTON}    //button[@title='Change Owner']
${SEARCH_OWNER}    //input[@title='Search People']
${OWNER_NAME}     //div[@class='ownerName']//a
${NEW_OWNER_SELECTED}    //span[@class='pillText']
${CLOSE_NOTIFICATION}    //button[@title='Dismiss notification']
${SALES_ADMIN_USER_RELEASE}    saleadm@teliacompany.com.release
#### SVE,B2B,B2,HDC Orders
${r}              b2b
${p}              b2o
${product_name}    Telia Robotics
${product_quantity}    1
${NRC}            35
${RC}             50000
${ARC}    10
${B2bproductfyr1}    Telia Sopiva Pro N
${B2bproductfyr2}   Pro Nettikortti
${B2bproductfyr3}   Multi-SIM
${fixed_charge for_Telia Sopiva Pro N}  30
${fixed_charge for_Pro Nettikortti}     0
${fixed_charge for_Multi-SIM}           0
${sales_type_value1}   New Money-New Services
${sales_type_value2}   New Money-Extending Services
${sales_type_value3}   Renegotiation-Service Replacement
${sales_type_value4}   Renegotiation-Service Continuation
${sales_type_value5}   Frame Agreement - New Services
${sales_type_value6}   Frame Agreement - Extending Services
${sales_type_value7}   Frame Agreement - Renegotiation
${contract_lenght}    12
${HDC_Total_KW}     5000
${HDC_Rack_Amount}   1000
${360_VIEW}     //li//a[text()='360 View']
${AVAILABILITY_CHECK_BUTTON}        //button[@onclick="OpenAddressValidation();"]
${DEFAULT_ADDRESS}      Korpijärventie 3
${ADDRESS_VALIDATION_DROPDOWN}      //ul[@class='typeahead dropdown-menu ng-scope am-fade bottom-left']/li/a[text()='${DEFAULT_ADDRESS}']
${PRODUCT_CHECKBOX}     //*[@id="Product List"]/div/ng-include/div/table/tbody/tr[7]/td[1]/label/input/../span
${NEW_OPPORTUNITY_RADIOBUTTON}     //span[text()='New Opportunity']/../input[@id='CreateOrUpdateRadio']/../span
${B2O_DIGISALES_LIGHT_USER}     network@teliacompany.com.${ENVIRONMENT}
${B2O_DIGISALES_LIGHT_PASSWORD}    PahaPassu3
${B2O_PRODUCT_CHECKBOX}     //*[@id="Product List"]/div/ng-include/div/table/tbody/tr[18]/td[1]/label/input/../span
${EXISTING_OPPORTUNITY_RADIOBUTTON}     //span[text()='Existing Opportunity']/../input[@id='CreateOrUpdateRadio']/../span
${EXISTING_OPPORTUNITY_TEXT_FIELD}      //input[@id='TypeAheadOpp']
${OPPORTUNITY_WARNING_BANNER}   //div[@class="slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_info cContractStatusToasts"]//h2[text()='Note! Selected Account does not have an active customership contract, please conclude an agreement with the customer before accepting orders for the Account.']
${SERVICE_CONTRACT_WARNING}     //div/div/small[text()='Selected Account does not have an active service contract for one or more of the selected offerings. A draft agreement and service contract has been automatically created for each of the offerings']
${SERVICE_CONTRACT_WARNING_oppo}     //div//*[text()='Note! Selected Account does not have an active service contract for one or more of the selected offerings, please conclude a service agreement with the customer before accepting orders from the Account.']
${STATUS_DRAFT_ELEMENT}     //span[text()='Status']/../../div[2]/span/span[text()='Draft']
${SALES_TYPE_DROPDOWN}      //table[@class='tg']/tbody//tr[2]/td[8]/select
${NEW_MONEY_NEW_SERVICES}   //table[@class='tg']/tbody//tr[2]/td[8]/select/option[@value='New Money-New Services']
${CPQ_CART_NEXT_BUTTON}      //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']
${QUOTE_DETAILS_TAB}    //*[@id="brandBand_1"]/div/div[1]/div[4]/div[1]/div/div[3]/div[1]/div/div/div/ul/li[2]/a
${B2O Account}      Digita Oy
${Pricing Comments}   Pricing Comments Testing
${Ebit Value}  20
${B2B_Contract_Length}  125
${B2O_Contract_Length}   185
${B2B_Max_contract_len}  120
${B2O_Max_contract_len}  180
${table_row}        //div[@class='slds-col slds-no-space forceListViewManagerPrimaryDisplayManager']//tr//a[contains(@class,'rowActionsPlaceHolder ')]
${test_opportunity}     //table/tbody/tr/td/span/span[text()='Analyse Prospect']/../../../th/span/a[contains(text(), TestOpportunity)]
${externalphoneno}       +3589888
${externaltitle}    MR
${externaleMail}    externalemail@email.com
${externalofficename}    ExternalOffice
${ulmid}    ULMID
${externalid}      EXternalID
${RemoveAccountOwner}       Aacon Oy
${noitems}       //div[@class='emptyContent']//p[text()='No items to display.']
${businessAccount}      Aacon Oy
${groupAccount}      Aacon Oy
${errorpopup}     //div[@class()='modal-container slds-modal__container']
${errorok}      //button[@title='OK']
${editgtmapprovalrequest}      //button[@title="Edit GTM Approval Request Justification"]
${gtmapprovaljustification}       //Span[text()='GTM Approval Request Justification']/../following-sibling::textarea
${gtmsave}        //div[@class="footer active"]//button[@title="Save"]
${moreactionslink}      //a[contains(@title, 'more actions')][1]
${submitgtmapproval}      //div/div[@role="menu"]//a[@title="Submit for HDC GTM Approval"][1]/..
${pendingapproval}     //span[text()='Pending Approval']
${approvedstatus}      //span[text()='GTM Pricing Approval Status']/..//following-sibling::div//span[text()='Approved']
${mobilecoveragerequest}      //a[@title='Mobile Coverage Request']
${showmoreactions}    //a[@title='Show 9 more actions']
${manualavailabilitycheck}      //a[@title='Manual Availability Check']
${investment}       //a[@title='Investment']
${remindmelater}       //a[text()='Remind Me Later']
${Additional_Details}    //span[text()="Additional Details"]
${HDC Total}     //span[text()="HDC Total KW"]
${HDC Total KW_investment}  //div//div//span[text()="Investment ID"]//following::div[8]//span[text()="HDC Total KW"]
${HDC Rack Amount_investment}     //div//div//span[text()="Investment ID"]//following::div[16]//span[text()="HDC Rack Amount"]
${Edit HDC Rack Amount}    //div//div//span[text()="Investment ID"]//following::div[16]//button[@title="Edit HDC Rack Amount"]
${Edit HDC Total KW}     //div//div//span[text()="Investment ID"]//following::button[@title="Edit HDC Total KW"]
${input_HDC_Total_KW}    //div//input[@name="HDC_Total_KW__c"]
${input_HDC_Rack_Amount}      //input[@name="HDC_Rack_Amount__c"]
${System Information}    //span[text()="System Information"]
${Migration}   //label//span[text()="Is Migration"]
${Save_OPPO}    //button[@title="Save"]
${iframe}   //div[contains(@class,'slds')]/iframe
${contractLength_Sve}   //input[@type="number"][@ng-model="p.ContractLength"]
${contract_lenght_updated}    24
${Internet Domain_Toggle}   //span[text()='Internet Domain']/../button
${Finnish Domain Name Registrant}   //div[contains(text(),'Finnish Domain Name Registrant Agreement(without Maintenance)')]//following::div[15]//button[1]
${Finnish_Domain_Service_Add_To_Cart}     //div[contains(text(),'Finnish Domain Name') and not(contains(text(),'Finnish Domain Name Registrant'))]/../../..//button[contains(text(),'Add to Cart')]
${Finnish_Domain_Service_Settings_Icon}       //div[contains(text(),'Finnish Domain Name') and not(contains(text(),'Finnish Domain Name Registrant'))]/../../..//*[@alt='settings']/..
${Verkotunnus_Field}    //select[@name='productconfig_field_0_0']
${Verkotunnus_option}      //select[contains(@name,'productconfig_field_0_0')]//option[@value=".fi"]
${Voimassaoloaika_Field}      //select[contains(@name,'productconfig_field_0_1')]
${Voimassaoloaika_option}      //select[contains(@name,'productconfig_field_0_1')]//option[text()='5']
${closing}       //*[@alt='close'][contains(@size,'large')]
${Annual Recurring charge_finish_time}    //div[@class="slds-is-relative"]//div[@ng-if="customField.type === 'currency'"]//span/span
${Monthly recurring chage_finish_time}  //div[@class="slds-grid slds-nowrap cpq-total-card"]/div[1]/div[2]
${one time_charge_finish_doamin}    //div[@class="slds-grid slds-nowrap cpq-total-card"]/div[3]/div[2]
${Child_product_Dns_finish doamin}     //button[@class="slds-button cpq-item-has-children"]
${Child_product_Dns_finish doamin_child}  //div[@class="cpq-item-child-product-name-wrapper"]//button[@class="slds-button cpq-item-has-children"]
${quote_number}   //div/span[@title="Quote Number"]
${Recurring Total(Exc. Reporting)}      //span[text()="Recurring Total(Exc. Reporting)"]
${Asiakkaan verkkotunnus}     //form[@name='productconfig']//label[text()[normalize-space() = 'Asiakkaan verkkotunnus (muotoa domain.pääte)']]/..//div//input
${Linkittyvä tuote}   //form[@name='productconfig']//label[text()[normalize-space() = 'Linkittyvä tuote']]/..//div//input
${Save_sve}   //button[contains(text(),"Save")]
### Lead  Variables ###

${lead_account_name}                Academic Work HR Services Oy
${lead_business_id}                2733621-7
${lead_email}                       kasibhotla.sreeramachandramurthy@teliacompany.com
${convert_lead_btn}                 //div[@title='Convert Lead']
${converting_lead_header}           //div[text()='Converting Lead']
${lead_name_input}                  //div[@class="slds-text-title_caps"]//following-sibling::input
${lead_desc_textarea}               //div[@class="slds-text-title_caps"]//following-sibling::textarea
${lead_close_date}                  //input[@class="field input"]
${converting_lead_dialogue}          //div[@class="convertSection"][text()='Converting Lead']
${converting_lead_overlay}           //button[text()='Convert Lead']
${lead_converted_h4}                //h4[text()='Lead Converted']
${group_id}         SALES FORCE TEST 1
#Changes for each account
${billing_acc_name_comm1}    Billing Telia Communication Oy_001
${billing_acc_name_digi1}   Billing_Digita Oy_2961
@{List}=  Telia chat  Telia Robotics   Telia colocation   Telia ACE   DataNet  Telia IOT Office  Telia Yhteyspiste
${a} =  0
${b} =  0
${c} =  0
#Order Page
${pdtname}   Telia Domain Name Service
${Order_Related_Tab}        //li[@class="tabs__item active uiTabItem"]//a//span[text()="Related"]
${Order_Products_Tab}    //div[@class="slds-media__body"]//a//span[text()="Order Products"]
${Order_Products_Related_Tab}   //span[contains(.,'Related')]
${Order_Products_Assets_Tab}   //div[@class="slds-media__body"]//a//span[text()="Assets"]
${Order_Products_Select}      //th/span/a[@title='${pdtname}']
${Order_Products_SubID}   //th//span/a[text()='${pdtname}']/following::td[3]

#Account Page
${Account_Asset_History}    //button//span[text()='Asset History']
${Account_Asset_iframe}   //button/span[text()='Asset History']/../../..//div[@class="content iframe-parent"]/iframe
${Account_Asset_TechnicalContact}   //table[@class='tb']//tr[19]//td[text()='Technical Contact']/following::td[1]

#DNS CPQ Page
${Asiakkaan verkkotunnus}     //form[@name='productconfig']//label[text()[normalize-space() = 'Asiakkaan verkkotunnus (muotoa domain.pääte)']]/..//div//input
${Linkittyvä tuote}      //form[@name='productconfig']//label[text()[normalize-space() = 'Linkittyvä tuote']]/..//div//input
${DNS_Setting}        //div[@id='tab-default-1']/div/ng-include/div/div/div/div[3]/div/div/div/span[text()='${pdtname}']//following::button[@title='Settings']
${Setting_Close}   //*[@alt='close'][contains(@size,'large')]
${Page_iframe}    //div[contains(@class,'slds')]/iframe
${CPQ_Next_Button}    //button[@class='slds-button slds-m-left_large slds-button_brand']/span[text()='Next']

#DNS Technical Page
${Technical_contact_search}    //input[@id='TechnicalContactTA']
${contact_search}   //input[@id='OrderContactTA']
${contact_email}    //input[@id='OCEmail']
${Technical_contact_email}    //input[@id='TCEmail']
${contact_next_button}   //div[@id='SelectOrderLevelContacts_nextBtn']
${updateContactDR}    //button[@class='slds-button slds-button--neutral ng-binding ng-scope'][@ng-click='nextRepeater(child.nextIndex, child.indexInParent)']
${Main_User}     //input[@id="MainContactTA"]
${City}     Helsiniki
${FirstName}    //input[@id="MCFname"]
${LastName}    //input[@id="MCLname"]
${EmailID}    //input[@id="MCEmail"]
${MobileNumber}     //input[@id="MCMobile"]
${Street}     //input[@id="MCStreet"]
${Postal_codes}     //input[@id="MCPostalCode"]
${city_Name}     //input[@id="MCCity"]
${Communication}    //select[@id="MCLanguage"]
${DNS_communication_language_english}      //select[@id="MCLanguage"]//*[@value="English"]

#VULA CPQ Psge
${Nopeus}    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Nopeus']]//following::select[1]
${Asennuskohde}    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Asennuskohde']]//following::select[1]
${Toimitustapa}    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Toimitustapa']]//following::select[1]
${VLAN}     //form[@name='productconfig']//following::label[text()[normalize-space() = 'VLAN']]//following::input[1]
${VULA NNI}    //form[@name='productconfig']//following::label[text()[normalize-space() = 'VULA NNI']]//following::input[1]
${Yhteyshenkilön nimi}     //form[@name='productconfig']//following::label[text()[normalize-space() = 'Yhteyshenkilön nimi']]//following::input[1]
${Yhteyshenkilön puhelinnumero}    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Yhteyshenkilön puhelinnumero']]//following::input[1]
${Katuosoite}    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Katuosoite']]//following::input[1]
${Katuosoite numero}    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Katuosoite numero']]//following::input[1]
${Postinumero}    //form[@name='productconfig']//following::label[text()[normalize-space() = 'Postinumero']]//following::input[1]
${Postitoimipaikka}      //form[@name='productconfig']//following::label[text()[normalize-space() = 'Postitoimipaikka']]//following::input[1]

#CreditScorePage
${return_opportunity_button}    //button[@id="Return to Opportunity"]

#Opportunity Page
${MarkStageasComplete_button}    //span[contains(text(),"Mark Stage as Complete")]
${Oppo_Related_Tab}    //a[@id="relatedListsTab__item"]
${Oppo_Product_panel}  	//h1[contains(.,'Product')]
${Product_viewall_button} 	//button[contains(.,'View All')]
