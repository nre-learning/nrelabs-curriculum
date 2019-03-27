#!/bin/bash
# Copyright (c) 2017, Juniper Networks, Inc.
# All rights reserved.

# Hack to fix a pending network ordering issue in Docker
# https://github.com/docker/compose/issues/4645
# We use docker insepct of our very own container to learn the expected network
# order by grabbing the MAC addresses, except eth0, which is always correct.
# Then we swap the ethX interfaces as needed

echo "$0: trying to fix network interface order via docker inspect myself ..."

# get ordered list of MAC addresses, but skip the first empty one 
MACS=$(docker inspect $HOSTNAME 2>/dev/null |grep MacAddr|awk '{print $2}' | cut -d'"' -f2| tail -n +2|tr '\n' ' ')

echo "MACS=$MACS"
index=0
for mac in $MACS; do
  FROM=$(ip link | grep -B1 $mac | head -1 | awk '{print $2}'|cut -d@ -f1)
  TO="eth$index"
  if [ "$FROM" == "$TO" ]; then
    echo "$mac $FROM == $TO"
  else
    echo "$mac $FROM -> $TO"
    FROMIP6=$(ip addr show $FROM | awk '/inet6/ {print $2}' | grep -v fe80)
    TOIP6=$(ip addr show $TO | awk '/inet6/ {print $2}' | grep -v fe80)
    echo "FROM $FROM ($FROMIP6) TO $TO ($TOIP6)"
    ip link set dev $FROM down
    ip link set dev $TO down
    ip link set dev $FROM name peth
    ip link set dev $TO name $FROM
    ip link set dev peth name $TO
    ip link set dev $FROM up
    if [ ! -z "$TOIP6" ]; then
        ip -6 addr add $TOIP6 dev $FROM
    fi
    ip link set dev $TO up
    if [ ! -z "$FROMIP6" ]; then
        ip -6 addr add $FROMIP6 dev $TO
    fi
    ethtool --offload $FROM tx off
    ethtool --offload $TO tx off
  fi
  index=$(($index + 1))
done
