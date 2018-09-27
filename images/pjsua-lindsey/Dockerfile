FROM centos

WORKDIR /root
RUN yum install -y gcc gcc-c++ make epel-release bzip2 iproute \
    && yum install -y wget \
    && wget https://github.com/cbednarski/hostess/releases/download/v0.3.0/hostess_darwin_amd64 -o /usr/sbin/hostess \
    && chmod 755 /usr/sbin/hostess \
    && wget http://www.pjsip.org/release/2.8/pjproject-2.8.tar.bz2 \
    && tar -xvjf pjproject-2.8.tar.bz2 \
    && cd pjproject-2.8 \
    && ./configure \
    && make dep \
    && make \
    && make clean \
    && yum erase -y gcc gcc-c++ make epel-release bzip2 wget \
    && yum -y autoremove

COPY launch.sh /root/launch.sh

CMD ["/bin/bash","/root/launch.sh"]
