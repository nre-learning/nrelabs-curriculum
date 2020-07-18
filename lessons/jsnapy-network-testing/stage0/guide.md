A big part of what makes automation work in production, especially in environments that have adopted "infrastructure as code" is automated testing. It's not enough to just write some scripts to automate common tasks, you need to also automate the validation that your infrastructure is in the state you expect. This is exactly why software developers have adopted automated testing. It's not enough to just write some software and hope it works; rather, tests are written and often packaged with the software itself. Infrastructure testing can and should follow a similar model.

You may be thinking to yourself "I can just run a bunch of 'show' commands really quickly and know if my network is working". Maybe you have a series of show commands in a notepad document on your laptop that you can paste into a terminal to help you troubleshoot. There are a few problems with this:

- Knowing what show commands to run on which devices isn't obvious to everyone on your team, present and future.
- Knowing what output from those show commands is "normal" is equally non-obvious.
- This model is fragile; one person running a bunch of show commands perfectly (not forgetting any devices or commands) and at the right time (it turns out, humans need sleep).

It would be great if we could represent the series of data retrieval tasks (show commands) that need to take place to get an understanding of the current state of the the network, as well as the automated assertions about what that data **should look like** in a normal case, as simple text files in a version control repository, just like software developers do for their tests. Doing this would immediately give us some big benefits:

- Gets new engineers up to speed quickly on what "normal" is (everything's plainly laid out in the tests, not in someone's head).
- Really helps in initial troubleshooting - at the beginning of each incident, run the test suite. Limit the scope of your initial discovery to the stuff that doesn't match the expectation.

<div style="text-align:center;margin-top:30px;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/jsnapy-updates/lessons/jsnapy-network-testing/jsnapy-logo.png"></div>

In this lesson, we'll explore the ideas of writing automated tests against our network infrastructure using a tool called [JSNAPy](https://github.com/Juniper/jsnapy). This is a tool that allows us to reap the benefits of automated testing in two steps:

- Automating the retrieval of state from network devices. OSPF adjacencies, number of routes, number of configuration options, etc. Anything in the XML tree.
- Making assertions about what that state **should be**, and bringing deviations to our attention.

## Understanding the Junos Data Model

If we take a look at `r1`, we can enter the Junos CLI by running `cli`, and then run `show ospf neighbor` to see the list of OSPF adjacencies that have formed.

```
cli
show ospf neighbor
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('r1', this)">Run this snippet</button>

One of the cool things about Junos is that everything is model-driven. All of the output you're seeing on the screen is based on models that were packaged within Junos, and in response to this "show" command, Junos is actually providing all of the necessary information via an XML payload that conforms to these models. Just before displaying it to us, the Junos CLI is actually translating from this XML payload into the more readable tabular output you see on the screen.

However, we can ask the Junos CLI to give us the raw XML, which is often necessary in the world of automation - while XML may "look gross", it is highly structured, and MUCH easier to parse than CLI output. We can do this by using the "pipe" operator (`|`) and then `display xml`: 

```
show ospf neighbor | display xml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('r1', this)">Run this snippet</button>

This is the same information we saw before, but in the raw XML format, rather than the "human friendly" tabular output. Cool trick, right? You can use this for nearly any Junos command, to access the XML "behind the scenes". You'll notice in this output that we have two `ospf-neighbor` nodes, one for each OSPF neighbor. Within these you'll see children nodes like `ospf-neighbor-state`, and `neighbor-id`, which are attributes of this neighbor from the perspective of `r1` (remember this is where we ran this command). Each of these has some kind of value representing the current state of that attribute at the time you ran the command, just like any other "show" command.

At this point, you may be wondering how to retrieve this information without using the CLI. After all, when we're using an external NETCONF client, which tools like PyEZ (covered in another lesson) or JSNAPy, we'll need to use NETCONF RPCs rather than CLI syntax. Here's where another cool trick comes in handy. If we pipe the same "show" command through `display xml rpc`, we can see that this information is available using the `get-ospf-neighbor-information` RPC:

```
show ospf neighbor | display xml rpc
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('r1', this)">Run this snippet</button>

It should be noted that not every Junos command has a dedicated RPC, but fortunately this is a very popular one, so we have our own RPC for this information. In an upcoming chapter of this lesson, we'll cover other ways to retrieve data that may not have its own dedicated RPC.

These tools will aid us heavily in the next sections on JSNAPy snapshots and tests.

## JSNAPY- Retrieving Snapshots

As mentioned earlier, JSNAPy works by first retrieiving data from the network device about....really, anything. This is up to you. Regardless, this data is referred to as a "snapshot", and in this section, we'll use the example of OSPF neighbors as the kind of data we want to grab snapshots about.

To do this, JSNAPy first must know about the devices you intend to create snapshots from. It does this in a configuration file that we'll pass in as a command-line argument later. This file is formatted as YAML, and we can use a tool called `bat` to look at the contents of this file with some helpful syntax highlighting and line numbers:

```
cd /antidote/stage0
bat snapshot0_config.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

