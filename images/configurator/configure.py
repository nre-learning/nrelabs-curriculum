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

config_path = template_file[:template_file.rfind("/")+1]
config_file = template_file[template_file.rfind("/")+1:]

driver = napalm.get_network_driver(vendor)
with driver(hostname=host, username=user, password=password, optional_args={'port': port}) as device:

    # Retrieve management IP address
    # TODO(mierdin): this is junos-specific. Will need to maintain a list of management interfaces per vendor,
    # or expose this as a field in the endpoint.
    interface_ip_details = device.get_interfaces_ip()['em0.0']
    for addr, prefix in interface_ip_details['ipv4'].items():
        address_cidr = "%s/%s" % (addr, prefix['prefix_length'])

    # Create template configuration with this address
    loader = FileSystemLoader([config_path])
    env = Environment(loader=loader, trim_blocks=True, lstrip_blocks=True)
    template_object = env.get_template(config_file)
    rendered_config = template_object.render(mgmt_addr=address_cidr)

    # Push rendered config to device
    device.load_merge_candidate(config=rendered_config)
    device.commit_config()
