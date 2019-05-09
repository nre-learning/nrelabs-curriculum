## Event-Driven Network Automation with StackStorm

---

### Part 2 - Actions

Though it's important to understand that StackStorm is all about event-driven automation, it's also useful to spend some time talking about what StackStorm can **do**. Being able to watch for all the events in the world isn't very useful if you can't do anything about what you see. In StackStorm, we can accomplish such things through "[Actions](https://docs.stackstorm.com/actions.html)". Some examples include:

- Push a configuration change to a network device
- Restart a service on a server
- Retrieve information about a virtual machine
- Bounce a switchport
- Send a message to Slack

There are many others - and the list is growing all the time in the StackStorm [Exchange](https://exchange.stackstorm.org/). In short, Actions can be thought of simply as neatly contained bits of code to perform a task. They accept input, do work, and usually provide some output. They're the very last piece in the chain we'll be building to create an end-to-end event-driven automation solution in this lesson.

<div style="text-align:center;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/master/lessons/lesson-15/actions.png"></div>

Many of the `st2` subcommands we saw in the previous lab use verbs like `get`, `create`, `delete`, `list` for their corresponding resources.
For instance, to list the available actions that are currently present on our system, we can run:

```
st2 action list
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

You can see that each action is located within a "pack", which we explained in the last lab. For instance, the "core" pack comes pre-installed with StackStorm,
and contains many common actions for doing simple things like running bash commands, calling a REST API, and more.


#### Hello World!

The `local` action in the `core` pack is referred to by it's "full name" as `core.local`. We can pass this to `st2 run` to execute this action:

```
st2 run core.local "echo Hello World!"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

Not every action is created equal - like any program or script, each action comes with different parameters - some optional, some required - that are necessary for it
to get its job done. Fortunately, we can use the handy `-h` flag to gain insight right at the command line into what parameters any action supports:

```
st2 run core.local -h
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

You can see that the `cmd` parameter is required, and is what we supplied in double quotes - the command to run on the bash shell.

The `echo` command usually takes a split second to execute. However, some actions can take much longer: minutes, hours, even more.
While it's usually the case that these Actions are executed via Triggers (which we'll get to in a later lab), it may be necessary to
start, or re-run them on the command-line as well. The `-a` flag allows us to execute an action in the same way, but we won't have to
wait for the Action to complete in order to get our terminal back - the `st2` command will return an execution ID for us right away:

```
st2 run -a core.local "sleep 300"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

You may notice that the output contains a reference to another StackStorm command we haven't seen yet:

```
st2 execution get < EXECUTION ID >
```

In StackStorm, the term "execution" is used to describe an instance of a running action. Each time you run an action, it's given an execution ID, which is a unique identifier of that exact instance where that action was run. Since we told `st2` to run this Action asynchronously, it make sure the Action execution was scheduled, retrieved its ID, and returned it to us immediately, so we can use `st2 execution get` to retrieve status at any time, rather than waiting for it to finish.

This is also useful because, as we'll see in the next few labs, we don't always run actions on the command-line directly like this. Sometimes it's done for us by a rule, or a workflow. In those cases, retrieving execution details using `st2 execution get` is often the only way to know how an action performed. We can see a list of recent executions as well:

```
st2 execution list
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

Now, this is a simple example, and there's way more to get into in the `core` pack, such as executing remote commands or scripts, calling REST APIs, and more. However,
this is a network automation lesson, and there's way too much value in using a tool like StackStorm for event-driven network automation, so let's get
into some more relevant examples.

#### Running NAPALM Actions against network devices

You may have seen [in another lesson](https://labs.networkreliability.engineering/labs/?lessonId=13&lessonStage=1) that
[NAPALM](https://github.com/napalm-automation/napalm) is an extremely useful tool in network automation. It's a Python library that sits on top of many vendor-specific
APIs like Juniper's NETCONF, Arista's eAPI, and Cisco's NX-API and exposes common functions so you don't have to worry about these vendor's APIs. You just interact
with NAPALM in your Python scripts, and NAPALM takes care of communicating with the upstream device(s).

StackStorm's exchange includes a pack for exposing NAPALM's functionality. This means, among other things, we can use NAPALM functions as StackStorm actions.
You might have noticed earlier that this pack is already installed, and the actions in the pack are available to us:

```
st2 action list --pack=napalm
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>


The `get_facts` action in this pack is a great place to get started. Like we saw in the NAPALM lesson, this action gathers some basic information about a network device, like the serial number and hostname:

```
st2 run napalm.get_facts hostname=vqfx1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

At this point, you might be asking "Where did we pass in the credentials for vqfx1"? Like many packs, these details are captured in the pack configuration:

```
cat /opt/stackstorm/configs/napalm.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

This configuration is specific to the `napalm` pack, and consists of two main parts. A list of devices, which we referred to by name with the `hostname` parameter, and a list
of credentials, which each device entry references in order to specify which credential set to use.

Getting facts is kind of cool - but what about something a little more specific? How about the current BGP peers?

```
st2 run napalm.get_bgp_neighbors hostname=vqfx1
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

Finally, it would be really great if we could actually push a config change with StackStorm.  If you pay attention to the output retrieved in the previous command, you may have noticed that one of our configured BGP peers is inactive. Upon further inspection, we see that the BGP configuration on vqfx1 is using the wrong `peer-as` attribute.

As part of this lesson, we've included a configuration snippet that will replace only the relevant configuration with the corrected `peer-as` attribute:

```
cat /antidote/stage2/vqfx1-config-patch.txt
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

The `loadconfig` action can accept this path as a parameter, and will perform a merge between this configuration, and the existing configuration:

```
st2 run napalm.loadconfig hostname=vqfx1 config_file="/antidote/stage2/vqfx1-config-patch.txt"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

If we go to vqfx1 now, we'll see that both BGP peers are active:

```
cli
show bgp summary
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

This was a brief look at StackStorm actions, using the `napalm` pack as an example, since it's extremely useful for our purposes here, learning event-driven network automation. However, there are **many** more actions inside many more packs available on the [StackStorm Exchange](https://exchange.stackstorm.org/), and you should definitely check those out as well.

In the next lab, we'll learn how to link actions together in a workflow, using the data we've retrieved in some of these actions to drive more complex decision-making.

