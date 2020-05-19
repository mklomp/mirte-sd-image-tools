#!/bin/bash
#NOTE: sudo not known in chroot, so all commands can be expected to be run as root

apt install -y git 

# Get install scripts
mkdir -p /mnt/armbian/working_dir
cd /mnt/armbian/working_dir
cp -R /working_dir/git_local .
if grep -q "/working_dir/git_local/zoef_install_scripts" /working_dir/repos.yaml; then
   echo "Using local repository of zoef_install_scripts"
else
   echo "Using remote repository of zoef_install_scripts"
   mkdir git_local
   cd git_local
   git clone https://gitlab.tudelft.nl/rcj_zoef/zoef_install_scripts
fi 

# Merge repos.yaml. With this you ar able to override the install repos
#TODO: can this be done with another program?
if [ -f /working_dir/repos.yaml ]; then
  apt install -y make build-essential 
  cpan -fi YAML Hash::Merge::Simple    #TODO: this installes it in /root of the host (maybe other may to merge them?)
  perl -MYAML=LoadFile,Dump -MHash::Merge::Simple=merge -E 'say Dump(merge(map{LoadFile($_)}@ARGV))' /mnt/armbian/working_dir/git_local/zoef_install_scripts/repos.yaml /working_dir/repos.yaml > /mnt/armbian/working_dir/git_local/zoef_install_scripts/merged2_repos.yaml
  mv /mnt/armbian/working_dir/git_local/zoef_install_scripts/repos.yaml /mnt/armbian/working_dir/git_local/zoef_install_scripts/repos_orig.yaml
  mv /mnt/armbian/working_dir/git_local/zoef_install_scripts/merged2_repos.yaml /mnt/armbian/working_dir/git_local/zoef_install_scripts/repos.yaml
fi

# Install zoef
chroot /mnt/armbian /bin/bash -c "cd /working_dir/git_local/zoef_install_scripts/ && ./create_user.sh"
chroot /mnt/armbian /bin/bash -c "sudo echo 'zoef ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers" # do not ask for sudo password
chroot /mnt/armbian /bin/bash -c "sudo -i -u zoef bash -c 'cd /working_dir/git_local/zoef_install_scripts/ && ./install_zoef.sh'" # install as zoef
chroot /mnt/armbian /bin/bash -c "sudo sed -i '$ d' /etc/sudoers" # ask again for sudo password
chroot /mnt/armbian /bin/bash -c "sudo passwd --expire zoef"

# Install network
chroot /mnt/armbian ./working_dir/git_local/zoef_install_scripts/network_install.sh
