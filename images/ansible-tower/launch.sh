#!/bin/bash
qemu-system-x86_64 \
-enable-kvm \
-smp 2 \
-m 2048 \
-hda /output/build/centos-8-amd64.qcow2 \
-netdev user,hostname=ansible-tower,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80,hostfwd=tcp::8443-:443,id=net \
-device virtio-net-pci,netdev=net -vnc :0 \
-serial stdio