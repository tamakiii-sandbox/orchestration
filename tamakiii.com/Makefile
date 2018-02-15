IMAGE     := hashicorp/terraform:0.11.3
TERRAFORM := docker run -it -v $(CURDIR):/work -w /work -v ~/.aws:/root/.aws $(IMAGE)

config_files   ?= $(shell find config -name "*.tfvars" -o -name "*.hcl")
config_options ?= $(foreach f,$(config_files),-var-file="$(f)")

setup:
	docker pull $(IMAGE)

init:
	$(TERRAFORM) init

plan:
	$(TERRAFORM) plan $(config_options) -out=terraform.tfplan

apply:
	$(TERRAFORM) apply terraform.tfplan

destroy:
	$(TERRAFORM) destroy $(config_options)

validate:
	$(TERRAFORM) validate $(NAME) $(VALUE)

import:
	$(TERRAFORM) import $(NAME) $(VALUE)

login:
	docker run -it --entrypoint sh $(IMAGE)

help:
	$(TERRAFORM) --help

help/%:
	$(TERRAFORM) $(@F) --help
