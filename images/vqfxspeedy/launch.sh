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
 -loadvm speedy \
 -device \
 pci-bridge,chassis_nr=1,id=pci.1 \
 -device \
 e1000,netdev=p00,mac=52:54:00:d1:63:00 \
 -netdev \
 user,id=p00,net=10.0.0.0/24,tftp=/tftpboot,hostfwd=tcp::2022-10.0.0.15:22,hostfwd=udp::2161-10.0.0.15:161,hostfwd=tcp::2830-10.0.0.15:830 \
 -device \
 e1000,netdev=vcp-int,mac=52:54:00:25:b2:01 \
 -netdev \
 tap,ifname=vcp-int,id=vcp-int,script=no,downscript=no \
 -device \
 e1000,netdev=dummy0,mac=52:54:00:eb:fa:01 \
 -netdev \
 tap,ifname=dummy0,id=dummy0,script=no,downscript=no \
 -device \
 e1000,netdev=p01,mac=52:54:00:a2:1e:01,bus=pci.1,addr=0x2 \
 -netdev \
 tap,id=p01,ifname=tap0,script=no,downscript=no \
 -device \
 e1000,netdev=p02,mac=52:54:00:86:b3:02,bus=pci.1,addr=0x3 \
 -netdev \
 tap,id=p02,ifname=tap1,script=no,downscript=no \
 -device \
 e1000,netdev=p03,mac=52:54:00:86:b3:03,bus=pci.1,addr=0x4 \
 -netdev \
 tap,id=p03,ifname=tap2,script=no,downscript=no \
 -device \
 e1000,netdev=p04,mac=52:54:00:86:b3:04,bus=pci.1,addr=0x5 \
 -netdev \
 tap,id=p04,ifname=tap3,script=no,downscript=no \
 -device \
 e1000,netdev=p05,mac=52:54:00:86:b3:05,bus=pci.1,addr=0x6 \
 -netdev \
 tap,id=p05,ifname=tap4,script=no,downscript=no \
 -device \
 e1000,netdev=p06,mac=52:54:00:86:b3:06,bus=pci.1,addr=0x7 \
 -netdev \
 tap,id=p06,ifname=tap5,script=no,downscript=no \
 -device \
 e1000,netdev=p07,mac=52:54:00:86:b3:07,bus=pci.1,addr=0x8 \
 -netdev \
 tap,id=p07,ifname=tap6,script=no,downscript=no \
 -device \
 e1000,netdev=p08,mac=52:54:00:86:b3:08,bus=pci.1,addr=0x9 \
 -netdev \
 tap,id=p08,ifname=tap7,script=no,downscript=no
