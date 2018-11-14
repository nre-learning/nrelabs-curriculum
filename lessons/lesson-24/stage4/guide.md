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

We use the `get_config()` function to get Junos configuration. The optional `options` argument
allows us to provide some additional detail for the kind of configuration we're requesting, such as candidate vs committed, default vs inherit, etc.
By default, `get_config()` returns the non-inherit candidate configuration.

Let's use the `get_config()` function below and provide options to get the inherited and committed configuration:

```
config = dev.rpc.get_config(
    options={'database':'committed', 'inherit':'inherit'})
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

Now that the configuration is stored in the `config` variable, we can use the `findtext()` function to get our device's host name:

```
config.findtext('system/host-name')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

We can also provide another optional argument for `get_config()` called `filter_xml`. This is used to limit the returned configuration hierarchy. This parameter requires us to pass
in an XML `etree` object, so to build this, we use the `lxml` package we used previously. This package's `E()` function can be supplied inline to get us an `etree` object to provide to `filter_xml`.

For example, the below function call retrieves and displays the **committed** Junos config with only the `system` and `protocols bgp` hierarchy in the **set** format:

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
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet</button>

The `filter_xml` argument is useful when the Junos device contains a huge config; the retrieval of a very large config can take a long time and is CPU intensive. With this filter, we can retrieve only what we need.

#### Provision Junos configuration

To work with a Junos configuration, first import `Config` module from `jnpr.junos.utils.config`, and then use the `bind()` function to create association with existing Device.

```
from jnpr.junos.utils.config import Config
dev.bind(cu=Config)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

After that, use the `load()` function to load target config; it supports both text and set format. In the below example, we're providing a config snippet to set Junos device's host name to 'vqfx_new':

```
config_text = '''
system {
  host-name vqfx_new;
}'''
dev.cu.load(config_text, format='text')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 5)">Run this snippet</button>

In this example, we provided the configuration as a multi-line string literal, stored in `config_text`. You can (and should) use <a href="/labs/?lessonId=16&lessonStage=1" target="_blank">Jinja.</a> to create configuration snippets from a template, and pass the result into `dev.cu.load`, but this is sufficient for a quick example.

##### Commit Junos configuration

After loading the config, you can see the current candidate changes (similar to how you would use `show | compare` on the command-line) by calling the `pdiff()` function.

```
dev.cu.pdiff()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 7)">Run this snippet</button>


Loading the configuration is only part of the story. Just like on the CLI, when we make a change to the config, we have to commit it to make those changes take effect:

```
dev.cu.commit()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 8)">Run this snippet</button>

Finally, we can go to our Junos CLI to verify the last configuration change:

```
cli
show configuration | compare rollback 1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 9)">Run this snippet</button>

By now, you should know all the common operations on Junos automation in PyEZ. In the next section, we'll look at one more tool in the PyEZ arsenal - Tables and Views.
