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
git clone https://github.com/nre-learning/antidote && cd antidote
```

All of Antidotes infrastructure is defined in Terraform configurations. So we just need to run `terraform apply`:

> At this point, Terraform will prompt you to provide the billing account ID you just retrieved in the previous step. **NOTE THAT THIS WILL IMMEDIATELY MAKE CHANGES IN YOUR ENVIRONMENT**. Use this with caution, as these instructions do not include a `terraform plan` step. Use these commands with caution.

```
terraform apply -auto-approve
```

> If this breaks on the image creation step, you likely need to get an updated Terraform installation, or update your providers using `terraform init`, as the `--licenses` parameter was only added in my [recent PR](https://github.com/terraform-providers/terraform-provider-google/pull/1717/).

At this point, you should wait a few minutes for DNS to update. Once the hostnames referenced in the Ansible inventory are resolving correctly, we can run the playbook that will configure the instances and install kubernetes and tungsten.

```
gcloud config set core/project networkreliabilityengineering && gcloud compute config-ssh
ansible-playbook -i inventory.yml prepinstances.yml
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

# TODOs

Some links that will be useful later for orchestrating network isolation between labs and within labs
https://www.juniper.net/documentation/en_US/contrail4.1/topics/concept/kubernetes-cni-contrail.html
http://dougbtv.com/nfvpe/2017/02/22/multus-cni/
Question is, can we do multiple interfaces with contrail too?

https://medium.com/google-cloud/understanding-kubernetes-networking-pods-7117dd28727

Need to secure jupyter notebooks
https://jupyter-notebook.readthedocs.io/en/stable/public_server.html
That's also useful for embedding somewhere

**ABSOLUTELY NOTHING IS SECURED** - need to do this.

All of our customizations to the contrail ansible stuff should be maintained outside the repo. Need to work to get the submodule back on track with upstream, rather than try to maintain a fork long-term.



# Maybe need?

Install libcloud:

```
virtualenv -p python3 venv && source venv/bin/activate
pip3 install -r requirements.txt
```

```
gcloud iam service-accounts keys create ~/ansible-gcloud.json \
  --iam-account ansible-sa@$(gcloud projects list | grep nre-learning | awk '{print $1}').iam.gserviceaccount.com
```







# Load Balancing Notes

Your load balancer will need to:
- Delete the lab if the load balancer loses contact with the client after a certain period of time (see next)
- Do some kind of rate-limiting - if possible, it would be nice if we could re-attach to an existing session if the person simply refreshes the page






TODOs
- need to fix DNS resolution in the guac container, and probably jupyter as well. Jupyter will need to be able to resolve to the same hostname but the IP might be different
- you will likely need to write a bit of javascript that hides the terminal until guacamole is ready, and/or until the underlying lab is ready. (see if guacamole can do this later waiting for you)
- Rotating SSL certificates
- All secrets. Tomcat, kubernetes, syringe. Need a way to update these easily so you can secure this thing
- secure kubernetes. Shouldn't allow direct access to tf-controller0, perhaps set up a VPN?
- secure syringe service account
- Need to gather a list of secrets, and make it easy to rotate them and store them outside this repo.
- Update LB confnig
- dynamic inventory for compute hosts    https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html
- how to scale?
- HTTPS (get rid of http) with letsencrypt. Don't forget to reenable redirection in the ingress
- jupyter without iframe https://groups.google.com/forum/#!topic/jupyter/1eh-Myq9q4Q
- jupyter letsencrypt cert. Also tomcat cert. How to secure privkeys in docker containers?
- Document network connectivity provided by syringe
- Convert lab page into a single dynamic page - will have to generate html from markdown somewhere, and source either the markdown or the resulting HTML from syringe
- Syringe docs, including the syringe.yaml DSL
- Add health checks in syringe and update ready status when it checks out
- scale antidote-web
- firm up security on ingress for antidote
- Logging and instrumentation in syringe is desperately needed
- Are the networks namespace-aware? Does the weave veth pair also need to have ns in the name?
- Garbage collection. Do it at a set interval? What about adding event handlers to either JS or Java or both? Actually would be nice if you could add close handlers but also update a last_used timestamp for the session when an API call is made, and have a goroutine running in the background cleaning them up. Actually do this only. Don't clean up when they leave the page or refresh. That will result in a shit UX. Do an async cleanup on the back end based on timeouts. You could also introduce a button that lets them reset the lab environment if you want down the road. Document this behavior. Also document the design between request and get, and how this allows us to do a request on each page load and it doesn't matter 
- Consider linking labs together in a lesson and provisioning all of them at once.
- document everything that needs to go into a lesson directory (syringe.yaml and README.md at a minimum), and then what's optional depending on what's in the syringefile.
- generate the lesson README in the browser, make it look just like the docker labs example - that looked nice. You'll need to add a place in the syringe.yaml file for it. Just provide a URL and it will get passed down to the browser.