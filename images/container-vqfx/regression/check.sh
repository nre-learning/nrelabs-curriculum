#!/bin/bash
# Copyright (c) 2019, Juniper Networks, Inc.
# All rights reserved.
#

SECONDS=0
logdir=$(dirname $0)

instances=$(docker ps --format '{{.Names}}'|grep regression|grep vqfx)
count=$(echo "$instances" | wc -w)

if [ "$count" -eq "0" ]; then
  echo "no instance running"
  exit 0
fi

if [ "$USER" == "root" ]; then
  CLI=cli
fi

while true; do
  echo "wait for fpc0 up in $count instances ($SECONDS seconds)..."
  success=0
  index=0
  for i in $instances; do
    ip=$(docker logs $i | grep 'root password'| cut -d\( -f2|cut -d\) -f1)
    fpcmem=$(ssh -o StrictHostKeyChecking=no -o ConnectTimeout=2 $ip $CLI show chassis fpc 0 2>/dev/null | grep Online | awk '{print $9}')
    fpcmem="${fpcmem:-0}"
    descr=$(docker logs $i | grep 'root password' | cut -d' ' -f1-4,7 | tr -d '\r' || echo $i)
    if [ "$fpcmem" -gt "1023" ]; then
      success=$(($success + 1))
      echo "$descr fpc0 up"
    else
      echo "$descr ... "
    fi
    index=$(($index + 1))
  done
  if [ "$count" -eq "$success" ]; then
    break
  fi
  if [ "$SECONDS" -gt "600" ]; then 
    echo "FAILED (waited for 10 minutes)"
    exit 1
  fi
  sleep 10
  newinstances=$(docker ps --format '{{.Names}}')
  newcount=$(echo "$instances" | wc -w)
  if [ "$count" -ne "$newcount" ]; then
    echo "instance count changed! Started with $count, left with $newcount"
    echo "FAILURE"
    exit 1
  fi
done

echo "$count instances up in $SECONDS seconds"
echo "SUCCESS"
exit 0
