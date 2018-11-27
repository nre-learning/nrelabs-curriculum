# Event-Driven Network Automation with StackStorm
## Part 2 - Workflows

https://github.com/StackStorm/st2

TBD
```
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>


Just like real "tasks" performed manually, or via another tool, StackStorm Actions almost never run in isolation. They're usually run in parallel with each other, or in sequence. They're usually run based off a decision that was made from information made available by an event, or another action's output.

In StackStorm, we call these complex logical structures "Workflows". There are a few options for accomplishing this in StackStorm, but in short, Workflows allow us to create a logical decision path where we chain actions together to accomplish a broader objective, rather than simply "running a command" or "executing a script". We can use Workflows to commit our tribal knowledge about how we go about solving problems into an executable format that everyone can use.


### What about other tools?

You might be asking - why not use other tools like Ansible, Puppet, or Chef for running workflows? In short, you can, but they're not recognized formally as a workflow by StackStorm. Let's use Ansible an an example:

In contrast to what we've seen with ActionChains and Mistral workflows, where each workflow execution spawns child executions for each task that workflow performs, StackStorm instead handles an Ansible playbook as a single Action Execution. Once the playbook begins executing, StackStorm doesn't have control over the individual tasks - it can only see what Ansible reports via stdout, and simply waits for the `ansible-playbook` process to finish. This isn't a bad or a good thing; it just moves the finer control elsewhere. Use the solution that works best for your needs.
