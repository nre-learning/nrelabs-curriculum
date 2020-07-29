#!/usr/bin/env bash

set -e +o pipefail

url="https://preview.nrelabs.io/webhook"

ech "ENV TO FOLLOW"
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

# if [ "$TRAVIS_PULL_REQUEST" == "false" ];
# then
#   echo "Not a PR build, skipping preview"
#   exit 0
# fi

# echo "Requesting preview...."

# curl $url --header "Content-Type: application/json" \
#   --data "{
#     \"branch\":\"$TRAVIS_PULL_REQUEST_BRANCH\",
#     \"pullRequest\":\"$TRAVIS_PULL_REQUEST\",
#     \"repoSlug\":\"$TRAVIS_PULL_REQUEST_SLUG\",
#     \"prSha\":\"$TRAVIS_PULL_REQUEST_SHA\"
#   }"


# echo "DONE!"

exit 0
