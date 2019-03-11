# Copyright (c) 2019, Juniper Networks, Inc.
# All rights reserved.

all: up

build: 
	./build.sh	

id_rsa.pub:
	cp ~/.ssh/id_rsa.pub .

up: id_rsa.pub
	kubectl create -f vqfx1.yml

ps:
	kubectl get pods 
	./getpass.sh

down:
	kubectl delete -f vqfx1.yml

