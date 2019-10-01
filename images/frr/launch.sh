#!/bin/bash

mount -o rw,remount /sys

random_mac () {
    hexchars="0123456789abcdef"
    end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )

    # QEMU OUI space - important to use this
    echo 52:54:00$end
}

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

    NETDEVS="$NETDEVS -netdev tap,id=dev$COUNTER,ifname=$tap,script=no,downscript=no -device virtio-net-pci,netdev=dev$COUNTER,id=eth$COUNTER1,mac=$(random_mac),multifunction=off,addr=3.$COUNTER1"
    let COUNTER=COUNTER+1 
done

printf "%s\n" $NETDEVS




/usr/bin/qemu-system-x86_64 \
 --enable-kvm \
 -cpu host \
 -display none \
 -machine q35 \
 -m 2048 \
 -serial telnet:0.0.0.0:5000,server,nowait \
 -monitor telnet:0.0.0.0:4000,server,nowait \
 -drive if=ide,file=/frr.qcow2,index=0 \
 -virtfs local,path=/antidote,security_model=passthrough,mount_tag=antidote \
 -netdev user,id=user,net=10.0.0.0/24,hostfwd=tcp::22-10.0.0.15:22,hostfwd=tcp::830-10.0.0.15:830 \
 -device virtio-net-pci,netdev=user,mac=$(random_mac),multifunction=on,addr=3.0 \
 $NETDEVS

