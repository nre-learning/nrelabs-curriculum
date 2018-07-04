#!/bin/bash
# Copyright (c) 2017, Juniper Networks, Inc.
# All rights reserved.
#

VCPMEM="${VCPMEM:-1024}"
VCPU="${VCPU:-1}"

echo "Juniper Networks vMX Docker Light Container"

set -e # exit immediately if something goes wrong
/system_check.sh

echo "/u contains the following files:"
ls /u

while getopts "c:m:l:V:ep:i:" opt; do
  case "$opt" in
    V)  VCPCPU=$OPTARG
      ;;
    m)  VCPMEM=$OPTARG
      ;;
    e)  EMULATED=1
      ;;
    p)  PUBLICKEY=$OPTARG
      ;;
    c)  CONFIG=$OPTARG
      ;;
    i)  LO_IP=$OPTARG
      ;;
    l)  LICENSE=$OPTARG
      ;;
  esac
done

CONFIG="${CONFIG-config.txt}"

shift "$((OPTIND-1))"

if [ ! -z "$1" ]; then
  IMAGE=$1
  shift
fi

if [ -z "$IMAGE" ]; then
  # no image given, check if we have one in /u
  IMAGE=$(cd /u && ls junos-*qcow2 | tail -1)
fi

if [ ! -f "/u/$IMAGE" ]; then
  echo "vMX file $IMAGE not found"
  exit 1
fi

if [ -z "$PUBLICKEY" ]; then
  PUBLICKEY=$(cd /u && ls id_*.pub | tail -1)
fi

if [ -z "$LICENSE" ]; then
  LICENSE=$(cd /u && ls license*txt | tail -1)
fi

if [ ! -f "/u/$PUBLICKEY" ]; then
  echo "WARNING: Can't read ssh public key file $PUBLICKEY"
  echo "Access limited to root password"
else
  SSHPUBLIC=$(cat /u/$PUBLICKEY)
fi

if [ ! -z "$PCI" ]; then
    echo -n "checking for igb_uio kernel module ..."
    ls /sys/bus/pci/drivers/igb_uio/ >/dev/null 2>/dev/null
    echo "ok"
fi

