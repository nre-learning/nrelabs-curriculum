#!/bin/bash
# Copyright (c) 2018, Juniper Networks, Inc.
# All rights reserved.

set -e 	# terminate on error

scripts/add_link.sh vqfx1 alpine1a
scripts/add_link.sh vqfx1 alpine1b
scripts/add_link.sh vqfx1 alpine1c
scripts/add_link.sh vqfx1 alpine1d
scripts/add_link.sh vqfx1 alpine1e
scripts/add_link.sh vqfx1 alpine1f
scripts/add_link.sh vqfx1 dhcptester1
scripts/add_link.sh vqfx1 dhcptester2

scripts/add_link.sh vqfx2 alpine2a
scripts/add_link.sh vqfx2 alpine2b

scripts/add_link.sh vqfx3 alpine3a
scripts/add_link.sh vqfx3 alpine3b

scripts/add_link.sh vqfx4 alpine4a
scripts/add_link.sh vqfx4 alpine4b
