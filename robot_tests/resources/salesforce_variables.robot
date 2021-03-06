*** Variables ***
${BROWSER}                                  Firefox
${LOGIN_PAGE}                               https://test.salesforce.com/
${LOGIN_PAGE_merge}                         https://telia-fi--merge.my.salesforce.com/
${IFRAME}                                   //iframe
${NAVIGATORTAB}                             //li[contains(@id, 'navigatortab__scc-pt')]
${LOGOUT_BUTTON}                            //a[@title='Logout']
${LOOKUP_SEARCH_FIELD}                      id=lksrch
${LOOKUP_SEARCH_GO_BUTTON}                  //input[@title='Go!']

${RIGHT_SIDEBAR_IFRAME}                     //div[contains(@class,'x-panel')]//iframe[contains(@src,'Right')]
${LEFT_SIDEBAR_IFRAME}                      //div[contains(@class,'x-panel')]//iframe[contains(@src,'Left')]
${ACCOUNT_FRAME}                            //div[contains(@id,'scc-pt')]${IFRAME}
${OPPORTUNITY_FRAME}                        //div[contains(@id,'scc-st')]${IFRAME}

${TOP_BAR}                                  //div[contains(@class,'workspace_context')]//table
#${EXPAND_TOP_BAR}                           //div[contains(@class,'x-layout-mini x-layout-mini-north x-layout-mini-over') and not(contains(@class,'custom-logo'))]
${EXPAND_TOP_BAR}                           //div[contains(@class,'x-layout-mini x-layout-mini-north')]
${EXPAND_TOP_BAR_HOVER}                     //div[contains(@class,'x-layout-mini x-layout-mini-north x-layout-mini-over')]
#${COLLAPSE_TOP_BAR}                         //div[contains(@class,'x-layout-mini x-layout-mini-north x-layout-mini-over') and not(contains(@id,'ServiceDesk'))]
#${COLLAPSE_TOP_BAR}                          //div[contains(@class,'x-layout-split-north') and not(contains(@id,'ServiceDesk'))]
#${COLLAPSE_TOP_BAR_HOVER}                    //div[contains(@class,'x-layout-split-north') and not(contains(@id,'ServiceDesk'))]
### Credentials
#${TEST_ENVIRONMENT}                         preprod
${TEST_ENVIRONMENT}                         merge
${CUSTOMER_CARE_USER}                       custcare@teliacompany.com.${TEST_ENVIRONMENT}
${SALES_ADMIN_USER}                         saleadm@teliacompany.com.${TEST_ENVIRONMENT}
${PRODUCT_MANAGER_USER}                     prodman@teliacompany.com.${TEST_ENVIRONMENT}
${B2B_DIGISALES_USER}                       b2bdigi@teliacompany.com.${TEST_ENVIRONMENT}
${B2B_DIGISALES_MANAGER}                    digimngr@teliacompany.com.${TEST_ENVIRONMENT}
${B2O_DIGISALES_USER}                       b2ouser@teliacompany.com.preprod
${PASSWORD}                                 PahaPassu1
${PASSWORD2}                                PahaPassu1

#API Tests- APIgee Integration
${TEST_ENV}                                 test
${UAT_ENV}                                  uat


# QUICKACTIONFIELD is an invalid xpath on its own. Needs to be completed with another `]` after the variable has been put
${ACTIVETEMPLATE_FIELD}                     //div[contains(@class,'activeTemplate')]
${QUICKACTIONFIELD}                         ${ACTIVETEMPLATE_FIELD}//div[@class='quickActionFieldElements' and .//div[@class='quickActionFieldLabel']
${INPUT_OR_TEXTAREA}                        //*[(local-name()='input' or local-name()='textarea') and not(@type='hidden')]


