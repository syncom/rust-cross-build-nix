# This Makefile is expected to be run inside nix-shell.
TARGET ?= x86_64-unknown-linux-musl
CARGO_FLAGS := --release --target $(TARGET)

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

ifeq ($(TARGET),x86_64-pc-windows-gnu)
  SRC_BIN := $(mkfile_dir)/target/$(TARGET)/release/hello-random.exe
  DEST_BIN := $(mkfile_dir)/out/hello-random-$(TARGET).exe
	OPENSSL_STATIC_FLAG := OPENSSL_STATIC=0
else
  SRC_BIN := $(mkfile_dir)/target/$(TARGET)/release/hello-random
  DEST_BIN := $(mkfile_dir)/out/hello-random-$(TARGET)
	OPENSSL_STATIC_FLAG := OPENSSL_STATIC=1
endif

.PHONY: all
all: Cargo.toml Cargo.lock src/main.rs
	$(OPENSSL_STATIC_FLAG) cargo build -vv --locked $(CARGO_FLAGS)
	cp $(SRC_BIN) $(DEST_BIN)

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
