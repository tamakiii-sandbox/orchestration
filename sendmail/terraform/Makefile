mkfile_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
root_dir   := $(abspath $(mkfile_dir)/..)
cwd        := $(subst $(root_dir)/,,$(abspath .))

out_file   := $(cwd)/terraform.tfplan
terraform  := $(root_dir)/bin/terraform

reconfigure    := -reconfigure
config_files   ?= $(shell cd $(root_dir) && find terraform/config -type f -name '*.hcl')
config_options ?= $(foreach f,$(config_files),-var-file=$(f))

init:
	$(terraform) init $(config_options) $(reconfigure) $(cwd)

plan:
	$(terraform) plan $(config_options) -out=$(out_file) $(cwd)

apply:
	$(terraform) apply $(out_file)

destroy:
	$(terraform) destroy $(config_options) $(cwd)

refresh:
	$(terraform) refresh
