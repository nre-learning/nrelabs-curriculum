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
