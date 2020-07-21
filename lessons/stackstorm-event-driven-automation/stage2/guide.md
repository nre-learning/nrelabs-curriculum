Just like real "tasks" performed manually, or via another tool, StackStorm Actions almost never run in isolation. They're usually run in parallel with each other, or in sequence. They're usually run based off a decision that was made from information made available by an event, or another action's output.

In StackStorm, we call these complex logical structures ["Workflows"](https://docs.stackstorm.com/workflows.html).

<div style="text-align:center;"><img src="https://raw.githubusercontent.com/nre-learning/nrelabs-curriculum/v0.3.2/lessons/lesson-15/workflows.png"></div>

There are a few options for accomplishing this in StackStorm:

- For simple workflows, try [ActionChain](https://docs.stackstorm.com/actionchain.html)
- For complex workflows, your best bet is [Orquesta](https://docs.stackstorm.com/orquesta.html)

There are, of course, other tools like Ansible that accomplish similar purposes. Especially if you have existing Ansible playbooks, you can certainly [execute those playbooks from StackStorm](https://github.com/StackStorm-Exchange/stackstorm-ansible). The benefit of using the options listed above is that they're more tightly integrated with StackStorm, meaning the workflow and StackStorm can work together for advanced features like parallelism, or flow control like pausing a workflow, or [asking for more information to continue](https://docs.stackstorm.com/inquiries.html).

Regardless of the workflow mechanism you choose, Workflows allow us to create a logical decision path where we chain actions together to accomplish a broader objective, rather than simply "running a command" or "executing a script". We can use Workflows to commit our tribal knowledge about how we go about solving problems into an executable format that everyone can use.

The `examples` pack, which is one of the few built-in StackStorm packs, is preloaded in our environment, and is a really good place to start for working examples of workflows, for all types. For each of these three Workflow options, we'll begin by showing a few examples in the `examples` pack, and then move into some more relevant examples for network automation.

### ActionChain

[ActionChains](https://docs.stackstorm.com/actionchain.html) are the simplest (but also the least robust) workflow option in StackStorm. If you want to run a sequence of actions, with some minimal error-handling, ActionChains are probably sufficient for your purposes. They're the "bare minimum" workflows option in StackStorm.

The "hello world" example for ActionChains has to be the `echochain` - in particular, `examples.echochain_param`. This is a simple chain that takes a few parameters, and uses them as variables, inserted into a set of "echo" commands, resulting in some text in stdout:

```
cat /opt/stackstorm/packs/examples/actions/chains/echochain_param.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

Like many things in StackStorm, ActionChain workflows are defined in YAML, and contain two high-level keys:

- `chain` - A list of tasks to perform in this workflow. Each task specifies a `ref`, which refers to the Action that should be run in this step, as well as the `parameters` to pass to that Action, as well as which task to go to next based on success or failure.
- `default` - this specifies the first task in the workflow. In this case, `c1`.

> You may also notice that some parts of the workflow (`{{input1}}`, `{{c1.stdout}}`) look very similar to the variable substitution we saw in the previous lesson on Jinja templates. This is no accident - these are actually small Jinja templates, and StackStorm supports their use here, and in many other resources you may run into. You'll see this used throughout the rest of this lesson in order to make our Workflows, Rules, and Actions more dynamic. See the [docs](https://docs.stackstorm.com/reference/jinja.html) for more information on where Jinja is used in StackStorm.

Just like we previously saw with Actions, we can see which parameters are required by this workflow by using `st2 run` with the `-h` flag:

```
st2 run examples.echochain-param -h
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

Again, just like any other Action, we can execute this workflow by passing in the necessary parameters.

```
st2 run examples.echochain-param input1="Hello, NRE Labs"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

This output should look mostly familiar, with one big exception; the normal stuff like the execution id, input parameters,
timestamps, and result values are all there, but there's also a table shown underneath that gives us the ID, status, and
Action ref of each of the tasks in the workflow. We can use the `st2 execution get <execution ID>` command to retrieve this
status, but also the status of any of these subexecutions - go ahead try it now!

This is one of the benefits of using one of the built-in Workflow options in Stackstorm, as we not only get the advanced functionality of Workflows - allowing
us to do more than just running Actions in isolation - but also we get detailed information inside the workflow execution itself, and it's children tasks.

That's a very light introduction to ActionChains. Check out the [docs](https://docs.stackstorm.com/actionchain.html) or
the [examples pack](https://github.com/StackStorm/st2/tree/master/contrib/examples/actions/chains) for more information and working examples.

### Orquesta

[Orquesta](https://docs.stackstorm.com/orquesta.html) is StackStorm's solution to complex workflows, that don't follow a simple, linear path, and require more robust decision making, error handling, or retries.

Like ActionChains, Orquesta workflows are written in YAML, and they also contain a set of tasks (defined as a YAML dictionary this time). Each task refers to an `action`, and has a series of much more robust tools for managing the way the workflow should proceed.

```
cat /opt/stackstorm/packs/examples/actions/workflows/orquesta-basic.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

Let's take a quick peek at this file - you can see the inline comments below for an explanation of the syntax involved:

```yaml
version: 1.0

description: A basic workflow that runs an arbitrary linux command.

# These are our input parameters. The top-level bits of information that
# this workflow needs in order to function.
input:
  - cmd
  - timeout

# A list of tasks to perform in this workflow
tasks:

  # This is the first task
  task1:

    # This specifies which action to run. This could be a simple local shell command
    # (like shown here), or some other action, including other workflows.
    action: core.local cmd=<% ctx(cmd) %> timeout=<% ctx(timeout) %>

    # This helps the workflow engine understand what comes after this task. It is here we
    # can make decisions about whether to go to another task (including specifying which one),
    # or exiting the workflow.
    next:

      # This condition (note that this is a list so we can have multiple) allows us to perform
      # the below statement when this task has succeeded
      - when: <% succeeded() %>

        # 'publish' allows us to push information to a new variable within this workflow. In this
        # case, the variable 'stdout' is being set to the contents of the stdout for the command
        # we passed to core.local, and the same is true for stderr.
        publish:
          - stdout: <% result().stdout %>
          - stderr: <% result().stderr %>

# output allows us to control what this workflow publishes as variables to the caller. In this case,
# we're expecting that 'stdout' has been set by the task above, so we can return that variable as output.
output:
  - stdout: <% ctx(stdout) %>
```

We can run this like any action:

```
st2 run examples.orquesta-basic cmd="uname -a"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', this)">Run this snippet</button>

See the [Orquesta](https://docs.stackstorm.com/orquesta.html) for more details on how to write these types of Workflows.

### Mistral

[Mistral](https://docs.stackstorm.com/mistral.html), was historically the preferred option for complex workflows. It is a workflow engine built within the OpenStack project, and was integrated and packaged with StackStorm for many years.

However, at the time of this writing (mid-2020), Orquesta is mature enough that Mistral is now viewed as the legacy option. In fact, Mistral is not supported for [Ubuntu Bionic (18.04)](https://docs.stackstorm.com/install/u18.html) or [Centos8](https://docs.stackstorm.com/install/rhel8.html), which are the official deployment options for Python 3 support. Python 2, of course, is end-of-support, and even now, we're seeing all kinds of stuff break when not running on Python 3 (NAPALM library dropped support for Python 2 starting with 3.5.0).

So, bottom line - if you're new to StackStorm, Mistral might be nice to know about anecdotally, but your time is much better invested in Orquesta. It is the future.