for pci in $PCI; do
    if [ ${#pci} -lt 8 ]; then
        pci="0000:$pci"
    fi
    if [ -e "/sys/bus/pci/drivers/igb_uio/$pci" ]; then
        echo "$pci already bound to igb_uio"
    else
        echo -n "Binding $pci to igb_uio ..."
        echo -n $pci > /sys/bus/pci/drivers/ixgbe/unbind || true
        echo -n "8086 10fb" > /sys/bus/pci/drivers/igb_uio/new_id
        if [ -e "/sys/bus/pci/drivers/igb_uio/$pci" ]; then
            echo "$pci bound to igb_uio"
        else
            echo -n $pci > /sys/bus/pci/drivers/igb_uio/bind
        fi
        echo "done"
    fi
done


# fix network interface order due to https://github.com/docker/compose/issues/4645
ifconfig -a
/fix_network_order.sh
ifconfig -a
ip route
ip -6 route

ROOTPASSWORD=$(pwgen 24 1)
SALT=$(pwgen 8 1)
HASH=$(openssl passwd -1 -salt $SALT $ROOTPASSWORD)
myip=$(ifconfig eth0|grep 'inet addr'|cut -d: -f2|awk '{print $1}')
# there is a small chance of getting 2 global IPv6 addresses temporarly, pick just the last one with tail -1
myipv6=$(ifconfig eth0|grep Global|awk '{print $3}'|tail -1|cut -d/ -f1)
# extract container name via id 
hostname=$(docker ps --format '{{.Names}}' -f id=$HOSTNAME || echo $HOSTNAME)
if [ -z "$hostname" ]; then
  hostname=$HOSTNAME
fi

if [ "$LO_IP" -ge 1 -a "$LO_IP" -le 255 ]; then
 id=$LO_IP
else
  id=$(echo $hostname|rev | cut -d'_' -f 1 | rev)   # get index, e.g. 3 from vmxdockerlight_vmx_3
fi
echo "Loopback IP last octet: $id"

export myip myipv6 hostname id
echo "-----------------------------------------------------------------------"
echo "vMX $hostname ($myip $myipv6) root password to $ROOTPASSWORD"
echo "-----------------------------------------------------------------------"
echo ""

if [[ "$IMAGE" =~ \.qcow2$ ]]; then
  echo "using qcow2 image $IMAGE"
  cp /u/$IMAGE /tmp/
  VCPIMAGE=$IMAGE
else
  echo "extracting qcow2 image from $IMAGE ..."
  tar zxvf /u/$IMAGE -C /tmp/ --wildcards vmx/images/junos*qcow2 2>/dev/null
  VCPIMAGE=$(ls /tmp/vmx*/images/junos*qcow2)
  mv $VCPIMAGE /tmp/
  VCPIMAGE=${VCPIMAGE##*/}
fi

if [ ! -f "/u/$LICENSE" ]; then
  echo "Warning: No license file found ($LICENSE)"
fi
echo "LICENSE=$LICENSE"

until ifconfig eth0; do
  echo "waiting for eth0 to be attached ..."
  sleep 5
done

# instead of using rcp, this method uses scp instead by
# creating a local ssh keypair and adding it to the junos config
#ln -s /usr/bin/scp /usr/bin/rcp
#ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ''
#PUBKEY=$(cat /root/.ssh/id_rsa.pub)
#cp /u/$CONFIG /tmp/
#cat >> /tmp/$CONFIG <<EOF
#groups {
#  coldboot {
#    system {
#      root-authentication {
#        ssh-rsa "$PUBKEY";
#      }
#    }
#  }
#}
#apply-groups coldboot;
#EOF

# loop thru ethernet interfaces and bridge eth0 to tap fxp0, remove its IP
# and build matching junos config

ethlist=$(netstat -i|grep eth|cut -d' ' -f1 | paste -sd " " -)
echo "ethernet interfaces: $ethlist"

cat > /tmp/$CONFIG <<EOF
system {
  host-name $hostname;
  root-authentication {
    encrypted-password "$HASH";
  }
  configuration-database {
    ephemeral {
      instance vfp0;
    }
  }
  services {
    ssh {
      client-alive-interval 30;
    }
    netconf {
      ssh;
    }
  }
}
EOF

# append user provided config. Doing this after our initial settings ubove
# allows a user to overwrite our defaults, like host-name
if [ -f /u/$CONFIG ]; then
  # replace any environment variable found in the config with its value
  # useful e.g. to add $id number to an IP address
  envsubst < /u/$CONFIG >> /tmp/$CONFIG
fi

if [ ! -z "$SSHPUBLIC" ]; then
  SSHUSER=$(echo $SSHPUBLIC | cut -d' ' -f3 | cut -d'@' -f1)
  if [ $SSHUSER == 'root' ]; then
    SSHUSER="lab"
  fi
  echo "adding super-user $SSHUSER with public key $SSHPUBLIC to config"
  cat >> /tmp/$CONFIG <<EOF
system {
  root-authentication {
    ssh-rsa "$SSHPUBLIC";
  }
}
groups {
  vmx-docker-light {
    system {
      login {
        user $SSHUSER {
          class super-user;
          authentication {
            encrypted-password "$HASH";
            ssh-rsa "$SSHPUBLIC";
          }
        }
      }
EOF
else
  cat >> /tmp/$CONFIG <<EOF
groups {
  vmx-docker-light {
    system {
EOF
fi
cat >> /tmp/$CONFIG <<EOF
      syslog {
        file messages {
          any notice;
        }
      }
    }
    protocols {
      lldp {
         interface all;
       }
     }
    interfaces {
EOF

ifdescrlist=$(docker inspect --format='{{range $p, $conf := .NetworkSettings.Networks}} {{$p}}  {{end}}' $HOSTNAME || echo "")
echo "ifdescr array = $ifdescrlist"
IFS=' ' read -r -a ifdarray <<< "$ifdescrlist"

mygw=$(ip -4 route list 0/0 |cut -d' ' -f3)

index=0
ifdindex=0
for eth in $ethlist; do
  echo "$eth ..."
  myip=$(ifconfig $eth|grep 'inet addr'|cut -d: -f2|awk '{print $1}')
  myipmask=$(ip -o -f inet addr show $eth |awk '{print $4}')
  myip6mask=$(ifconfig $eth|grep Global|tail -1|awk '{print $3}')
  if [ -z "$myipmask" ]; then
    ip4cfg=""
  else
    ip4cfg="family inet { address $myipmask; }"
  fi
  echo "Interface $eth IPv6 address $myip6mask"
  if [ -z "$myip6mask" ]; then
    ip6cfg=""
  else
    ip6cfg="family inet6 { address $myip6mask; }"
  fi
  ifdescr="${ifdarray[$ifdindex]}"
  ifdindex=$(($ifdindex + 1))
  echo "ifdescr=$ifdescr"
  if [ "eth0" == $eth ]; then
    mymac=$(ifconfig $eth |grep HWaddr|awk {'print $5'})
    echo "Bridging $eth ($myipmask/$mymac) with fxp0"
    brctl addbr br-ext
    ip link set up br-ext
    ip tuntap add dev fxp0 mode tap
    ifconfig fxp0 up promisc
    macchanger -A eth0
    brctl addif br-ext eth0
    brctl addif br-ext fxp0
    echo "$eth -> fxp0"
    cat >> /tmp/$CONFIG <<EOF
      fxp0 {
        description "$eth-$ifdescr"
        unit 0 {
          $ip4cfg
          $ip6cfg
        }
      }
EOF
  else
    echo "$eth -> ge-0/0/$index"
    if [ -z "$NOIP" ]; then
      cat >> /tmp/$CONFIG <<EOF
      ge-0/0/$index {
        description "$eth-$ifdescr"
        unit 0 {
          $ip4cfg
          $ip6cfg
        }
      }
EOF
    else
      cat >> /tmp/$CONFIG <<EOF
      ge-0/0/$index {
        description "$eth-$ifdescr"
      }
EOF
    fi
    index=$(($index + 1))
  fi
  ip addr flush dev $eth
done

if [ ! -z "$mygw" ]; then
  cat >> /tmp/$CONFIG <<EOF
    }
    routing-options {
      static {
        route 0.0.0.0/0 next-hop $mygw;
      }
    }
EOF
else
  cat >> /tmp/$CONFIG <<EOF
   }
EOF
fi

nameservers=$(grep nameserver /etc/resolv.conf | grep -v ' 127' | awk '{print $2}')
if [ ! -z "$nameservers" ]; then
  echo "system { name-server {" >> /tmp/$CONFIG 
  for nameserver in $nameservers; do
    echo "  $nameserver;" >> /tmp/$CONFIG
  done 
  echo "} }" >> /tmp/$CONFIG 
fi

cat >> /tmp/$CONFIG <<EOF
 }
}
apply-groups vmx-docker-light;
EOF

brctl addbr br-int
ip addr add 128.0.0.16/8 dev br-int
ip link set up br-int
#tunctl -t em1
ip tuntap add dev em1 mode tap
ifconfig em1 up promisc
brctl addif br-int em1
brctl show

# Extra interfaces from multus

brctl addbr br-net0
ip addr add 129.0.0.16/8 dev br-net0
ip link set up br-net0
ip tuntap add dev em2 mode tap
ifconfig em2 up promisc
brctl addif br-net0 em2
brctl addif br-net0 net0
brctl show

brctl addbr br-net1
ip addr add 130.0.0.16/8 dev br-net1
ip link set up br-net1
ip tuntap add dev em3 mode tap
ifconfig em3 up promisc
brctl addif br-net1 em3
brctl show

brctl addbr br-net2
ip addr add 131.0.0.16/8 dev br-net2
ip link set up br-net2
ip tuntap add dev em4 mode tap
ifconfig em4 up promisc
brctl addif br-net2 em4
brctl show

brctl addbr br-net3
ip addr add 132.0.0.16/8 dev br-net3
ip link set up br-net3
ip tuntap add dev em5 mode tap
ifconfig em5 up promisc
brctl addif br-net3 em5
brctl show


CFGDRIVE=/tmp/configdrive.qcow2
echo "Creating config drive $CFGDRIVE"
/create_config_drive.sh $CFGDRIVE /tmp/$CONFIG /u/$LICENSE

if [ ! -z "$EMULATED" ]; then
    ENABLEKVM="-cpu SandyBridge"
else
  if [ -e /dev/kvm ]; then
    ENABLEKVM="--enable-kvm -cpu host"
  else
    ENABLEKVM="-cpu SandyBridge"
  fi
fi
echo "ENABLEKVM=$ENABLEKVM EMULATED=$EMULATED"

/usr/sbin/rsyslogd

HDDIMAGE="/tmp/vmxhdd.img"
echo "Creating empty $HDDIMAGE for VCP ..."
qemu-img create -f qcow2 $HDDIMAGE 4G >/dev/null

echo "Starting PFE with PCI=($PCI) ..."
PCI=$PCI sh /start_pfe.sh &

echo "Booting VCP ($ENABLEKVM) ..."
qemu-system-x86_64 --version

cd /tmp
qemu-system-x86_64 -M pc $ENABLEKVM -smp 1 -m $VCPMEM \
  -smbios type=0,vendor=Juniper \
  -smbios type=1,manufacturer=VMX,product=VM-vcp_vmx1-161-re-0,version=0.1.0 \
  -no-user-config \
  -no-shutdown \
  -drive if=ide,file=$VCPIMAGE -drive if=ide,file=$HDDIMAGE \
  -drive if=ide,file=$CFGDRIVE \
  -device cirrus-vga,id=video0,bus=pci.0,addr=0x2 \
  -netdev type=tap,id=tc0,ifname=fxp0,script=no,downscript=no \
  -device virtio-net-pci,netdev=tc0,mac=$mymac \
  -netdev type=tap,id=tc1,ifname=em1,script=no,downscript=no \
  -device virtio-net-pci,netdev=tc1 \
  -netdev type=tap,id=tc2,ifname=em2,script=no,downscript=no \
  -device virtio-net-pci,netdev=tc2 \
  -netdev type=tap,id=tc3,ifname=em3,script=no,downscript=no \
  -device virtio-net-pci,netdev=tc3 \
  -netdev type=tap,id=tc4,ifname=em4,script=no,downscript=no \
  -device virtio-net-pci,netdev=tc4 \
  -netdev type=tap,id=tc5,ifname=em5,script=no,downscript=no \
  -device virtio-net-pci,netdev=tc5 \
  -nographic || true
