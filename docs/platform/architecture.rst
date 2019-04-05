.. architecture:

Architecture
================================

Antidote has multiple layers that build up a cluster, and multiple tools that run or setup each layer.

.. image:: /images/antidote_hla.png

Starting from the top down:

Curriculum
^^^^^^^^^^

All of the lessons and labs are defined as a standalone curriculum. The platform underneath is built to
treat this as a modular component. For instance, the :ref:`NRE Labs curriculum <contrib-curriculum>` is certainly the most
popular curriculum currently available, and it's what we are serving via the `NRE Labs <https://labs.networkreliability.engineering>`_
site, but no aspect of this curriculum is baked into the Antidote platform. Other curricula can be developed and run within the antidote
platform.

Platform
^^^^^^^^

This is where the custom software components of Antidote live. In particular, `Syringe <https://github.com/nre-learning/syringe>`_
provides an upstream API for provisioning lesson resources, then makes the relevant calls to Kubernetes to make sure the relevant,
specific compute resources and policies are instantiated. `Antidote-web <https://github.com/nre-learning/antidote-web>`_
consumes the API offered by Syringe and is responsible for providing a fully web-based experience for interacting with lesson resources.


Infrastructure
^^^^^^^^^^^^^^

The :ref:`NRE Labs <contrib-curriculum>` instance of Antidote leverages Google Compute Platform (specifically GCE virtual machines)
due to the availability of hardware-assisted virtualization capabilities, which allows us to run virtual network
devices on the platform without an unacceptable performance penalty. Antidote itself tightly integrates with Kubernetes for
compute orchestration, however, so while Kubernetes is a hard requirement, GCP is not, though a good idea considering the
aforementioned HW virtualization capabilities.

Kubernetes was selected as a common substrate for the Antidote platform for
better portability between cloud providers or on-premises deployments. Aside from performance considerations, the underlying
cloud or bare-metal infrastructure doesn't matter; as long as the Antidote platform is deployed on a Kubernetes cluster, that's
all that matters. The `antidote-ops <https://github.com/nre-learning/antidote-ops>`_ repository
contains the Terraform and Ansible scripts we use to run Antidote in GCP to power NRE Labs.

Why not Hosted Kubernetes?
^^^^^^^^^^^^^^^^^^^^^^^^^^

There are two main constraints we need to solv before moving into something like GKE:

- We need to be able to preserve the HW virtualization capabilities. It's possible to set this flag on the hosts
  used for GKE, but it's not clear how well-supported this is. This warrants further exploration.
- The current networking model uses a CNI plugin to make the lesson networking work. All of the existing
  hosted kubernetes options from the major cloud providers have rather strict networking models and don't let you bring your own CNI plugin.
  See the below section on Lesson Networking for more.

Lesson Networking
^^^^^^^^^^^^^^^^^

Kubernetes provides a lot of great primitives for managing the individual resources that make up a lesson programmatically,
but with one major caveat - the networking model is not very conducive to running network devices. The popular use case for
Kubernetes is to deploy simple applications within containers that have a single network interface, `eth0`.

Since we want to run network devices with multiple network interfaces that are connected together in a dynamic way, we need
to do some creative stuff on the back-end to make things work. This is a part of the design that's still getting worked out,
so the documentation on this will be necessarily light until we have a more solid foundation here. However, the TL;DR
for how things currently work is as follows:

.. image:: /images/lessonsnetworking.png

* Every Kubernetes pod is connected to the "main" network via its ``eth0`` interface. This is nothing new. However, because we're using
  `Multus <https://github.com/intel/multus-cni>`_, we can provision multiple networks for a pod.
* When we schedule lesson resources, we use affinity rules to ensure all of a lessons' resources are scheduled
  onto the same host.
* Depending on the resource type, and the connections described in the :ref:`lesson definition <syringefile>`,
  we may also connect additional interfaces to a pod, connected to other networks.
* Since all pods are on the same host, if we need to connect pods together directly, such as in a specified
  network topology, we can simply create a linux bridge and add the relevant interfaces. In the future, we will do away
  with affinity rules and use overlay networking instead of the simple linux bridge.
* For security reasons, network access outside the lesson namespace is disabled.
  All lessons should be totally self-contained and not rely on external resources to properly function
  when the lesson is being run.

NetworkServiceMesh is an alternative to Multus that may allow us to accomplish the same goal of running multiple network interfaces
out of a pod, but without the requirement of using a custom CNI plugin. It also doesn't directly integrate with whatever CNI
plugin IS in use (we ran into some issues with Weave+Multus, which is why we use linux bridges and therefore host affinities).
Further exploration is needed, but if NSM satisfies performance and scale considerations, we're seriously considering moving to it.

DNS in Antidote is `provided by Kubernetes <https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/>`_.
So, if you want to reach vqfx1, simply query for `vqfx1`. You will be directed to the
correponding service in your namespace. Note that each lesson + session combination gets its own namespace, which means
``vqfx1`` is locally significant to your lesson specifically.

