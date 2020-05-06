In the previous lab, we explored the use of NAPALM to verify that two particular findings in the [STIG for Juniper devices](https://stigviewer.com/stig/infrastructure_router__juniper/) were found to be in compliance.

In this lab, we'll use another tool to accomplish the same purpose. This tool, [JSNAPy](https://github.com/Juniper/jsnapy), was explored in a [previous lesson](https://labs.networkreliability.engineering/labs?lessonId=12), and is a very useful tool for performing validations against any part of a Junos device's state or configuration.

Here's the key tradeoffs between NAPALM and JSNAPy for this purpose.
- NAPALM is multi-vendor and JSNAPy is not (currently). If you want to write tests that work across multiple vendors, NAPALM is your best bet.
- NAPALM only has a limited number of "getter" functions, which are how NAPALM retrieves data from the network devices. If the data you wish to validate lies outside of those getters, you're unable to validate them. In contrast, JSNAPY, while Juniper-specific, can make assertions on anything in the XML hierarchy, both from a configuration or an operational state perspective.

Hopefully that conveys that one is not better or worse - they're built with different constraints and for different use cases.

Let's dive into this lab. As with the previous lab, `vqfx1` has been intentionally configured to violate the two findings we explored. First, V-3969, which again stipulates that we ensure SNMP community strings are read-only.

```
show configuration snmp | display xml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

We've built a test file similar to what we saw in the introduction to JSNAPy, but this one captures both of the findings we'll explore in this lab. This is totally based on preference - JSNAPy allows you to place all tests in the same file, or split them up however you want.

```
cd /antidote/stage1/
cat jsnapy_tests.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

The test `test_v-3969_snmp_readonly` uses the `get-config` RPC to retrieve the configuration from the device. Then, it uses the xpath expression `snmp/community` to narrow down in the configuration to the exact node we want to look at. Finally, it asserts in the test that the node `authorization` is exactly equal to `read-only`.

Since we saw in the previous snippet that this was not true, we can run these tests and see that we're in violation:

```
jsnapy --snapcheck -f jsnapy_config.yaml -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Again, easy fix manually (though again, you should build some kind of automated remediation to findings like this - however, this will suffice for now).

```
configure
set snmp community antidote authorization read-only
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

Running this again shows our SNMP test now passes:

```
jsnapy --snapcheck -f jsnapy_config.yaml -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

However, a byproduct of also including our V-31285 test which asserts the BGP configuration uses authentication for all peers, makes our entire test suite fail, even though the SNMP read-only check is passing on its own.

Let's take a look at the BGP neighbor information:

```
show bgp neighbor | display xml | no-more
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

One cool trick that most don't know about in Junos is the ability to use the expression `| display xml rpc` to display the name of the RPC call that would retrieve the same information:

```
show bgp neighbor | display xml rpc
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

If we take another look at the JSNAPy test, we can see this is the RPC we're using in our second test:

```
cat jsnapy_tests.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Another advantage of using JSNAPy is, due to the fact that it uses XPath to locate data in the XML hierarchy, we can make assertions on all child elements of a node, or a specific one. This means we can write one test to assert that any and all BGP peers are configured with authentication.

The XPath expression `//bgp-peer` matches all BGP peers configured on the device. Once these are located, the actual test being run is that the node `bgp-option-information/authentication-configured` exists. This is what Junos places in the body of the response to the RPC `get-bgp-neighbor-information` when a certain peer is configured with authentication.

Since our BGP peers are not configured with authentication, our previous test run failed. Let's first get our device compliant once more:

```
configure
set protocols bgp group PEERS neighbor 10.12.0.12 authentication-key antidote
set protocols bgp group PEERS neighbor 10.31.0.13 authentication-key antidote
commit and-quit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

Running our tests once more shows all passing, and we're now fully compliant with the two findings we've been looking at:

```
jsnapy --snapcheck -f jsnapy_config.yaml -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

JSNAPy was designed from the beginning for multiple tests across multiple devices. You can maintain your tests in the way you want, either in separate files, or grouped according to functionality, other guidelines, etc. If we wanted to run the same tests across more than just this one `vqfx1` device, we would only need to add them to the inventory in the JSNAPy config file.

These examples should get you started - consider writing more tests for other findings!
