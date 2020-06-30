#!/usr/bin/env python

import sys
import napalm
from jinja2 import FileSystemLoader, Environment

user = sys.argv[1]
password = sys.argv[2]
vendor = sys.argv[3]
port = sys.argv[4]
host = sys.argv[5]
template_file = sys.argv[6]

driver = napalm.get_network_driver(vendor)
with driver(hostname=host, username=user, password=password, optional_args={'port': port}) as device:
    device.load_merge_candidate(filename=template_file)
    device.commit_config()

