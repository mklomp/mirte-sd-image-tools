#!/bin/bash
#NOTE: sudo not known in chroot, so all commands can be expected to be run as root

apt install -y git

# Get install scripts
mkdir -p /mnt/image/working_dir
cd /mnt/image/working_dir
cp -R /git_local .
if grep -q "/working_dir/git_local/mirte-install-scripts" /repos.yaml; then
   echo "Using local repository of mirte-install-scripts"
else
   echo "Using remote repository of mirte-install-scripts"
   mkdir git_local
   cd git_local
   git clone https://github.com/mirte-robot/mirte-install-scripts.git
fi

# Merge repos.yaml. With this you ar able to override the install repos
if [ -f /repos.yaml ]; then
  perl -MYAML=LoadFile,Dump -MHash::Merge::Simple=merge -E 'say Dump(merge(map{LoadFile($_)}@ARGV))' /mnt/image/working_dir/git_local/mirte-install-scripts/repos.yaml /repos.yaml > /mnt/image/working_dir/git_local/mirte-install-scripts/merged2_repos.yaml
  mv /mnt/image/working_dir/git_local/mirte-install-scripts/repos.yaml /mnt/image/working_dir/git_local/mirte-install-scripts/repos_orig.yaml
  mv /mnt/image/working_dir/git_local/mirte-install-scripts/merged2_repos.yaml /mnt/image/working_dir/git_local/mirte-install-scripts/repos.yaml
fi

# Install mirte
chroot /mnt/image /bin/bash -c "cd /working_dir/git_local/mirte-install-scripts/ && ./create_user.sh"
chroot /mnt/image /bin/bash -c "sudo echo 'mirte ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers" # do not ask for sudo password
chroot /mnt/image /bin/bash -c "sudo -i -u mirte bash -c 'cd /working_dir/git_local/mirte-install-scripts/ && ./install_mirte.sh'" # install as mirte
chroot /mnt/image /bin/bash -c "sudo sed -i '$ d' /etc/sudoers" # ask again for sudo password
chroot /mnt/image /bin/bash -c "sudo passwd --expire mirte"

# Install network
chroot /mnt/image ./working_dir/git_local/mirte-install-scripts/network_install.sh
