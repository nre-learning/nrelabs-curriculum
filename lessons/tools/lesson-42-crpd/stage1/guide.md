# Exploring cRPD
## Part 1 - Configuring Basic Networking and Routing

---

First, configure `crpd1`:

```
# Linux config
ip addr add 192.168.1.1/24 dev eth1
ip addr add 123.123.123.123/32 dev lo

# Junos config
cli
configure
set routing-options router-id 1.1.1.1
set protocols ospf area 0.0.0.0 interface eth1 interface-type p2p
set protocols ospf area 0.0.0.0 interface lo.0 interface-type nbma
commit and-quit
exit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('crpd1', this)">Run this snippet</button>

Next, configure `crpd2`:

```
# Linux config
ip addr add 192.168.1.2/24 dev eth1

# Junos config
cli
configure
set routing-options router-id 2.2.2.2
set protocols ospf area 0.0.0.0 interface eth1 interface-type p2p
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('crpd2', this)">Run this snippet</button>


Finally, verify that you can see the learned route, and can ping the loopback of `crpd1`:

```
show ospf neighbor 
show route 123.123.123.123
exit
ping 123.123.123.123
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('crpd2', this)">Run this snippet</button>

