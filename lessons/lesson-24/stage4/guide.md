## Junos Automation with PyEZ

*Contributed by Raymond Lam @jnpr-raylam*

---

### Part 4 - Configuration Management

#### 1. Get Junos configuration

To get Junos configuration, it's similar to collecting data in previous sections - first connect to the Junos, create the `Device` instance, passing in the username, password, enable normalization, use port 22, and then call the `open()` function.

Let's connect to vQFX now for preparing upcoming tasks.

```
python
from jnpr.junos import Device
dev = Device('vqfx', user='root', password='VR-netlab9',
             normalize=True, port=22).open()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

Remember RPC of getting configuration is `get_config()`. It is a special RPC that you can't use the `|display xml rpc` or `display_xml_rpc()` to get the XML tag.

The `get_config()` function accepts two parameters only, first is `options` argument to get different config version, e.g., candidate vs committed, default vs inherit

```
options={'database':'committed|candidate'}
options={'inherit':'inherit'}
options={'format':'text|set'}
```

By default, without any arguments, it returns non-inherit candidate configuration.

For example, to get the inherited and committed configuration, use below RPC call, assign a dictionary to the `options` argument.

```
config = dev.rpc.get_config(
    options={'database':'committed', 'inherit':'inherit'})
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

Same as before, there is no output from above function call, and the Junos configuration is saved to `config` variable for further parsing.

Second acceptable argument is `filter_xml`, it is used to limit the returned configuration hierarchy, the required type of `filter_xml` object is XML etree.

```
filter_xml=<lxml.etree._Element object>
```

##### 1.1 Construct XML object

Several methods to build the XML object for `filter_xml` argument.  Most simple one is preparing XML string and use `etree.fromstring()` function to convert it to an XML object.

```
from lxml import etree
xml = etree.fromstring('<configuration><system><host-name>vqfx</host-name></system></configuration>')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

After that, verify the type of `xml` variable and display it as XML string using `etree.tostring()` function.

```
type(xml)
print(etree.tostring(xml, pretty_print=True))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 5)">Run this snippet</button>

Manually prepare the XML string by typing all starting and ending tag is quite error prone, so it's not recommended.

Second method is use lxml builder function, the `E()` builder is quite similar to SLAX when building the XML tree:

```
Python lxml builder E()          SLAX
=======================          =======================
xml = E.configuration(           var $xml = <configuration> {
    E.system(                        <system> {
        E('host-name', 'vqfx')            <host-name> "vqfx";
    )                                }
)                                }
```

To build the XML above, its top level tag is `<configuration>`, so the outermost function is `E.configuration()`.

Next level is `<system>`, so put `E.system()` as the argument of `E.configuration()`.

Next level is `<host-name>`, again, Python doesn't support hyphen in function name, so use another format of `E()` function: `E(tag, element)`.

```
from lxml.builder import E
xml = E.configuration(
          E.system(
              E('host-name', 'vqfx')
          )
      )
print(etree.tostring(xml, pretty_print=True))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 7)">Run this snippet</button>

Above snippet creates the same XML object as before, but we don't have to manually type the XML tag now.

##### 1.2 Group all things together

To get Junos config with only `system` and `protocols bgp` hierarchy, and the config should inherit all apply-groups and display as text format, we will use below `get_config()` function call.

```
dev = Device('vqfx', user='root', password='VR-netlab9', port=22)
dev.open()
config = dev.rpc.get_config(
    options={'inherit':'inherit', 'format':'text'},
    filter_xml=E.configuration(
        E.system,
        E.protocols(
            E.bgp
        )
    )
)
print(config.text)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 8)">Run this snippet</button>

`filter_xml` technique is useful when the Junos device contains a huge config, gathering of a huge config takes a long time and is CPU intensive. Best practice is don't collect anything that you don't need.

##### 1.3 get\_config() vs other get\_some\_information()

You may get confused between normal RPC and the `get_config()` RPC call. Below summarizes their supported arguments and its usage.

```
get_some_information()
    {'format':'text|json'}                  # Get format other than XML
    key=value                               # e.g. interface_name='ge-0/0/0'
    flag=True                               # e.g. statistics=True

get_config()
    options={'format':'text|set|json'}      # Get format other than XML
    filter_xml=E.system()                   # Filter the XML result
```
For `get_some_information()`, provide any arguments that is valid under the corresponding RPC request:
  - For key/value pair, just pass `key=value`; for config flag,  pass `flag=True`
  - If text format is needed, pass the dictionary with key is `format`, and value is `text` or other desired format

For `get_config()`, it accepts two arguments only:
  - `options` to specify the desired output format, or whether the config is inherit and the config database
  - `filter_xml` to filter the config pull from Junos, accepted object is XML etree, use the XML builder `E()` function to construct the XML object


#### 2. Parse Junos configuration

You can use the same techniques for parsing RPC replies to parse Junos config. First, let's print `config` XML etree object as string directly.

