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
    #
    # TODO(mierdin): while this script works for any vendor, the IP address replacement functionality using Jinja
    # below is specific to Junos. So, any other vendor device must use NAT for now. This should be easy to fix, though.
    # The best approach will be to provide interface_ip_details to the template, rather than a specific interface. Then,
    # the underlying config can specify the interface they want. The change here will be simple - the tedious work will
    # be updating all existing configs to use the new dictionary.

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
