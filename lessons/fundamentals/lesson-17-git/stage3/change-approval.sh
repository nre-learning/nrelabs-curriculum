#!/bin/bash

# This script simulates a change approval for change 124 occurring while we're working on a branch
# for change 123. It checks out master, then merges 124 into master, and then checks out change 123
# so we can see the difference between our 123 change and the new master branch

git checkout master > /dev/null 2>&1
git merge change-124 master > /dev/null 2>&1
git checkout change-123 > /dev/null 2>&1
