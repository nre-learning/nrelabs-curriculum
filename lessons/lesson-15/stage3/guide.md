## Event-Driven Network Automation with StackStorm

---

### Part 3 - Workflows

Just like real "tasks" performed manually, or via another tool, StackStorm Actions almost never run in isolation. They're usually run in parallel with each other, or in sequence. They're usually run based off a decision that was made from information made available by an event, or another action's output.

In StackStorm, we call these complex logical structures ["Workflows"](https://docs.stackstorm.com/workflows.html).

<div style="text-align:center;"><img src="https://raw.githubusercontent.com/nre-learning/antidote/st2-lesson/lessons/lesson-15/workflows.png" width="100"></div>

There are a few options for accomplishing this in StackStorm:

- [ActionChain](https://docs.stackstorm.com/actionchain.html)
- [Mistral](https://docs.stackstorm.com/mistral.html)
- [Orquesta](https://docs.stackstorm.com/orquesta.html)

There are, of course, other tools like Ansible that accomplish similar purposes. Especially if you have existing Ansible playbooks, you can certainly [execute those playbooks from StackStorm](https://github.com/StackStorm-Exchange/stackstorm-ansible). The benefit of using the options listed above is that they're more tightly integrated with StackStorm, meaning the workflow and StackStorm can work together for advanced features like parallelism, or flow control like pausing a workflow, or [asking for more information to continue](https://docs.stackstorm.com/inquiries.html).

Regardless of the workflow mechanism you choose, Workflows allow us to create a logical decision path where we chain actions together to accomplish a broader objective, rather than simply "running a command" or "executing a script". We can use Workflows to commit our tribal knowledge about how we go about solving problems into an executable format that everyone can use.

The `examples` pack, which is one of the few built-in StackStorm packs, is preloaded in our environment, and is a really good place to start for working examples of workflows, for all types. For each of these three Workflow options, we'll begin by showing a few examples in the `examples` pack, and then move into some more relevant examples for network automation.

#### Example 1 - ActionChain

[ActionChains](https://docs.stackstorm.com/actionchain.html) are the simplest (but also the least robust) workflow option in StackStorm. If you want to run a sequence of actions, with some minimal error-handling, ActionChains are probably sufficient for your purposes. They're the "bare minimum" workflows option in StackStorm.

The "hello world" example for ActionChains has to be the "echochain" - in particular, `examples.echochain_param`. This is a simple chain that takes a few parameters, and uses them as variables, inserted into a set of "echo" commands, resulting in some text in stdout:

```
cat /opt/stackstorm/packs/examples/actions/chains/echochain_param.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 0)">Run this snippet</button>

Like many things in StackStorm, ActionChain workflows are defined in YAML, and contain two high-level keys:

- `chain` - A list of tasks to perform in this workflow. Each task specifies a `ref`, which refers to the Action that should be run in this step, as well as the `parameters` to pass to that Action, as well as which task to go to next based on success or failure.
- `default` - this specifies the first task in the workflow. In this case, `c1`.

> You may also notice that some parts of the workflow (`{{input1}}`, `{{c1.stdout}}`) look very similar to the variable substitution we saw in the previous lesson on Jinja templates. This is no accident - these are actually small Jinja templates, and StackStorm supports their use here, and in many other resources you may run into. You'll see this used throughout the rest of this lesson in order to make our Workflows, Rules, and Actions more dynamic. See the [docs](https://docs.stackstorm.com/reference/jinja.html) for more information on where Jinja is used in StackStorm.

Just like we previously saw with Actions, we can see which parameters are required by this workflow by using `st2 run` with the `-h` flag:

```
st2 run examples.echochain-param -h
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 1)">Run this snippet</button>

Again, just like any other Action, we can execute this workflow by passing in the necessary parameters.

```
st2 run examples.echochain-param input1="Hello, NRE Labs"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 2)">Run this snippet</button>

This output should look mostly familiar, with one big exception; the normal stuff like the execution id, input parameters,
timestamps, and result values are all there, but there's also a table shown underneath that gives us the ID, status, and
Action ref of each of the tasks in the workflow. We can use the `st2 execution get <execution ID>` command to retrieve this
status, but also the status of any of these subexecutions - go ahead try it now!

This is one of the benefits of using one of the built-in Workflow options in Stackstorm, as we not only get the advanced functionality of Workflows - allowing
us to do more than just running Actions in isolation - but also we get detailed information inside the workflow execution itself, and it's children tasks.

That's a very light introduction to ActionChains. Check out the [docs](https://docs.stackstorm.com/actionchain.html) or
the [examples pack](https://github.com/StackStorm/st2/tree/master/contrib/examples/actions/chains) for more information and working examples.

#### Example 2 - Mistral

[Mistral](https://docs.stackstorm.com/mistral.html), by contrast, is much more powerful than ActionChains. While ActionChains excel
in simplicity, it's this simplicity that can, at times, prove inadequate for some of the decision-making power or execution style we need
in our Workflows from time to time. In these cases, some of the [advanced features](https://docs.openstack.org/mistral/latest/main_features.html)
that Mistral brings to the table may prove useful.

However, unlike ActionChains, Mistral is an [OpenStack project](https://docs.openstack.org/mistral/latest/), and not part of the StackStorm codebase. Instead,
StackStorm maintains [close integrations with Mistral](https://github.com/StackStorm/st2mistral) so that Mistral can run as a separate entity,
and ensure StackStorm and Mistral remain in sync with each other regarding workflow and action executions.

```
cat /opt/stackstorm/packs/examples/actions/workflows/mistral-jinja-branching.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 3)">Run this snippet</button>

Like ActionChains, Mistral workflows are written in YAML, and they also contain a set of tasks (defined as a YAML dictionary this time) under the `tasks` key.
Each task refers to an `action`, which in the case of a Mistral+Stackstorm deployment like we have here, refers to a StackStorm action.

The `publish` keyword allows us to create new variables to use later in the workflow. In this case, the variable `path` is being created, and the Jinja template we see being assigned to it: `"{{ task('t1').result.stdout }}"` captures the resulting text printed to stdout by the command run by `t1`. We can see that this command is `"echo {{ _.which }}"`, which itself has a Jinja template that passes in the `which` parameter, which we can see is a parameter required by the workflow as a whole.

Let's give this a try:

```
st2 run examples.mistral-jinja-branching which=a
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 4)">Run this snippet</button>

The output is similar to what we saw with ActionChains - because Mistral is also a Workflow option in StackStorm, we see a table of all our subexecutions. However, we
only see two subexecutions, while we saw four tasks in the Mistral workflow: `t1`, `a`, `b`, and `c`.

Like ActionChains, Mistral allows us to specify which task to run based on success or failure. However, as we can see, if `t1` succeeds, the workflow
points to not one, but all three other tasks (`a`, `b`, and `c`). In addition, each reference contains a Jinja template that performs a conditional check.
The way this works is that Mistral will evaluate these conditionals, and the ones that result in a boolean True will cause the workflow to execute the referenced task next.

In the workflow we executed, we provided `a` as input to the `which` parameter, and based on this workflow logic, the `a` task was executed next.

You can use this to make some pretty advanced decisions in your own workflows: executing actions only when the input to the workflow,
or perhaps the output of one or more of that workflow's tasks, shows a certain value.

#### Example 3 - Orquesta

[Orquesta](https://docs.stackstorm.com/orquesta.html) is the new kid on the block - released recently, and currently a "beta" workflow
option in StackStorm, it combines the advantage of ActionChain's "built-in" nature with the robustness and flexibility of Mistral.
