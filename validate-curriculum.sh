

#!/usr/bin/env bash

# set -e +o pipefail

# Install Antidote CLI
curl -Lo antidote.tar.gz https://github.com/nre-learning/antidote-core/releases/download/v0.6.0/antidote-linux-amd64.tar.gz
tar xvzf antidote.tar.gz

# Validate curriculum
./antidote validate .
