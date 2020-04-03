# Multi-Vendor Network Automation with NAPALM
## Part 3 - The NAPALM Command-Line Utility

Depending on the use case, you may want to use NAPALM's Python library directly, such as in scripts you've already written. However, NAPALM includes a command-line utility which provides a nice alternative to being able to run many of the same functions without writing any Python at all.

First, let's create an alias so we can cut down on repetitive flags. We're always going to be connecting to the same device with the same credentials,
so adding an alias will save us some screen real estate and keystrokes:

```
alias napalm="napalm --user=antidote --password=antidotepassword --vendor=junos"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

Using the `-h` flag shows us we have a few subcommands we can use:

```
napalm -h
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

In this lab we'll focus on the `call` subcommand. This subcommand allows us to execute the "getter" functions, such as `get_interfaces`,
which we saw used from Python in the previous lab. The cool thing about running this all from the Bash shell is we can take advantage of the multitude of tools for working with text data:

```
napalm vqfx1 call get_interfaces | jq .em4
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

What just happened? Well, first the command `napalm vqfx1 call get_interfaces` retrieved the full list of network interfaces we saw in the previous example. Then, we piped that big JSON dictionary into the `jq` tool, which allows us to specify a particular key (in this case, `em4`) and only display the value for that key. Thus, we only get `em4`'s interface information. This is the power of using tools like NAPALM at the bash shell - no need to log in to the device and check the interface data one at a time. Just change the hostname or the interface name on this one line.

There are other useful functions we can execute, not just the "getter" functions we've seen thus far. The `ping` function allows us to initiate a ping from the device we're connecting to. This is extremely useful for doing reachability tests - again, without actually opening an interactive terminal connection to the remote device.

```
napalm vqfx1 call ping --method-kwargs="destination='10.0.0.15'"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

There are a few other subcommands, but we'll cover those in either another lesson, or in the case of configuration capabilities, the very next lab.
For that, we go back into the world of Python...
