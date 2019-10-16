
#    Download the repo file from https://ast.tucny.com/repo/tucny-asterisk.repo to /etc/yum.repos.d/
#    Import the signing key using 'rpm --import https://ast.tucny.com/repo/RPM-GPG-KEY-dtucny'
#    Edit the /etc/yum.repos.d/tucny-asterisk.repo and set 'enabled=1' for 'asterisk-common' and the version of asterisk you want to use
#    Install the packages you want. 'dnf install asterisk' or 'yum install asterisk' can get you started.

FROM centos:7

RUN yum install -y iproute epel-release lshw openssh-server \
    && yum install -y wget \
    && wget -P /etc/yum.repos.d/ https://ast.tucny.com/repo/tucny-asterisk.repo \
    && sed -i '/^\[asterisk-common]/,/^\[/{s/^enabled[[:space:]]*=.*/enabled=1/}' /etc/yum.repos.d/tucny-asterisk.repo \
    && sed -i '/^\[asterisk-13]/,/^\[/{s/^enabled[[:space:]]*=.*/enabled=1/}' /etc/yum.repos.d/tucny-asterisk.repo \
    && rpm --import https://ast.tucny.com/repo/RPM-GPG-KEY-dtucny \
    && yum install -y asterisk asterisk-pjsip asterisk-sqlite asterisk-voicemail asterisk-voicemail-plain \
    && mkdir -p /etc/asterisk/samples \
    && mv /etc/asterisk/*.* /etc/asterisk/samples \
    && yum -y erase wget epel-release \
    && yum -y autoremove \
    && mkdir /var/run/sshd \
    && echo 'root:antidotepassword' | chpasswd \
    && sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

COPY ./asterisk_configs /etc/asterisk
COPY launch.sh /root/launch.sh

EXPOSE 22 8088

CMD ["/bin/bash","/root/launch.sh"]


