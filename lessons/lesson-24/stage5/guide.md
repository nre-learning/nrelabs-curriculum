### Junos Automation with PyEZ

**Contributed by: [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

#### Part 5 - PyEZ Tables and Views

Tables and Views provide a simple and efficient way to extract information from complex operational command output or configuration data and map it to a Python data structure. 

There are two types of tables - Operational Tables and Config Tables. Operational Tables select items from RPC reply of an operational command, and configuration Tables select data from specific hierarchies in the selected configuration database. Each Table item represents a record of data and has a unique key. A Table also references a Table View, which is used to map the tag names in the data to the variable property names used within the Python module.

There are some predefined OpTables and ConfigTables, located in the `op` and `resources` folder of PyEZ module directory.

```
ls /usr/local/lib/python2.7/dist-packages/jnpr/junos/op
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

```
ls /usr/local/lib/python2.7/dist-packages/jnpr/junos/resources
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

#### PyEZ OpTable

This section takes `RouteTable` OpTable as an example, it is defined in `op/routes.yml` file.

```
cat /usr/local/lib/python2.7/dist-packages/jnpr/junos/op/routes.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

To use OpTable, first import the dictionary name defined in YAML files that has the `rpc` key, the name usually ends with 'Table'.

The import path is constructed from the file name path, change `/` to `.` and remove the extension.

```
python
from jnpr.junos.op.routes import RouteTable
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet</button>

Next, create Table instance, same as Config instance, use device's `bind()` function to associate the Table with the Device.

```
from jnpr.junos import Device
dev = Device('vqfx', user='root', password='VR-netlab9')
dev.open()
dev.bind(routes=RouteTable)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

Run `get()` function, what PyEZ does here is to run the RPC defined in `rpc` key in YAML file, which is `<get-route-information>`.

The `get()` function accepts same arguments as `dev.rpc.get_route_information()`. Let's pass `table='inet.0'` to specify the default route table, it is same as the CLI command `show route table inet.0`.

```
dev.routes.get(table='inet.0')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 5)">Run this snippet</button>

Now, you can show all collected routes by accessing the dictionary keys.

```
dev.routes.keys()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 6)">Run this snippet</button>

For each routes, access its dictionary keys to get the route information.

```
dev.routes['10.0.0.0/24'].keys()
dev.routes['10.0.0.0/24'].via
dev.routes['10.0.0.0/24'].protocol
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 7)">Run this snippet</button>

To display all routes information, use a `for` loop to iterate over the Tables object.

<pre>
for route in dev.routes:
    print(route.key, route.protocol, route.via, route.age, route.nexthop)

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 8)">Run this snippet</button>

PyEZ OpTable enables users with **NO** XML knowledge to manage and automate Junos devices. As illustrated in above examples, you can retrieve device's route table without any XML elements.

All you need is to just call `get()` function, and all pre-defined information will be fetched and populated in the dictionary and ready for your access. It hides all RPC requests and XML data parsing code.

#### PyEZ ConfigTable

In a simple view, ConfigTable is just the reverse of OpTable.

OpTable parses XML output from Junos and populates the dictionary's attributes, ConfigTable read the dictionary's attributes and converts to a XML config object for applying to Junos device.

This section takes `StaticRouteTable` ConfigTable as an example, it is defined in `resources/staticroutes.yml` file.

```
exit()
cat /usr/local/lib/python2.7/dist-packages/jnpr/junos/resources/staticroutes.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 9)">Run this snippet</button>

Similar to OpTable, first step is to import the dictionary name defined in YAML file that has `set` key, the name usually ends with 'Table'.

```
python
from jnpr.junos.resources.staticroutes import StaticRouteTable
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 10)">Run this snippet</button>

Next, create Table instance and use `bind()` function to associate with the Device.

```
from jnpr.junos import Device
dev = Device('vqfx', user='root', password='VR-netlab9')
dev.open()
dev.bind(route=StaticRouteTable)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 11)">Run this snippet</button>

Dictionary `StaticRouteView` in the YAML file determines available settings for this ConfigTable. As in the terminal output, `route_name` and `hop` are defined, and we can assign values to these attributes:

```
dev.route.route_name = '192.168.100.0/24'
dev.route.hop = '10.0.0.2'
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 12)">Run this snippet</button>

After configured one set of data, call the `append()` function.

```
dev.route.append()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 13)">Run this snippet</button>

If there is additional data, set them again and call another `append()`.

```
dev.route.route_name = '192.168.200.0/24'
dev.route.hop = '10.0.0.2'
dev.route.append()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 14)">Run this snippet</button>

Finally, when finished appending all new configs, call `set()` function.

```
dev.route.set()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 15)">Run this snippet</button>

Verify new config is applied to vQFX.

```
cli
show configuration |compare rollback 1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 16)">Run this snippet</button>

ConfigTable enables users to provision Junos config without XML elements. You don't have to prepare the configuration file or any `set` commands, instead, just simply configure dictionary values and then call `append()` and `set()` function.

Congratulation! You have finished the Junos Automation by PyEZ lesson. Hope you will start and enjoy using Junos PyEZ to manage your Junos devices!
