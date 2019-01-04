#!/bin/bash

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
 -hda /image/utility-vm -hdb /user-data.img \
 -device e1000,netdev=net0 \
 -netdev user,id=net0,hostfwd=tcp::2022-:22 \
 -fsdev local,security_model=passthrough,id=fsdev0,path=/antidote \
 -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
