mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

.PHONY: cross-rs rust-overlay cr-clean ro-clean clean

all: cross-rs rust-overlay

cross-rs:
	make -C $(mkfile_dir)/nix-cross-rs

cr-clean:
	make -C $(mkfile_dir)/nix-cross-rs clean

rust-overlay:
	make -C $(mkfile_dir)/nix-rust-overlay r10e-build

ro-clean:
	make -C $(mkfile_dir)/nix-rust-overlay clean

clean: cr-clean ro-clean
