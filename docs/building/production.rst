Deploying Antidote into Production
================================

This is NOT the guide for running a local instance of Antidote. That can be found in < INSERT LINK >.

## Prerequisites

- Git
- Terraform
- Ansible

## Infrastructure Setup

Follow [the instructions for installing the Google Cloud SDK](https://cloud.google.com/sdk/gcloud/), and then run these commands to authenticate:

```
gcloud auth login
gcloud auth application-default login
gcloud config set compute/zone us-west1-b
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

The google provider for terraform doesn't **quite** (https://github.com/terraform-providers/terraform-provider-google/issues/1774#issuecomment-422507130) have the filestore APIs yet, so we'll have to do this to get our NFS server online:

```
gcloud beta filestore instances create nfs-server --location=us-west1-b --tier=STANDARD --file-share=name="influxdata",capacity=1TB --network=name="default-internal"
gcloud dns record-sets transaction add -z=nre --name="nfs.labs.networkreliability.engineering." --type=A --ttl=300 "$(gcloud beta filestore instances list | grep nfs-server | awk '{print $6}')"
gcloud dns record-sets transaction execute -z=nre
```

Next, bootstrap the cluster:

```
./bootstrapcluster.sh
```

## Platform Setup

Next we need to start the services that will power Antidote. At this point, you should now be able to run kubectl commands. Verify with:

```
kubectl get nodes
```

Enter the `platform` directory and execute the shell script to upload all of the platform kubernetes manifests:

```
cd ../platform/
./bootstrapplatform.sh
```

> NOTE may need to restart the coredns pods

> NOTE need to add the following command to create the filestore, then update all kubernetes manifests with the right IP, and THEN make sure all subdirectories are created (like `influxdata`)

```
gcloud beta filestore instances create nfs-server \
    --location=us-west1-b \
    --tier=STANDARD \
    --file-share=name="influxdata",capacity=1TB \
    --network=name="default-internal"
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







## GKE new stuff

After running terraform, configure kubectl with:

```
gcloud container clusters get-credentials antidote-cluster --zone us-west1-a --project networkreliabilityengineering
```

```
kubectl get cs
kubectl get nodes
```


<!-- https://github.com/coreos/prometheus-operator/issues/357 -->
```
kubectl create clusterrolebinding mierdin-admin-binding --clusterrole=cluster-admin --user=Mierdin@gmail.com
```

```
cd platform/
./start.sh
```

