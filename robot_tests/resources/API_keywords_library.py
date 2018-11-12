#coding=utf-8
import requests
import requests.auth
import json
import os
import base64
import datetime as dt
import random
import uuid
import time

os.environ['Content-Type'] = 'application/json'
os.environ['authorization'] = 'Basic {{base64key}}'


s = requests.Session()

def get_session():
    s = requests.Session()
    return s

	
def API_authenticate():
    base64Key = 'R1lMckd2TUZsMjBIdW96QWZFdjBBMlJBNzdwTGNBeXI6WlQ2aHR0YzlNYzZVZUZPWg=='
    print 'base64Key'
    global token_json
    token_url = "https://api-garden-test.teliacompany.com:443/oauth/client_credential/accesstoken?grant_type=client_credentials"
    payload = {'grant_type': 'client_credentials', 'Authorization':"Basic "+ base64Key}
    headers = {}
    client_id = 'GYLrGvMFl20HuozAfEv0A2RA77pLcAyr'
    client_secret = 'ZT6httc9Mc6UeFOZ'

    access_token_response = s.post(token_url,auth=(client_id, client_secret),verify=False)
#    access_token_response = requests.post(token_url, data=payload, verify=False, allow_redirects=False, auth=(client_id, client_secret))

    print("[auth:setToken()] STATUS CODE: " + str(access_token_response.status_code))
    print("[auth:setToken()] RESPONSE: " + access_token_response.text)

    if access_token_response.status_code == 200:
        token_json = access_token_response.json()
        #parsed_json = json.loads(access_token_response.text)
        print (token_json)
        access_token = token_json["access_token"]
        print token_json["access_token"]

    return access_token_response.status_code

def API_authenticate_ulm():
    base64Key = 'MHRHa3AwQXFBWTFiaUJ5THZlUWdud3J1S1NLYVRPV0E6dFFmMkdoNHdvN3pKY3pPQg=='
    print 'base64Key'
    global token_json_ulm
    token_url = "https://api-garden-test.teliacompany.com:443/oauth/client_credential/accesstoken?grant_type=client_credentials"
    payload = {'grant_type': 'client_credentials', 'Authorization':"Basic "+ base64Key}
    headers = {}
    client_id = '0tGkp0AqAY1biByLveQgnwruKSKaTOWA'
    client_secret = 'tQf2Gh4wo7zJczOB'

    access_token_response = s.post(token_url,auth=(client_id, client_secret),verify=False)
#    access_token_response = requests.post(token_url, data=payload, verify=False, allow_redirects=False, auth=(client_id, client_secret))

    print("[auth:setToken()] STATUS CODE: " + str(access_token_response.status_code))
    print("[auth:setToken()] RESPONSE: " + access_token_response.text)

    if access_token_response.status_code == 200:
        token_json_ulm = access_token_response.json()
        #parsed_json = json.loads(access_token_response.text)
        print (token_json_ulm)
        access_token = token_json_ulm["access_token"]
        print token_json_ulm["access_token"]

    return access_token_response.status_code

def API_authenticate_ngsf_ddm():
    base64Key = 'SEQ4Q0VUeXQyS25nalV3bmYyV2pCa3puZ3dlV0xHb0s6VE1mMElKaW5aQWd3NU9FdA=='
    print 'base64Key'
    global token_json_ngsf_ddm
    token_url = "https://api-garden-uat.teliacompany.com:443/oauth/client_credential/accesstoken?grant_type=client_credentials"
    payload = {'grant_type': 'client_credentials', 'Authorization':"Basic "+ base64Key}
    headers = {}
    client_id = 'XVwNexDnaLZgFcRvJmWz90UTYKbtGGWO'
    client_secret = 'uoZGpR2r37sdkPfR'

    access_token_response = s.post(token_url,auth=(client_id, client_secret),verify=False)
#    access_token_response = requests.post(token_url, data=payload, verify=False, allow_redirects=False, auth=(client_id, client_secret))

    print("[auth:setToken()] STATUS CODE: " + str(access_token_response.status_code))
    print("[auth:setToken()] RESPONSE: " + access_token_response.text)

    if access_token_response.status_code == 200:
        token_json_ngsf_ddm = access_token_response.json()
        #parsed_json = json.loads(access_token_response.text)
        print (token_json_ngsf_ddm)
        access_token = token_json_ngsf_ddm["access_token"]
        print token_json_ngsf_ddm["access_token"]

    return access_token_response.status_code