${NEW_OPPORTUNITY_BUTTON}                   //input[contains(@title,'New Opportunity')]
${OPPORTUNITY_SAVE_BUTTON}                  //h2[contains(text(), 'Opportunity Edit')]/../following-sibling::td//input[@title='Save']
${OPPORTUNITY_CPQ_BUTTON}                   //h2[contains(text(), 'Opportunity Detail')]/../following-sibling::td//input[@title='CPQ']
${QUOTE_CPQ_BUTTON}                         //h2[contains(text(), 'Quote Detail')]/../following-sibling::td//input[@title='CPQ']
${OPPO_EDIT_TITLE}                          //h1[contains(text(),'Opportunity Edit')]

# ${OPPO_INFO_OPPO_NAME_FIELD}                //label[contains(text(), 'Opportunity Name')]/../following-sibling::*//input
# ${OPPO_INFO_STAGE_FIELD}                    //label[contains(text(), 'Stage')]/../following-sibling::*//select
${OPPO_INFO_CLOSE_DATE_FIELD}               //label[contains(text(), 'Close Date')]/../following-sibling::*//input
${CLASSIF_DESCRIPTION_FIELD}                //label[text()= 'Description' and *[@class= 'assistiveText']]/../following-sibling::*//textarea
${CLASSIF_ACCOUNT_SEARCH_BUTTON}            //label[contains(text(), 'Account Name')]/../following-sibling::*//img[@class='lookupIcon']
${CLASSIF_ACCOUNT_NAME_FILLED}              //label[contains(text(), 'Account Name')]/../following-sibling::*//input[@class='readonly']
${CLOSE_REASON_FIELD}                       //label[contains(text(),'Close Reason')]/../following-sibling::td
${CLOSE_COMMENT_FIELD}                      //label[text()='Close Comment']/../following-sibling::td

${NEW_ACCOUNT_BUTTON}                       //input[contains(@title,'New Account')]
${NEW_CONTACT_BUTTON}                       //input[contains(@title,'New Contact')]
${MORE_DROPDOWN_AT_DETAILS}                 //span[@class='optionLabel' and contains(text(), 'More')]/following-sibling::span[@class='arrowIcon']
${NEW_CONTACT_AT_MORE_DROPDOWN}             ul//span[contains(text(), 'New Contact')]
${ADD_SOLUTION_AREA_AT_DETAILS}             //span[@class='optionLabel' and text()='Add Solution Area']
${NEW_CONTACT_BUTTON_AT_DETAILS}            //span[@class= 'optionLabel' and text()= 'New Contact']
${NEW_OPPORTUNITY_BUTTON_AT_DETAILS}        //span[@class= 'optionLabel' and text()= 'New Opportunity']
${NEW_EVENT_BUTTON_AT_DETAILS}              //span[@class= 'optionLabel' and text()= 'New Event']
${NEW_OPPORTUNITY_AT_MORE_DROPDOWN}         ul//span[contains(text(), 'New Opportunity')]
${ACCOUNT_DETAILS}                          //a[@title='Details']
${FIELD_DETAIL}                             //h2[contains(text(),'Detail')]
${ACCOUNT_FEED}                             //a[@title='Feed']
${LIST_VIEW}                                //a[@title='View List']
${BOTTOM_SAVE_BUTTON}                       //td[@id='bottomButtonRow']/input[@title='Save']
${ACCOUNT_NAME_LOOKUP}                      //img[contains(@title,'Account Name')]
${EDIT_BUTTON}                              //*[@title='Edit']
${VIEW_BUTTON}                              //*[@title='View']
${SEARCH_TAB}                               //li[contains(@class,'x-tab-strip-closable setupTab')]
${CPQ_BUTTON}                               //input[@title='CPQ']
${ADD_ATTTACHMENT_BUTTON}                   //*[@title='Add Attachment']
${ATTACHMENT_NAME}                          //input[@id='name']
${ATTACHMENT_FILE}                          //input[@id='files']
${ATTACHMENT_DESCRIPTION}                   //textarea[@id='description']
${DOCUMENT_STATUS}                          //select[@id='Document_Stage']
${DOCUMENT_TYPE}                            //select[@id='type']
${CREATE_ATTACHMENT}                        //div[@id='create_attachment_document']
${SELECT_BUTTON}                            //button[contains(text(), 'Select')]
${SEND_DOCUMENTS_BUTTON}                    //*[@title='Send Documents to ECM']
${UPLOAD_DOCUMENTS_BUTTON}                  //*[@title='Send Selected Documents to ECM']


