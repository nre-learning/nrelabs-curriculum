Why Weave?

Weave Net supports an overlay network that can span different cloud networking configurations, simplifying running legacy workloads on Kubernetes. For example, Weave supports multicast, even when the underlying network doesn’t. Weave can configure the underlying VPC networking and bypass the overlay when running on AWS. This provider forms a mesh network of hosts that are partitionable and eventually consistent, meaning that the setup is almost zero-config, and it doesn’t need to rely on an Etcd. Weave supports encryption and Kubernetes network policy ensuring that there is security at the network level.

https://github.com/weaveworks/weave/blob/master/site/kubernetes.md

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

https://www.weave.works/docs/net/latest/kubernetes/kube-addon/

My issue:
https://github.com/intel/multus-cni/issues/91

Run on controller:

```
sudo curl -L git.io/weave -o /usr/bin/weave
sudo chmod a+x /usr/bin/weave
```


Maybe needed?
sudo brctl addbr weave-brmgmt
sudo brctl addbr weave-br12

but probably more along the lienes of hte fact that it's trying to create a veth pair with itself
ACTUALLY it's not the same. They are differnet.
https://sourcegraph.com/github.com/weaveworks/weave@58eaf19026e6ac540c6f89c0dd2bb18bc80c5d59/-/blob/net/veth.go#L126

\n    },\n    \"dns\": {}\n}{\n    \"code\": 100,\n    \"msg\": \"Multus: error in invoke Delegate add - \\\"weave-net\\\": could not create veth pair vethwepl9e03dba-vethwepg9e03dba: file exists\"\n}": invalid character '{' after top-level value

[mierdin@tf-compute0 ~]$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 42:01:0a:8a:00:02 brd ff:ff:ff:ff:ff:ff
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default
    link/ether 02:42:31:37:b2:15 brd ff:ff:ff:ff:ff:ff
4: datapath: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1376 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether b2:7d:9c:12:ea:bb brd ff:ff:ff:ff:ff:ff
6: weave: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1376 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 52:94:3e:64:5a:1d brd ff:ff:ff:ff:ff:ff
7: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 02:60:79:0d:96:71 brd ff:ff:ff:ff:ff:ff
9: vethwe-datapath@vethwe-bridge: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1376 qdisc noqueue master datapath state UP mode DEFAULT group default
    link/ether e2:36:21:47:c8:a7 brd ff:ff:ff:ff:ff:ff
10: vethwe-bridge@vethwe-datapath: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1376 qdisc noqueue master weave state UP mode DEFAULT group default
    link/ether 7a:ae:d9:69:09:3d brd ff:ff:ff:ff:ff:ff
11: vxlan-6784: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 65520 qdisc noqueue master datapath state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 66:51:8a:35:79:bb brd ff:ff:ff:ff:ff:ff
63276: weave-brmgmt: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
63285: weave-br12: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 9a:be:ea:95:8a:ef brd ff:ff:ff:ff:ff:ff
63743: vethwepl8ab7e07@if63742: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master weave-br12 state UP mode DEFAULT group default
    link/ether 9a:be:ea:95:8a:ef brd ff:ff:ff:ff:ff:ff link-netnsid 0



using a new bridge probably a good idea for isolation, but don't think its your problem
[mierdin@tf-compute0 ~]$ sudo brctl show
bridge name	bridge id		STP enabled	interfaces
docker0		8000.02423137b215	no
weave		8000.52943e645a1d	no		vethwe-bridge
weave-br12		8000.9abeea958aef	no		vethwepl8ab7e07
weave-brmgmt		8000.000000000000	no

https://sourcegraph.com/github.com/weaveworks/weave@58eaf19026e6ac540c6f89c0dd2bb18bc80c5d59/-/blob/plugin/net/cni.go#L36:3
https://www.weave.works/blog/linux-namespaces-and-go-don-t-mix




I think the problem is that the way that weave sets veth pair names is pretty static. You can create a veth pair before attaching it to a bridge.

https://www.weave.works/docs/net/latest/building/

kubectl describe ds -n=kube-system weave-net


cd $GOPATH/src/github.com/mierdin/weave
git submodule update --init


kubectl delete ds -n=kube-system weave-net
make


sudo docker image rm -f $(sudo docker images | grep weave | awk '{print $3}')
#gcloud compute ssh tf-controller0 --command "sudo docker image rm -f $(sudo docker images | grep weave | awk '{print $3}')"
#gcloud compute ssh tf-compute0 --command "sudo docker image rm -f $(sudo docker images | grep weave | awk '{print $3}')"
#gcloud compute ssh tf-compute1 --command "sudo docker image rm -f $(sudo docker images | grep weave | awk '{print $3}')"


gcloud compute ssh tf-controller0 --command "sudo rm -f /opt/cni/bin/weave*"
gcloud compute ssh tf-compute0 --command "sudo rm -f /opt/cni/bin/weave*"
gcloud compute ssh tf-compute1 --command "sudo rm -f /opt/cni/bin/weave*"
gcloud compute scp ./weave.tar.gz tf-controller0:~
gcloud compute scp ./weave.tar.gz tf-compute0:~
gcloud compute scp ./weave.tar.gz tf-compute1:~
gcloud compute ssh tf-controller0 --command "sudo docker load -i ~/weave.tar.gz"
gcloud compute ssh tf-compute0 --command "sudo docker load -i ~/weave.tar.gz"
gcloud compute ssh tf-compute1 --command "sudo docker load -i ~/weave.tar.gz"
gcloud compute ssh tf-controller0 --command "sudo systemctl restart kubelet"
gcloud compute ssh tf-compute0 --command "sudo systemctl restart kubelet"
gcloud compute ssh tf-compute1 --command "sudo systemctl restart kubelet"

kubectl create -f weaveinstall.yml

gcloud compute ssh tf-controller0 --command "sudo rm /etc/cni/net.d/10-weave.conf"
gcloud compute ssh tf-compute0 --command "sudo rm /etc/cni/net.d/10-weave.conf"
gcloud compute ssh tf-compute1 --command "sudo rm /etc/cni/net.d/10-weave.conf"
gcloud compute ssh tf-controller0 --command "sudo systemctl restart kubelet"
gcloud compute ssh tf-compute0 --command "sudo systemctl restart kubelet"
gcloud compute ssh tf-compute1 --command "sudo systemctl restart kubelet"

<!-- kubectl set image -n=kube-system ds/weave-net weave=weaveworks/weave-kube:$MYVER -->





<!-- // vethPrefix = vethPrefix + bridgeName[len(bridgeName)-2:] -->





gcloud compute ssh tf-controller0 --command "sudo docker tag weaveworks/weave-kube:latest weaveworks/weave-kube:$MYVER"
gcloud compute ssh tf-compute0 --command "sudo docker tag weaveworks/weave-kube:latest weaveworks/weave-kube:$MYVER"
gcloud compute ssh tf-compute1 --command "sudo docker tag weaveworks/weave-kube:latest weaveworks/weave-kube:$MYVER"