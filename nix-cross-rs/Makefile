mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

all: cross-build

cross-build:
	$(mkfile_dir)/run.sh 2>/dev/null

clean:
	rm -rf $(mkfile_dir)/out
