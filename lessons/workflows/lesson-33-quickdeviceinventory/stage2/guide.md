## Quick and Easy Device Inventory

**Contributed by: [@jweidley](https://github.com/jweidley) and [@mayeates](https://github.com/mayeates)**

---

### Part 2  - Multiple Device Inventory

In the previous section, we reviewed using the PyEz module to obtain facts about a device and how we can print just the keys we want to see. In this section, we will pull together a few simple skills from other NRE Labs lessons to obtain specific facts about a list of network devices.

There are so many uses for a script like this. For instance, you can find out what version of code is running on all your devices to plan code upgrades, get a list of serial numbers for maintenance renewal, find out which devices lost power as the result of a power outage and the list goes on!

First we need a list of device names or IP addresses that we want to retrieve information from. We will use a YAML file to store the device list. The YAML file looks like this:

<pre>
cd /antidote/lessons/lesson-33/stage2/
more devices.yml
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Pretty simple, right? New devices can be easily added without tinkering around in the script. Now lets start on the script. Start python, import the YAML module and import the Junos PyEz module.

<pre>
python
import yaml
from jnpr.junos import Device
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Next we have to read in the YAML file with the device hostnames/IP addresses. First, open the `devices.yml` file as readonly and then use the YAML module to put it into a Python list, like so:

<pre>
deviceFile = open('devices.yml', 'r')
deviceList = yaml.full_load(deviceFile)
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Lets print the `deviceList` variable to ensure the devices.yml file has been processed correctly.
<pre>
print deviceList
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

It would be helpful to have a column header so you can easily know what each field value is. This can be done with a simple `print` statement.

<pre>
print("HOSTNAME;MODEL;SERIAL-NUMBER;JUNOS-VERSION")
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Now this is where the magic happens!  We are going to create a `for` loop so we can perform a series of actions on each device in the list (i.e. YAML file). The first thing we do is create the `dev` variable that includes the device hostname and login credentials. Next we `open` a NETCONF connection to the device so we can query the `facts`. 

Then we `print` the specific keys from the facts dictionary on the same line separated by a semicolon. Thats it and all that is left is to `close` the connection to the device.

<pre>
for device in deviceList:
	dev = Device(host=device, user="antidote", password="antidotepassword")
	dev.open()
	print(dev.facts['hostname'] + ";" + dev.facts['model'] + ";" + dev.facts['serialnumber'] + ";" + dev.facts['version'])
	dev.close()

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

In the linux terminal on the right you can see the loop working, accessing each device and printing the facts. In the NRE Labs environment the serial number of the vQFX switches are the same but wont be the case in your production or lab environment.

In the output you should see the **hostname, model, serial number** and the **Junos version** that is running on the two test devices. As you can see the output data is separated by semicolons which allows it easily to be imported into Excel so the data can be analyzed, sorted, etc.

