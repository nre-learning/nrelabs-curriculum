### Junos Automation with PyEZ

*Contributed by Raymond Lam @jnpr-raylam*

---

#### Part 5 - PyEZ Tables and Views

Tables and Views provide a simple and efficient way to extract information from complex operational command output or configuration data and map it to a Python data structure. 

There are two types of tables - Operational Tables and Config Tables. Operational Tables select items from the RPC reply of an operational command, and configuration Tables select data from specific hierarchies in the selected configuration database. Each Table item represents a record of data and has a unique key. A Table also references a Table View, which is used to map the tag names in the data to the variable property names used within the Python module.

There are some predefined OpTables and ConfigTables, located in the `op` and `resources` folder of PyEZ module directory.

```
ls /usr/local/lib/python2.7/dist-packages/jnpr/junos/op
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

```
ls /usr/local/lib/python2.7/dist-packages/jnpr/junos/resources
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

##### 1. PyEZ OpTable

This section describes `RouteTable` OpTable, it is defined in `op/routes.yml` file

```
cat /usr/local/lib/python2.7/dist-packages/jnpr/junos/op/routes.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

To use OpTable, first import the dictionary name defined in YAML files that has the `rpc` key, the name usually ends with 'Table'.

The `from` part in the import statement is constructed from the file name path, change `/` to `.` and remove the extension.

```
python
from jnpr.junos.op.routes import RouteTable
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet</button>

Next, create Table instance, same as Config instance, two syntax are available - provide the `Device` object as argument in creation statement, or use device's `bind()` function to associate the Table with the Device.

<pre>
from jnpr.junos import Device
dev = Device('vqfx', user='root', password='VR-netlab9').open()
dev.bind(routes=RouteTable)
## OR ## routes = RouteTable(dev)

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

Run `get()` function, what PyEZ does here is to run the RPC defined in `rpc` key in YAML file, which is `<get-route-information>`.

The `get()` function accepts same arguments as `dev.rpc.get_route_information()`, here passing in `table='inet.0'` to specify the default route table, it is same as the CLI command `show route table inet.0`.

```
dev.routes.get(table='inet.0')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 5)">Run this snippet</button>

Now, you can show which routes are collected by accessing the dictionary keys.

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

All available keys are defined in the `routes.yml` YAML file.

To display all routes information, use a for loop to iterate over the Tables object.

<pre>
for route in dev.routes:
    print(route.key, route.protocol, route.via, route.age, route.nexthop)

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 8)">Run this snippet</button>

##### 1.1 Details of PyEZ OpTable

To explain the relationship between the YAML and XML, let's put them side by side as below. Those non-related XML element tags are deleted for brevity

```
<route-information>                                             RouteTable:
    <route-table>                                                 rpc: get-route-information
        <table-name>inet.0</table-name>                           args_key: destination
        <rt>                                                      item: route-table/rt
            <rt-destination>10.0.0.0/24</rt-destination>          key: rt-destination
            <rt-entry>                                            view: RouteTableView
                <protocol-name>Direct</protocol-name>
                <age seconds="4543">01:15:43</age>              RouteTableView:
                <nh>                                              groups:
                    <selected-next-hop/>                            entry: rt-entry
                    <via>em0.0</via>                              fields_entry:
                </nh>                                               # fields taken from the group 'entry'
            </rt-entry>                                             protocol: protocol-name
        </rt>                                                       via: nh/via | nh/nh-local-interface
    </route-table>                                                  age: { age/@seconds : int }
</route-information>                                                nexthop: nh/to
```

First, the name `RouteTable` defines the object name for import, create and bind to the Device object.

Under the RouteTable, define the `rpc` key to specify the RPC request tag, it will be called once the `get()` function of the RouteTable object is called.

For `args_key`, in Junos, there are some command arguments that the key can be omitted and simply provide the value.

`destination` in `show route` is one of the examples, here, you don't have to use `show route destination 10.0.0.0/24`, but the `<destination>` is used in the actual XML RPC call.

```
cli
show route 10.0.0.0/24 |display xml rpc
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 10)">Run this snippet</button>

This kind of special handling is called argument keys. The `args_key` in the OpTable is to simulate that behavior. With the `args_key` defined to be `destination`, to get some specific routes, just simply call `dev.routes.get('10.0.0.0/24')`, rather than `dev.routes.get(destination='10.0.0.0/24')`.

For other arguments, still has to specify the key=value pair, e.g., `dev.routes.get(table='inet.0')`.

The `item` variable in the YAML definition determines how to group the data in the dictionary output. The RouteTable is set to `route-table/rt`, which means that it will create each dictionary entry for each `<route-table><rt>` XML hierarchy.

For each dictionary entry, its key is determined by the `key` variable in YAML. In the example, `'route-table/rt/rt-destination' (e.g., 10.0.0.0/24)` will become the dictionary key.

