FROM kalilinux/kali-linux-docker

RUN apt-get update && apt-get install -y openssh-server \
    zlib1g-dev libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential wordlists

# python \
#     python-pip dnsutils iputils-ping git vim curl util-linux sshpass nano jq sudo
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

#ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN gem install wpscan

RUN wpscan --update
RUN su - antidote -c "wpscan --update"

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
