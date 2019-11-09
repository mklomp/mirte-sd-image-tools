## Prerequisites

You need singularity container >=2.3. On ubuntu (16.10+):
   ```
   $ sudo apt install singularity-container
   ```
   
For other versions of Ubuntu you can follow the installation guide on the [Singularity website](https://sylabs.io/guides/3.0/user-guide/installation.html#install-the-debian-ubuntu-package-using-apt).

## Generating the image

1. git clone this repository
   ```
   $ sudo apt install git
   $ git clone https://gitlab.tudelft.nl/rcj_zoef/zoef_sd_card_image
   ```
2. create the image with singularity (this may take some time ~20 mins)
   ```
   $ sudo ./build_image.sh
   ```
3. You will now have an image file zoef.img in your /tmp folder
4. Use an image burning tool (e.g. dd or etcher ([link](https://www.balena.io/etcher/)) to burn it to an SD card

## Install Firmata on the Arduino

At the moment there is still an issue with enabeling the arduino-cli in the installer. You could do two things to get FirmataPlus installed. Curretnly the preferred way is using the arduino IDE:

1. Flash the FirmataPlus software on your arduino on you host ([link](https://github.com/MrYsLab/pymata-aio/wiki/Uploading-FirmataPlus-to-Arduino))

Or, you could flash it from the OrangePi

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

## Connecting to zoef

After you have created the sd-card, you have to put the SD card in the Orange Pi and boot up the Orange Pi by plugging in the usb power cable. After some time a wireless network with ssid 'Zoef_<uiniqueID>' should be visible. You can connect your pc to this network (password: zoef_zoef). 


## Control the robot on the dashboard

After you have installed the zoef software you can open a browser and go to http://192.168.42.1 (or http://zoef.local) and program the robot. This should also work after a reboot.

## Login with ssh

1. Put the sd card in the orange pi and boot
2. Wait until a wifi network with ssid 'Zoef_<ID>' comes up
3. Connect to the 'Zoef_<ID>' network with password 'zoef_zoef'
4. Login with ssh (password: 'zoef_zoef'
   ```
   $ ssh zoef@192.168.42.1
   ```
5. The first time you login you will be asked to change your password (and need to login againg with the new password)

## Connect Zoef to an acces point

1. In a webbrowser go to http://192.168.42.1
2. Click on 'setup network' on the top left
3. Select the ssid you want to connect to, including the passprase
4. If all went ok, Zoef will connect to the network
5. Check the ip of Zoef (todo: at the moment there can only be one Zoef in a network):
   ```
   $ ping zoef.local
   ```

