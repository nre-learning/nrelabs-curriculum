FROM crpd:latest

ADD launch.sh /
ADD sshd_config /
ADD all-sudoers /etc/sudoers.d/all
RUN chmod 0440 /etc/sudoers.d/all
ADD juniper.conf /
# ADD license.conf /

# Adjust MOTD
RUN rm -f /etc/update-motd.d/*
RUN rm -f /etc/legal
ADD motd.sh /etc/update-motd.d/00-antidote-motd

CMD ["bash", "/launch.sh"]