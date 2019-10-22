Bootstrap: docker
From: ubuntu:bionic

%files
    wifi_ap_setup.sh
    install_zoef.sh

%post
    # Update system
    apt update
    apt upgrade -y

    # Install prerequisites
    echo "Install basics for building singularity image"
    apt install -y qemu qemu-user-static binfmt-support p7zip-full wget

    # Download and mount image
    cd /
    rm Ubuntu_bionic_next.7z || /bin/true
    wget https://dl.armbian.com/orangepizero/Ubuntu_bionic_next.7z
    7z e Ubuntu_bionic_next.7z
    mkdir -p /mnt/armbian
    mount -o loop,offset=4194304 Armbian_5.90_Orangepizero_Ubuntu_bionic_next_4.19.57.img /mnt/armbian
    cp /usr/bin/qemu-arm-static /mnt/armbian/usr/bin/
    mount --bind /dev /mnt/armbian/dev/
    mount --bind /sys /mnt/armbian/sys/
    mount --bind /proc /mnt/armbian/proc/
    mount --bind /dev/pts /mnt/armbian/dev/pts

    # Install wifi_ap
    mv /wifi_ap_setup.sh /mnt/armbian
    chroot /mnt/armbian ./wifi_ap_setup.sh

    # Install Zoef related stuff (for now only putting the file there until repos are public)
    chmod +x /install_zoef.sh
    mv /install_zoef.sh /mnt/armbian/home/zoef

    # Cleanup
    rm /mnt/armbian/usr/bin/qemu-arm-static
    rm /mnt/armbian/wifi_ap_setup.sh

    # Unmount
    umount /mnt/armbian/dev/pts
    umount /mnt/armbian/dev/
    umount /mnt/armbian/sys/
    umount /mnt/armbian/proc/
    umount /mnt/armbian/

    # Copy to tmp directory
    cp Armbian_5.90_Orangepizero_Ubuntu_bionic_next_4.19.57.img /tmp
  
    


