# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/kali:$(TARGET_VERSION) .
	docker push antidotelabs/kali:$(TARGET_VERSION)
