# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build -f Dockerfile.buildenv --pull --no-cache -t antidotelabs/ansible-tower-build:$(TARGET_VERSION) .
	docker run -ti --rm --privileged --device /dev/kvm --mount source=ansible-tower-image,target=/output --name ansible-tower-build antidotelabs/ansible-tower-build:$(TARGET_VERSION)
	docker build -f Dockerfile.runtime --pull --no-cache -t antidotelabs/ansible-tower-qemu:$(TARGET_VERSION) .
