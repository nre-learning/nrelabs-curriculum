FROM debian:stable as build-env

ENV DEBIAN_FRONTEND=noninteractive
ENV PACKER_LOG=1

RUN apt-get update -qy \
 && apt-get upgrade -qy \
 && apt-get install -y \
    bridge-utils \
    iproute2 \
    python3-ipy \
    tcpdump \
    htop \
    unzip \
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

# We want to curl the image first so we can cache it inside Docker's FS instead of Packer pulling it on each build
RUN curl -o /ubuntu-base.img https://cloud-images.ubuntu.com/xenial/20181223/xenial-server-cloudimg-amd64-disk1.img

RUN wget -nv https://releases.hashicorp.com/packer/1.3.3/packer_1.3.3_linux_amd64.zip
RUN unzip -b -qq packer_1.3.3_linux_amd64.zip -d /usr/local/bin

COPY cloud-config.yaml /cloud-config.yaml
RUN cloud-localds /user-data.img /cloud-config.yaml

COPY provision.sh /
COPY packer.json /
RUN packer build /packer.json



# Runtime container
FROM debian:stable

RUN apt-get update -qy \
 && apt-get upgrade -qy \
 && apt-get install -y \
    bridge-utils \
    iproute2 \
    python3-ipy \
    tcpdump \
    htop \
    unzip \
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

COPY --from=build-env /image/utility-vm /utility-vm.img
COPY --from=build-env /user-data.img /user-data.img
COPY --from=build-env /ubuntu-base.img /ubuntu-base.img

COPY launch.sh /

EXPOSE 22 161/udp 830 5000 10000-10099

ENTRYPOINT ["/launch.sh"]
