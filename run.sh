#!/bin/bash

if test "$1" == "shell"
then
    sudo singularity run --app shell --bind .:/working_dir virtual_armbian.simg
fi
# TODO: be able to mount alredy existing image zoef_sd.img
# TODO: be able to execute a script
if test "$1" == "build_sd_image"
then
    sudo singularity exec --bind .:/working_dir virtual_armbian.simg /bin/bash -c "/mount_image.sh && /install_zoef.sh"
    sudo chown $USER:$USER zoef_sd.img
fi
