.. networking:

Lab Networking
================================

In order to connect

- Use affinity rules to place pods within the same lesson instance all on the same host. Note that a lesson instance is specific to a user's session.
  Another user will have a different lesson instance even if it's from the exact same lesson ID/definition.
- Use simple linux bridges to connect pods within a lesson to each other.

.. image:: /images/lessonsnetworking.png

TODO
- How does DNS work?
- namespace impact on bridge isolation and DNS?
- do we need a separate mgmt network per lesson?

Using v3.0 of multus
https://github.com/intel/multus-cni


We use a default network configuration in `/etc/cni/net.d/1-multus-cni.conf` which specifies a CNI plugin that will be used by default, such as Weave.
This means that all pods are configured this way for their `eth0` interface. All future networks we attach to a pod start with `net1` and so forth.

.. code:: json

    {
        "name": "node-cni-network",
        "type": "multus",
        "kubeconfig": "/etc/cni/net.d/multus.d/multus.kubeconfig",
        "delegates": [{
            "type": "weave-net",
            "hairpinMode": true,
            "masterplugin": true
        }]
    }


We'll demonstrate this with a simple busybox image for simplicity.

`busybox_networks.yaml`:

.. code:: yaml

    ---
    apiVersion: "k8s.cni.cncf.io/v1"
    kind: NetworkAttachmentDefinition
    metadata:
        name: 12-net
    spec:
        config: '{
            "name": "12-net",
            "type": "bridge",
            "plugin": "bridge",
            "bridge": "12-bridge",
            "forceAddress": false,
            "hairpinMode": true,
            "delegate": {
                    "hairpinMode": true
            },
            "ipam": {
                "type": "host-local",
                "subnet": "10.10.12.0/24"
            }
        }'

    ---
    apiVersion: "k8s.cni.cncf.io/v1"
    kind: NetworkAttachmentDefinition
    metadata:
        name: 23-net
    spec:
        config: '{
            "name": "23-net",
            "type": "bridge",
            "plugin": "bridge",
            "bridge": "23-bridge",
            "forceAddress": false,
            "hairpinMode": true,
            "delegate": {
                    "hairpinMode": true
            },
            "ipam": {
                "type": "host-local",
                "subnet": "10.10.23.0/24"
            }
        }'

    ---
    apiVersion: "k8s.cni.cncf.io/v1"
    kind: NetworkAttachmentDefinition
    metadata:
        name: 31-net
    spec:
        config: '{
            "name": "31-net",
            "type": "bridge",
            "plugin": "bridge",
            "bridge": "31-bridge",
            "forceAddress": false,
            "hairpinMode": true,
            "delegate": {
                    "hairpinMode": true
            },
            "ipam": {
                "type": "host-local",
                "subnet": "10.10.31.0/24"
            }
        }'

`busybox_pods.yaml`:

.. code:: yaml

    ---
    apiVersion: v1
    kind: Pod
    metadata:
    name: bb1
    labels:
        antidote_lab: "1"
        lab_instance: "1"
        podname: "bb1"
    annotations:
        k8s.v1.cni.cncf.io/networks: '[
                { "name": "31-net" },
                { "name": "12-net" }
        ]'
    spec:
    affinity:
        podAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                - key: antidote_lab
                operator: In
                values:
                - "1"
            topologyKey: kubernetes.io/hostname
    containers:
    - name: busybox
        image: busybox
        command:
        - sleep
        - "3600"
        ports:
        - containerPort: 22
        - containerPort: 830

    ---
    apiVersion: v1
    kind: Pod
    metadata:
    name: bb2
    labels:
        antidote_lab: "1"
        lab_instance: "1"
        podname: "bb2"
    annotations:
        k8s.v1.cni.cncf.io/networks: '[
                { "name": "12-net" },
                { "name": "23-net" }
        ]'
    spec:
    affinity:
        podAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                - key: antidote_lab
                operator: In
                values:
                - "1"
            topologyKey: kubernetes.io/hostname
    containers:
    - name: busybox
        image: busybox
        command:
        - sleep
        - "3600"
        ports:
        - containerPort: 22
        - containerPort: 830

    ---
    apiVersion: v1
    kind: Pod
    metadata:
    name: bb3
    labels:
        antidote_lab: "1"
        lab_instance: "1"
        podname: "bb3"
    annotations:
        k8s.v1.cni.cncf.io/networks: '[
                { "name": "23-net" },
                { "name": "31-net" }
        ]'
    spec:
    affinity:
        podAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                - key: antidote_lab
                operator: In
                values:
                - "1"
            topologyKey: kubernetes.io/hostname
    containers:
    - name: busybox
        image: busybox
        command:
        - sleep
        - "3600"
        ports:
        - containerPort: 22
        - containerPort: 830

