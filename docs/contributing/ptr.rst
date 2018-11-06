.. _ptr:

NRE Labs' "Public Test Realm"
================================

`https://labs.networkreliability.engineering/ <https://labs.networkreliability.engineering/>`_ is the "production"
runtime of NRE Labs. It is considered to be mostly stable (though still tech preview for now).
It's deployed using tagged versions of git repositories and docker images, and goes through a decent amount
of regular testing, as well as far fewer changes than the underlying ``antidote`` software projects.

However, there's a version of NRE Labs that is deployed every time a change to `master` is detected
on one of Antidote's repositories, called the "public test realm". It's located at:
`https://ptr.labs.networkreliability.engineering/ <https://ptr.labs.networkreliability.engineering/>`_.

The NRE Labs PTR will be quite similar to the "production" copy, but there are a few
important differences to discuss:

* Everything is deployed via ``master`` or the current release branch, and is inherently unstable.
  We will try to keep things working, but it **is** a test realm. There be dragons here.
* All lessons in the ``antidote`` repository are shown, despite the `disabled` property in the
  syringe file.
* A black bar with the latest commit ID for all three projects (``antidote``, ``antidote-web``, 
  ``syringe``) is shown at the bottom of each page.

The goal with the PTR is to make it easier to test release candidates for Antidote.
Once the PTR has the changes we want in the next release, and we've put it through some testing, we can more confidently
release the next version. It will also help contributors see their changes more quickly, rather than
waiting for a release. Finally, it also gives users a chance to see upcoming lessons, and provide early feedback.
