# Using Jinja for Configuration Templates
## Part 4 - Jinja2 with YAML 

In the previous parts we have used a list of dictionaries for generating configs for multiple interfaces.
This is a very cumbersome way of modeling your data. Is there a better way for data serialiation?  
Yes, YAML!!! YAML provides a human readable way for data serialization.
YAML provides a easy way of defining list and dictionaries.  

In this part we will go over how you can import data from a YAML file and render Jinja2 tempate.

We have a yaml file already stored in the machine for you! Lets start by taking a look at it. 
```
cd /antidote/lessons/lesson-16/stage4/
cat part4.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

It is so much easy to read our data now! Now lets start with our lesson then!   
As you already know by now, our first step is to start the Python interpreter and import `Environment` module from Jinja2 library.
We will also import the `yaml` library and `pprint` for pretty printing our output.

```
python
from jinja2 import Environment
import yaml
from pprint import pprint
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

The below snippet is used to import the data from the YAML file to our python code. `open()` function opens our yaml file in the `read` mode and assignes it to the variable `yaml_file`. Just note that here we have only provided the name of our yaml file as it is in the same directory as our python code, in case it is in a different folder then you have to give the exact file path to the `open()`. The data from the YAML file can then be easily imported into Python simply by using `yaml.load()` function.

```
yaml_file = open('part4.yml', 'r')
all_devices = yaml.load(yaml_file)
pprint(all_devices)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>

Does this output look familier to you. Its a dictionary containing a list of dictionaries, same as what we were using in previous lessons! You already know what to do now! we start by creating a config template to set the `system hostname` and obtain the interface config.

```
env = Environment(trim_blocks=True, lstrip_blocks=True)
config_temp = env.from_string('''
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
''')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

Once the template is defined we will render the config tempelate for each device specified in the YAML file.
Python `enumerate()` function keeps a count of loop index so that we can print the number of device we are looping over.  
`%s` in the first print statement will take the value of `device_number` for the devices in `all_devices`.
In case you are wondering what is `print('-'*30)`, it is just to make the output more presenatable, you will see when you run the below snippet!!

```
for dev_number, device in enumerate(all_devices['devices'], 1):
    render_1 = config_temp.render(device=device)
    print('Configuration for Device %s' % (dev_number))
    print('-'*30)
    print(str(render_1))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 4)">Run this snippet</button>

P.S. press `Enter` to exit out of the python `for` loop and see your results.

Good Job! You are now ready to render your first network configuration template!  
If you would like to provide Jinja2 tempalates and variables to PyEz and push these configs on to a remote Junos device, checkout out Intro to PyEZ lesson(coming soon)!
