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

## Part 2 - Primer on Resource Modules

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

## Complete

You have completed stage 3!

## Takeaways

- Resource modules and facts have a direct relationship allowing Ansible to read existing brownfield networks and create a source of truth really quickly.
- The `ansible_network_resources` parameter is used to collect facts around a specific resource such as l3_interfaces.
- Variables are mostly commonly stored in group_vars and host_vars. This short example only used host_vars.

For more information on why resource modules were developed please refer to [this blog post](https://www.ansible.com/blog/network-features-coming-soon-in-ansible-engine-2.9).

---

These exercises are made possible by [Juniper Networks](https://juniper.net) and the [Red Hat Ansible Automation Platform](https://www.ansible.com/products/automation-platform)

<img src="https://github.com/Mierdin/nrelabs-curriculum/blob/ansible-networking/lessons/tools/lesson-41-ansible-network/stage1/rh-ansible-platform.png?raw=true"></div>

Check out our free network automation e-books on https://ansible.com:
- [Part 1: Modernize Your Network with Red Hat](https://www.ansible.com/resources/ebooks/network-automation-for-everyone)
- [Part 2: Automate Your Network with Red Hat](https://www.ansible.com/resources/ebooks/automate-your-network)
