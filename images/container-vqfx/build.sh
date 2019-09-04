#!/bin/bash

target=antidotelabs/container-vqfx
ocpkg=$(ls junos-openconfig-*.tgz)

docker build -f src/Dockerfile -t container-vqfx src

for image in *.img; do

  # Originally, we got the tag from the Junos version. However, we are removing this now
  # in favor of the Antidote-relevant tag.
  #
  # version=$(echo "${image%.*}" | cut -d- -f5)
  version=$TARGET_VERSION

  echo "Building container $target:$version ... "
  docker build --pull --no-cache -f Dockerfile.junos --build-arg image=$image --build-arg ocpkg=$ocpkg -t $target:$version .
done
