#!/usr/bin/env python
from __future__ import print_function
import sys
import re
from ncclient import manager
import xml.etree.ElementTree as ET

if len(sys.argv) <= 1:
    print("Usage: %s <target>\n" % sys.argv[0])
    sys.exit()
    
hostname = sys.argv[1]

conn = manager.connect(host=hostname, username='root', password='VR-netlab9', port=22, hostkey_verify=False)

query = 'get-system-uptime-information'
response_nc = conn.dispatch(query)

print('Server request:\n<rpc>\n    <%s>\n</rpc>\n' % query)
print('Server response:\n%s\n' % response_nc.xml)

response_xml = re.sub('(nc:)|(xmlns([^=]+)?="[^"]+")|(junos:)|(ns0:)', '', response_nc.xml)
response = ET.fromstring(response_xml)

uptime = response.findtext('.//system-uptime-information/uptime-information/up-time')
uptime = uptime.strip()

print("Uptime: " + uptime + "\n")

try: conn.close_session()
except: pass
