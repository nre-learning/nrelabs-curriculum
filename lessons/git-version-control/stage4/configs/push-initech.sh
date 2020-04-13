#!/bin/bash

set -e

cd ../../initech-network-configs/

rm -rf .git/

git init
git config --local user.email "nreadmin@nrelabs.io"
git config --local user.name "NRE Admin"
git config --local commit.gpgsign false

git add *
git commit -s -m "Initial commit"
git remote add origin http://nreadmin:Password1!@remote:3000/initech/network-configs.git
git push origin master
