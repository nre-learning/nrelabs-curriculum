# Automated STIG Compliance Validation
## Part 1  - STIG Compliance Validation with NAPALM

Anyone who's worked on United States military networks and systems has had to go through the experience of making sure that everything is compliant with the [Security Technical Implementation Guides](https://iase.disa.mil/stigs/Pages/index.aspx), or STIGs. These are a set of guidelines that serve as the minimum standard for locking down and reducing the attack surface for IT infrastructure within the US Department of Defense. Other countries have equivalent guides and standards as well.

Whether deploying greenfield network infrastructure, or running ongoing operations, ensuring STIG compliance is extremely important, but also extremely tedious. At best, network engineers have written their own scripts for running through the compliance checks they care about, but a large number of engineers do this work by hand. It

In this lesson, we'll explore two ways to automate checking our network infrastructure for compliance with STIG. For this lab, we'll focus on a tool we learned about in a previous lesson - NAPALM. As a refresher, this is an open source network automation tool meant to abstract away vendor-specific APIs, and allow you to write against a single set of Python functions to perform network automation tasks.

One really nifty feature not covered by that lesson is going to be covered in this lab, and that is NAPALM's "verify" functionality. As mentioned before, NAPALM can be used to "retrieve" information from network devices using a set of "getter" functions. Here's an example where we're retrieving the SNMP information that's been configured on `vqfx1`:

```python
python
import napalm
driver = napalm.get_network_driver("junos")
device = driver(hostname="vqfx1", username="antidote", password="antidotepassword")
device.open()
device.get_snmp_information()
quit()
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

As an example, one of the many potential findings within the STIG for Juniper network equipment stipulates that all [network devices must only allow read-only SNMP access](https://stigviewer.com/stig/infrastructure_router__juniper/2018-03-06/finding/V-3969). As we can see, `vqfx1` would be in violation of this rule.

Now of course, you're already thinking we can just run this check in a simple script, but this is just one check of many [for Juniper devices alone](https://stigviewer.com/stig/infrastructure_router__juniper/). There exists a better way, to commit the rules involved with STIG compliance as a file that NAPALM can use to verify, while writing as little Python yourself as possible. We can create a simple YAML definition that contains "tests" for specific findings. For instance, in this YAML file, we can tell NAPALM to use `get_snmp_information` to retrieve SNMP information, and then make an assertion that the community string is set to read-only.

```
cd /antidote/stage0/
cat napalm_verify_snmp.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We've intentionally configured `vqfx1` ahead of time to have a read-write string, so that we see the violation when we run the napalm validate command with this test:

```
napalm --user=antidote --password=antidotepassword --vendor=junos vqfx1 validate napalm_verify_snmp.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

There's a lot to go through in the resulting JSON output, but the important thing is the high-level key "complies" has a value of `false`.
This means that the test we wrote to assert that the SNMP community string adheres to V-3969 is showing noncompliance on this device.

We can get this test to pass by reconfiguring `vqfx1` to comply with V-3969 by setting the community string to read only:

```
configure
set snmp community antidote authorization read-only
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

We can re-execute this test now and see that the assertion passes:

```
napalm --user=antidote --password=antidotepassword --vendor=junos vqfx1 validate napalm_verify_snmp.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

[Another finding stipulates](https://stigviewer.com/stig/infrastructure_router__juniper/2018-03-06/finding/V-31285) that all eBGP or iBGP peers must be authenticated. We've constructed another YAML file for testing this, using NAPALM's built-in functionality to allow regular expressions to match retrieved values:

```
cat napalm_verify_bgp.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

In this case, the regular expression `.+` is used to ensure that the authentication key used is **at least** one character. This means that, if there is no authentication key configured, this test would fail. As we've pre-configured this BGP configuration without authentication, we can see that it does:

```
napalm --user=antidote --password=antidotepassword --vendor=junos vqfx1 validate napalm_verify_bgp.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

As with before, this is an easy fix with a quick re-configuration:

```
configure
set protocols bgp group PEERS neighbor 10.12.0.12 authentication-key antidote
set protocols bgp group PEERS neighbor 10.31.0.13 authentication-key antidote
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

Now, we should again see all tests pass:

```
napalm --user=antidote --password=antidotepassword --vendor=junos vqfx1 validate napalm_verify_bgp.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

This lab has intentionally left a few things out:
- It doesn't ensure compliance. It just detects noncompliance in an automated way. This is very valuable, but even more valuable is the ability to couple these tests with something like a Python script or Ansible playbook to perform the necessary compliance changes automatically when a violation is detected.
- Obviously, there are many other findings you can write tests for that we haven't included here. You should [take a look](https://stigviewer.com/stig/infrastructure_router__juniper/) at the other findings, and consider writing a test for them here as practice.

In the next lab, we'll look at doing the same thing with another tool we've looked at before - JSNAPy.
