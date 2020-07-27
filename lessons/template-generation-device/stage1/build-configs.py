#!/usr/bin/env python3

import yaml
from jinja2 import Template

var_file = open('variables.yml')
var_data = var_file.read()
my_vars = yaml.full_load(var_data)

template_file = open('template.j2')
template_data = template_file.read()
template = Template(template_data)

for device in my_vars:
	print("Creating config for " + device["HOSTNAME"])
	outfile = open(device["HOSTNAME"] + ".conf", "w")
	outfile.write(template.render(device))
	outfile.close()

## End of script ##
