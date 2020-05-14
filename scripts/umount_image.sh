#!/bin/bash

# Cleanup
rm /mnt/armbian/usr/bin/qemu-arm-static

# Unmount
umount /mnt/armbian/dev/pts
umount /mnt/armbian/dev
umount /mnt/armbian/sys
umount /mnt/armbian/proc
umount /mnt/armbian/
