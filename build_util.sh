#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="."  # "$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
IMAGE_NAME="jetson-util"
DESC="General utilities and tools for Jetson host"

DXL_WIZARD_RUN="DynamixelWizard2Setup-linux-arm64.run"

# Check for Wizard 2.0
if [ -f "${REPO_ROOT}/${DXL_WIZARD_RUN}" ]; then
    echo ">>> Found Dynamixel Wizard 2.0 (${DXL_WIZARD_RUN})."
else
    echo ">>> WARNING: Dynamixel Wizard 2.0 not found in build context."
    echo "    Download (https://www.robotis.com/service/download.php?no=2233)"
    echo "    and place it in this directory as ${DXL_WIZARD_RUN}"
fi

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