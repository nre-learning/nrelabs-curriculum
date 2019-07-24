#!/bin/bash

# This script uses the gsutil utility from Google Cloud
# to download files from the relevant bucket. See
# https://cloud.google.com/sdk/docs/ for instructions on installing
# the Google Cloud SDK, which includes this utility.

declare -a arr=(
    "container-vqfx/junos-openconfig-0.0.0.10-1-signed.tgz"
    "container-vqfx/cosim.tgz"
    "container-vqfx/jinstall-vqfx-10-f-18.1R1.9.img"
)

for i in "${arr[@]}"
do
   gsutil cp "gs://nrelabs-curriculum-base-images/$i" "./$i"
   mv "$i" ./
done

rm -rf container-vqfx/
mv cosim.tgz src/
