NAME = "symfony-4.0"

build:
	docker-compose build

start:
	docker-compose up -d --remove-orphans

login/%:
	docker exec -it $(shell docker ps -q -f ancestor=${NAME}/$(@F)) ash

