#!/bin/bash
# Copyright (c) 2019, Juniper Networks, Inc.
# # All rights reserved.

MTU=9000

c1=$1
c2=$2
if [ -z "$c2" ]; then
    echo "$0 <container1> <container2>"
    exit 1
fi

set -e	# terminate on error

sudo mkdir -p /var/run/netns

fc1=$(docker-compose -f regression/docker-compose.yml ps -q $c1)
echo "$c1 $fc1"
pid1=$(docker inspect -f "{{.State.Pid}}" $fc1)
if [ -z "$pid1" ]; then
    echo "Can't find pid for container $c1"
    exit 1
fi

fc2=$(docker-compose -f regression/docker-compose.yml ps -q $c2)
echo "$c2 $fc2"
pid2=$(docker inspect -f "{{.State.Pid}}" $fc2)
if [ -z "$pid2" ]; then
    echo "Can't find pid for container $c2"
    exit 1
fi

echo "$c1 has pid $pid1"
echo "$c2 has pid $pid2"

sudo ln -sf /proc/$pid1/ns/net /var/run/netns/$c1
sudo ln -sf /proc/$pid2/ns/net /var/run/netns/$c2

ifcount1=$(sudo ip netns exec $c1 ip link | grep ' eth' | wc -l)
ifcount2=$(sudo ip netns exec $c2 ip link | grep ' eth' | wc -l)

echo "$c1 has $ifcount1 eth interfaces"
echo "$c2 has $ifcount2 eth interfaces"

sudo ip link add v${c1}-${ifcount1} type veth peer name v${c2}-${ifcount2}
sudo ip link set dev v${c1}-${ifcount1} mtu $MTU
sudo ip link set dev v${c2}-${ifcount2} mtu $MTU

sudo ip link set v${c1}-${ifcount1} name eth$ifcount1 netns $c1
sudo ip link set v${c2}-${ifcount2} name eth$ifcount2 netns $c2

sudo ip netns exec $c1 ip link set up eth$ifcount1
sudo ip netns exec $c2 ip link set up eth$ifcount2

echo "$c1:eth$ifcount1 === $c2:eth$ifcount2"

