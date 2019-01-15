#!/bin/bash

mount -o rw,remount /sys

# COUNTER=0
# while [  $COUNTER -lt 8 ]; do

#     let COUNTER1=COUNTER+1

#     net="net$COUNTER1"
#     macvtap="macvtap$COUNTER"
#     bridge=br$net$tap

#     ip addr flush dev $net
#     ip link add link $net name $macvtap type macvtap
#     ip link set macvtap0 address 52:54:00:00:01:0"$COUNTER" up

#     # Enable LLDP
#     # echo 16384 > /sys/class/net/$bridge/bridge/group_fwd_mask

#     let COUNTER=COUNTER+1 
# done

# myip=$(ip address show dev eth0|grep 'inet '|awk '{print $2}')
# # bridge eth0 to em0 via macvtap passthru mode, remove ip and change mac address of eth0
# mymac=$(cat /sys/class/net/eth0/address)
# macchanger -A eth0
# ip link add link eth0 name em0 type macvtap mode passthru
# ip link set em0 address $mymac
# ip link set dev em0 up promisc on
# ip addr flush dev eth0
# IFS=: read major minor < <(cat /sys/devices/virtual/net/em0/tap*/dev)
# mknod "/dev/em0" c $major $minor


random_mac () {
    hexchars="0123456789abcdef"
    end=$( for i in {1..6} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )

    # QEMU OUI space - important to use this
    echo 52:54:00$end
}

NETDEVS=""
index=0
mnetlist=$(ls /sys/class/net | grep net | grep -v vtap)

echo "walking the network list $mnetlist"
maxmtu=1500
for mnet in $mnetlist; do
  mymac=$(cat /sys/class/net/$mnet/address)
#   mymac=$(random_mac)
  mtu=$(cat /sys/devices/virtual/net/$mnet/mtu)
  if [ $mtu > $maxmtu ]; then
    maxmtu=$mtu
  fi
  macchanger -A $mnet
  echo "ip link add link $mnet name vtap$mnet type macvtap mode passthru"
  ip link add link $mnet name vtap$mnet type macvtap mode passthru
  echo "setting mac address to $mymac on vtap$mnet"
  ip link set vtap$mnet address $mymac
  ip link set dev vtap$mnet mtu $mtu
  ip addr flush dev $mnet
  # create dev file (there is no udev in container: need to be done manually)
  IFS=: read major minor < <(cat /sys/devices/virtual/net/vtap$mnet/tap*/dev)
  mknod "/dev/vtap$mnet" c $major $minor
  ip link show dev vtap$mnet
  ip link set dev vtap$mnet up promisc on
  let fd=$index+8
  let vfd=$index+4
  let ione=$index+8
  NETDEVS="$NETDEVS -netdev tap,id=gnet$index,vhost=on,fd=${fd},vhostfd=${vfd} ${fd}<>/dev/vtap$mnet ${vfd}<>/dev/vhost-net -device e1000,netdev=gnet$index,mac=$mymac,bus=pci.1,addr=0x$ione"
  # echo "groups { openjnpr-container-vmx { interfaces { xe-0/0/$index { description "$eth"; mac $mymac; mtu $mtu; unit 0; }}}}" >> /tmp/$CONFIG
  index=$(($index +1))
done

echo "----NETDEVS-----"
echo $NETDEVS
echo "----------------"


screen -d -m socat TCP-LISTEN:22,fork TCP:127.0.0.1:2022
screen -d -m socat UDP-LISTEN:161,fork UDP:127.0.0.1:2161
screen -d -m socat TCP-LISTEN:830,fork TCP:127.0.0.1:2830
screen -d -m socat TCP-LISTEN:8080,fork TCP:127.0.0.1:2880

get_tapdev () {
    tapindex=$(< /sys/class/net/$1/ifindex)
    tapdev=/dev/tap"$tapindex"

    echo $tapdev
}



# after ide


#  --enable-kvm \

# when on gcloud
# echo 16384 | sudo tee -a /sys/class/net/12-jjtigg867g/bridge/group_fwd_mask

# tcpdump -i net1 ether proto 0x88cc


# eval exec qemu-system-x86_64 -M pc --enable-kvm -cpu host  -smp 1 -m $VCPMEM \
#   -no-user-config \
#   -no-shutdown \
#   -smbios type=0,vendor=Juniper \
#   -drive if=ide,file=$VCPIMAGE -drive if=ide,file=$HDDIMAGE -drive if=ide,file=$CFGDRIVE \
#   -netdev tap,fd=7,id=tc0,vhost=on 7<>/dev/em0 -device virtio-net-pci,netdev=tc0,mac=$mymac \
#   -netdev type=tap,id=tc1,ifname=em1,script=no,downscript=no -device virtio-net-pci,netdev=tc1 \
#   -netdev type=tap,id=tc2,ifname=em2,script=no,downscript=no -device virtio-net-pci,netdev=tc2 \

