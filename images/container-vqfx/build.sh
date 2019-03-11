#!/bin/bash

target=antidote/vqfx

docker build -f src/Dockerfile -t container-vqfx src

for image in *.img; do
  version=$(echo "${image%.*}" | cut -d- -f5)
  echo "Building container $target:$version ... "
  docker build -f Dockerfile.junos --build-arg image=$image -t $target:$version .
done
