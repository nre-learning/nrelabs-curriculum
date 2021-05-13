#!/usr/bin/env bash

set -e +o pipefail

if [ -z "$1" ]
then
      echo "Must pass JSON array of image names as first parameter to this script"
fi

if [ -z "$2" ]
then
      echo "Must provide source tag as second parameter to this script"
fi

if [ -z "$3" ]
then
      echo "Must provide preview ID as third parameter to this script"
fi

wget -q "https://github.com/nre-learning/docker-housekeeping/releases/download/v0.1.0/docker-housekeeping-linux-amd64" && chmod +x docker-housekeeping-linux-amd64 && mv docker-housekeeping-linux-amd64 docker-housekeeping

for row in $(echo "$1" | jq -r '.[] | @base64'); do
    _getimage() {
     echo ${row} | base64 --decode
    }

    image=$(_getimage)

    if [ "$image" != "empty" ];
    then
        $(pwd)/docker-housekeeping retag --repository antidotelabs/$image --oldTag $2 --newTag preview-$3
    fi
done

rm -f $(pwd)/docker-housekeeping
