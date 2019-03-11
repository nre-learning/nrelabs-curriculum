# Copyright (c) 2018, Juniper Networks, Inc.
# All rights reserved.

all: build

build: src/cosim.tgz
	./build.sh

src/cosim.tgz:
	cd vagrant && ./extract_pfe_files.sh ../src

run:
	docker run -ti --rm --name vqfx --privileged antidote/vqfx:18.4R1.8

stop:
	docker kill vqfx || true
