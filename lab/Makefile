IMAGE := hashicorp/terraform:0.11.1
ARGS  :=

setup:
	docker pull ${IMAGE}

sh:
	docker run -it --entrypoint sh ${IMAGE}

terraform/%:
	docker run -it -v $(CURDIR):/work -w /work -v ~/.aws:/root/.aws ${IMAGE} $(@F) ${ARGS}

