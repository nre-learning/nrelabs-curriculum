I created an "orig" image here, and I'm careful not to overwrite it when I'm copying the snapshotted qcow2 out of the container

```
qemu-img convert -f vmdk -O qcow2 ~/Code/Juniper/vrnetlab/vqfx/vqfx10k-re-15.1X53-D60.vmdk vqfx-orig.qcow2
```




qemu-system-x86_64 \
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





root
Juniper

clear
cli
configure
    
set system services ssh
set system services netconf ssh
set system services netconf rfc-compliant
delete system login user vagrant
set system login password change-type set-transitions minimum-changes 0
commit

set system login user antidote class super-user authentication plain-text-password

antidotepassword

set system root-authentication plain-text-password

antidotepassword

delete interfaces
set interfaces em0 unit 0 family inet address 10.0.0.15/24
set interfaces em1 unit 0 family inet address 169.254.0.2/24

commit


https://github.com/GNS3/gns3-gui/issues/725
(qemu) stop

(or system_powerdown - "stop" actually suspends)

(qemu) savevm speedy


(qemu) q

qemu-img snapshot -l vqfx.qcow2
