#!/usr/bin/env python3

import yaml
from jinja2 import Template

var_file = open('vlans.yml')
var_data = var_file.read()
my_vars = yaml.full_load(var_data)

template_file = open('template.j2')
template_data = template_file.read()
template = Template(template_data)

outfile = open("new-vlans.conf", "w")
outfile.write(template.render(my_vars))
outfile.close()

## End of script ##
