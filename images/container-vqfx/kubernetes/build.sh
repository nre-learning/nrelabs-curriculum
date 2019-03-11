#!/bin/bash

target=juniper/vqfx

for image in *.img; do
  version=$(echo "${image%.*}" | cut -d- -f5)
  echo "Building container $target:$version ... "
  docker build --build-arg image=$image -t $target:$version .
done
