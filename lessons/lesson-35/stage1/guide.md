# Device Specific Template Generation
**Contributed by: [@jweidley](https://github.com/jweidley)**
---
## Part 1  - Skills Review

Having the ability to easily generate a device specific configuration from an approved template is a **HUGE** time saver and it provides the consistency that you need to avoid common configuration errors.

In this section, we will do a quick review of the key concepts required to accomplish this task; specificially YAML and Jinja2. View the Lesson Diagram to see a visual representation of the process. For a complete review of [YAML](https://labs.networkreliability.engineering/labs/?lessonId=14&lessonStage=1) and [Jinja2](https://labs.networkreliability.engineering/labs/?lessonId=16&lessonStage=1) please go through those lessons in NRE Labs.

#### Device Template File
The most important part of the template generation process is to have a device template with a known good configuration. The configuration in this template usually has to be approved by a configuration control board and the security team. The approved template is then modified to include variables using  Jinja syntax so the substitions can be done by the script.

Lets take a look at our sample configuration template that has already had the Jinja syntax added.
<pre>
cd /antidote/lessons/lesson-35/stage1
more template.j2
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

Jinja2 variables can be almost any combinations of numbers or lower case or upper case letters but in this example we will use all captial letters so they stand out better. The variables are surrounded by double curly brackets, for example **{{ HOSTNAME }}**. In the output look for the three template variables (**HOSTNAME, MGMT\_IP and DEFAULT\_GW**). Pay attention to these variable names because they will be set to specific values in the next section using YAML.

#### YAML Review
YAML is a human friendly data serialization standard but what does that mean? It means that it is a way to format data so that it is easy for humans to read and edit. The data in the YAML file will be used to make substitutions in the device template. We have a sample YAML file with prepopulated data.

<pre>
cd /antidote/lessons/lesson-35/stage1
more variables.yml
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

The format of this file is called a dictionary which is a mapping of unique key and value pairs. The **Key** is on the left side of the colon (:) and **Value** is on the right side. So **HOSTNAME** is the key and **ex4300-3** is the value of that key.

Now lets get into python and see what it looks like and how it works. First we run the Python interactive shell and load the yaml module.

<pre>
python
import yaml
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

Next we have to open the variables.yml file, read the file and then load the data into a variable called `my_vars`.
<pre>
var_file = open('variables.yml')
var_data = var_file.read()
my_vars = yaml.full_load(var_data)
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet</button>

Alright, now lets ensure the data has been properly read and loaded by printing the `my_vars` variable.
<pre>
print my_vars
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

In the output you can see the upper case keys and their coresponding values, for example **'HOSTNAME': 'ex4300-3'**.

#### Template Generation
Now we will generate a configuration based on the device template and YAML data. This is done using Jinja2 so we have to import the Jinja2 module.

<pre>
from jinja2 import Template
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 5)">Run this snippet</button>

Next we have to open and read the device template that contains the Junos configuration with Jinja2 variables and store it a variable called `template`.

<pre>
template_file = open('template.j2')
template_data = template_file.read()
template = Template(template_data)
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 6)">Run this snippet</button>

Lastly we will render the template based on the data from the YAML file.

<pre>
print(template.render(my_vars))
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 7)">Run this snippet</button>

You can see from the output on the linux terminal that all three variables have successfully been substituted with the values from the YAML configuration file. Go to the next section to see a more practical example.

