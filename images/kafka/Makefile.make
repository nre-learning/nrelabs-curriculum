# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/kafka:$(TARGET_VERSION) .
	docker push antidotelabs/kafka:$(TARGET_VERSION)