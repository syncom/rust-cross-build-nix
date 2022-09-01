# This Makefile is expected to be run inside nix-shell.
TARGET ?= x86_64-unknown-linux-musl
CARGO_FLAGS := --release --target $(TARGET)

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

.PHONY: all
all: Cargo.toml Cargo.lock src/main.rs
	cargo build -vv --locked $(CARGO_FLAGS)
	cp target/$(TARGET)/release/hello-random out/hello-random-$(TARGET)

.PHONY: run
run: all
	cargo run $(CARGO_FLAGS)

# This target calls other targets to build reproducible artifacts
.PHONY: r10e-build
r10e-build: Dockerfile run.sh
	$(mkfile_dir)/run.sh

.PHONY: clean
clean:
	rm -rf $(mkfile_dir)/out
