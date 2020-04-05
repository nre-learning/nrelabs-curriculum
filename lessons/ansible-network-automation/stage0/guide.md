## Objective

This first exercise is mostly about exploring and understanding the lab environment, and the
various parts that go into successfully running your first Ansible playook. This exercise will cover:

- Determining the Ansible version running on the control node
- Locating and understanding the Ansible configuration file - (`ansible.cfg`)
- Locating and understanding an ini formatted inventory file
- Running your first Ansible Playbook to turn on netconf

## Part 1 - Examine Ansible software version

Run the ansible command with the `--version` flag to see not only the version of Ansible that's installed,
but also a few other key details:

```
ansible --version
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

This output will become more useful the deeper you get into Ansible.

## Part 2 - Examine inventory

Ansible works on a concept called "inventory". This is a way of describing the infrastructure elements
(in our case, network devices) that we'll be automating with Ansible. Ansible offers several options for
managing inventory, but for now, we'll keep it simple and describe our inventory in a text file.

Navigate to lesson stage directory and show inventory:

```
cd /antidote/stage0
cat hosts
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

In the output every square bracket (`[ ]`) defines a group. For example `[juniper]` is a group that contains the host vqfx1. Groups can also be nested. The group `[devices]` is a parent group to the group `[juniper]`.  Parent groups are declared using the `children` directive. Having nested groups allows the flexibility of assigning more specific values to variables.

> **Note:** A group called `all` always exists and contains all groups and hosts defined within an inventory.

### Info on variables within an inventory

Group variables groups are declared using the vars directive. Having groups allows the flexibility of assigning common variables to multiple hosts. Multiple group variables can be defined under the `[group_name:vars]` section. For example look at the group `juniper`:

- `ansible_network_os` - This variable is necessary while using the network_cli or netconf connection type within a play definition, as we will see shortly.
- `ansible_connection` - This variable sets the connection plugin for this group. This can be set to values such as netconf, httpapi and network_cli depending on what this particular network platform supports.

## Part 3 - Examine Ansible configuration file

The `ansible.cfg` file allows us to give Ansible instructions for how to operate. We can easily inspect the contents:

```
cat ansible.cfg
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

Note the following parameters within `ansible.cfg`:

- `stdout_callback` - this is setting the console output to yaml versus the default to make it more human readable
- `inventory` - shows the location of the Ansible Inventory being used by Ansible Playbooks - note that this currently set to the same location for the inventory file we explored in a previous step.

Configuration files are searched for in the following order:

- `ANSIBLE_CONFIG` (environment variable if set)
- `ansible.cfg` (in the current directory)
- `~/.ansible.cfg` (in the home directory)
- `/etc/ansible/ansible.cfg`

You can find a full example of an `ansible.cfg` file on Github [here](https://github.com/ansible/ansible/blob/devel/examples/ansible.cfg). This is useful for understanding the various configuration options that can be set by this file.

## Part 4 - Examine Ansible Playbook

In Ansible, the "playbook" is a core concept - it is a file, written in YAML, which describes the various tasks we want to perform against our infrastructure.

We'll start off with a simple example, called `netconf.yml` - inspect this file to see its contents:

```
cat netconf.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

The purpose of this playbook is to log into a Juniper device and enable NETCONF. Lets examine each part of this Ansible Playbook, line-by-line:

- `name: Ansible test within NRE Labs lesson` - optional but highly encouraged description of what this Ansible Playbook will do
- `hosts: vqfx1` - this is what hosts the Ansible Playbook will execute on.  This can be a group or a single host.
- `gather_facts: no` - by default Ansible will gather information about devices.  We can disable this if we are not using facts.  Disabling this will also speed up the Ansible Playbook.
- `tasks:` - this section of the Ansible Playbook contains the actual work that needs to be done by including one or more tasks in a list.
- `name: turn on netconf for juniper devices` - this is an optional but highly encouraged description of what you want the task to do.
- `vars` - it is possible to add or change any variable on a task by task basis.  For this first task we are gonna assume that this is a brand new Juniper device with netconf turned off
- `ansible_connection: network_cli` - we will use the standard command line over SSH to connect to the deivce for this task.
- `junos_netconf` - this is the [Ansible Module](https://docs.ansible.com/ansible/latest/modules/junos_netconf_module.html) that turns on netconf on the Juniper device.  Tasks and modules have a one-to-one correlation.


## Part 5 - Execute the Ansible Playbook

Now that our inventory has been set and our playbook has been written, executing it is a breeze - we only need to run the `ansible-playbook` command, with a single argument - the name of the playbook:

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

The `junos_netconf` module is idempotent. This means, a configuration change is pushed to the device if and only if that configuration does not exist on the end hosts.

> Need help with Ansible Automation terminology? Check out the [glossary here](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html) for more information on terms like idempotency.

To validate the concept of idempotency, re-run the playbook:

```
ansible-playbook netconf.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

You'll notice that this time, the output did not say `changed=1`, as it did the first time. Instead, it says `ok=1`, with all green text. This is because Ansible determined that no change needed to be made, and therefore didn't try to make one. Unless another operator or process removes or modifies the existing configuration on the Juniper device, this will remain the case.  

This Ansible Playbook could be scheduled to enforce configuration state with the Red Hat Ansible Automation Platform across hundreds of Juniper devices.

## Complete

You have completed Part 1!

## Takeaways

- Ansible requires an [inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) to execute Automation on
- [Ansible Playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) are Ansible’s configuration, deployment, and orchestration language. They can describe a policy you want your remote systems to enforce, or a set of steps in a general IT process.
- Ansible modules such as [junos_netconf](https://docs.ansible.com/ansible/latest/modules/junos_netconf_module.html) can be idempotent, meaning they are stateful

---

These exercises are made possible by [Juniper Networks](https://juniper.net) and the [Red Hat Ansible Automation Platform](https://www.ansible.com/products/automation-platform)

<img src="https://github.com/nre-learning/nrelabs-curriculum/blob/master/lessons/tools/lesson-41-ansible-network/rh-ansible-platform.png?raw=true"></div>

Check out our free network automation e-books on https://ansible.com:
- [Part 1: Modernize Your Network with Red Hat](https://www.ansible.com/resources/ebooks/network-automation-for-everyone)
- [Part 2: Automate Your Network with Red Hat](https://www.ansible.com/resources/ebooks/automate-your-network)
