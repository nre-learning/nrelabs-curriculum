# Copyright (c) 2018, Juniper Networks, Inc.
# All rights reserved.

FROM alpine:3.8

RUN apk add --no-cache open-lldp mtu tcpdump 

COPY launch.sh /

ENTRYPOINT ["/bin/ash", "/launch.sh"]
