# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/webserver:$(TARGET_VERSION) .
	docker push antidotelabs/webserver:$(TARGET_VERSION)
