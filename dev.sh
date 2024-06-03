#!/bin/bash
# ----------------------------------------------------------------
# Build docker dev stage and add local code for live development
# ----------------------------------------------------------------


# Build docker image up to dev stage
DOCKER_BUILDKIT=1 docker build \
    -t av_iox_roudi_launch:latest-dev \
    -f Dockerfile --target dev .

# Get the absolute path of the script
SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

# Run docker image with local code volumes for development
docker run -it --rm --net host --privileged \
    -v /dev:/dev \
    -v /tmp:/tmp \
    -v $SCRIPT_DIR/roudi_config.toml:/opt/ros_ws/roudi_config.toml \
    -v /etc/localtime:/etc/localtime:ro \
    av_iox_roudi_launch:latest-dev
