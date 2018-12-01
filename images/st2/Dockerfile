FROM ubuntu:xenial

# Borrowed with love from https://github.com/StackStorm/st2-dockerfiles/blob/master/base/Dockerfile

ARG DEBIAN_FRONTEND=noninteractive

ARG ST2_VERSION=2.9.1
RUN : "${ST2_VERSION:?Docker build argument needs to be set and non-empty.}"

LABEL maintainer="StackStorm <info@stackstorm.com>"
LABEL com.stackstorm.vendor="StackStorm"
LABEL com.stackstorm.support="Community"
LABEL com.stackstorm.version="${ST2_VERSION}"
LABEL com.stackstorm.name="StackStorm K8s HA"
LABEL com.stackstorm.description="Docker image, optimized to run StackStorm \
components and core services with Highly Available requirements in Kubernetes environment"
LABEL com.stackstorm.url="https://stackstorm.com/#product"

ENV container docker
ENV ENV /etc/skel/.profile
ENV TERM xterm

# Generate and set locale to UTF-8
RUN apt-get -qq update \
  && apt-get install -y \
    curl \
    locales \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen en_US.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# The LC_ALL variable must be defined after executing update-local
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

#####################################################################################################
## External Deps               
#####################################################################################################

RUN mkdir -p /data/db
RUN apt-get update
RUN apt-get install -y gnupg-curl
RUN apt-get install -y curl wget

# Add key and repo for the latest stable MongoDB (3.4)
RUN wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.4.list
RUN apt-get update

RUN apt-get install -y crudini
RUN apt-get install -y mongodb-org
RUN apt-get install -y rabbitmq-server

#####################################################################################################
## Change Password                  
#####################################################################################################

ENV ST2_PASSWORD=antidotepassword

#####################################################################################################
## Prepare the environement and install StackStorm (install script)                  
#####################################################################################################

# RUN export DEBIAN_FRONTEND=noninteractive \
# 	&& export NO_PROXY=localhost,127.0.0.1,${HOSTNAME} \
# 	&& apt-get update \
# 	&& apt-get dist-upgrade --yes \
# 	&& apt-get install --yes curl vim gnupg-curl tree \
# 	# && curl -sSL -O https://stackstorm.com/packages/install.sh ; chmod +x install.sh ; ./install.sh --user=st2admin  \
#     && curl -sSL https://stackstorm.com/packages/install.sh | bash -s -- --user=st2admin --password=${ST2_PASSWORD} --version=2.9.1


	

# RUN ls -lha /etc/init.d
# RUN apt-cache policy st2

# Install StackStorm, but without UI
RUN curl -sf https://packagecloud.io/install/repositories/StackStorm/stable/script.deb.sh | bash \
  && apt-get install -y st2=${ST2_VERSION}-* \
  && rm -f /etc/apt/sources.list.d/StackStorm_*.list 

ADD htpasswd /etc/st2/htpasswd

RUN echo "stanley:stanley" | chpasswd
ADD start_st2_services.sh /

#####################################################################################################
## Additional installations / configuration             
#####################################################################################################

RUN apt-get update && apt-get install -y openssh-server python git vim screen
ADD napalm.yaml /opt/stackstorm/configs
RUN screen -d -m /start_st2_services.sh && sleep 5 && st2ctl reload --register-all && st2 pack install napalm

# st2ctl reload --register-all



# EXPOSE 9100
# EXPOSE 9101
# EXPOSE 9102

#####################################################################################################
## Security options from Utility      
#####################################################################################################
RUN mkdir /var/run/sshd

# Antidote user
RUN mkdir -p /home/antidote
RUN useradd antidote -p antidotepassword
RUN mkdir -p /home/antidote/.st2/
ADD st2config /home/antidote/.st2/config
RUN chown antidote:antidote /home/antidote /home/antidote/.st2 /home/antidote/.st2/config
RUN chsh antidote --shell=/bin/bash
RUN echo 'antidote:antidotepassword' | chpasswd
RUN echo 'root:$(uuidgen)' | chpasswd

# Adjust MOTD
RUN rm -f /etc/update-motd.d/*
RUN rm -f /etc/legal
ADD .welcome.sh /etc/update-motd.d/00-antidote-motd
RUN chmod +x /etc/update-motd.d/00-antidote-motd

# Disable root Login
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Disable su for everyone not in the wheel group (no one is in the wheel group)
RUN echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

CMD /start_st2_services.sh
