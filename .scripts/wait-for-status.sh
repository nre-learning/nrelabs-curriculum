#!/usr/bin/env bash

# set -e +o pipefail

if [ -z "$1" ]
then
    echo "Must provide preview ID as parameter to this script"
    exit 1
fi

for i in {1..120}
do

    build_status=$(curl https://preview.nrelabs.io/status\?id\=$1 | jq -r .Status)
    if [[ -z "$build_status" ]]
    then
        echo "Error retrieving build status"
        exit 1
    fi

    if [[ "$build_status" == "FAILED" ]]
    then
        echo "Preview deployment failed"
        exit 1
    elif [[ "$build_status" == "CREATED" ]]
    then
        echo "Preview deployment not started - call this script after a created preview has also been started."
        exit 1
    elif [[ "$build_status" == "READY" ]]
    then
        echo "Preview deployment succeeded"
        exit 0
    fi

    echo "Status for preview $1 is $build_status; sleeping for 10 seconds..."
    sleep 10

done

echo "Timed out"
exit 1
