#!/usr/bin/env bash

set -e +o pipefail

wget "https://github.com/nre-learning/docker-housekeeping/releases/download/v0.1.0/docker-housekeeping-linux-amd64"
chmod +x docker-housekeeping-linux-amd64
mv docker-housekeeping-linux-amd64 docker-housekeeping

$(pwd)/docker-housekeeping prune-preview-tags

rm -f $(pwd)/docker-housekeeping