# Add new contact person fields/paths
${CONTACT_PERSON_TITLE_DROPDOWN}            //select[@title='Salutation']
${CP_FIRSTNAME_FIELD}                       //input[contains(@id,'name_firstcon2')]
# ${CP_LASTNAME_FIELD}                        //label[contains(text(), 'Last Name')]/../following-sibling::*//input
# ${CP_SALES_ROLE_FIELD}                      //label[contains(text(), 'Sales Role')]/../../following-sibling::*//select
# ${CP_MOBILE_FIELD}                          //label[contains(text(), 'Mobile')]/../following-sibling::*//input
# ${CP_PHONE_FIELD}                           //label[contains(text(), 'Phone')]/../following-sibling::*//input
# ${CP_EMAIL_FIELD}                           //label[contains(text(), 'Email')]/../following-sibling::*//input
# ${CP_BUSINESS_CARD_FIELD}                   //label[contains(text(), 'Business Card Title')]/../following-sibling::*//input
# ${CP_ACCOUNTNAME_FIELD}                     //label[contains(text(), 'Account Name')]/../following-sibling::td//span[@class='lookupInput']/input
${CP_DETAILED_ERROR_MESSAGE_FIELD}          //div[@class='errorMsg']
${CP_COMMON_ERROR_MESSAGE_FIELD}            //div[@class='pbError']
${CREATE_CP_BUTTON}                         id=publishersharebutton

${CPQ_SEARCH_FIELD}                         //div[contains(@class, 'cpq-searchbox')]//input
${CPQ_CREATE_QUOTE}                         //span[contains(text(), 'Create Quote')]
${CPQ_CREATE_ORDER}                         //span[contains(text(), 'Create Order')]
${CPQ_CREATE_ASSETS}                        //span[contains(text(), 'Create Assets')]
${VIEW_RECORD_BUTTON}                       //button[@title='View Record']
${SUBMIT_ORDER_TO_DELIVERY}                 //input[@title='Submit Order']  # //td[@id='topButtonRow']
${SAVE_ORDER_BUTTON}                        //.[contains(text(), 'Order Detail')]/../following-sibling::td//.[@title='Save']

# New Event
# Added //div[contains(@class,'activeTemplate')] to xpath, because these also work for New Task
# ${NEW_EVENT_SUBJECT_FIELD}                  //div[contains(@class,'activeTemplate')]//div[./label[text()='Subject']]/following-sibling::div/input
# ${NEW_EVENT_EVENT_TYPE_FIELD}               //div[contains(@class,'activeTemplate')]//div[./label[text()='Event Type']]/following-sibling::div//select
# ${NEW_EVENT_REASON_FIELD}                   //div[contains(@class,'activeTemplate')]//div[./label[text()='Reason']]/following-sibling::div//select
# ${NEW_EVENT_START_FIELD}                    //div[contains(@class,'activeTemplate')]//div[./label[text()='Start']]/following-sibling::div//input
# ${NEW_EVENT_END_FIELD}                      //div[contains(@class,'activeTemplate')]//div[./label[text()='End']]/following-sibling::div//input
${NEW_EVENT_CONTACT_PERSON_FIELD}           //div[contains(@class,'activeTemplate')]//input[@title='Name' and contains(@id,'evt')]
${NEW_EVENT_ACCOUNT_FIELD}                  //div[contains(@class,'activeTemplate')]//input[@title='Related To' and contains(@id,'evt')]
# ${NEW_EVENT_DESCRIPTION_FIELD}              //div[contains(@class,'activeTemplate')]//td[./label[text()='Description']]/following-sibling::td/textarea
${NEW_EVENT_WIG_GLORY_FIELD}                //td[./label[text()='DaaS']]/following-sibling::td/input
# ${NEW_TASK_DUE_DATE_FIELD}                  //div[contains(@class,'activeTemplate')]//div[./label[text()='Due Date']]/following-sibling::div//input