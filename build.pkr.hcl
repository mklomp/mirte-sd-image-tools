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
  qemu_binary = ""
}

source "arm-image" "mirte_orangepi3b" {
  image_type = "armbian"
  iso_url = "https://mirte.arend-jan.com/files/base_img/Armbian-unofficial_25.02.0-trunk_Orangepi3b_jammy_edge_6.13.1.img.xz"
  iso_checksum = "sha256:28fb7218ba216822af9a4fb1ee55fe59c8f147ccc32d65cf23ce59f62070b6ac"
  output_filename = "./workdir/mirte_orangepi3b.img"
  target_image_size = 15*1024*1024*1024
  qemu_binary = "qemu-aarch64-static"
}

source "arm-image" "mirte_x86" {
  image_type = "armbian"
  iso_url = "/home/arendjan/Downloads/Armbian-unofficial_25.02.0-trunk_Uefi-x86_jammy_current_6.12.10 (1).img"
  iso_checksum = "sha256:d847269f9be318be2c8bbbfde3ea43418686ce9f779e3552979a45d01cc030e8"
  target_image_size = 15*1024*1024*1024
  image_mounts = [ "", "", "/" ]
}


# source "arm-image" "mirte_rpi4b" { # TODO: change to armbian image
#   image_type = "raspberrypi"
#   iso_url = "https://cdimage.ubuntu.com/releases/20.04.5/release/ubuntu-20.04.5-preinstalled-server-armhf+raspi.img.xz"
#   iso_checksum = "sha256:065c41846ddf7a1c636a1aac5a7d49ebcee819b141f9d57fd586c5f84b9b7942"
#   output_filename = "./workdir/mirte_rpi4b.img"
#   target_image_size = 15*1024*1024*1024 # 15GB
# }

build {
  sources = ["source.arm-image.mirte_orangepizero2", "source.arm-image.mirte_orangepi3b", "source.arm-image.mirte_x86"]
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
