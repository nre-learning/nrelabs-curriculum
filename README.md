# NRE Learning

This is a starting point for a set of learning labs for NRE skills.

For ease of use, all of this is built with Terraform and Docker, on top of Google Cloud Platform (since they offer native hardware virtualization extensions).

## Download vMX image

Before launching a vMX, you need an official vmx-bundle tar file from Junos 17.3 or newer.

There is a free trial version available at [https://www.juniper.net/us/en/dm/free-vmx-trial/](https://www.juniper.net/us/en/dm/free-vmx-trial/) (not yet updated with 17.3,  currently in beta). **Start this now** as the bundle is quite large and will take some time to download.

Once downloaded, extract the junos-*.qcow2 VCP VM image from the tar file. We'll use this in a later step.

```
tar zxf vmx-bundle-17.3R1.10.tgz
mv vmx/images/junos-vmx-x86-64-17.3R1.10.qcow2 .
rm -rf vmx
```

## Prerequisites

- Git
- Terraform
- Ansible

## Infrastructure Setup

Follow [the instructions for installing the Google Cloud SDK](https://cloud.google.com/sdk/gcloud/), and then run these commands to authenticate:

```
gcloud auth login
gcloud auth application-default login
gcloud config set compute/zone us-west1-a
gcloud config set compute/region us-west1
```

You will also want to [set up a billing account](https://cloud.google.com/billing/docs/how-to/manage-billing-account), and write down the billing account ID (you can find this on the [billing console](https://console.cloud.google.com/billing)). You'll need that when we run terraform.

Make sure to clone this repo so you can get access to the Terraform configs and Ansible playbooks for provisioning the environment.

```
git clone https://github.com/nre-learning/antidote && cd antidote
```

All of Antidotes infrastructure is defined in Terraform configurations. So we just need to run `terraform apply`:

> At this point, Terraform will prompt you to provide the billing account ID you just retrieved in the previous step. It goes without saying but **NOTE THAT THIS WILL MAKE CHANGES IN YOUR ENVIRONMENT**. Review the output of `terraform apply` or `terraform plan` to determine the scope of the changes you're making. 

```
cd infrastructure/
terraform apply
```

Once terraform creates all of the necessary resources, it's time to run our ansible playbook.

```
gcloud config set core/project networkreliabilityengineering && gcloud compute config-ssh
virtualenv -p python3 venv && source venv/bin/activate
pip3 install -r requirements.txt
ansible-playbook -i inventory/ prepinstances.yml
```

## Platform Setup

Next we need to start the services that will power Antidote. In order to do that, we need to configure kubectl. There's a file `kubeconfig` located in the `tmp/` directory alongside the playbook we just ran. Edit that file to point to `k8s.labs.networkreliability.engineering` instead of the internal IP that's currently there. Then, copy it to `~/.kube/config` on your system.

Finally, look up the external IP address for the first controller, and add an entry for `k8s.labs.networkreliability.engineering` to point to this address.

```
sudo cp tmp/kubeconfig ~/.kube/config
sudo vi ~/.kube/config
sudo vi /etc/hosts
```

You should now be able to run kubectl commands. Verify with:

```
kubectl get nodes
```

Enter the `platform` directory and execute the shell script to upload all of the platform kubernetes manifests:

```
cd ../platform/

```















Next, you should install the Network CRD:

```
kubectl create -f infra/crdnetwork.yaml
```

Finally, you should be able to run the example lesson:

```
cd lessons/lesson-1/k8s-csrx-weave/
./start.sh
```

You can tail the logs of the vMX container to know when it's finished booting:

```
docker logs -f lesson-1_vmx1_1
```

You'll see something like this when the vMX is booted and ready to use:

```
Tue Jun 12 21:24:32 UTC 2018

FreeBSD/amd64 (lesson-1_vmx1_1) (ttyu0)

login:
```

> **DON'T** continue until you see this, as there won't be anything for the lab to connect to until you do. In the future, we'll be spawning all this ahead of time so that when the user wants to connect, there's one waiting for them. For now, we cook everything to order. :smile:

<!-- docker logs lesson-1_vmx1_1 | grep password -->

Exit the shell of the instance, and get back to the machine you were running `gcloud` commands from. Run this to get access to the example demo application:

```
open "http://$(gcloud compute instances describe tf-controller01 | grep natIP | awk '{print $2}'):3000/"
```

Hit next a few times in the notebook pane to test it out. It should look something like this if it worked:

![](images/example_lesson1.png?raw=true "lesson1")

You can also poke around the on-screen terminal - this is our vMX image - it's the actual Junos system that our jupyter notebook queried.

## Cleaning Up

As expected, clean up with `terraform destroy`
