.PHONY: build start clean-start stop restart clean logs
export DOCKER_BUILDKIT=1
export BUILDER_REGISTRY_USERNAME=
export BUILDER_REGISTRY_PASSWORD=

build:
	docker-compose build

auth:
	docker run --entrypoint htpasswd registry:2 -Bbn ${BUILDER_REGISTRY_USERNAME} ${BUILDER_REGISTRY_PASSWORD} > htpasswd.registry

start:
	docker-compose up --force-recreate --build -d

clean-start: clean start

stop:
	docker-compose down --remove-orphans

restart: stop start

clean:
	docker-compose rm -f -s -v

logs:
	docker-compose logs -f