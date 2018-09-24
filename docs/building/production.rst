.. _production:

Deploying Antidote into Production
==================================

This is NOT the guide for running a local instance of Antidote. That can be found in the :ref:`build local instructions <buildlocal>`. These instructions are if you wish to leverage the Terraform and Ansible scripts to get a production-quality instance of Antidote running in the cloud.

Prerequisites
-------------

- Git
- Terraform
- Ansible

Infrastructure Setup
--------------------

Follow `the instructions for installing the Google Cloud SDK <https://cloud.google.com/sdk/gcloud/>`_, and then run these commands to authenticate::

    gcloud auth login
    gcloud auth application-default login
    gcloud config set compute/zone us-west1-b
    gcloud config set compute/region us-west1

You will also want to `set up a billing account <https://cloud.google.com/billing/docs/how-to/manage-billing-account>`_, and write down the billing account ID (you can find this on the [billing console](https://console.cloud.google.com/billing)). You'll need that when we run terraform.

Make sure to clone this repo so you can get access to the Terraform configs and Ansible playbooks for provisioning the environment::

    git clone https://github.com/nre-learning/antidote && cd antidote

All of Antidotes infrastructure is defined in Terraform configurations. So we just need to run `terraform apply`:

.. note::  At this point, Terraform will prompt you to provide the billing account ID you just retrieved in the previous step. It goes without saying but **NOTE THAT THIS WILL MAKE CHANGES IN YOUR ENVIRONMENT**. Review the output of `terraform apply` or `terraform plan` to determine the scope of the changes you're making:

.. code-block:: text

    cd infrastructure/
    terraform apply

The google provider for terraform `**JUST** <https://github.com/terraform-providers/terraform-provider-google/issues/1774#issuecomment-422507130>`_ received support for filestore APIs, but it hasn't made it into a release yet, so for now, we'll have to do this to get our NFS server online::

    gcloud beta filestore instances create nfs-server --location=us-west1-b --tier=STANDARD --file-share=name="influxdata",capacity=1TB --network=name="default-internal"
    gcloud dns record-sets transaction add -z=nre --name="nfs.labs.networkreliability.engineering." --type=A --ttl=300 "$(gcloud beta filestore instances list | grep nfs-server | awk '{print $6}')"
    gcloud dns record-sets transaction execute -z=nre

Next, bootstrap the cluster::

    ./bootstrapcluster.sh


Platform Setup
----------------------------------

Next we need to start the services that will power Antidote. At this point, you should now be able to run kubectl commands. Verify with::

    kubectl get nodes

Enter the `platform` directory and execute the shell script to upload all of the platform kubernetes manifests::

    cd ../platform/
    ./bootstrapplatform.sh

.. note::  may need to restart the coredns pods

.. note::  need to add the following command to create the filestore, then update all kubernetes manifests with the right IP, and THEN make sure all subdirectories are created (like `influxdata`)

.. code-block:: text

    gcloud beta filestore instances create nfs-server \
        --location=us-west1-b \
        --tier=STANDARD \
        --file-share=name="influxdata",capacity=1TB \
        --network=name="default-internal"

Cleaning Up
----------------------------------

As expected, clean up with `terraform destroy`


