mkfile_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
root_dir   := $(abspath $(mkfile_dir)/..)

profile := tamakiii
packer  := export AWS_PROFILE=$(profile) && $(root_dir)/bin/packer

build:
	$(packer) build packer/example.json

validate:
	$(packer) validate packer/example.json

help:
	$(packer) --help
