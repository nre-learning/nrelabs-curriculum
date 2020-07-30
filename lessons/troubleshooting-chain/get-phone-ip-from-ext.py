#!/usr/bin/env python3

import requests
import xml.etree.ElementTree as ET
import sys
import json


def out(*args):
    if sys.stdout.isatty():
        print(', '.join(args[0]["hosts"]))
    else:
        print(json.dumps(args[0]))


def myfunc(*args):

    host = args[0]["host"][0]
    port = args[0]["port"][0]
    username = args[0]["username"][0]
    secret = args[0]["password"][0]
    phone = args[0]["phone"][0]

    baseurl = "http://" + host + ":" + port + "/mxml"

    params = {"action": "login", "username": username, "secret": secret}

    resp = requests.get(baseurl, params=params)

    cookies = resp.cookies

    resp = requests.get(baseurl, cookies=cookies, params={"action": "PJSIPShowRegistrationInboundContactStatuses"})

    root = ET.fromstring(resp.content.decode('ascii'))

    contacts = root.findall(".//*[@event='ContactStatusDetail']")

    result = None
    for contact in contacts:
        if contact.get("aor") == phone:
            result = contact.get("viaaddress").split(":")[0]
            break

    if result:
        out({"hosts": [result]})


myfunc_args = dict()

if not sys.stdin.isatty():
    for line in sys.stdin:
        lined = json.loads(line)
        for k, v in lined.items():
            if k in myfunc_args:
                myfunc_args[k] += v
            else:
                myfunc_args[k] = v

for arg in sys.argv[1:]:
    kvp = arg.split("--", 1)[1].split("=", 1)
    k = kvp[0]
    v = kvp[1].split(",")
    if k in myfunc_args:
        myfunc_args[k] += v
    else:
        myfunc_args[k] = v

myfunc(myfunc_args)
