In this lesson, we're going to talk about running tests against our network with a nifty open source tool called [JSNAPy](https://github.com/Juniper/jsnapy). Being able to describe what we expect "normal" to mean on our network in simple text files saves us a ton of time when troubleshooting, or when making changes. It also helps new engineers come up with speed quickly with what the network is supposed to look like on a normal day.

First, let's take a peek at our network configuration by going to `junos1`. We can see that no BGP peers have been configured:

```
show bgp summary
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('junos1', this)">Run this snippet</button>

This doesn't seem right. You heard from another engineer that this router should be running BGP, so to see that it has no peers configured is concerning.

Fortunately, you know that your team uses JSNAPy to describe what "normal" looks like, so we should be able to run some tests to confirm this is the case, rather than rely on tribal knowledge.
s
We can run the below commands on our Ubuntu host to see the JSNAPy configuration file:

```
cd /antidote/
cat jsnapy_config.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

We see that the configuration specifies the three routers in our topology. We also see that it references a test file. Let's take a look at that now:

```
cat jsnapy_tests.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

In this test file, you see that three checks are being performed:

- There must be one BGP group configured
- There must be two BGP peers configured
- There must not be any "down" BGP peers

This is a nifty way to state what "normal" is, so we don't have to guess. Let's just run JSNAPy, and the tool will tell us which of these assertions isn't actually true right now.

```
jsnapy --snapcheck -f jsnapy_config.yaml -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

