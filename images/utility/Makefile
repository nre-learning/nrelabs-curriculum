# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/utility:$(TARGET_VERSION) .
	docker push antidotelabs/utility:$(TARGET_VERSION)
