# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/zookeeper:$(TARGET_VERSION) .
	docker push antidotelabs/zookeeper:$(TARGET_VERSION)