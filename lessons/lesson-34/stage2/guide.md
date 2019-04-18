## Automated Device Configuration Backup

**Contributed by: [@mayeates](https://github.com/mayeates) and [@jweidley](https://github.com/jweidley)**

---

### Part 2  - Multiple Device Backup 

In this lesson we will expand on the last lesson and backup the configurations from multiple Junos devices. In this section the configuration will be stored in the native Junos format to a local file on the Linux system.

First we need a list of device names or IP addresses that we want to retrieve information from. We will use a YAML file to store the device list. The YAML file looks like this:
<pre>
cd /antidote/lessons/lesson-34/stage2/
more devices.yml
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

With this method new devices can be easily added without editing in the script.

Next we will start the Python interactive shell, load the YAML module to process the `devices.yml` file, load the PyEz module so we can communicate with our Junos devices and load the `lxml` module to format the XML data returned from the Junos devices.
<pre>
python
import yaml
from jnpr.junos import Device
from lxml import etree
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button> 

Next we have to read in the YAML file with the device hostnames. First, open the file as readonly and then use the YAML module to put it into a Python list, like so:
<pre>
deviceFile = open('devices.yml', 'r')
deviceList = yaml.full_load(deviceFile)
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button> 

To ensure the `devices.yml` file was processed correctly we can print the `deviceList` variable.
<pre>
print deviceList
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

We need to create a `for` loop so we can perform a series of actions on each device in the list (i.e. YAML file). The first thing we do is create the `dev` variable that represents the device hostname and login credentials. Then we need to `open` a NETCONF connection to the device.
<pre>
for device in deviceList:
	dev = Device(host=device, user="antidote", password="antidotepassword")
	dev.open()
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 4)">Run this snippet</button>

In order to save the configuration we need to `open` a local file on the Linux system with a unique name. To be descriptive the filename will be the **device**-backup.txt which can be accomplished with the `device` variable.
<pre>
	outfile = open(device + "-backup.txt","w")
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 5)">Run this snippet</button>

Then we will use the `rpc.get_config` function to pull the device configuration and store it in a variable called `config`. Next we write the configuration to the local file and finally `close` the local file.
<pre>
	config = dev.rpc.get_config(options={'format':'text'})
	outfile.write(etree.tostring(config))
	outfile.close()

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 6)">Run this snippet</button>

In the Linux terminal you can see the loop making a connection with each device and saving the configuration. Wait until you see the `>>>`  prompt before running the next snippet. 

In order to verify the backed up configurations we will need to exit the Python shell.
<pre>
exit()
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 7)">Run this snippet</button>

Lets do a directory listing looking for the backup files.
<pre>
ls -l
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 8)">Run this snippet</button>

View one of the backed up configuration files using the `cat` command. 
<pre>
cat vqfx1-backup.txt
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 9)">Run this snippet</button>