Since we set affinity rules to ensure all pods in this example run on the same host, we can see that all three
pods are on node `antidote-worker-rm4m`.

.. code:: bash

    kubectl get pods -owide
    NAME      READY     STATUS    RESTARTS   AGE       IP          NODE
    bb1       1/1       Running   0          6m        10.46.0.3   antidote-worker-rm4m
    bb2       1/1       Running   0          6m        10.46.0.2   antidote-worker-rm4m
    bb3       1/1       Running   0          6m        10.46.0.1   antidote-worker-rm4m

This means we can go straight to `antidote-worker-rm4m` and look directly at the linux bridges to see all of
the veth pairs created for our pods connected to their respective bridges.

.. code:: bash

    [mierdin@antidote-worker-rm4m ~]$ brctl show
    bridge name	bridge id		STP enabled	interfaces
    12-bridge		8000.3ef2f983be58	no		veth7f22f574
                                vethb05bc7c8
    23-bridge		8000.7204d78214a6	no		veth64adfee5
                                veth87397395
    31-bridge		8000.5e998329ff44	no		veth4e639bb9
                                vethc8a58c24
    docker0		8000.0242dc1bc14f	no
    weave		8000.6e3a5b617747	no		vethwe-bridge
                                vethweeth0pl321
                                vethweeth0pl41f
                                vethweeth0plff0

Let's take a peek into our pods to look at the network interfaces it sees:

.. code:: bash

    kubectl exec bb1 ip addr show

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
        valid_lft forever preferred_lft forever
    3: net1@if46: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue
        link/ether 0a:58:0a:0a:1f:04 brd ff:ff:ff:ff:ff:ff
        inet 10.10.31.4/24 scope global net1
        valid_lft forever preferred_lft forever
        inet6 fe80::601c:c6ff:fec6:9938/64 scope link tentative flags 08
        valid_lft forever preferred_lft forever
    5: net2@if48: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue
        link/ether 0a:58:0a:0a:0c:07 brd ff:ff:ff:ff:ff:ff
        inet 10.10.12.7/24 scope global net2
        valid_lft forever preferred_lft forever
        inet6 fe80::84bd:e3ff:fe12:59d1/64 scope link tentative flags 08
        valid_lft forever preferred_lft forever
    41: eth0@if42: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1376 qdisc noqueue
        link/ether 8e:1a:a5:9f:75:ba brd ff:ff:ff:ff:ff:ff
        inet 10.46.0.3/12 brd 10.47.255.255 scope global eth0
        valid_lft forever preferred_lft forever
        inet6 fe80::8c1a:a5ff:fe9f:75ba/64 scope link tentative flags 08
        valid_lft forever preferred_lft forever

.. code:: bash

    kubectl exec bb2 ip addr show

        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
        valid_lft forever preferred_lft forever
    3: net1@if45: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue
        link/ether 0a:58:0a:0a:0c:06 brd ff:ff:ff:ff:ff:ff
        inet 10.10.12.6/24 scope global net1
        valid_lft forever preferred_lft forever
        inet6 fe80::5c19:c5ff:fea8:e2fd/64 scope link tentative flags 08
        valid_lft forever preferred_lft forever
    5: net2@if50: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue
        link/ether 0a:58:0a:0a:17:07 brd ff:ff:ff:ff:ff:ff
        inet 10.10.23.7/24 scope global net2
        valid_lft forever preferred_lft forever
        inet6 fe80::d8f2:58ff:fe8a:deca/64 scope link tentative flags 08
        valid_lft forever preferred_lft forever
    43: eth0@if44: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1376 qdisc noqueue
        link/ether 1a:c8:5d:95:a1:ba brd ff:ff:ff:ff:ff:ff
        inet 10.46.0.2/12 brd 10.47.255.255 scope global eth0
        valid_lft forever preferred_lft forever
        inet6 fe80::18c8:5dff:fe95:a1ba/64 scope link tentative flags 08
        valid_lft forever preferred_lft forever

