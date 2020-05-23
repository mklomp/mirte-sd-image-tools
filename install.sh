#!/bin/bash

# this depends on the host system used
# sudo apt install singularity-container

sudo rm -rf virtual_armbian.simg
sudo singularity build --sandbox virtual_armbian.simg virtual_armbian.def
