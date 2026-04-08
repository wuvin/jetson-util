#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="."  # "$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
IMAGE_NAME="jetson-util"
DESC="General utilities and tools for Jetson host"

# Build
echo ">>> Building ${IMAGE_NAME}..."
docker build \
    --network=host \
    -f "${REPO_ROOT}/Dockerfile" \
    -t "${IMAGE_NAME}" \
    --label org.opencontainers.image.description="${DESC}" \
    "${REPO_ROOT}"
echo ">>> Build complete."

# docker image prune -f >/dev/null