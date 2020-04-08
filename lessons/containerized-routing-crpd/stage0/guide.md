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


Verify that `crpd2` has formed an OSPF adjacency with `crpd1`, and that you can see the route to `123.123.123.123`:

```
show ospf neighbor 
show route 123.123.123.123
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('crpd2', this)">Run this snippet</button>

Exit from the Junos CLI:

```
exit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('crpd2', this)">Run this snippet</button>

You should now be able to ping the loopback address of `crpd1` from `crpd2`:

```
ping 123.123.123.123
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('crpd2', this)">Run this snippet</button>

