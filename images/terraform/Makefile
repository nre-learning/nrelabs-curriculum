# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/terraform:$(TARGET_VERSION) .
	docker push antidotelabs/terraform:$(TARGET_VERSION)

dockerfast:
	docker build --pull -t antidotelabs/terraform:$(TARGET_VERSION) .
	docker push antidotelabs/terraform:$(TARGET_VERSION)
