# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/gnmic:$(TARGET_VERSION) .
	docker push antidotelabs/gnmic:$(TARGET_VERSION)

dockerfast:
	docker build --pull -t antidotelabs/gnmic:$(TARGET_VERSION) .
	docker push antidotelabs/gnmic:$(TARGET_VERSION)
