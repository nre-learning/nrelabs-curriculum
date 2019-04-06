.. _curriculum-tips:

Tips and FAQs
=============

Snippet Indices
~~~~~~~~~~~~~~~
Currently, in order to add a "Run this snippet" button underneath a code snippet, you need to add some HTML underneath
each snippet, containing the 0-based index that the snippet takes within the document:

.. code::

    ```
    echo "Hello, World!"
    ```
    <button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

It's very important to get that index right. If this button is meant to run the very first snippet, use index 0. For the second
snippet, use 1, and so on. This is true regardless of whether or not some of your snippets don't have buttons. If you skip
adding a button to a snippet, you must equally increment the index that's used for your next button.

We realize this is a bit of a pain, and we're currently exploring ways to make this easier for you.


Newlines at the end of snippets
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
When you're adding a snippet to a lesson guide, sometimes you may want an extra newline run at the end.
For example, if you are executing some Python code, and your snippet ends on a loop, or a conditional,
you need an extra newline to get the interpreter to understand you're done defining the loop.

The solution to this is to use ``<pre>`` tags in lieu of the traditional triple-backtick for embedding
code in Markdown. For instance, instead of this:

.. code::

    ```
        (code)
    ```

Do this:

.. code::

    <pre>
        (code)
    </pre>

These are rendered exactly the same way in the lesson guide, but the latter is interpreted much more literally
when being pasted into the terminal window, meaning the extra newline is executed like any other character.

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

How can I stand up a development environment to test my curriculum contributions?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



How the hell are you running network devices in this thing?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Point to architecture

Why only Junos?
~~~~~~~~~~~~~~~
There's no architectural restriction against running other images. The only requirement is that the network device is accessible via SSH
for terminal access with the appropriate credentials. We're already using NAPALM for doing inter-stage configuration, so we're ready to use
other vendor kit from the get-go; it's a matter of getting vendors to contribute their image. Juniper has done this as an early example,
but any other vendor that is willing to abide by the NRE Labs Accords (LINK) is welcome to participate in the project.

How do I get my "stuff" into a lesson?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Almost always, it's a matter of just putting it in your lesson directory. The entire curriculum is mapped via volume
to every container that runs in a lesson, so just by having those files in that directory, you'll have access to them at runtime.

You can also create a docker image that follows the `image` (LINK) standards if you want a more complicated software installation to
be present.







# David Barosso Questions
1. is there more detailed documentation somewhere?
3. if I add a lesson, should I just number it and put it here? github.com/nre-learning/a…



Things from Dmitri Figol stream to fix
- Copy/paste from lesson guide
- Fix random disconnects after idling for a while
- Copying from robot file out of terminal strips newlines
- Install browser in utility so you can browse the report
- Consider disabling right click?
- Expand grafana iframe
- unexpected session close
- order of snippets in lab 2 of st2 lesson

