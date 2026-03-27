#! /bin/sh

source xenomai3-vars.sh

#Xenomai3 Kernel-----------------------------------------
#git clone https://gitlab.com/Xenomai/linux-dovetail
#git -C linux-dovetail checkout v6.12.67-dovetail1

#git clone https://gitlab.com/Xenomai/xenomai3/xenomai.git xenomai3
#git -C xenomai3 checkout master #73ad3b8ac131cd2ec400108dc74ca8edded7318f as of now

cd xenomai3
scripts/prepare-kernel.sh --linux=../linux-dovetail/

cd ../linux-dovetail

cp ../kconfig-base-config-6.12.74+deb13+1-rt-amd64.txt .config #Base: debian trixie config-6.12.74+deb13+1-rt-amd64
make oldconfig
make -j16 deb-pkg LOCALVERSION=-xenomai3-$XENOMAI_GIT_VERSION KDEB_PKGVERSION=$(make kernelversion)-${KERNEL_VERSION_STUFFIX}
cd ..

#Xenomai3 userspace tools-------------------------------------
cd xenomai3

DEBEMAIL="hannes.diethelm@gmail.com" DEBFULLNAME="Hannes Diethelm" dch -v 3.3-${XENOMAI_VERSION_STUFFIX}-${XENOMAI_GIT_VERSION} "Build v3.3 master branch + patches"
dpkg-buildpackage -b -uc
cd ..

#Cleanup-----------------------------------------------------
mkdir deb
mv *.deb deb
rm *.changes *.buildinfo *.tar.gz *.dsc

git -C xenomai3 clean -fxd
git -C xenomai3 checkout -- .

git -C linux-dovetail clean -fxd
git -C linux-dovetail checkout -- .

git add \
  deb/linux-headers-6.12.67-xenomai3-${XENOMAI_GIT_VERSION}_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}_amd64.deb \
  deb/linux-image-6.12.67-xenomai3-${XENOMAI_GIT_VERSION}_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}_amd64.deb
  
git add \
  deb/libxenomai1_3.3-${XENOMAI_VERSION_STUFFIX}-${XENOMAI_GIT_VERSION}_amd64.deb \
  deb/libxenomai-dev_3.3-${XENOMAI_VERSION_STUFFIX}-${XENOMAI_GIT_VERSION}_amd64.deb \
  deb/xenomai-runtime_3.3-${XENOMAI_VERSION_STUFFIX}-${XENOMAI_GIT_VERSION}_amd64.deb \
  deb/xenomai-testsuite_3.3-${XENOMAI_VERSION_STUFFIX}-${XENOMAI_GIT_VERSION}_amd64.deb

git clean -f deb/
