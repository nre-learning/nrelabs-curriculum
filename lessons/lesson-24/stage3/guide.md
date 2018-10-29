## Junos Automation with PyEZ

### Part 3 - Configuration Management

#### 1. Get Junos configuration

To get Junos configuration, first connect to the Junos. Same as collecting data, create the Device instance, passing in the username, password, enable normalzation, use port 22, and then call the `open()` function

```
python
from jnpr.junos import Device
dev = Device('vqfx1', user='root', password='VR-netlab9', normalize=True, port=22).open()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

Remember that get configuration RPC is `get_config()`. It is a special RPC that you can't use the `|display xml rpc` or `display_xml_rpc()` to get the RPC tag

```
config = dev.rpc.get_config()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

Two arguments can be provided, first is `options` argument to get different config version, e.g., candidate vs commited, default vs inherit

```
options={'database':'committed|candidate'}
options={'inherit':'inherit'}
options={'format':'text|set'}
```

By default, without any arguments, it returns non-inherit candidate configuration

For example, to get the inherited and committed configuration, use below RPC call, assign a dictionary to the `options` argument

```
config = dev.rpc.get_config(options={'database':'committed', 'inherit':'inherit'})
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

Second acceptable argument is `filter_xml`, to limit the returned configuration hierarchy, the type of `filter_xml` object is XML etree

```
filter_xml=<lxml.etree._Element object>
```

##### 1.1 Construct XML object

Several methods to build the XML object for `filter_xml` argument

Most simple is preparing the XML string and use `etree.fromstring()` function to convert it to an XML object

```
from lxml import etree
xml = etree.fromstring('<configuration><system><host-name>vqfx</host-name></system></configuration>')
type(xml)
print(etree.tostring(xml, pretty_print=True))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 5)">Run this snippet</button>

Manually prepare the XML string by typing all starting and ending tag is quite error prone, so not recommended

Second method is use lxml builder function, the `E()` builder is quite similar to SLAX when building the XML tree

```
Python lxml builder E()          SLAX                 
=======================          =======================
xml = E.configuration(           var $xml = <configuration> {
    E.system(                        <system> {
        E('host-name', 'vqfx')            <host-name> "vqfx";
    )                                }
)                                }
```

To build the XML above, its top level tag is `<configuration>`, so the outermost function is `E.configuration()`

Next level is `<system>`, so put `E.system()` as the argument of `E.configuration()`

Next level is `<host-name>`, again, Python doesn't support hyphen in function name, so use another format of `E()` function: `E(tag, element)`

```
from lxml.builder import E
xml = E.configuration(E.system(E('host-name', 'vqfx')))
print(etree.tostring(xml, pretty_print=True))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 7)">Run this snippet</button>

Both `E.tag(element)` and `E(tag, element)` produce the same XML object

```
xml1 = E('node1', E('node2', 'text'))
etree.tostring(xml1)
xml2 = E.node1( E.node2('text') )
etree.tostring(xml2)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 8)">Run this snippet</button>

##### 1.2 Group all things together

To get the Junos config with only `system` and `protocols bgp` hierarchy, and the config should inherit all apply-groups and display as text format

```
dev = Device('vqfx1', user='root', password='VR-netlab9', port=22).open()
config = dev.rpc.get_config(options={'inherit':'inherit', 'format':'text'}, filter_xml=E.configuration(E.system, E.protocols(E.bgp)))
print(config.text)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 9)">Run this snippet</button>

`filter_xml` technique is useful when the Junos device contains a huge config, gathering of a huge config takes a long time and is CPU intensive

Best practice is don't collect anything that you don't need

##### 1.3 get_config() vs other get_some_information()

You may get confused between normal RPC and the `get_config()` RPC call

```
get_some_information()
    {'format':'text|json'}                  # Get format other than XML
    key=value                               # e.g. interface_name='ge-0/0/0'
    flag=True                               # e.g. statistics=True

get_config()
    options={'format':'text|set|json'}      # Get format other than XML
    filter_xml=E.system()                   # Filter the XML result
```
For `get_some_information()`, provide any arguments that is valid under the corresponding RPC request
  - For key/value pair, just pass `key=value`; for config flag,  pass `flag=True`
  - If text format is needed, pass the dictionary with key is `format`, and value is `text` or other desired format

For `get_config()`, it accepts two arguments only
  - `options` to specify the desired output format, or whether the config is inherit and the config database
  - `filter_xml` to filter the config pull from Junos, accepted object is XML etree, use the XML builder `E()` function to construct the XML object


#### 2. Parse Junos configuration

Same technique for parsing Junos config as parsing the replies from other RPC request

You can print the XML etree object as string directly

```
dev = Device('vqfx1', user='root', password='VR-netlab9', normalize=True, port=22).open()
config = dev.rpc.get_config()
print(etree.tostring(config, pretty_print=True))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 11)">Run this snippet</button>

And use `xpath` to query the target config knob

