#!/bin/bash
# Copyright (c) 2018, Juniper Networks, Inc.
# All rights reserved.

set -e 	# terminate on error

testmtu/add_link.sh vqfx1 alpine1a
testmtu/add_link.sh vqfx1 alpine1b
