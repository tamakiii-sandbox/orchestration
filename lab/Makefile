IMAGE := hashicorp/terraform:0.11.1
ARGS  :=

MAKE := $(shell which make)

secret_config := "config/secret.hcl"

setup:
	docker pull ${IMAGE}

plan:
	$(MAKE) terraform/plan ARGS="-out=terraform.tfplan -var-file=${secret_config}"

apply:
	$(MAKE) terraform/apply ARGS=terraform.tfplan

destroy:
	$(MAKE) terraform/destroy ARGS="-var-file=${secret_config}"

validate:
	$(MAKE) terraform/validate

sh:
	docker run -it --entrypoint sh ${IMAGE}

terraform/%:
	docker run -it -v $(CURDIR):/work -w /work -v ~/.aws:/root/.aws ${IMAGE} $(@F) ${ARGS}


