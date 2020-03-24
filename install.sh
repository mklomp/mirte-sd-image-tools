#!/bin/bash

sudo apt install singularity-container
sudo rm virtual_armbian.simg
sudo singularity build virtual_armbian.simg virtual_armbian.def
