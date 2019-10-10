#!/bin/bash

# Install ROS Melodic
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update
sudo apt install ros-melodic-ros-base python-rosinstall python-rosinstall-generator python-wstool build-essential python-catkin-tools
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

# Install Zoef ROS package (TODO: create rosinstall/rosdep)
sudo apt install ros-melodic-controller-manager ros-melodic-rosbridge-server ros-melodic-diff-drive-controller
mkdir ~/zoef_ws/src
cd ~/zoef_ws/src
git clone https://gitlab.tudelft.nl/rcj_zoef/zoef_ros_package.git
cd ..
catkin build
echo "source /home/zoef/zoef_ws/devel/setup.bash" >> ~/.bashrc

# TODO: add systemd service to start ros

# Install Zoef Interface
sudo apt install singularity-container
cd ~
git clone https://gitlab.tudelft.nl/rcj_zoef/web_interface.git
sed -i 's/From: ubuntu:bionic/From: arm32v7\/ubuntu:bionic/g' Singularity
./run_singularty init

# TODO: add systemd service to start interface
