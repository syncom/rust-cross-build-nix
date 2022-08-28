mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

cross-rs:
	make -C $(mkfile_dir)/nix-cross-rs

cr-clean:
	make -C $(mkfile_dir)/nix-cross-rs clean

clean: cr-clean
