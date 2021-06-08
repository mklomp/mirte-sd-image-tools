#!/bin/bash

# this depends on the host system used
# sudo apt install singularity-container

sudo rm -rf image_tools.sif
sudo singularity build image_tools.sif image_tools.def
