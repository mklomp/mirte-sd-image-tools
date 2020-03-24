#!/bin/bash

sudo apt install git

# Get install scripts
cd /
git clone https://gitlab.tudelft.nl/rcj_zoef/zoef_install_scripts

# Install network
mv zoef_install_scripts/network_install.sh /mnt/armbian
chroot /mnt/armbian ./network_install.sh

# Install zoef
sed -i 's/~/\/home\/zoef/g' zoef_install_scripts/install_zoef.sh
mv zoef_install_scripts/install_zoef.sh /mnt/armbian
chroot /mnt/armbian ./install_zoef.sh
chroot /mnt/armbian /bin/bash -c "/bin/chown -R zoef:zoef /home/zoef"

# Move image
cp /zoef_sd.img /working_dir
