#!/usr/bin/env bash

# if [ -d "/sys/devices/virtual/net/net1" ]; then
#     ip address change 10.10.100.20/24 dev net1
#     ip route add 10.0.0.0/8 via 10.10.100.1 dev net1
# fi

ip address change 10.10.100.20/24 dev net1
ip route add 10.0.0.0/8 via 10.10.100.1 dev net1

/usr/bin/ssh-keygen -A
/usr/sbin/sshd
/usr/sbin/asterisk -f -C /etc/asterisk/asterisk.conf
