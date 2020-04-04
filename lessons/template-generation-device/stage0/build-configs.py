#!/usr/bin/python

import yaml
from jinja2 import Template

var_file = open('variables.yml')
var_data = var_file.read()
my_vars = yaml.full_load(var_data)

template_file = open('template.j2')
template_data = template_file.read()
template = Template(template_data)

print(template.render(my_vars))

## End of script ##
