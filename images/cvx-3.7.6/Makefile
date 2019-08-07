# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build -t antidotelabs/cvx-3.7.6:$(TARGET_VERSION) .
	docker push antidotelabs/cvx-3.7.6:$(TARGET_VERSION)
