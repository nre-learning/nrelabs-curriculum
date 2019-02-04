## Automating with Openconfig

**Contributed by: [@valjeanchan](https://github.com/valjeanchan) and [@jnpr-raylam](https://github.com/jnpr-raylam)**

---

### Chapter 3 - Custom Yang modules and custom Yang translator

While OpenConfig supports many data models including BGP, interfaces, routing, MPLS, etc.  Sometimes we might want to define custom configuration hierarchy to simplify device configurations or standardize configuration across multi-vendor devices.

Yang is a data modeling language for Netconf protocol. For information about Yang, see [RFC 6020](https://tools.ietf.org/html/rfc6020).

[Placeholder to add custom Yang mechanism, difference between OpenConfig, etc.]

In this lesson, we're going to define a custom Yang module to create new config stanza, and a custom Yang translator to translate custom defined configuration to Junos config.

The custom Yang module called `vpn-services` helps configure L3VPN. It groups all the L3VPN related parameters (e.g., interfaces, VLAN Id, IP address, RD, RT, etc) into a single place. Take a look on the Yang file first.

```
cd /antidote/lessons/lesson-26
cat vpn-services.yang
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 0)">Run this snippet</button>

For the translation script, it supports both SLAX and Python language.  We're using Python language in this lesson as it's familiar to most people.  Different with commit script, to improve the efficiency, it processes the delta configuration only and therefore the translation script logic should take care the addition and removal of config knob. Let's take a look on the translation script.

```
cat vpn-services.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 1)">Run this snippet</button>

To install the custom Yang module, we have to copy both `vpn-services.yang` and `vpn-services.py` to vQFX first.

```
sshpass -p antidotepassword scp -o StrictHostKeyChecking=no vpn-services.* antidote@vqfx:~
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', 2)">Run this snippet</button>

After that, install the custom Yang module by `request system yang add` command

```
request system yang add package vpn-services module vpn-services.yang translation-script vpn-services.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 3)">Run this snippet</button>

After installation completed, press `ENTER` key few times to acknowledge the `cli` process restart request.

Next, verify the Yang package `vpn-services` is installed and the translation script is enabled

```
show system yang package vpn-services
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 4)">Run this snippet</button>

Now, you can go to the `vpn-services` configuration hierarchy, use the `set` and `?` to navigate the config tree.

```
configure
edit vpn-services:vpn-services
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx', 5)">Run this snippet</button>

In next lesson, we will configure the L3VPN services using the new `vpn-services` config knob.