HDDIMAGE="/tmp/vmxhdd.img"
echo "Creating empty $HDDIMAGE for VCP ..."
qemu-img create -f qcow2 $HDDIMAGE 4G >/dev/null

CFGDRIVE=/tmp/configdrive.qcow2
echo "Creating config drive $CFGDRIVE"
export YANG_SCHEMA YANG_DEVIATION YANG_ACTION YANG_PACKAGE
/create_config_drive.sh $CFGDRIVE /vqfx.conf

# Creating config drive /tmp/configdrive.qcow2
# METADISK=/tmp/configdrive.qcow2 CONFIG=/vqfx.conf LICENSE=
# Creating config drive (configdrive.img) ...
# adding config file /vqfx.conf
# /create_config_drive.sh: line 127: mkfs.vfat: command not found
# mount: wrong fs type, bad option, bad superblock on /dev/loop0,
#        missing codepage or helper program, or other error
#        In some cases useful info is found in syslog - try
#        dmesg | tail or so.
# umount: /mnt: not mounted
# -rw-r--r--. 1 root root 196616 Jan 15 07:00 /tmp/configdrive.qcow2


eval /usr/bin/qemu-system-x86_64 \
 -display none \
 -machine pc \
 -m 2048 \
 -monitor tcp:0.0.0.0:4000,server,nowait \
 -serial telnet:0.0.0.0:5000,server,nowait \
 -drive if=ide,file=/vqfx.qcow2 -drive if=ide,file=$HDDIMAGE -drive if=ide,file=$CFGDRIVE \
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
 $NETDEVS


 # GOLD
# -netdev tap,id=gnet0,vhost=on,fd=8,vhostfd=4 8<>/dev/vtapnet1 4<>/dev/vhost-net
# -device virtio-net-pci,netdev=gnet0,mac=02:64:f1:c7:02:cb,bus=pci.1,addr=0x8
# -netdev tap,id=gnet1,vhost=on,fd=9,vhostfd=5 9<>/dev/vtapnet2 5<>/dev/vhost-net
# -device virtio-net-pci,netdev=gnet1,mac=06:eb:b7:64:4f:18,bus=pci.1,addr=0x9
#####

#  -device \
#  virtio-net-pci,netdev=p08,mac=$(random_mac) \
#  -netdev \
#  tap,id=p08,ifname=tap7,script=no,downscript=no


sleep 100000










# ----NETDEVS-----
# -netdev tap,fd=8,id=gnet0,vhost=on 8<>/dev/vtap
# -device virtio-net-pci,netdev=net0,mac=52:54:00:ad:1c:7a,bus=pci.8,addr=0x7,host_mtu=1500

# -netdev tap,fd=9,id=gnet1,vhost=on 9<>/dev/vtap
# -device virtio-net-pci,netdev=net1,mac=52:54:00:b6:95:1f,bus=pci.9,addr=0x7,host_mtu=1500
# ----------------
# qemu-system-x86_64: -netdev tap,fd=8,id=gnet0,vhost=on: TUNGETIFF ioctl() failed: Inappropriate ioctl for device
# TUNSETOFFLOAD ioctl() failed: Inappropriate ioctl for device
# qemu-system-x86_64: -netdev tap,fd=9,id=gnet1,vhost=on: TUNGETIFF ioctl() failed: Inappropriate ioctl for device
# TUNSETOFFLOAD ioctl() failed: Bad address
# qemu-system-x86_64: -netdev tap,fd=8,id=gnet0,vhost=on: drive with bus=0, unit=0 (index=0) exists



# ----NETDEVS-----
# -netdev tap,fd=8,id=gnet0,vhost=on 8<>/dev/vtapnet1
# -device virtio-net-pci,netdev=net0,mac=52:54:00:cc:e6:17,bus=pci.8,addr=0x7,host_mtu=1500

# -netdev tap,fd=9,id=gnet1,vhost=on 9<>/dev/vtapnet2
# -device virtio-net-pci,netdev=net1,mac=52:54:00:78:78:73,bus=pci.9,addr=0x7,host_mtu=1500
# ----------------
# qemu-system-x86_64: -netdev tap,fd=8,id=gnet0,vhost=on: TUNGETIFF ioctl() failed: Inappropriate ioctl for device
# TUNSETOFFLOAD ioctl() failed: Inappropriate ioctl for device
# qemu-system-x86_64: -netdev tap,fd=9,id=gnet1,vhost=on: TUNGETIFF ioctl() failed: Inappropriate ioctl for device
# TUNSETOFFLOAD ioctl() failed: Bad address
# qemu-system-x86_64: -netdev tap,fd=8,id=gnet0,vhost=on: drive with bus=0, unit=0 (index=0) exists