```
print(config.findtext('system/host-name'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 12)">Run this snippet</button>


#### 3. Provision Junos configuration

To change the configuration, import the `Config` module from `jnpr.junos.utils.config`

```
from jnpr.junos.utils.config import Config
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 13)">Run this snippet</button>

And then create the Config instance. Two syntax for the instance creation

First is create the Config instance, pass the Device object as argument, and then assign the Config object to a variable

For this syntax, call the `load()` and `commit()` function of `cu` variable to load and commit config on Junos device

```
cu = Config(dev)
cu.load()
cu.commit()
```

Second syntax is use the device `bind()` function to create the association between the new Config object with existing Device

Call the `dev.bind()` function, provide the argument `cu=Config`, `cu` is an arbitrary variable name and `Config` is the module name

After that, all subsequent `load()` and `commit()` function is called on the `dev.cu` object

```
dev.bind(cu=Config)
dev.cu.load()
dev.cu.commit()
```
    
Recommend to use second syntax. Most likely your code will deal with multiple devices. In that case, you can put all the Device object in a dictioary.

If use the `bind()` syntax, you can use a for loop to load configuration to all devices

```
devices = {}
for vqfx in ('vqfx1', 'vqfx2', 'vqfx3'):
    devices[vqfx] = Device(vqfx, user='root', password='VR-netlab9', port=22).open()
    devices[vqfx].bind(cu=Config)

for vqfx in devices:
    devices[vqfx].cu.load()
    devices[vqfx].cu.commit()
```

Or in somewhere of your code, you just want to apply config on specific device, simply reference the Device object in the dictionary and call its Config function

```
devices['vqfx1'].cu.load()
devices['vqfx1'].cu.commit()
```

With the `bind()` syntax, you don't have to keep separate Config object variable for each devices

In addition, apart from Config module, there are other PyEZ modules supporting both initialization syntax

Use `bind()` syntax for all these modules, all device related attributes can be grouped together

##### 3.1 Load Junos configuration

To load the config, call the `load()` function with several arguments

If the config is stored in a XML/string object in the program, provide the object as the first argument to the `load()` function

```
dev.cu.load(object, format='xml|text|set')
```

If the config is saved in a file, provide the `path` argument to indicate the path of config file

```
dev.cu.load(path='filename', format='xml|text|set')
```

To demonstrate loading the config using XML/string object, all 4 lines of code below will set the Junos device's hostname to 'vqfx1_new'

```
dev = Device('vqfx1', user='root', password='VR-netlab9', port=22).open()
dev.bind(cu=Config)
dev.cu.load(E.configuration(E.system(E('host-name', 'vqfx1_new'))), format='xml')
dev.cu.load('<configuration><system><host-name>vqfx1_new</host-name></system></configuration>', format='xml')
dev.cu.load('system { host-name vqfx1_new; }', format='text')
dev.cu.load('set system host-name vqfx1_new', format='set')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 20)">Run this snippet</button>

For XML format, either provide the XML etree object or the XML string

For text & set format, provide the string in the specified format

Recommend to use the set format, when you enclose the config in your program, most likely the config is simple. E.g., just simply disable some interfaces, or add some static routes

In that case, set format is the most convenience way and providing the same feeling as what you type in Junos CLI

If you have to load a large piece of configuration, suggest to put it in a separate file, and pass the filename as `path` argument to the `load()` function

For loading config from file system, PyEZ use the file extension to determine its format. For text format, use either `conf`, `txt` or `text`. For XML or set format, use `xml` and `set` respectively

You can also set the `format` argument to override the auto decision based on file extension

```
dev.cu.load(path='junos_config.[xml|conf|text|txt|set]', format='[xml|text|set]')
```

Besides loading a plain text config file, you may consider to use jinja2 template, which is a file contains the Junos config, plus some special tags to indicate the varibles. PyEZ provides the variable values to feed into the template and load it onto Junos device

##### 3.2 Commit Junos configuration

After loading the config in last section, you can do the `show |compare` by calling the `pdiff()` function

```
dev.cu.pdiff()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 22)">Run this snippet</button>

Next, same as Junos CLI, perform config commit

```
dev.cu.commit()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 23)">Run this snippet</button>

```
cli
show configuration |compare rollback 1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', 24)">Run this snippet</button>

The `commit()` function accepts arguments to modify the commit behavior, just like `commit comment` and `commit confirm` feature

```
dev.cu.load('set system host-name vqfx1', format='set')
dev.cu.commit(comment='Commit from PyEZ', confirm=5)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 25)">Run this snippet</button>

```
show system commit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', 26)">Run this snippet</button>

Now re-commit the config to confirm

```
dev.cu.commit()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 27)">Run this snippet</button>

On top of above functions, there are a few more in the Config module, their usage is to reflect the similar features in Junos CLI

```
cu.lock()           cu.commit_check()
cu.unlock()         cu.rollback()
```
