# Ansible Network Automation - Resource Facts

**Contributed by: [Red Hat](https://ansible.com)**

---

## Objective

Demonstration use of resource modules used in combination with Ansible facts for network infrastructure.

This exercise will cover:

- using `junos_facts` module
- the `gather_network_resources` parameter
- creating a structured data yaml file from `junos_facts`

## Part 1 - Navigate to stage 3

Navigate to lesson stage directory:

```
cd /antidote/stage3
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

## Part 1 - Primer on Resource Modules

So what exactly is a “resource module?” Sections of a device’s configuration can be thought of as a resources provided by that device. Network resource modules are intentionally scoped to configure a single resource and can be combined as building blocks to configure complex network services.

For example the following are Juniper Junos resource modules:
- [junos_interfaces](https://docs.ansible.com/ansible/latest/modules/junos_interfaces_module.html#junos-interfaces-module) - configures physical interface attributes such as duplex, hold_times, mtu, description fields and speed
- [junos_l2_interfaces](https://docs.ansible.com/ansible/latest/modules/junos_l2_interfaces_module.html#junos-l2-interfaces-module) - configures interface attributes such as access vlans, trunks, interface-mode, native vlans and allowed_vlans
- [junos_l3_interfaces](https://docs.ansible.com/ansible/latest/modules/junos_l3_interfaces_module.html#junos-l3-interfaces-module) - configures layer 3 interface attributes such as IPv4 and IPv6 address assignment
- [junos_lacp](https://docs.ansible.com/ansible/latest/modules/junos_lacp_module.html#junos-lacp-module) - configures Link Aggregation Control Protocol global settings such as link_protection and system_priority
- [junos_vlans](https://docs.ansible.com/ansible/latest/modules/junos_vlans_module.html#junos-vlans-module) - configures VLANs, and their respective descriptions and names

> **Note** For a full list of Juniper Junos modules please refer to the [documentation](https://docs.ansible.com/ansible/latest/modules/list_of_network_modules.html#junos).

Every resource module will have corresponding facts integration so that Ansible Network Automation can both read and write for that particular resource.  There is a new keyword `gather_network_resources` that allows fact modules (e.g. `junos_facts`) to gather resource module facts for a particular resource.

| **Resource Module** | **gather_network_resources** |
| ------------- |:-------------:|
| `junos_interfaces` | `interfaces` |
| `junos_l2_interfaces`    | `l2_interfaces` |
| `junos_l3_interfaces` | `l3_interfaces` |
| `junos_lacp` | `lacp` |
| `junos_vlans` | `vlans` |

## Part 2 - Examine Ansible Playbook

Next, show Ansible Playbook contents:

```
cat facts.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

Lets examine the Ansible Playbook:

- `name: collect l3 interface configuration facts` - description for the task
- `junos_facts:` module being used for this task
- `gather_subset: min` - must be set to min in order for `gather_network_resources` to work.  This is done for backwards compatibility for older Ansible Playbooks.
- `gather_network_resources:` - parameter that needs a list of one or more network resources to gather.  Can also be set to `all` and will gather all network resources available for that version of Ansible.
- `l3_interfaces` - the network resource to gather data on.

The second task is using the `debug` module to print the facts to the console window.

## Part 3 - Execute the Ansible Playbook

Next, run the Ansible Playbook with the `ansible-playbook` command:

```
ansible-playbook facts.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

--

## Complete

Using less than 20 lines of "code" you have just automated version and serial number collection. Imagine if you were running this against your production network! You have actionable data in hand that does not go out of date.

If you have trouble modifying the Ansbile Playbook try running the pre-populated solution here:
```
ansible-playbook solution.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>


You have completed stage 3!

---

These exercises are made possible by [Juniper Networks](https://juniper.net) and the [Red Hat Ansible Automation Platform](https://www.ansible.com/products/automation-platform)

<img src="https://github.com/Mierdin/nrelabs-curriculum/blob/ansible-networking/lessons/tools/lesson-41-ansible-network/stage1/rh-ansible-platform.png?raw=true"></div>

Check out our free network automation e-books on https://ansible.com:
- [Part 1: Modernize Your Network with Red Hat](https://www.ansible.com/resources/ebooks/network-automation-for-everyone)
- [Part 2: Automate Your Network with Red Hat](https://www.ansible.com/resources/ebooks/automate-your-network)
