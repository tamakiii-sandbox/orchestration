IMAGE     := hashicorp/terraform:0.11.3
TERRAFORM := docker run -it -v $(CURDIR):/work -w /work -v ~/.aws:/root/.aws -v ~/.ssh:/root/.ssh $(IMAGE)
OUT_FILE  := terraform.tfplan

config_files   ?= $(shell find config -name "*.tfvars" -o -name "*.hcl")
config_options ?= $(foreach f,$(config_files),-var-file="$(f)")

setup:
	docker pull $(IMAGE)

init:
	$(TERRAFORM) init

plan:
	$(TERRAFORM) plan $(config_options) -out=$(OUT_FILE)

apply:
	$(TERRAFORM) apply $(OUT_FILE)

destroy:
	$(TERRAFORM) destroy $(config_options)

validate:
	$(TERRAFORM) validate

import: require/ADDR require/ID
	$(TERRAFORM) import $(ADDR) $(ID)

refresh:
	$(TERRAFORM) refresh

show:
	$(TERRAFORM) show

output:
	$(TERRAFORM) output $(NAME)

state-rm: require/ADDRESS
	$(TERRAFORM) state rm $(ADDRESS)

login:
	docker run -it --entrypoint sh $(IMAGE)

help:
	$(TERRAFORM) --help

help/%:
	$(TERRAFORM) $(@F) --help

require/%:
	@if [ -z "$($(@F))" ]; then echo "$(@F) is required. $($(@F))" && exit 1; fi
