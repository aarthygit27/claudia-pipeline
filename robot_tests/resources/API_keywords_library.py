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
#import pdb; pdb.set_trace()

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

def API_authenticate_Sap():
    base64Key = 'NUZBMFVjd1pUY2FjZklURFZyYmdwZklUYWZjeVVwRDc6MVh4Y2x6UWtkUmRMdFJtNQ=='
    print 'base64Key'
    global token_json_sap
    token_url = "https://api-garden-test.teliacompany.com/oauth/client_credential/accesstoken?grant_type=client_credentials"
    payload = {'grant_type': 'client_credentials', 'Authorization':"Basic "+ base64Key}
    headers = {}
    client_id = '5FA0UcwZTcacfITDVrbgpfITafcyUpD7'
    client_secret = '1XxclzQkdRdLtRm5'

    access_token_response = s.post(token_url,auth=(client_id, client_secret),verify=False)
#    access_token_response = requests.post(token_url, data=payload, verify=False, allow_redirects=False, auth=(client_id, client_secret))

    print("[auth:setToken()] STATUS CODE: " + str(access_token_response.status_code))
    print("[auth:setToken()] RESPONSE: " + access_token_response.text)

    if access_token_response.status_code == 200:
        token_json_sap = access_token_response.json()
        #parsed_json = json.loads(access_token_response.text)
        print (token_json_sap)
        access_token = token_json_sap["access_token"]
        print token_json_sap["access_token"]

    return access_token_response.status_code

def API_authenticate_Ecm():
    base64Key = 'dEwxR3g3VE9aUnFTdDZlc0FpRTZCZmw3MVQ2UFJQV3c6RXlSUlVIME5BQW1CZ2VmYQ=='
    print 'base64Key'
    global token_json_ecm
    token_url = "https://api-garden-test.teliacompany.com/oauth/client_credential/accesstoken?grant_type=client_credentials"
    payload = {'grant_type': 'client_credentials','Authorization':"Basic "+ base64Key}
    headers = {}
    client_id = ' tL1Gx7TOZRqSt6esAiE6Bfl71T6PRPWw'
    client_secret = 'EyRRUH0NAAmBgefa'

    access_token_response = s.post(token_url,auth=(client_id, client_secret),verify=False)
#    access_token_response = requests.post(token_url, data=payload, verify=False, allow_redirects=False, auth=(client_id, client_secret))
    print("[auth:setToken()] STATUS CODE: " + str(access_token_response.status_code))
    print("[auth:setToken()] RESPONSE: " + access_token_response.text)

    if access_token_response.status_code == 200:
        token_json_ecm = access_token_response.json()
        #parsed_json = json.loads(access_token_response.text)
        print (token_json_ecm)
        access_token = token_json_ecm["access_token"]
        print token_json_ecm["access_token"]

    return access_token_response.status_code

def API_authenticate_address_validation():
    base64Key = 'ZlBIbzJMaW1Wd05XTjQ0YmRMTEQ4ZzBlS0c4bmdBeTg6OWJGY0d1Rk5Wb0owZXZBaQ=='
    print 'base64Key'
    global token_json_address_validation
    token_url = "https://api-garden-test.teliacompany.com/oauth/client_credential/accesstoken?grant_type=client_credentials"
    payload = {'grant_type': 'client_credentials','Authorization':"Basic "+ base64Key}
    headers = {}
    client_id = 'fPHo2LimVwNWN44bdLLD8g0eKG8ngAy8'
    client_secret = '9bFcGuFNVoJ0evAi'

    access_token_response = s.post(token_url,auth=(client_id, client_secret),verify=False)
#    access_token_response = requests.post(token_url, data=payload, verify=False, allow_redirects=False, auth=(client_id, client_secret))
    print("[auth:setToken()] STATUS CODE: " + str(access_token_response.status_code))
    print("[auth:setToken()] RESPONSE: " + access_token_response.text)

    if access_token_response.status_code == 200:
        token_json_address_validation = access_token_response.json()
        #parsed_json = json.loads(access_token_response.text)
        print (token_json_address_validation)
        access_token = token_json_address_validation["access_token"]
        print token_json_address_validation["access_token"]

    return access_token_response.status_code

def API_Authenticate_resource_availability():
    base64Key = 'MEtraDA2STU4NVlSQUo2dUZXRDJOUU0wVktxUXRIVlg6RGk1OUV4bVkzak1qN2RoZw=='
    print 'base64Key'
    global token_json_resource_availability
    token_url = "https://api-garden-test.teliacompany.com/oauth/client_credential/accesstoken?grant_type=client_credentials"
    payload = {'grant_type': 'client_credentials','Authorization':"Basic "+ base64Key}
    headers = {}
    client_id = '0Kkh06I585YRAJ6uFWD2NQM0VKqQtHVX'
    client_secret = 'Di59ExmY3jMj7dhg'

    access_token_response = s.post(token_url,auth=(client_id, client_secret),verify=False)
