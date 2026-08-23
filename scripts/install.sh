#! /bin/sh

set -e

. scripts/config.sh

#Dependency
sudo apt install gdb

if [ "$BUILD_TYPE" = "kernel" -o "$BUILD_TYPE" = "kernel_rt" ]; then
    #Xenomai3 Kernel-----------------------------------------
    sudo apt install --reinstall \
      ./${PACKAGE_DIR}/linux-headers-${KERNEL_PACKAGE_VERSION}_amd64.deb \
      ./${PACKAGE_DIR}/linux-image-${KERNEL_PACKAGE_VERSION}_amd64.deb
fi

if [ "$BUILD_TYPE" = "xenomai" ]; then
    #Xenomai3 userspace tools-------------------------------------
    sudo apt install --reinstall \
      ./${PACKAGE_DIR}/libxenomai1_${XENOMAI_PACKAGE_VERSION}_amd64.deb \
      ./${PACKAGE_DIR}/libxenomai-dev_${XENOMAI_PACKAGE_VERSION}_amd64.deb \
      ./${PACKAGE_DIR}/xenomai-runtime_${XENOMAI_PACKAGE_VERSION}_amd64.deb \
      ./${PACKAGE_DIR}/xenomai-testsuite_${XENOMAI_PACKAGE_VERSION}_amd64.deb
fi
