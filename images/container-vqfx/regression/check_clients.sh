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

echo ""

for i in $instances; do
  index="${i: -3:1}"
  echo "$i check connectivity between alpine${index}a and alpine${index}b:"
  docker-compose -f regression/docker-compose.yml exec alpine${index}a ping -c 3 192.168.99.2
  echo ""
done

docker-compose -f regression/docker-compose.yml exec alpine1a ping -c 3 192.168.99.2
docker-compose -f regression/docker-compose.yml exec alpine1a ping -c 3 192.168.99.3
docker-compose -f regression/docker-compose.yml exec alpine1a ping -c 3 192.168.99.4
docker-compose -f regression/docker-compose.yml exec alpine1a ping -c 3 192.168.99.5

for i in $instances; do
  index="${i: -3:1}"
  echo -n "$i max MTU "
  docker-compose -f regression/docker-compose.yml exec alpine${index}a mtu -d 192.168.99.2 | tail -1
done
echo ""
