# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	gsutil cp "gs://nrelabs-curriculum-base-images/cvx-3.7.8/cvx-3.7.8.qcow2" "./cvx.qcow2"
	docker build --pull --no-cache -t antidotelabs/cvx:$(TARGET_VERSION) .
	docker push antidotelabs/cvx:$(TARGET_VERSION)

