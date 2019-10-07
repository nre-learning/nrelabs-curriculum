FROM centos:7

WORKDIR /root
RUN yum install -y gcc gcc-c++ make epel-release bzip2 iproute openssh-server \
    && yum install -y wget unzip \
    && useradd antidote -d /home/antidote -m \
    && echo antidotepassword | passwd --stdin antidote

USER antidote
WORKDIR /home/antidote
RUN wget https://github.com/pjsip/pjproject/archive/2.8.zip \
    && unzip 2.8.zip \
    && cd pjproject-2.8 \
    && ./configure \
    && make dep \
    && make \
    && make clean

USER root
RUN yum erase -y gcc gcc-c++ make epel-release bzip2 wget \
    && yum -y autoremove \
    && mkdir /var/run/sshd \
    && yum clean all \
    && rm -rf /var/cache/yum

COPY launch.sh /root/launch.sh

EXPOSE 22

CMD ["/root/launch.sh"]
