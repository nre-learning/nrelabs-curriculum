# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:

	# TODO(mierdin): Add step to download the crpd tgz from a private bucket and import

	# Currently using "crpd-custom:latest" because that's statically referenced in the linuxkit build
  # if you can make the linuxkit version dynamic then you can change both to use TARGET_VERSION
	docker build --no-cache -t crpd-custom:latest ./crpd-custom 
	linuxkit build -format=qcow2-bios crpd.yml

	docker build --pull --no-cache -t antidotelabs/crpd:$(TARGET_VERSION) .
	docker push antidotelabs/crpd:$(TARGET_VERSION)
