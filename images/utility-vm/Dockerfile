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
    curl \
    socat \
    screen \
    qemu-kvm \
    telnet \
    vim \
    procps \
    openssh-client \
    cloud-image-utils \
 && rm -rf /var/lib/apt/lists/*

RUN curl -o /ubuntu.img https://cloud-images.ubuntu.com/xenial/20190101/xenial-server-cloudimg-amd64-disk1.img

RUN apt-get install -y openssh-client

COPY cloud-config.yaml /cloud-config.yaml

RUN cloud-localds /user-data.img /cloud-config.yaml

# COPY vqfx-snap1.qcow2 /vqfx.qcow2
COPY launch.sh /

EXPOSE 22 161/udp 830 5000 10000-10099
ENTRYPOINT ["/launch.sh"]
