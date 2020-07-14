FROM crpd:20.1R1.11

ADD launch.sh /
ADD sshd_config /
ADD all-sudoers /etc/sudoers.d/all
RUN chmod 0440 /etc/sudoers.d/all
ADD juniper.conf /

# Leaving out license for now, as we don't need those features yet, and I still want to figure out the best way
# to apply this license so that it's not publicly viewable. See launch.sh script for some ideas here.
#
# ADD license.conf /

# Adjust MOTD
RUN rm -f /etc/update-motd.d/*
RUN rm -f /etc/legal
ADD motd.sh /etc/update-motd.d/00-antidote-motd

CMD ["bash", "/launch.sh"]
