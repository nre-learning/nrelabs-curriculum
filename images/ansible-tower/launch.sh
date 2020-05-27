#!/bin/bash
qemu-system-x86_64 \
-enable-kvm \
-smp 2 \
-m 2048 \
-hda /tmp/hda.qcow2 \
-netdev user,hostname=ansible-tower,hostfwd=tcp::22-:22,hostfwd=tcp::80-:80,hostfwd=tcp::443-:443,id=net \
-device virtio-net-pci,netdev=net -vnc :0 \
-serial stdio