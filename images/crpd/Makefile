# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	gsutil cp "gs://nrelabs-curriculum-base-images/crpd/junos-routing-crpd-docker-20.2R1.10.tgz" "./crpd.tgz"
	docker load -i crpd.tgz

	docker build --no-cache -t antidotelabs/crpd:$(TARGET_VERSION) .
	docker push antidotelabs/crpd:$(TARGET_VERSION)

dockerfast:
	gsutil cp "gs://nrelabs-curriculum-base-images/crpd/junos-routing-crpd-docker-20.2R1.10.tgz" "./crpd.tgz"
	docker load -i crpd.tgz

	docker build -t antidotelabs/crpd:$(TARGET_VERSION) .
	docker push antidotelabs/crpd:$(TARGET_VERSION)
