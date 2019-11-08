#!/bin/bash

if test -z $1  || test "$1" == "git"
then
    sudo singularity build --sandbox zoef_build Singularity
fi
if test "$1" == "local"
then
    echo "using local folders"
    cp Singularity Singularity.orig
    sed -i 's/%files/%setup\n    mkdir -p ${SINGULARITY_ROOTFS}\/local\n\n%files/g' Singularity
    sed -i 's/%files/%files\n    ..\/zoef_install_files \/local/g' Singularity
    [ -d "../zoef_arduino" ] && sed -i 's/%files/%files\n    ..\/zoef_arduino \/local/g' Singularity
    [ -d "../web_interface" ] && sed -i 's/%files/%files\n    ..\/web_interface \/local/g' Singularity
    [ -d "../zoef_ros_package" ] && sed -i 's/%files/%files\n    ..\/zoef_ros_package \/local/g' Singularity
    [ -d "../zoef_msgs" ] && sed -i 's/%files/%files\n    ..\/zoef_msgs \/local/g' Singularity
    sudo singularity build --sandbox zoef_build Singularity
    mv Singularity.orig Singularity
fi 
if test "$1" == "git_remote"
then
   REMOTE=zoef@192.168.42.1
   mkdir -p tmp
   cd tmp
   git clone ../../zoef_sd_card_image
   git clone $REMOTE:zoef_install_scripts
   cd zoef_install_scripts && git remote set-url origin http://gitlab.tudelft.nl/rcj_zoef/zoef_install_scripts && cd ..
   git clone $REMOTE:zoef_arduino
   cd zoef_arduino && git remote set-url origin http://gitlab.tudelft.nl/rcj_zoef/zoef_arduino && cd ..
   git clone $REMOTE:web_interface
   cd web_interface && git remote set-url origin http://gitlab.tudelft.nl/rcj_zoef/web_interface && cd ..
   mkdir -p zoef_ws/src
   cd zoef_ws/src
   git clone $REMOTE:zoef_ws/src/zoef_ros_package
   cd zoef_ros_package && git remote set-url origin http://gitlab.tudelft.nl/rcj_zoef/zoef_ros_package && cd ..
   git clone $REMOTE:zoef_ws/src/zoef_msgs
   cd zoef_msgs && git remote set-url origin http://gitlab.tudelft.nl/rcj_zoef/zoef_msgs && cd ..
   cd ../../zoef_sd_card_image
   ./build_image.sh local
fi


if test "$1" == "clean"
then
    sudo rm -rf zoef_build
fi