def API_get_credit_scoring():
    url = "https://api-garden-test.teliacompany.com:443/v1/finland/creditscore"
	
    jsonni = {"creditScoreRequest":{"inquirer":"B2B DigiSales", "originalInquiringSystem":"Claudia", "usage":"1", "businessId":"2299480-0", "language":"en", "appliedAmount":0, "version":"3", "productCategory":"BroadbandLowRisk"}, "header":{"sender":{"name":"PH10097", "id":123}, "timestamp": dt.datetime.now().isoformat()}}
    headers = {'Content-Type':'application/json', 'Authorization': 'Bearer ' + token_json['access_token'], 'traceId': uuid.uuid4().hex}
    #headers = {}
    r = s.post(url, json=jsonni, headers=headers,verify=False)
    print("[auth:setToken()] STATUS CODE: " + str(r.status_code))
    print("[auth:setToken()] RESPONSE: " + r.text)

    if r.status_code == 200:
        parsed_json = json.loads(r.text)
        return r.status_code


def Create_new_user_existing_company_ULM():
    url = "https://api-garden-test.teliacompany.com:443/v1/finland/ULMUserManagement/createCompanyUser"
    global  ulm_parsed_response
    global ulm_user_id
    jsonni = {
    "requestInfo":{
        "actionDate": "1518817660660",
        "applicationName":"claudia"
    },
    "requestData": {
        "firstName": time.time(),
        "lastName": "User",
        "companyIdList": [
            {
                "companyId": "597133",
                "companyIdType": "AIDA"

            }
        ],
        "businessGroupType": "b2b",
        "businessEmail": str(time.time())+'@test.com',
        "businessMobilePhone": "+1387280864848",
        "communicationLanguage": "fi",
        "socialSecurityNumber": random.randint(1000000000,9999999999),
        "thirdPartyFlag": "false",
        "preferredContactChannel": "email",
        "businessConsents": [
            {
                "consentName": "e_marketing_sms",
                "consentValue": "on"
            },
            {
                "consentName": "e_marketing_email",
                "consentValue": "off"
            },
            {
                "consentName": "direct_letter_marketing",
                "consentValue": "off"
            },
            {
                "consentName": "telemarketing",
                "consentValue": "on"
            },
            {
                "consentName": "profiling_for_marketing",
                "consentValue": "off"
            },
            {
                "consentName": "marketing_location_data",
                "consentValue": "off"
            },
            {
                "consentName": "marketing_traffic_data",
                "consentValue": "off"
            }
        ],
        "userMemberships": ["admin","contact"]
    }
}
    headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token_json_ulm['access_token'],
               'traceId': uuid.uuid4().hex}
    # headers = {}
    r = s.post(url, json=jsonni, headers=headers, verify=False)
    print("[auth:setToken()] STATUS CODE: " + str(r.status_code))
    print("[auth:setToken()] RESPONSE: " + r.text)

    if r.status_code == 200:
        parsed_json = json.loads(r.text)
        print parsed_json
        ulm_parsed_response = r.json()
        return r.status_code

def Update_request_ulm():
    url = "https://api-garden-test.teliacompany.com:443/v1/finland/ULMUserManagement/updateCompanyUser"
    jsonni = {
    "requestInfo":{
        "actionDate": "1518817660660",
        "applicationName":"claudia"
    }
    ,
    "requestData": {
        "ulmUserId": ulm_parsed_response['responseData']['ulmUserId'],
        "firstName": time.time(),
        "lastName": "User",
        "companyIdList": [
            {
                "companyId": "597132",
                "companyIdType": "AIDA"

            }
        ],
        "businessGroupType": "b2b",
        "businessEmail": str(time.time())+'@test.com',
        "businessMobilePhone": "+1387280864848",
        "communicationLanguage": "fi",
        "socialSecurityNumber": "7866976976",
        "thirdPartyFlag": "false",
        "preferredContactChannel": "email",
        "businessConsents": [
            {
                "consentName": "e_marketing_sms",
                "consentValue": "on"
            },
            {
                "consentName": "e_marketing_email",
                "consentValue": "off"
            },
            {
                "consentName": "direct_letter_marketing",
                "consentValue": "off"
            },
            {
                "consentName": "telemarketing",
                "consentValue": "on"
            },
            {
                "consentName": "profiling_for_marketing",
                "consentValue": "off"
            },
            {
                "consentName": "marketing_location_data",
                "consentValue": "off"
            },
            {
                "consentName": "marketing_traffic_data",
                "consentValue": "off"
            }
        ],
        "userMemberships": ["primary","contact"]
    }
}
    headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token_json_ulm['access_token'],
               'traceId': uuid.uuid4().hex}
    # headers = {}
    r = s.post(url, json=jsonni, headers=headers, verify=False)
    print("[auth:setToken()] STATUS CODE: " + str(r.status_code))
    print("[auth:setToken()] RESPONSE: " + r.text)

    if r.status_code == 200:
        parsed_json = json.loads(r.text)
        return r.status_code

