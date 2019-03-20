#!/bin/bash
# Copyright (c) 2017, Juniper Networks, Inc.
# All rights reserved.

#-----------------------------------------------------------
function extract_licenses {
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [ ! -z "$line" ]; then
      tmp="$(echo "$line" | cut -d' ' -f1)"
      if [ ! -z "$tmp" ]; then
        file=config_drive/config/license/${tmp}.lic
        >&2 echo "  writing license file $file ..."
        echo "$line" > $file
      else
        echo "$line" >> $file
      fi
    fi
  done < "$1"
}

#==================================================================
METADISK=$1
CONFIG=$2
LICENSE=$3
PERSISTENT=$4

echo "METADISK=$METADISK CONFIG=$CONFIG"

echo "Creating config drive (configdrive.img) ..."
mkdir config_drive
mkdir config_drive/boot
mkdir config_drive/var
mkdir config_drive/var/db
mkdir config_drive/var/db/vmm
mkdir config_drive/var/db/vmm/etc
mkdir config_drive/var/db/vmm/yang
mkdir config_drive/config
mkdir config_drive/config/license

if [ "$PERSISTENT" == "persist"  ]; then
# remove eventual juniper.conf
 cat >> config_drive/var/db/vmm/etc/rc.vmm <<EOF
 if [ -f /var/vmguest/config/juniper.conf ]; then
  echo "persistent setup, removing juniper.conf"
  rm -f /var/vmguest/config/juniper.conf
 fi
 if [ -f /config/juniper.conf ]; then
  echo "persistent setup, removing juniper.conf"
  rm -f /config/juniper.conf
 fi
EOF
else
cat > config_drive/boot/loader.conf <<EOF
#vmchtype="vqfx"
#vm_retype="RE-VMX"
#vm_instance="0"
EOF
fi

# env YANG_SCHEMA YANG_DEVIATION YANG_ACTION YANG_PACKAGE passed to script
if [ ! -z "$YANG_SCHEMA" ]; then
  DEST=$PWD/config_drive/var/db/vmm/yang/
  (cd /u; cp $YANG_SCHEMA $YANG_DEVIATION $YANG_ACTION $DEST)
  yangargs=""
  for file in $YANG_SCHEMA; do
    filebase=$(basename $file)
    yangargs="$yangargs -m /var/db/vmm/yang/$filebase"
  done
  for file in $YANG_DEVIATION; do
    filebase=$(basename $file)
    yangargs="$yangargs -d /var/db/vmm/yang/$filebase"
  done
  for file in $YANG_ACTION; do
    filebase=$(basename $file)
    chmod a+rx $DEST/$filebase
    yangargs="$yangargs -a /var/db/vmm/yang/$filebase"
  done
  YANG_PACKAGE="${YANG_PACKAGE-cyang}"
  cat > config_drive/var/db/vmm/etc/rc.vmm <<EOF
echo "------------> YANG import started"
ls /var/db/vmm/scripts
echo "/bin/sh /usr/libexec/ui/yang-pkg add -X -i $YANG_PACKAGE $yangargs"
/bin/sh /usr/libexec/ui/yang-pkg add -X -i $YANG_PACKAGE $yangargs
echo "------------> YANG import completed"
EOF
  chmod a+rx config_drive/var/db/vmm/etc/rc.vmm
  echo -n "YANG files loaded into config_drive: "
  ls $DEST
fi

junospkg=$(ls /u/junos-*-x86-*tgz 2>/dev/null)
if [ ! -z "$junospkg" ]; then
  echo "adding $junospkg"
  filebase=$(basename $junospkg)
  cp $junospkg config_drive/var/db/vmm/
  PKG=$(echo $filebase|cut -d'-' -f1,2)
  if [ ! -z "$PKG" ]; then
    cat >> config_drive/var/db/vmm/etc/rc.vmm <<EOF
installed=\$(pkg info | grep $PKG)
if [ -z "\$installed" ]; then
  echo "Adding package $PKG (file $junospkg)"
  pkg add /var/db/vmm/$filebase
  reboot
fi
EOF
  fi
fi

if [ "$PERSISTENT" != "persist"  ]; then
 echo "adding config file $CONFIG"
 cp $CONFIG config_drive/config/juniper.conf
fi

cd config_drive
tar zcf vmm-config.tgz *
rm -rf boot config var
cd ..

# Create our own metadrive image, so we can use a junos config file
# 50MB should be enough.
dd if=/dev/zero of=metadata.img  bs=1M count=50
mkfs.vfat metadata.img
mount -o loop metadata.img /mnt
cp config_drive/vmm-config.tgz /mnt
umount /mnt
qemu-img convert -O qcow2 metadata.img $METADISK
rm metadata.img
ls -l $METADISK
