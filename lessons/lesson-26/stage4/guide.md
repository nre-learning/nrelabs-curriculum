## Vendor neutral configuration provisioning using YANG and OpenConfig

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 4 - Custom YANG config provisioning using CLI and NETCONF

In this stage, we will configure the L3VPN services using the `vpn-services` config knob defined by our custom YANG model.

#### Preparation
Firstly, we repeat what we have done in previous stage - copy both YANG model and translation script to vQFX, and then install it.

```
cd /antidote/lessons/lesson-26
sshpass -p antidotepassword scp -o StrictHostKeyChecking=no vpn-services.yang vpn-services.py antidote@vqfx:~
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

```
request system yang add package vpn-services module vpn-services.yang translation-script vpn-services.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 1)">Run this snippet</button>

Same as before, press `ENTER` when you're asked to restart the `cli`


#### Config using custom YANG
As you would expect, config using custom YANG is exactly the same way as in OpenConfig and native Junos config.
Now, we configure a new L3VPN instance using CLI, notice the our custom vpn-service:vpn-service stanza:

```
configure
edit vpn-services:vpn-services l3vpn CustomerA
set interface xe-0/0/4 vlan-id 10 ip-address 192.168.10.1/24
set route-distinguisher 1.2.3.4:10 vrf-target 1.2.3.4:10
set static-route route 192.168.0.0/17 next-hop 192.168.10.254
set static-route route 192.168.128.0/17 next-hop 192.168.10.253
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 2)">Run this snippet</button>

#### Config verification
We can also check the translated configuration:

```
show configuration | display translation-script translated-config | no-more
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 3)">Run this snippet</button>

Verify a new routing instance is created.

```
show route table CustomerA.inet.0
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 4)">Run this snippet</button>

#### config custom YANG configration using NETCONF
Now, let's try to create another L3VPN instance using NETCONF. Firstly, go to Python interactive prompt, load PyEZ module and create a Junos device object:

```
python
from jnpr.junos import Device
from jnpr.junos.utils.config import Config
dev = Device('vqfx', user='antidote', password='antidotepassword')
dev.bind(cu=Config)
dev.open()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 5)">Run this snippet</button>

Then we load the configuration, print the diff, and commit:

```
dev.cu.load(path='vpn-services.conf', format='text')
dev.cu.pdiff()
dev.cu.commit(timeout=600)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 6)">Run this snippet</button>

Verify the translated config:

```
show configuration | display translation-script translated-config | no-more
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 7)">Run this snippet</button>

To conclude we demostrated how to provision Junos device using custom YANG modules via CLI and NETCONF. Custom YANG modules is flexible that it can be used to define custom service oriented configration models to suit your business needs. Please feel free to to modify the configuration by yourself and see how the translation script helps you to provision the corresponding Junos configuration.

For further information about custom YANG on Junos please visit Juniper TechLibrary "[Understanding the Management of Nonnative YANG Modules on Devices Running Junos OS](https://www.juniper.net/documentation/en_US/junos/topics/concept/netconf-yang-modules-custom-managing-overview.html)"
