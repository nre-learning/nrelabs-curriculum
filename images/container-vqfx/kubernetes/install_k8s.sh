#!/bin/bash

echo "initialize cluster ..."
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

echo "configure kubectl ..."
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "adding CNI network multus with flannel for pod network ..."
sudo cp multus-cni.conf /etc/cni/net.d/1-multus-cni.conf
sudo cp veth-p2p /opt/cni/bin/
sudo chmod a+x /opt/cni/bin/veth-p2p
kubectl create -f multusinstall.yml

echo ""
echo -n "waiting for node to be ready "
while true; do
  if [ -z "$(kubectl get nodes | grep NotReady)" ]; then
    break
  fi
  sleep 1
  echo -n "."
done
echo ""
echo "kubectl get nodes"
kubectl get nodes

echo ""
echo "remove control plane node isolation ..."
kubectl taint nodes --all node-role.kubernetes.io/master-
