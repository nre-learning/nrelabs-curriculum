FROM ubuntu:focal

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server python3 python3-pip curl dnsutils iputils-ping git vim  util-linux sshpass nano jq libxml2-utils

RUN mkdir /var/run/sshd

# Antidote user
RUN mkdir -p /home/antidote
RUN useradd antidote -p antidotepassword
RUN chown antidote:antidote /home/antidote
RUN chsh antidote --shell=/bin/bash
RUN echo 'antidote:antidotepassword' | chpasswd
RUN echo 'root:$(uuidgen)' | chpasswd

# Adjust MOTD
RUN rm -f /etc/update-motd.d/*
RUN rm -f /etc/legal
ADD motd.sh /etc/update-motd.d/00-antidote-motd

# Disable root Login
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Disable su for everyone not in the wheel group (no one is in the wheel group)
RUN echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su

# https://stackoverflow.com/questions/36292317/why-set-visible-now-in-etc-profile
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# ADD requirements.txt /requirements.txt
# RUN pip3 install -r /requirements.txt

# COPY bash_profile /home/antidote/.bash_profile
# RUN chown antidote:antidote /home/antidote/.bash_profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]


# ------------------

# Because tzdata comes with an interactive installer wizard to configure
# your timezone
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

# RUN wget -O - https://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add - && \
#     echo "deb http://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest bionic main" >> /etc/apt/sources.list && \
#     apt-get update
    #&& apt-get upgrade -y

# RUN wget -O - https://repo.saltstack.com/apt/ubuntu/18.04/amd64/archive/2019.2.4/SALTSTACK-GPG-KEY.pub | apt-key add - && \
#     echo "deb https://repo.saltstack.com/apt/ubuntu/18.04/amd64/archive/2019.2.4 bionic main" >> /etc/apt/sources.list && \
#     apt-get update

RUN curl -L https://bootstrap.saltstack.com -o install_salt.sh \
  && sh install_salt.sh -P -M -x python3

RUN apt-get --auto-remove --yes remove python-openssl

ADD requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

RUN apt-get install -y salt-master salt-minion

# configure minion and proxy
COPY ./salt_configs/master /etc/salt
COPY ./salt_configs/minion /etc/salt
COPY ./salt_configs/proxy /etc/salt

RUN service salt-minion restart
RUN service salt-master restart

# Add pillar file for vqfx1
RUN mkdir /srv/pillar
COPY ./salt_configs/vqfx1.sls /srv/pillar

# Add pillar file for top
COPY ./salt_configs/top.sls /srv/pillar

# Add salt file for infrastructure data
COPY ./salt_configs/infrastructure_data.sls /srv/pillar

# Add configuration template for vqfx1
RUN mkdir /srv/salt
COPY ./salt_configs/infrastructure_config.conf /srv/salt

# Add sls file to provision the configuration
COPY ./salt_configs/provision_infrastructure.sls /srv/salt

# set user permissions for Antidote user to run Salt
RUN chown -R antidote:antidote /etc/salt
RUN chown -R antidote:antidote /var/cache/salt
RUN chown -R antidote:antidote /srv
RUN chown -R antidote:antidote /var/log/salt
RUN chown -R antidote:antidote /var/run/salt
RUN chown -R antidote:antidote /var/run/salt-master.pid || true
RUN chown -R antidote:antidote /var/run/process_responsibility_salt-minion.pid || true
RUN chmod -R 777 /var/run/salt-master.pid || true
RUN chown antidote:antidote /var/run || true
RUN chmod 777 /var/run
