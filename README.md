# NRE Learning

This is a starting point for a set of learning labs for NRE skills.

For ease of use, all of this is built with Terraform and Docker, on top of Google Cloud Platform (since they offer native hardware virtualization extensions).


## Download vMX image

Before launching a vMX, you need an official vmx-bundle tar file from Junos 17.3 or newer.

There is a free trial version available at [https://www.juniper.net/us/en/dm/free-vmx-trial/](https://www.juniper.net/us/en/dm/free-vmx-trial/) (not yet updated with 17.3,  currently in beta). **Start this now** as the bundle is quite large and will take some time to download.

Once downloaded, extract the junos-*.qcow2 VCP VM image from the tar file. We'll use this in a later step.

```
$ tar zxf vmx-bundle-17.3R1.10.tgz
$ mv vmx/images/junos-vmx-x86-64-17.3R1.10.qcow2 .
$ rm -rf vmx
$ ls -l junos-vmx-x86-64-17.3R1.10.qcow2
-rw-r--r-- 1 mwiget mwiget 1226440704 Jun 22 00:14 junos-vmx-x86-64-17.3R1.10.qcow2
```

## Walkthrough

Follow [the instructions for installing the Google Cloud SDK](https://cloud.google.com/sdk/gcloud/), and then run these commands to authenticate:

```
gcloud auth login
gcloud auth application-default login
gcloud config set compute/zone us-west1-a
gcloud config set compute/region us-west1
```

You will also want to [set up a billing account](https://cloud.google.com/billing/docs/how-to/manage-billing-account), and write down the billing account ID (you can find this on the [billing console](https://console.cloud.google.com/billing)). You'll need that in the next step.

First, we need to provision a new GCP project, and a GCE disk based off of the public Ubuntu 16.04 disk:

> At this point, Terraform will prompt you to provide the billing account ID you just retrieved in the previous step.

```
terraform init
terraform apply \
    -auto-approve \
    -target=google_project.project \
    -target=google_project_services.project \
    -target=google_compute_disk.xenial_disk
```

Because the GCP provider for Terraform doesn't yet allow us to [attach the required license for enabling virtualization extensions](https://cloud.google.com/compute/docs/instances/enable-nested-virtualization-vm-instances), we stop after this disk creation, so that we can then create the required image using the `gcloud` utility based from this disk:

```
gcloud config set core/project $(gcloud projects list | grep nre-learning | awk '{print $1}')

gcloud compute images create nested-vm-image \
  --source-disk u16-disk --source-disk-zone us-west1-a \
  --licenses "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"
```

Once our new image exists, we can apply the remaining terraform resources:

```
terraform apply -auto-approve
```

Assuming you copied the junos image you downloaded earlier to `./junos-vmx-x86-64-18.1R1.9.qcow2`, SCP it to the new instance:

```
gcloud compute scp ./junos-vmx-x86-64-18.1R1.9.qcow2 nrelearn:~
```

Now, let's SSH into our new instance:

```
gcloud compute ssh nrelearn
```

Install dependencies, set up hugepages, and copy the vMX image into place:

```
sudo apt-get update && sudo apt-get install docker.io hugepages qemu-kvm -y
sudo sysctl vm.nr_hugepages=1024
mkdir myfiles
mv ~/junos-vmx-x86-64-18.1R1.9.qcow2 ~/myfiles
```

### license-eval.txt

Download the free 60-day 50 Mbps vMX trial license from the vMX trial website and rename the file to license-eval.txt:

```
$ curl -o myfiles/license-eval.txt https://www.juniper.net/us/en/dm/free-vmx-trial/E421992502.txt
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   206  100   206    0     0   2093      0 --:--:-- --:--:-- --:--:--  2102
$  ls -l myfiles/license-eval.txt
-rw-r--r--  1 mwiget  935  202 Jul 17 09:10 myfiles/license-eval.txt
```

### id_rsa.pub

This step is optional, but greatly simplifies operation with the vMX instance, by allowing ssh access to the instances via ssh private key. 

If you don't have already a ssh public/private keypair, you can create one with 'ssk-keygen'. Just hit enter to all questions (unless you know what you are doing):

```
$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/jdoe/.ssh/id_rsa):
Created directory ‘/home/jdoe/.ssh’.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/jdoe/.ssh/id_rsa.
Your public key has been saved in /home/jdoe/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:8fr36Lx/UUusEEWhepgewH9J+ST2+DbVliMDtGo8dUM jdoe@server
The key’s randomart image is:
+---[RSA 2048]----+
|           .oE.  |
|      .   ..=    |
|       o.  X.+.  |
|        +oO.X .o+|
|        S@.=.=o+=|
|        o.= ..++.|
|        ..   +  .|
|         . .o.. .|
|          .o=+o. |
+----[SHA256]-----+
jdoe@server:~$ ls -l .ssh/id_rsa.pub
-rw-r--r-- 1 jdoe jdoe 390 Jul 18 13:29 .ssh/id_rsa.pub
```

Copy your ssh public key (id_rsa.pub) from your ~/.ssh directory into the myfiles directory. This will grant you password-less access to the vMX as root and your username:

```
$ cp ~/.ssh/id_rsa.pub myfiles/
```

Your myfiles directory should now look similar to this:

```
$ ls myfiles/
id_rsa.pub  license-eval.txt  junos-vmx-x86-64-17.3R1.10.qcow2
```

## Finally...

Eventually we want to build our own Dockerfiles per lab, as well as the infrastructure for actually running them, but this is all I have for now. Ensure you can run the vMX image with:

```
sudo docker run --name nre-learning -d --privileged --volume=$HOME/myfiles/:/u marcelwiget/vmx-docker-light
```

> Omit the `-d` flag to get instant feedback, or continue to run in detached mode and use `docker logs` to see startup status.

<!-- # sudo hugeadm --pool-pages-min 2M:+512 --add-temp-swap -->

## Cleaning Up

As expected, clean up with `terraform destroy`









