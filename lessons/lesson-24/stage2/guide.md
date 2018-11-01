## Junos Automation with PyEZ

*Contributed by Raymond Lam @jnpr-raylam*

---

### Part 2 - Collect data from Junos Devices

#### 1. Connect to Junos device

If you have read some PyEZ introduction, you should familiar with below 5 lines of boilerplate codes:

```
    from jnpr.junos import Device
    from pprint import pprint
    dev = Device('vqfx', user='root', password='VR-netlab9')
    dev.open()
    pprint(dev.facts)
```
If you don't, no worries. I will go through above code snippet line by line.

First, to gather information from Junos, we have to import required modules - `Device` from `jnpr.junos` library

```
python
from jnpr.junos import Device
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

After that, create a Device object by providing hostname, username and password for authenticating to the vQFX device, and then call `open()` function to make a Netconf over SSH connection - just like what you did manually in previous section.

```
dev = Device('vqfx', user='root', password='VR-netlab9')
dev.open()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

You should see `Device(vqfx)` in the terminal, that means PyEZ is successfully connect and authenticate to the Junos device, and return the Device object. If problem occurs, PyEZ may throw exception likes ConnectTimeoutError or ConnectAuthError.

Next Use `pprint()` function to print device's basic information.

```
from pprint import pprint
pprint(dev.facts)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet</button>

The `dev.facts` consolidates output of multiple RPC get requests, e.g. show chassis routing-engine, show version, show virtual-chassis, etc. Under the hood, when you first time access the `dev.facts` attribute, PyEZ will execute corresponding RPC requests to collect information likes host name, software version, serial number, etc. 

By default, PyEZ requires Junos device to enable port 830 by `set system services netconf ssh` config, but not all customer applied that since they don't use Netconf in their daily operation

Here, I would recommend adding argument `port=22` when creating Device object, to force PyEZ connect using port 22, instead of default Netconf TCP port 830.

Almost every Junos devices have SSH enabled, with this setting, PyEZ can still connect to Junos without `system services netconf ssh` explicitly configured, and the connection protocol is still Netconf over SSH, but over port 22, not port 830.

You can try delete the netconf services configuration on vQFX, and then run below snippet to confirm successful connectivity.

```
dev = Device('vqfx', user='root', password='VR-netlab9', port=22)
dev.open()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

#### 2. Figure out RPC XML tag

After connected to the device, it's time to collect information. In previous section, we use `<get-system-uptime-information>` tag in the RPC request to get device's uptime. How can we know `show system uptime` maps to `<get-system-uptime-information>` ?

There are two methods, the first one is issue the command in Junos CLI, and add `| display xml rpc` pipe:

```
cli
show system uptime |display xml rpc
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 5)">Run this snippet</button>

From the output, we know XML tag of `show system uptime` command is `<get-system-uptime-information>`

Second method is call Device object's `display_xml_rpc()` function, provide command `show system uptime` as first argument, and second argument `format='text'`:

```
print(dev.display_xml_rpc('show system uptime', format='text'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 6)">Run this snippet</button>

After got the XML tag, convert all the hyphens to underscores, as Python doesn't allow hyphen in the function name. i.e., `get-system-uptime-information` -> `get_system_uptime_information`

Finally, append it to the `dev.rpc` object, it will return XML object containing the `show system uptime` response in XML format.

```
uptime = dev.rpc.get_system_uptime_information()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 7)">Run this snippet</button>

There is no output from above snippet, the code just saves response to `uptime` variable. You will learn how to display and extract useful information from the returned variable later.

#### 3. Figure out RPC call arguments

In Junos CLI, sometimes you provide a number of arguments, e.g., in `show interfaces`, you can specify the interface to be displayed, whether showing statistics, or whether showing data in brief format.

There is similar mechanism to specify those arguments in PyEZ RPC call.  The first step is to figure out argument names, using same techniques just mentioned - ` | display xml rpc` on Junos device or call `display_xml_rpc()` function.

Here we're not going to repeat both methods, and just show how to get argument keys of `show interfaces em3 statistics` in Junos CLI:

```
show interfaces em3 statistics |display xml rpc
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 8)">Run this snippet</button>

From the Junos output, you can see two types of arguments:
  - `<interface-name>em3</interface-name>` key-value pair, key is `interface-name`, and value is the actual name of target interface
  - `<statistics/>` a config flag to turn on some features, key is `statistics`, and there is no value associated


To construct RPC call for `show interfaces em3 statistics`, the function name is `get_interface_information()` - convert hyphens to underscores from XML tag.

To convert arguments, for key-value pair type, give it in the format of `key=value`, but again convert hyphens to underscores; and for flag type, give it in the format `flag=True`.

You should now be able to determine the format of RPC call, let's do it:

```
intf = dev.rpc.get_interface_information(
    interface_name='em3', statistics=True)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 9)">Run this snippet</button>

Again, the output is saved to `intf` variable, and there should be no output. You'll learn how to extract information later.

#### 4. Specify output format

In Junos CLI, you can specify output format in either default text, XML or JSON

```
    root@vqfx> show interfaces |display ?
    Possible completions:
    json                 Show output in JSON format
    xml                  Show output as XML tags
```

Similar function exists in PyEZ, by default, the output format of PyEZ RPC call is XML.

To change the returned format, you can add a dictionary object as first argument of RPC call to specify desired format. The dictionary key is `format` and value is either `text` or `json`. For text, it will return same output as in Junos CLI:

```
intf = dev.rpc.get_interface_information(
    {'format':'text'},
    interface_name='em3', statistics=True)
print(intf.text)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 11)">Run this snippet</button>

The `format` dictionary **MUST** be placed in first argument due to Python coding syntax, otherwise error will be prompted.

Because XML is easier for data parsing and manipulation, it's recommended to keep output as default XML format, unless your program just simply displays the CLI output to user.

In next section, we will talk about how to parse and extract useful information from RPC replies.