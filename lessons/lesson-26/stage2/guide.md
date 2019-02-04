## Automating with Openconfig

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 2 - Provision Openconfig using CLI and Netconf

Same as normal Junos configuration, we can use CLI and Netconf to provision Openconfig.

To add an interface with OpenConfig, we apply configuration under `openconfig-interfaces:interfaces` stanza.

```
configure
set openconfig-interfaces:interfaces interface xe-0/0/0 subinterfaces subinterface 0 openconfig-if-ip:ipv4 addresses address 192.168.10.1/24
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 0)">Run this snippet</button>


Verify the new interface is created.

```
show interfaces terse xe-0/0/0
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 1)">Run this snippet</button>


Show the translated Junos config from Openconfig.

```
show configuration | display translation-scripts translated-config | no-more
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 2)">Run this snippet</button>


Now, let's try to configure a new BGP neighbor with Openconfig using Netconf. First, take a look on the openconfig-bgp configuration we're going to apply.

```
cd /antidote/lessons/lesson-26
cat openconfig-bgp.conf
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 3)">Run this snippet</button>

After that, go to Python interactive prompt, load PyEZ module and create a Junos device object.

(If you're not familiar with PyEZ, here is the course [Junos Automation with PyEZ](https://labs.networkreliability.engineering/labs/?lessonId=24&lessonStage=1)!)

```
python
from jnpr.junos import Device
from jnpr.junos.utils.config import Config
dev = Device('vqfx', user='antidote', password='antidotepassword')
dev.bind(cu=Config)
dev.open()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 4)">Run this snippet</button>

Next, load the configuration, print the diff, and then commit.

```
dev.cu.load(path='openconfig-bgp.conf', format='text')
dev.cu.pdiff()
dev.cu.commit()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 5)">Run this snippet</button>

Verify a new BGP neighbor is created. Here, the neighbor doesn't exist in the network, so the BGP state is expected to be `Connect` or `Active`

```
show bgp summary
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 6)">Run this snippet</button>

Show the translated Junos config again.

```
show configuration | display translation-scripts translated-config | no-more
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 7)">Run this snippet</button>
