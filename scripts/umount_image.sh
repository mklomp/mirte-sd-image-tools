#!/bin/bash

# Cleanup
rm /mnt/armbian/usr/bin/qemu-arm-static
rm -rf /mnt/armbian/working_dir

# Unmount
umount -l /mnt/armbian/dev/pts
umount -l /mnt/armbian/dev
umount -l /mnt/armbian/sys
umount -l /mnt/armbian/proc
umount -l /mnt/armbian/

