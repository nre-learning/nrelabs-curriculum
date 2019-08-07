# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build -t antidotelabs/asterisk:$(TARGET_VERSION) .
	docker push antidotelabs/asterisk:$(TARGET_VERSION)
