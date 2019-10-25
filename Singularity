Bootstrap: docker
From: ubuntu:bionic

%files
    wifi_ap_setup.sh
    install_zoef.sh

%post
    # Update system
    apt update

    # Install prerequisites
    apt install -y qemu qemu-user-static binfmt-support p7zip-full wget parted

    # Download image
    cd /
    rm Ubuntu_bionic_next.7z || /bin/true
    wget https://dl.armbian.com/orangepizero/Ubuntu_bionic_next.7z
    7z e Ubuntu_bionic_next.7z

    # Resize image and partition (add 3Gb)
    dd if=/dev/zero bs=1MiB of=/Armbian_5.90_Orangepizero_Ubuntu_bionic_next_4.19.57.img conv=notrunc oflag=append count=3000
    loopvar=`losetup -f`
    losetup $loopvar /Armbian_5.90_Orangepizero_Ubuntu_bionic_next_4.19.57.img
    parted $loopvar resizepart 1 100%
    losetup -d $loopvar
    loopvar=`losetup -f`

    # Mount image and resize filesystem
    mkdir -p /mnt/armbian
    mount -o loop=$loopvar,offset=4194304 /Armbian_5.90_Orangepizero_Ubuntu_bionic_next_4.19.57.img /mnt/armbian
    losetup -c $loopvar
    resize2fs -f $loopvar

    # Mount other folders
    cp /usr/bin/qemu-arm-static /mnt/armbian/usr/bin/
    mount --bind /dev /mnt/armbian/dev/
    mount --bind /sys /mnt/armbian/sys/
    mount --bind /proc /mnt/armbian/proc/
    mount --bind /dev/pts /mnt/armbian/dev/pts
 
    # Install wifi_ap
    mv /wifi_ap_setup.sh /mnt/armbian
    chroot /mnt/armbian ./wifi_ap_setup.sh

    # Install zoef
    sed -i 's/~/\/home\/zoef/g' /install_zoef.sh
    mv /install_zoef.sh /mnt/armbian
    chroot /mnt/armbian ./install_zoef.sh
    chroot /mnt/armbian /bin/bash -c "/bin/chown -R zoef:zoef /home/zoef"

    # Cleanup
    rm /mnt/armbian/usr/bin/qemu-arm-static
    rm /mnt/armbian/wifi_ap_setup.sh
    rm /mnt/armbian/install_zoef.sh
    losetup -d $loopvar

    # Unmount
    umount /mnt/armbian/dev/pts
    umount /mnt/armbian/dev
    umount /mnt/armbian/sys
    umount /mnt/armbian/proc
    umount /mnt/armbian/

    #TODO: shrink fs, partition and image

    # Copy to tmp directory
    cp Armbian_5.90_Orangepizero_Ubuntu_bionic_next_4.19.57.img /tmp/zoef.img
