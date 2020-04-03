## Using Jinja for Configuration Templates

**Contributed by: [@ShrutiVPawaskar](https://github.com/ShrutiVPawaskar) and [@shahbhoomi](https://github.com/shahbhoomi)**

---

## Part 4 - Passing Data into a Template From YAML

In the previous sections we used a Python list of dictionaries for generating configs for multiple interfaces.

This is a very cumbersome way of modeling your data, largely because we've mixed our data with the program that's meant to use that data (Python script).
It's a very good idea to maintain this data separately - but for that, we need a solid data serialization format that's also easy to read.

Fortunately, we have YAML. This allows us to create data structures that are very easily importable into Python, while maintaining it separately, outside
our Python logic.

We cover YAML in more detail in the lesson "Introduction to YAML". If you haven't gone through that lesson, you should check it out, so the next few examples make a bit more sense. In this section we will go over how you can import data from a YAML file and use it to render a Jinja template.

We have a YAML file already stored in the machine for you! Lets start by taking a look at it.
```
cd /antidote/stage3/
cat part3.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

It is so much easier to read our data now! Now lets start with our lesson.

As you already know by now, our first step is to start the Python interpreter and import `Environment` module from Jinja2 library.
We will also import the `yaml` library and `pprint` for pretty printing our output.

```
python
from jinja2 import Environment
import yaml
from pprint import pprint
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

The below snippet is used to import the data from the YAML file to our python code. The `open()` function opens our yaml file in the `read` mode and assigns it to the variable `yaml_file`. Just note that here we have only provided the name of our yaml file as it is in the same directory as our python code, in case it is in a different folder then you have to give the exact file path to the `open()`. The data from the YAML file can then be easily imported into Python simply by using `yaml.load()` function.

```
yaml_file = open('part4.yml', 'r')
all_devices = yaml.load(yaml_file, Loader=yaml.FullLoader)
pprint(all_devices)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Does this output look familiar? Its a list of dictionaries - the same as what we were using in previous sections! You already know what to do now. We start by creating a config template to set the `system hostname` and obtain the interface config:

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
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Now that the template is defined we will render the config template for each device specified in the YAML file.

The Python `enumerate()` function keeps a count of loop index so that we can print the number of device we are looping over, so we can keep track of the configs in our output.

`%s` in the first print statement will take the value of `device_number` for the devices in `all_devices`.
In case you are wondering what is `print('-'*30)`, it is just to make the output more presenatable, you will see when you run the below snippet!!

<pre>
for dev_number, device in enumerate(all_devices, 1):
    render_1 = config_temp.render(device=device)
    print('Configuration for Device %s' % (dev_number))
    print('-'*30)
    print(str(render_1))

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

So now in the next section we will learn how to import multiple Jinja templates from different directories and use it in your script. We will also see how to `include` those imported templates in one main template which can then be used to configure the device.
