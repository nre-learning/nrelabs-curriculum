.. _contrib:

.. toctree::
   :maxdepth: 1

   contributelesson.rst

Please use the menu above to get to the relevant instructions for how you're trying to build Antidote.


Contributing to Antidote
================================

In general, there are two area in which to contribute: Antidote infrastructure
and into the curriculum of Lessons. Lessons contributions are expected to be
the most common, and the community is striving to abstract the infrastructure
well enough that no software or platform engineering complexities are
involved in creating lessons.

:ref:`Skip to code contribution <contrib-code>` guidelines, if you're not
contributing to the learning curriculum.

Contributing Lessons and Labs
------------------------------

Before setting off contributing, you should have used NRE Labs and have an idea
about the user experience desired if you wish to have your work considered to
be published there. Furthermore, you should read about the
project's curriculum :ref:`taxonomy <nrelabs>`. And in order to test your
contributions before submitting a pull request to the project, it is helpful to
run an instance of Antidote yourself and test your changes. 

This document is meant to convey the spirit of the ideal contribution to Antidote.
Please read on, as it will make the review process much easier. When you're ready
to begin working on a lesson, go on to :ref:`Contributing a Lesson <contriblesson>`
for the technical details.

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


**Required lab components**

syringe file
readme for the lab
html layout
Default configs

tabs will be determined via syringefile and rendered from jinja2 template at
build time.


.. _contrib-code:

Contributing to Antidote Member Projects
----------------------------------------

If you want to propose a change to Antidote, Syringe, Antidote-web, or any other member project,
contributions are welcome! Just be patient, as these components are still not considered quite stable, so you
should reach out to the maintainers before getting too deep into the weeds on a change, so you don't waste your time.