```
dev.routes.keys()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 11)">Run this snippet</button>

Now, the first level key of the RouteTable object is `rt-destination (e.g., 10.0.0.0/24)`, the secondary level keys are defined in the `view` variable which points to `RouteTableView`.

Let's rewrite the RouteTableView as follows, below two RouteTableView produce the same result:

```
RouteTableView:                            -->   RouteTableView:
  groups:                                          fields:
    entry: rt-entry                                  protocol: rt-entry/protocol-name
  fields_entry:                                      via: rt-entry/nh/via | rt-entry/nh/nh-local-interface
    # fields taken from the group 'entry'            age: { rt-entry/age/@seconds: int }
    protocol: protocol-name                          nexthop: rt-entry/nh/to
    via: nh/via | nh/nh-local-interface
    age: { age/@seconds : int }
    nexthop: nh/to
```

Here, under the `RouteTableView`, it defines four entries, point to different XML element nodes, corresponding to the 4 secondary level keys of the resulting object - `protocol`, `via`, `age`, `nexthop`.

```
dev.routes['10.0.0.0/24'].keys()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 13)">Run this snippet</button>

In the re-wrote RouteTableView, the `protocol` field is `rt-entry/protocol-name`, so the value of XML tag `<rt-entry><protocol-name>` under the item `<route-table><rt>` will be assigned to the key `protocol`.

```
dev.routes['10.0.0.0/24'].protocol
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 14)">Run this snippet</button>

`via` is a little bit different, it uses the or `|` operator, that means it first tries to assign the XML `<rt-entry><nh><via>` to the `via` key, if that element node is not available, it tries `<rt-entry><nh><nh-local-interface>`.

```
dev.routes['10.0.0.0/24'].via
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 15)">Run this snippet</button>

`age` is another format. By default, all the value of the RouteTable's secondary level key is in string type.

Use the syntax `{ xml/path: int }` to ask the OpTable to change the value to another type - integer `int` in this example.

Also, the xpath of `age` is `rt-entry/age/@seconds`, `@` means getting the attribute inside the tag, it tries to fetch the attribute `seconds` inside the tag `<age seconds="4543">`, and the result is 4543 here (your terminal output should be different depends on the actual device uptime).

```
dev.routes['10.0.0.0/24'].age
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 16)">Run this snippet</button>

Last, `nexthop` is assigned the value of XML `<rt-entry><nh><to>`. In this example, there is no next-hop for direct route, the value is `None` here.

```
print(dev.routes['10.0.0.0/24'].nexthop)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 17)">Run this snippet</button>

Back to the original pre-defined RouteTableView, all the xpath of the fields are begin with `rt-entry/`. Use `groups` variable here, to define a hierarchy called `entry` which points to the `<rt-entry>` element node.

```
RouteTableView:                            -->   RouteTableView:
  groups:                                          fields:
    entry: rt-entry                                  protocol: rt-entry/protocol-name
  fields_entry:                                      via: rt-entry/nh/via | rt-entry/nh/nh-local-interface
    # fields taken from the group 'entry'            age: { rt-entry/age/@seconds: int }
    protocol: protocol-name                          nexthop: rt-entry/nh/to
    via: nh/via | nh/nh-local-interface
    age: { age/@seconds : int }
    nexthop: nh/to
```

For subsequent variable assignment, it is defined under `fields_<group_name>`, it is `fields_entry` here, and all the xpath defined under the `fields_entry` will be prepended by `rt-entry/`.

###### 1.2 Benefits of PyEZ OpTable

Define which field is populated for the dictionary, choose which field acts as the dictionary key. The architecture of the dictionary follows the definition in the YAML file.

Useful for extracting same data frequently.  For example, if the program has to extract and manipulate route information in multiple places, you have to use `xpath()` in a for loop, and multiple `findtext()` function in each code blocks.

For OpTable, all you need is just one `get()` function, and all the required information will be packed in the dictionary and ready for your access.

OpTable is a feature to hide all the RPC request and the XML data parsing.

One downside is the limited set of pre-defined OpTable, if the predefined one doesn't fit you, you have to write your own one.

OpTable is useful for repeated case, not worth to write a new OpTable for just one off case.

For one off case, use the `xpath()` function instead.

###### 1.3 Create your own OpTable

First, define your own OpTable in a YAML file, the file should contain one `XXXXTable` and one `XXXXTableView`.

The file extension should be `*.yml`, and put the file under `jnpr/junos/op`.

```
exit()
cd ~
cat > myroutes.yml <<EOF
---
MyRouteTable:
  rpc: get-route-information
  args_key: destination
  item: route-table/rt
  key: rt-destination
  view: MyRouteTableView

MyRouteTableView:
  groups:
    entry: rt-entry
  fields_entry:
    # fields taken from the group 'entry'
    protocol: protocol-name
    via: nh/via | nh/nh-local-interface
    age: { age/@seconds : int }
    age_HMS_format: age
    nexthop: nh/to
EOF
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 19)">Run this snippet</button>

Next, create a `*.py` file with the same name, the file should contain below content.

```
cat > myroutes.py <<EOF
from jnpr.junos.factory import loadyaml
from os.path import splitext
_YAML_ = splitext(__file__)[0] + '.yml'
globals().update(loadyaml(_YAML_))
EOF
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 20)">Run this snippet</button>

Just copy and paste these 4 lines, not required to understand them for using the OpTable.

