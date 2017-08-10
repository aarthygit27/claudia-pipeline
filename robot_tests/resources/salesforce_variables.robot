*** Variables ***
${NAVIGATORTAB}                             //li[contains(@id, 'navigatortab__scc-pt')]
${LOGOUT_BUTTON}                            //div[@id='userNav-menuItems']//a[text()='Logout']
${LOOKUP_SEARCH_FIELD}                      id=lksrch
${LOOKUP_SEARCH_GO_BUTTON}                  //input[@title='Go!']
${LOGIN_PAGE}                               https://test.salesforce.com/
${BROWSER}                                  Firefox
${IFRAME}                                   //iframe

### Credentials
${CUSTOMER_CARE_USER}                       custcare@teliacompany.com.preprod
${SALES_ADMIN_USER}                         saleadm@teliacompany.com.preprod
${PRODUCT_MANAGER_USER}                     prodman@teliacompany.com.preprod
${B2B_DIGISALES_USER}                       b2bdigi@teliacompany.com.preprod
${PASSWORD}                                 PahaPassu2

${NEW_OPPORTUNITY_BUTTON}                   //input[contains(@title,'New Opportunity')]
${OPPORTUNITY_FRAME}                        //div[contains(@id,'scc-st')]${IFRAME}
${OPPORTUNITY_SAVE_BUTTON}                  //h2[contains(text(), 'Opportunity Edit')]/../following-sibling::td//input[@title='Save']
${OPPORTUNITY_CPQ_BUTTON}                   //h2[contains(text(), 'Opportunity Detail')]/../following-sibling::td//input[@title='CPQ']
${OPPO_EDIT_TITLE}                          //h1[contains(text(),'Opportunity Edit')]
${OPPO_TEST_ACCOUNT}                        Juleco
${OPPO_TEST_CONTACT}                        Paavo Pesusieni

${OPPO_INFO_OPPO_NAME_FIELD}                //label[contains(text(), 'Opportunity Name')]/../following-sibling::*//input
${OPPO_INFO_STAGE_FIELD}                    //label[contains(text(), 'Stage')]/../following-sibling::*//select
${OPPO_INFO_CLOSE_DATE_FIELD}               //label[contains(text(), 'Close Date')]/../following-sibling::*//input
${CLASSIF_DESCRIPTION_FIELD}                //label[text()= 'Description' and *[@class= 'assistiveText']]/../following-sibling::*//textarea
${CLASSIF_ACCOUNT_SEARCH_BUTTON}            //label[contains(text(), 'Account Name')]/../following-sibling::*//img[@class='lookupIcon']
${CLASSIF_ACCOUNT_NAME_FILLED}              //label[contains(text(), 'Account Name')]/../following-sibling::*//input[@class='readonly']
${CLOSE_REASON_FIELD}                       //label[contains(text(),'Close Reason')]/../following-sibling::td
${CLOSE_COMMENT_FIELD}                      //label[text()='Close Comment']/../following-sibling::td

${ACCOUNT_FRAME}                            //div[contains(@id,'scc-pt')]${IFRAME}
${NEW_ACCOUNT_BUTTON}                       //input[contains(@title,'New Account')]
${NEW_CONTACT_BUTTON}                       //input[contains(@title,'New Contact')]
${MORE_DROPDOWN_AT_DETAILS}                 //span[@class='optionLabel' and contains(text(), 'More')]/following-sibling::span[@class='arrowIcon']
${NEW_CONTACT_AT_MORE_DROPDOWN}             ul//span[contains(text(), 'New Contact')]
${NEW_CONTACT_BUTTON_AT_DETAILS}            //span[@class= 'optionLabel' and text()= 'New Contact']
${NEW_OPPORTUNITY_BUTTON_AT_DETAILS}        //span[@class= 'optionLabel' and text()= 'New Opportunity']
${NEW_OPPORTUNITY_AT_MORE_DROPDOWN}         ul//span[contains(text(), 'New Opportunity')]
${ACCOUNT_DETAILS}                          //a[@title='Details']
${FIELD_DETAIL}                             //h2[contains(text(),'Detail')]
${ACCOUNT_FEED}                             //a[@title='Feed']
${BOTTOM_SAVE_BUTTON}                       //td[@id='bottomButtonRow']/input[@title='Save']
${ACCOUNT_NAME_LOOKUP}                      //img[contains(@title,'Account Name')]
${EDIT_BUTTON}                              //input[@title='Edit']
${SEARCH_TAB}                               //li[contains(@class,'x-tab-strip-closable setupTab')]

# Add new contact person fields/paths
${CONTACT_PERSON_TITLE_DROPDOWN}            //select[@title='Salutation']
${CP_FIRSTNAME_FIELD}                       //input[contains(@id,'name_firstcon2')]
${CP_LASTNAME_FIELD}                        //label[contains(text(), 'Last Name')]/../following-sibling::*//input
${CP_SALES_ROLE_FIELD}                      //label[contains(text(), 'Sales Role')]/../../following-sibling::*//select
${CP_MOBILE_FIELD}                          //label[contains(text(), 'Mobile')]/../following-sibling::*//input
${CP_PHONE_FIELD}                           //label[contains(text(), 'Phone')]/../following-sibling::*//input
${CP_EMAIL_FIELD}                           //label[contains(text(), 'Email')]/../following-sibling::*//input
${CP_BUSINESS_CARD_FIELD}                   //label[contains(text(), 'Business Card Title')]/../following-sibling::*//input
${CP_ACCOUNTNAME_FIELD}                     //label[contains(text(), 'Account Name')]/../following-sibling::td//span[@class='lookupInput']/input
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