#!/bin/bash

mount -o rw,remount /sys


ethlist=$(ls /sys/class/net | grep 'net' | grep -v 'eth0')

NETDEVS=""

COUNTER=0
for eth in $ethlist
do

    let COUNTER1=COUNTER+1

    net="net$COUNTER1"
    tap="tap$COUNTER"
    bridge=br$net$tap

    ip link add $bridge type bridge
    ip addr flush dev $net
    ip link set $net master $bridge
    ip tuntap add dev $tap mode tap
    ip link set $tap master $bridge
    ip link set $bridge up
    ip link set $tap up

    # Enable LLDP
    echo 16384 > /sys/class/net/$bridge/bridge/group_fwd_mask

    NETDEVS="$NETDEVS -netdev tap,id=dev$COUNTER,ifname=$tap,script=no,downscript=no -device virtio-net-pci,netdev=dev$COUNTER,id=swp$COUNTER1,mac=$(random_mac),multifunction=on,addr=6.$COUNTER"
    let COUNTER=COUNTER+1 
done


screen -d -m socat TCP-LISTEN:22,fork TCP:127.0.0.1:2022
screen -d -m socat UDP-LISTEN:161,fork UDP:127.0.0.1:2161
screen -d -m socat TCP-LISTEN:830,fork TCP:127.0.0.1:2830
screen -d -m socat TCP-LISTEN:8080,fork TCP:127.0.0.1:2880

random_mac () {
    hexchars="0123456789abcdef"
    end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )

    # QEMU OUI space - important to use this
    echo 52:54:00$end
}


/usr/bin/qemu-system-x86_64 \
 --enable-kvm \
 -cpu host \
 -display none \
 -machine pc \
 -m 2048 \
 -serial telnet:0.0.0.0:5000,server,nowait \
 -drive if=ide,file=/cvx-3.7.6.qcow2,index=0 \
 -net nic,model=virtio-net-pci,macaddr=$(random_mac) \
 -net user,net=10.0.0.0/24,tftp=/tftpboot,hostfwd=tcp::2022-10.0.0.15:22,hostfwd=udp::2161-10.0.0.15:161,hostfwd=tcp::2830-10.0.0.15:830,hostfwd=tcp::2880-10.0.0.15:8080 \
 $NETDEVS

