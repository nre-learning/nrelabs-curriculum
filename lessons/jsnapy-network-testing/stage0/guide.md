Concepts like "infrastructure as code" are becoming the preferred way to do network automation. A big part of this is writing automated tests.

## Why test your network? 

- Gets new engineers up to speed quickly on what "normal" is. (normal is whats in the test, not in someone's head)
- Really helps in initial troubleshooting

In this lesson, we'll explore the ideas of writing automated tests against our network infrastructure using a tool called [JSNAPy](https://github.com/Juniper/jsnapy).

< give brief history and overview of JSNAPy with links >


 is a tool that allows you to do just this. Being able to describe what we expect "normal" to mean on our network in simple text files saves us a ton of time when troubleshooting, or when making changes. It also helps new engineers come up with speed quickly with what the network is supposed to look like on a normal day.

## Your First JSNAPy Test

```
cd /antidote/stage0
cat test0_config.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

```
cli
show ospf neighbor
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('r1', this)">Run this snippet</button>

```
show ospf neighbor | display xml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('r1', this)">Run this snippet</button>

```
show ospf neighbor | display xml rpc
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('r1', this)">Run this snippet</button>

```
cat test0_test.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

```
jsnapy --snapcheck snap.xml -f test0_config.yaml -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

