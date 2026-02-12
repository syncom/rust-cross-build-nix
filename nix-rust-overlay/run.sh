#!/usr/bin/env bash

set -euxo pipefail

SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
OUT_DIR="${SCRIPT_DIR}/out"
REVISION=$(git --work-tree="${SCRIPT_DIR}"/../ --git-dir="${SCRIPT_DIR}"/../.git \
  rev-parse HEAD)
BUILDER_TAG_NAME="rust-overlay_builder:$REVISION"

#########################################
# Self test
#########################################
err() {
  echo -e "$*"
  exit 1
}

self_test() {
  # Check sha256sum
  command -v sha256sum &>/dev/null || \
    err "sha256sum not found. Please install coreutils first"

  # Check docker
  docker info &>/dev/null || \
    err "Make sure docker daemon is running"
}

# Let's go
self_test
echo "Creating builder container image..."
# Need to run docker build in script's parent directory
cd "${SCRIPT_DIR}/.."
docker buildx build \
  --platform linux/amd64 \
  --load \
  -f "${SCRIPT_DIR}/Dockerfile" \
  -t "${BUILDER_TAG_NAME}" \
  . \
  --builder "$(docker buildx create \
              --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=-1 \
              --driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=-1)"


docker images "${BUILDER_TAG_NAME}"
rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}"

echo "Cross building started..."
docker run --platform linux/amd64 -v "${OUT_DIR}":/tmp/out_rust-overlay --rm -i "${BUILDER_TAG_NAME}" << CMD
mkdir -p /tmp/out_rust-overlay && \
cp -r /build/rust-cross-build-nix/out/* /tmp/out_rust-overlay/
CMD

echo
echo "============ HELLO-RANDOM ARTIFACTS INFO ============"
echo "Artifacts created in ${OUT_DIR}/"
echo "sha256sums:"
sha256sum "${OUT_DIR}"/hello-random* | sort -k2
echo
