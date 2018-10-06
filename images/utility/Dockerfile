FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server python python-pip dnsutils iputils-ping git vim curl
RUN mkdir /var/run/sshd

RUN adduser antidote

RUN echo 'antidote:antidotepassword' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
