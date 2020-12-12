#!/bin/bash

# This script copies any relevant configuration files,
# starts the ssh service, and then starts the rest of cRPD.

\cp /juniper.conf /config/juniper.conf
# cp /license.conf /config/license.conf

\cp /sshd_config /etc/ssh/sshd_config

echo "root:antidotepassword"|chpasswd
service ssh start

# cli load merge /config/license.conf

eval exec /sbin/runit-init 0
