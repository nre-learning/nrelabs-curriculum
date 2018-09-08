# Lesson 12 - Unit Testing Networks with JSNAPy

In this lesson, we're going to talk about running tests against our network with a nifty open source tool called [JSNAPy](https://github.com/Juniper/jsnapy). Being able to describe what we expect "normal" to mean on our network in simple text files saves us a ton of time when troubleshooting, or when making changes. It also helps new engineers come up with speed quickly with what the network is supposed to look like on a normal day.

First, let's take a peek at our network configuration by going to `vqfx1`. We can see that no BGP peers have been configured:

```
cli
show bgp summary
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', 0) type=">Run this snippet</button>

<!-- > Need to be able to click a button by a snippet to paste into the currently shown terminal -->

Next, we can go to our bash shell and see what kind of files JSNAPy requires:

```
cd /antidote/lessons/lesson-12/
cat jsnapy_config.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1) type=">Run this snippet</button>

```
cat jsnapy_tests.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2) type=">Run this snippet</button>


```
jsnapy --snapcheck -f jsnapy_config.yaml -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3) type=">Run this snippet</button>