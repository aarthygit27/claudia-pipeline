*** Variables ***

${TELLU_USERNAME}           sjx9846
${TELLU_PASSWORD}           salakka
${TELLU_SERVER}             http://kovalainen.stadi.sonera.fi:8081/portal
${TELLU_USERNAME_FIELD}     name=j_username
${TELLU_PASSWORD_FIELD}     name=j_password
${TELLU_CONTACT_PERSON_SEARCH_BUTTON}    name=ButtonGroup1#Button0
${TELLU_SEARCH_RESULT_PAGE_HEADER}    //h1
${TELLU_CONTACT_PERSON_LINK}    //a[.='Contact Persons']
${TELLU_EDIT_CONTACT_PERSON_PAGE_TITLE}    title=Contact Person Editor - CRM
${TELLU_RESET_ALL_SEARCH_FIELDS_BUTTON}    id=ButtonGroup1_Button3
${TELLU_SHOW_ONLY_CONTACT_PERSON_WITH_SALES_ROLE_CHECKBOX}    id=BooleanChoice1_checkbox
${TELLU_CONTACT_PERSON_SELECT_ALL_BUTTON}    id=RadioButtons0_1
${TELLU_CONTACT_PERSON_LAST_NAME_FIELD}    id=InputText10
${TELLU_BUSINESS_ID_FIELD}    id=InputText6
${TELLU_CREATE_NEW_CONTACT_PERSON_BUTTON}    id=ButtonGroup0_Button1
${TELLU_STREETNAME_FIELD}    id=StreetName
${TELLU_POSTAL_CODE_FIELD}    id=PostalCode
${TELLU_CITY_CODE_FIELD}    id=City
${TELLU_COUNTRY_CODE_FIELD}    id=Country
${TELLU_FIRST_NAME_FIELD}    id=FirstName
${TELLU_LAST_NAME_FIELD}    id=LastName
${TELLU_MOBILE_AS_DEFAULT_CHECKBOX}    id=Checkbox0_checkbox
${TELLU_EMAIL_AS_DEFAULT_CHECKBOX}    id=Checkbox1_checkbox
${TELLU_BUSINESS_CARD_TITLE_FIELD}    id=InputText10
${TELLU_EMAIL_FIELD}    id=PrimaryEmail
${TELLU_PHONE_FIELD}    id=InputText5
${TELLU_LANGUAGE_SELECT}    id=InputText8
${TELLU_SALES_ROLE_SELECT}    id=Label5
${TELLU_ADDRESS_TYPE_SELECT}    id=AddressType
${TELLU_ADDRESS_ADDITIONAL_INFO_FIELD}    id=InputText33
${TELLU_PO_BOX_NUMNBER_FIELD}    id=PoBoxNumber
${TELLU_PREFERRED_CONTACT_CHANNEL_SELECT}    id=InputText20
${TELLU_OFFICIAL_NAME_FIELD}    id=InputText16
${TELLU_GENDER_SELECT}    id=InputText18
${TELLU_UPDATE_CONTACT_PERSON_BUTTON}    id=ButtonGroup0_Button2
${TELLU_EDIT_CONTACT_PERSON_BUTTON}     xpath=(//img[@type='image'])[2]
${TELLU_ADD_HOBBY_SELECTIONS_BUTTON}    id=DualList1_top
${TELLU_FIRST_ELEMENT_IN_HOBBY_LIST_SELECTION}    id=DualList1From
${TELLU_LOG_OUT_LINK}    //a[contains(text(),'Log Off')]
${TELLU_CONTACT_PERSON_RESULT_LAST_NAME_FIELD}    id=TableCelllastName0_0
${TELLU_REFRESH_SEARCH_BUTTON}    id=ButtonGroup2_Button1