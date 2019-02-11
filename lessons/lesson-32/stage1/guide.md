# STIG Compliance Validation
## Part 1  - STIG Compliance Validation with NAPALM

Anyone who's worked on United States military networks and systems has had to go through the experience of making sure that everything is compliant with the (Security Technical Implementation Guides](https://iase.disa.mil/stigs/Pages/index.aspx), or STIGs. These are a set of guidelines that serve as the minimum standard for locking down and reducing the attack surface for IT infrastructure within the US Department of Defense. Other countries have equivalent guides and standards as well.

Whether deploying greenfield network infrastructure, or running ongoing operations, ensuring STIG compliance is extremely important, but also extremely tedious. At best, network engineers have written their own scripts for running through the compliance checks they care about, but a large number of engineers do this work by hand. It

In this lesson, we'll explore two ways to automate checking our network infrastructure for compliance with STIG. For this lab, we'll focus on a tool we learned about in a previous lesson - NAPALM. As a refresher, this is an open source network automation tool meant to abstract away vendor-specific APIs, and allow you to write against a single set of Python functions to perform network automation tasks.

One really nifty feature not covered by that lesson is going to be covered in this lab, and that is NAPALM's "verify" functionality. As mentioned before, NAPALM can be used to "retrieve" information from network devices using a set of "getter" functions. Here's an example where we're retrieving the SNMP information that's been configured on `vqfx1`:

```python
import napalm
driver = napalm.get_network_driver("junos")
device = driver(hostname="vqfx1", username="antidote", password="antidotepassword")
device.open()
device.get_snmp_information()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

As an example, one of the many potential findings within the STIG for Juniper network equipment stipulates that all [network devices must only allow read-only SNMP access](https://stigviewer.com/stig/infrastructure_router__juniper/2018-03-06/finding/V-3969). As we can see, `vqfx1` would be in violation of this rule.

Now of course, you're already thinking we can just run this check in a simple script, but this is just one check of many [for Juniper devices alone](https://stigviewer.com/stig/infrastructure_router__juniper/). There exists a better way, to commit the rules involved with STIG compliance as a file that NAPALM can use to verify, while writing as little Python yourself as possible.

```
import pprint
pprint.pprint(device.compliance_report('napalm_verify_snmp.yaml'))
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

