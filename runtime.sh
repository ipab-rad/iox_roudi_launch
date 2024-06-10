#!/bin/bash
# ---------------------------------------------------------------------------
# Build docker image and run ROS code for runtime or interactively with bash
# ---------------------------------------------------------------------------

# Initialise CMD as empty
CMD=""

# If an arg is defined, start container with bash
if [ -n "$1" ]; then
    CMD="bash"
fi

# Build docker image only up to base stage
DOCKER_BUILDKIT=1 docker build \
    -t av_iox_roudi_launch:latest \
    -f Dockerfile --target runtime .


# Run docker image
docker run -it --rm --net host --privileged \
    -v /dev:/dev \
    -v /tmp:/tmp \
    -v /etc/localtime:/etc/localtime:ro \
    av_iox_roudi_launch:latest $CMD