#    access_token_response = requests.post(token_url, data=payload, verify=False, allow_redirects=False, auth=(client_id, client_secret))
    print("[auth:setToken()] STATUS CODE: " + str(access_token_response.status_code))
    print("[auth:setToken()] RESPONSE: " + access_token_response.text)

    if access_token_response.status_code == 200:
        token_json_resource_availability = access_token_response.json()
        #parsed_json = json.loads(access_token_response.text)
        print (token_json_resource_availability)
        access_token = token_json_resource_availability["access_token"]
        print token_json_resource_availability["access_token"]

    return access_token_response.status_code

def API_Authenticate_credit_score():
    base64Key = 'Z01QSzgxQWxoWW5IQTBGQTZ3a2UweVZFaHdoSnFKMXg6akFLZHU3akJoaUtJMGRHdg=='
    print 'base64Key'
    global token_json_credit_score
    token_url = "https://api-garden-test.teliacompany.com/oauth/client_credential/accesstoken?grant_type=client_credentials"
    payload = {'grant_type': 'client_credentials','Authorization':"Basic "+ base64Key}
    headers = {}
    client_id = 'gMPK81AlhYnHA0FA6wke0yVEhwhJqJ1x'
    client_secret = 'jAKdu7jBhiKI0dGv'

    access_token_response = s.post(token_url,auth=(client_id, client_secret),verify=False)
#    access_token_response = requests.post(token_url, data=payload, verify=False, allow_redirects=False, auth=(client_id, client_secret))
    print("[auth:setToken()] STATUS CODE: " + str(access_token_response.status_code))
    print("[auth:setToken()] RESPONSE: " + access_token_response.text)

    if access_token_response.status_code == 200:
        token_json_credit_score = access_token_response.json()
        #parsed_json = json.loads(access_token_response.text)
        print (token_json_credit_score)
        access_token = token_json_credit_score["access_token"]
        print token_json_credit_score["access_token"]

    return access_token_response.status_code


def Authenticate_Ecm_Notify():
    base64Key = 'Ynp0Mm1IRmFEZjFDY1hLM05ac0tNcGZ2R2tOR016Smw6UFFEdlBjRTEya3E4WHpWUA=='
    print 'base64Key'
    global token_json_ecm_notify
    token_url = "https://api-garden-test.teliacompany.com/oauth/client_credential/accesstoken?grant_type=client_credentials"
    payload = {'grant_type': 'client_credentials', 'Authorization':"Basic "+ base64Key}
    headers = {}
    client_id = ' bzt2mHFaDf1CcXK3NZsKMpfvGkNGMzJl'
    client_secret = 'PQDvPcE12kq8XzVP'

    access_token_response = s.post(token_url,auth=(client_id, client_secret),verify=False)
#    access_token_response = requests.post(token_url, data=payload, verify=False, allow_redirects=False, auth=(client_id, client_secret))

    print("[auth:setToken()] STATUS CODE: " + str(access_token_response.status_code))
    print("[auth:setToken()] RESPONSE: " + access_token_response.text)

    if access_token_response.status_code == 200:
        token_json_ecm_notify = access_token_response.json()
        #parsed_json = json.loads(access_token_response.text)
        print (token_json_ecm_notify)
        access_token = token_json_ecm_notify["access_token"]
        print token_json_ecm_notify["access_token"]

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
        "companyIdnone": [
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

def Create_Document_ECM():
    url = "https://api-garden-test.teliacompany.com/v1/finland/ecmdocument/document"
    jsonni =[{
      "type":"Agreement",
      "name":"test-agreement.pdf",
      "lifecycleState":"Approved",
      "version":"1",
      "creationDate":"2019-02-19T11:09:35.511Z",
      "lastUpdate":"2019-02-29T11:09:35.511Z",
      "product":"Daas",
      "language":"fi",
      "owner":"B2C Finland",
      "documentName":"docname",
      "sender":"Claudia",
      "characteristic":[
         {
            "name":"classification",
            "value":"Not classified"
         },
         {
            "name":"contractId",
            "value":"123456"
         },
         {
            "name":"documentId",
            "value":"09876"
         },
         {
            "name":"contractPartyMaster",
            "value":"Customer master system"
         },
         {
            "name":"contractStatus",
            "value":"Active"
         },
         {
            "name":"contractOrderType",
            "value":"Order"
         },
         {
            "name":"contractDealerCode",
            "value":"Avaaja"
         },
         {
            "name":"contractPartyId",
            "value":"9898971-7"
         },
         {
            "name":"contractParty",
            "value":"TESTI TSF PILOTTIYRITYS71"
         },
         {
            "name":"legacyId",
            "value":"legacyId"
         },
         {
            "name":"retentionPeriod",
            "value":"3"
         },
         {
            "name":"securityClassification",
            "value":"Confidential"
         },
         {
            "name":"validFrom",
            "value":"2018-02-19T11:19:19Z"
         },
         {
            "name":"validTo",
            "value":"2019-02-25T11:19:19Z"
         }
      ],
      "binaryAttachment":[
         {
            "mimeType":"application/pdf",
            "url":"https://telia-fi--dev--c.cs88.content.force.com/servlet/servlet.FileDownload?file=00P9E000002nYFd"
         }
      ],
      "category":[
         {
            "name":"Business"
         }
      ],
      "relatedParty":[
         {
            "role":"creator",
            "name":"asd12345"
         }
      ]
   }
]

    headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token_json_ecm['access_token'],
               'traceId': uuid.uuid4().hex}
    # headers = {}
    r = s.post(url, json=jsonni, headers=headers, verify=False)
    print(r)
    print(r.status_code)
    print("[auth:setToken()] STATUS CODE: " + str(r.status_code))
    print("[auth:setToken()] RESPONSE: " + r.text)

    if r.status_code == 200:
        parsed_json = json.loads(r.text)
        print parsed_json
        return r.status_code

