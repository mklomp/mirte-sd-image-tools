## Prerequisites

You need singularity container >=2.3. On ubuntu (16.10+):
   ```
   $ sudo apt install singularity-container
   ```
   
For other versions of Ubuntu you can follow the installation guide on the [Singularity website](https://sylabs.io/guides/3.0/user-guide/installation.html#install-the-debian-ubuntu-package-using-apt).

## Generating an sd image

1. Clone this repository
   ```
   $ sudo apt install git
   $ git clone https://gitlab.tudelft.nl/rcj_zoef/zoef_sd_card_image
   ```
2. Install the sigularity image
   ```
   $ sudo ./install.sh
   ```
3. Create the sd card image (this will take some time)
   ```
   $ sudo ./run.sh build_sd_card
   ```
4. This will generate a zoef_sd.img in the current directory
5. Use an image burning tool (e.g. dd or etcher ([link](https://www.balena.io/etcher/)) to burn it to an SD card


## (For Developer) Using singularity to run an Armbian image on non ARM

1. Start a ARM shell
   ```
   $ sudo ./run.sh shell
   ```
2. You can now run commands as if it was on ARM
   ```
   $ uname -a
   ```
