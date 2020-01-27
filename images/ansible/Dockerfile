FROM centos:8

RUN yum --enablerepo=extras -y install epel-release
RUN yum update -y
RUN yum install -y openssh-server git vim nano jq python3-pip sshpass
RUN mkdir /var/run/sshd

# Antidote user
RUN mkdir -p /home/antidote
RUN useradd antidote -p antidotepassword
RUN chown antidote:antidote /home/antidote
# RUN chsh antidote --shell=/bin/bash
RUN echo 'antidote:antidotepassword' | chpasswd
RUN echo 'root:$(uuidgen)' | chpasswd
RUN rm /run/nologin
RUN ssh-keygen -b 2048 -t rsa -f /etc/ssh/ssh_host_rsa_key -q -N ""

# Adjust MOTD
ADD motd.sh /etc/profile.d/motd.sh

# Disable root Login
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Disable su for everyone not in the wheel group (no one is in the wheel group)
RUN echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

ADD requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

RUN mkdir /etc/ansible
COPY ansible.cfg /etc/ansible/ansible.cfg

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
