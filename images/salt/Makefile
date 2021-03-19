# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/salt:$(TARGET_VERSION) .
	docker push antidotelabs/salt:$(TARGET_VERSION)

dockerfast:
	docker build --pull -t antidotelabs/salt:$(TARGET_VERSION) .
	docker push antidotelabs/salt:$(TARGET_VERSION)
