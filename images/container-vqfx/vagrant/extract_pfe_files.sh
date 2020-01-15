#!/bin/sh
# Copyright (c) 2018, Juniper Networks, Inc.
# All rights reserved.

DESTDIR=$1
if [ -z $DESTDIR ]; then
  DESTDIR=.
fi

Port=$(vagrant ssh-config vqfx-pfe|grep Port|awk '{print $2}')
IdentityFile=$(vagrant ssh-config vqfx-pfe|grep IdentityFile|awk '{print $2}')
User=$(vagrant ssh-config vqfx-pfe|grep 'User '|awk '{print $2}')
HostName=$(vagrant ssh-config vqfx-pfe|grep HostName|awk '{print $2}')
#echo $Port $IdentityFile $User $HostName
echo "downloading files from vagrant box vqfx-pfe (scp -P $Port -i $IdentityFile $User@$Hostname) ..."
#scp -o StrictHostKeyChecking=no  -P $Port -i $IdentityFile $User@$HostName:/etc/rc3.d/S99zhcosim $DESTDIR 2>/dev/null
scp -o StrictHostKeyChecking=no  -P $Port -i $IdentityFile $User@$HostName:/root/pecosim/cosim.tgz $DESTDIR  2>/dev/null
ls -l S99zhcosim cosim.tgz
