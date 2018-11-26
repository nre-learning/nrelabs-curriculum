.. _release:

Antidote Release Process
================================

The Antidote project is composed of three primary Github repositories:

- `Antidote <https://github.com/nre-learning/antidote>`_ - contains infrastructure
  and platform configurations, as well as the codified lesson definitons.
- `Syringe <https://github.com/nre-learning/syringe>`_ - contains code for the
  back-end orchestrator between Kubernetes and the front-end
- `Antidote-web <https://github.com/nre-learning/antidote-web>`_ - contains code
  for the front-end web application.

Each of these repositories maintain semantic versioning whenever a new release comes out, and they're released
in sync with each other. For instance, when `0.1.3 <https://github.com/nre-learning/antidote/releases/tag/0.1.3>`_
came out, this version was created for each of these
projects, and each project is intended to be deployed together at the same version.

There's no pre-determined schedule for releases. Generally we try to do a release every two weeks or so, but this is a guideline. This could
vary based on conflicts with holidays, or based on incoming changes to any of the projects in Antidote.

The `antidote-ops <https://github.com/nre-learning/antidote-ops>`_ repository is a
`StackStorm <https://github.com/StackStorm/st2>`_ pack for managing Antidote in production, including workflows
for creating release branches/tags in Git, uploading tagged Docker images to Dockerhub, and deploying
versions of the software to Kubernetes.

Whenever a new release is created, the CHANGELOG notes from each project is summarized underneath the
corresponding `Antidote release notes <https://github.com/nre-learning/antidote/releases>`_ for that release. Stay tuned to that link
as well as the `NRE blog <https://networkreliability.engineering>`_ for updates there.

Once a release is created, it's first deployed to the ptr_ . This is a sibling site to the main production instance where
new features and content can be tested before making it live to the production site. Generally, releases are deployed to the PTR as soon as they're available.
They'll be tested there for at least a few days, and as long as there aren't any serious issues, the live site will also be updated to this version a few days later.

.. _ptr:

NRE Labs' "Public Test Realm"
-----------------------------

The "production" runtime of NRE Labs is located at
`https://labs.networkreliability.engineering/ <https://labs.networkreliability.engineering/>`_.
It is considered to be mostly stable (though still tech preview for now).
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
