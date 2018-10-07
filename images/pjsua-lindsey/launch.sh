#!/usr/bin/env bash


ip address flush dev net1
ip address add 10.10.150.10/24 dev net1
ip route add 10.10.0.0/16 via 10.10.150.1 dev net1

echo "10.10.200.10  asterisk" >> /etc/hosts

/usr/bin/ssh-keygen -A
/usr/sbin/sshd -D

