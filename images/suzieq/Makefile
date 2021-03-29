# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/suzieq:$(TARGET_VERSION) .
	docker push antidotelabs/suzieq:$(TARGET_VERSION)

dockerfast:
	docker build --pull -t antidotelabs/suzieq:$(TARGET_VERSION) .
	docker push antidotelabs/suzieq:$(TARGET_VERSION)
