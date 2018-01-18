IMAGE := hashicorp/terraform:0.11.2
ARGS  :=
MAKE := $(shell which make)

config_files   ?= $(shell find config -name "*.tfvars" -o -name "*.hcl")
config_options ?= $(foreach f,${config_files},-var-file="${f}")

setup:
	docker pull ${IMAGE}

init:
	$(MAKE) terraform/init

plan:
	$(MAKE) terraform/plan ARGS="${config_options} -out=terraform.tfplan"

apply:
	$(MAKE) terraform/apply ARGS=terraform.tfplan

destroy:
	$(MAKE) terraform/destroy

validate:
	$(MAKE) terraform/validate

import:
	$(MAKE) terraform/import ARGS="${NAME} ${VALUE}"

sh:
	docker run -it --entrypoint sh ${IMAGE}

terraform/%:
	docker run -it -v $(CURDIR):/work -w /work -v ~/.aws:/root/.aws ${IMAGE} $(@F) ${ARGS}

