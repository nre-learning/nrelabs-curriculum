# Build container
FROM ubuntu:18.04 AS build-env

ENV PACKER_LOG=1

RUN apt update
RUN apt install qemu qemu-kvm libvirt-bin  bridge-utils  virt-manager wget unzip -y
RUN echo 'options kvm_intel nested=1' >> /etc/modprobe.d/qemu-system-x86.conf
RUN wget -nv -O /centos8-base.iso http://mirror.san.fastserv.com/pub/linux/centos/8.1.1911/isos/x86_64/CentOS-8.1.1911-x86_64-boot.iso 
RUN wget -nv https://releases.hashicorp.com/packer/1.5.6/packer_1.5.6_linux_amd64.zip
RUN unzip -b -qq packer_1.5.6_linux_amd64.zip -d /usr/local/bin
COPY tower.json /
COPY inventory /
RUN mkdir /http
COPY ks.cfg /http/
RUN mkfifo /tmp/qemu-serial.in /tmp/qemu-serial.out
CMD ["/usr/local/bin/packer", "build", "/tower.json"]


# Runtime container
FROM debian:stable AS runtime

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qy \
 && apt-get upgrade -qy \
 && apt-get install -y \
    bridge-utils \
    qemu-kvm \
    vim \
    procps \
 && rm -rf /var/lib/apt/lists/*


COPY launch.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/launch.sh

EXPOSE 22
EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/usr/local/bin/launch.sh"]