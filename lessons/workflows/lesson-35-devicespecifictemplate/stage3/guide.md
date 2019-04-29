## Device Specific Template Generation

**Contributed by: [@jweidley](https://github.com/jweidley)**

---

### Part 3  - Multiple Devices w/ Uplinks

The examples in the previous lesson were a little more realistic and in this section we'll take it to the next level. 

There are times that you need to be able to create multiples of the same configuration line using different data sets. We will continue with the sample project of deploying a number of access switches. To explain this concept we will use uplink ports on Access switches. Access switches usually have two connections, one to each upstream distribution switch. In most situations those uplink ports would be the same on every access switch, but not always. In this session we will show you how to add those uplinks in a quick and consistant way but still allowing flexibility to change them as necessary.


#### YAML Variables File 
In order to add the uplink ports we need to add values to the YAML file. We will create another dictionary key named **UPLINKS** and then we will use nested dictionaries with key/value pairs for each distribution switch. This is what the YAML file will look like.

<pre>
cd /antidote/lessons/lesson-35/stage3
head -12 variables.yml
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

There are two uplinks, one that will connect to `distro1` and the other that will connect to `distro2`. For each connection you specify the **INTERFACE** and **DESCRIPTION** keys with their corresponding values.

#### Device Template File
In order to create the multiple uplink ports we will need to modify the Jinja2 template to include a `for` loop so it can loop through all of the data in the **UPLINKS** dictionary. Lets look at the new template.
<pre>
cd /antidote/lessons/lesson-35/stage3
head -18 template.j2
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

See the `for` loop syntax **\{% for item in UPLINKS %\}**. When the loop is executed `item` will be set to `distro1` on the first pass and then be set to `distro2` on the second pass, each time printing the **INTERFACE** and **DESCRIPTION** values that are set.

#### Python
Now lets get into python and see what it looks like and how it works. First we run the Python interactive shell and load the yaml module.

<pre>
python
import yaml
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Next we have to open the variables.yml file, read the file and load the data into into a variable called `my_vars`.
<pre>
var_file = open('variables.yml')
var_data = var_file.read()
my_vars = yaml.full_load(var_data)
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Alright, now lets ensure the data has been properly read and loaded by printing the my_vars variable. Since the data is somewhat complex we will using the pretty print (pprint) module to display the data in a structured way so its more readable.
<pre>
from pprint import pprint
pprint(my_vars)
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

#### Template Generation
Now we will generate a configuration based on the device template and YAML data. This is done using Jinja2 so we have to import the Jinja2 module.

<pre>
from jinja2 import Template
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Next we have to open and read the device template that contains the Junos configuration with Jinja2 variables and store it a variable called template.

<pre>
template_file = open('template.j2')
template_data = template_file.read()
template = Template(template_data)
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Lastly we will render the template based on the data. Since we are dealing with multiple devices we have to use a loop to process each device defined in the YAML directionary.

<pre>
for device in my_vars:
   print(template.render(device))


quit()
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Scroll back on the linux terminal and you can see that the substitutions were performed for each of the three access switches listed in the YAML configuration file. 

#### Things to try
The session is complete but if you want to play around on your own, here are a couple of things to try.

1. Add statements to the `for` loop so the configurations are written to a file instead of printed to the screen
2. Print the contents of my_vars using `print` and with `pprint` to see the benefits of `pprint`.
3. Add another **for** loop the template.j2 to add the uplink ports under **[protocols stp interfaces]**

Regenerating the configuration files can be done using the `build-configs.py` script.
<pre>
./build-configs.py
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>


