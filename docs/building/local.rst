.. _buildlocal:

Build and Run Antidote Locally
================================

If you want to contribute some lessons, you'll probably want to find a way to run them locally yourself before opening a pull request. Or maybe you're looking to show some automation demos in an environment that doesn't have internet access (hello federal folks). If any of this describes you, you've come to the right place.

Because Antidote only needs Kubernetes and CNI to run, we don't have to spin up a whole bunch of expensive cloud resources in order to run it on our laptop, either for demonstration or testing purposes. `minikube` is a simple application for running a single-node installation of Kubernetes, pretty much anywhere. With this, and a few scripts, we can get the whole thing running fairly quickly.

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

Next, run this script to automatically spin up Antidote::

    ./anti-up.sh

A few notes on the above:

1. This script will ask you for your `sudo` password. There's nothing sinister here, and you can (should) inspect the script to see that all its doing is making sure there's an entry in your `/etc/hosts` file to point to the minikube IP with the expected hostname.
2. This may take a few minutes, so be patient. However, you should only need to do this once.

You can check the spin up status at anytime using `kubectl get pod`::

    ~$ kubectl get pod

    NAME                                        READY     STATUS              RESTARTS   AGE
    antidote-web-57f98b78d4-7q5mc               0/2       ContainerCreating   0          44s
    nginx-ingress-controller-6f575d4f84-j8n9k   0/1       ContainerCreating   0          46s
    syringe-785f64bbbd-5f6d2                    0/1       Init:0/1            0          45s

... wait a few minutes, then check again, until all pods are running::

    ~$ kubectl get pod

    NAME                                        READY     STATUS    RESTARTS   AGE
    antidote-web-57f98b78d4-7q5mc               1/2       Running   0          7m
    nginx-ingress-controller-6f575d4f84-j8n9k   1/1       Running   0          7m
    syringe-785f64bbbd-5f6d2                    1/1       Running   0          7m

Now you can use minikube commands to list the services and get its URL::

    ~$ minikube service list

    |-------------|---------------|-----------------------------|
    |  NAMESPACE  |     NAME      |             URL             |
    |-------------|---------------|-----------------------------|
    | default     | antidote-web  | No node port                |
    | default     | kubernetes    | No node port                |
    | default     | nginx-ingress | http://192.168.99.101:30002 |
    | default     | syringe       | No node port                |
    | kube-system | kube-dns      | No node port                |
    |-------------|---------------|-----------------------------|

Replace http with https in the URL for nginx-ingress and point your browser to it. For above output,
use https://192.168.99.101:30002 or https://antidote-local:30002 (host entry added to /etc/hosts during spin up).
You'll need to allow an exception for this URL (This connection is Not Private ...) to access.

Iterating on Lessons
--------------------

If you're working on lessons, there's no need to destroy and rebuild the minikube instance. You can deploy changes to your lessons much more quickly.

Syringe, the "behind the scenes orchestrator" of the Antidote project, is responsible for iterating over a series of directories, finding lessons, and presenting them via its API. In order to give Syringe access to these lessons, we need to provide a URL to a git repo where they can be found. Fortunately, this is already done for you in the `syringe.yaml` file of the `antidote-selfmedicate` repository. When you bootstrapped antidote for the first time, Syringe was started, and it automatically pulled down the lessons in the primary Antidote repository.

You, however, likely want to point Syringe at your own repository. So, here are the steps you'll need to take to get your own lessons into the environment.

1. First, commit and push your lessons to a Git repository of your choosing, as long as this repository is accessible by the machine where you're running Antidote.
2. Modify `syringe.yaml` to point to your Git repository, instead of the primary Antidote repository. You will either need to store your lessons in the `lessons/` directory, similar to the primary Antidote repository, or modify the environment variable passed to syringe to point to whatever directory you wish.
3. Use the handy script: `./refreshlessons.sh` to instruct kubernetes to refresh the Syringe deployment. This causes Syringe to re-pull a fresh copy of your Git repository and make it available. Run this any time you've pushed changes to your repository and wish to see them reflected in Antidote.

Basic Sanity Checks
--------------------

In the very near future, Syringe itself will be modified to provide much simpler sanity checks of lessons so that you don't even need to spin all this up to just make sure you've got the basics covered. Stay tuned.
