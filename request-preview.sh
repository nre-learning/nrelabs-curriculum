#!/usr/bin/env bash

set -e +o pipefail

# VERSION="tbd"

url="https://preview.nrelabs.io/webhook"
# url="http://127.0.0.1:8080/webhook"

# https://docs.travis-ci.com/user/environment-variables/
# commit="${TRAVIS_PULL_REQUEST_SHA:-$TRAVIS_COMMIT}"
# build="$TRAVIS_JOB_NUMBER"
# pr="$TRAVIS_PULL_REQUEST"
# job="$TRAVIS_JOB_ID"
# slug="$TRAVIS_REPO_SLUG"
# env="$env,TRAVIS_OS_NAME"
# tag="$TRAVIS_TAG"
# if [ "$TRAVIS_BRANCH" != "$TRAVIS_TAG" ];
# then
#   branch="$TRAVIS_BRANCH"
# fi

# echo "TRAVIS_PULL_REQUEST_SHA - $TRAVIS_PULL_REQUEST_SHA"
# echo "TRAVIS_COMMIT - $TRAVIS_COMMIT"
# echo "TRAVIS_JOB_NUMBER - $TRAVIS_JOB_NUMBER"
# echo "TRAVIS_PULL_REQUEST - $TRAVIS_PULL_REQUEST"
# echo "TRAVIS_JOB_ID - $TRAVIS_JOB_ID"
# echo "TRAVIS_REPO_SLUG - $TRAVIS_REPO_SLUG"
# echo "env - $env"
# echo "TRAVIS_OS_NAME - $TRAVIS_OS_NAME"
# echo "TRAVIS_TAG - $TRAVIS_TAG"
# echo "TRAVIS_BRANCH - $TRAVIS_BRANCH"

# TRAVIS_PULL_REQUEST_SHA - 8a2de5fbea5c0ad652f5c4fe8a15390e4bae1405   # THIS is the most recent git commit in the branch. I don't know what the one below is.
# TRAVIS_COMMIT - 5a3d0a24910b5d06c7a2761f5a5c692f009832af
# TRAVIS_JOB_NUMBER - 1124.1
# TRAVIS_PULL_REQUEST - 323
# TRAVIS_JOB_ID - 675908366
# TRAVIS_REPO_SLUG - nre-learning/nrelabs-curriculum
# env - 
# TRAVIS_OS_NAME - linux
# TRAVIS_TAG - 
# TRAVIS_BRANCH - master

# TRAVIS_PULL_REQUEST="323"
# TRAVIS_REPO_SLUG="nre-learning/nrelabs-curriculum"
# TRAVIS_BRANCH="master"

curl $url --header "Content-Type: application/json" \
  --data "{
    \"branch\":\"$TRAVIS_BRANCH\",
    \"pullRequest\":\"$TRAVIS_PULL_REQUEST\",
    \"repoSlug\":\"$TRAVIS_REPO_SLUG\",
    \"prSha\":\"$TRAVIS_PULL_REQUEST_SHA\"
  }"

exit 0
