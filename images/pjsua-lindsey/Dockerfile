FROM centos

WORKDIR /root
RUN yum install -y gcc gcc-c++ make epel-release bzip2 iproute openssh-server \
    && yum install -y wget \
    && wget http://www.pjsip.org/release/2.8/pjproject-2.8.tar.bz2 \
    && tar -xvjf pjproject-2.8.tar.bz2 \
    && cd pjproject-2.8 \
    && ./configure \
    && make dep \
    && make \
    && make clean \
    && yum erase -y gcc gcc-c++ make epel-release bzip2 wget \
    && yum -y autoremove \
    && mkdir /var/run/sshd \
    && useradd antidote -d /home/antidote -m \
    && echo antidotepassword | passwd antidote --stdin \

COPY launch.sh /root/launch.sh
COPY phone.sh /home/antidote/phone.sh
EXPOSE 22

CMD ["/bin/bash","/root/launch.sh"]
