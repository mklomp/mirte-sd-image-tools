#!/bin/bash

SD_IMAGE="${SD_IMAGE:-/zoef_sd.img}"

# Mount image and resize filesystem
mkdir -p /mnt/armbian
mount -o loop,offset=269484032 $SD_IMAGE /mnt/armbian  #TODO: mount without offset

# Mount other folders
cp /usr/bin/qemu-arm-static /mnt/armbian/usr/bin/
mount --bind /dev /mnt/armbian/dev/
mount --bind /sys /mnt/armbian/sys/
mount --bind /proc /mnt/armbian/proc/
mount --bind /dev/pts /mnt/armbian/dev/pts
