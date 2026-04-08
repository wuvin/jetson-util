#!/usr/bin/env bash
set -euo pipefail
# run_util.sh — launch for util container

CONTAINER_NAME="util"

# Remove stale container with same name if it exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo ">>> Removing existing container '${CONTAINER_NAME}'..."
    docker rm -f "${CONTAINER_NAME}" > /dev/null
fi

# Set container options
FLAGS=(
    # Container instance settings
    --runtime nvidia -it --rm --privileged
    # Name
    --name "${CONTAINER_NAME}"
    # Host sharing
    --network host --ipc host --pid host
    # Directory mounts
    -v /:/host:rw
    -v /home:/home:rw
    -v /media:/media:rw
    -v /mnt:/mnt:rw
    -v /tmp:/tmp:rw
    # Device visibility
    -v /dev:/dev
    # RealSense device mappings
    -v /run/udev:/run/udev:ro
    --group-add video
    --device-cgroup-rule "c 81:* rmw"
    --device-cgroup-rule "c 189:* rmw"
    # Time
    -v /etc/timezone:/etc/timezone:ro
    -v /etc/localtime:/etc/localtime:ro
    # Display
    # -e "TERM=${TERM:-xterm-256color}"
    -e DISPLAY="${DISPLAY:-:0}"
    # Misc
    -v /var/log:/var/log:ro
    # X11 forwarding
    -e QT_X11_NO_MITSHM=1
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw
)

# Run
echo ">>> Starting ${CONTAINER_NAME}..."
exec docker run "${FLAGS[@]}" "${IMAGE_NAME}"