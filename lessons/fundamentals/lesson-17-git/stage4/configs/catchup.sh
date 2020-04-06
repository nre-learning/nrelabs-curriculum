#!/bin/bash

# Catch up from previous sections
rm -rf /home/antidote/myfirstrepo
mkdir -p /home/antidote/myfirstrepo
cd /home/antidote/myfirstrepo
git init
git config --global user.email "jane@nrelabs.io"
git config --global user.name "Jane Doe"
cp /antidote/stage3/interface-config.txt .
git add interface-config.txt
git commit -m "Adding new interface configuration file"

# simulate Fred's change
git config --global user.email "fred@nrelabs.io"
git config --global user.name "Fred Smith"
git checkout -b change-124
sed -i s/10.12.0.11/10.12.0.12/ interface-config.txt
git add interface-config.txt
git commit -s -m "Updated em4 IP address"

# Prepare for learner
git config --global user.email "jane@nrelabs.io"
git config --global user.name "Jane Doe"
git checkout master

# from stage 3
git checkout -b change-123
sed -i s/10.31.0.11/10.31.0.12/ interface-config.txt
git add interface-config.txt
git commit -m "Changed IP address of em3"
# CHANGE APPROVAL SCRIPT
git checkout master > /dev/null 2>&1
git merge change-124 master > /dev/null 2>&1
git checkout change-123 > /dev/null 2>&1
# CHANGE APPROVAL SCRIPT
git merge master change-123 -m "Merge branch 'master' into change-123"
# BUMBLING FRED
git config --global user.email "fred@nrelabs.io"
git config --global user.name "Fred Smith"
git checkout master > /dev/null 2>&1
sed -i s/10.31.0.11/123.123.123.123/ interface-config.txt > /dev/null 2>&1
git add interface-config.txt > /dev/null 2>&1
git commit -m "I'm fred and I'm conficting with your change!" > /dev/null 2>&1
git checkout change-123 > /dev/null 2>&1
git config --global user.email "jane@nrelabs.io"
git config --global user.name "Jane Doe"
# BUMBLING FRED
git merge master change-123 -m "Catch-up again"
grep -Ev "<<<<<<<|=======|>>>>>>>|123\.123\.123\.123" interface-config.txt > temp && mv -f temp interface-config.txt
git add interface-config.txt
git commit -s -m "Resolve merge conflict, overwrite Fred's change"
git checkout master
git merge change-123 -m "Merging change 123 into master"
git branch -d change-123
echo "admin:supersecretpassword" >> credentials.txt
