
IMAGE := hashicorp/terraform:0.11.1

setup:
	docker pull ${IMAGE}

init:
	docker run -it -v $(CURDIR):/work -w /work -v ~/.aws:/root/.aws ${IMAGE} init

plan:
	docker run -it -v $(CURDIR):/work -w /work -v ~/.aws:/root/.aws ${IMAGE} plan

sh:
	docker run -it -v $(CURDIR):/work -w /work -v ~/.aws:/root/.aws --entrypoint sh ${IMAGE}

