# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:

	./download_packages.sh

	docker build -t antidotelabs/vqfx:$(TARGET_VERSION) .
	docker push antidotelabs/vqfx:$(TARGET_VERSION)
