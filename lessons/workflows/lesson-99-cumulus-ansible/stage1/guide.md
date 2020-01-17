# Automating Cumulus Linux with Ansible

https://cumulusnetworks.com/blog/automating-cumulus-linux-ansible/

## Part 1 - < INSERT >

Automating your network can seem like a daunting task. But the truth is that automating Cumulus Linux with Ansible can be easier than many of the things you’re probably already automating.

In this lesson, we’ll show you how to get started on your network automation journey using a simple, four-step process:

  - Pick one small network task to automate
  - Configure it manually on a small scale
  - Mimic the manual configuration in Ansible
  - Expand the automation to additional network devices

To illustrate, I’ll be using the following simple, bare-bones topology based on the Cumulus Reference topology. You can follow along by spinning up your own virtual data center for free using Cumulus in the Cloud.

## Pick one network task to automate

The first step is to pick one thing to automate. Just one! The only caveat is that it needs to be something you understand and are comfortable with. Trying to automate a feature you’ve never used is sure to scare you away from automation forever, unless of course you have someone guiding you through the process.

Preferably, pick something that’s quick and simple when done manually. Configuring the OSPF routing protocol between two switches falls into this category. When done manually, it’s literally only three lines of configuration on each device. Let’s start by manually creating an OSPF adjacency between the switches spine01 and leaf01.

First, we’ll issue the following commands on the spine01 switch:

cumulus@spine01:~$ net add ospf router-id 192.168.0.21
cumulus@spine01:~$ net add ospf network 192.168.0.0/16 area 0.0.0.0
cumulus@spine01:~$ net commit

The net add ospf router-id 192.168.0.21 command assigns spine01 the router ID (RID) of 192.168.0.21, which matches its unique management IP. OSPF uniquely identifies each device by its RID, so by setting the RID manually, we can easily identify this switch later on.

The command net add ospf network 192.168.0.0/16 area 0.0.0.0 enables OSPF on the management interface (eth0, which is in the 192.168.0.0/16 subnet), and places it in area 0.0.0.0, which is the OSPF backbone area. To keep things clean and simple, we’ll place everything in the backbone area.

Now let’s do the same thing for leaf01:

cumulus@leaf01:~$ net add ospf router-id 192.168.0.11
cumulus@leaf01:~$ net add ospf network 192.168.0.0/16 area 0.0.0.0
cumulus@leaf01:~$ net commit

If both switches are configured correctly, they should form an adjacency. We can verify this by using the net show command from leaf01:

cumulus@leaf01:~$ net show ospf neighbor
 
Neighbor ID   Pri State  Dead Time Address     Interface         RXmtL RqstL DBsmL
192.168.0.21  1 Full/DR  32.278s 192.168.0.21  eth0:192.168.0.11     0     0     0

The output shows an adjacency with 192.168.0.21 (spine01), which means everything is working as expected! Spine01 and leaf01 are now OSPF neighbors.


## Validating your configuration with NetQ

It’s fine to validate a manual configuration by issuing a net show command on each device. But when we get around to automating this and adding more switches, we’ll need a way to check everything in one fell swoop using a single command. This is where NetQ comes in.

NetQ is invaluable for validating any Cumulus Linux configuration, whether manual or automated. NetQ keeps a record of every configuration and state change that occurs on every device.

Let’s go back to the management server and use NetQ to view information on the current OSPF topology:

cumulus@oob-mgmt-server:~$ netq show ospf

cumulus@oob-mgmt-server:~$ netq check ospf
Total Sessions: 2, Failed Sessions: 0

NetQ gives you a real-time view of the OSPF states of leaf01 and spine01. At a glance, you can see that leaf01 and spine01 are both in OSPF area 0.0.0.0, and have a full adjacency. The netq show command gives you the same data you’d get by running a net show command on each switch, but quicker and with a lot less typing!

Now that we’ve manually gotten OSPF up and running between two switches, let’s look at how to automate this process using Ansible.
Automating OSPF using Ansible

