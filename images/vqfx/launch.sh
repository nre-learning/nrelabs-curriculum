#!/bin/bash

mount -o rw,remount /sys

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
    ip link set $tap up promisc on
    ip link set $tap master $bridge
    ip link set $bridge up
    ip link set $tap up

    # Enable LLDP
    echo 16384 > /sys/class/net/$bridge/bridge/group_fwd_mask

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

# after ide


#  --enable-kvm \

# when on gcloud
# echo 16384 | sudo tee -a /sys/class/net/12-jjtigg867g/bridge/group_fwd_mask

# tcpdump -i net1 ether proto 0x88cc

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
 e1000,netdev=p00,mac=52:54:00:7f:60:55 \
 -netdev \
 user,id=p00,net=10.0.0.0/24,tftp=/tftpboot,hostfwd=tcp::2022-10.0.0.15:22,hostfwd=udp::2161-10.0.0.15:161,hostfwd=tcp::2830-10.0.0.15:830,hostfwd=tcp::2880-10.0.0.15:8080 \
 -device \
 e1000,netdev=vcp-int,mac=52:54:00:ae:ac:c2 \
 -netdev \
 tap,ifname=vcp-int,id=vcp-int,script=no,downscript=no \
 -device \
 e1000,netdev=dummy0,mac=52:54:00:c0:bc:34 \
 -netdev \
 tap,ifname=dummy0,id=dummy0,script=no,downscript=no \
 -device \
 e1000,netdev=p01,mac=52:54:00:d5:23:41,bus=pci.1,addr=0x2 \
 -netdev \
 tap,id=p01,ifname=tap0,script=no,downscript=no \
 -device \
 e1000,netdev=p02,mac=52:54:00:a0:98:f2,bus=pci.1,addr=0x3 \
 -netdev \
 tap,id=p02,ifname=tap1,script=no,downscript=no \
 -device \
 e1000,netdev=p03,mac=52:54:00:6e:19:fd,bus=pci.1,addr=0x4 \
 -netdev \
 tap,id=p03,ifname=tap2,script=no,downscript=no \
 -device \
 e1000,netdev=p04,mac=52:54:00:2c:86:f4,bus=pci.1,addr=0x5 \
 -netdev \
 tap,id=p04,ifname=tap3,script=no,downscript=no \
 -device \
 e1000,netdev=p05,mac=52:54:00:c4:e2:e1,bus=pci.1,addr=0x6 \
 -netdev \
 tap,id=p05,ifname=tap4,script=no,downscript=no \
 -device \
 e1000,netdev=p06,mac=52:54:00:b0:e3:5d,bus=pci.1,addr=0x7 \
 -netdev \
 tap,id=p06,ifname=tap5,script=no,downscript=no \
 -device \
 e1000,netdev=p07,mac=52:54:00:37:b1:cb,bus=pci.1,addr=0x8 \
 -netdev \
 tap,id=p07,ifname=tap6,script=no,downscript=no \
 -device \
 e1000,netdev=p08,mac=52:54:00:5f:46:19,bus=pci.1,addr=0x9 \
 -netdev \
 tap,id=p08,ifname=tap7,script=no,downscript=no



# show interfaces em0 | match Current
# show interfaces em1 | match Current
# show interfaces em2 | match Current
# show interfaces em3 | match Current
# show interfaces em4 | match Current
# show interfaces em5 | match Current
# show interfaces em6 | match Current
# show interfaces em7 | match Current
# show interfaces em8 | match Current
# show interfaces em9 | match Current
# show interfaces em10 | match Current



sleep 100000






# {master:0}
# root@vqfx2> show interfaces em0 | match Current
#   Current address: 52:54:00:7f:60:55, Hardware address: 

# {master:0}
# root@vqfx2> show interfaces em1 | match Current
#   Current address: 52:54:00:ae:ac:c2, Hardware address: 

# {master:0}
# root@vqfx2> show interfaces em2 | match Current
#   Current address: 52:54:00:c0:bc:34, Hardware address: 

# {master:0}
# root@vqfx2> show interfaces em3 | match Current
#   Current address: 52:54:00:d5:23:41, Hardware address: 

# {master:0}
# root@vqfx2> show interfaces em4 | match Current
#   Current address: 52:54:00:a0:98:f2, Hardware address: 

# {master:0}
# root@vqfx2> show interfaces em5 | match Current
#   Current address: 52:54:00:6e:19:fd, Hardware address: 

# {master:0}
# root@vqfx2> show interfaces em6 | match Current
#   Current address: 52:54:00:2c:86:f4, Hardware address: 

# {master:0}
# root@vqfx2> show interfaces em7 | match Current
#   Current address: 52:54:00:c4:e2:e1, Hardware address: 

# {master:0}
# root@vqfx2> show interfaces em8 | match Current
#   Current address: 52:54:00:b0:e3:5d, Hardware address: 

# {master:0}
# root@vqfx2> show interfaces em9 | match Current
#   Current address: 52:54:00:37:b1:cb, Hardware address: 

# {master:0}
# root@vqfx2> show interfaces em10 | match Current
#   Current address: 52:54:00:5f:46:19, Hardware address: 




