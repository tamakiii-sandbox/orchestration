IMAGE := hashicorp/terraform:0.11.1
ARGS  :=

MAKE := $(shell which make)

setup:
	docker pull ${IMAGE}

init:
	$(MAKE) terraform/init

plan:
	$(MAKE) terraform/plan ARGS="-out=terraform.tfplan"

apply:
	$(MAKE) terraform/apply ARGS=terraform.tfplan

destroy:
	$(MAKE) terraform/destroy

validate:
	$(MAKE) terraform/validate

sh:
	docker run -it --entrypoint sh ${IMAGE}

terraform/%:
	docker run -it -v $(CURDIR):/work -w /work -v ~/.aws:/root/.aws ${IMAGE} $(@F) ${ARGS}
