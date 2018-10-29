#!/usr/bin/env python
from __future__ import print_function
import paramiko
import socket
import sys
import re
import xml.etree.ElementTree as ET

if len(sys.argv) <= 1:
    print("Usage: %s <target>\n" % sys.argv[0])
    sys.exit()
    
hostname = sys.argv[1]

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

uptime_rpc = '''<rpc>
    <get-system-uptime-information/>
</rpc>'''
close_rpc = '''<rpc>
    <close-session/>
</rpc>'''

socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
socket.connect((hostname, 22))

trans = paramiko.Transport(socket)
trans.connect(username='root', password='VR-netlab9')

ch = trans.open_session()
name = ch.set_name('netconf')
ch.invoke_subsystem('netconf')
ch.send(uptime_rpc)

data = ch.recv(2048)
while data:
    data += ch.recv(1024)
    if data.find('</nc:rpc-reply>') >= 0:
        ch.send(close_rpc)
        break

match = re.search('(<nc:rpc-reply[^>]*>.*</nc:rpc-reply>)', data, re.DOTALL)
if match:
    response_xml = match.groups()[0]
    print('Server request:\n%s\n' % uptime_rpc)
    print('Server response:\n%s\n' % response_xml)
    
    response = re.sub('(nc:)|(xmlns([^=]+)?="[^"]+")|(junos:)|(ns0:)', '', response_xml)
    response = ET.fromstring(response)

    uptime = response.findtext('.//system-uptime-information/uptime-information/up-time')
    uptime = uptime.strip()

    print("Uptime: " + uptime + "\n")

ch.close()
trans.close()
socket.close()
