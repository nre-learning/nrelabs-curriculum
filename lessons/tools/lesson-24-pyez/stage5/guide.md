### Junos Automation with PyEZ

**Contributed by: [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

#### Part 5 - PyEZ Tables and Views

Tables and Views provide a simple and efficient way to extract information from complex operational command output or configuration data and map it to a Python data structure.
In the previous sections we still had to know a significant amount of XML to get at what we want - with Tables and Views, this is abstracted from us so we just deal with Python.

There are two types of tables - Operational Tables (OpTables) and Config Tables (ConfigTables). Operational Tables select items from RPC reply of an operational command, and Configuration Tables select data from specific hierarchies in the selected configuration database. Each Table item represents a record of data and has a unique key. A Table also references a Table View, which is used to map the tag names in the data to the variable property names used within the Python module.

There are some predefined OpTables and ConfigTables, located in the `op` and `resources` folder of the PyEZ package directory:

```
ls /usr/local/lib/python2.7/dist-packages/jnpr/junos/op
ls /usr/local/lib/python2.7/dist-packages/jnpr/junos/resources
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

#### PyEZ OpTable

`RouteTable` is a type of `OpTable` - it allows us to retrieve the routing information on a device. It is defined in `op/routes.yml` file.

```
cat /usr/local/lib/python2.7/dist-packages/jnpr/junos/op/routes.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

PyEZ allows us to easily use these existing tables by importing them as Python modules. To import an OpTable like `RouteTable`, first import the the dictionary name defined in the YAML file that has the `rpc` key; the name usually ends with 'Table'. The Python import path is constructed from the file name path - change `/` to `.` and remove the extension.

```
python
from jnpr.junos.op.routes import RouteTable
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Next, create a Table instance and use the device's `bind()` function to associate the Table with the Device.

```
from jnpr.junos import Device
dev = Device('vqfx', user='antidote', password='antidotepassword')
dev.open()
dev.bind(routes=RouteTable)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

The definition for `RouteTable` specifies the RPC function to retrieve routes, which is `<get-route-information>`. This makes it simpler for us in Python: we need only call the `get()` function. This accepts the same arguments as `dev.rpc.get_route_information()`. Let's pass `table='inet.0'` to specify the default route table; it is the same as the CLI command `show route table inet.0`.

```
dev.routes.get(table='inet.0')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Now, you can show all collected routes by accessing the dictionary keys:

```
dev.routes.keys()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

For each route, access its dictionary key to get the route information:

```
dev.routes['10.0.0.0/24'].keys()
dev.routes['10.0.0.0/24'].via
dev.routes['10.0.0.0/24'].protocol
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

To display all of the routing information, we can use a `for` loop to iterate over the Tables object.

<pre>
for route in dev.routes:
    print(route.key, route.protocol, route.via, route.age, route.nexthop)

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

PyEZ OpTable enables users with **NO** XML knowledge to manage and automate Junos devices. As illustrated in above examples, you can retrieve device's route table without any XML elements.

All you need is to just call the `get()` function, and all pre-defined information will be fetched and populated in the dictionary and ready for your access. It hides all RPC requests and XML data parsing code.

#### PyEZ ConfigTable

In a simple view, ConfigTable is just the reverse of OpTable. Where OpTable parses XML output from Junos and populates the dictionary's attributes, ConfigTable reads the dictionary's attributes and converts to a XML config object for applying to Junos device.

This section takes the `StaticRouteTable` ConfigTable as an example; it is defined in `resources/staticroutes.yml` file.

```
exit()
cat /usr/local/lib/python2.7/dist-packages/jnpr/junos/resources/staticroutes.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Similar to OpTable, the first step is to import the dictionary name defined in YAML file that has `set` key, the name usually ends with 'Table'.

```
python
from jnpr.junos.resources.staticroutes import StaticRouteTable
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Next, create a Table instance and use the `bind()` function to associate with the Device.

```
from jnpr.junos import Device
dev = Device('vqfx', user='antidote', password='antidotepassword')
dev.open()
dev.bind(route=StaticRouteTable)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

The dictionary `StaticRouteView` in the YAML file determines the available settings for this ConfigTable. As in the terminal output, `route_name` and `hop` are defined, and we can assign values to these attributes:

```
dev.route.route_name = '192.168.100.0/24'
dev.route.hop = '10.0.0.2'
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

After we've configured one set of data, we can call the `append()` function to add it to our config:

```
dev.route.append()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

If there is additional data, set them again and call another `append()`.

```
dev.route.route_name = '192.168.200.0/24'
dev.route.hop = '10.0.0.2'
dev.route.append()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Finally, when finished appending all new configs, call `set()` function:

```
dev.route.set()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

This performs a configuration commit on our device and applies the changes to the running configuration. Again, we can verify new config is applied on the Junos CLI:

```
show configuration |compare rollback 1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', this)">Run this snippet</button>

ConfigTable enables users to provision Junos config without XML elements. You don't have to prepare the configuration file or any `set` commands, instead, just simply configure dictionary values and then call `append()` and `set()` function.

Congratulations! You have finished this lesson on Junos Automation with PyEZ. I hope it was useful, and will enjoy using PyEZ to manage your Junos devices!
