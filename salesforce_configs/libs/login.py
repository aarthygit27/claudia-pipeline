# -*- coding: utf-8 -*-

import re, os

from http_adapter import TLS1_2HttpAdapter
import requests

def get_sessionId_and_serverUrl(server, dir, username="", password=""):
    url = "https://{0}.salesforce.com".format(server)
    body = ""
    with open(os.path.join(dir, "login.xml")) as f:
        for line in f:
            body += line
    body = body.replace("my_username", username)
    body = body.replace("my_password", password)

    session = requests.Session()
    session.mount(url, TLS1_2HttpAdapter())

    headers = {"Content-Type": "text/xml; charset=UTF-8",
                "SOAPAction": "login"}
    response = session.post(url + "/services/Soap/u/38.0", data=body, headers=headers)
    text = response.text.encode("utf-8")
    try:
        sessionId = re.search("<sessionId>(.*?)</sessionId>", text).group(1)
        serverUrl = re.search("<serverUrl>(.*?)</serverUrl>", text).group(1)
    except AttributeError:
        raise RuntimeError(text)

    return sessionId, serverUrl


if __name__ == "__main__":
    import sys
    try:
        server = sys.argv[1]
    except IndexError:
        server = "test"
    sessionId, serverUrl = get_sessionId_and_serverUrl(server, "..")
    print sessionId
    print serverUrl
