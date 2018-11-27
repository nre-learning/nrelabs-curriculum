## Event-Driven Network Automation with StackStorm

---

### Part 2 - Actions

<!-- TODO - there's something missing here - maybe mention their organized according to pack name? But then you'd have to explain packs. Also only having core.local seems like a limited example. Maybe one more? Don't want to make this too bloated since Actions has it's own tutorial, but this just feels weak as-is -->

Though it's important to understand that StackStorm is all about event-driven automation, it's also useful to spend some time talking about what StackStorm can **do**. Being able to watch for all the events in the world isn't very useful if you can't do anything about what you see. In StackStorm, we can accomplish such things through "[Actions](https://docs.stackstorm.com/actions.html)". Some examples include:

- Push a new router configuration
- Restart a service on a server
- Create a virtual machine
- Acknowledge a Nagios / PagerDuty alert
- Bounce a switchport
- Send a message to Slack
- Start a Docker container

There are many others - and the list is growing all the time in the StackStorm [Exchange](https://exchange.stackstorm.org/).

Actions can be thought of simply as neatly contained bits of code to perform a task. They accept input, do work, and usually provide some output.





st2 run core.local -h




We can see the list of actions that are available to us in our freshly-installed StackStorm:

    ubuntu@st2vagrant:~$ st2 action list
    +---------------------------------+---------+------------------------------------------------------------------------------+
    | ref                             | pack    | description                                                                  |
    +---------------------------------+---------+------------------------------------------------------------------------------+
    | chatops.format_execution_result | chatops | Format an execution result for chatops                                       |
    | chatops.post_message            | chatops | Post a message to stream for chatops                                         |
    | chatops.post_result             | chatops | Post an execution result to stream for chatops                               |
    | core.announcement               | core    | Action that broadcasts the announcement to all stream consumers.             |
    | core.http                       | core    | Action that performs an http request.                                        |
    | core.local                      | core    | Action that executes an arbitrary Linux command on the localhost.            |
    | core.local_sudo                 | core    | Action that executes an arbitrary Linux command on the localhost.            |
    | core.noop                       | core    | Action that does nothing                                                     |
    | core.pause                      | core    | Action to pause current thread of workflow/sub-workflow.                     |
    | core.remote                     | core    | Action to execute arbitrary linux command remotely.                          |
    | core.remote_sudo                | core    | Action to execute arbitrary linux command remotely.                          |
    | core.sendmail                   | core    | This sends an email                                                          |
    | core.windows_cmd                | core    | Action to execute arbitrary Windows command remotely.                        |
    | linux.check_loadavg             | linux   | Check CPU Load Average on a Host                                             |
    | linux.check_processes           | linux   | Check Interesting Processes                                                  |
    | linux.cp                        | linux   | Copy file(s)                                                                 |
    | linux.diag_loadavg              | linux   | Diagnostic workflow for high load alert                                      |
    ...(continued)...

Even on a fresh installation, the number of actions available to us is substantial. Since we're learning, let's run one of the very simplest actions available - `core.local`. As the description says, this is an action that "executes an arbitrary Linux command on the localhost".

Executing an action is done with the `st2 run` command:

    st2 run core.local "echo Hello World!"

This particular action is quite simple, and allows us to run it with one positional parameter; namely, the arbitrary linux command we want to run: `echo Hello World!`.

When we run this command, we get some useful output summarizing what just happened:

    ubuntu@st2vagrant:~$     st2 run core.local "echo Hello World!"
    .
    id: 58c09d9fc4da5f3ea6afc9ec
    status: succeeded
    parameters:
      cmd: echo Hello World!
    result:
      failed: false
      return_code: 0
      stderr: ''
      stdout: Hello World!
      succeeded: true

In StackStorm, we use the term "execution" to describe an instance of a running action. Each time we run an action, it's given an execution ID, which is a unique identifier of that exact instance where that action was run. Note the ID in the output above: `58b88644c4da5f2c87ff78ae` - we can use this ID to retrieve this same detail at any time:

    st2 execution get 58c09d9fc4da5f3ea6afc9ec

This is useful because, as we'll see in the next few sections, we don't always run actions on the command-line directly like this. Sometimes it's done for us by a rule, or a workflow. In those cases, retrieving execution details using `st2 execution get` is often the only way to know how an action performed.

We can see a list of recent executions as well:

    st2 execution list

Since we recently installed StackStorm, most of these executions were caused by the installer - but the one we just ran can be found at the bottom:

    ubuntu@st2vagrant:~$ st2 execution list
    +----------------------------+---------------+--------------+-------------------------+--------------------+---------------+
    | id                         | action.ref    | context.user | status                  | start_timestamp    | end_timestamp |
    +----------------------------+---------------+--------------+-------------------------+--------------------+---------------+
    |   58c0998bc4da5f3ea6afc9cb | core.local    | st2admin     | succeeded (0s elapsed)  | Wed, 08 Mar 2017   | Wed, 08 Mar   |
    |                            |               |              |                         | 23:53:47 UTC       | 2017 23:53:47 |
    |                            |               |              |                         |                    | UTC           |
    |   58c0998ec4da5f3ea6afc9ce | core.remote   | st2admin     | succeeded (32s elapsed) | Wed, 08 Mar 2017   | Wed, 08 Mar   |
    |                            |               |              |                         | 23:53:50 UTC       | 2017 23:54:22 |
    |                            |               |              |                         |                    | UTC           |
    | + 58c099afc4da5f3ea6afc9d1 | packs.install | st2admin     | succeeded (12s elapsed) | Wed, 08 Mar 2017   | Wed, 08 Mar   |
    |                            |               |              |                         | 23:54:23 UTC       | 2017 23:54:35 |
    |                            |               |              |                         |                    | UTC           |
    |   58c09d9fc4da5f3ea6afc9ec | core.local    | st2admin     | succeeded (0s elapsed)  | Thu, 09 Mar 2017   | Thu, 09 Mar   |
    |                            |               |              |                         | 00:11:11 UTC       | 2017 00:11:11 |
    |                            |               |              |                         |                    | UTC           |
    +----------------------------+---------------+--------------+-------------------------+--------------------+---------------+

Hopefully at this point, your appetite has been whetted on Actions. We'll explore Actions in much greater detail in a future tutorial.