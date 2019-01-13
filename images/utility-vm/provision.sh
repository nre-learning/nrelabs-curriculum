#!/bin/bash

sudo mkdir /antidote
sudo mount -t 9p -o trans=virtio,version=9p2000.L hostshare /antidote
echo "hostshare /antidote  9p trans=virtio,version=9p2000.L,nobootwait,rw,_netdev    0  0" | sudo tee -a /etc/fstab

sudo apt-get update -qy \
 && sudo apt-get upgrade -qy \
 && sudo apt-get install -y \
    docker.io python python-pip dnsutils iputils-ping git vim curl util-linux sshpass

sudo pip install napalm netmiko jsnapy junos-eznc robotframework jinja2
