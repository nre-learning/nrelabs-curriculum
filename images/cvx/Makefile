# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	gsutil cp "gs://nrelabs-curriculum-base-images/cvx/cvx.qcow2" "./cvx.qcow2"
	docker build -t antidotelabs/cvx:$(TARGET_VERSION) .
	docker push antidotelabs/cvx:$(TARGET_VERSION)

