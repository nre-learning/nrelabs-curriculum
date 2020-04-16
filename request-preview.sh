#!/usr/bin/env bash

set -e +o pipefail

VERSION="tbd"

url="https://preview.nrelabs.io/"

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

echo "TRAVIS_PULL_REQUEST_SHA - $TRAVIS_PULL_REQUEST_SHA"
echo "TRAVIS_COMMIT - $TRAVIS_COMMIT"
echo "TRAVIS_JOB_NUMBER - $TRAVIS_JOB_NUMBER"
echo "TRAVIS_PULL_REQUEST - $TRAVIS_PULL_REQUEST"
echo "TRAVIS_JOB_ID - $TRAVIS_JOB_ID"
echo "TRAVIS_REPO_SLUG - $TRAVIS_REPO_SLUG"
echo "env - $env"
echo "TRAVIS_OS_NAME - $TRAVIS_OS_NAME"
echo "TRAVIS_TAG - $TRAVIS_TAG"
echo "TRAVIS_BRANCH - $TRAVIS_BRANCH"



# # find branch, commit, repo from git command
# if [ "$GIT_BRANCH" != "" ];
# then
#   branch="$GIT_BRANCH"

# elif [ "$branch" = "" ];
# then
#   branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || hg branch 2>/dev/null || echo "")
#   if [ "$branch" = "HEAD" ];
#   then
#     branch=""
#   fi
# fi

# if [ "$commit_o" = "" ];
# then
#   # merge commit -> actual commit
#   mc=
#   if [ -n "$pr" ] && [ "$pr" != false ];
#   then
#     mc=$(git show --no-patch --format="%P" 2>/dev/null || echo "")
#   fi
#   if [[ "$mc" =~ ^[a-z0-9]{40}[[:space:]][a-z0-9]{40}$ ]];
#   then
#     say "    Fixing merge commit SHA"
#     commit=$(echo "$mc" | cut -d' ' -f2)
#   elif [ "$GIT_COMMIT" != "" ];
#   then
#     commit="$GIT_COMMIT"
#   elif [ "$commit" = "" ];
#   then
#     commit=$(git log -1 --format="%H" 2>/dev/null || hg id -i --debug 2>/dev/null | tr -d '+' || echo "")
#   fi
# else
#   commit="$commit_o"
# fi

exit ${exit_with}
