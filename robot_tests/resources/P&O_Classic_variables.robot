*** Variables ***
${CLASSIC_APP}    https://telia-fi--devpo.my.salesforce.com
${DECOMPOSE_ORDER}    //td[@id='topButtonRow']//input[@title='Decompose Order']
${ORCHESTRATE_PLAN}    //*[contains(text(),'Start Orchestration Plan')]
${VIEW_BUTTON}    //button[contains(text(),'View')]
${CREATE_ORDER}    //span[text()='Create Order']
${CPQ_BUTTON}     //div[@title='CPQ']
${B2B_DIGISALES_USER_DEVPO}    b2bdigi@teliacompany.com.devpo
${PASSWORD_DEVPO}    PahaPassu3
${DEFAULT_TEST_ACCOUNT}    Aacon Oy
${MAIN_WINDOW}    ${EMPTY}
${NEXT_BUTTON}    //button/span[text()='Next']
${technical_contact}    John Doe
${ADD_CART}       //button[contains(text(),'Add to Cart')]
${SETTINGS}       //button[@title='Settings']
${SPINNER_SMALL}    //div[contains(@class,'small button-spinner')]
${X_BUTTON}       //span[contains(text(),'Close')]/..
${DEVPO_ACCOUNT}    Betonimestarit Oy
${LOGIN_PAGE}     https://test.salesforce.com/
${SALES_CLASSIC_USER}    b2bdigi@teliacompany.com.devpo
${PASSWORD_SALES_CLASSIC}    PahaPassu3
${SALES_HOME_PAGE}    //a[@class='switch-to-lightning']
${SALES_CONSOLE_HOME_PAGE}    https://cs85.salesforce.com/home/home.jsp?source=lex
${SEARCH_FIELD_SALES}    //input[@id='phSearchInput']
${SEARCH_BUTTON_SALES}    //input[@id='phSearchButton']
${CREATE_OPPORTUNITY_SALES}    //span[@id='createNewLabel']
${OPPORTUNITY_DROPDOWN}    //a[@class='opportunityMru menuButtonMenuLink']
${RECORD_TYPE_TEXT}    //label[text()='Record Type of new record']
${RECORDTYPE_DROPDOWN}    //table[@class='detailList']//select[@id='p3']
${CONTINUE_BUTTON_RECORD_TYPE}    //input[@title='Continue']
${OPPORTUNITY_NAME_FIELD}    //label[text()='Opportunity Name']/../..//input[@name='opp3']
${DESCRIPTION_FIELD}    //label[text()='Description']/../..//textarea[@name='opp14']
${STAGE_DROPDOWN}    //label[text()='Stage']/../..//select[@name='opp11']
${CLOSE_DATE}     //label[text()='Close Date']/../..//input[contains(@onfocus,'DatePicker')]
${CLOSE_DATE_YEAR}    //select[@title='Year']
${CLOSE_DATE_MONTH}    //select[@title='Month']
${PRICE_LIST_FIELD}    //label[text()='Price List']/../..//input[@type='text']
${SAVE_BUTTON_BOTTOM}    //div[@class='pbBottomButtons']//input[@title='Save']
${ADD_TO_CART}    //button[contains(text(),'Add to Cart')]
${SETTINGS_BTN}    //button[@title='Settings']
${Asiakkaan_verkkotunnus_field}    //input[@name='productconfig_field_1_1']
${Käyttäjä_lisätieto_field}    //input[@name='productconfig_field_1_3']
${Linkittyvä_tuote_field}    //input[@name='productconfig_field_1_4']
${Sisäinen_kommentti_field}    //input[@name='productconfig_field_1_5']
${Finnish_Domain_Service_Add_To_Cart}    //div[contains(text(),'Finnish Domain Name') and not(contains(text(),'Finnish Domain Name Registrant'))]/../../..//button[contains(text(),'Add to Cart')]
${Finnish_Domain_Service_Settings_Icon}    //div[contains(text(),'Finnish Domain Name') and not(contains(text(),'Finnish Domain Name Registrant'))]/../../..//*[@alt='settings']/..
${Verkotunnus_Field}    //select[@name='productconfig_field_0_0']
${Verkotunnus_option}    //select[contains(@name,'productconfig_field_0_0')]//option[text()='.FI']
${Voimassaoloaika_Field}    //select[contains(@name,'productconfig_field_0_1')]
${Voimassaoloaika_option}    //select[contains(@name,'productconfig_field_0_1')]//option[text()='5']
${DNS_PRIMARY}    //div[contains(text(),'DNS Primary')]/../../..//button[contains(text(),'Add to Cart')]
${NEXT_BUTTON_CART}    //span[text()='Next']
${NEXT_BUTTON_UPDATE_PRODUCT}    //div[contains(@class,'cancel')]/..//button[contains(text(),'Next')]
${OPEN_QUOTE_BTN}    //button[@id='Open Quote']
${CPQ_BTN}        //td[@id='topButtonRow']//input[@value=' CPQ ']
${CREATE_ORDER_BTN}    //span[text()='Create Order']
${VIEW_BUTTON_PO}    //button[@title='View']
${DECOMPOSE_ORDER}    //td[@id='topButtonRow']//input[@title='Decompose Order']
${START_ORCHESTRATION_PLAN}    //span[text()='Start Orchestration Plan']
${NEXT_BUTTON_CART_PAGE}    //button[contains(@class,'slds-button')]/span[text()='Next']
${OPEN_QUOTE_BUTTON}    //button[@id='Open Quote']
${CLOSE_BUTTON_SETTINGS_TAB}    //button[@class='slds-button slds-button--icon']
${SEARCH_BUTTON_ACCOUNT}    //div[@id='ExtractAccount']
${CHECKBOX_ACCOUNT}    //div[text()='Betonimestarit Oy']/../..//label//span[@class='slds-checkbox--faux']
${NEXT_BUTTON_ACCOUNT_SEARCH}    //div[@id='SearchAccount_nextBtn']
${CONTACT_NAME_FIELD}    //input[@id='ContactName2']
${NEXT_BUTTON_SELECTCONTACT}    //div[@id='SelectOrderLevelContacts_nextBtn']
${REQUESTED_ACTION_DATE}    //input[@id='RequestedActionDate']
${CHOOSE_DATE_ONE}    //table//tr[@id='week-0']//span[@tabindex='0' and text()='01']
${ADDITIONAL_DATA_NEXT_BTN}    //div[@id='Additional data_nextBtn']
${NEXT_MONTH_ARROW}    //button[@title='Next Month']
${CHECKBOX_SELECT_OWNER}    //div[contains(text(),'Betonimestarit') and contains(text(),'Billing')]/../..//label//input
${BUYER_IS_PAYER}    //input[@id='BuyerIsPayer']
${SELECT_BUYER_NEXT_BUTTON}    //div[@id='SelectedBuyerAccount_nextBtn']
${SUBMIT_ORDER_BUTTON}    //div[@id='DecomposeOrder']
${ORCHESTRATION_PLAN_IMAGE}    //h1[text()='Orchestration Plan']/../img[@alt='Orchestration Plan']
${CPQ_BUTTON_CREATE_OPPORTUNITY}    //div[@id='customButtonMuttonButton']/span[text()='CPQ']
${CREATE_OPPORTUNITY_NAME_FIELD}    //input[@id='opp3']
${CREATE_OPPORTUNITY_DESCRIPTION}    //textarea[@id='opp14']
${CREATE_OPPORTUNITY_STAGE}    //select[@id='opp11']
${CREATE_OPPORTUNITY_STAGE_SELECTION}    //select[@id='opp11']/option[@value='Analyse Prospect']
${CREATE_OPPORTUNITY_DATE}    //input[@id='opp9']
${CREATE_OPPORTUNITY_PRICE_LIST}    //span/input[@id='CF00N5800000DyL67']
${EDIT_BUTTON}    //input[@title='Edit']
${CONTACT_FIELD}    //input[@id='CF00N5800000CZNtx']
${CONTACT_LOOKUP}    //img[@alt='Contact Lookup (New Window)']
${SHOW_ALL_RESULTS_BUTTON}    //a[text()='Show all results']
${SELECT_CONTACT_NAME}    //tr[@class='dataRow even last first']//a
${SALES_ADMIN_USER_DEVPO}    saleadm@teliacompany.com.devpo
${CHILD_SETTINGS}    //div[@ng-if='!importedScope.isProvisioningStatusDeleted(childProd, attrs.provisioningStatus)']//button[@title='Settings']
${Telia_Arkkitehti_jatkuva_palvelu}    01u6E000003TtYXQA0
${Muut_asiantuntijapalvelut}    01u6E000003TwOCQA0
${Telia_Projektijohtaminen_jatkuva_palvelu}    01u6E000003TvEUQA0
${Telia_Projektijohtaminen_varallaolo_ja_matkustus}    01u6E000003TvEZQA0
${Telia_Konsultointi_jatkuva_palvelu}    01u6E000003TvEAQA0
${Telia_Konsultointi_varallaolo_ja_matkustus}    01u6E000003TvEKQA0
${Telia_Palvelunhallintakeskus}    01u6E000003TvFfQAK
${Avainasiakaspalvelukeskus kertapalvelu}    01u6E000004jyzbQAA
${Avainasiakaspalvelukeskus_varallaolo_ja_matkustus}    01u6E000003TvFzQAK
${Avainasiakaspalvelukeskus_lisätyöt_jatkuva_palvelu}    01u6E000003TvGJQA0
${TELIA_VPN_NNI}    01u6E000004z9cgQAA
${TELIA_VPN_ACCESS}    01u6E000004z9dPQAQ
${Avainasiakaspalvelukeskus}    01u6E000004kuWgQAI
${Avainasiakaspalvelukeskus jatkuva palvelu}    01u6E000003TvFpQAK
${Telia Crowd Insights}    01u6E000003U0Z8QAK
${Telia Robotics}    01u6E000003U0SHQA0
${Telia Sign}     01u6E000004kKZ7QAM
${CHILD_SETTINGS_new}    //div[contains(@ng-show,'childProd')][contains(text(),'Kilometrikorvaus')]/../../..//button[@title='Show Actions']
