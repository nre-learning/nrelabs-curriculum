## Device Specific Template Generation

**Contributed by: [@jweidley](https://github.com/jweidley)**

---

### Part 4  - Push Template to Device

After you generate a template configuration the next step is to push the configuration to a device or a series for devices so thats what we will do in this lesson. The sample project we will use is we have to generate a number of VLANs and then push them to a few QFX switches.

First lets see what VLANs are already configured on the QFX switches, starting with vqfx1:
<pre>
show configuration vlans
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

and on vqfx2:
<pre>
show configuration vlans
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx2', this)">Run this snippet</button>

Notice the only VLAN configured is the default VLAN and a VLAN tag of 1.

#### YAML Variables File 
We will use a YAML file to store the specific data for the VLANs we need to create. The sample `vlans.yml` file contains a dictionary with a list of **key/value** pairs that contain the **VLAN\_NAME** and the **VLAN\_ID**. Lets see what the sample YAML file looks like.

<pre>
cd /antidote/stage3
cat vlans.yml
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

#### Device Template File
In order to create multiple VLANs we will need a Jinja2 template with a `for` loop similar to what was done in the previous section. Lets look at the new template.
<pre>
cd /antidote/stage3
cat template.j2
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

This template will automatically generate VLANs with names that:
- Start with the letter **v**
- Includes the **VLAN\_ID**
- Uses a period (.) as a separator
- Includes the **VLAN\_Name** value

For example, the generated VLAN names would look like this **v100.voip-servers**.

#### Python
Now lets get into python and get started. The portion of the script where we import the YAML file & Jinja2 template is similar to what was done in the previous sections so lets do that first.

<pre>
python
import yaml
from jinja2 import Template

var_file = open('vlans.yml')
var_data = var_file.read()
my_vars = yaml.full_load(var_data)

template_file = open('template.j2')
template_data = template_file.read()
template = Template(template_data)

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Next we need to `open` a new file, called `new-vlans.conf`, to store the generated configuration, `render` the Jinja2 template from data stored in the YAML file and then `close` the file. We will also `print` the generated configuration to the screen so we can see what it looks like.
<pre>
outfile = open("new-vlans.conf", "w")
outfile.write(template.render(my_vars))
outfile.close()
print(template.render(my_vars))

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

#### Push Configuration to devices
At this point the new VLANs have been created and written out to a file. Now we need to `open` and `load` the file that contains the list of devices that the template will be deployed to. The device list is another YAML fall called `devices.yml`.
<pre>
deviceFile = open('devices.yml', 'r')
deviceList = yaml.full_load(deviceFile)

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

We will use PyEz to connect to the QFX switches and push the configuration template so we have to load those modules.
<pre>
from jnpr.junos import Device
from jnpr.junos.utils.config import Config

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Since we are dealing with multiple device we need to create a `for` loop in order to connect to each device and push the configuration template. The `device` variable represents the device hostname and login credentials which are used to `open` a NETCONF connection to the device.

Then we start the process of `load`ing the configuration. We must specify the file with the configuration and the format.

Lastly we check the `commit` status of the configuration push. We will `print` a positive message if the commit was complete and a negative message if the commit fails.
<pre>
for device in deviceList:
  device = Device(host=device, username="antidote", password="antidotepassword")
  device.open()
  cfg=Config(device)
  cfg.load(path='new-vlans.conf', format='text')
  if cfg.commit() == True:
     print ('configuration commited on ' + device.facts["hostname"])
  else:
     print ('commit failed on ' + device.facts["hostname"])
     device.close()

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Watch the output in the linux terminal. You will see the script looping through the QFX switches, pushing the configuration and printing the commit status messages. This may take a couple of minutes so wait until you see the `>>>` prompt.

Now lets check to see if the VLANs were successfully pushed, starting with vqfx1:
<pre>
set cli screen-length 50
show configuration vlans
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

and check vqfx2:
<pre>
set cli screen-length 50
show configuration vlans
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx2', this)">Run this snippet</button>
