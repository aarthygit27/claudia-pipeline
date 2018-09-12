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
    token_url = "http://api-garden-test.teliacompany.com/oauth/client_credential/accesstoken?grant_type=client_credentials"
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
    token_url = "http://api-garden-test.teliacompany.com/oauth/client_credential/accesstoken?grant_type=client_credentials"
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
    token_url = "http://api-garden-uat.teliacompany.com/oauth/client_credential/accesstoken?grant_type=client_credentials"
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
    url = "https://api-garden-test.teliacompany.com/v1/finland/creditscore"
	
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
    url = "https://api-garden-test.teliacompany.com/v1/finland/ULMUserManagement/createCompanyUser"
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
    url = "https://api-garden-test.teliacompany.com/v1/finland/ULMUserManagement/updateCompanyUser"
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
    url = "https://api-garden-uat.teliacompany.com/v1/finland/service/order"
    jsonni = {
  "serviceOrderRequest": {
    "serviceOrder": [
      {
        "serviceOrderItem": [
          {
            "service": {
              "serviceState": "INACTIVE"
            },
            "requestedStartDate": "2018-01-19",
            "requestedCompletionDate": "2018-01-19",
            "product": {
              "productSpecification": {
                "name": "TS_prod_H_DataCenter"
              },
              "id": "8025E000000HdV9QAK",
              "description": "PS-HDC",
              "assetId": "8025E000000HdV6QAKSS",
              "commercialId": "8025E000s00HdV6QAKSS",
              "dateofAction": "2018-01-19"
            },
            "note": {
              "text": ""
            },
            "action": "Add"
          },
          {
            "serviceOrderItemRelationship": [
              {
                "type": "INCLUDED_BY",
                "id": "8025E000000HdV9QAK"
              }
            ],
            "service": {
              "serviceState": "INACTIVE"
            },
            "requestedStartDate": "2018-01-19",
            "requestedCompletionDate": "2018-01-19",
            "product": {
              "productSpecification": {
                "productSpecCharacteristic": [
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_Transferprovider"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_Secureroom"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_Cabinetreservation"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_powercoolingcapacity12RU"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_powercoolingcapacity52RU"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_CabinetClassified"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_ClassifiedSpace"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_PDUdefault"
                  },
                  {
                    "name": "TS_char_HDC_AssetId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "cab52assetid"
                      }
                    ]
                  },
                  {
                    "name": "TS_char_HDC_CommercialId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "cab52commercialid"
                      }
                    ]
                  }
                ],
                "name": "TS_prod_HDC_Cabinet52RU_B2O"
              },
              "id": "8025E000000HdV6QAK",
              "description": "PS-Cabinet 52 RU-B2O",
              "assetId": "8025E000000HdV6QAKSS",
              "commercialId": "8025E000s00HdV6QAKSS",
              "dateofAction": "2018-01-19"
            },
            "note": {
              "text": ""
            },
            "action": "Add"
          },
          {
            "serviceOrderItemRelationship": [
              {
                "type": "INCLUDED_BY",
                "id": "8025E000000HdV6QAK"
              }
            ],
            "service": {
              "serviceState": "INACTIVE"
            },
            "requestedStartDate": "2018-01-19",
            "requestedCompletionDate": "2018-01-19",
            "product": {
              "productSpecification": {
                "productSpecCharacteristic": [
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_12PDUtype"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "Perus"
                      }
                    ],
                    "name": "TS_char_HDC_52PDUtype"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_PDUdefault"
                  },
                  {
                    "name": "TS_char_HDC_AssetId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "pdu52assetid"
                      }
                    ]
                  },
                  {
                    "name": "TS_char_HDC_CommercialId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "pdu52commercialid"
                      }
                    ]
                  }
                ],
                "name": "TS_prod_HDC_add52PDU"
              },
              "id": "8025E000000HdVAQA0",
              "description": "PS-Additional PDU for 52 RU",
              "assetId": "8025E000000HdV6QAKSS",
              "commercialId": "8025E000s00HdV6QAKSS",
              "dateofAction": "2018-01-19"
            },
            "note": {
              "text": ""
            },
            "action": "Add"
          },
          {
            "serviceOrderItemRelationship": [
              {
                "type": "INCLUDED_BY",
                "id": "8025E000000HdV6QAK"
              }
            ],
            "service": {
              "serviceState": "INACTIVE"
            },
            "requestedStartDate": "2018-01-19",
            "requestedCompletionDate": "2018-01-19",
            "product": {
              "productSpecification": {
                "productSpecCharacteristic": [
                  {
                    "name": "TS_char_HDC_AssetId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "powerassetid"
                      }
                    ]
                  },
                  {
                    "name": "TS_char_HDC_CommercialId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "powercommercialid"
                      }
                    ]
                  }
                ],
                "name": "TS_prod_HDC_AddPowerFeeds"
              },
              "id": "8025E000000HdV1QAK",
              "description": "PS-Additional power feeds, 400 VAC, 3-phase 16A, 32A (A2 + B2)",
              "assetId": "8025E000000HdV6QAKSS",
              "commercialId": "8025E000s00HdV6QAKSS",
              "dateofAction": "2018-01-19"
            },
            "note": {
              "text": ""
            },
            "action": "Add"
          },
          {
            "serviceOrderItemRelationship": [
              {
                "type": "INCLUDED_BY",
                "id": "8025E000000HdV6QAK"
              }
            ],
            "service": {
              "serviceState": "INACTIVE"
            },
            "requestedStartDate": "2018-01-19",
            "requestedCompletionDate": "2018-01-19",
            "product": {
              "productSpecification": {
                "productSpecCharacteristic": [
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "ODF 1 24k, takana"
                      }
                    ],
                    "name": "TS_char_HDC_fiberconnection"
                  },
                  {
                    "name": "TS_char_HDC_AssetId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "fibreassetid"
                      }
                    ]
                  },
                  {
                    "name": "TS_char_HDC_CommercialId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "fibrecommercialid"
                      }
                    ]
                  }
                ],
                "name": "TS_prod_HDC_FibreOpticConnection"
              },
              "id": "8025E000000HdV8QAK",
              "description": "PS-Fibre-optic conn, 24 fibres",
              "assetId": "8025E000000HdV6QAKSS",
              "commercialId": "8025E000s00HdV6QAKSS",
              "dateofAction": "2018-01-19"
            },
            "note": {
              "text": ""
            },
            "action": "Add"
          },
          {
            "serviceOrderItemRelationship": [
              {
                "type": "INCLUDED_BY",
                "id": "8025E000000HdV6QAK"
              }
            ],
            "service": {
              "serviceState": "INACTIVE"
            },
            "requestedStartDate": "2018-01-19",
            "requestedCompletionDate": "2018-01-19",
            "product": {
              "productSpecification": {
                "productSpecCharacteristic": [
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": ""
                      }
                    ],
                    "name": "TS_char_HDC_cabinetB"
                  },
                  {
                    "name": "TS_char_HDC_AssetId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "cablingassetid"
                      }
                    ]
                  },
                  {
                    "name": "TS_char_HDC_CommercialId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "cablingcommercialid"
                      }
                    ]
                  }
                ],
                "name": "TS_prod_HDC_CablingFibres24SM"
              },
              "id": "8025E000000HdUzQAK",
              "description": "PS-Cabling, 24 fibres, SM",
              "assetId": "8025E000000HdV6QAKSS",
              "commercialId": "8025E000s00HdV6QAKSS",
              "dateofAction": "2018-01-19"
            },
            "note": {
              "text": ""
            },
            "action": "Add"
          },
          {
            "serviceOrderItemRelationship": [
              {
                "type": "INCLUDED_BY",
                "id": "8025E000000HdV9QAK"
              }
            ],
            "service": {
              "serviceState": "INACTIVE"
            },
            "requestedStartDate": "2018-01-19",
            "requestedCompletionDate": "2018-01-19",
            "product": {
              "productSpecification": {
                "productSpecCharacteristic": [
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_Transferprovider"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "Palotila 1"
                      }
                    ],
                    "name": "TS_char_HDC_Secureroom"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_Cabinetreservation"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "1,6 kW"
                      }
                    ],
                    "name": "TS_char_HDC_powercoolingcapacity12RU"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": ""
                      }
                    ],
                    "name": "TS_char_HDC_powercoolingcapacity52RU"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_CabinetClassified"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_ClassifiedSpace"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_PDUdefault"
                  },
                  {
                    "name": "TS_char_HDC_AssetId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "cab12assetid"
                      }
                    ]
                  },
                  {
                    "name": "TS_char_HDC_CommercialId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "cab12commercialid"
                      }
                    ]
                  }
                ],
                "name": "TS_prod_HDC_Cabinet12RU"
              },
              "id": "8025E000000HdV2QAK",
              "description": "PS-Cabinet 12 RU",
              "assetId": "8025E000000HdV6QAKSS",
              "commercialId": "8025E000s00HdV6QAKSS",
              "dateofAction": "2018-01-19"
            },
            "note": {
              "text": ""
            },
            "action": "Add"
          },
          {
            "serviceOrderItemRelationship": [
              {
                "type": "INCLUDED_BY",
                "id": "8025E000000HdV2QAK"
              }
            ],
            "service": {
              "serviceState": "INACTIVE"
            },
            "requestedStartDate": "2018-01-19",
            "requestedCompletionDate": "2018-01-19",
            "product": {
              "productSpecification": {
                "productSpecCharacteristic": [
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": ""
                      }
                    ],
                    "name": "TS_char_HDC_cabinetB"
                  },
                  {
                    "name": "TS_char_HDC_AssetId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "neteassetid"
                      }
                    ]
                  },
                  {
                    "name": "TS_char_HDC_CommercialId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "netcommercialid"
                      }
                    ]
                  }
                ],
                "name": "TS_prod_HDC_NetworkODFconnection"
              },
              "id": "8025E000000HdV0QAK",
              "description": "PS-In-house cabling between cabinets in the same data hall",
              "assetId": "8025E000000HdV6QAKSS",
              "commercialId": "8025E000s00HdV6QAKSS",
              "dateofAction": "2018-01-19"
            },
            "note": {
              "text": ""
            },
            "action": "Add"
          },
          {
            "serviceOrderItemRelationship": [
              {
                "type": "INCLUDED_BY",
                "id": "8025E000000HdV9QAK"
              }
            ],
            "service": {
              "serviceState": "INACTIVE"
            },
            "requestedStartDate": "2018-01-19",
            "requestedCompletionDate": "2018-01-19",
            "product": {
              "productSpecification": {
                "productSpecCharacteristic": [
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_Transferprovider"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "Palotila 1"
                      }
                    ],
                    "name": "TS_char_HDC_Secureroom"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_Cabinetreservation"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_powercoolingcapacity12RU"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "6,5 kW"
                      }
                    ],
                    "name": "TS_char_HDC_powercoolingcapacity52RU"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_CabinetClassified"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_ClassifiedSpace"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "Perus"
                      }
                    ],
                    "name": "TS_char_HDC_PDUdefault"
                  },
                  {
                    "name": "TS_char_HDC_AssetId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "cusassetid"
                      }
                    ]
                  },
                  {
                    "name": "TS_char_HDC_CommercialId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "cuscommercialid"
                      }
                    ]
                  }
                ],
                "name": "TS_prod_HDC_Customercabinet"
              },
              "id": "8025E000000HdV3QAK",
              "description": "PS-HDC_CustomerCabinet",
              "assetId": "8025E000000HdV6QAKSS",
              "commercialId": "8025E000s00HdV6QAKSS",
              "dateofAction": "2018-01-19"
            },
            "note": {
              "text": ""
            },
            "action": "Add"
          },
          {
            "serviceOrderItemRelationship": [
              {
                "type": "INCLUDED_BY",
                "id": "8025E000000HdV3QAK"
              }
            ],
            "service": {
              "serviceState": "INACTIVE"
            },
            "requestedStartDate": "2018-01-19",
            "requestedCompletionDate": "2018-01-19",
            "product": {
              "productSpecification": {
                "productSpecCharacteristic": [
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_12PDUtype"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_52PDUtype"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "Vaiheittain"
                      }
                    ],
                    "name": "TS_char_HDC_PDUdefault"
                  },
                  {
                    "name": "TS_char_HDC_AssetId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "pduxassetid"
                      }
                    ]
                  },
                  {
                    "name": "TS_char_HDC_CommercialId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "pduxcommercialid"
                      }
                    ]
                  }
                ],
                "name": "TS_prod_HDC_PDU"
              },
              "id": "8025E000000HdV5QAK",
              "description": "PS-PDU",
              "assetId": "8025E000000HdV6QAKSS",
              "commercialId": "8025E000s00HdV6QAKSS",
              "dateofAction": "2018-01-19"
            },
            "note": {
              "text": ""
            },
            "action": "Add"
          },
          {
            "serviceOrderItemRelationship": [
              {
                "type": "INCLUDED_BY",
                "id": "8025E000000HdV9QAK"
              }
            ],
            "service": {
              "serviceState": "INACTIVE"
            },
            "requestedStartDate": "2018-01-19",
            "requestedCompletionDate": "2018-01-19",
            "product": {
              "productSpecification": {
                "productSpecCharacteristic": [
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_Transferprovider"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_Secureroom"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_Cabinetreservation"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_powercoolingcapacity12RU"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_powercoolingcapacity52RU"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_CabinetClassified"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {
                        "value": "false"
                      }
                    ],
                    "name": "TS_char_HDC_ClassifiedSpace"
                  },
                  {
                    "productSpecCharacteristicValue": [
                      {}
                    ],
                    "name": "TS_char_HDC_PDUdefault"
                  },
                  {
                    "name": "TS_char_HDC_AssetId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "hallassetid"
                      }
                    ]
                  },
                  {
                    "name": "TS_char_HDC_CommercialId",
                    "productSpecCharacteristicValue": [
                      {
                        "value": "hallcommercialid"
                      }
                    ]
                  }
                ],
                "name": "TS_prod_HDC_DedicatedDataHall"
              },
              "id": "8025E000000HdV7QAK",
              "description": "PS-Dedicated data hall",
              "assetId": "8025E000000HdV6QAKSS",
              "commercialId": "8025E000s00HdV6QAKSS",
              "dateofAction": "2018-01-19"
            },
            "note": {
              "text": ""
            },
            "action": "Add"
          }
        ],
        "organization": [
          {
            "systemIdentification": {
              "name": "AIDA",
              "id": "002512014"
            },
            "place": [
              {
                "address": {
                  "streetName": "Teollisuuskatu 15",
                  "postcode": "00510",
                  "locality": "Helsinki",
                  "format": "PHYSICAL",
                  "countryCode": "FI"
                }
              }
            ],
            "partyRole": {
              "name": "SUBSCRIBER"
            },
            "partyId": "0015E00000Eo5CrQAJ",
            "organizationName": [
              {
                "tradingName": "TestAccount"
              }
            ],
            "businessIdIdentification": {
              "businessId": "TestBusinessId"
            }
          }
        ],
        "orderDate": dt.datetime.now().isoformat(),
        "individual": [
          {
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
              "id": "Accenture"
            },
            "individualName": [
              {
                "givenNames": "Heimo",
                "familyNames": "Tiihonen",
                "formattedName": "Heimo Tiihonen"
              }
            ],
            "contactMedium": [
              {
                "phoneNumber": [
                  {
                    "type": "PHONE",
                    "phoneNumber": "+35811111111"
                  }
                ],
                "emailContact": [
                  {
                    "eMailAddress": "vinitha.menon@teliacompany.com"
                  }
                ]
              }
            ]
          }
        ],
        "externalId": "8015E0000002R5DQAU",
        "characteristic": [
          {
            "name": "TS_CUSTOMER_ID",
            "characteristicValue": [
              {
                "value": "00558000001vbsRAAQ"
              }
            ]
          },
          {
            "name": "cpPreferredLanguage",
            "characteristicValue": [
              {
                "value": "Finnish"
              }
            ]
          },
          {
            "name": "contractId",
            "characteristicValue": [
              {
                "value": "8005E000000XF9AQAW"
              }
            ]
          },
          {
            "name": "contractStartDate",
            "characteristicValue": [
              {
                "value": ""
              }
            ]
          },
          {
            "name": "contractEndDate",
            "characteristicValue": [
              {
                "value": ""
              }
            ]
          },
          {
            "name": "contractSLA",
            "characteristicValue": [
              {
                "value": "Standard"
              }
            ]
          }
        ]
      }
    ],
    "header": {
      "timestamp": dt.datetime.now().isoformat(),
      "sender": {
        "systemId": "CLAUDIA"
      },
      "receiver": [
        {
          "systemId": "DDM"
        }
      ],
      "operation": "CREATE",
      "messageId": "CLAUDIA-8015E0000002R5DQAU"
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
    url = "https://api-garden-uat.teliacompany.com/v1/finland/service/order"
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