#!/bin/bash

# Mount image and resize filesystem
loopvar=`losetup -f`
mkdir -p /mnt/armbian
mount -o loop=$loopvar,offset=4194304 /zoef_sd.img /mnt/armbian

# Mount other folders
cp /usr/bin/qemu-arm-static /mnt/armbian/usr/bin/
mount --bind /dev /mnt/armbian/dev/
mount --bind /sys /mnt/armbian/sys/
mount --bind /proc /mnt/armbian/proc/
mount --bind /dev/pts /mnt/armbian/dev/pts
