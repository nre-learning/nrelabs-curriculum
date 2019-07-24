# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build -t antidotelabs/salt:$(TARGET_VERSION) .
	docker push antidotelabs/salt:$(TARGET_VERSION)
