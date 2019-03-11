#!/bin/bash
# Copyright (c) 2019, Juniper Networks, Inc.
# All rights reserved.
#

SECONDS=0
logdir=$(dirname $0)

set -e

if [ "$USER" == "root" ]; then
  CLI=cli
fi

echo ""

echo "check connectivity between alpine1a and alpine1b:"
docker-compose -f testmtu/docker-compose.yml exec alpine1a ping -c 3 192.168.99.2
echo ""
echo -n "$i max MTU "
docker-compose -f testmtu/docker-compose.yml exec alpine1a mtu -d 192.168.99.2 | tail -1
echo ""
