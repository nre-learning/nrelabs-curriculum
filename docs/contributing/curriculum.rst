.. _contrib-curriculum:

Contributing to the Curriculum
==============================

Thanks for contributing to the Antidote curriculum. Before starting your work, please read this
document in its entirety, so your work has the maximum impact and your time is best spent.

Step 1 - Ask Around!
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Antidote is still in tech preview, so there is a lot of work going on all the time. Before you get
started, make sure you don’t conflict with any existing or current work! 

The first step is to peruse the `existing curriculum
issues <https://github.com/nre-learning/antidote/issues?q=is%3Aopen+is%3Aissue+label%3Acurriculum>`_.
If someone's already working on something related to the curriculum, there's a good chance that
there will be an issue there. If not, please first `open an issue <https://github.com/nre-learning/antidote/issues/new>`_
so the community can have a chance to provide feedback on your idea before you spend time building it. There's a chance
that something already exists, or maybe someone else is planning to work on it, and evangelizing your idea first
gives you an opportunity to combine forces with these existing efforts if they exist.

Once you feel like you've gotten good feedback, and you have a good plan in place, read the following section for some
guidelines on how to write a really awesome lesson.

Step 2 - Plan It Out
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Lessons in NRE Labs should demonstrate something useful to a network engineer.
For instance, the first lesson is a simple NAPALM based python tool that
collects system information about a target device.

If a user can easily replicate what is shown in the lab so that it can help
them in production, then this would be even better.

There are multiple ways to build lessons in Antidote.  

**One-off**

The simplest method is to have single one-off lessons that do not have any direct relationship to
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

Step 3 - Put It Together
^^^^^^^^^^^^^^^^^^^^^^^^

Okay. You've determined that you have a good idea for a lesson, and no one else is working on it.
Let's get you started!

The best ally to have when buliding lessons is a local instance of Antidote
running on your own laptop. Ironing out all of the bugs locally before you submit a pull
request makes the review process much smoother. For more info, see the
:ref:`local build <buildlocal>` documentation.

Once you're ready to start building a lesson, you'll need to create a :ref:`syringe.yaml file<syringefile>`.
This is the primary metadata file for a lesson, and it's here where we declare the attributes (such as the
name of the lesson and what course it belongs to), what resources the lesson needs, and how they connect to
each other (if applicable).

.. note::
    It's very important to get the ``syringe.yaml`` file right, because it's so central to the
    definition of a lesson. Please refer to the :ref:`syringe.yaml docs <syringefile>` for detailed
    documentation on this file.

This is really the only "required" file for a lesson, but in order to be useful, the ``syringe.yaml`` file will
need to refer to other files like configs, markdown files, and more, in order to be useful. 
Take a look at the `existing lessons <https://github.com/nre-learning/antidote/tree/master/lessons>`_ and see
how those lessons are laid out. What you'll need in your lesson directory will vary wildly, depending on the
contents of your ``syringe.yaml`` file.

Step 4 - Get It Reviewed
^^^^^^^^^^^^^^^^^^^^^^^^

Once you've got your changes together, and pushed to a branch of your own (i.e. in a fork of the Antidote repo),
`open a pull request <https://github.com/nre-learning/antidote/pull/new>`_.

Here are a few things that reviewers should be on the lookout for when reviewing new contributions to the
curriculum, either for new or existing lessons. If you're contributing to the curriculum, you should be aware
of these guidelines, to make the review process much smoother.

- Can a user get through a lesson stage quickly? Are we letting them get to a quick win as soon as practical while still teaching quality content?
- Does the new or changed lesson adhere to the spirit of Antidote lessons laid out in this document?
- For new lessons, does the lesson guide (or jupyter notebook if applicable) look nice? Does the author attribute themselves?
- Is the lesson guide(s) easy to follow?
- Are any documentation updates also needed?
- Is the CHANGELOG updated properly?
- Can we show this in NRE labs? Usage rights?
- Is the business benefit clear from this lesson? How easy is it for people to link this content with their day-to-day?

Appendix - Lesson Contribution FAQ
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**NAPALM Can't Find My Configs.**
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This is likely due to the way you've deployed syringe.

In the selfmedicate repo, there are a number of kubernetes manifests useful for running antidote locally.
However, there are some defaults here you'll likely want to change. In particular, if you're making lesson
changes in a branch or fork (which is ideal if you want to open a PR) you will want to make sure you update
the syringe deployment in two places:

- The init-container definition, where the ``antidote`` repo
  is cloned into the syringe pod
- Syringe's ``SYRINGE_LESSON_REPO_REMOTE`` and ``SYRINGE_LESSON_REPO_BRANCH``
  environment variables.

Be sure to re-deploy syringe using ``kubectl apply -f syringe.yaml`` once you've made the appropriate changes.
If you've already made these changes and it still doesn't work, make sure syringe is using the latest copy
of your repo by deleting the syringe pod. The Syringe deployment will re-deploy a new pod with a freshly-cloned
version of your lesson repo.
