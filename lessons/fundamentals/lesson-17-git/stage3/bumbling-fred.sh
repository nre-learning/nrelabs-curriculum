#!/bin/bash

# This script simulates fred not only making a commit directly on `master` (which isn't very team-friendly)
# but also changing the same line we're working on in our branch, which means we'll have a merge conflict
# when we merge our branch back to master

git checkout master
sed -i s/10.31.0.11/123.123.123.123/ interface-config.txt
git add interface-config.txt
git commit -m "I'm fred and I'm conficting with your change!"
git checkout change-123
