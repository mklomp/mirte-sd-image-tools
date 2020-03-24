#!/bin/bash

# Cleanup
rm /mnt/armbian/usr/bin/qemu-arm-static
rm /mnt/armbian/network_install.sh
rm /mnt/armbian/install_zoef.sh

# Unmount
umount /mnt/armbian/dev/pts
umount /mnt/armbian/dev
umount /mnt/armbian/sys
umount /mnt/armbian/proc
umount /mnt/armbian/
