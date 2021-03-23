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

wget -q "https://raw.githubusercontent.com/nre-learning/docker-retag/d702a5a109af5e8f04baea2c80782dc107142f19/docker-retag" && chmod +x docker-retag

for row in $(echo "$1" | jq -r '.[] | @base64'); do
    _getimage() {
     echo ${row} | base64 --decode
    }

    image=$(_getimage)

    if [ "$image" != "empty" ];
    then
        $(pwd)/docker-retag antidotelabs/$image:$2 preview-$3
    fi
done

rm -f $(pwd)/docker-retag