def Create_service_order_DDM():
    url = "https://api-garden-uat.teliacompany.com:443/v1/finland/service/order"
    jsonni = {
   "serviceOrderRequest":{
      "serviceOrder":[
         {
            "serviceOrderItem":[
               {
                  "service":{
                     "serviceState":"INACTIVE"
                  },
                  "requestedStartDate":"2018-07-30",
                  "requestedCompletionDate":"2018-07-30",
                  "product":{
                     "productSpecification":{
                        "productSpecCharacteristic":[
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"1"
                                 }
                              ],
                              "name":"Quantity"
                           }
                        ],
                        "name":"TS_prod_H_DataCenter"
                     },
                     "id":"80258000007SmvxAAC",
                     "description":"PS-HDC",
                     "commercialId":"HDC058779",
                     "assetId":"02i5800000H3CddAAF"
                  },
                  "individual":[
                     {
                        "systemIdentification":{
                           "name":"CLAUDIA",
                           "id":""
                        },
                        "partyRole":{
                           "partyRoleCategory":{
                              "categoryName":""
                           },
                           "name":"PRIMARY_CONTACT"
                        },
                        "partyId":"0035800000ohlBlAAI",
                        "organizationIdentification":{
                           "id":"3001188943"
                        },
                        "individualName":[
                           {
                              "givenNames":"Tuomas",
                              "formattedName":"Tuomas Partanen",
                              "familyNames":"Partanen"
                           }
                        ],
                        "contactMedium":[
                           {
                              "telephoneNumber":[
                                 {
                                    "type":"Mobile",
                                    "phoneNumber":"+358504801753"
                                 }
                              ],
                              "emailContact":[
                                 {
                                    "eMailAddress":"tuomas.partanen@teliacompany.com"
                                 }
                              ]
                           }
                        ]
                     },
                     {
                        "systemIdentification":{
                           "name":"CLAUDIA",
                           "id":""
                        },
                        "partyRole":{
                           "partyRoleCategory":{
                              "categoryName":""
                           },
                           "name":"DELIVERY_CONTACT"
                        },
                        "partyId":"0035800000ohlBlAAI",
                        "organizationIdentification":{
                           "id":"3001188943"
                        },
                        "individualName":[
                           {
                              "givenNames":"Tuomas",
                              "formattedName":"Tuomas Partanen",
                              "familyNames":"Partanen"
                           }
                        ],
                        "contactMedium":[
                           {
                              "telephoneNumber":[
                                 {
                                    "type":"Mobile",
                                    "phoneNumber":"+358504801753"
                                 }
                              ],
                              "emailContact":[
                                 {
                                    "eMailAddress":"tuomas.partanen@teliacompany.com"
                                 }
                              ]
                           }
                        ]
                     }
                  ],
                  "action":"ADD"
               },
               {
                  "serviceOrderItemRelationship":[
                     {
                        "type":"INCLUDED_BY",
                        "id":"80258000007SmvxAAC"
                     }
                  ],
                  "service":{
                     "serviceState":"INACTIVE"
                  },
                  "requestedStartDate":"2018-07-30",
                  "requestedCompletionDate":"2018-07-30",
                  "product":{
                     "productSpecification":{
                        "productSpecCharacteristic":[
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"1"
                                 }
                              ],
                              "name":"Quantity"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"Standard"
                                 }
                              ],
                              "name":"TS_char_HDC_PDUdefault"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"false"
                                 }
                              ],
                              "name":"TS_char_HDC_Energyprovider"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"Compartment 1"
                                 }
                              ],
                              "name":"TS_char_HDC_Secureroom"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"false"
                                 }
                              ],
                              "name":"TS_char_HDC_Cabinetreservation"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"6,5 kW"
                                 }
                              ],
                              "name":"TS_char_HDC_powercoolingcapacity52RU"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"false"
                                 }
                              ],
                              "name":"TS_char_HDC_CabinetClassified"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"Primary"
                                 }
                              ],
                              "name":"TS_char_HDC_purpose"
                           }
                        ],
                        "name":"TS_prod_HDC_Cabinet52RU"
                     },
                     "id":"80258000007SmvwAAC",
                     "description":"PS-Cabinet 52 RU",
                     "commercialId":"RACK058780",
                     "assetId":"02i5800000H3CdeAAF"
                  },
                  "note":{
                     "text":""
                  },
                  "individual":[
                     {
                        "systemIdentification":{
                           "name":"CLAUDIA",
                           "id":""
                        },
                        "partyRole":{
                           "partyRoleCategory":{
                              "categoryName":""
                           },
                           "name":"PRIMARY_CONTACT"
                        },
                        "partyId":"0035800000ohlBlAAI",
                        "organizationIdentification":{
                           "id":"3001188943"
                        },
                        "individualName":[
                           {
                              "givenNames":"Tuomas",
                              "formattedName":"Tuomas Partanen",
                              "familyNames":"Partanen"
                           }
                        ],
                        "contactMedium":[
                           {
                              "telephoneNumber":[
                                 {
                                    "type":"Mobile",
                                    "phoneNumber":"+358504801753"
                                 }
                              ],
                              "emailContact":[
                                 {
                                    "eMailAddress":"tuomas.partanen@teliacompany.com"
                                 }
                              ]
                           }
                        ]
                     },
                     {
                        "systemIdentification":{
                           "name":"CLAUDIA",
                           "id":""
                        },
                        "partyRole":{
                           "partyRoleCategory":{
                              "categoryName":""
                           },
                           "name":"DELIVERY_CONTACT"
                        },
                        "partyId":"0035800000ohlBlAAI",
                        "organizationIdentification":{
                           "id":"3001188943"
                        },
                        "individualName":[
                           {
                              "givenNames":"Tuomas",
                              "formattedName":"Tuomas Partanen",
                              "familyNames":"Partanen"
                           }
                        ],
                        "contactMedium":[
                           {
                              "telephoneNumber":[
                                 {
                                    "type":"Mobile",
                                    "phoneNumber":"+358504801753"
                                 }
                              ],
                              "emailContact":[
                                 {
                                    "eMailAddress":"tuomas.partanen@teliacompany.com"
                                 }
                              ]
                           }
                        ]
                     }
                  ],
                  "action":"ADD"
               },
               {
                  "serviceOrderItemRelationship":[
                     {
                        "type":"INCLUDED_BY",
                        "id":"80258000007SmvxAAC"
                     }
                  ],
                  "service":{
                     "serviceState":"INACTIVE"
                  },
                  "requestedStartDate":"2018-07-30",
                  "requestedCompletionDate":"2018-07-30",
                  "product":{
                     "productSpecification":{
                        "productSpecCharacteristic":[
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"1"
                                 }
                              ],
                              "name":"Quantity"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"Standard"
                                 }
                              ],
                              "name":"TS_char_HDC_12PDUtype"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"false"
                                 }
                              ],
                              "name":"TS_char_HDC_Energyprovider"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"Compartment 1"
                                 }
                              ],
                              "name":"TS_char_HDC_Secureroom"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"false"
                                 }
                              ],
                              "name":"TS_char_HDC_Cabinetreservation"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"1,6 kW"
                                 }
                              ],
                              "name":"TS_char_HDC_powercoolingcapacity12RU"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"false"
                                 }
                              ],
                              "name":"TS_char_HDC_CabinetClassified"
                           },
                           {
                              "productSpecCharacteristicValue":[
                                 {
                                    "value":"Primary"
                                 }
                              ],
                              "name":"TS_char_HDC_purpose"
                           }
                        ],
                        "name":"TS_prod_HDC_Cabinet12RU"
                     },
                     "id":"80258000007SmvvAAC",
                     "description":"PS-Cabinet 12 RU",
                     "commercialId":"RACK058781",
                     "assetId":"02i5800000H3CdfAAF"
                  },
                  "note":{
                     "text":""
                  },
                  "individual":[
                     {
                        "systemIdentification":{
                           "name":"CLAUDIA",
                           "id":""
                        },
                        "partyRole":{
                           "partyRoleCategory":{
                              "categoryName":""
                           },
                           "name":"PRIMARY_CONTACT"
                        },
                        "partyId":"0035800000ohlBlAAI",
                        "organizationIdentification":{
                           "id":"3001188943"
                        },
                        "individualName":[
                           {
                              "givenNames":"Tuomas",
                              "formattedName":"Tuomas Partanen",
                              "familyNames":"Partanen"
                           }
                        ],
                        "contactMedium":[
                           {
                              "telephoneNumber":[
                                 {
                                    "type":"Mobile",
                                    "phoneNumber":"+358504801753"
                                 }
                              ],
                              "emailContact":[
                                 {
                                    "eMailAddress":"tuomas.partanen@teliacompany.com"
                                 }
                              ]
                           }
                        ]
                     },
                     {
                        "systemIdentification":{
                           "name":"CLAUDIA",
                           "id":""
                        },
                        "partyRole":{
                           "partyRoleCategory":{
                              "categoryName":""
                           },
                           "name":"DELIVERY_CONTACT"
                        },
                        "partyId":"0035800000ohlBlAAI",
                        "organizationIdentification":{
                           "id":"3001188943"
                        },
                        "individualName":[
                           {
                              "givenNames":"Tuomas",
                              "formattedName":"Tuomas Partanen",
                              "familyNames":"Partanen"
                           }
                        ],
                        "contactMedium":[
                           {
                              "telephoneNumber":[
                                 {
                                    "type":"Mobile",
                                    "phoneNumber":"+358504801753"
                                 }
                              ],
                              "emailContact":[
                                 {
                                    "eMailAddress":"tuomas.partanen@teliacompany.com"
                                 }
                              ]
                           }
                        ]
                     }
                  ],
                  "action":"ADD"
               }
            ],
            "organization":[
               {
                  "systemIdentification":{
                     "name":"AIDA",
                     "id":"1510196"
                  },
                  "place":[
                     {
                        "address":{
                           "streetName":"ELIMÄENKATU 8",
                           "postcode":"00510",
                           "locality":"HELSINKI",
                           "format":"PHYSICAL",
                           "countryCode":"FI"
                        }
                     }
                  ],
                  "partyRole":{
                     "name":"SUBSCRIBER"
                  },
                  "partyId":"0015800000io3MJAAY",
                  "organizationName":[
                     {
                        "tradingName":"Test Customer Multibella BAC"
                     }
                  ],
                  "businessIdIdentification":{
                     "businessId":"6661025-8"
                  }
               }
            ],
            "orderDate":"2018-06-27T05:53:59Z",
            "individual":[
               {
                  "systemIdentification":{
                     "name":"AIDA",
                     "id":"1510196"
                  },
                  "partyRole":{
                     "partyRoleCategory":{
                        "categoryName":"OrderCreator"
                     },
                     "name":"EMPLOYEE"
                  },
                  "partyId":"0035800000ohlBlAAI",
                  "organizationIdentification":{
                     "id":"3001188943"
                  },
                  "individualName":[
                     {
                        "givenNames":"Tuomas",
                        "formattedName":"Tuomas Partanen",
                        "familyNames":"Partanen"
                     }
                  ],
                  "contactMedium":[
                     {
                        "telephoneNumber":[
                           {
                              "type":"Mobile",
                              "phoneNumber":"+358504801753"
                           }
                        ],
                        "emailContact":[
                           {
                              "eMailAddress":"tuomas.partanen@teliacompany.com"
                           }
                        ]
                     }
                  ]
               },
               {
                  "systemIdentification":{
                     "name":"CLAUDIA",
                     "id":""
                  },
                  "partyRole":{
                     "partyRoleCategory":{
                        "categoryName":""
                     },
                     "name":"SALES_PERSON"
                  },
                  "partyId":"00558000001umjIAAQ",
                  "organizationIdentification":{
                     "id":"TELIA"
                  },
                  "individualName":[
                     {
                        "givenNames":"Tuomas",
                        "formattedName":"Tuomas Partanen",
                        "familyNames":"Partanen"
                     }
                  ],
                  "contactMedium":[
                     {
                        "telephoneNumber":[
                           {
                              "type":"Mobile",
                              "phoneNumber":"+358 504801753"
                           }
                        ],
                        "emailContact":[
                           {
                              "eMailAddress":"tuomas.partanen@teliacompany.com"
                           }
                        ]
                     }
                  ]
               }
            ],
            "externalId":"318062705193",
            "characteristic":[
               {
                  "name":"TS_CUSTOMER_ID",
                  "characteristicValue":[
                     {
                        "value":"3001188943"
                     }
                  ]
               },
               {
                  "name":"cpPreferredLanguage",
                  "characteristicValue":[
                     {
                        "value":"Finnish"
                     }
                  ]
               },
               {
                  "name":"contractId",
                  "characteristicValue":[
                     {
                        "value":""
                     }
                  ]
               },
               {
                  "name":"contractStartDate",
                  "characteristicValue":[
                     {
                        "value":""
                     }
                  ]
               },
               {
                  "name":"contractEndDate",
                  "characteristicValue":[
                     {
                        "value":""
                     }
                  ]
               },
               {
                  "name":"contractSLA",
                  "characteristicValue":[
                     {
                        "value":"Standard"
                     }
                  ]
               }
            ]
         }
      ],
      "header":{
         "timestamp":"2018-06-27T05:53:59Z",
         "sender":{
            "systemId":"CLAUDIA"
         },
         "receiver":[
            {
               "systemId":"DDM"
            }
         ],
         "operation":"CREATE",
         "messageId":"CLAUDIA-801580000030BfmAAE"
      }
   }
    }


    headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token_json_ngsf_ddm['access_token'],
               'traceId': uuid.uuid4().hex}
    # headers = {}
    r = s.post(url, json=jsonni, headers=headers, verify=False)
    print("[auth:setToken()] STATUS CODE: " + str(r.status_code))
    print("[auth:setToken()] RESPONSE: " + r.text)

    if r.status_code == 200:
        parsed_json = json.loads(r.text)
        return r.status_code

