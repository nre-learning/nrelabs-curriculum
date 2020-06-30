#!/usr/bin/env python

import os
import sys
import napalm
from jinja2 import FileSystemLoader, Environment

user = "root"
password = "antidotepassword"
vendor = "junos"
port = 22
host = os.environ['ANTIDOTE_TARGET_HOST']
config_file = "/antidote/stage0/configs/junos1.txt"

driver = napalm.get_network_driver(vendor)
with driver(hostname=host, username=user, password=password, optional_args={'port': port}) as device:
    device.load_merge_candidate(filename=config_file)
    device.commit_config()
