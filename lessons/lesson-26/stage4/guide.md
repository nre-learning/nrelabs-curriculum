## Automating with Openconfig

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 4 - Custom Yang config provisioning using CLI and Netconf

In this stage, we will configure the L3VPN services using the `vpn-services` config knob defined by custom Yang.

First, we repeat what we have done in previous stage - copy both yang model and translation script to vQFX, and then install it.

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

Now, configure a new L3VPN instance using CLI.

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

Verify the translated configuration.

```
show configuration | display translation-script translated-config | no-more
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 3)">Run this snippet</button>

Verify a new routing instance is created.

```
show route table CustomerA.inet.0
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 4)">Run this snippet</button>

Now, let's try to create another L3VPN instance using Netconf. First, go to Python interactive prompt, load PyEZ module and create a Junos device object.

```
python
from jnpr.junos import Device
from jnpr.junos.utils.config import Config
dev = Device('vqfx', user='antidote', password='antidotepassword')
dev.bind(cu=Config)
dev.open()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 5)">Run this snippet</button>

Next, load the configuration, print the diff, and then commit.

```
dev.cu.load(path='vpn-services.conf', format='text')
dev.cu.pdiff()
dev.cu.commit(timeout=600)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 6)">Run this snippet</button>

Show the translated config again.

```
show configuration | display translation-script translated-config | no-more
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 7)">Run this snippet</button>

Now, you can try to modify the configuration by yourself and see how the translation script helps you to provision the corresponding Junos configuration.
