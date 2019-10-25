## Prerequisites

You need singularity container >=2.3. On ubuntu:
   ```
   $ sudo apt install singularuty-container
   ```

## Generating the image

1. git clone this repository
2. create the image with singularity (this may take some time ~20 mins)
   ```
   $ sudo singularity build --sandbox zoef_dev Singularity 
   ```
3. You will now have an image file Armbian_5.90_Orangepizero_Ubuntu_bionic_next_4.19.57.img in your /tmp folder
4. Use an image burning tool (e.g. dd or etcher ([link](https://www.balena.io/etcher/)) to burn it to an SD card

## Install Firmata on teh Arduino

At the moment there is still an issue with enabeling the arduino-cli in the installer. You could do two things to get FirmataPlus installed on your arduino:

1. Flash the FirmataPlus software on your arduino on you host ([link](https://github.com/MrYsLab/pymata-aio/wiki/Uploading-FirmataPlus-to-Arduino))

Or, you could flash it from teh OrangePi

1. Ssh into the robot (see instructions below)
2. Move into the zoef_arduino repository
   ```
   $ cd zoef_arduino
   ```
3. Create the Singulary image
   ```
   $ sudo singularity build --sandbox arduino_dev Singularity
   ```
4. And ru the image
   ```
   $ sudo singularity run zoef_dev
   ```

## Control the robot on the dashboard

After you have installed the zoef software you can open a browser and go to http://192.168.42.1 and program the robot. This should also work after a reboot.

## Login with ssh

1. Put the sd card in the orange pi and boot
2. Wait until a wifi network with ssid 'Zoef' comes up
3. Connect to the 'Zoef' network with password 'Zoef_Zoef'
4. Login with ssh (password: 'zoef_zoef'
   ```
   $ ssh zoef@192.168.42.1
   ```
5. The first time you login you will be asked to change your password (and need to login againg with the new password)

## Enable NAT

At the moment there is a problem with including iptables into the SD card image. To get NAT enabled you need to run a script:

1. Ssh into the OrangePi 
2. Check that you have access to the internet:
   ```
   $ ping google.com 
   ```
3. Run teh script:
   ```
   $ cd zoef_sd_card_image 
   $ ./enable_NAT.sh
   ```
