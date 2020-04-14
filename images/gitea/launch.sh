#!/bin/bash

chown git:git /data/git
chown -R git:git /data/gitea

# Create first/admin user. Use this to connect via API and perform configuration tasks
su -c '/app/gitea/gitea -c /data/gitea/conf/app.ini admin create-user --name nreadmin --password Password1! --email nreadmin@nrelabs.io --admin' git

# Start Gitea (original CMD from Gitea's Dockerfile)
/bin/s6-svscan /etc/s6
