#!/bin/bash
# Copyright (c) 2018, Juniper Networks, Inc.
# All rights reserved.
#
echo "Juniper Networks vQFX Docker Light Container"

VCPMEM="${VCPMEM:-1024}"  # default memory for VCP: 1024MB
VCPU="${VCPU:-1}"         # default # of cpus for VCP: 1
WAITFOR="${WAITFOR:-eth0}"

set -e # exit immediately if something goes wrong

echo "/u contains the following files:"
ls /u

if [ -z "$IMAGE" ]; then
  # no image given, check if we have one in /u
  IMAGE=$(cd /u && ls jinstall*img | tail -1)
fi

if [ ! -f "/u/$IMAGE" ]; then
  echo "vMX file /u/$IMAGE not found"
  exit 1
fi


if [[ "$IMAGE" =~ \.img$ ]]; then
  echo "using qcow2 image $IMAGE"
  cp /u/$IMAGE /tmp/
  VCPIMAGE=$(basename $IMAGE)
else
  echo "$IMAGE isn't a qcow2 image"
  exit 1
fi
RELEASE=$(echo "$VCPIMAGE" | cut -d- -f5| cut -d. -f1,2,3)

until ip link show $WAITFOR; do
  echo "waiting for $WAITFOR to be attached ..."
  sleep 5
done

# fix network interface order due to https://github.com/docker/compose/issues/4645
/fix_network_order.sh

rootpassword=$(pwgen 24 1)
hostname=$(docker ps --format '{{.Names}}' -f id=$HOSTNAME)
hostname="${hostname:-$HOSTNAME}"
myip=$(ip address show dev eth0|grep 'inet '|awk '{print $2}')
myipv6=$(ip addr show dev eth0 | awk '/inet6/ {print $2}' | head -1)
echo "Interface $eth IPv6 address $myipv6"
# bridge eth0 to em0 via macvtap passthru mode, remove ip and change mac address of eth0
echo "Bridging $eth ($myipmask/$mymac) with em0"
mymac=$(cat /sys/class/net/eth0/address)
macchanger -A eth0
ip link add link eth0 name em0 type macvtap mode passthru
ip link set em0 address $mymac
ip link set dev em0 up promisc on
ip addr flush dev eth0
IFS=: read major minor < <(cat /sys/devices/virtual/net/em0/tap*/dev)
mknod "/dev/em0" c $major $minor

export rootpassword hostname myip myipv6

# augment junos config with apply group, which gets applied if no config provided
# (apply-group statement is assumed to be present in existing config, allowing a user
# to not apply it at all)
CONFIG="${CONFIG-config.txt}"
if [ -f /u/$CONFIG ]; then
  source=$CONFIG
  CONFIG=$(basename $CONFIG)
  cp /u/$source /tmp/$CONFIG
else
  echo "apply-groups openjnpr-container-vmx;" > /tmp/$CONFIG
fi
/create_apply_group.sh >> /tmp/$CONFIG

ip=$(echo "$myip" | cut -d/ -f1)
echo "-----------------------------------------------------------------------"
echo "$hostname ($ip) $RELEASE root password $rootpassword"
echo "-----------------------------------------------------------------------"
echo ""


if [ -n "$HDDIMAGE" ]; then
  # HDDIMAGE defined
  if [ -w "$HDDIMAGE" ]; then
   echo "reusing existing $HDDIMAGE"
   PERSIST="persist"
  else
   echo "Creating $HDDIMAGE for VCP ..."
   qemu-img create -f qcow2 $HDDIMAGE 4G >/dev/null
  fi
else
 HDDIMAGE="/tmp/vmxhdd.img"
 echo "Creating empty $HDDIMAGE for VCP ..."
 qemu-img create -f qcow2 $HDDIMAGE 4G >/dev/null
fi


NETDEVS=""
index=0
ethlist=$(ls /sys/class/net | grep eth |grep -v eth0)

echo "walking the network list $ethlist"
maxmtu=1500
for eth in $ethlist; do
  mymac=$(cat /sys/class/net/$eth/address)
  mtu=$(cat /sys/devices/virtual/net/$eth/mtu)
  if [ $mtu > $maxmtu ]; then
    maxmtu=$mtu
  fi
  macchanger -A $eth
  ip link add link $eth name vtap$eth type macvtap mode passthru
  echo "setting mac address to $mymac on vtap$eth"
  ip link set vtap$eth address $mymac
  ip link set dev vtap$eth mtu $mtu
  ip addr flush dev $eth
  # create dev file (there is no udev in container: need to be done manually)
  IFS=: read major minor < <(cat /sys/devices/virtual/net/vtap$eth/tap*/dev)
  mknod "/dev/vtap$eth" c $major $minor
  ip link show dev vtap$eth
  ip link set dev vtap$eth up promisc on
  let fd=$index+8
  NETDEVS="$NETDEVS -netdev tap,fd=$fd,id=net$index,vhost=on ${fd}<>/dev/vtap$eth -device virtio-net-pci,netdev=net$index,mac=$mymac,host_mtu=$mtu"
  echo "groups { openjnpr-container-vmx { interfaces { xe-0/0/$index { description "$eth"; mac $mymac; mtu $mtu; unit 0; }}}}" >> /tmp/$CONFIG
  index=$(($index +1))
done

# create em1 used to connect vQFX RE VM and PFE cosim
ip tuntap add dev em1 mode tap
ip link set dev em1 mtu $maxmtu
ip addr add 169.254.0.1/24 dev em1
ethtool --offload em1 tx off
ip link set em1 up promisc on

# unused em2 port we need to add to vQFX
ip tuntap add dev em2 mode tap
ip link set up em2

echo "========="
echo "NETDEVS=$NETDEVS"
echo "highest mtu $maxmtu"
echo "========="
ip link 

echo "Creating config drive $CFGDRIVE"
CFGDRIVE=/tmp/configdrive.qcow2
export YANG_SCHEMA YANG_DEVIATION YANG_ACTION YANG_PACKAGE
/create_config_drive.sh $CFGDRIVE /tmp/$CONFIG /u/$LICENSE 

echo "Starting cosim ..."
chmod u+rwx,go+rx-w /root/pecosim/pecosim_autorun.sh
/root/pecosim/pecosim_autorun.sh &


echo "Booting VCP ..."
cd /tmp/
eval exec qemu-system-x86_64 -M pc --enable-kvm -cpu host  -smp 1 -m $VCPMEM \
  -no-user-config \
  -no-shutdown \
  -smbios type=0,vendor=Juniper \
  -drive if=ide,file=$VCPIMAGE -drive if=ide,file=$HDDIMAGE -drive if=ide,file=$CFGDRIVE \
  -netdev tap,fd=7,id=tc0,vhost=on 7<>/dev/em0 -device virtio-net-pci,netdev=tc0,mac=$mymac \
  -netdev type=tap,id=tc1,ifname=em1,script=no,downscript=no -device virtio-net-pci,netdev=tc1 \
  -netdev type=tap,id=tc2,ifname=em2,script=no,downscript=no -device virtio-net-pci,netdev=tc2,host_mtu=$maxmtu \
  $NETDEVS \
  -nographic || true