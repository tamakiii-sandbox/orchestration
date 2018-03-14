mkfile_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
root_dir   := $(abspath $(mkfile_dir)/..)
target_dir := $(abspath .)
cwd        := $(subst $(root_dir)/,,$(target_dir))

out_file   := $(cwd)/terraform.tfplan
terraform  := $(root_dir)/bin/terraform

config_files   ?= terraform/config/config.hcl
config_options ?= $(foreach f,$(config_files),-var-file=$(f))

init:
	$(terraform) init $(config_options) $(cwd)

plan:
	$(terraform) plan $(config_options) -out=$(out_file) $(cwd)

apply:
	$(terraform) apply $(out_file) $(cwd)

destroy:
	$(terraform) destroy $(config_options) $(cwd)
