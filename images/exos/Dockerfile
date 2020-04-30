FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qy \
 && apt-get upgrade -qy \
 && apt-get install -y \
    bridge-utils \
    iproute2 \
    python3-ipy \
    tcpdump \
    htop \
    socat \
    screen \
    qemu-kvm \
    telnet \
    vim \
    procps \
 && rm -rf /var/lib/apt/lists/*

COPY exos.qcow2 /exos.qcow2
COPY launch.sh /

EXPOSE 22 161/udp 830 5000 10000-10099
ENTRYPOINT ["/launch.sh"]
