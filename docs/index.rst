.. antidote documentation master file

Introduction to Antidote
========================

.. toctree::
   :maxdepth: 1
   :caption: Contents:

   architecture.rst
   platform/index.rst
   building/building.rst
   contributing/index.rst
   roadmap.rst
   nrelabs.rst
   community.rst

Antidote is a community initiatve to democratize interactive, dependency-free learning.
With Antidote, you can create compelling, interactive learning experiences by building
turnkey lesson materials that are fully browser-based, placing minimal burden on the
learner to come with pre-requisite knowledge or environment configurations.

Antidote is composed of a set of is an open-source project aimed at making
automated network operations more accessible with fast, easy and fun learning.
It teaches from-scratch network automation skills for network reliability engineers
(NREs) and other NetOps pros or amateurs.

Antidote isn't just one application, but rather, a set of smaller applications
that work together to provide this learning experience. 
The `antidote-selfmedicate <https://github.com/nre-learning/antidote-selfmedicate>`_ repository is the simplest way to get this going, as it's,
designed to allow you to run everything on your laptop, using `minikube`. This is very useful if you're looking to develop some lessons
and need an easy way to test them out without a lot of setup. See the :ref:`build local <buildlocal>` instructions for more info on that.

In case you're looking to run Antidote in more of a public-facing, production capacity, the main `Antidote
repository <https://github.com/nre-learning/antidote>`_ contains terraform configurations, kubernetes manifests,
and scripts necessary for running all of Antidote's components in the cloud. More information for spinning this up can be found in the :ref:`production <production>` guide.

In fact, the reference runtime and use case for Antidote is
:ref:`NRE Labs <nrelabs>` and Antidote is the project behind it. NRE Labs is
a free site and training service on the web sponsored by Juniper Networks, but
anyone interested can run their own copy of Antidote.

Often the first step to learning about network automation is the hardest:
you need to setup complex virtual environments, labs, or worse risk
experimenting in production. NRE Labs was built to teach skills right in your
web browser and let you deal with real tools, code and network devices.

What's more is that often at the outset of the network automation journey,
when one thinks about what to automate, the answer is “the network!” But
specifics about workflows are prerequisite to automating them. That's why the
community here has created lessons and labs with real-life NetOps workflows.
And everything you see and use is applicable and open for you to use back in
your own environments.

:ref:`Contributions <contrib>` are welcome.

*Please note that NRE Labs is currently in limited tech preview.*

`Join the community on our Slack space and channel #nre_labs <https://join.slack.com/t/juniperautomators/shared_invite/enQtMzU3NDI2MTA5NDc2LTg0MTdmNDk5NTM3OTI4NjVmODk5OTFiMzcyNTk3ZTY1NWIxNTVlNjNhNzc2NjI1NDMwODgxMzU5YjNhNjA3MjI>`_

