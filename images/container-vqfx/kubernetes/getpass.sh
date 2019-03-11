#!/bin/bash
# Copyright (c) 2019, Juniper Networks, Inc.
# All rights reserved.
#
# simple script to extract root passwords from vqfx log file


list="vqfx1"
for i in $list; do
  descr=$(kubectl logs $i | grep 'root password' | cut -d' ' -f1-4,7 | tr -d '\r' || echo $i)
  if [ ! -z "$descr" ]; then
    ip=$(kubectl logs $i | grep 'root password'|cut -d\( -f2|cut -d\) -f1)
    echo -n " $ip "
    fpcmem=$(ssh -o StrictHostKeyChecking=no -o ConnectTimeout=1 lab@$ip cli show chassis fpc 0 2>/dev/null | grep Online | awk '{print $9}')
    fpcmem="${fpcmem:-0}"
    if [ "$fpcmem" -gt "1023" ]; then
      success=$(($success + 1))
      echo -e "$descr ready"
    else
      echo -e "$descr ..."
    fi
  fi
done
