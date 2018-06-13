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

## Walkthrough

Follow [the instructions for installing the Google Cloud SDK](https://cloud.google.com/sdk/gcloud/), and then run these commands to authenticate:

```
gcloud auth login
gcloud auth application-default login
gcloud config set compute/zone us-west1-a
gcloud config set compute/region us-west1
```

You will also want to [set up a billing account](https://cloud.google.com/billing/docs/how-to/manage-billing-account), and write down the billing account ID (you can find this on the [billing console](https://console.cloud.google.com/billing)). You'll need that in the next step.

Make sure to clone this repo so you can get access to the Terraform configs and Ansible playbooks for provisioning the environment.

```
git clone https://github.com/Mierdin/nre-learn && cd nre-learn
```

We need to run the terraform configs in stages, which will be explained shortly. For now, we just want to run the configs pertaining to the creation of a new GCP project and a new disk:

> At this point, Terraform will prompt you to provide the billing account ID you just retrieved in the previous step. **NOTE THAT THIS WILL IMMEDIATELY MAKE CHANGES IN YOUR ENVIRONMENT**. Use this with caution, as this instructions do not include a `terraform plan` step. Use these commands with caution.

```
terraform init
terraform apply \
    -auto-approve \
    -target=google_project.project \
    -target=google_project_services.project \
    -target=google_compute_disk.centos7_disk
```

Because the GCP provider for Terraform [doesn't yet allow](https://github.com/terraform-providers/terraform-provider-google/issues/1045) us to [attach the required license for enabling virtualization extensions](https://cloud.google.com/compute/docs/instances/enable-nested-virtualization-vm-instances), we stop after this disk creation, so that we can then create the required image using the `gcloud` utility based from this disk:

> I'm planning to propose a PR for the GCP terraform provider to add the `--licenses` field, so we don't have to do this silliness. Should be straightforward.

```
gcloud config set core/project $(gcloud projects list | grep nre-learning | awk '{print $1}')

gcloud compute images create nested-vm-image \
  --source-disk centos7-disk --source-disk-zone us-west1-a \
  --licenses "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"
```

Once our new image exists, we can apply the remaining terraform resources:

```
terraform apply -auto-approve
```

Time to run ansible:

```
gcloud compute config-ssh
cat terraform.tfstate | grep '.*_nat_ip.*\|.*tags\.[0-9][0-9].*' | cut -d':' -f2 | awk '{print $1}' | cut -d'"' -f2 >| hosts
ansible-playbook -i hosts prepinstances.yml
```

> The Ansible playbook assumes you extracted the vMX image downloaded earlier to `./junos-vmx-x86-64-18.1R1.9.qcow2` and will take care of copying it to the instance(s).

## Finally...

Optionally, you can run this to provide `sudo`-less docker access:

```
gcloud compute ssh tf-controller01 -- 'sudo usermod -aG docker $USER'
```

> You'll see `Connection to <ip> closed.`, this is normal

Now, let's SSH into our new instance:

```
gcloud compute ssh tf-controller01
```

Finally, you should be able to run the docker-compose lab:

```
cd ~/nre-learn/lessons/lesson-1
docker-compose up -d --build
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

Exit the shell of the instance, and get back to the machine you were running `gcloud` commands from. Run this to open the jupyter notebook:

```
open "http://$(gcloud compute instances describe tf-controller01 | grep natIP | awk '{print $2}'):8888/notebooks/work/lesson1.ipynb"
```

Hit next a few times to test it out. It should look something like this if it worked:

![](images/example_lesson1.png?raw=true "lesson1")

## Cleaning Up

As expected, clean up with `terraform destroy`

# TODOs

Some links that will be useful later for orchestrating network isolation between labs and within labs
https://www.juniper.net/documentation/en_US/contrail4.1/topics/concept/kubernetes-cni-contrail.html
http://dougbtv.com/nfvpe/2017/02/22/multus-cni/
Question is, can we do multiple interfaces with contrail too?

Need to secure jupyter notebooks
https://jupyter-notebook.readthedocs.io/en/stable/public_server.html
That's also useful for embedding somewhere


