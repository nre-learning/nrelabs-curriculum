# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/stackstorm:$(TARGET_VERSION) .
	docker push antidotelabs/stackstorm:$(TARGET_VERSION)
