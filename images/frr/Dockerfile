FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qy \
 && apt-get upgrade -qy \
 && apt-get install -y \
    bridge-utils \
    iproute2 \
    python3-ipy \
    socat \
    screen \
    qemu-kvm \
    ssh \
    tcpdump \
    ethtool \
    telnet \
    procps \
 && rm -rf /var/lib/apt/lists/*

COPY frr.qcow2 /frr.qcow2
COPY launch.sh /

EXPOSE 22 161/udp 830 5000 10000-10099
ENTRYPOINT ["/launch.sh"]

