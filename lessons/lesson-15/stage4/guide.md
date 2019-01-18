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

https://github.com/StackStorm/st2

TBD
```

```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>