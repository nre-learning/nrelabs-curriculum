# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build -t antidotelabs/utility-vm:$(TARGET_VERSION) .
	docker push antidotelabs/utility-vm:$(TARGET_VERSION)
