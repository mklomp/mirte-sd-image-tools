#!/bin/bash

sudo apt install git

# Get install scripts
cd /
git clone https://gitlab.tudelft.nl/rcj_zoef/zoef_install_scripts
mv zoef_install_scripts /mnt/armbian

# Merge repos.yaml. With this you ar able to override the install repos
if [ -f /working_dir/repos.yaml ]; then
  apt install -y make build-essential 
  cpan -fi YAML Hash::Merge::Simple    #TODO: this installes it in /root of the host (maybe other may to merge them?)
  perl -MYAML=LoadFile,Dump -MHash::Merge::Simple=merge -E 'say Dump(merge(map{LoadFile($_)}@ARGV))' /mnt/armbian/zoef_install_scripts/repos.yaml /working_dir/repos.yaml > /mnt/armbian/zoef_install_scripts/merged_repos.yaml
  mv /mnt/armbian/zoef_install_scripts/repos.yaml /mnt/armbian/zoef_install_scripts/repos_orig.yaml
  mv /mnt/armbian/zoef_install_scripts/merged_repos.yaml /mnt/armbian/zoef_install_scripts/repos.yaml
fi

# Install zoef
chroot /mnt/armbian /bin/bash -c "cd /zoef_install_scripts/ && ./install_zoef.sh"
chroot /mnt/armbian /bin/bash -c "/bin/chown -R zoef:zoef /home/zoef"

# Install network
chroot /mnt/armbian ./zoef_install_scripts/network_install.sh
