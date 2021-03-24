# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/pjsua-lindsey:$(TARGET_VERSION) .
	docker push antidotelabs/pjsua-lindsey:$(TARGET_VERSION)

dockerfast:
	docker build --pull -t antidotelabs/pjsua-lindsey:$(TARGET_VERSION) .
	docker push antidotelabs/pjsua-lindsey:$(TARGET_VERSION)
