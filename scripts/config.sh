#! /bin/sh

usage(){
    echo "Usage: $0 [kernel|kernel_rt|xenomai]"
}

if [ -z "$BUILD_TYPE" ]; then
    if [ "$#" -ne 1 ]; then
        usage
        exit 1
    fi
    BUILD_TYPE=$1
fi

XENOMAI_VERSION=3.3
XENOMAI_VERSION_STUFFIX=6
XENOMAI_PACKAGE_VERSION=${XENOMAI_VERSION}-${XENOMAI_VERSION_STUFFIX}

if [ "$BUILD_TYPE" = "kernel_rt" ]; then
    KERNEL_CONFIG=kconfig-base-config-6.12.94+deb13-rt-amd64.txt
    KERNEL_LOCAL_VERSION=-xenomai3-${XENOMAI_VERSION}-rt
else
    KERNEL_CONFIG=kconfig-base-config-6.12.94+deb13-amd64.txt
    KERNEL_LOCAL_VERSION=-xenomai3-${XENOMAI_VERSION}
fi

KERNEL_VERSION=6.12.90
KERNEL_VERSION_CIP=-cip24
KERNEL_VERSION_STUFFIX=1
KERNEL_PACKAGE_VERSION=${KERNEL_VERSION}${KERNEL_VERSION_CIP}${KERNEL_LOCAL_VERSION}_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}

case "$BUILD_TYPE" in
    "kernel")
        GH_RELEASE_TAG=kernel-${KERNEL_PACKAGE_VERSION}
        PACKAGE_DIR=pkg-kernel
        ;;
    "kernel_rt")
        GH_RELEASE_TAG=kernel-${KERNEL_PACKAGE_VERSION}
        PACKAGE_DIR=pkg-kernel-rt
        ;;
    "xenomai")
        GH_RELEASE_TAG=xenomai-${XENOMAI_PACKAGE_VERSION}
        PACKAGE_DIR=pkg-xenomai
        ;;
    *)
        usage
        exit 1
        ;;
esac
