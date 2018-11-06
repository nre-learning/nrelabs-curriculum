## Junos Automation with PyEZ

**Contributed by: [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Part 4 - Configuration Management

#### Get Junos configuration

Before starting this section, let's apply the boilerplate code to import PyEZ module and connect to vQFX.

```
python
from jnpr.junos import Device
dev = Device('vqfx', user='root', password='VR-netlab9')
dev.open()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

We use `get_config()` function to get Junos configuration, it accepts two parameters, first is `options` argument to request different config version, e.g., candidate vs committed, default vs inherit

```
options={'database':'committed|candidate',
         'inherit':'inherit',
         'format':'text|set'}
```

By default, without the options arguments, it returns non-inherit candidate configuration.

For example, use below function to get inherited and committed configuration.

```
config = dev.rpc.get_config(
    options={'database':'committed', 'inherit':'inherit'})
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

And then use `findtext()` function to get Junos device's host name:

```
config.findtext('system/host-name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet</button>

Second acceptable argument for `get_config()` is `filter_xml`, it is used to limit the returned configuration hierarchy. The required type of `filter_xml` object is XML etree. To build the etree object, we use lxml builder `E()` function.

For example, use below function call to get and display **committed** Junos config with only `system` and `protocols bgp` hierarchy in **set** format:

```
from lxml.builder import E
config = dev.rpc.get_config(
    options={'database':'committed', 'format': 'set'},
    filter_xml=E.configuration(
        E.system,
        E.protocols(
            E.bgp
        )
    )
)
print(config.text)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

`filter_xml` argument is useful when the Junos device contains a huge config, gathering of a huge config takes a long time and is CPU intensive. Best practice is don't collect anything you don't need.

#### Provision Junos configuration

To work with Junos configuration, first import `Config` module from `jnpr.junos.utils.config`, and then use `bind()` function to create association with existing Device.

```
from jnpr.junos.utils.config import Config
dev.bind(cu=Config)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 5)">Run this snippet</button>

After that, use `load()` function to load target config, it supports both text and set format. Below two snippets product the same result - set Junos device's host name to 'vqfx_new'.

```
config_text = '''
system {
  host-name vqfx_new;
}'''
dev.cu.load(config_text, format='text')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 6)">Run this snippet</button>

```
config_set = 'set system host-name vqfx_new'
dev.cu.load(config_set, format='set')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 7)">Run this snippet</button>

##### Commit Junos configuration

After loading the config, you can do the `show | compare` by calling the `pdiff()` function.

```
dev.cu.pdiff()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 8)">Run this snippet</button>

Next, same as Junos CLI, perform config commit.

```
dev.cu.commit()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 9)">Run this snippet</button>

And then verify the change has been applied to vQFX.

```
cli
show configuration |compare rollback 1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 10)">Run this snippet</button>

By now, you should know all the common operations on Junos automation by PyEZ. In next section, I will introduce one more tool - PyEZ Tables and Views.
