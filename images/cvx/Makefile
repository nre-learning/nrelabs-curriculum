# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build -t antidotelabs/cvx:$(TARGET_VERSION) .
	docker push antidotelabs/cvx:$(TARGET_VERSION)
