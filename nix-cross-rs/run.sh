#!/usr/bin/env bash

set -euxo pipefail

SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
OUT_DIR="${SCRIPT_DIR}/out"
REVISION=$(git --work-tree="${SCRIPT_DIR}"/../ --git-dir="${SCRIPT_DIR}"/../.git \
  rev-parse HEAD)
BUILDER_TAG_NAME="cross-rs_builder:$REVISION"

echo "Creating builder container image..."
# Need to run docker build in script's parent directory
cd "${SCRIPT_DIR}/.."
docker build -f "${SCRIPT_DIR}/Dockerfile" -t "${BUILDER_TAG_NAME}" .
docker images "${BUILDER_TAG_NAME}"
rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}"

echo "Cross building started..."
docker run --privileged -v /var/lib/containers/storage -v "${OUT_DIR}":/build/rust-cross-build-nix/out --rm -i "${BUILDER_TAG_NAME}"

echo
echo "============ HELLO-RANDOM ARTIFACTS INFO ============"
echo "Artifacts created in ${OUT_DIR}/"
echo "sha256sums:"
sha256sum "${OUT_DIR}"/hello-random* | sort -k2
echo
