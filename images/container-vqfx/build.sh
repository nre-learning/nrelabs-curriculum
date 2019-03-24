#!/bin/bash

target=antidotelabs/vqfx-full

docker build -f src/Dockerfile -t container-vqfx src

for image in *.img; do
  version=$(echo "${image%.*}" | cut -d- -f5)
  echo "Building container $target:$version ... "
  echo $image
  docker build -f Dockerfile.junos --build-arg image=$image -t $target .
done
