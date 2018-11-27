## Event-Driven Network Automation with StackStorm

---

<div class="alert alert-warning" role="alert">
  This lesson comes with a video, and it's highly recommended that you watch this first. Click the "Lesson Video" button above to watch!
</div>

### Part 1 - StackStorm CLI and Packs

StackStorm is a powerful event-driven automation framework that is built from infrastructure-as-code principles and designed
to be extensible at every layer.

In this lesson, we'll be mostly working with the StackStorm command-line utility `st2`, so in this first lab, we'll take a moment to overview this, as well
as how StackStorm integrates with other systems through something called `packs`.

Note that in many places in this lesson, we'll be linking to the [StackStorm docs](https://docs.stackstorm.com/).
This is definitely the best place to go for more technical information on how StackStorm is installed, configured,
and operated. This lesson will instead focus on the basic concepts to get you started.


#### Command-Line Help

Throughout these tutorials, you may have questions about a certain StackStorm command, such as what arguments are supported,
or how to provide a certain parameter. Note that the StackStorm command-line utility, `st2`, allows you to use the `-h`
flag at various levels to get help output. For instance, if you want an overview of global `st2` subcommands or flags, simply run:

```
st2 -h
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 0)">Run this snippet</button>

You'll notice there are several subcommands available to us. Many of these are StackStorm resources that fill specific roles in the event-driven
automation paradigm, such as `trigger`, `rule`, and `action`. We'll be diving deeper into each of these in the following labs.

You'll also notice some optional arguments you can supply, such as the immensely helpful `--debug` flag, which prints out all interactions
between the CLI and the StackStorm API in a really cool way - the responses are pretty-printed as JSON to the terminal, and the requests
are printed as the equivalent cURL command, so if you wanted to script your own StackStorm API calls, you just need to add this debug flag
to your favorite command and.....and...... you know what, just run it and see for yourself - it's so cool!

```
st2 --debug run core.local date
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 1)">Run this snippet</button>

Don't worry about the details of the command we just ran, we'll cover that in detail in the next lab.

As mentioned before, `-h` is useful at multiple levels in addition to the global `st2` command. For instance, we can use it for the `st2 run` command
we just ran to see what options that subcommand supports:


If you already know you want to run an action, but you want to know the proper syntax on top of that, see the contextual help there:

```
st2 run -h
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 1)">Run this snippet</button>


#### StackStorm Packs

As mentioned before, StackStorm is highly extensible. It focuses entirely on the primitives necessary to enable event-driven automation,
and integrates with existing tools to accomplish tasks or receive events.

In StackStorm, all extensibility is done through something called a "Pack". Any time you want StackStorm to integrate with some
third-party system, or if you want to upload some custom rules or workflows, you do this through a pack.

The StackStorm project maintains its own [Exchange](https://exchange.stackstorm.org/) which is a centralized index containing many community-maintained packs
that make it easier to install these integrations. This index is maintained to ensure the really popular packs have a more-or-less permanent home, and to allow
much easier installation via the CLI.

```
~$ st2 pack install napalm

For the "napalm" pack, the following content will be registered:

rules     |  4
sensors   |  1
triggers  |  0
actions   |  27
aliases   |  1

Installation may take a while for packs with many items.

	[ succeeded ] download pack
	[ succeeded ] make a prerun
	[ succeeded ] install pack dependencies
	[ succeeded ] register pack

+-------------+----------------------------------------------------+
| Property    | Value                                              |
+-------------+----------------------------------------------------+
| name        | napalm                                             |
| description | NAPALM network automation library integration pack |
| version     | 0.2.14                                             |
| author      | mierdin, Rob Woodward                              |
+-------------+----------------------------------------------------+
```

In short, any time you want to integrate with something, find the pack for it. It's important to note also that not all packs need to be in the Exchange.
You can also [install packs directly from any Git repository](https://docs.stackstorm.com/packs.html#installing-a-pack):

```
~$ st2 pack install https://github.com/emedvedev/chatops_tutorial

	[ succeeded ] download pack
	[ succeeded ] make a prerun
	[ succeeded ] install pack dependencies
	[ succeeded ] register pack

+-------------+---------------------------+
| Property    | Value                     |
+-------------+---------------------------+
| name        | Chatops Tutorial          |
| description | Tutorial pack for ChatOps |
| version     | 0.3.0                     |
| author      | emedvedev                 |
+-------------+---------------------------+
```

For simplicity, this lesson's instance of StackStorm will come pre-installed with all the packs we'll need, but it's important to keep these commands in mind if you want to use StackStorm in your own environment, so you can install the same extensions we refer to.

In the next lab, we'll start diving into the specific primitives that StackStorm uses to enable event-driven automation, starting with "Actions". See you then!
