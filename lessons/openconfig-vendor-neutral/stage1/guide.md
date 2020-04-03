## Vendor-Neutral Network Configuration with OpenConfig

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 2 - Provision Openconfig using CLI and Netconf

As with normal Junos configuration, we can use CLI and Netconf to provision Openconfig based configuration.


#### Config using CLI
For example, to add an interface with OpenConfig, we apply configuration under `openconfig-interfaces:interfaces` stanza.

```
configure
set openconfig-interfaces:interfaces interface xe-0/0/0 subinterfaces subinterface 0 openconfig-if-ip:ipv4 addresses address 192.168.10.1/24
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', this)">Run this snippet</button>


Verify the new interface is created.

```
show interfaces terse xe-0/0/0
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', this)">Run this snippet</button>

As discussed in chapter 1, the Junos OpenConfig package contains scripts to translate OpenConfig based configuration into Junos format. We can show the  translated Junos config with the following command:

```
show configuration | display translation-scripts translated-config | no-more
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', this)">Run this snippet</button>

As you can see the fundamental data values are the same across OpenConfig and Junos Config, only the schema differs.

#### Config using Netconf

Now, let's try to configure a new BGP neighbor with Openconfig using Netconf. First, take a look on the openconfig-bgp configuration we're going to apply.

```
cd /antidote
cat openconfig-bgp.conf
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

As you can see, the OpenConfig BGP schema contains common data that BGP requires. This configuration should be able to be provisioned to any network devices that support netconf with OpenConfig.

Here we are using PyEZ (a python module for Junos Netconf connecitity) as a netconf client.
Start a Python interactive prompt, then load the PyEZ module and create a Junos device object.

_(If you're not familiar with PyEZ, check out the lesson "Junos Automation with PyEZ"!)_

```
python
from jnpr.junos import Device
from jnpr.junos.utils.config import Config
dev = Device('vqfx', user='antidote', password='antidotepassword')
dev.bind(cu=Config)
dev.open()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Next, we load the configuration, print the diff, and  commit:

```
dev.cu.load(path='openconfig-bgp.conf', format='text')
dev.cu.pdiff()
dev.cu.commit()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Verify a new BGP neighbor is being created.
**Note:** _the peering neighbor doesn't exist in the setup, therefore the BGP state is expected to be `Connect` or `Active`_

```
show bgp summary
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', this)">Run this snippet</button>

Again we inspect the translated Junos config:

```
show configuration | display translation-scripts translated-config | no-more
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', this)">Run this snippet</button>

Now you can see that OpenConfig is vendor-neutral and therefore this exercise can be applied to any other vendor that also supports OpenConfig (_by using a vendor neutral NetConf Client_).

In the next chapter we will explore custom yang modules where you may define custom data schema for different business needs.
