#!/bin/bash

rpi4b_link="https://cdimage.ubuntu.com/releases/20.04.5/release/ubuntu-20.04.5-preinstalled-server-armhf+raspi.img.xz"
orangepizero_link="https://archive.armbian.com/orangepizero/archive/Armbian_21.02.3_Orangepizero_focal_current_5.10.21.img.xz"
orangepizero2_link="https://archive.armbian.com/orangepizero2/archive/Armbian_22.02.2_Orangepizero2_focal_legacy_4.9.255.img.xz"

image="custom"
if [ "$1" = "" ]; then
   image="orangepizero2"
else
   image=$1
fi

link=$image"_link"

if [ "$image" = "custom" ]; then
   cp $1 mirte_custom_sd.img
else
   # Download and unxz the file
   # TODO:aks for permission to overwrite
   wget -O mirte_${image}_sd.img.xz "${!link}"
   rm -f mirte_${image}_sd.img
   unxz mirte_${image}_sd.img.xz
fi
