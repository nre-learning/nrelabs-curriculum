#!/bin/bash
echo "tearing down ..."
sudo kubeadm reset -f
#sudo iptables -F 
#sudo iptables -t nat -F
#sudo iptables -t mangle -F 
#sudo iptables -X
