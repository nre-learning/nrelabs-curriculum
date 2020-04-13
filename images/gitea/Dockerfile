FROM gitea/gitea:latest

# This directory contains a very basically bootstrapped system. It has no users, no repositories.
# All I did was go through the initial wizard and provide the hostname and tagline.
# Once I captured this, I manually deleted the data-init/ssh directory so Docker wouldn't choke on
# the permissions. Gitea appears to regenerate this on startup if it's missing.
COPY data-init/ /data

COPY launch.sh /
ENV USER=root
CMD ["/launch.sh"]