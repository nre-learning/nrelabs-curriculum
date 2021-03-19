#!/usr/bin/env bash

# set -e +o pipefail

if [ -z "$1" ]
then
    echo "Must provide status commit ID as parameter to this script"
    exit 1
fi

for i in {1..120}
do

    # TODO - May want to consider checking for the status of the commit in general, which is always there - it's a key "state"
    # at the top level of the returned object here, outside of the "statuses" array.
    build_status=$(curl \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/repos/nre-learning/nrelabs-curriculum/commits/$1/status | jq -r '.statuses[] | select(.context=="Building Endpoint Images").state')

    if [[ "$build_status" == "failure" ]]
    then
        echo "Status failed"
        exit 1
    elif [[ "$build_status" == "success" ]]
    then
        echo "Status succeeded"
        exit 0
    fi

    echo "Sleeping for 10 seconds..."
    sleep 10

done

echo "Timed out"
exit 1
