#!/bin/sh
# NOTE: this needs to be run as root since both
# losetup and mount need it.
# NOTE: this assumes that singularity binds the
# image to /zoef_sd.img
# TODO: is there a way to do this in userspace?

# Resize image and partition to a total of 7Gb
dd if=/dev/zero bs=1G seek=7 count=0 of=/zoef_sd.img

# Resize last partition
loopvar=`losetup --partscan --show --find /zoef_sd.img`
parted $loopvar resizepart `ls ${loopvar}p* | wc -l` 100%
losetup -d $loopvar

# Resize filesystem of last partition
loopvar=`losetup -fP --show /zoef_sd.img`
mount `ls $loopvar* | tail -n1` /mnt/image/
losetup -c $loopvar
resize2fs -f `ls $loopvar* | tail -n1`
umount /mnt/image/
losetup -d $loopvar

# Fix needed to get internet while installing raspberry pi image
loopvar=`losetup -fP --show /zoef_sd.img`
mount `ls $loopvar* | tail -n1` /mnt/image/
rm /mnt/image/etc/resolv.conf
echo "nameserver 8.8.8.8" > /mnt/image/etc/resolv.conf
cat /mnt/image/etc/resolv.conf
umount /mnt/image/
losetup -d $loopvar
