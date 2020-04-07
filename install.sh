#!/bin/bash

sudo apt install singularity-container
sudo rm -rf virtual_armbian.simg
sudo singularity build --sandbox virtual_armbian.simg virtual_armbian.def
