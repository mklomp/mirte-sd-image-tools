#!/bin/bash

EMMC_DEV=/dev/mmcblk0
IMAGE=/root/mirte_orangepi3b.img
# This script is used to install the Mirte image onto the emmc.

# Check if the script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# check image exists
if [ ! -f $IMAGE ]; then
  echo "$IMAGE not found"
  exit
fi

# check if the emmc exists
if [ ! -b $EMMC_DEV ]; then
  echo "emmc not found"
  exit
fi

# write the image to the emmc
echo "Writing $IMAGE to $EMMC_DEV"
# dd if=$IMAGE of=$EMMC_DEV bs=4M status=progress
cat $IMAGE > $EMMC_DEV
# sync
sync

# check if the image was written successfully by using checksum
echo "Verifying $IMAGE"
head -c "$(stat -c %s $IMAGE)" $EMMC_DEV | md5sum -c $IMAGE.md5sum


# check return code
if [ $? -eq 0 ]; then
  echo "Mirte image installed successfully"
else
  echo "Mirte image installation failed"
fi

source /usr/lib/u-boot/platform_install.sh
write_uboot_platform_mtd $DIR /dev/mtdblock0 



shutdown

