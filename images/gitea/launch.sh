#!/bin/bash

# Create first/admin user. Use this to connect via API and perform configuration tasks
gitea admin create-user --username nreadmin --password Password1! --email nreadmin@nrelabs.io --admin

# Start Gitea (original CMD from Gitea's Dockerfile)
/bin/s6-svscan /etc/s6
