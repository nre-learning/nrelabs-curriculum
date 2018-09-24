.. architecture:

Antidote Architecture
================================

.. toctree::
   :maxdepth: 1

   infrastructure.rst
   lessonnetworking.rst
   lessonscheduling.rst


Antidote has multiple layers that build up a cluster, and multiple tools that run or setup each layer.

In general, the Antidote cluster can be thought of like a Kubernetes cluster running many services. This cluster is designed to run atop any cloud IaaS with very few services outside of the cluster (e.g. ingress load balancing). Because we're not using hosted Kubernetes (e.g. GKE), we need to setup the group of virtual machines on which to install Kubernetes before we can even begin. To automate this task and make it multicloud portable, we are using general infrastructure-as-code tooling.

The NRE Labs runtime of Antidote runs on Google Cloud Platform, so we'll use this as a example to illustrate the cluster and stack at a glance.

.. image:: /images/infralayers.png

Now let's overview the tiers that make up Antidote:

+----------------------+--------------+--------------------------------------------------------------------------+
| Infrastructure Tier  | Tool Used    |                              Explanation                                 |
+======================+==============+==========================================================================+
| Cloud Infrastructure | Terraform    | All cloud infrastructure elements (VM instances, DNS entries,            |
|                      |              | load balancers, etc) are defined in Terraform files. This lets           |
|                      |              | us use infrastructure-as-code workflows to quickly                       |
|                      |              | create/delete/change infrastructure elements. Because Terraform is not   |
|                      |              | a cloud DSL, if you want to host Antidote on another cloud, you only     |
|                      |              | need to change the Terraform layer, made simple by Terraform Providers.  |
+----------------------+--------------+--------------------------------------------------------------------------+
| Instance Config      | Ansible      | Once Terraform provisions the cloud VM Linux instances, they need        |
|                      |              | to be configured, such as having dependencies installed, configuration   |
|                      |              | files written, processes restarted, etc. We use an Ansible playbook to   |
|                      |              | initially configure all VM instances, including those that are added to  |
|                      |              | the compute cluster to respond to a scaling event.                       |
+----------------------+--------------+--------------------------------------------------------------------------+
| Container Scheduling | Kubernetes   | Kubernetes orchestrates the services in a container cluster. When we     |
|                      |              | want to provision a resource as part of a lab, we do this by interacting |
|                      |              | with Kubernetes API.                                                     |
+----------------------+--------------+--------------------------------------------------------------------------+
| Lesson Provisioning  | Syringe      | Kubernetes is still fairly low-level for our purposes, and we don't want |
|                      |              | to place the burden on the lab contributor to know how Kubernetes works. |
|                      |              | So we developed a tool called Syringe that ingests a very simple lab     |
|                      |              | definition, and creates the necessary resources in the cluster. It also  |
|                      |              | provides an API for the web front-end (antidote-web) to know how to      |
|                      |              | provision and connect to lab resources.                                  |
+----------------------+--------------+--------------------------------------------------------------------------+
| Web Front-End        | antidote-web | We developed a custom web application based on Apache Tomcat and Apache  |
|                      |              | Guacamole that serves the front end. Guacamole specifically enables an   |
|                      |              | in-browser terminal experience for virtual Linux nodes or network        |
|                      |              | devices in the lab topology. Jupyter notebooks handle stepping through   |
|                      |              | the lab exercise steps.                                                  |
+----------------------+--------------+--------------------------------------------------------------------------+

Antidote provisions and manages Kubernetes as opposed to using a hosted, managed solution like GKE because:

- It needs a custom CNI plugin (multus). GKE doesn't support CNI except for very tightly controlled deployments.
  This means that we can't have multiple interfaces per pod. We tried our best to think of alternatives but the
  tradeoffs were not great. Using multus is really our only option, which means the K8s deployment we're using
  must support CNI.
- Keeping things simple, and using only IaaS makes antidote more portable. You could deploy onto any cloud provider,
  or even on-premises. Initially, antidote was developed on top of GKE and in addition to the other constraints, it wasn't
  possible to keep GKE-specifics from leaking into the logic of the application. So, we're keeping things generic at the infrastructure
  layer, allowing others to pick the foundation that works for them more easily.