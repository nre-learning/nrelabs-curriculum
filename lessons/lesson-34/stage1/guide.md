# Automated Device Configuration Backup
**Contributed by: [@mayeates](https://github.com/mayeates) and [@jweidley](https://github.com/jweidley)**
---
## Part 1  - Single Device Backup
Having an up to date device configuration is essential for disater recovery in the event of device failure or natural disaster. Being able to automate backup configurations makes recovery of the device that much easier (especially if it's a mission critical device). In this lesson we will pull the configuration from a single device and store it in **"display set"** format. 

First we will start the Python interactive shell, load the PyEz module so we can communicate with the Junos devices and load the `lxml` module to format the XML data returned from the Junos device.
<pre>
python
from jnpr.junos import Device
from lxml import etree
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

After that, we will create a new text file for the configuration to be saved. The file will be named **vqfx1-backup.txt** and will be in the home directory on the Linux system. 
<pre>
outfile = open("vqfx1-backup.txt","w")
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

Next we create the `dev` variable that represents the device hostname and login credentials. Then we need to `open` a NETCONF connection to the device.

<pre>
dev = Device(host="vqfx1", user="antidote", password="antidotepassword")
dev.open()
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>

Then we will use the `rpc.get_config` function to pull the device configuration and store it in a variable called `config`. Next we `write` the configuration to the local file and finally `close` the local file.
<pre>
config = dev.rpc.get_config(options={'format':'set'})
outfile.write(etree.tostring(config))
outfile.close()
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

In the Linux terminal you can see it making a connection with each device and saving the configuration. Wait until you see the `>>>`  prompt before running the next snippet. 

In order to verify the backed up configurations we will need to exit the Python shell.
<pre>
exit()
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 4)">Run this snippet</button>

Do a listing of the directory to see the **vqfx1-backup.txt** file with the current date and timestamp.  
<pre>
ls -l
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 5)">Run this snippet</button>

If you would like to see the configuration backed up you can use the `cat` command to view the backed up configuration file.
<pre>
cat vqfx1-backup.txt
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 6)">Run this snippet</button>

