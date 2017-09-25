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
${TELLU_CONTACT_PERSON_SELECT_ALL_BUTTON}    xpath=id('RadioButtons0_1')
${TELLU_CONTACT_PERSON_LAST_NAME_FIELD}    id=InputText10