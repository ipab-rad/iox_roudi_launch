#!/bin/bash
# ----------------------------------------------------------------
# Build docker dev stage and add local code for live development
# ----------------------------------------------------------------


# Build docker image up to dev stage
DOCKER_BUILDKIT=1 docker build \
    -t av_iox_roudi_launch:latest-dev \
    -f Dockerfile --target dev .

# Run docker image with local code volumes for development
docker run -it --rm --net host --privileged \
    -v /dev:/dev \
    -v /tmp:/tmp \
    -v ./roudi_config.toml:/opt/ros_ws/roudi_config.toml \
    -v /etc/localtime:/etc/localtime:ro \
    av_iox_roudi_launch:latest-dev
