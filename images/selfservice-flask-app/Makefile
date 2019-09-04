# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	docker build --pull --no-cache -t antidotelabs/selfservice-flask-app:$(TARGET_VERSION) .
	docker push antidotelabs/selfservice-flask-app:$(TARGET_VERSION)
