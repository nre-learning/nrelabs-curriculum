# Ansible Network Automation - Enable Netconf

**Contributed by: [Red Hat](https://ansible.com)**

---

## Objective

Explore and understand the lab environment. This exercise will cover

- Determining the Ansible version running on the control node
- Locating and understanding the Ansible configuration file - (ansible.cfg)
- Locating and understanding an ini formatted inventory file
- Running your first Ansible Playbook to turn on netconf

## Part 1 - Examine Ansible software version

Run the ansible command with the --version command to look at what is configured:

```
ansible --version
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

## Part 2 - Examine inventory

Navigate to lesson stage directory and show inventory:

```
cd /antidote/stage1
cat hosts
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

In the output every square bracket (`[ ]`) defines a group. For example `[juniper]` is a group that contains the host vqfx1. Groups can also be nested. The group `[devices]` is a parent group to the group `[juniper]`.  Parent groups are declared using the `children` directive. Having nested groups allows the flexibility of assigning more specific values to variables.

> *Note:* A group called **all** always exists and contains all groups and hosts defined within an inventory.

### Info on variables within an inventory

Group variables groups are declared using the vars directive. Having groups allows the flexibility of assigning common variables to multiple hosts. Multiple group variables can be defined under the `[group_name:vars]` section. For example look at the group `juniper`:

- ansible_network_os - This variable is necessary while using the network_cli or netconf connection type within a play definition, as we will see shortly.
- ansible_connection - This variable sets the connection plugin for this group. This can be set to values such as netconf, httpapi and network_cli depending on what this particular network platform supports.

## Part 3 - Examine Ansible configuration file

Look at the contents of the ansible.cfg file

```
cat ansible.cfg
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

Note the following parameters within the ansible.cfg file:

- `stdout_callback` - this is setting the console output to yaml versus the default to make it more human readable
- `inventory` - shows the location of the Ansible Inventory being used by Ansible Playbooks

Configuration files are searched for in the following order:

- ANSIBLE_CONFIG (environment variable if set)
- ansible.cfg (in the current directory)
- ~/.ansible.cfg (in the home directory)
- /etc/ansible/ansible.cfg

Move the Ansible configuration file to the home directory so that all Ansible Playbooks will use it regardless of what directory they are in.

```
mv ansible.cfg ~/.ansible.cfg
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

For more information on the ansible.cfg file please check out the [documentation here](https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html).  There is a full example on [Github here](https://github.com/ansible/ansible/blob/devel/examples/ansible.cfg).

## Part 4 - Examine Ansible Playbook

Next, show Ansible Playbook contents:

```
cat netconf.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

Lets examine each part of this Ansible Playbook:

- `name: Ansible test within NRE Labs lesson` - optional but highly encouraged description of what this Ansible Playbook will do
- `hosts: vqfx1` - this is what hosts the Ansible Playbook will execute on.  This can be a group or a single host.
- `gather_facts: no` - by default Ansible will gather information about devices.  We can disable this if we are not using facts.  Disabling this will also speed up the Ansible Playbook.
- `tasks:` - this section of the Ansible Playbook contains the actual work that needs to be done by including one or more tasks in a list.
- `name: turn on netconf for juniper devices` - this is an optional but highly encouraged description of what you want the task to do.
- `vars` - it is possible to add or change any variable on a task by task basis.  For this first task we are gonna assume that this is a brand new Juniper device with netconf turned off
- `ansible_connection: network_cli` - we will use the standard command line over SSH to connect to the deivce for this task.
- `junos_netconf` - this is the [Ansible Module](https://docs.ansible.com/ansible/latest/modules/junos_netconf_module.html) that turns on netconf on the Juniper device.  Tasks and modules have a one-to-one correlation.


## Part 5 - Execute the Ansible Playbook

Run our simple Ansible Playbook to turn on netconf for our Juniper device.

```
ansible-playbook netconf.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

We can verify this is done on the vqfx:

```
show configuration system services
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

## Part 6 - Understand idempotency

The junos_netconf module is idempotent. This means, a configuration change is pushed to the device if and only if that configuration does not exist on the end hosts.

> Need help with Ansible Automation terminology? Check out the glossary here for more information on terms like idempotency.

To validate the concept of idempotency, re-run the playbook:

```
ansible-playbook netconf.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

> Note: See that the changed parameter in the PLAY RECAP indicates 0 changes.

Re-running the Ansible Playbook multiple times will result in the same exact output, with ok=1 and change=0. Unless another operator or process removes or modifies the existing configuration on the Juniper device, this Ansible Playbook will just keep reporting ok=1 indicating that the configuration already exists and is configured correctly on the network device.

This Ansible Playbook could be scheduled to enforce configuration state with the Red Hat Ansible Automation Platform across hundreds of Juniper devices.

## Complete

You have completed stage 1!

---

These exercises are made possible by [Juniper Networks](https://juniper.net) and the [Red Hat Ansible Automation Platform](https://www.ansible.com/products/automation-platform)

![red hat ansible automation platform logo](rh-ansible-platform.png)

Check out our free network automation e-books on https://ansible.com:
- [Part 1: Modernize Your Network with Red Hat](https://www.ansible.com/resources/ebooks/network-automation-for-everyone)
- [Part 2: Automate Your Network with Red Hat](https://www.ansible.com/resources/ebooks/automate-your-network)
