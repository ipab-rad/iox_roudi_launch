FROM ros:humble-ros-base-jammy AS base

# Install key dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get -y --quiet --no-install-recommends install \
        ros-"$ROS_DISTRO"-rmw-cyclonedds-cpp \
    && rm -rf /var/lib/apt/lists/*

# Setup ROS workspace folder
ENV ROS_WS /opt/ros_ws
WORKDIR $ROS_WS

# Set cyclone DDS ROS RMW
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

COPY ./roudi_config.toml $ROS_WS/

# Add tools to PATH
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /root/.bashrc

# -----------------------------------------------------------------------

FROM base AS dev

# Install basic dev tools (And clean apt cache afterwards)
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get -y --quiet --no-install-recommends install \
        # Command-line editor
        nano \
        # Ping network tools
        inetutils-ping \
        # Bash auto-completion for convenience
        bash-completion \
    && rm -rf /var/lib/apt/lists/*

# Add colcon build alias for convenience
RUN echo 'alias colcon_build="colcon build --symlink-install \
    --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    source install/setup.bash"' >> /root/.bashrc

# Enter bash for clvelopment
CMD ["bash"]

# -----------------------------------------------------------------------

FROM base as runtime

# Start recording a rosbag by default
CMD ["iox-roudi", "-c", "/opt/ros_ws/roudi_config.toml"]
