.. _contrib-lifecycle:

The Curriculum Contribution Lifecycle
=====================================

Contributing to the curriculum is fairly straightforward, but you should consider the guidance
in this document to ensure you spend your time wisely.

.. NOTE::

    Contributions of any kind are welcome. New lessons are cool, but so are modifications, additions,
    or even minor fixes to existing content. No contribution is too small!

Contributing to the NRE Labs Curriculum should follow a four-step lifecycle. This ensures that lesson
quality remains high and contributors' time is not wasted.

.. image:: /images/lifecycle.png
   :scale: 90 %
   :align: center

Step 1 - Ask Around!
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The NRE Labs Curriculum should be treated like any other open source project.
It's built via contributions from all over the world, all the time. So, the very first thing you should do
is get a lay of the land. First, peruse the `existing curriculum
issues <https://github.com/nre-learning/nrelabs-curriculum/issues>`_ to see
if anyone is already working on something similar to what you have in mind.

If not, please first `open an issue <https://github.com/nre-learning/nrelabs-curriculum/issues/new>`_
so the community can have a chance to provide feedback on your idea before you spend time building it. There's a chance
that something already exists, or maybe someone else is planning to work on it, and evangelizing your idea first
gives you an opportunity to combine forces with these existing efforts if they exist. A single lesson that covers
all the bases is way better than two similar lessons that have overlap and confuse the learner.

Step 2 - Plan It Out
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Even if you have determined that no one else is working on the thing you want to work on,
it's still a good idea to build a general outline of the lesson you want to build and solicit
feedback from the maintainers and contributors to NRE Labs.

If you haven't `opened an issue <https://github.com/nre-learning/nrelabs-curriculum/issues/new>`_ yet,
it's still recommended you do so. Use this as a way to
provide an outline to the community, as well as yourself, of the lesson you have in mind. Provide
as much detail as you can, listing the various topics you want to cover, how long each lab/stage
is expected to take, what kind of new software will need to be brought into the curriculum, etc.

This gives other community members a chance to review your plan and maybe address any concerns ahead of
time, saving you a lot of headache in the long-term.

Here are some tips for a great lesson:

* Lessons in NRE Labs should demonstrate something that a network engineer could easily replicate
  in their own environment. Topics we teach here should be aimed at getting the learner skilled up enough
  to actually put these concepts into production. So, the more practical the better.
* Individual labs within a lesson should be kept to a reasonable length. The general rule of thumb is that
  a single lab can be finished in about 5 minutes. A lab that is too short, and the learner will feel like they're not
  learning a lot. Too long and the learner won't feel like they're accomplishing anything. So, within a single lesson,
  be very intentional with how you're breaking content up into different labs.
* Some lessons can be repeated 2 or 3 times.  For instance, in addition to the
  NAPALM lesson, you could show the user how to collect system information using
  an alternate method.  You should explain why a network engineer would want to
  choose one method over another.  In the case of the first lesson, NAPALM is a
  somewhat limited tool.  If the user needs additional information, they would
  need to do something different.  They could use PyEZ, for instance.
* Some lessons could be a group of inter-related tasks.  A troubleshooting
  workflow that helps a network engineer locate a device in the network, or the
  path between two devices, could be broken up into a set of distinct tasks.
  Not every task has to be automated, but some could be, and the lessons could
  reflect this.

Step 3 - Put It Together
^^^^^^^^^^^^^^^^^^^^^^^^

Okay. You've determined that you have a good idea for a lesson, and no one else is working on it.
Let's get you started!

As is common on Github-based projects, direct commit access to the main NRE Labs curriculum repository is
not permitted. To be able to commit new or modified curriculum content, you first need to
`fork the NRE Labs curriculum repository. <https://github.com/nre-learning/nrelabs-curriculum/fork>`_ 
This allows you to create a copy of the curriculum at a location of your choosing (usually underneath your 
own Github username) that you have permissions to push to. Once you have your fork, you can clone from there
and start making commits as you add or change lesson content.

Next - you'll want a local copy of the Antidote stack running locally so you can rapidly test and
iterate on the changes you've made. Ironing out all of the bugs locally before you submit a pull
request makes the review process much smoother. For more info, see the
:ref:`local build <buildlocal>` documentation.

Next thing you'll want to bookmark is the documentation on :ref:`lesson definitions <lessondef>`.
All lessons are defined "as-code", meaning they are all defined using simple text files stored in Git.
This documentation is vital for knowing what kind of things you can use to create an awesome lesson,
so read that carefully, and follow the instructions there, whether you're creating a new lesson, or
modifying an existing one.

At this point, you're ready to make the changes to your copy of the NRE Labs curriculum. Make commits, and
push them to your fork as you see fit. Try to keep commit messages relevant and descriptive.

Step 4 - Get It Reviewed and Merged
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Eventually, you'll arrive at the point where the content you're able to see in your local copy of Antidote
looks like it's ready for prime time. You've made all the changes you plan to make, and you've added them to
your fork via pushed commits. At this point, you're ready to
`open a pull request <https://github.com/nre-learning/nrelabs-curriculum/pull/new>`_ (PR).

The link above will prompt you to specify your fork and branch you wish to "pull from" into the main NRE Labs
curriculum. Select the appropriate fork and branch, and then fill out the description for the pull request.
If you are opening this PR in response to an issue (whether you opened it or not) and you feel it addresses
everything in that issue, you can say ``Closes <insert link to issue here>`` in your description, and when
the PR is merged, the referenced issue(s) will be closed automatically.

At this point, the next step is for a reviewer to approve or make suggestions for a second round of edits
for your content. Note that the goal for **each and every review** is not to nitpick or make it difficult to
contribute to NRE Labs, but rather to ensure the content is reflected in the best light possible. Be patient
and willing to adapt to feedback.

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
- Does this follow the :ref:`Lesson Image Requirements <lessonimages>`?
- Is the business benefit clear from this lesson? How easy is it for people to link this content with their day-to-day?