.. code:: bash

    kubectl exec bb3 ip addr show

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
        valid_lft forever preferred_lft forever
    3: net1@if47: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue
        link/ether 0a:58:0a:0a:17:06 brd ff:ff:ff:ff:ff:ff
        inet 10.10.23.6/24 scope global net1
        valid_lft forever preferred_lft forever
        inet6 fe80::dca1:79ff:fe89:a1f2/64 scope link tentative flags 08
        valid_lft forever preferred_lft forever
    5: net2@if49: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue
        link/ether 0a:58:0a:0a:1f:05 brd ff:ff:ff:ff:ff:ff
        inet 10.10.31.5/24 scope global net2
        valid_lft forever preferred_lft forever
        inet6 fe80::64e2:b0ff:fed4:952e/64 scope link tentative flags 08
        valid_lft forever preferred_lft forever
    39: eth0@if40: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1376 qdisc noqueue
        link/ether 5e:e8:3f:c7:f3:a3 brd ff:ff:ff:ff:ff:ff
        inet 10.46.0.1/12 brd 10.47.255.255 scope global eth0
        valid_lft forever preferred_lft forever
        inet6 fe80::5ce8:3fff:fec7:f3a3/64 scope link tentative flags 08
        valid_lft forever preferred_lft forever

We can, of course, ping bb2 and bb3 from bb1 using the addresses shown above:

.. code:: bash

    kubectl exec -it bb1 /bin/sh
    / # ping 10.10.12.6 -c3
    PING 10.10.12.6 (10.10.12.6): 56 data bytes
    64 bytes from 10.10.12.6: seq=0 ttl=64 time=0.101 ms
    64 bytes from 10.10.12.6: seq=1 ttl=64 time=0.111 ms
    64 bytes from 10.10.12.6: seq=2 ttl=64 time=0.106 ms

    --- 10.10.12.6 ping statistics ---
    3 packets transmitted, 3 packets received, 0% packet loss
    round-trip min/avg/max = 0.101/0.106/0.111 ms
    / # ping 10.10.31.5 -c3
    PING 10.10.31.5 (10.10.31.5): 56 data bytes
    64 bytes from 10.10.31.5: seq=0 ttl=64 time=33.159 ms
    64 bytes from 10.10.31.5: seq=1 ttl=64 time=0.109 ms
    64 bytes from 10.10.31.5: seq=2 ttl=64 time=0.103 ms

    --- 10.10.31.5 ping statistics ---
    3 packets transmitted, 3 packets received, 0% packet loss
    round-trip min/avg/max = 0.103/11.123/33.159 ms

DNS
---

DNS in Antidote is done the typical Kubernetes way, outlined in https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/.

So, if you want to reach vqfx1, simply query for `vqfx1`. You will be directed to the correponding service in your namespace.

You can specify the namespace, to access things in other namespaces, such as the default namespace:

vqfx1.default.svc.cluster.local


in-pod
---

nrlab, talk about how the bridges are built






https://thenetworkway.wordpress.com/2016/01/04/lldp-traffic-and-linux-bridges/
cat /proc/mounts | grep sysfs
mount /sys -o remount,rw
echo 16384 > /sys/class/net/net1_tap0/bridge/group_fwd_mask
echo 16384 > /sys/class/net/net2_tap1/bridge/group_fwd_mask

On host:
echo 16384 > /sys/class/net/12-bridge/bridge/group_fwd_mask
echo 16384 > /sys/class/net/23-bridge/bridge/group_fwd_mask
echo 16384 > /sys/class/net/31-bridge/bridge/group_fwd_mask
