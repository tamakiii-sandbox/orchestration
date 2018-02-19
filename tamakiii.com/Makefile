TERRAFORM := bin/terraform
OUT_FILE  := terraform.tfplan

config_files   ?= $(shell find config -name "*.tfvars" -o -name "*.hcl")
config_options ?= $(foreach f,$(config_files),-var-file="$(f)")

plan:
	$(TERRAFORM) plan $(config_options) -out=$(OUT_FILE)

apply:
	$(TERRAFORM) apply $(OUT_FILE)

destroy:
	$(TERRAFORM) destroy $(config_options)
