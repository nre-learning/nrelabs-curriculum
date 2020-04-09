# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	# docker build --pull --no-cache -t antidotelabs/ansible:$(TARGET_VERSION) .
	docker build --pull -t antidotelabs/ansible:$(TARGET_VERSION) .
	# docker build --pull -t antidotelabs/ansible:$(TARGET_VERSION) .
	docker push antidotelabs/ansible:$(TARGET_VERSION)
