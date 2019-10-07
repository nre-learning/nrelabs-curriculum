# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	gsutil cp "gs://nrelabs-curriculum-base-images/frr-7.2-dev/frr-7.2-dev.qcow2" "./frr.qcow2"
	docker build --pull --no-cache -t antidotelabs/frr:$(TARGET_VERSION) .
	docker push antidotelabs/frr:$(TARGET_VERSION)

