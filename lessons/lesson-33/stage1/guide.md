## Quick and Easy Device Inventory

**Contributed by: [@jweidley](https://github.com/jweidley) and [@mayeates](https://github.com/mayeates)**

---

### Part 1  - Single Device Inventory

Whether inventorying newly deployed or operational devices the task can be very time consuming and tedious. In this lesson, we'll review a tool we learned about in a previous lesson - PyEz. As a refresher, PyEZ is a micro-framework for Python that enables you to manage and automate Junos devices. It provides the capabilities that a user would have on the Junos OS command-line interface (CLI) in an environment built for automation tasks.

This is a simple example of using Python and the PyEz module to establish a NETCONF connection to a Junos device and print the device `facts`. Device `facts` are unique attributes of the system, like hostname, Junos version, up-time, etc.

<pre>
python
from jnpr.junos import Device
dev = Device(host="vqfx1", user="antidote", password="antidotepassword")
dev.open()
print dev.facts
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

At the end you can see all the device `facts` printed but it is kind of difficult to read and see the structure of the data. To fix this we can use the pretty print module **(pprint)** to give the `facts` some structure and make them easier to read.
<pre>
from pprint import pprint
pprint (dev.facts)
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

Now that looks a little better! The device `facts` are stored in a Python dictionary which are comprised of key/value pairs separated by a colon (:). Look at the output and find the key/value pairs for hostname & model. It should look like this:

`'model': 'VQFX-10000',`

The facts **key** is `model` and the **value** of that key is `VQFX-10000`.

In most cases you only want or need a couple of these facts and not the entire dictionary. Next lets look at printing just the `hostname` value. This is done like so...
<pre>
print dev.facts['hostname']
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>

`dev` represents your connection to the device, `facts` relates to the facts dictionary and `hostname` is the specific key of the facts dictionary that you want to display. Lets do this again for the `model` key.

<pre>
print dev.facts['model']
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

The last thing to do is to put multiple values on the same line separated by a unique character. This type of operation is very easy with Python. We will use the semicolon character as our separator.

<pre>
print dev.facts['hostname'] + ";" + dev.facts['model']
</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 4)">Run this snippet</button>

Thats it....Easy Peasy Lemon squeezy!! :)

In the next lab, we'll take these same concepts to support gathering information from multiple devices.

