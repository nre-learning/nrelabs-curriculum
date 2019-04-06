.. antidote documentation master file

Introduction to Antidote
========================

.. image:: /images/antidote.png
   :scale: 80 %
   :align: center

.. toctree::
   :maxdepth: 1
   :caption: Contents:

   platform/index.rst
   building/building.rst
   contribute-nrelabs/index.rst
   contribute-antidote/index.rst
   releases/index.rst
   community.rst

Antidote is a community initiatve to democratize interactive, dependency-free learning.
With Antidote, you can create compelling, interactive learning experiences by building
turnkey lesson materials that are fully browser-based, placing minimal burden on the
learner to come with pre-requisite knowledge or environment configurations.

The Antidote project is composed of a set of open source software applications
that work together to provide this learning experience. 
The `antidote-selfmedicate <https://github.com/nre-learning/antidote-selfmedicate>`_ repository is the simplest way to get this going, as it's,
designed to allow you to run everything on your laptop, using `minikube`. This is very useful if you're looking to develop some lessons
and need an easy way to test them out without a lot of setup. See the :ref:`build local <buildlocal>` instructions for more info on that.

In case you're looking to run Antidote in more of a public-facing, production capacity, the main `Antidote
repository <https://github.com/nre-learning/antidote>`_ contains terraform configurations, kubernetes manifests,
and scripts necessary for running all of Antidote's components in the cloud. More information for spinning this up can be found in the :ref:`production <production>` guide.

In fact, the reference runtime and use case for Antidote is
:ref:`NRE Labs <contrib-curriculum>` and Antidote is the project behind it. NRE Labs is
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

:ref:`Contributions <contrib-curriculum>` are welcome.

*Please note that NRE Labs is currently in limited tech preview.*
