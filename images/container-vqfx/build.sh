#!/bin/bash

target=antidote/vqfx
ocpkg=$(ls junos-openconfig-*.tgz)

docker build -f src/Dockerfile -t container-vqfx src

for image in *.img; do
  version=$(echo "${image%.*}" | cut -d- -f5)
  echo "Building container $target:$version ... "
  docker build -f Dockerfile.junos --build-arg image=$image --build-arg ocpkg=$ocpkg -t $target:$version .
done
