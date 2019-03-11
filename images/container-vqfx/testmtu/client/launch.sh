#!/bin/ash
# Copyright (c) 2018, Juniper Networks, Inc.
# All rights reserved.

until ip link show $WAITFOR; do
  echo "waiting for $WAITFOR to be attached ..."
  sleep 5
done

ifconfig eth1 $LOCAL_IP mtu $MTU up
lldpad -d

lldptool set-lldp -i eth1 adminStatus=rxtx
lldptool -T -i eth1 -V sysName enableTx=yes
lldptool -T -i eth1 -V portDesc enableTx=yes
lldptool -T -i eth1 -V sysDesc enableTx=yes
lldptool -T -i eth1 -V sysCap enableTx=yes
lldptool -T -i eth1 -V mngAddr enableTx=yes

/bin/ash
