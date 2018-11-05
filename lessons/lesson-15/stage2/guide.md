# Event-Driven Network Automation with StackStorm
## Part 2 - Workflows

https://github.com/StackStorm/st2

TBD
```
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

### What about other tools?

You might be asking - why not use other tools like Ansible, Puppet, or Chef for running workflows? In short, you can, but they're not recognized formally as a workflow by StackStorm. Let's use Ansible an an example:

In contrast to what we've seen with ActionChains and Mistral workflows, where each workflow execution spawns child executions for each task that workflow performs, StackStorm instead handles an Ansible playbook as a single Action Execution. Once the playbook begins executing, StackStorm doesn't have control over the individual tasks - it can only see what Ansible reports via stdout, and simply waits for the `ansible-playbook` process to finish. This isn't a bad or a good thing; it just moves the finer control elsewhere. Use the solution that works best for your needs.

