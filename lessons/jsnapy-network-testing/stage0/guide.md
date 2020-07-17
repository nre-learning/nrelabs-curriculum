Concepts like "infrastructure as code" are becoming the preferred way to do network automation. A big part of this is writing automated tests.


<div style="text-align:center;margin-top:30px;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/jsnapy-updates/lessons/jsnapy-network-testing/jsnapy-logo.png" width="300px"></div>

## Why test your network?

You may be thinking to yourself "I can just run a bunch of 'show' commands really quickly and know if my network is working" Maybe you have a series of show commands in a notepad document that you can paste into a terminal to help you troubleshoot. There are a few problems with this:

- Knowing what show commands to write isn't obvious to everyone on your team.
- Knowing what output from those show commands is "normal" is DEFINITELY not obvious to everyone.
- This model is based on one person running these show commands a) perfectly (not forgetting any devices or commands) and b) doing so at the right time (turns out humans need to sleep)

Test allow you to commit as-code:

- The series of data retrieval tasks (show commands) that need to take place to get an understanding of the current state of the the network
- The automated assertions about that data. If the resulting data is within the bounds you define in the test, everything shows green. Red only shows when there is deviation.

Benefits:

- Gets new engineers up to speed quickly on what "normal" is. (normal is whats in the test, not in someone's head)
- Really helps in initial troubleshooting

In this lesson, we'll explore the ideas of writing automated tests against our network infrastructure using a tool called [JSNAPy](https://github.com/Juniper/jsnapy).

< give brief history and overview of JSNAPy with links >


 is a tool that allows you to do just this. Being able to describe what we expect "normal" to mean on our network in simple text files saves us a ton of time when troubleshooting, or when making changes. It also helps new engineers come up with speed quickly with what the network is supposed to look like on a normal day.

JSNAPy allows us to accomplish this by doing two things:

- Automating the retrieval of state from network devices. OSPF adjacencies, number of routes, number of configuration options, etc. Anything in the XML tree.
- Making assertions about what that state **should be**, and bringing deviations to our attention.

## Understanding the Junos Data Model

If we take a look at `r1`, we can enter the Junos CLI by running `cli`, and then run `show ospf neighbor` to see the list of OSPF adjacencies that have formed.

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

## Retrieving Snapshots of State

```
cd /antidote/stage0
jsnapy --snap snapshot1 -f test0_config.yaml -v
```

When we ran that command, JSNAPy identified the retrieval methods identified 

```
ls -lha ~/jsnapy/snapshots/
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>
jsnapy

```
xmllint --format ~/jsnapy/snapshots/r1_22_snapshot1_get_ospf_neighbor_information.xml | pygmentize
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>


## Making Assertions About State With "Tests"

```
cd /antidote/stage0
cat test0_config.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>


```
cat test0_test.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

```
jsnapy --snapcheck -f test0_config.yaml -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

