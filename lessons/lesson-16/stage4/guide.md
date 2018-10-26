# Using Jinja for Configuration Templates
## Part 4 - Jinja2 with YAML 

In this part we will give go over how you can import data from a YAML file and render Jinja2 tempate.

In the previous parts we have used a list of dictionaries and generating configs for multiple interfaces.
This is a very cumbersome way of modeling your data. Is there a better way for data serialiation?

Yes!!! YAML provides a humman readable way for data serialization.
YAML provides a easy way of defining list and dictionaries. 

Lets start off by taking a look at the YAML file. 
```
cd /antidote/lessons/lesson-16/stage4/
cat part4.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

Next, like previous parts, we want to start the Python interpreter and import Template module from Jinja2 library.
We are also import the yaml library and pprint for pretty printing our output.

```

python
from jinja2 import Template
import yaml
from pprint import pprint
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

The data from the YAML file can easily be imported into Python simply by opening the yaml file and using yaml.load function.

```

yaml_file = open('part4.yml', 'r')
all_devices = yaml.load(yaml_file)
pprint(all_devices)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>

Does this output look familier to you. Its a dictionay containing a list of dictionary.

We are now going to define a config template using the jinja2 Template module to set the system hostname and obtain the interface config.

```

config_temp = Template("""
system {
    host-name {{ device.hostname }};
}
{% for item  in device.interface %}
interfaces {
    {{ item.name }} {
        unit {{ item.unit }} {
            family inet {
                address {{ item.ip_address }};
            }
        }
    }
}
{% endfor %}
""")


```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

We will render the config tempelate for each device specefied in the YAML file.
Python enumerate function keeps a count of loop index so that we can print the loop index.

```

for dev_number, device in enumerate(all_devices['devices'], 1):
    render_1 = config_temp.render(device=device)
    print('Configuration for Device %s' % (dev_number))
    print('-'*30)
    print(str(render_1))

```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 4)">Run this snippet</button>

As a up level we can directly provide Jinja2 tempalates and variables to PyEz and push these configs on to a Junos device.
