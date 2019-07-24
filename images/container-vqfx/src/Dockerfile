# Copyright (c) 2018, Juniper Networks, Inc.
# All rights reserved.

FROM ubuntu:18.04 as cosim
ADD cosim.tgz /root/pecosim
RUN rm -f /root/pecosim/*.tgz

FROM ubuntu:18.04

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get install -y -q qemu-kvm qemu-utils dosfstools \
        pwgen telnet screen socat expect vim tcl tclsh \
        ca-certificates netbase libpcap0.8 \
        tcpdump macchanger gettext-base net-tools ethtool\
        file iproute2 docker.io \
        --no-install-recommends \
    && mv /usr/sbin/tcpdump /sbin/ \
    && mkdir /root/pecosim

COPY --from=cosim /root/pecosim /root/pecosim

COPY create_config_drive.sh launch.sh \
  create_apply_group.sh fix_network_order.sh create_snapshot.expect /

RUN chmod a+rx /*.sh

EXPOSE 22
EXPOSE 830

ENTRYPOINT ["/launch.sh"]
