#!/bin/sh
# Copyright (c) 2017, Juniper Networks, Inc.
# All rights reserved.
#
if [ $(id -u) -ne 0 ]; then
  echo "please run this with sudo $0"
  exit 1
fi
echo "enabling LLDP passthru the docker linux bridges ..."
bridges=$(ls -d /sys/class/net/br-*)
for bridge in $bridges; do
  br=$(basename $bridge)
  echo -n "$br "
  echo 16384 > /sys/class/net/$br/bridge/group_fwd_mask
done
echo ""
echo "done."
