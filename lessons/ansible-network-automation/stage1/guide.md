## Objective

In this section, we'll demonstrate the use of Ansible facts on network infrastructure.

Ansible facts are information derived from speaking to the remote network elements. Ansible facts are returned in structured data (JSON) that makes it easy manipulate or modify. For example a network engineer could create an audit report very quickly using Ansible facts and templating them into a markdown or HTML file.

This exercise will cover:

- Native fact gathering (using `gather_facts: True`)
- Using the `debug` module.

## Part 1 - Examine Ansible Facts Playbook

Ansible Playbooks are [**YAML** files](https://yaml.org/). YAML is a structured encoding format that is also extremely human readable (unlike it's subset - the JSON format)

Examine the Ansible Playbook file called `facts.yml`:  

```
cd /antidote/stage1
cat facts.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

First, let's explain the beginning of this Ansible Playbook in detail:

```yaml
---
- name: Ansible Facts
  hosts: vqfx1
  gather_facts: True
```

On this Ansible Playbook instead of disabling `gather_facts` we will turn it on.  Fact gathering is the default behavior so we could have also just deleted the line entirely.

Next, the second part, which includes our tasks:

```
  tasks:

  - name: print facts to console
    debug:
      msg: "{{ansible_facts}}"
```

This task will simply print the `ansible_facts` for `vqfx1` to the console window.  This will be a very long list of facts that will scroll past the window.  The double curly brackets denoted by `{{` and `}}` are used as a variable lookup.  This is done using a very simple Jinja2 template and perform a variable substitution.  More information can be found in the [documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#defining-variables-in-a-playbook).

## Part 2 - Execute the Ansible Playbook

Run our simple Ansible Playbook to print Ansible facts to the console window.

```
ansible-playbook facts.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

## Part 3 - Add two additional tasks

Use your text editor of choice to add two additional tasks to the Ansible Playbook facts.yml

```
nano facts.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

add the following two tasks (you can use your clipboard):

```
  - name: display version
    debug:
      msg: "The version is: {{ ansible_net_version }}"

  - name: display serial number
    debug:
      msg: "The serial number is:{{ ansible_net_serialnum }}"
```

Save the Ansible Playbook and exit the text editor.

## Part 4 - Re-run the Ansible Playbook

Run the modified Ansible Playbook to print Ansible facts to the console window.

```
ansible-playbook facts.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>


## Complete

Using less than 20 lines of "code" you have just automated version and serial number collection. Imagine if you were running this against your production network! You have actionable data in hand that does not go out of date.

If you have trouble modifying the Ansible Playbook try running the pre-populated solution here:

```
ansible-playbook solution.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>


You have completed Part 2!

## Takeaways

- The double brackets (`{{`) and (`}}`) are used to perform variable substitution within an Ansible Playbook.
- [Ansible Facts](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variables-discovered-from-systems-facts) are information derived from speaking with your remote systems.
- The [debug module](https://docs.ansible.com/ansible/latest/modules/debug_module.html) can be useful to print variable information to the console window

---

These exercises are made possible by [Juniper Networks](https://juniper.net) and the [Red Hat Ansible Automation Platform](https://www.ansible.com/products/automation-platform)

<img src="https://github.com/nre-learning/nrelabs-curriculum/blob/v1.2.0/lessons/ansible-network-automation/rh-ansible-platform.png?raw=true"></div>

Check out our free network automation e-books on https://ansible.com:
- [Part 1: Modernize Your Network with Red Hat](https://www.ansible.com/resources/ebooks/network-automation-for-everyone)
- [Part 2: Automate Your Network with Red Hat](https://www.ansible.com/resources/ebooks/automate-your-network)
