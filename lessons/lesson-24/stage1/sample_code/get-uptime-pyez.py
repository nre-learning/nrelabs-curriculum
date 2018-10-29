#!/usr/bin/env python
from __future__ import print_function
import sys
from jnpr.junos import Device
from lxml import etree

if len(sys.argv) <= 1:
    print("Usage: %s <target>\n" % sys.argv[0])
    sys.exit()
    
hostname = sys.argv[1]

dev = Device(hostname, user='root', passwd='VR-netlab9', port=22, gather_facts=False, normalize=True)
dev.open()

response = dev.rpc.get_system_uptime_information()
print('Server response:')
etree.dump(response)

uptime = response.findtext('.//uptime-information/up-time')

print("\nUptime: " + uptime + "\n");
