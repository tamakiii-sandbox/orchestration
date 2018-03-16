
build:
	docker-compose build

up: build
	docker-compose up

clean:
	make -C terraform clean

destroy:
	make -C terraform/route53 init destroy
	make -C terraform/ec2 init destroy
	make -C terraform/ecr init destroy
	make -C terraform/ecs init destroy
	make -C terraform/network init destroy
