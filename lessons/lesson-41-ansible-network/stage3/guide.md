# Ansible Network Automation - Resource Facts

**Contributed by: [Red Hat](https://ansible.com)**

---

## Objective

Demonstration use of resource modules used in combination with Ansible facts for network infrastructure.

This exercise will cover:

- Using `junos_facts` module
- The `gather_network_resources` parameter
- Creating a structured data yaml file from `junos_facts`

## Part 1 - Primer on Resource Modules

So what exactly is a “resource module?” Sections of a device’s configuration can be thought of as a resources provided by that device. Network resource modules are intentionally scoped to configure a single resource and can be combined as building blocks to configure complex network services.

For example the following are Juniper Junos resource modules:
- [`junos_interfaces`](https://docs.ansible.com/ansible/latest/modules/junos_interfaces_module.html#junos-interfaces-module) - configures physical interface attributes such as duplex, hold times, mtu, description fields and speed
- [`junos_l2_interfaces`](https://docs.ansible.com/ansible/latest/modules/junos_l2_interfaces_module.html#junos-l2-interfaces-module) - configures interface attributes such as access vlans, trunks, interface-mode, native vlans and allowed vlans
- [`junos_l3_interfaces`](https://docs.ansible.com/ansible/latest/modules/junos_l3_interfaces_module.html#junos-l3-interfaces-module) - configures layer 3 interface attributes such as IPv4 and IPv6 address assignment
- [`junos_lacp`](https://docs.ansible.com/ansible/latest/modules/junos_lacp_module.html#junos-lacp-module) - configures Link Aggregation Control Protocol global settings such as `link_protection` and `system_priority`
- [`junos_vlans`](https://docs.ansible.com/ansible/latest/modules/junos_vlans_module.html#junos-vlans-module) - configures VLANs, and their respective descriptions and names

> **Note** For a full list of Juniper Junos modules please refer to the [documentation](https://docs.ansible.com/ansible/latest/modules/list_of_network_modules.html#junos).

Every resource module will have corresponding facts integration so that Ansible Network Automation can both read and write for that particular resource.  There is a new keyword `gather_network_resources` that allows fact modules (e.g. `junos_facts`) to gather resource module facts for a particular resource.

 <table>
  <tr>
    <th><b>Resource Module</b></th>
    <th><b>gather_network_resources</b></th>
  </tr>
  <tr>
    <td><pre>junos_interfaces</pre></td>
    <td><pre>interfaces</pre></td>
  </tr>
  <tr>
    <td><pre>junos_l2_interfaces</pre></td>
    <td><pre>l2_interfaces</pre></td>
  </tr>
  <tr>
    <td><pre>junos_l3_interfaces</pre></td>
    <td><pre>l3_interfaces</pre></td>
  </tr>
  <tr>
    <td><pre>junos_lacp</pre></td>
    <td><pre>lacp</pre></td>
  </tr>
  <tr>
    <td><pre>junos_vlans</pre></td>
    <td><pre>vlans</pre></td>
  </tr>
</table>

## Part 2 - Examine Ansible Playbook

Next, display the Ansible Playbook contents:

```
cd /antidote/stage3
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

The Ansible Playbook output will appear in the console to the right.

### OPTIONAL: Playing with verbosity

Instead of using the debug module try deleting the `debug` task.  Use the text editor of your choice and delete the second task.

```
nano facts.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

Now re-run the `ansible-playbook` command with the verbosity flag (`-v`).
```
ansible-playbook facts.yml -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

This can be another way to quickly see what an Ansible Task is doing.

## Part 4 - Variable Primer

Previously in the first part of this lesson, we talked about variables in inventory.  Variables are pieces of data, in the form of key-value pairs that Ansible can use during play.  When using variables within an inventory it is recommended to only have variables that are used to connect and authenticate **to the device**.  

Examples for inventory variables include:
- [Connection plugins](https://docs.ansible.com/ansible/latest/plugins/connection.html) (e.g. network_cli, netconf)
- Usernames
- [Platform types](https://docs.ansible.com/ansible/latest/network/user_guide/platform_index.html#settings-by-platform) (ansible_network_os)

Variables stored for use to configure resources **on the device** are recommended to be in `group_vars` or `host_vars`.

- **Host** variables apply to the host and override group vars.  These are stored in a directory `host_vars`.
- **Group** variables apply for all devices in that group.  These are stored in a directory `group_vars`.

Examples for `group_vars` and `host_vars` are:
- VLANs
- Routing configuration
- System services (NTP, DNS, etc)

For a complete guide on Ansible Variables, please refer to the [documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html).

## Part 5 - Saving variables to host_vars

For this next part we will use the resource module to save collected facts to a persistent file under the `host_vars` directory.

Display the Ansible Playbook contents:

```
cat save.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

Lets examine the Ansible Playbook.  There is one new task:

```yaml
  - name: push structured data to host vars
    copy:
      content: "{{ansible_network_resources | to_nice_yaml}}"
      dest: "{{playbook_dir}}/host_vars/{{inventory_hostname}}"
```

- `copy:` - this task uses the [copy module](https://docs.ansible.com/ansible/latest/modules/copy_module.html)
- `content: "{{ansible_network_resources | to_nice_yaml}}"` - the parameter content will push the variable `ansible_network_resources` that was collected by `junos_facts`.  The filter ` | to_nice_yaml` will convert this to a more human readable format.  This is purely for aesthetics and not required.  To learn more about filters like `to_nice_yaml` please refer to the [documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html).
- `dest: "{{playbook_dir}}/host_vars/{{inventory_hostname}}"` - this line will create a file named `vqfx1` since that is the only host in our topology, and dump the contents from the previous line (the `ansible_network_resources` which contains are l3_interfaces variables).  If there was multiple hosts, Ansible would create a separate file for each host in parallel.

## Part 6 - Execute the save playbook

First, let's create the directory `host_vars/`. Our playbook will write the collected facts here:

```
mkdir host_vars/
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

Now, we can execute our playbook to save our structured data to this directory:

```
ansible-playbook save.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

Now examine the contents of `host_vars`:

```
cat host_vars/vqfx1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

While the format for our `host_vars` is a little different, since this is written in YAML, it's not far off from the output of `show configuration interfaces` on the `vqfx1` device:

```
show configuration interfaces
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

Ansible creates a vendor agnostic representation of layer 3 information using the l3_interfaces resource module.  These variables can be stored into a database, cmdb or git repo to create a SoT (source of truth) for your network devices.

## Part 7 - Examine the l3_interfaces Ansible Playbook

Examine the `l3_interfaces.yml` Ansible Playbook that will use the resource module [`junos_l3_interfaces`](https://docs.ansible.com/ansible/latest/modules/junos_l3_interfaces_module.html) to push the configuration to the device.

```
cat l3_interfaces.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

There is one task:

```
      junos_l3_interfaces:
        config: "{{l3_interfaces}}"
```

Since our variables are in the `host_vars` directory they are automatically loaded as variables into our Ansible Playbook and available to use.

Run the Ansible Playbook:
```
ansible-playbook l3_interfaces.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

Since we have not modified the configuration at all, we are pushing back the exact same configuration that we just saved.  The Ansible Playbook will report green and `changed=0` indicating that the configuration is not modified.  The `junos_l3_interfaces` is idempotent meaning that it is aware of the configuration on the Juniper Junos device and won't modify it unless it has to.

## Part 8 - Modify the configuration

Now that we have our configuration as a flat file we can modify the source of truth and push the configuration.

Use the text editor of your choice and open up the `host_vars` for vqfx1

```
nano host_vars/vqfx1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

Change the IP address for **em3** to `10.10.10.1/30`, save the file, and exit the text editor.

Now execute the `l3_interfaces.yml` Ansible Playbook again with the modified `host_vars` file.  Use the verbosity flag (`-v`) to see what commands the module will use
```
ansible-playbook l3_interfaces.yml -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

Juniper vqfx1 port **em3** is connected to the Cumulus VX device's `swp1`. Look at the table below:

<table>
  <tr>
    <th><b>Juniper vqfx1</b></th>
    <th><b>interface</b></th>
    <th><b>interface</b></th>
    <th><b>Cumulus VX cvx1</b></th>
  </tr>
  <tr>
    <td><pre>10.10.10.1/30</pre></td>
    <td><pre>em3</pre></td>
    <td><pre>swp1</pre></td>
    <td><pre>10.10.10.2/30</pre></td>
  </tr>
</table>

Perform a ping from the `vqfx1` device to verify we have connectivity after the new configuration has been pushed:

```
ping 10.10.10.2 count 5
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

## Complete

You have completed stage 3!

## Takeaways

- Resource modules and facts have a direct relationship allowing Ansible to read existing brownfield networks and create a source of truth really quickly.
- verbose mode (`-v`) allows us to see more output to the terminal window, including which commands would be applied
- The `ansible_network_resources` parameter is used to collect facts around a specific resource such as `l3_interfaces`.
- Variables are mostly commonly stored in `group_vars` and `host_vars`. This short example only used `host_vars`.

For more information on why resource modules were developed please refer to [this blog post](https://www.ansible.com/blog/network-features-coming-soon-in-ansible-engine-2.9).

---

These exercises are made possible by [Juniper Networks](https://juniper.net) and the [Red Hat Ansible Automation Platform](https://www.ansible.com/products/automation-platform)

<img src="https://github.com/nre-learning/nrelabs-curriculum/blob/master/lessons/tools/lesson-41-ansible-network/rh-ansible-platform.png?raw=true"></div>

Check out our free network automation e-books on https://ansible.com:
- [Part 1: Modernize Your Network with Red Hat](https://www.ansible.com/resources/ebooks/network-automation-for-everyone)
- [Part 2: Automate Your Network with Red Hat](https://www.ansible.com/resources/ebooks/automate-your-network)
