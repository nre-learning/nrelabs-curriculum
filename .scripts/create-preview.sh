#!/usr/bin/env bash

set -e +o pipefail

url="https://preview.nrelabs.io/create"

PR_ID=$(echo $GITHUB_REF | sed "s/refs\/pull\/\(.*\)\/merge/\1/")

if [ "$GITHUB_EVENT_NAME" != "pull_request" ];
then
  echo "Not a PR build, skipping preview"
  exit 0
fi

echo $(curl -s $url --header "Content-Type: application/json" \
  --data "{
    \"branch\":\"$GITHUB_REF\",
    \"pullRequest\":\"$PR_ID\",
    \"repoSlug\":\"$GITHUB_REPOSITORY\",
    \"prSha\":\"$GITHUB_SHA\"
  }")

exit 0
