
[Install with Docker](https://guacamole.apache.org/doc/gug/guacamole-docker.html)
[Extend Guacamole](https://guacamole.apache.org/doc/gug/guacamole-ext.html)

# Core Infrastructure

- Jupyter? (we would have to make sure users don't try to manipulate others gear)
- Guacamole - should be straightforward to centralize this

The bre labs provisioning process needs an API. The tutorials are just one application on top of this API but it can also be used for cicd testing with simply different topologies.

Be aware of which containers need copies. Jupyter doesn't need to be be spun up multiple

# Use Cases

(update diagram)

(add existing ones, these are new)
- ANTIDOTE USE CASE - Self service sales enablement
- ANTIDOTE USE CASE - Sales enablement - build a web front end for setting up demos. Generate antidote DSL and spin it up
- ANTIDOTE USE CASE - discover customer environment and generate antidote DSL from it


You'll need to make sure that the lab is presented on a standard port, for enterprises to use. You'll already have to do proxying to make sure they connect to the right back-end, but proxying is also a good idea for this reason. Look at nginx and haproxy as well as some of the more advanced stuff for this


# Load Balancer

Irules and iapps f5, traffic scripts in steelapp.

Lua script inside nginx config. See if you can run other code too.

You really just need the load balancer to make sessions sticky. The end application like xterm or guac should update kubernetes. Need to use cookies on load balancer, and probably still do source-ip rate limiting


# Isolation

kubectl create namespace my-namespace

https://kubernetes.io/docs/concepts/services-networking/network-policies/
https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/

# Syringe

Needs health checks to know when the lab is provisioned (being able to successfully SSH for instance)

Need to watch both the K8S API, as well as the load balancer logs. Will also need to configure the load balancer probably.

# Networking

http://dougbtv.com/nfvpe/2017/02/22/multus-cni/

Why Weave?

Weave Net supports an overlay network that can span different cloud networking configurations, simplifying running legacy workloads on Kubernetes. For example, Weave supports multicast, even when the underlying network doesn’t. Weave can configure the underlying VPC networking and bypass the overlay when running on AWS. This provider forms a mesh network of hosts that are partitionable and eventually consistent, meaning that the setup is almost zero-config, and it doesn’t need to rely on an Etcd. Weave supports encryption and Kubernetes network policy ensuring that there is security at the network level.

https://github.com/weaveworks/weave/blob/master/site/kubernetes.md

# Postgres

# Some postgres stuff:


```
gcloud compute scp initdb.sql db0:~
```


```
sudo cp initdb.sql /var/lib/pgsql
sudo -i -u postgres
createuser -P -s -e guacuser
#guacuser/guac

createdb guacamole_db

psql -f initdb.sql guacamole_db
```

