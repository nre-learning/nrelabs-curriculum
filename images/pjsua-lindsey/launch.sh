#!/usr/bin/env bash



ip address flush dev net1
ip address add 10.10.150.10/24 dev net1
ip route add 10.10.0.0/16 via 10.10.150.1 dev net1

echo "10.10.200.10  asterisk" >> /etc/hosts

/usr/bin/ssh-keygen -A
/usr/sbin/sshd
/root/pjproject-2.8/pjsip-apps/bin/pjsua-x86_64-unknown-linux-gnu --id sip:1107@asterisk --registrar sip:asterisk --realm * --username 0019159BF771 --password 4webrEtHupHewu4
