mkfile_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
root_dir   := $(abspath $(mkfile_dir)/..)

profile := tamakiii
debug   :=
environments := export AWS_PROFILE=$(profile) && export PACKER_LOG=$(debug)
packer  := $(environments) && $(root_dir)/bin/packer

build:
	$(packer) build packer/example.json

validate:
	$(packer) validate packer/example.json

inspect:
	$(packer) inspect packer/example.json

help:
	$(packer) --help

%/help:
	$(packer) $(@D) --help