Verify the new OpTable has the new key `age_HMS_format` that specify the route age in Hour:Minute:Second format.

```
python
from myroutes import MyRouteTable
from jnpr.junos import Device
dev = Device('vqfx', user='root', password='VR-netlab9').open()
dev.bind(myRoutes=MyRouteTable)
dev.myRoutes.get(table='inet.0')
dev.myRoutes['10.0.0.0/24'].keys()
dev.myRoutes['10.0.0.0/24'].age_HMS_format
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 21)">Run this snippet</button>

#### 2. PyEZ ConfigTable

In a simple view, ConfigTable is just the reverse of OpTable.

OpTable parses the XML output from Junos and populates the dictionary's attributes, ConfigTable read the dictionary's attributes and converts to a XML config object for loading to the Junos device.

This section describes the `StaticRouteTable` ConfigTable, it is defined in `resources/staticroutes.yml` file.

```
exit()
cat /usr/local/lib/python2.7/dist-packages/jnpr/junos/resources/staticroutes.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 22)">Run this snippet</button>

Similar to OpTable, first step is to import the dictionary name defined in YAML file that has the `set` key, the name usually ends with 'Table'

The `from` part in the import statement is constructed from the file name path, change the `/` to `.` and remove the extension.

```
python
from jnpr.junos.resources.staticroutes import StaticRouteTable
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 23)">Run this snippet</button>

Next, create the Table instance, similarly, two syntax are available.

<pre>
from jnpr.junos import Device
dev = Device('vqfx', user='root', password='VR-netlab9').open()
dev.bind(route=StaticRouteTable)
## OR ## route = StaticRouteTable(dev)

</pre>
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 24)">Run this snippet</button>

Check the `StaticRouteView` in the YAML file to determine the available settings for this ConfigTable. Here, `route_name` and `hop` are defined.

Set the attributes of the ConfigTable object.

```
dev.route.route_name = '192.168.100.0/24'
dev.route.hop = '10.0.0.2'
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 25)">Run this snippet</button>

After configured one set of data, call the `append()` function.

```
dev.route.append()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 26)">Run this snippet</button>

If there is additional data, set them again and call another `append()`.

```
dev.route.route_name = '192.168.200.0/24'
dev.route.hop = '10.0.0.2'
dev.route.append()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 27)">Run this snippet</button>

Finally, when finished append all the new config, call `set()` function.

```
dev.route.set()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 28)">Run this snippet</button>

Verify the new config is applied to Junos.

```
cli
show configuration |compare rollback 1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 29)">Run this snippet</button>

What `set()` actually does is call the `lock()`, `load()`, `commit()` and `unlock()` function in the Config object.

##### 2.1 Details of PyEZ ConfigTable

The relationship between ConfigTable YAML and XML is quite similar to that between OpTable and XML.

Below is the XML of new config applied to Junos from last section, and I put the content of StaticRouteTable side by side for easy comparison.

```
<routing-options>                                 StaticRouteTable:
    <static>                                        set: routing-options/static/route
        <route>                                     key-field:
            <name>192.168.100.0/24</name>             - route_name
            <next-hop>10.0.0.2</next-hop>           view: StaticRouteView
        </route>
        <route>                                   StaticRouteView:
            <name>192.168.200.0/24</name>           fields:
            <next-hop>10.0.0.2</next-hop>             route_name: name
        </route>                                      hop: next-hop
    </static>
</routing-options>
```

First, the name `StaticRouteTable` defines the object name for import, create and bind.

Under the StaticRouteTable, the `set` variable defines the base XML path for subsequent configuration.

From the config XML, all the static route related configuration are under `<routing-options><static><route>`, so define 'set' as `routing-options/static/route`.

The `key-field` is used as the temporary dictionary key, in which the dictionary will convert to XML and load to the Junos device.

For each configuration element, define the attribute under the `fields` which is under the `StaticRouteView` pointed by the `view` variable in the StaticRouteTable.

The value of each variables under `fields` is a XML element node under the `set` xpath.

We have defined `route_name` to 192.168.100.0/24 and `hop` to 10.0.0.2, after run the `append()` function, below XML will be created, by appending the `<name>` and `<next-hop>` element node under `<routing-options><static><route>`.

```
<routing-options>
    <static>
        <route>
            <name>192.168.100.0/24</name>
            <next-hop>10.0.0.2</next-hop>
        </route>
    </static>
</routing-options>
```

By calling the `set()` function, the XML is loaded to Junos and the new config is committed.

##### 2.2 Benefits of PyEZ ConfigTable

ConfigTable is useful when applying some set of config data frequently, no need to prepare the configuration file or the set commands.

Just setting the dictionary attributes, call the `append()` and `set()`.

Similar to OpTable, downside is the limited set of pre-defined ConfigTable, if it doesn't fit you, write your own one.

For repeated case. If apply one off config, not worth to write a new ConfigTable.

##### 2.3 Create your own ConfigTable

Same as creating the OpTable, create two files - `*.yml` and `*.py`, and then put them under `jnpr/junos/resources`.

The YAML file contains the ConfigTable definition and the Python file contains the 4 lines of boilerplate code.
