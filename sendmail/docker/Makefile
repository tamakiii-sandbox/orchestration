compose   := docker-compose --project-directory $(realpath ..)
tag       := release
namespace := sendmail
host      := 825814182855.dkr.ecr.ap-northeast-1.amazonaws.com

release: build tag push
tag: tag/php
push: push/php

build:
	$(compose) build

tag/%:
	docker tag $(shell $(compose) images -q $(@F)) $(host)/$(namespace)/$(@F):$(tag)

push/%:
	docker push $(host)/$(namespace)/$(@F):$(tag)

clean:
	$(compose) down
