#!/usr/bin/env python3

# cRPD probably won't work for this, this uses an RPC that's not available.
# ./get-interface-from-arp-ip.py --devices=junos1:22 --username=root --password=antidotepassword --hosts=00:00:00:00:00:00

import xml.etree.ElementTree as ET
import sys
import json
from jnpr.junos import Device
import pprint
pp = pprint.PrettyPrinter(indent=4)



def out(*args):
    if sys.stdout.isatty():
        for dev, ints in args[0].items():
            print(dev + ": " + ', '.join(ints))
    else:
        print(json.dumps(args[0]))





def myfunc(*args):

    devices = args[0]["devices"]
    username = args[0]["username"][0]
    secret = args[0]["password"][0]
    hosts = args[0]["hosts"]

    arpinfo = {}
    for device in devices:
        dev, port = device.split(":")

        handle = Device(host=dev, port=port, user=username, passwd=secret)
        handle.open()
        devname = handle.rpc.get_system_information().find('host-name').text


        for host in hosts:
            arptable = handle.rpc.get_arp_table_information(hostname=str(host))
            for intname in arptable.findall("./arp-table-entry/interface-name"):
                if devname in arpinfo:
                    arpinfo[devname].append(intname.text.strip())
                else:
                    arpinfo[devname] = [intname.text.strip()]

    out(arpinfo)



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