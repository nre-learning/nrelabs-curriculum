from ubuntu:16.04

RUN apt-get update && apt-get install -y sudo net-tools openssh-server python python-pip dnsutils iputils-ping git vim curl util-linux

RUN mkdir /var/run/sshd

RUN wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/archive/2018.3.2/SALTSTACK-GPG-KEY.pub | apt-key add - && \
    echo "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/archive/2018.3.2 xenial main" >> /etc/apt/sources.list && \
    apt-get update

RUN apt-get install -y salt-master
RUN service salt-master restart

RUN apt-get install -y salt-minion
RUN service salt-minion restart

RUN touch /etc/salt/proxy
#RUN echo "master: $(ip route get 1| awk '{print $NF;exit}')" > /etc/salt/minion
RUN echo "master: $(ip route get 1| awk '{print $NF;exit}')" > /etc/salt/proxy
#RUN echo "id: minion" >> /etc/salt/minion

# Antidote user
RUN mkdir -p /home/antidote
RUN useradd antidote -p antidotepassword
RUN chown antidote:antidote /home/antidote
RUN chown antidote:antidote /etc/salt
RUN chown antidote:antidote /var/cache/salt
RUN chown antidote:antidote /var/run
RUN chown antidote:antidote /var/run/

RUN chsh antidote --shell=/bin/bash
RUN echo 'antidote:antidotepassword' | chpasswd
RUN echo 'root:rootpassword' | chpasswd

# Adjust MOTD
RUN rm -f /etc/update-motd.d/*
RUN rm -f /etc/legal
ADD motd.sh /etc/update-motd.d/00-antidote-motd

# Disable root Login
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
# RUN sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Disable su for everyone not in the wheel group (no one is in the wheel group)
# RUN echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
