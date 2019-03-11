## vqfx container on kubernetes

First success running vqfx container in kubernetes using multus-cni with kubeadm on a linux laptop!!!

Current issues:

- How to pass the ssh public key to the container?
- How to pass the vqfx2.conf file to the container? Create a volume?
- My setup blocks IP unicast packets over the networks created with multus+weave, broadcast works though

But launching vQFX image (built with integrated qcow2 image) failed to launch kvm with the following error:

```
qemu-system-x86_64: -netdev tap,fd=7,id=tc0,vhost=on: tap: open vhost char device failed: No such file or directory
```

I tried manually installing the kernel module vhost via `sudo modprobe vhost`, but the error remained. Did a stop/start, which might got rid of the module. Might need to check again.

the kvm image installed by minikube doesn't have the kernel modules for vhost_net:

$ ls /lib/modules/4.15.0/kernel/drivers/vhost/
vhost.ko  vhost_vsock.ko
$

On a generic ubuntu 18.04, there are these files available:

mwiget@cbm1:~$ find /lib/modules/4.15.0-43-generic/kernel -name vhost\*
/lib/modules/4.15.0-43-generic/kernel/drivers/vhost
/lib/modules/4.15.0-43-generic/kernel/drivers/vhost/vhost_net.ko
/lib/modules/4.15.0-43-generic/kernel/drivers/vhost/vhost_vsock.ko
/lib/modules/4.15.0-43-generic/kernel/drivers/vhost/vhost.ko
/lib/modules/4.15.0-43-generic/kernel/drivers/vhost/vhost_scsi.ko

# Build

Build standard container-vqfx first (required until the kubernetes changes relevant to launch.sh are pushed upstream). From the main repo directory run:

```
$ make build
```

Then change into the minikube directory and copy one or more valid jinstall-vqfx-10 images into the folder:

```
$ cd kubernetes
$ ./build.sh
Building container juniper/vqfx:18.4R1.8 ...
Sending build context to Docker daemon  588.3MB
Step 1/3 : ARG image
Step 2/3 : FROM juniper/container-vqfx
 ---> 6e0f58e32ea8
Step 3/3 : ADD $image /u
 ---> d9fd0c5defca
Successfully built d9fd0c5defca
Successfully tagged juniper/vqfx:18.4R1.8
```

List the image:

```
$ docker images |head
REPOSITORY                                           TAG                 IMAGE ID            CREATED              SIZE
juniper/vqfx                                         18.4R1.8            d9fd0c5defca        24 seconds ago       1.27GB
juniper/container-vqfx                               latest              6e0f58e32ea8        About a minute ago   684MB
<none>                                               <none>              6a3e9d5c83a1        6 hours ago          684MB
<none>                                               <none>              0ee622044d3a        6 hours ago          406MB
```


Deploy the vqfx with 2 alpine containers via 

```
$ kubectl create -f vqfx.yml
```

Monitor the log file of vqfx1 until you see the login prompt:

```
$ kubectl logs -f vqfx1

. . .

starting local daemons:set cores for group access
Running /packages/finish.install ...
.
Fri Feb  8 18:55:23 UTC 2019

vqfx1 (ttyd0)
^C
```

Hit Ctrl-C to exit the log and find the IP address of vqfx1:

```
$ kubectl logs vqfx1 |grep 'root password'
vqfx1 (10.32.0.25) 18.4R1.8 root password lab123
```

```
mwiget@xps:~/Dropbox/git/container-vqfx/kubernetes$ kubectl get pods
NAME      READY   STATUS    RESTARTS   AGE
alpine1   1/1     Running   0          2m43s
alpine2   1/1     Running   0          2m43s
bb1       1/1     Running   1          72m
bb2       1/1     Running   1          72m
vqfx1     1/1     Running   2          27m

```

Log into vqfx1 as user lab, password lab123. Currently user root can't log in via ssh (missing junos statement to allow it).

```
$ ssh lab@10.32.0.25
Password; lab123
Last login: Fri Feb  8 19:19:39 2019 from 10.32.0.1
--- JUNOS 18.4R1.8 built 2018-12-17 03:30:15 UTC
{master:0}
lab@vqfx1> show chassis fpc 
                     Temp  CPU Utilization (%)   CPU Utilization (%)  Memory    Utilization (%)
Slot State            (C)  Total  Interrupt      1min   5min   15min  DRAM (MB) Heap     Buffer
  0  Online           Testing  43        19        0      0      0    1024        0         73
  1  Empty           
  2  Empty           
  3  Empty           
  4  Empty           
  5  Empty           
  6  Empty           
  7  Empty           
  8  Empty           
  9  Empty           

{master:0}
lab@vqfx1> 
```

Upload the vqfx1.conf config and do a load merge (not overwrite!!)


Then log into the alpine1 container and ping 192.168.99.2 and 192.168.99.254. Repeat from alpine2.
In my k8s cluster multus networking I have an issue with unicast packets. Broadcasts work, hence one can
see the ARP resolved.


```
{master:0}
lab@vqfx1> show arp 
MAC Address       Address         Name                      Interface               Flags
16:e4:9b:98:16:77 10.32.0.1       10.32.0.1                 em0.0                   none
36:96:0a:ff:4d:6a 169.254.0.1     169.254.0.1               em1.0                   none
0a:58:0a:0b:0b:1b 192.168.99.1    192.168.99.1              irb.0 [xe-0/0/1.0]      none
Total entries: 3

{master:0}
lab@vqfx1> show arp    
MAC Address       Address         Name                      Interface               Flags
16:e4:9b:98:16:77 10.32.0.1       10.32.0.1                 em0.0                   none
36:96:0a:ff:4d:6a 169.254.0.1     169.254.0.1               em1.0                   none
0a:58:0a:0b:0b:1b 192.168.99.1    192.168.99.1              irb.0 [xe-0/0/0.0]      none
0a:58:0a:0b:0c:1b 192.168.99.2    192.168.99.2              irb.0 [xe-0/0/0.0]      none
Total entries: 4

{master:0}
lab@vqfx1> quit 

Connection to 10.32.0.25 closed.

```


