# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/wordpress:$(TARGET_VERSION) .
	docker push antidotelabs/wordpress:$(TARGET_VERSION)