def Get_validate_the_address():
    url = "https://api-garden-test.teliacompany.com/getAddress"
    jsonni ={
            "ValidateAddressRequest": {
                "RequestHeader": {
                    "Sender": {
                        "User": "CM1 TAS",
                        "Id": {
                            "type": "UserId",
                            "text": "tas-cm1-1"
                        }
                    },
                    "Receiver": {
                        "Country": "FIN"
                    },
                    "Timestamp": "2019-02-19T08:58:06.185+03:00",
                    "RequestId": "d5a75bc2-3a90-4a74-8ffa-d17c7b0e85c6"
                },
                "Address": {
                    "streetNrFirst": "2",
                    "streetName": "Telekatu",
                    "postcode": "00510",
                    "type": "PHYSICAL",
                    "category": "PHYSICAL"
                }
            }
        }


    headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token_json_address_validation['access_token'],
               'traceId': uuid.uuid4().hex}
    # headers = {}
    r = s.post(url, json=jsonni, headers=headers, verify=False)
    print(r)
    print(r.status_code)
    print("[auth:setToken()] STATUS CODE: " + str(r.status_code))
    print("[auth:setToken()] RESPONSE: " + r.text)

    if r.status_code == 200:
        parsed_json = json.loads(r.text)
        print parsed_json
        return r.status_code

def Get_resource_availability_in_address():
    url = "https://api-garden-test.teliacompany.com/v1/finland/resourceavailability/availabilityofall"
    jsonni ={
  "GetAvailabilityOfAllRequest":{
        "requestId":"123456",
        "townName":"Helsinki",
        "postalCode":"00510",
        "streetName":"Aleksis Kiven katu",
        "streetNumber":"25"
    }
}

    headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token_json_resource_availability['access_token'],
               'traceId': uuid.uuid4().hex}
    # headers = {}
    r = s.post(url, json=jsonni, headers=headers, verify=False)
    print(r)
    print(r.status_code)
    print("[auth:setToken()] STATUS CODE: " + str(r.status_code))
    print("[auth:setToken()] RESPONSE: " + r.text)

    if r.status_code == 200:
        parsed_json = json.loads(r.text)
        print parsed_json
        return r.status_code

def check_credit_score():
    url = "https://api-garden-test.teliacompany.com/v1/finland/creditscore"
    jsonni ={

    "header":{
      "timestamp":"2017-05-19T08:46:43.457+03:00",
      "sender":{
        "id":123,
        "name":"matti sarrinen",
      }
    },
    "creditScoreRequest":{
      "inquirer":"Laakko Jukka",
      "originalInquiringSystem":"Multibella",
      "language":"en",
      "productCategory":"BroadbandLowRisk",
      "usage":"1",
     "version":"3",
      "businessId":"1704967-9"
    }
}

    headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token_json_credit_score['access_token'],
               'traceId': uuid.uuid4().hex}
    # headers = {}
    r = s.post(url, json=jsonni, headers=headers, verify=False)
    print(r)
    print(r.status_code)
    print("[auth:setToken()] STATUS CODE: " + str(r.status_code))
    print("[auth:setToken()] RESPONSE: " + r.text)

    if r.status_code == 200:
        parsed_json = json.loads(r.text)
        print parsed_json
        return r.status_code

