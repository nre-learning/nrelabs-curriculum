# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:
	# TODO(mierdin): Enable this
	# gsutil cp "gs://nrelabs-curriculum-base-images/crd/junos-routing-crpd-docker-20.1R1.11.tgz" "./junos-routing-crpd-docker-20.1R1.11.tgz"
	docker load -i junos-routing-crpd-docker-20.1R1.11.tgz

	docker build --no-cache -t antidotelabs/crpd:$(TARGET_VERSION) .
	docker push antidotelabs/crpd:$(TARGET_VERSION)