def Create_service_order_NGSF():
    url = "https://api-garden-uat.teliacompany.com:443/v1/finland/service/order"
    jsonni = {
  "serviceOrderRequest": {
    "serviceOrder": [{
      "serviceOrderItem": [{
        "service": {
          "serviceState": "INACTIVE"
        },
        "product": {
          "productSpecification": {
            "name": "TS_prod_H_DataCenter"
          },
          "id": "8025E000000HcYJQA0",
          "description": "PS-HDC"
        },
        "note": {
          "text": ""
        },
        "action": "Add"
      },
      {
        "serviceOrderItemRelationship": [{
          "type": "INCLUDED_BY",
          "id": "8025E000000HcYJQA0"
        }],
        "service": {
          "serviceState": "INACTIVE"
        },
        "product": {
          "productSpecification": {
            "productSpecCharacteristic": [{
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_Transferprovider"
            },
            {
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_Secureroom"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_Cabinetreservation"
            },
            {
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_powercoolingcapacity12RU"
            },
            {
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_powercoolingcapacity52RU"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_CabinetClassified"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_ClassifiedSpace"
            },
            {
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_PDUdefault"
            }],
            "name": "TS_prod_HDC_Cabinet52RU_B2O"
          },
          "id": "8025E000000HcYGQA0",
          "description": "PS-Cabinet 52 RU-B2O"
        },
        "note": {
          "text": ""
        },
        "action": "Add"
      },
      {
        "serviceOrderItemRelationship": [{
          "type": "INCLUDED_BY",
          "id": "8025E000000HcYGQA0"
        }],
        "service": {
          "serviceState": "INACTIVE"
        },
        "product": {
          "productSpecification": {
            "productSpecCharacteristic": [{
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_12PDUtype"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "Perus"
              }],
              "name": "TS_char_HDC_52PDUtype"
            },
            {
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_PDUdefault"
            }],
            "name": "TS_prod_HDC_add52PDU"
          },
          "id": "8025E000000HcYKQA0",
          "description": "PS-Additional PDU for 52 RU"
        },
        "note": {
          "text": ""
        },
        "action": "Add"
      },
      {
        "serviceOrderItemRelationship": [{
          "type": "INCLUDED_BY",
          "id": "8025E000000HcYGQA0"
        }],
        "service": {
          "serviceState": "INACTIVE"
        },
        "product": {
          "productSpecification": {
            "name": "TS_prod_HDC_AddPowerFeeds"
          },
          "id": "8025E000000HcYBQA0",
          "description": "PS-Additional power feeds, 400 VAC, 3-phase 16A, 32A (A2 + B2)"
        },
        "note": {
          "text": ""
        },
        "action": "Add"
      },
      {
        "serviceOrderItemRelationship": [{
          "type": "INCLUDED_BY",
          "id": "8025E000000HcYGQA0"
        }],
        "service": {
          "serviceState": "INACTIVE"
        },
        "product": {
          "productSpecification": {
            "productSpecCharacteristic": [{
              "productSpecCharacteristicValue": [{
                "value": "ODF 1 24k, takana"
              }],
              "name": "TS_char_HDC_fiberconnection"
            }],
            "name": "TS_prod_HDC_FibreOpticConnection"
          },
          "id": "8025E000000HcYIQA0",
          "description": "PS-Fibre-optic conn, 24 fibres"
        },
        "note": {
          "text": ""
        },
        "action": "Add"
      },
      {
        "serviceOrderItemRelationship": [{
          "type": "INCLUDED_BY",
          "id": "8025E000000HcYGQA0"
        }],
        "service": {
          "serviceState": "INACTIVE"
        },
        "product": {
          "productSpecification": {
            "productSpecCharacteristic": [{
              "productSpecCharacteristicValue": [{
                "value": ""
              }],
              "name": "TS_char_HDC_cabinetB"
            }],
            "name": "TS_prod_HDC_CablingFibres24SM"
          },
          "id": "8025E000000HcYAQA0",
          "description": "PS-Cabling, 24 fibres, SM"
        },
        "note": {
          "text": ""
        },
        "action": "Add"
      },
      {
        "serviceOrderItemRelationship": [{
          "type": "INCLUDED_BY",
          "id": "8025E000000HcYJQA0"
        }],
        "service": {
          "serviceState": "INACTIVE"
        },
        "product": {
          "productSpecification": {
            "productSpecCharacteristic": [{
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_Transferprovider"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "Palotila 1"
              }],
              "name": "TS_char_HDC_Secureroom"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_Cabinetreservation"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "1,6 kW"
              }],
              "name": "TS_char_HDC_powercoolingcapacity12RU"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": ""
              }],
              "name": "TS_char_HDC_powercoolingcapacity52RU"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_CabinetClassified"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_ClassifiedSpace"
            },
            {
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_PDUdefault"
            }],
            "name": "TS_prod_HDC_Cabinet12RU"
          },
          "id": "8025E000000HcYCQA0",
          "description": "PS-Cabinet 12 RU"
        },
        "note": {
          "text": ""
        },
        "action": "Add"
      },
      {
        "serviceOrderItemRelationship": [{
          "type": "INCLUDED_BY",
          "id": "8025E000000HcYCQA0"
        }],
        "service": {
          "serviceState": "INACTIVE"
        },
        "product": {
          "productSpecification": {
            "productSpecCharacteristic": [{
              "productSpecCharacteristicValue": [{
                "value": ""
              }],
              "name": "TS_char_HDC_cabinetB"
            }],
            "name": "TS_prod_HDC_NetworkODFconnection"
          },
          "id": "8025E000000HcY9QAK",
          "description": "PS-In-house cabling between cabinets in the same data hall"
        },
        "note": {
          "text": ""
        },
        "action": "Add"
      },
      {
        "serviceOrderItemRelationship": [{
          "type": "INCLUDED_BY",
          "id": "8025E000000HcYJQA0"
        }],
        "service": {
          "serviceState": "INACTIVE"
        },
        "product": {
          "productSpecification": {
            "productSpecCharacteristic": [{
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_Transferprovider"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "Palotila 1"
              }],
              "name": "TS_char_HDC_Secureroom"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_Cabinetreservation"
            },
            {
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_powercoolingcapacity12RU"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "6,5 kW"
              }],
              "name": "TS_char_HDC_powercoolingcapacity52RU"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_CabinetClassified"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_ClassifiedSpace"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "Perus"
              }],
              "name": "TS_char_HDC_PDUdefault"
            }],
            "name": "TS_prod_HDC_Customercabinet"
          },
          "id": "8025E000000HcYDQA0",
          "description": "PS-HDC_CustomerCabinet"
        },
        "note": {
          "text": ""
        },
        "action": "Add"
      },
      {
        "serviceOrderItemRelationship": [{
          "type": "INCLUDED_BY",
          "id": "8025E000000HcYDQA0"
        }],
        "service": {
          "serviceState": "INACTIVE"
        },
        "product": {
          "id": "8025E000000HcYEQA0"
        },
        "note": {
          "text": ""
        },
        "action": "Add"
      },
      {
        "serviceOrderItemRelationship": [{
          "type": "INCLUDED_BY",
          "id": "8025E000000HcYDQA0"
        }],
        "service": {
          "serviceState": "INACTIVE"
        },
        "product": {
          "productSpecification": {
            "productSpecCharacteristic": [{
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_12PDUtype"
            },
            {
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_52PDUtype"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "Vaiheittain"
              }],
              "name": "TS_char_HDC_PDUdefault"
            }],
            "name": "TS_prod_HDC_PDU"
          },
          "id": "8025E000000HcYFQA0",
          "description": "PS-PDU"
        },
        "note": {
          "text": ""
        },
        "action": "Add"
      },
      {
        "serviceOrderItemRelationship": [{
          "type": "INCLUDED_BY",
          "id": "8025E000000HcYJQA0"
        }],
        "service": {
          "serviceState": "INACTIVE"
        },
        "product": {
          "productSpecification": {
            "productSpecCharacteristic": [{
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_Transferprovider"
            },
            {
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_Secureroom"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_Cabinetreservation"
            },
            {
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_powercoolingcapacity12RU"
            },
            {
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_powercoolingcapacity52RU"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_CabinetClassified"
            },
            {
              "productSpecCharacteristicValue": [{
                "value": "false"
              }],
              "name": "TS_char_HDC_ClassifiedSpace"
            },
            {
              "productSpecCharacteristicValue": [{

              }],
              "name": "TS_char_HDC_PDUdefault"
            }],
            "name": "TS_prod_HDC_DedicatedDataHall"
          },
          "id": "8025E000000HcYHQA0",
          "description": "PS-Dedicated data hall"
        },
        "note": {
          "text": ""
        },
        "action": "Add"
      }],
      "organization": [{
        "systemIdentification": {
          "name": "AIDA",
          "id": "0"
        },
        "place": [{
          "address": {
            "streetNrFirst": "13",
            "streetName": "Kauhajärventie",
            "postcode": "62295",
            "locality": "KAUHAJÄRVI",
            "format": "PHYSICAL",
            "countryCode": "FIN"
          }
        }],
        "partyRole": {
          "name": "SUBSCRIBER"
        },
        "partyId": "0",
        "organizationName": [{
          "tradingName": "Excellent"
        }],
        "businessIdIdentification": {
          "businessId": "0-7"
        }
      }],
      "orderDate": "2017-12-28T12:46:16",
      "individual": [{
        "systemIdentification": {
          "name": "CLAUDIA"
        },
        "partyRole": {
          "partyRoleCategory": {
            "categoryName": "OrderCreator"
          },
          "name": "EMPLOYEE"
        },
        "partyId": "0055E000002CJgiQAG",
        "organizationIdentification": {

        },
        "individualName": [{
          "formattedName": "Heimo Tiihonen"
        }],
        "contactMedium": [{
          "emailContact": [{
            "emailAddress": "heimo.tiihonen@accenture.com"
          }]
        }]
      }],
      "externalId": "8015E0000002Q9gQAE",
      "characteristic": [{
        "name": "TS_CUSTOMER_ID",
        "characteristicValue": [{
          "value": "00558000001vbsRAAQ"
        }]
      },
      {
        "name": "contractId",
        "characteristicValue": [{

        }]
      },
      {
        "name": "cpPreferredLanguage",
        "characteristicValue": [{
          "value": "LANGUAGE_ACTIVITY.FINNISH"
        }]
      },
      {
        "name": "contractStartDate",
        "characteristicValue": [{
          "value": ""
        }]
      },
      {
        "name": "contractEndDate",
        "characteristicValue": [{
          "value": ""
        }]
      },
      {
        "name": "contractSLA",
        "characteristicValue": [{
          "value": "Standard"
        }]
      }]
    }],
    "header": {
      "timestamp": dt.datetime.now().isoformat(),
      "sender": {
        "systemId": "CLAUDIA"
      },
      "receiver": [{
        "systemId": "NGSF"
      }],
      "operation": "CREATE",
      "messageId": "CLAUDIA-8015E0000002Q9gQAE"
    }
  }
}

    headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token_json_ngsf_ddm['access_token'],
               'traceId': uuid.uuid4().hex}
    # headers = {}
    r = s.post(url, json=jsonni, headers=headers, verify=False)
    print("[auth:setToken()] STATUS CODE: " + str(r.status_code))
    print("[auth:setToken()] RESPONSE: " + r.text)

    if r.status_code == 200:
        parsed_json = json.loads(r.text)
        return r.status_code