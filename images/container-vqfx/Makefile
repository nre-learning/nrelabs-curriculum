# Copyright (c) 2018, Juniper Networks, Inc.
# All rights reserved.

all: build

build: src/cosim.tgz
	docker build -f src/Dockerfile -t juniper/container-vqfx src
	docker-compose -f testmtu/docker-compose.yml build

src/cosim.tgz:
	cd vagrant && ./extract_pfe_files.sh ../src

FORCE: ;

id_rsa.pub:
	cp ~/.ssh/id_rsa.pub .

up: id_rsa.pub
	docker-compose up -d
	sudo scripts/lldp_passthru.sh

regress: id_rsa.pub regression/docker-compose.yml
	docker-compose -f regression/docker-compose.yml up -d
	regression/add_links.sh
	regression/check.sh
	regression/check_clients.sh

mtu: id_rsa.pub testmtu/docker-compose.yml
	docker-compose -f testmtu/docker-compose.yml up -d
	testmtu/add_links.sh
	testmtu/check.sh
	testmtu/check_clients.sh

ps:
	docker-compose ps
	@echo ""
	docker-compose -f regression/docker-compose.yml ps
	@echo ""
	docker-compose -f testmtu/docker-compose.yml ps
	@echo ""
	scripts/getpass.sh

down:
	docker-compose down
	docker-compose -f regression/docker-compose.yml down
	docker-compose -f testmtu/docker-compose.yml down

clean:
	docker system prune -f
	docker volume prune -f
	rm -f id_rsa.pub
