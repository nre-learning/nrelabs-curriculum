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
screen -d -m socat UDP-LISTEN:161,fork UDP:127.0.0.1:2161
screen -d -m socat TCP-LISTEN:830,fork TCP:127.0.0.1:2830
screen -d -m socat TCP-LISTEN:8080,fork TCP:127.0.0.1:2880

random_mac () {
    hexchars="0123456789abcdef"
    end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )

    # QEMU OUI space - important to use this
    echo 52:54:00$end
}

#  -loadvm speedy \

/usr/bin/qemu-system-x86_64 \
 -display \
 none \
 -machine \
 pc \
 -monitor \
 tcp:0.0.0.0:4000,server,nowait \
 -m \
 2048 \
 -serial \
 telnet:0.0.0.0:5000,server,nowait \
 -drive \
 if=ide,file=/vqfx.qcow2,index=0 \
 -device \
 pci-bridge,chassis_nr=1,id=pci.1 \
 -device \
 e1000,netdev=p00,mac=$(random_mac) \
 -netdev \
 user,id=p00,net=10.0.0.0/24,tftp=/tftpboot,hostfwd=tcp::2022-10.0.0.15:22,hostfwd=udp::2161-10.0.0.15:161,hostfwd=tcp::2830-10.0.0.15:830,hostfwd=tcp::2880-10.0.0.15:8080 \
 -device \
 e1000,netdev=vcp-int,mac=$(random_mac) \
 -netdev \
 tap,ifname=vcp-int,id=vcp-int,script=no,downscript=no \
 -device \
 e1000,netdev=dummy0,mac=$(random_mac) \
 -netdev \
 tap,ifname=dummy0,id=dummy0,script=no,downscript=no \
 -device \
 e1000,netdev=p01,mac=$(random_mac),bus=pci.1,addr=0x2 \
 -netdev \
 tap,id=p01,ifname=tap0,script=no,downscript=no \
 -device \
 e1000,netdev=p02,mac=$(random_mac),bus=pci.1,addr=0x3 \
 -netdev \
 tap,id=p02,ifname=tap1,script=no,downscript=no \
 -device \
 e1000,netdev=p03,mac=$(random_mac),bus=pci.1,addr=0x4 \
 -netdev \
 tap,id=p03,ifname=tap2,script=no,downscript=no \
 -device \
 e1000,netdev=p04,mac=$(random_mac),bus=pci.1,addr=0x5 \
 -netdev \
 tap,id=p04,ifname=tap3,script=no,downscript=no \
 -device \
 e1000,netdev=p05,mac=$(random_mac),bus=pci.1,addr=0x6 \
 -netdev \
 tap,id=p05,ifname=tap4,script=no,downscript=no \
 -device \
 e1000,netdev=p06,mac=$(random_mac),bus=pci.1,addr=0x7 \
 -netdev \
 tap,id=p06,ifname=tap5,script=no,downscript=no \
 -device \
 e1000,netdev=p07,mac=$(random_mac),bus=pci.1,addr=0x8 \
 -netdev \
 tap,id=p07,ifname=tap6,script=no,downscript=no \
 -device \
 e1000,netdev=p08,mac=$(random_mac),bus=pci.1,addr=0x9 \
 -netdev \
 tap,id=p08,ifname=tap7,script=no,downscript=no
