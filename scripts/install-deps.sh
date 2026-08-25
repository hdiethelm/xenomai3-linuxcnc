#! /bin/sh

set -e

#Xenomai3 kernel-----------------------------------------
sudo apt install build-essential libncurses-dev bison flex libssl-dev libelf-dev dwarves git fakeroot rsync sbsigntool kernel-wedge

#Xenomai3 userspace tools-------------------------------------
sudo apt install libltdl-dev gdb devscripts

