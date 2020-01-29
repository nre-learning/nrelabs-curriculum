# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/gitlab:$(TARGET_VERSION) .
	docker push antidotelabs/gitlab:$(TARGET_VERSION)
