# Contributing lessons to NRElabs

## Lessons Should Demonstrate Something Useful

Lessons in NRElabs should demonstrate something useful to a network engineer.  For instance, the first lesson is a simple NAPALM based python tool that collects system information about a target device.

If a user can easily replicate what is shown in the lab so that it can help them in production, then this would be even better.

## Planning Lessons

### One-off

There are multiple ways to build lessons in NRElabs.  The simplest method is to have single "one-off" lessons that do not have any direct relationship to other lessons.

### Repeat

Some lessons can be repeated 2 or 3 times.  For instance, in addition to the NAPALM lesson, you could show the user how to collect system information using an alternate method.  You should explain why a network engineer would want to choose one method over another.  In the case of the first lesson, NAPALM is a somewhat limited tool.  If the user needs additional information, they would need to do something different.  They could use PyEZ, for instance.

### Workflow

Some lessons could be a group of inter-related tasks.  A troubleshooting workflow that helps a network engineer locate a device in the network, or the path between two devices, could be broken up into a set of distinct tasks.  Not every task has to be automated, but some could be, and the lessons could reflect this.

### Considerations

There are a number of languages, tools, and libraries/packages that could be leveraged to build a lesson.  Consider using open-source tools for the lessons, or tools that are at least free.  This helps ensure that a user could more easily replicate what is shown in the lesson.
