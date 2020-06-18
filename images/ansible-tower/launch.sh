#!/bin/bash

random_mac () {
    hexchars="0123456789abcdef"
    end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )

    # QEMU OUI space - important to use this
    echo 52:54:00$end
}


qemu-system-x86_64 \
-enable-kvm \
-smp 2 \
-m 2048 \
-hda /output/build/centos-8-amd64.qcow2 \
-netdev user,hostname=ansible-tower,hostfwd=tcp::22-:22,hostfwd=tcp::80-:80,hostfwd=tcp::443-:443,id=net \
-device virtio-net-pci,netdev=net -vnc :0 \
-serial stdio
