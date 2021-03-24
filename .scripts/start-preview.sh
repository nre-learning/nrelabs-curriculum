#!/usr/bin/env bash

set -e +o pipefail

url="https://preview.nrelabs.io/start"

if [ -z "$1" ]
then
      echo "Must provide preview ID as parameter to this script"
fi

curl -f -v -s $url --header "Content-Type: application/json" \
  --data "{
    \"previewID\":\"$1\"
  }"

