## Vendor-Neutral Network Configuration with OpenConfig

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 3 - Custom YANG modules and custom Yang translator
#### Custom YANG modules and Translation Script
OpenConfig supports a variety of data models including BGP, interfaces, routing, MPLS, etc.  Sometimes, however, we might want to define a custom configuration hierarchy to simplify device configurations or standardize configuration across multi-vendor devices.

Yang is a data modeling language for the Netconf protocol. For information about Yang, see [RFC 6020](https://tools.ietf.org/html/rfc6020).

As discussed in the beginning of the course, the YANG configuration will be converted to device specific configuration via a translation mechanism. In Junos this translation mechansim is implemented by translation scripts.

#### Custom YANG Modules with Junos
Juniper offers OpenConfig translation scripts to convert OpenConfig based configuration data into Junos.
To use custom YANG modules, you will need to define the following items:
- custom YANG config models
- custom YANG to Junos translation script
  - this can be implemented using SLAX/XSLT/Python
- custom YANG action script for YANG based operational commands (_e.g. show commands_) (optional)

In this lesson, we're going to define a custom YANG module to create new config stanza, and a custom YANG translation script to translate custom defined configuration to Junos config.

#### Loading Custom YANG Modules
Here we created a custom YANG module called `vpn-services` which helps to configure L3VPN in a service oriented way.
It groups all the L3VPN related parameters (e.g., interfaces, VLAN Id, IP address, RD, RT, etc) into a single place.
Let's take a look on the YANG file first.

```
cd /antidote
cat vpn-services.yang
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

For the translation script, it supports both SLAX and Python language.  We're using Python language in this lesson as it's familiar to most people.  Different with commit script, to improve the efficiency, it processes the delta configuration only and therefore the translation script logic should take care the addition and removal of config knob. Let's take a look on the translation script.

```
cat vpn-services.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

To install the custom YANG module, we have to copy both `vpn-services.yang` and `vpn-services.py` to vQFX:

**Notes:** _if there are multiple Routing Engines in the device, make sure install the YANG modules on each of the Routing Engines._

```
sshpass -p antidotepassword scp -o StrictHostKeyChecking=no vpn-services.* antidote@vqfx:~
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Then we install the custom YANG module by `request system yang add` command:

```
request system yang add package vpn-services module vpn-services.yang translation-script vpn-services.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', this)">Run this snippet</button>

After the installation completed, press `ENTER` key a few times to acknowledge the `cli` process restart request.

#### Validating custom YANG modules
Use the following command to verify the YANG package `vpn-services` is installed and the translation script is enabled:

```
show system yang package vpn-services
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', this)">Run this snippet</button>

Now, the Junos device is ready to be provisioned using the custom yang module. In next lesson, we will configure some L3VPN services using the new `vpn-services` config knob.
