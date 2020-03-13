#!/bin/bash

COUNTER=0
while [  $COUNTER -lt 10 ]; do

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

    let COUNTER=COUNTER+1 
done


screen -d -m socat TCP-LISTEN:22,fork TCP:127.0.0.1:2022
screen -d -m socat TCP-LISTEN:5001,fork TCP:127.0.0.1:5000
# screen -d -m socat UDP-LISTEN:161,fork UDP:127.0.0.1:2161
# screen -d -m socat TCP-LISTEN:830,fork TCP:127.0.0.1:2830
# screen -d -m socat TCP-LISTEN:8080,fork TCP:127.0.0.1:2880

random_mac () {
    hexchars="0123456789abcdef"
    end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )

    # QEMU OUI space - important to use this
    echo 52:54:00$end
}

/usr/bin/qemu-system-x86_64 \
 -display none \
 -machine pc \
 --enable-kvm \
 -monitor tcp:0.0.0.0:4000,server,nowait \
 -m 2048 \
 -serial telnet:0.0.0.0:5000,server,nowait \
 -drive if=ide,file=crpd.qcow2,index=0 \
 -device pci-bridge,chassis_nr=1,id=pci.1 \
 -device e1000,netdev=p10,mac=$(random_mac) \
 -netdev user,id=p10,net=10.0.0.0/24,tftp=/tftpboot,hostfwd=tcp::2022-10.0.0.15:22 \
 -device e1000,netdev=p01,mac=$(random_mac) \
 -netdev tap,ifname=tap0,id=p01,script=no,downscript=no \
 -device e1000,netdev=p02,mac=$(random_mac) \
 -netdev tap,ifname=tap1,id=p02,script=no,downscript=no
 -device e1000,netdev=p03,mac=$(random_mac) \
 -netdev tap,ifname=tap2,id=p03,script=no,downscript=no \
 -device e1000,netdev=p04,mac=$(random_mac) \
 -netdev tap,ifname=tap3,id=p04,script=no,downscript=no

