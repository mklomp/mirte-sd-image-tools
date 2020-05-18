#!/bin/bash

if test "$1" == "shell"
then
    sudo singularity run --writable --app shell --bind .:/working_dir virtual_armbian.simg
fi
if test "$1" == "shell_local"
then
    sudo singularity exec --bind .:/working_dir virtual_armbian.simg /bin/bash -c "export SD_IMAGE=/working_dir/zoef_sd.img && /mount_image.sh && chroot /mnt/armbian"
fi
if test "$1" == "build_sd_image"
then
    sudo singularity exec --bind .:/working_dir virtual_armbian.simg /bin/bash -c "/mount_image.sh && /install_zoef.sh && /umount_image.sh && /resize_image.sh && cp /zoef_sd.img /working_dir"
    sudo chown $USER:$USER zoef_sd.img
fi
