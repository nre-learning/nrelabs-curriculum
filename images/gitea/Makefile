# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:

	docker build --pull --no-cache -t antidotelabs/gitea:$(TARGET_VERSION) .
	docker push antidotelabs/gitea:$(TARGET_VERSION)

dockerfast:
	# Foo
	docker build --pull -t antidotelabs/gitea:$(TARGET_VERSION) .
	docker push antidotelabs/gitea:$(TARGET_VERSION)
