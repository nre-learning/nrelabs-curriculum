#!/bin/bash
echo "tearing down ..."
sudo kubeadm reset -f

echo "bringing up ..."
mkdir -p $HOME/.kube
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "adding CNI network multus with flannel ..."
kubectl create -f weaveinstall.yml
sudo cp multus-cni.conf /etc/cni/net.d/1-multus-cni.conf
kubectl create -f multusinstall.yml

# example from flannel repo:
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
#kubectl apply -f kube-flannel.yml

# example from multus-cni repo:
#cat ./{multus-daemonset.yml,flannel-daemonset.yml} | kubectl apply -f -

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

echo ""
echo "enable forwarding ..."
sudo iptables --policy FORWARD ACCEPT
sudo sysctl -p sysctl-k8s.conf

echo ""
echo "creating sample networks ..."
kubectl create -f busybox_networks.yml 

sleep 10

echo ""
echo "creating busybox bb1 and bb2 ..."
kubectl create -f busybox1.yml 
kubectl create -f busybox2.yml 

echo ""
echo -n "waiting for bb2 to be running "
while true; do
  if [ ! -z "$(kubectl get pods bb2 | grep Running)" ]; then
    break
  fi
  sleep 1
  echo -n "."
done

echo ""
echo "checking networks in bb1:"
kubectl exec bb1 ifconfig

echo "checking networks in bb2:"
kubectl exec bb2 ifconfig

