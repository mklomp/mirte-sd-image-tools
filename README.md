## Prerequisites

You need singularity container >=2.3. On ubuntu:
   ```
   $ sudo apt install singularuty-container
   ```

## Generating the image

1. git clone this repository
2. create the image with singularity
   ```
   $ sudo singularity build --sandbox zoef_dev Singularity 
   ```
3. You will now have an image file Armbian_5.90_Orangepizero_Ubuntu_bionic_next_4.19.57.img in yout /tmp folder
4. Use an image burning tool (e.g. dd or etcher ([link](https://www.balena.io/etcher/)) to burn it to an SD card

## Login with ssh

1. Put the sd card in the orange pi and boot
2. Wait until a wifi network with ssid 'Zoef' comes up
3. Connect to the 'Zoef' network with password 'Zoef_Zoef'
4. Login with ssh (password: 'zoef_zoef'
   ```
   $ ssh zoef@192.168.42.1
   ```

## Install zoef software on the image

This step should be included in the previous step. But since we currently use a private repository. So for now we need to do this manually:

1. After loggin in install all the needed software:
   ```
   $ ./install_zoef.sh 
   ```

## Control the robot on the dashboard

After you have installed teh zoef software you can open a browser and go to http://192.168.42.1:8080
