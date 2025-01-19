DOCKER = docker-compose -f srcs/docker-compose.yml

build:
	${DOCKER} build

up:
	${DOCKER} up -d

down:
	${DOCKER} down

run: build up

re: down run

prune: down
	docker system prune --all --force --volumes

fclean: down
	docker system prune --all --force --volumes
	sudo rm -rf /home/${USER}/data

logs:
	${DOCKER} logs -f

eval:
	@docker stop $(shell docker ps -qa); \
	docker rm $(shell docker ps -qa); \
	docker rmi $(shell docker images -qa); \
	docker volume rm $(shell docker volume ls -q); \
	docker network rm $(shell docker network ls -q) 2>/dev/null

.PHONY: build up down re run logs prune fclean eval