```
dev = Device('vqfx', user='root', password='VR-netlab9',
             normalize=True, port=22).open()
config = dev.rpc.get_config()
print(etree.tostring(config, pretty_print=True))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 10)">Run this snippet</button>

And use `xpath` to query target config knob:

```
print(config.findtext('system/host-name'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 11)">Run this snippet</button>


#### 3. Provision Junos configuration

To change the configuration, you have to import `Config` module from `jnpr.junos.utils.config`.

```
from jnpr.junos.utils.config import Config
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 12)">Run this snippet</button>

And then create Config instance, there are two syntax for instance creation.

  1. Create the Config instance, pass the Device object as argument, and then assign the Config object to a variable

    For this syntax, call `load()` and `commit()` function of `cu` variable to load and commit config on Junos device

    ```
    cu = Config(dev); cu.load(); cu.commit()
    ```

  2. Use device's `bind()` function to create association between new Config object with existing Device

    Call the `dev.bind()` function, provide argument `cu=Config`, `cu` is an arbitrary variable name and `Config` is the module name

    After that, all subsequent `load()` and `commit()` function is called on `dev.cu` object

    ```
    dev.bind(cu=Config); dev.cu.load(); dev.cu.commit()
    ```

Recommend to use second syntax. Most likely your code will deal with multiple devices. With `bind()` syntax, you don't have to keep separate Config object variable for each devices.

In addition, apart from Config module, there are other PyEZ modules supporting both initialization syntax. Use `bind()` syntax for all these modules can group devices related attributes together.

##### 3.1 Load Junos configuration

To load Junos config, call `load()` function with several arguments.

If the config is stored in a XML/string object in the program, provide the object as the first argument to the `load()` function.

```
dev.cu.load(object, format='xml|text|set')
```

If the config is saved in a file, provide the `path` argument to indicate the path of config file.

```
dev.cu.load(path='filename', format='xml|text|set')
```

To demonstrate loading configuration using XML/string object, all 4 lines of code below will set the Junos device's host name to 'vqfx_new'

```
dev = Device('vqfx', user='root', password='VR-netlab9', port=22).open()
dev.bind(cu=Config)
dev.cu.load(E.configuration(E.system(E('host-name', 'vqfx_new'))), format='xml')
dev.cu.load('<configuration><system><host-name>vqfx_new</host-name></system></configuration>', format='xml')
dev.cu.load('system { host-name vqfx_new; }', format='text')
dev.cu.load('set system host-name vqfx_new', format='set')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 17)">Run this snippet</button>

For XML format, either provide the XML etree object or the XML string; For text & set format, provide the string in the specified format.

Recommend to use the set format, when you enclose the config in your program, most likely the config is simple. E.g., just simply disable some interfaces, or add some static routes.

In that case, set format is the most convenience way and providing the same feeling as what you type in Junos CLI.

If you have to load a large piece of configuration, suggest to put it in a separate file, and pass the filename as `path` argument to the `load()` function.

For loading config from file system, PyEZ use the file extension to determine its format. For text format, use either `conf`, `txt` or `text`. For XML or set format, use `xml` and `set` respectively.  You can also set the `format` argument to override the auto decision based on file extension.

```
dev.cu.load(path='junos_config.[xml|conf|text|txt|set]', format='[xml|text|set]')
```

Besides loading a plain text config file, you may consider to use jinja2 template, which is a file contains the Junos config, plus some special tags to indicate the variables. PyEZ provides the variable values to feed into the template and load it onto Junos device.

##### 3.2 Commit Junos configuration

After loading the config in previous section, you can do the `show |compare` by calling the `pdiff()` function.

```
dev.cu.pdiff()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 19)">Run this snippet</button>

Next, same as Junos CLI, perform config commit.

```
dev.cu.commit()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 20)">Run this snippet</button>

And then verify the change has been applied to vQFX.

```
cli
show configuration |compare rollback 1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 21)">Run this snippet</button>

The `commit()` function accepts arguments to modify the commit behavior, just like `commit comment` and `commit confirm` feature.

Try to commit config again, but add the comment and give it a 5 minutes time to further confirm.

```
dev.cu.load('set system host-name vqfx', format='set')
dev.cu.commit(comment='Commit from PyEZ', confirm=5)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 22)">Run this snippet</button>

Verify the `commit comment` and `commit confirm` are implemented in vQFX.

```
show system commit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 23)">Run this snippet</button>

Now re-commit the config again to confirm.

```
dev.cu.commit()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 24)">Run this snippet</button>

On top of above functions, there are a few more in the Config module, their usage is to reflect the similar features in Junos CLI.

```
cu.lock()           cu.commit_check()
cu.unlock()         cu.rollback()
```
I'm not going to illustrate above functions one by one, you can test it by yourself if interested.

By now, you should know all the common operations on Junos automation by PyEZ. In next section, I will introduce one more tool - PyEZ Tables and Views. 

  
