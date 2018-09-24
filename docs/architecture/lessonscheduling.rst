Lab Scheduling
================================

talk about the strange, not quote canonical way we're using k8s for lab scheduling. Syringe, multus, weave, etc.

Talk about isolation

What is a Lab?
---------------

When a user logs in to the NRE Labs portal to access an exercise, a variety of provisioning activities happen
automatically on the back-end. A big portion of this is defining and scheduling kubernetes resources to support that exercise.

We need `Pods <https://kubernetes.io/docs/concepts/workloads/pods/pod/>`_ to run the container images for our network devices, Jupyter notebooks, and anything else
required by the exercise. We need `Services <https://kubernetes.io/docs/concepts/services-networking/service/>`_ to make those Pods accessible to the outside world, so that
the web front-end knows where to connect to those resources. Finally, we also need to define several Network objects, which is a
`Custom Resource Definition <https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/>`_ we define in Antidote so we can provide more
granular network topologies between our Pods.

To put this under a nice umbrella term so we can more readily refer to these resources as a single cohesive unit that serves a given exercise, we're simply calling this
a "lab".

.. image:: /images/labexample.png

Note that this is what's required for a single user to use a single lab. If multiple users are using this lab, then multiple instances of this same topology will be spun up in parallel,
in isolation from each other. In addition, this is just the lab layout for this particular exercise. Other exercises will leverage a slightly different lab definition, and will likely
have multiple instances of that running in a given moment as well based on usage.

NOTE - orchestrating all of these resources is done by syringe - see this page (LINK) for more details
