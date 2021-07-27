#!/bin/bash

# Ask for sudo password once, and make sure the timeout will
# not expire.
sudo -v
while true; do
   sudo -nv; sleep 1m
   kill -0 $$ 2>/dev/null || exit
done &


if test "$1" == "image_shell"
then
   # Shell into the SD card image. This means mounting the the image
   # and chroot 'into' the image.
   sudo singularity run --app load_image --bind ./zoef_${2}_sd.img:/zoef_sd.img image_tools.sif
fi
if test "$1" == "singularity_shell"
then
   #TODO: also bind the repos.yaml and git_local?
   sudo singularity shell --bind ./zoef_${2}_sd.img:/zoef_sd.img image_tools.sif
fi
if test "$1" == "build_sd_image"
then
   # Determine which image to build
   image="orangepi"
   if [ $2 ]; then
      image=$2
   fi

   # Download and resize the image to 8Gb
   singularity run --app download_image image_tools.sif $image
   sudo singularity run --app prepare_image --bind ./zoef_${image}_sd.img:/zoef_sd.img image_tools.sif

   # Install zoef on the image
   if [ -f ./repos.yaml ] && [ -d ./git_local ]; then
     sudo singularity run --app install_zoef --bind ./zoef_${image}_sd.img:/zoef_sd.img --bind ./repos.yaml:/repos.yaml --bind ./git_local:/git_local image_tools.sif
   elif [ -f ./repos.yaml ]; then
     sudo singularity run --app install_zoef --bind ./zoef_${image}_sd.img:/zoef_sd.img --bind ./repos.yaml:/repos.yaml image_tools.sif
   elif [ -d ./git_local ]; then
     sudo singularity run --app install_zoef --bind ./zoef_${image}_sd.img:/zoef_sd.img --bind ./git_local:/git_local image_tools.sif
   fi

   # Shrink the image to max used size and zip it for convenience
   sudo singularity run --app shrink_image --bind ./zoef_${image}_sd.img:/zoef_sd.img image_tools.sif
   zip -r ./zoef_v`date +"%Y%m%d"`_${image}_sd.img.zip ./zoef_${image}_sd.img
fi
