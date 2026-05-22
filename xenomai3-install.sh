#! /bin/sh

set -e

. ./xenomai3-vars.sh

#Dependency
sudo apt install gdb

#Xenomai3 Kernel-----------------------------------------
sudo dpkg -i \
  deb/linux-headers-${KERNEL_VERSION}-cip22-xenomai3-${XENOMAI_GIT_VERSION}_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}_amd64.deb \
  deb/linux-image-${KERNEL_VERSION}-cip22-xenomai3-${XENOMAI_GIT_VERSION}_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}_amd64.deb

#Xenomai3 userspace tools-------------------------------------
sudo dpkg -i \
  deb/libxenomai1_3.3-${XENOMAI_VERSION_STUFFIX}-${XENOMAI_GIT_VERSION}_amd64.deb \
  deb/libxenomai-dev_3.3-${XENOMAI_VERSION_STUFFIX}-${XENOMAI_GIT_VERSION}_amd64.deb \
  deb/xenomai-runtime_3.3-${XENOMAI_VERSION_STUFFIX}-${XENOMAI_GIT_VERSION}_amd64.deb \
  deb/xenomai-testsuite_3.3-${XENOMAI_VERSION_STUFFIX}-${XENOMAI_GIT_VERSION}_amd64.deb
