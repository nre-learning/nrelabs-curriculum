#!/usr/bin/env bash

set -e +o pipefail

url="https://preview.nrelabs.io/webhook"

echo "ENV TO FOLLOW"
echo $(env)

# # https://docs.travis-ci.com/user/environment-variables/
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
# echo "TRAVIS_PULL_REQUEST_BRANCH - $TRAVIS_PULL_REQUEST_BRANCH"






# GITHUB_REPOSITORY_OWNER=nre-learning
# GITHUB_ACTIONS=true
# USER=runner
# GITHUB_HEAD_REF=actions-preview
# GITHUB_ACTOR=Mierdin
# GITHUB_ACTION=run5
# PWD=/home/runner/work/nrelabs-curriculum/nrelabs-curriculum
# HOME=/home/runner
# RUNNER_TEMP=/home/runner/work/_temp
# DEBIAN_FRONTEND=noninteractive
# RUNNER_WORKSPACE=/home/runner/work/nrelabs-curriculum
# GITHUB_REF=refs/pull/344/merge
# GITHUB_SHA=45f5b4b395e311396d8009cdd57b8f0fb391b405
# GITHUB_RUN_ID=187513084
# GITHUB_SERVER_URL=https://github.com
# GITHUB_EVENT_PATH=/home/runner/work/_temp/_github_workflow/event.json
# GITHUB_BASE_REF=master
# GITHUB_JOB=build
# RUNNER_USER=runner
# GITHUB_REPOSITORY=nre-learning/nrelabs-curriculum
# GITHUB_EVENT_NAME=pull_request
# GITHUB_RUN_NUMBER=3
# GITHUB_WORKFLOW=CI
# GITHUB_WORKSPACE=/home/runner/work/nrelabs-curriculum/nrelabs-curriculum

PR_ID=$(echo $GITHUB_REF | sed "s/refs\/pull\/\(.*\)\/merge/\1/")

if [ "$GITHUB_EVENT_NAME" != "pull_request" ];
then
  echo "Not a PR build, skipping preview"
  exit 0
fi

PREVIEW_PAYLOAD="{
  \"branch\":\"$GITHUB_HEAD_REF\",
  \"pullRequest\":\"$PR_ID\",
  \"repoSlug\":\"$GITHUB_REPOSITORY\",
  \"prSha\":\"$GITHUB_SHA\"
}"

echo "Requesting preview...."
echo $PREVIEW_PAYLOAD

curl $url --header "Content-Type: application/json" \
  --data $PREVIEW_PAYLOAD


echo "DONE!"

exit 0
