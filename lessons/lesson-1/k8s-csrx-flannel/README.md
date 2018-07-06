
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

curl -L -o etcd-v3.3.8-linux-amd64.tar.gz https://github.com/coreos/etcd/releases/download/v3.3.8/etcd-v3.3.8-linux-amd64.tar.gz
tar -xzf etcd-v3.3.8-linux-amd64.tar.gz
sudo cp etcd-v3.3.8-linux-amd64/etcdctl /usr/bin

```
sudo etcdctl \
--endpoints="https://127.0.0.1:2379" \
--key-file="/etc/kubernetes/pki/apiserver-etcd-client.key" \
--cert-file="/etc/kubernetes/pki/apiserver-etcd-client.crt" \
--ca-file="/etc/kubernetes/pki/etcd/ca.crt" \
set /coreos.com/network/config '{ "Network": "10.5.0.0/16", "Backend": {"Type": "vxlan"}}'
```

kubectl get ds --namespace=kube-system kube-flannel-ds