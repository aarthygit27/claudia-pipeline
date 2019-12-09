import requests
import requests.auth
import json
import os
import base64
import datetime as dt
import random
import uuid
import time

s = requests.Session()
auth ={
        "username":"ulm-testers",
        "password":"Pc5q7Pqbtsd1NZiIq34gsuhrpMDC9rjo"
  }
json_sadmin ={
      "username":"devops_sadmin",
      "credential":"1111"
  }
json_b2o_adm = {
      "username": "b2o-adm@mailinator.com",
      "credential": "PaSsw0rd321"
  }

json_user_sowmi = {
      "username": "sowmiya.narayanan@mailinator.com",
      "credential": "PaSsw0rd321"
  }
def CSR_session_start():
  url = "https://int.id.telia.fi/admin/rest/v60/admin/session"
  headers = {'Content-Type': 'application/json','Authorization':str(auth),'traceId': uuid.uuid4().hex}
  response = s.post(url, json=json_sadmin, headers=headers, verify=False)

  print("[auth:setToken()] STATUS CODE: "+ str(response.status_code))
  print("[auth:setToken()] RESPONSE: " + response.text)

  return response.status_code

def session_end():
  url = "https://int.id.telia.fi/admin/rest/v60/session/end"
  headers = {'Content-Type': 'application/json','Authorization': str(auth),'traceId': uuid.uuid4().hex}
  response = s.get(url, headers=headers, verify=False)
  print("[auth:setToken()] STATUS CODE: " + str(response.status_code))

  return response.status_code

def user_session_start():
  url = "https://int.id.telia.fi/rest/v60/session/start"
  headers = {'Content-Type': 'application/json','Authorization':str(auth),'traceId': uuid.uuid4().hex}

  response = s.post(url, json=json_b2o_adm, headers=headers, verify=False)

  print("[auth:setToken()] STATUS CODE: "+ str(response.status_code))
  print("[auth:setToken()] RESPONSE: " + response.text)

  return response.status_code

def user_session_start_sowmi():
  url = "https://int.id.telia.fi/rest/v60/session/start"
  headers = {'Content-Type': 'application/json','Authorization':str(auth),'traceId': uuid.uuid4().hex}

  response = s.post(url, json=json_user_sowmi, headers=headers, verify=False)

  print("[auth:setToken()] STATUS CODE: "+ str(response.status_code))
  print("[auth:setToken()] RESPONSE: " + response.text)

  return response.status_code

def user_account_details():
  url = "https://int.id.telia.fi/rest/v60/user/10200"
  headers = {'Content-Type': 'application/json','Authorization':str(auth),'traceId': uuid.uuid4().hex}

  response = s.get(url, json=json_b2o_adm, headers=headers, verify=False)

  print("[auth:setToken()] STATUS CODE: "+ str(response.status_code))
  print("[auth:setToken()] RESPONSE: " + response.text)

  return response.status_code

def user_group_details():
  url = "https://int.id.telia.fi/rest/v60/user/groups"
  headers = {'Content-Type': 'application/json','Authorization':str(auth),'traceId': uuid.uuid4().hex}

  response = s.get(url, json=json_b2o_adm, headers=headers, verify=False)

  print("[auth:setToken()] STATUS CODE: "+ str(response.status_code))
  print("[auth:setToken()] RESPONSE: " + response.text)

  return response.status_code

def user_group_user_list():
  url = "https://int.id.telia.fi/rest/v60/group/6300/users"
  headers = {'Content-Type': 'application/json','Authorization':str(auth),'traceId': uuid.uuid4().hex}

  response = s.get(url, json=json_b2o_adm, headers=headers, verify=False)

  print("[auth:setToken()] STATUS CODE: "+ str(response.status_code))
  print("[auth:setToken()] RESPONSE: " + response.text)

  return response.status_code

def user_group_membership_details():
  url = "https://int.id.telia.fi/rest/v60/group/6300/memberships"
  headers = {'Content-Type': 'application/json','Authorization':str(auth),'traceId': uuid.uuid4().hex}

  response = s.get(url, json=json_b2o_adm, headers=headers, verify=False)

  print("[auth:setToken()] STATUS CODE: "+ str(response.status_code))
  print("[auth:setToken()] RESPONSE: " + response.text)

  return response.status_code

def update_profile_by_self_start():
  url = "https://int.id.telia.fi/rest/v60/group/6300/memberships"
  headers = {'Content-Type': 'application/json','Authorization':str(auth),'traceId': uuid.uuid4().hex}

  response = s.get(url, json=json_b2o_adm, headers=headers, verify=False)

  print("[auth:setToken()] STATUS CODE: "+ str(response.status_code))
  print("[auth:setToken()] RESPONSE: " + response.text)

  return response.status_code

def update_profile_by_self_execute():
  url = "https://int.id.telia.fi/rest/v60/group/6300/memberships"
  headers = {'Content-Type': 'application/json','Authorization':str(auth),'traceId': uuid.uuid4().hex}

  response = s.get(url, json=json_b2o_adm, headers=headers, verify=False)

  print("[auth:setToken()] STATUS CODE: "+ str(response.status_code))
  print("[auth:setToken()] RESPONSE: " + response.text)

  return response.status_code