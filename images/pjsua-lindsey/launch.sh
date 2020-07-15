#!/usr/bin/env bash


# ip address flush dev net1
# ip address add 10.10.150.10/24 dev net1

# TODO(mierdin): This is all VERY specific to the troubleshooting lesson, which is the only lesson that uses this image.
# Ideally we'd perform this via some kind of runtime configuration which would need to be run as root, but currently the user
# interacts as "antidote" user.
ip route add 10.10.0.0/16 via 10.10.150.3 dev net1

# echo "10.10.200.10  asterisk" >> /etc/hosts

/usr/bin/ssh-keygen -A
/usr/sbin/sshd -D
