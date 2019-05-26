#!/usr/bin/env python

import sys, os
import napalm
from jinja2 import FileSystemLoader, Environment

user = "antidote"
password = "antidotepassword"
vendor = "junos"
port = "22"
host = os.getenv("SYRINGE_TARGET_HOST")
template_file = "vqfx1.txt"

driver = napalm.get_network_driver(vendor)
with driver(hostname=host, username=user, password=password, optional_args={'port': port}) as device:

    # Retrieve management IP address
    # TODO(mierdin): this is junos-specific. Will need to maintain a list of management interfaces per vendor,
    # or expose this as a field in the endpoint.
    interface_ip_details = device.get_interfaces_ip()['em0.0']
    for addr, prefix in interface_ip_details['ipv4'].items():
        address_cidr = "%s/%s" % (addr, prefix['prefix_length'])

    # Create template configuration with this address
    loader = FileSystemLoader([os.path.dirname(os.path.realpath(__file__))])  # Use current directory
    env = Environment(loader=loader, trim_blocks=True, lstrip_blocks=True)
    template_object = env.get_template(template_file)
    rendered_config = template_object.render(mgmt_addr=address_cidr)

    # Push rendered config to device
    device.load_replace_candidate(config=rendered_config)
    device.commit_config()
