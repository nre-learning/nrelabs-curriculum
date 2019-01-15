FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive

COPY vqfx-orig.qcow2 /vqfx.qcow2

RUN apt-get update -qy \
 && apt-get upgrade -qy \
 && apt-get install -y \
    bridge-utils \
    iproute2 \
    python3-ipy \
    tcpdump \
    htop \
    dosfstools \
    macchanger \
    socat \
    screen \
    qemu-kvm \
    telnet \
    vim \
    procps \
 && rm -rf /var/lib/apt/lists/*

COPY launch_orig.sh /launch.sh
COPY create_config_drive.sh /
COPY vqfx.conf /

EXPOSE 22 161/udp 830 5000 10000-10099
ENTRYPOINT ["/launch.sh"]

