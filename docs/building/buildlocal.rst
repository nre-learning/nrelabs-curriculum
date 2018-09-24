.. _buildlocal:

Build and Run Antidote Locally
================================

Because Antidote only needs Kubernetes and CNI to run, we don't have to spin up a whole bunch of expensive cloud resources in order to run it on our laptop, either for demonstration or testing purposes. For instance, if you want to contribute some lessons, you'll probably want to iterate on them yourself before opening a pull request. Or maybe you're looking to show some automation demos in an environment that doesn't have internet access (hello federal folks). If any of this describes you, you've come to the right place.

.. note::  Currently, the scripts for running Antidote on minikube are Mac or Linux only. However, minikube does support Windows, so it shouldn't take too much work to get it working. PRs welcome!

Install and Configure Dependencies
----------------------------------

First, you'll need minikube. This is by far the easiest way to get a working instance of Kubernetes running on your laptop. Follow the `installation instructions <https://kubernetes.io/docs/tasks/tools/install-minikube/>`_ and confirm you have things working with `kubectl get nodes`. You should see something like this::

    ~$ kubectl get nodes
    
    NAME       STATUS    ROLES     AGE       VERSION
    minikube   Ready     <none>    7h        v1.8.0

If you see something like this, you should be ready to go to the next section, as everything else is executed via a shell script. However, if you are curious, more comprehensive minikube documentation is available `here <https://kubernetes.io/docs/setup/minikube/>`_. 


Bootstrap Antidote
------------------

All of the scripts and kubernetes manifests for running Antidote within minikube are located in the `antidote-selfmedicate <https://github.com/nre-learning/antidote-selfmedicate>`_ repository. Clone and enter this repository::

    git clone https://github.com/nre-learning/antidote-selfmedicate
    cd antidote-selfmedicate

Next,


Iterating on Lessons
--------------------

If you're working on lessons, there's no need to destroy and rebuild the minikube instance. You can deploy changes to your lessons much more quickly.

1. Commit and push your changes to any git repo that can be accessed by your machine, and make sure this URL is present in <FILE>
2. Syringe will pull a fresh copy of this repository whenever it starts, so you can run <THIS COMMAND> to force syringe to re-deploy itself, and pull down your changes.