def create_product_order_sap():
    url = "https://api-garden-test.teliacompany.com/v1/finland/int/productorder"
    jsonni ={
    	"header": {
	    	"transactionId": "345frrwe3432423",
		    "timestamp": "2018-11-27T11:30:25-11:30",
		    "sender": {
			    "name": "Claudia"
		    },
		    "receivers": [{
			    "name": "SAP"
	        }],
	    	"messageId": "123456",
	    	"correlationId": "weqwe334234"
	        },
	"fileInformation": {
		"fileName": "SF31811270537420181127T113025-1130.xml",
		"fileEncoding": "UTF-8",
		"fileContentClassification": "Product",
        "fileContentAsString": "<OrderData><contractNumber>1010004096</contractNumber><Solita_System_Number>SF024781</Solita_System_Number><Solita_Order_Number>SF3181127053740001</Solita_Order_Number><System_Order_Number>2018-0002478</System_Order_Number><Parameter><Name>eventCreationDate</Name><Value>20181128T143506Z</Value></Parameter></OrderData><SapData><SapLine><Product_ID>5003441</Product_ID><lineType>mother</lineType><codeType>1</codeType></SapLine><SapLine><Product_ID>5003350</Product_ID><lineType>normal</lineType><codeType>1</codeType></SapLine><SapLine><Product_ID>5003352</Product_ID><lineType>normal</lineType><codeType>1</codeType></SapLine><SapLine><Product_ID>5008961</Product_ID><lineType>normal</lineType><codeType>1</codeType></SapLine><SapLine><Product_ID>5006393</Product_ID><lineType>normal</lineType><codeType>2</codeType></SapLine></SapData><OrderLine><OrderLineData><Parameter><Name>region</Name><Value>Muu</Value></Parameter><Parameter><Name>Customer_Order_ID</Name><Value>2018110000004351</Value></Parameter><Parameter><Name>OrderLineProfitCenter</Name><Value>116013</Value></Parameter><Parameter><Name>orderLanguage</Name><Value>fi</Value></Parameter><Parameter><Name>contractPeriod</Name><Value>02</Value></Parameter><Parameter><Name>attrFastDelivery</Name><Value>N</Value></Parameter><Parameter><Name>requestedDate</Name><Value>20181128T000000Z</Value></Parameter></OrderLineData><OrderLineInformation><Parameter><Name>additionalInfo</Name><Value>MTU: 1590. Class of service (CoS) : Standard (CoS L). E-NNI ID : 2222. Remember SAMI pop-up. Traffic report : Stat Bas. -. </Value></Parameter></OrderLineInformation><ConnectionData><Connection_Purpose>MEL</Connection_Purpose><Customer_Connection_ID>12345</Customer_Connection_ID><Parameter><Name>attrChangeType</Name><Value>Nopeuden nosto/lasku</Value></Parameter><Parameter><Name>attrSubscriberLine</Name><Value>Alueverkon kuitu/kupari</Value></Parameter><Parameter><Name>attrSpeed</Name><Value>23</Value></Parameter><Parameter><Name>aPostOffice</Name><Value>Helsinki</Value></Parameter><Parameter><Name>attrCos</Name><Value>10</Value></Parameter><Parameter><Name>aCompanyName</Name><Value>Telia Oyj</Value></Parameter><Parameter><Name>aCountry</Name><Value>FI</Value></Parameter><Parameter><Name>attrEthConnectionId</Name><Value>2222</Value></Parameter><Parameter><Name>attrVlanId</Name><Value>1</Value></Parameter><Parameter><Name>attrConnectionA</Name><Value>A25</Value></Parameter><Parameter><Name>attrAddressMEArea</Name><Value>MELO</Value></Parameter><Parameter><Name>attrMEAreaPP</Name><Value>MELO</Value></Parameter><Parameter><Name>attrMEArea</Name><Value>Def</Value></Parameter><Parameter><Name>aPostalCode</Name><Value>00510</Value></Parameter><Parameter><Name>attrPremiseShortName</Name><Value>Abc</Value></Parameter><Parameter><Name>attrPricingZone</Name><Value>ME00</Value></Parameter><Parameter><Name>attrPricingZonePP</Name><Value>ME00</Value></Parameter><Parameter><Name>aStreet</Name><Value>Teollisuuskatu</Value></Parameter><Parameter><Name>aStreetNumber</Name><Value>15</Value></Parameter><Parameter><Name>attrTrafficReport</Name><Value>Stat Bas</Value></Parameter><Parameter><Name>attrServiceLevel</Name><Value>22</Value></Parameter></ConnectionData></OrderLine></Order>"
    }
}

    headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token_json_sap['access_token'],
               'traceId': uuid.uuid4().hex}
    # headers = {}
    r = s.post(url, json=jsonni, headers=headers, verify=False)
    print(r)
    print(r.status_code)
    print("[auth:setToken()] STATUS CODE: " + str(r.status_code))
    print("[auth:setToken()] RESPONSE: " + r.text)

    if r.status_code == 200:
        parsed_json = json.loads(r.text)
        print parsed_json
        return r.status_code