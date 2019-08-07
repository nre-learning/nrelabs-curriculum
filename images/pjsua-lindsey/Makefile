# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build -t antidotelabs/pjsua-lindsey:$(TARGET_VERSION) .
	docker push antidotelabs/pjsua-lindsey:$(TARGET_VERSION)
