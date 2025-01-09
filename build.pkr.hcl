packer {
  required_plugins {
    arm-image = {
      version = ">= 0.2.11"
      source  = "github.com/arendjan/arm-image"
    }
  }
}


source "arm-image" "mirte_orangepizero2" {
  image_type = "armbian"
  iso_url = "https://surfdrive.surf.nl/files/index.php/s/2wfidBQcSt81PnS/download?path=Download Armbian-unofficial_24.8.1_Orangepizero2_jammy_current_6.6.44.img.xz"
  iso_checksum = "sha256:d8abb93bdc5df0512f30295f3c18c35bb96af8bf618e063bc19352903d38a225"
  output_filename = "./workdir/mirte_orangepizero2.img"
  target_image_size = 15*1024*1024*1024
  qemu_binary = "qemu-aarch64-static"
}

source "arm-image" "mirte_orangepi3b" {
  image_type = "armbian"
  iso_url = "https://mirte.arend-jan.com/files/base_img/Armbian-unofficial_25.02.0-trunk_Orangepi3b_jammy_edge_6.13.0-rc5.img.xz"
  iso_checksum = "sha256:0b96e63ededf4263588e6eda8bcf2a2da57b58159522667ef5829d76bd7e5ab8"
  output_filename = "./workdir/mirte_orangepi3b.img"
  target_image_size = 15*1024*1024*1024
  qemu_binary = "qemu-aarch64-static"
}
  
# source "arm-image" "mirte_rpi4b" { # TODO: change to armbian image
#   image_type = "raspberrypi"
#   iso_url = "https://cdimage.ubuntu.com/releases/20.04.5/release/ubuntu-20.04.5-preinstalled-server-armhf+raspi.img.xz"
#   iso_checksum = "sha256:065c41846ddf7a1c636a1aac5a7d49ebcee819b141f9d57fd586c5f84b9b7942"
#   output_filename = "./workdir/mirte_rpi4b.img"
#   target_image_size = 15*1024*1024*1024 # 15GB
# }

build {
  sources = ["source.arm-image.mirte_orangepizero2", "source.arm-image.mirte_orangepi3b"]
  provisioner "file" {
    source = "git_local"
    destination = "/usr/local/src/mirte"
  }
  provisioner "file" {
    source = "repos.yaml"
    destination = "/usr/local/src/mirte/"
  }
  provisioner "file" {
    source = "settings.sh"
    destination = "/usr/local/src/mirte/"
  }
  provisioner "file"  {
    source = "wheels"
    destination = "/usr/local/src/mirte/wheels/"
  }
  provisioner "file"  {
    source = "mirte_main_install.sh"
    destination = "/usr/local/src/mirte/"
  }
 provisioner "shell" {
    inline_shebang = "/bin/bash -e"
    inline = [
      "chmod +x /usr/local/src/mirte/mirte_main_install.sh",
      "export type=${source.name}",
      "echo $type",
      "mkdir /usr/local/src/mirte/build_system/",
      "sudo -E /usr/local/src/mirte/mirte_main_install.sh"
    ]
  }
  # provisioner "file" { # Provide the logs to the sd itself, doesn't work as tee deletes it and packer is missing it
  #   source = " logs/current_log.txt"
  #   destination = "/usr/local/src/mirte/build_system/"
  # }
  provisioner "file" { # provide the build script
    source = "build.pkr.hcl"
    destination = "/usr/local/src/mirte/build_system/"
  }
}
