#!/usr/bin/env bash

set -euxo pipefail

SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
OUT_DIR="${SCRIPT_DIR}/out"
REVISION=$(git --work-tree="${SCRIPT_DIR}"/../ --git-dir="${SCRIPT_DIR}"/../.git \
  rev-parse HEAD)
BUILDER_TAG_NAME="rust-overlay_builder:$REVISION"

echo "Creating builder container image..."
# Need to run docker build in script's parent directory
cd "${SCRIPT_DIR}/.."
docker build -f "${SCRIPT_DIR}/Dockerfile" -t "${BUILDER_TAG_NAME}" .
docker images "${BUILDER_TAG_NAME}"
rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}"

echo "Cross building started..."
docker run -v "${OUT_DIR}":/tmp/out_rust-overlay --rm -i "${BUILDER_TAG_NAME}" << CMD
mkdir -p /tmp/out_rust-overlay && \
cp -r /build/rust-cross-build-nix/out/* /tmp/out_rust-overlay/
CMD

echo
echo "============ HELLO-RANDOM ARTIFACTS INFO ============"
echo "Artifacts created in ${OUT_DIR}/"
echo "sha256sums:"
sha256sum "${OUT_DIR}"/hello-random* | sort -k2
echo