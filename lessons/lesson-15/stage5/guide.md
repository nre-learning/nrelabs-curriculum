## Event-Driven Network Automation with StackStorm

---

### Part 5 - Rules

And now, all of the concepts we've learned thus far come together. In this lesson we'll explore how *[Rules](https://docs.stackstorm.com/rules.html)* allow us to link the events that are reported to StackStorm via Sensors and Triggers, to the actions we want to take in response to those events in Actions and Workflows. Rules are the missing link in this chain.

<div style="text-align:center;"><img src="https://raw.githubusercontent.com/nre-learning/antidote/master/lessons/lesson-15/rules.png"></div>

With Rules, we are declaring to StackStorm what events we care about (in the form of Triggers), and what action we want to take in response to seeing those events. In this lab, we'll create a Rule that responds to the Triggers we saw in the previous lab (`napalm.InterfaceDown`) and replaces the interface configuration on the affected device to turn the interface back up again.

Our finished rule file can be seen here - continue for a walkthrough of each of the components of this file:

```
cat /antidote/lessons/lesson-15/stage5/replace_interface_config.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 0)">Run this snippet</button>

The first part of a rule file is very similar to most other forms of YAML-based metadata in StackStorm. We have a few fields that describe the rule itself, such as its name, the pack it's in, etc:

```yaml
name: "replace_interface_config"
pack: "napalm"
description: "Watches for interface down events from NAPALM, and sends a configuration snippet to the device to turn the interface back up"
enabled: true
```

Next, all Rules need to reference a Trigger. As mentioned, we want to consume the `napalm.InterfaceDown` triggers we saw in the previous lab on Sensors and Triggers:

```yaml
trigger:
    type: "napalm.InterfaceDown"
```

StackStorm's rules engine will monitor for all incoming trigger instances, and when the specific trigger that's referenced in the Rule shows up, it will take care of activating the next steps.

If you recall from the previous lab, all triggers come with certain properties. Our `napalm.InterfaceDown` trigger contains properties to indicate the `interface` that went down, and the `device` where that interface was located. We can use the optional `criteria` field to further filter what triggers should be handled by this rule. Maybe we want to take different actions based on which interface actually went down. In any case, for the purposes of this lesson, we'll accept all triggers without criteria or filtering, so providing an empty dictionary here is appropriate:

```yaml
criteria: {}
```

Finally, the `action` section tells the Rule what to do when an incoming trigger instance matches the defined trigger type, as well as any defined criteria. This can be a discrete Action, or a Workflow. In our case, we'll just call the `napalm.load_config` action directly to upload our new config to the device.

```yaml
action:
    ref: "napalm.loadconfig"
    parameters:
        hostname: "{{ trigger.device }}"
        config_file: "/antidote/lessons/lesson-15/stage5/interface-up-config.xml"
```

Note that we're making use of the `device` field from the trigger payload in a Jinja snippet, in order to dynamically populate `napalm.loadconfig`'s `hostname` parameter. The [StackStorm docs](https://docs.stackstorm.com/reference/jinja.html) cover the usage of Jinja in Stackstorm in greater detail.

Normally, rules would be located in the `rules/` directory of a pack, but we can also create a rule directly from the command line using our YAML file.

```
st2 rule create replace_interface_config.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 5)">Run this snippet</button>

The tabular output shows us that StackStorm has ingested our new Rule definition and is ready to watch for new trigger-instances. Now that the rule is in place, any new instances of the trigger `napalm.InterfaceDown` will be handled by this rule. In the name of variety, let's trigger an event on `vqfx2`:

```
configure
set interfaces em4 disable
commit
exit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx2', 6)">Run this snippet</button>

As with before, check the `trigger-instance` list until our new instance comes in. Again, this sensor works on a polling basis, so it may take a few seconds. Also note that if you went through the previous lab, our old trigger-instances will still be there, so pay attention to the timestamps.

```
st2 trigger-instance list --trigger=napalm.InterfaceDown
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 7)">Run this snippet</button>

Similar to the relationship between `actions` and `executions`, as well as between `triggers` and `trigger-instances`, a specific instance of a Rule being matched is known as a `rule-enforcement`. Once we see our new `trigger-instance` appear in the previous command, we can list the `rule-enforcements` to make sure this trigger instance was picked up by our new rule:

```
st2 rule-enforcement list
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 8)">Run this snippet</button>

This is a very handy tool for seeing our new Rule in action. If you look at the output, you'll notice that the field `trigger_instance_id` shows the ID of the trigger-instance that was handled by this rule, as well as the  `execution_id` of the action execution that was created.

Remember how we retrieve execution details? `st2 execution get <execution-id>` will get it for us. The below snippet uses a bit of bash-fu to automatically retrieve this:

```
st2 execution get $(st2 execution list --action=napalm.loadconfig | grep napalm | tail -1 | awk '{ print $2}')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 9)">Run this snippet</button>

Looks like our `loadconfig` action executed successfully - we can verify this at the CLI of `vqfx2`:

```
show interfaces em4
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx2', 10)">Run this snippet</button>

That's it for now! To recap:

- Actions and Workflows can be used for performing useful tasks around our network
- Sensors and Triggers help us integrate with external systems, like network devices but also monitoring platforms, to understand when certain events have taken place
- Rules allow us to describe the "if this then that" logic that ties Triggers with Actions and Workflows, so we don't have to execute scripts ourselves anymore - we can commit these decisions as code into Rules.

This was just a taste. In future lessons, we'll explore specific use cases and custom solutions on top of StackStorm.
