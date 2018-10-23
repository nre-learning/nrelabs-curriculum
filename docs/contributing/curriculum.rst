.. _contrib-curriculum:

Contributing to the Curriculum
==============================

Thanks for contributing to the Antidote curriculum. Before starting, please read this document in its entirety,
so your work has the maximum impact and your time is best spent.

Look at existing or in-progress content
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Read this document in its entirety

After you have used NRE Labs, know the spirit of it’s break down of workflows as lessons with many quick stages/labs
to progress through, and after you’ve read the quick contributing guide above, then it’s time to dirty your hands.

4. Make a contribution goal for yourself (or anyone else) to fulfill by opening up a new issue with the “curriculum”
label. Make sure you don’t conflict with an existing issue that is open and in progress. If you do conflict, then
simply consider working together.  Here are those existing issues: https://github.com/nre-learning/antidote/issues?q=is%3Aopen+is%3Aissue+label%3Acurriculum
Also make sure you don’t conflict with an existing lesson here: https://github.com/nre-learning/antidote/tree/master/lessons (also look
here to see example of how other lessons are implmented until docs are better)
5. Set off working.





Lessons Should Demonstrate Something Useful
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Lessons in NRE Labs should demonstrate something useful to a network engineer.
For instance, the first lesson is a simple NAPALM based python tool that
collects system information about a target device.

If a user can easily replicate what is shown in the lab so that it can help
them in production, then this would be even better.

Planning Lessons
^^^^^^^^^^^^^^^^^^^^^^

**One-off**

There are multiple ways to build lessons in NRElabs.  The simplest method is
to have single one-off lessons that do not have any direct relationship to
other lessons.

**Repeat**

Some lessons can be repeated 2 or 3 times.  For instance, in addition to the
NAPALM lesson, you could show the user how to collect system information using
an alternate method.  You should explain why a network engineer would want to
choose one method over another.  In the case of the first lesson, NAPALM is a
somewhat limited tool.  If the user needs additional information, they would
need to do something different.  They could use PyEZ, for instance.

**Workflow**

Some lessons could be a group of inter-related tasks.  A troubleshooting
workflow that helps a network engineer locate a device in the network, or the
path between two devices, could be broken up into a set of distinct tasks.
Not every task has to be automated, but some could be, and the lessons could
reflect this.

**Considerations**

There are a number of languages, tools, and libraries/packages that could be
leveraged to build a lesson.  Consider using open-source tools for the lessons,
or tools that are at least free.  This helps ensure that a user could more
easily replicate what is shown in the lesson.





Lesson Details
=================================

The best way to get started building lessons is to get an instance of Antidote
running on your own laptop. Ironing out all of the bugs before you submit a pull
request makes the review process much smoother. For more info, see the
:ref:`local build <buildlocal>` documentation.

You'll also want to get familiar with the :ref:`syringe file <syringefile>` documentation.

**Required lab components**

syringe file
readme for the lab
html layout
Default configs

tabs will be determined via syringefile and rendered from jinja2 template at
build time.

The :ref:`Syringe YAML file <syringefile>` is the main descriptor of a lesson. It is here
that a lesson is defined, it's properties and stages declared, and resources like configs,
scripts, and playbooks referenced.