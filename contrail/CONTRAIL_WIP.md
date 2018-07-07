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