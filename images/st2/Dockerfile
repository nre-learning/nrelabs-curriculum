FROM ubuntu:trusty

# let Upstart know it's in a container
ENV container docker

COPY mongod.init /etc/init.d/mongod

#####################################################################################################
## Security options from Utility (copying these for now, should inherit from utility in future)          
#####################################################################################################
RUN apt-get update && apt-get install -y openssh-server python git vim
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

# Disable root Login
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Disable su for everyone not in the wheel group (no one is in the wheel group)
RUN echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

#####################################################################################################
## Change Password                  
#####################################################################################################

ENV ST2_PASSWORD=antidotepassword

#####################################################################################################
## Prepare the environement and install StackStorm (install script)                  
#####################################################################################################

RUN export DEBIAN_FRONTEND=noninteractive \
	&& export NO_PROXY=localhost,127.0.0.1,${HOSTNAME} \
	&& apt-get update \
	&& apt-get dist-upgrade --yes \
	&& apt-get install --yes curl vim gnupg-curl tree \
	&& /etc/init.d/rsyslog start \
	&& /etc/init.d/ssh start \
	&& curl -sSL -O https://stackstorm.com/packages/install.sh ; chmod +x install.sh ; ./install.sh --user=st2admin --password=${ST2_PASSWORD} --version=2.2.1; exit 0 \
	&& echo "stanley:stanley" | chpasswd

RUN ls -lha /etc/init.d
RUN apt-cache policy st2

#####################################################################################################
## Cleaning                  
#####################################################################################################

RUN rm -f /install.sh /st2-community-installer.sh /st2bootstrap-deb.sh \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ADD start_st2_services.sh /

ENTRYPOINT /start_st2_services.sh

WORKDIR /opt/stackstorm/packs
