## Junos Automation with PyEZ

**Contributed by: [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Part 2 - Collect Data from Junos Devices

#### Connect to Junos device

The first thing you will want to do with PyEZ is learn how to connect to a device. Once we've connected,
we can run PyEZ's various functions for getting facts about our device, applying a config, or retrieving more
detailed information about operational state.

In this section, we'll cover step-by-step how to connect to a device using PyEZ on the Python interpreter shell.

First, to gather information from Junos, we have to import the required modules - `Device` from `jnpr.junos` library.
We'll enter the python shell, and then import the appropriate module:

```
python
from jnpr.junos import Device
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

After that, create a Device object by providing hostname, username and password for authenticating to vQFX device, and then call the `open()` function to make a NETCONF connection.

```
dev = Device('vqfx', user='root', password='VR-netlab9')
dev.open()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

This is a much simpler way to accomplish the same thing we did manually in the previous section!

You should see `Device(vqfx)` in the terminal; that means PyEZ is successfully connect and authenticate to the Junos device, and return the Device object. If you're trying to implement this in your own environment, you may see an Exception raised, like a ConnectTimeoutError or ConnectAuthError. These mean that PyEZ cannot reach your device's NETCONF API, or that your credentials are invalid, respectively.

Next, we'll use a special `pprint()` function to print this device's basic information in a way that's easy for us to read.

```
from pprint import pprint
pprint(dev.facts)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

The `dev.facts` dictionary consolidates the output of multiple RPC get requests, e.g. show chassis routing-engine, show version, show virtual-chassis, etc. Under the hood, when you first time access the `dev.facts` attribute, PyEZ will execute corresponding RPC requests to collect information likes host name, software version, serial number, etc. 

#### Prepare your first function call

Now that we've connected to the device and printed basic facts, it's time to collect more detailed information. To review, NETCONF uses Remote Procedure Calls (RPC) to communicate between client and server. The client sends an RPC request with a particular name, and the server responds with the requested information.

In previous section, we manually typed the RPC tag `<get-system-uptime-information>` to get device's uptime. However, you kind of have to know this ahead of time to be able to specify this tag. What if you wanted to know the tag for your favorite "show" command?

In the case of Junos, you can just add the pipe ` | display xml rpc` to the `show` command:

```
show system uptime | display xml rpc
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 3)">Run this snippet</button>

From the output, we know the XML tag of `show system uptime` command is `<get-system-uptime-information>`.

PyEZ implements all these RPC tags as Python functions, but we have to change it slightly to be compatible with Python. We can get rid of the ending "<" and ">", and then convert all the hyphens to underscores, as Python doesn't allow hyphen in the function name. i.e., `get-system-uptime-information` -> `get_system_uptime_information`.

Finally, use this as the append it to the `dev.rpc` object, it will return XML object containing the `show system uptime` response.

```
uptime = dev.rpc.get_system_uptime_information()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

There is no output from above snippet, the code just saves response to `uptime` variable. You will learn how to display and extract useful information from returned variable later.

#### Call function with arguments

In Junos CLI, sometimes you provide a number of arguments, e.g., in `show interfaces`, you can specify the interface to be displayed, whether showing statistics, or whether showing data in brief format.

There is a similar mechanism to specify those arguments in a PyEZ RPC call.  The first step is to figure out argument names, using the same techniques just mentioned - ` | display xml rpc` on Junos device. E.g, to get argument keys of `show interfaces em3 statistics` in the Junos CLI:

```
show interfaces em3 statistics | display xml rpc
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 5)">Run this snippet</button>

From the Junos output, you can see two types of arguments:
  - `<interface-name>em3</interface-name>` key-value pair, key is `interface-name`, and value is the actual name of target interface
  - `<statistics/>` a config flag to turn on some features, this is a boolean value, and we set it to 'True' to gather statistics.

To construct RPC call for `show interfaces em3 statistics`, the function name is `get_interface_information()` - again, converting hyphens to underscores from the XML RPC tag.

To convert arguments for the key-value pair type, give it in the format of `key=value`, but again convert hyphens to underscores; and for flag type, give it in the format `flag=True`.

You should now be able to determine the format of RPC call, let's do it:

```
intf = dev.rpc.get_interface_information(
    interface_name='em3', statistics=True)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 6)">Run this snippet</button>

Again, the output is saved to `intf` variable, and there should be no output in the terminal. You'll learn how to extract information in next section.