You may notice the `tests` section refers to another YAML file called `snapshot0.yaml` - let's take a look at this now:

```
bat snapshot0.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

This example is very simple, and despite the name of the previous section where this was referenced, this file doesn't contain any tests at all - just the RPC we want to use to retrieve OSPF neighbor state.

Let's run the `jsnapy` command, passing in the configuration file, as well as the name for this snapshot - we'll call it `snapshot0`:

```
jsnapy --snap snapshot0 -f snapshot0_config.yaml -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

When we ran that command, JSNAPy used the `get-ospf-neighbor-information` RPC on each network device, and stored the responses in snapshot files located here:

```
ls -lha ~/jsnapy/snapshots/
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

You'll notice there are files for each device in our inventory. You'll also notice that the filename contains the RPC used, so at-a-glance, we can quickly tell which file contains what kind of contents. Let's take a look at the one for `r1`:

```
xmllint --format ~/jsnapy/snapshots/r1_22_snapshot0_get_ospf_neighbor_information.xml | pygmentize
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

You'll notice this exactly matches the XML data we retrieved via the command-line of `r1`.

And we're halfway there! We've retrieved the necessary bits of data; now, let's make some assertions about what that data **should be**, using JSNAPy tests.

## Making Assertions About State With "Tests"

It's not enough to just know the current state of things. Much of what makes an experienced network engineer is knowing the peculiarities of your specific environment. Maybe a given router interface is supposed to be down. Maybe there are certain number of routes that you expect to learn from a given BGP peer. All of these things are very specific to your environment, and it can be tremendously helpful to not just automate the retrieval of this state, but codify all of your built-in assertions about what that state should be, so that everyone can benefit from it.

With JSNAPy, we can do exactly that using "tests". This takes the concepts of state retrieval that we've already learned to the next level, by allowing us to specify in a YAML file the specific constraints that indicate what the data should look like, so that it's no longer stored in our brain, it's laid out for all to see, and more importantly, in a way that can be automated fully.

Let's take a look at a new pair of config/test files:"

```
bat test0_config.yaml
bat test0_test.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

In `test0_test.yaml` you'll notice we've added a lot more text. Please read the in-line comments for an explanation of each part of this test file. In short, we're making the assertion that each OSPF neighbor is in the "Full" state, by zooming in on the particular part of the XML response that contains that information, and using the `is-equal` operator to make the comparison. Don't worry, this is just a simple example. We'll go into a lot more detail on other operators you can use in a future chapter of this lesson.

We can execute this test using the `--snapcheck` flag to the `jsnapy` command. In effect, this will cause JSNAPy to first retrieve a fresh snapshot, and then immediately "check" that snapshot's contents using the instructions in our test file, for compliance with what we want:

```
jsnapy --snapcheck -f test0_config.yaml -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

Because all OSPF neighbors are in the "Full" statement, our assertion evaluates to "true" for all three devices, and JSNAPy lets us know what all tests pass with a bunch of beautiful green text. Yay!

Of course if you're like me, you want to see some stuff break, so let's see what happens when we - oh I don't know - delete the entire OSPF configuration on `r1`:

```
conf
delete protocols ospf
commit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('r1', this)">Run this snippet</button>

Simply re-running the exact same test shows that the assertion about OSPF state fails on `r1`, since it's not configured at all:

```
jsnapy --snapcheck -f test0_config.yaml -v
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux', this)">Run this snippet</button>

However, because we weren't asserting the **number** of OSPF neighbors there should be, the tests on `r2` and `r3` pass just fine; while there were only one neighbor relationship on each, the assertion was only that whatever neighbors are there have a "Full" state, which is true. This highlights the importance of writing specific, and exhaustive tests. Maybe we could add to or change our test to capture the reduction in OSPF neighbors from the expected state? We'll explore this in future chapters.

This has been a very simple example, but hopefully you're starting to see the value in codifying the built-in assertions that we have about our infrastructure, so that we can very easily and quickly get a solid picture of what is "out of place". This becomes immensely valuable when you're in the hot seat, trying to figure out the cause of an outage, as you no longer have to poke around running "show" commands yourself - you can just run your tests, and see what fails.

This was a very quick introduction to JSNAPy. In future sections, we'll be diving into much more detail on both data retrieval, as well as testing, and the myriad of options available to use for both.
