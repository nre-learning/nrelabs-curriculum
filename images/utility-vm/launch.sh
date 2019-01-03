#!/bin/bash

# COUNTER=0
# while [  $COUNTER -lt 1 ]; do

#     let COUNTER1=COUNTER+1

#     net="net$COUNTER1"
#     tap="tap$COUNTER"
#     bridge=br$net$tap

#     ip link add bridge0 type bridge
#     ip addr flush dev $net
#     ip link set $net master $bridge
#     ip tuntap add dev $tap mode tap
#     ip link set $tap master $bridge
#     ip link set $bridge up
#     ip link set $tap up

#     let COUNTER=COUNTER+1 
# done


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
 -display \
 none \
 -machine \
 pc \
 -monitor \
 tcp:0.0.0.0:4000,server,nowait \
 -m \
 512 \
 -serial \
 telnet:0.0.0.0:5000,server,nowait \
 -hda /ubuntu.img -hdb /user-data.img \
 -device \
 pci-bridge,chassis_nr=1,id=pci.1 \
 -device \
 e1000,netdev=p00,mac=$(random_mac) \
 -netdev \
 user,id=p00,net=10.0.0.0/24,tftp=/tftpboot,hostfwd=tcp::2022-10.0.0.15:22,hostfwd=udp::2161-10.0.0.15:161,hostfwd=tcp::2830-10.0.0.15:830,hostfwd=tcp::2880-10.0.0.15:8080 \