We’re going to create an Ansible Playbook to automate the exact configuration we just performed manually. When it comes to automation platforms in general, and particularly Ansible, there are many ways to achieve the same result. I’m going to show you a simple and straightforward way, but understand that it’s not the only way.

The first step is to create the folder structure on the management server to store the Playbook. You can do this with one command:

cumulus@oob-mgmt-server:~$ mkdir -p cumulus-ospf-ansible/roles/ospf/tasks

This will create the following folders:

cumulus-ospf-ansible
cumulus-ospf-ansible/roles
cumulus-ospf-ansible/roles/ospf
cumulus-ospf-ansible/roles/ospf/tasks

Specifying the switches to automate

Next, in the cumulus-ospf-ansible directory, we’ll create the hosts file to indicate which switches we want Ansible to configure. For now, spine01 and leaf01 are the only ones we want to automate. Incidentally, I prefer the nano text editor to edit the hosts file, but you can use a different one if you’d like.

cumulus@oob-mgmt-server:~$ cd cumulus-ospf-ansible
cumulus@oob-mgmt-server:~$ nano hosts

[switches]
spine01 rid=192.168.0.21
leaf01 rid=192.168.0.11

This places both switches into a group called switches. The rid= after each name indicates the unique OSPF router ID for the switch. Ansible will use this value when executing the actual configuration task, which we’ll set up next.
Creating the task

In the cumulus-ospf-ansible/roles/ospf/tasks folder, create another file named main.yaml:

cumulus@oob-mgmt-server:~/cumulus-ospf-ansible$ cd roles/ospf/tasks
cumulus@oob-mgmt-server:~/cumulus-ospf-ansible/roles/ospf/tasks$ nano main.yaml

---
- name: Enable OSPF
  nclu:
   commands:
   - add ospf router-id {{ rid }}
   - add ospf network {{ item.prefix }} area {{ item.area }}
   atomic: true
   description: "Enable OSPF"
 loop:
   - { prefix: 192.168.0.0/16, area: 0.0.0.0 }

The task named Enable OSPF uses the Network Command Line Utility (NCLU) module that ships with Ansible 2.3 and later. Let’s walk through this.

Look at the two lines directly under commands:

commands:
- add ospf router-id {{ rid }}
- add ospf network {{ item.prefix }} area {{ item.area }}

These commands look familiar! They’re very similar to the ones we issued manually, but with a few key differences.

First, the net command is missing from the beginning because the NCLU module adds it implicitly.

Second, instead of static values for the router ID, subnet prefix, and OSPF area, the variable names are surrounded by double braces. The rid variable comes from the hosts file, while the other two variables (item.prefix and item.area) come from the main.yaml file itself, under the loop section.

The atomic: true statement flushes anything in the commit buffer on the switch before executing the commands. This ensures that no other pending, manual changes inadvertently get committed when you run the Playbook.

Speaking of the Playbook, we have only one step left before we’re ready to run it!
Creating the play

In the cumulus-ospf-ansible folder, create a file named setup.yaml which will contain the play:

cumulus@oob-mgmt-server:~/cumulus-ospf-ansible/roles/ospf/tasks$ cd ../../..
cumulus@oob-mgmt-server:~/cumulus-ospf-ansible$ nano setup.yaml

- hosts: switches
  roles:
  - ospf

This file instructs Ansible to run the configuration directives in the cumulus-ospf-ansible/roles/ospf/tasks/main.yaml file against the devices in the switches group. All that’s left to do now is run the Playbook!
Running the Playbook

Now for the moment you’ve been waiting for! Issue the following command to run the Playbook:

cumulus@oob-mgmt-server:~/cumulus-ospf-ansible$ ansible-playbook -i hosts setup.yaml

PLAY [switches] *******************************************************************************

TASK [Gathering Facts] ************************************************************************
 ok: [spine01]
 ok: [leaf01]

TASK [ospf : Enable OSPF] *********************************************************************
 ok: [spine01] => (item={u'prefix': u'192.168.0.0/16', u'area': u'0.0.0.0'})
 ok: [leaf01] => (item={u'prefix': u'192.168.0.0/16', u'area': u'0.0.0.0'})

