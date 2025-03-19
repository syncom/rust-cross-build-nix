mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

all: cross-build

cross-build:
	$(mkfile_dir)/run.sh

clean:
	rm -rf $(mkfile_dir)/out
