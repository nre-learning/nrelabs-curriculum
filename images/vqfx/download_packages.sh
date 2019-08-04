#!/bin/bash

# This script uses the gsutil utility from Google Cloud
# to download files from the relevant bucket. See
# https://cloud.google.com/sdk/docs/ for instructions on installing
# the Google Cloud SDK, which includes this utility.

declare -a arr=(
    "container-vqfx/jinstall-vqfx-10-f-18.4R1.8.qcow2"
)

for i in "${arr[@]}"
do
   gsutil cp "gs://nrelabs-curriculum-base-images/$i" "./$i"
   mv "$i" ./
done

rm -rf container-vqfx/