PLAY RECAP ************************************************************************************
 leaf01 : ok=2 changed=0 unreachable=0 failed=0
 spine01 : ok=2 changed=0 unreachable=0 failed=0

The last two lines say changed=0 because the automated configuration is identical to what we configured manually. Hence, there’s nothing to change. This is a good indication that the Playbook works as expected, and we can safely add more switches to the automation process.
Expanding the automation

Next, let’s add the rest of the switches and corresponding RIDs to the hosts file:

[switches]
 spine01 rid=192.168.0.21
 leaf01 rid=192.168.0.11
 leaf02 rid=192.168.0.12
 leaf03 rid=192.168.0.13
 leaf04 rid=192.168.0.14
 spine02 rid=192.168.0.22

Now run the playbook again:

cumulus@oob-mgmt-server:~/cumulus-ospf-ansible$ ansible-playbook -i hosts setup.yaml

PLAY [switches] **********************************************************************

TASK [Gathering Facts] ***************************************************************
 ok: [leaf02]
 ok: [leaf04]
 ok: [leaf03]
 ok: [spine01]
 ok: [leaf01]
 ok: [spine02]

TASK [ospf : Enable OSPF] ************************************************************
 ok: [spine01] => (item={u'prefix': u'192.168.0.0/16', u'area': u'0.0.0.0'})
 ok: [leaf01] => (item={u'prefix': u'192.168.0.0/16', u'area': u'0.0.0.0'})
 changed: [leaf02] => (item={u'prefix': u'192.168.0.0/16', u'area': u'0.0.0.0'})
 changed: [leaf04] => (item={u'prefix': u'192.168.0.0/16', u'area': u'0.0.0.0'})
 changed: [leaf03] => (item={u'prefix': u'192.168.0.0/16', u'area': u'0.0.0.0'})
 changed: [spine02] => (item={u'prefix': u'192.168.0.0/16', u'area': u'0.0.0.0'})

PLAY RECAP *****************************************************************************
 leaf01 : ok=2 changed=0 unreachable=0 failed=0
 leaf02 : ok=2 changed=1 unreachable=0 failed=0
 leaf03 : ok=2 changed=1 unreachable=0 failed=0
 leaf04 : ok=2 changed=1 unreachable=0 failed=0
 spine01 : ok=2 changed=0 unreachable=0 failed=0
 spine02 : ok=2 changed=1 unreachable=0 failed=0

All of the switches except leaf01 and spine01 have changed. Let’s use NetQ to validate those changes.

cumulus@oob-mgmt-server:~$ netq check ospf
Total Sessions: 6, Failed Sessions: 0

This shows all the OSPF state changes for each switch. Although the output is a little mixed up, you can see that each switch is listed five times; one time for each adjacency. Based on this, we can tell that the automated configuration worked for all of the switches!

But to get a clearer picture, let’s look just at the changes on leaf01 within the last five minutes. Of course, NetQ can do this as well.

NetQ shows leaf01 becoming fully adjacent with four other switches. Not coincidentally, this is the number of switches whose configurations changed! Because the adjacency with spine01 was made more than five minutes ago and hasn’t changed, it doesn’t show up in the output.
Give it a shot!

Cumulus Linux, NetQ and Ansible work together seamlessly to give you a complete automation solution. Everything you need is already there! Start by automating a simple task you’re comfortable with, and only on a handful of devices. From there, you can move onto more complex tasks, adding more devices as you go.

Although automating something as critical as your network can be intimidating, it’s well worth it. Automation can dramatically reduce the number of accidental configurations, fat-finger mistakes, and unauthorized changes. When you combine network automation with NetQ, you’ll almost never need to log into a switch to manually check its configuration or status. Not only that, with NetQ you get a detailed log of every change that occurs on your network devices – whether it’s a configuration change or a state change such as an interface going down or a route flapping. And when an improper configuration does occur, you can just rerun the appropriate Playbook to put everything back in order.
