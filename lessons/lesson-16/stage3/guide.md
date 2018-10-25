# Using Jinja for Configuration Templates
## Part 3 - Let try the if and set statements!

Now that you have tried the for loop, lets up-level. In this part we will try if and set statement along with for loops.



First, we want to start the Python interpreter and import Template module from Jinja2 library:

```
python
from jinja2 import Template
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

Similar to Part2, lets define a list of dictionary with interface and ip_address as the keys.


```
interfaces = [{'interface': 'ge-0/0/0', 'ip_address': '192.168.1.1'},
              {'interface': 'ge-0/0/1', 'ip_address': '10.10.1.1'},
              {'interface': 'fxp0', 'ip_address': '172.16.1.1'}]

```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

Unlike Part2, we dont want to generate configurations for all interfaces. We only want to generate configuration for the management IP address. 
For this we can use the if condition, if the interface value matches the our management interface (fxp0) 
then only generate the config. 

Jinja2 if statement for checking conditions:  
  *Syntax:*   
  *{% if condition %}*  
  *...*  
  *{% endif %}*  

Run the below snippet to see the if condition in action.

```

ipaddr_template = Template('''
{% for item in interfaces %}
interfaces {
    {%- if item.interface == 'fxp0' %}
    {{ item.interface }} {
        unit 0 {
            family inet {
                address {{item.ip_address}};
            }
        }
    }
    {% endif %}
}
{% endfor %}''')

render_1 = ipaddr_template.render(interfaces=interfaces)
print(str(render_1))

```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>


This is good. But what if we decide to change the management interface to ge-0/0/0. One approch is to change the 'fxp0' by 'ge-0/0/0' in the if statement.
A better approch is to define a variable called mgmt_interface and, change the value of this variable when we decide to change the management interface.

Jinja2 uses set statement to define variable which can be used within the template.
  *Syntax:*   
  *{% set variable_name: variable_value %}*

Run the snippet below to understand the use of set statements.

```

set_temp = '''{% set mgmt_interface = 'ge-0/0/0' %}
{% for item in interfaces %}
interfaces {
    {%- if item.interface == mgmt_interface %}
    {{ item.interface }} {
        unit 0 {
            family inet {
                address {{item.ip_address}};
            }
        }
    }
    {% endif %}
}
{% endfor %}'''

int_template = Template(set_temp)
render_2 = int_template.render(interfaces=interfaces)

print(str(render_2))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

In the next stage, we'll dive a little deeper into using YAML files for defining variables for Jinja2 templates.
