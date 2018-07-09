https://github.com/Juniper/contrail-docker/wiki/Setup-basic-kubernetes-cluster


# RUN THIS ON TF-CONTROLLER0

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"


# THIRD TRY

https://tungstenfabric.github.io/website/Tungsten-Fabric-one-line-install-on-k8s.html

mkdir -pm 777 /var/lib/contrail/kafka-logs; curl https://raw.githubusercontent.com/nre-learning/antidote/master/oneliner_deploy.yaml | kubectl apply -f -


https://tf-controller0.labs.networkreliability.engineering:8143/



# Resources

https://github.com/containernetworking/cni/tree/master/cnitool

https://www.juniper.net/documentation/en_US/contrail5.0/topics/concept/install-microsvcs-helm-multi-faq-50.html

Disk space
https://kb.juniper.net/InfoCenter/index?page=content&id=KB30499
https://bugs.launchpad.net/juniperopenstack/+bug/1458290

https://github.com/Juniper/contrail-controller/wiki/Installing-Contrail-CNI-on-Kubernetes

https://bugs.launchpad.net/juniperopenstack/+bug/1694317
https://github.com/Juniper/contrail-docker/wiki/Provision-Contrail-CNI-for-Kubernetes#steps-to-provision-contrail

https://github.com/Juniper/contrail-controller/wiki/REST-API-of-contrail-vrouter-agent-for-port-management

https://github.com/kubernetes/kubernetes/issues/56902


https://tungstenfabric.github.io/website/Tungsten-Fabric-one-line-install-on-k8s.html




# Troubleshooting contrail

# vrouter

The vrouter container on the compute nodes is restarting because it apparently doesn't like hostnames

```
cd /etc/contrail/ && sudo sed -i 's/tf-controller0/10.138.0.2/g' ./*.env
```

Then go to /etc/contrail/vrouter and run

```
sudo docker-compose down && sudo docker-compose up -d
```

# control node

If you look at the control node you'll notice several containers are restarting there too.


cd /etc/contrail/ && sudo sed -i 's/tf-controller0/10.138.0.5/g' ./*.env

cd /etc/contrail/analytics && sudo docker-compose down && sudo docker-compose up -d
cd /etc/contrail/config && sudo docker-compose down && sudo docker-compose up -d
cd /etc/contrail/control && sudo docker-compose down && sudo docker-compose up -d
cd /etc/contrail/webui && sudo docker-compose down && sudo docker-compose up -d


https://github.com/Juniper/contrail-container-builder/

less +F /var/log/contrail/cni/opencontrail.log

sudo systemctl status kubelet -l

sudo contrail-status

- /etc/contrail/contrail-vrouter-agent.conf
/var/log/contrail/contrail-vrouter-agent.log


<!-- Inside the vrouter agent container -->
[root@tf-compute0 contrail]# cat vnc_api_lib.ini
[global]
WEB_SERVER = 10.138.0.2
WEB_PORT = 8082
BASE_URL = /
[auth]
AUTHN_TYPE = noauth

https://www.juniper.net/documentation/en_US/contrail4.1/topics/task/verification/verifying-cni-k8s.html
https://www.juniper.net/documentation/en_US/contrail4.1/topics/task/configuration/node-status-vnc.html