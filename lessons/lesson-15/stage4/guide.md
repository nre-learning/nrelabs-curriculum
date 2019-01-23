## Event-Driven Network Automation with StackStorm

---

### Part 4 - Sensors and Triggers

So far, we've seen a few options for "doing work" in StackStorm. That is, `Actions` give us a way of performing a simple, singular task, supporting both input parameters as well as output variables. We saw the myriad of `Workflow` options that allow us to create complex logical flows between multiple actions, to make more advanced decisions aimed at accomplishing a greater goal.

However, this lesson uses the term "Event-Driven Automation", and it's important that we learn how to take these concepts - many of which we know from other tools - 
and begin to combine them with the event-driven primitives in StackStorm to allow us to perform this automation in an **autonomous** way. In other words, we don't
want to just define **what** to do, we also want to define **when** to do it, so we aren't on the hook for executing scripts and workflows ourselves. We can describe the scenarios in which we would want these workflows to be executed, and StackStorm will take care of executing them on our behalf when those events take place.

#### Sensors

In order for StackStorm to know when a certain "event" has taken place, it needs to have some kind of process for gathering data about other systems or processes. It needs a mechanism for gathering "raw" data, so that it can make a decision about when that data represents something meaningful - an "event".

StackStorm uses something called `sensors` to do this. These are little bits of Python code that run as separate processes within StackStorm.

As with everything else, Sensors are distributed within Packs. We can run the following command to see the list of sensors in the `napalm` pack:

```
st2 sensor list --pack=napalm
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 0)">Run this snippet</button>

Of particular interest for this lab is the `napalm.InterfaceSensor`, which as described, is a sensor that polls network devices for interface up/down events. This sounds awesome, but how is it actually *done*?

The following `get` command gives us a clue:

```
st2 sensor get napalm.InterfaceSensor
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 1)">Run this snippet</button>

Here, we see a lot more detail about this sensor, including the field `artifact_uri`, which is an absolute path to the actual Python code running this sensor. The contents of this Sensor is a bit beyond the scope of this lesson, but if you're curious, [the documentation](https://docs.stackstorm.com/sensors.html#creating-a-sensor) on creating a Sensor is really good, and it's a really good idea to have that up in another tab while perusing the contents of the Sensor code provided in the command below:

```
cat /opt/stackstorm/packs/napalm/sensors/interface_sensor.py
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 2)">Run this snippet</button>

How did StackStorm know about this Python code? Every Sensor, like many things in StackStorm, is comprised of two components. A script file - which is what was referenced in the output above - and a metadata YAML file, which describes things like where to find the script file, and other useful metadata:

```
cat /opt/stackstorm/packs/napalm/sensors/interface_sensor.yaml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 3)">Run this snippet</button>

#### Triggers

It's impossible to talk about Sensors in StackStorm without talking about Triggers. In fact, Sensors would have no point in existing if it wasn't for Triggers. You can think of Sensors as a bit of fairly self-contained code for constantly bringing in information about some external entity or system.

It is up to the Sensor to determine if the information being brought in is *actionable*. For instance, our `napalm.InterfaceSensor` periodically polls our network devices for interface information. If nothing changes with respect to our network device's interfaces, no meaningful event has taken place. However, if we disabled an interface, the next time our Sensor polled that device, it would notice a change, and it's time to notify StackStorm that this meaningful event has taken place. This notification is called a *Trigger*.

Each Sensor is responsible not only for deciding when to fire a Trigger, but also to register all possible triggers by declaring them in the Sensor's metadata file (you may have noticed this in the previous output).

Similar to what we did with Sensors, we can list all registered Triggers in the NAPALM pack like so:

```
st2 trigger list --pack=napalm
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 4)">Run this snippet</button>

In this output, we see that there are two triggers related to interfaces, `napalm.InterfaceDown` and `napalm.InterfaceUp`. Drilling into the `InterfaceDown` trigger specifically:

```
st2 trigger get napalm.InterfaceDown
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 5)">Run this snippet</button>

We can see that triggers have properties. This one has two string properties, `device` and `interface`. We'll see those in action shortly, and especially in the next lab.

This is all great, but how do we know when an event has actually taken place - that is, when a trigger has been fired? For this, we use a slightly different term, the `trigger-instance`. This is a special resource type within StackStorm that represents a discrete instance of a trigger being fired by a Sensor. Each time a Trigger is fired by a Sensor, a new `trigger-instance` is created for that point in time. This is very similar to the relationship between Actions and Executions. An Action is a type of task that can be performed in StackStorm - an Execution is an instance of that Action actually taking place at a point in time.

We can see the list of `trigger-instances` using the command you have probably already anticipated by now (the st2 CLI is comfortably predictable), but let's add a special flag to limit the scope to the trigger we want:

```
st2 trigger-instance list --trigger=napalm.InterfaceDown
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('st2', 6)">Run this snippet</button>

Huh - an empty list? Well, this makes sense, doesn't it? Our Sensor has been busy collecting data, but that data hasn't shown any changes, and no meaningful event has taken place, deserving of a Trigger. Let's cause one. :)

```
configure
set interfaces em4 disable
commit
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', 7)">Run this snippet</button>

Let's see if we've been able to get a Trigger to fire. Note that this interface data is obtained by polling periodically,
so you may have to run the following command a few times before it shows up:

```
st2 trigger-instance list --trigger=napalm.InterfaceDown
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', 8)">Run this snippet</button>

Once we see a trigger-instance show up in the list, we can use the command `st2 trigger-instance get <trigger-instance-id>` (similar to what we did in a previous lesson with execution IDs) to view details about this trigger instance.
Or if you're feeling lucky, you could use the below command with some bash-fu to get it for you :)

```
st2 trigger-instance get $(st2 trigger-instance list --trigger=napalm.InterfaceDown | grep napalm | head -1 | awk '{ print $2}')
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', 9)">Run this snippet</button>

Remember those fields from earlier - `device` and `interface`? Those are filled out now, with the device and interface that we changed to create the event. These fields can now be passed on to other entities in StackStorm, like Rules, to drive very powerful, autonomous decision-making. Check out the next lab in this lesson for more on that!
