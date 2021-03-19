# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/asterisk:$(TARGET_VERSION) .
	docker push antidotelabs/asterisk:$(TARGET_VERSION)

dockerfast:
	docker build --pull -t antidotelabs/asterisk:$(TARGET_VERSION) .
	docker push antidotelabs/asterisk:$(TARGET_VERSION)
