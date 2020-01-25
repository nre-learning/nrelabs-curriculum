FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openssh-server python python-pip dnsutils iputils-ping git vim curl util-linux sshpass nano jq
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

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# The latest release of JSNAPy as of now was 1.3.2, released in
# May of 2018. Since then, there have been many fixes, and the main one we care
# about is the YAML deprecation notices. I will follow up with them and ask why
# we haven't done a release in so long with many outstanding fixes already in
# master, but in the meantime, we will clone and check out a commit manually so
# we can avoid the YAML deprecation notices 
RUN git clone https://github.com/Juniper/jsnapy.git /tmp/jsnapy \
    && cd /tmp/jsnapy \
    && git checkout bb8e02b1a9bd0e981c7d9a18cd1a08f5596cac65 \
    && python setup.py install

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
