#!/bin/bash

if test "$1" == "shell_local"
then
   sudo singularity run --app load_image --bind ./zoef_${2}_sd.img:/zoef_sd.img image_tools.sif
fi
if test "$1" == "build_sd_image"
then
   image="orangepi"
   if [ $2 ]; then
      image=$2
   fi
   singularity run --app download_image image_tools.sif $image
   sudo singularity run --app prepare_image --bind ./zoef_${image}_sd.img:/zoef_sd.img image_tools.sif
   sudo singularity run --app install_zoef --bind ./zoef_${image}_sd.img:/zoef_sd.img --bind ./repos.yaml:/repos.yaml --bind ./git_local:/git_local image_tools.sif
   sudo singularity run --app shrink_image --bind ./zoef_${image}_sd.img:/zoef_sd.img image_tools.sif
   zip -r ./zoef_v`date +"%Y%m%d"`_${image}_sd.img.zip ./zoef_${image}_sd.img
fi
