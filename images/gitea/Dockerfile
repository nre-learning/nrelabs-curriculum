FROM gitea/gitea:latest
# FROM gitea/gitea:1.4.1

# https://discourse.gitea.io/t/i-cannot-programmatically-setup-users-in-a-docker-container/289/5

# This directory contains a very basically bootstrapped system. It has no users, no repositories.
# All I did was go through the initial wizard and provide the hostname and tagline.
# Once I captured this, I manually deleted the data-init/ssh directory so Docker wouldn't choke on
# the permissions. Gitea appears to regenerate this on startup if it's missing.


# COPY data-init/ /data
COPY data-init/gitea/conf/app.ini /data/gitea/conf/app.ini
COPY data-init/gitea/gitea.db /data/gitea/gitea.db

RUN chown -R git:git /data/gitea

COPY launch.sh /
ENV USER=git

CMD ["/launch.sh"]