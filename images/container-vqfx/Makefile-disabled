# SHELL=/bin/bash

TARGET_VERSION ?= latest

all: docker

docker:

	./download_packages.sh

	TARGET_VERSION=$(TARGET_VERSION) ./build.sh

	# The below might be useful for building an image with snapshots.
	# Currently leaving this commented out so that we can finish the rest of the pipeline without this added
	# complexity, not to mention that some infrastructure improvements (both prod and selfmedicate) might mean
	# we don't need to do the snapshot trick. However, if it proves necessary in the future, this does work,
	# we just need to add the logic to copy the resulting disk file out and into its own container, so we don't
	# create a monster image.
	#
	# docker kill vqfx-full || true
	# docker rm vqfx-full || true
	# sleep 5
	# docker run -d --name vqfx-full -v $$(pwd):/cap --rm -p 2222:22 -p 4001:4000 -p 5001:5000 --privileged antidotelabs/vqfx-full:$(TARGET_VERSION)
	# ./wait_for_live.sh
	# docker exec vqfx-full /create_snapshot.expect

	docker push antidotelabs/container-vqfx:$(TARGET_VERSION)
