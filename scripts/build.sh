#! /bin/sh

set -e

. scripts/config.sh

if [ "$BUILD_TYPE" = "kernel" ] || [ "$BUILD_TYPE" = "kernel_rt" ]; then
    #Xenomai3 Kernel-----------------------------------------
    #git clone https://gitlab.com/Xenomai/linux-dovetail
    #git -C linux-dovetail checkout v6.12.67-dovetail1

    #git clone https://gitlab.com/Xenomai/xenomai3/xenomai.git xenomai3
    #git -C xenomai3 checkout master #73ad3b8ac131cd2ec400108dc74ca8edded7318f as of now

    cd xenomai3

    scripts/prepare-kernel.sh --linux=../linux-dovetail/

    cd ../linux-dovetail

    cp "../$KERNEL_CONFIG" .config
    make oldconfig
    make -j"$(nproc)" bindeb-pkg LOCALVERSION="$KERNEL_LOCAL_VERSION" KDEB_PKGVERSION="$(make kernelversion)-$KERNEL_VERSION_STUFFIX"

    cd ..

    #Cleanup-----------------------------------------------------
    rm -rf "$PACKAGE_DIR"
    mkdir -p "$PACKAGE_DIR"
    mv ./*.deb ./*.changes ./*.buildinfo "$PACKAGE_DIR"

    git -C xenomai3 clean -fxd
    git -C xenomai3 checkout -- .

    git -C linux-dovetail clean -fxd
    git -C linux-dovetail checkout -- .
fi

if [ "$BUILD_TYPE" = "xenomai" ]; then
    #Xenomai3 userspace tools-------------------------------------
    cd xenomai3

    DEBEMAIL="hannes.diethelm@gmail.com" DEBFULLNAME="Hannes Diethelm" dch -v "$XENOMAI_PACKAGE_VERSION" "Build v3.3 master branch"
    dpkg-buildpackage -b -uc

    cd ..

    #Cleanup-----------------------------------------------------
    rm -rf "$PACKAGE_DIR"
    mkdir -p "$PACKAGE_DIR"
    mv ./*.deb ./*.changes ./*.buildinfo "$PACKAGE_DIR"

    git -C xenomai3 clean -fxd
    git -C xenomai3 checkout -- .
fi
