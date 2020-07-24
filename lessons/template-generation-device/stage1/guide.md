The examples in the previous lesson were purposefully simple so the basic concepts could be described in a way that is easy to understand. In this section we will create a template generator that creates device specific configurations for multiple devices.

The sample project we will use is deploying a large number of access switches. When deploying devices it is common for them to have a base configuration to include hostname, management IP address and a default gateway.

#### Device Template File
In this section we will use the same template file that we used in the previous lesson. Look for the template variables in all capital letters surrounded by double curly brackets, for example **{{ HOSTNAME }}**. Pay attention to these variables because they will be set to specific values in the next section using YAML.
<pre>
cd /antidote/stage1
more template.j2
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>


#### YAML Variables File 
In this section we will generate configurations for multiple devices. In order to accomplish this the YAML file format will be changed slightly. Since we will be dealing with multiple devices the YAML file will contain three elements with dictionary key/value pairs for each element. Lets look at the new format.

<pre>
cd /antidote/stage1
more variables.yml
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

You can see that variables.yml file contains three variables for three access switches that will we generate configurations for.

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

Alright, now lets ensure the data has been properly read and loaded by printing the `my_vars` variable.
<pre>
print(my_vars)
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

#### Template Generation
Now we will generate a configuration based on the device template and YAML data. This is done using Jinja2 so we have to import the Jinja2 module.

<pre>
from jinja2 import Template
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Next we have to open and read the device template that contains the Junos configuration with Jinja2 variables and store it a variable called `template`.

<pre>
template_file = open('template.j2')
template_data = template_file.read()
template = Template(template_data)
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Lastly we will render the template based on the data from the YAML file. Since we are dealing with multiple devices we have to use a loop to process each device defined in the YAML file. The loop will run through the `my_vars` list processing each element one at a time, making the substitutions of the key/value pairs until there aren't any elements left.

<pre>
for device in my_vars:
   print(template.render(device))
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Scroll back on the linux terminal and you can see that the substitutions were performed for each of the three access switches listed in the YAML configuration file. 

That is pretty cool but it would be more helpful if those generated configuration files were written out to a file with the name of the device. That can easily be done by adding a couple of statements inside the loop. First you have to open a file of a certain name with write permissions **("w")**, the **print** statement above is changed to a **write** operation and after the file is written to the file should be **closed(). It would look like this:

<pre>
for device in my_vars:
   outfile = open(device["HOSTNAME"] + ".conf", "w")
   outfile.write(template.render(device))
   outfile.close()
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Nothing was outputted to the screen because the data was written to the file. We will exit the Python interactive shell so we can look at the files.
<pre>
quit()
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Lets look at the files in the directory. Notice that the ex4300-x.conf files are now present.
<pre>
ls -l
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Lets look at one of the newly generate configuration files.
<pre>
cat ex4300-3.conf
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

#### Things to try
The session is complete but if you want to play around on your own, here are a couple of things to try.

1. Add another device to variables.yml file and regenerate the configuration files
2. Add a line to the template.j2 file with a new variable, add the corresponding variable to variables.yml and regenerate the configuration files

Regenerating the configuration files can be done using the `build-configs.py` script.
<pre>
./build-configs.py
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>


