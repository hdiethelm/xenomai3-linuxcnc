#! /bin/sh

XENOMAI_GIT_VERSION=73ad3b

#Xenomai3 Kernel-----------------------------------------
sudo dpkg -i \
  deb/linux-headers-6.12.67-xenomai3-${XENOMAI_GIT_VERSION}_6.12.67-1_amd64.deb \
  deb/linux-image-6.12.67-xenomai3-${XENOMAI_GIT_VERSION}_6.12.67-1_amd64.deb

#Reboot, check for xenomai:
# sudo dmesg | grep -i xenomai

#Xenomai3 userspace tools-------------------------------------
sudo dpkg -i \
  deb/libxenomai1_3.3-1-${XENOMAI_GIT_VERSION}_amd64.deb \
  deb/libxenomai-dev_3.3-1-${XENOMAI_GIT_VERSION}_amd64.deb \
  deb/xenomai-runtime_3.3-1-${XENOMAI_GIT_VERSION}_amd64.deb \
  deb/xenomai-testsuite_3.3-1-${XENOMAI_GIT_VERSION}_amd64.deb \
