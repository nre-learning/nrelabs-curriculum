.. infrastructure:

Infrastructure
================================


# Load Balancer

Irules and iapps f5, traffic scripts in steelapp.

Lua script inside nginx config. See if you can run other code too.

You really just need the load balancer to make sessions sticky. The end application like xterm or guac should update kubernetes. Need to use cookies on load balancer, and probably still do source-ip rate limiting




# Scheduling

Right now, I'm taking charge of curating kubernetes defintions and other config files for a lab. Long-term, it would be best to limit the configuration to a bare minimum. Select
what images you want, connected in which ways, and which jupyter notebooks to include.

To do this, we need a tool that not only accepts these minimal parameters and deploys them to k8s,but also takes care of scheduling pre-provisioned lab instances.

Needs health checks to know when the lab is provisioned (being able to successfully SSH for instance)

Need to watch both the K8S API, as well as the load balancer logs. Will also need to configure the load balancer probably.



# Postgres

Guacamole needs this


# Isolation

kubectl create namespace my-namespace

https://kubernetes.io/docs/concepts/services-networking/network-policies/
https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/

# Networking

http://dougbtv.com/nfvpe/2017/02/22/multus-cni/

## Weave

Why Weave?

Weave Net supports an overlay network that can span different cloud networking configurations, simplifying running legacy workloads on Kubernetes. For example, Weave supports multicast, even when the underlying network doesn’t. Weave can configure the underlying VPC networking and bypass the overlay when running on AWS. This provider forms a mesh network of hosts that are partitionable and eventually consistent, meaning that the setup is almost zero-config, and it doesn’t need to rely on an Etcd. Weave supports encryption and Kubernetes network policy ensuring that there is security at the network level.

weave also supports network policy

https://github.com/weaveworks/weave/blob/master/site/kubernetes.md
https://www.weave.works/docs/net/latest/kubernetes/kube-addon/
https://sourcegraph.com/github.com/weaveworks/weave@58eaf19026e6ac540c6f89c0dd2bb18bc80c5d59/-/blob/plugin/net/cni.go#L36:3
https://www.weave.works/blog/linux-namespaces-and-go-don-t-mix
https://www.weave.works/docs/net/latest/building/

Some labs may need a single shared network, and this should be the default. They can optionally specify their own bridge per link, in which case the multiple interfaces would sit on different defined network definitions. In both cases, you'll likely want to do some kind of network policy


# Updating DNS

Patching the coredns deployment with the appropriate network is all you need to do:

kubectl -n kube-system patch deployment coredns -p '{"spec":{"template":{"metadata":{"annotations":{"networks": "[{ \"name\": \"guac-net\" }]"}}}}}'


# Load balancing

https://cloud.google.com/kubernetes-engine/docs/tutorials/http-balancer

Also nginx ingress. 

Labs don't get load balanced. Syringe schedules one service per lab pod, and each service is used individually from the antidote-web app

# Antidote-web

[Install with Docker](https://guacamole.apache.org/doc/gug/guacamole-docker.html)
[Extend Guacamole](https://guacamole.apache.org/doc/gug/guacamole-ext.html)

Also get the build your own docs, since you did this

# Monitoring

- NGINX
- The nodes themselves
- gcp LB logs?
- web logs?
- syringe logs