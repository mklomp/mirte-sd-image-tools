#!/bin/sh

raspberry_pi_link="https://cdimage.ubuntu.com/releases/20.04.3/release/ubuntu-20.04.3-preinstalled-server-armhf+raspi.img.xz"
orange_pi_link="https://archive.armbian.com/orangepizero/archive/Armbian_21.02.3_Orangepizero_focal_current_5.10.21.img.xz"

image="custom"
if [ "$1" = "" ] || [ "$1" = "orangepi" ]; then
   image="orangepi"
elif [ "$1" = "raspberrypi" ]; then
   image="raspberrypi"
fi

image_link=$orange_pi_link
if [ "$image" = "raspberrypi" ]; then
   image_link=$raspberry_pi_link
fi

if [ "$image" = "custom" ]; then
   cp $1 mirte_custom_sd.img
else
   # Download and unxz the file
   # TODO:aks for permission to overwrite
   wget -O mirte_${image}_sd.img.xz $image_link
   rm -f mirte_${image}_sd.img
   unxz mirte_${image}_sd.img.xz
fi
