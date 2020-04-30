# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	# wget -nc -q -O exos.qcow2 https://akamai-ep.extremenetworks.com/Extreme_P/github-en/Virtual_EXOS/EXOS-VM_v30.5.1.15.qcow2
	# wget -nc -q -O exos.iso https://akamai-ep.extremenetworks.com/Extreme_P/github-en/Virtual_EXOS/vm-30.6.1.11.iso

	# docker build --pull --no-cache -t antidotelabs/exos:$(TARGET_VERSION) .
	docker build --pull -t antidotelabs/exos:$(TARGET_VERSION) .
	# docker push antidotelabs/exos:$(TARGET_VERSION)

