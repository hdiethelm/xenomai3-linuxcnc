#! /bin/sh

#Xenomai3 Kernel-----------------------------------------
#git clone https://gitlab.com/Xenomai/linux-dovetail
#git -C linux-dovetail checkout v6.12.67-dovetail1

#git clone https://gitlab.com/Xenomai/xenomai3/xenomai.git xenomai3
#git -C xenomai3 checkout master #73ad3b8ac131cd2ec400108dc74ca8edded7318f as of now
XENOMAI_GIT_VERSION=73ad3b

cd xenomai3
scripts/prepare-kernel.sh --linux=../linux-dovetail/

cd ../linux-dovetail

cp ../kconfig-base-config-6.12.74+deb13+1-rt-amd64.txt .config #Base: debian trixie config-6.12.74+deb13+1-rt-amd64
make oldconfig
make -j16 deb-pkg LOCALVERSION=-xenomai3-$XENOMAI_GIT_VERSION KDEB_PKGVERSION=$(make kernelversion)-1
cd ..

#Xenomai3 userspace tools-------------------------------------
cd xenomai3

patch -p1 < ../xenomai3-master.patch
DEBEMAIL="hannes.diethelm@gmail.com" DEBFULLNAME="Hannes Diethelm" dch -v 3.3-1-${XENOMAI_GIT_VERSION} "Build v3.3 master branch + patches"
dpkg-buildpackage -b -uc
cd ..

#Xenomai3 userspace tools (plain install)--------------------
#cd xenomai3

#patch -p1 < ../xenomai3-master.patch
#./scripts/bootstrap
#./configure --with-core=mercury --enable-smp --enable-pshared --enable-dlopen-libs
#make
#sudo make install
#echo "/usr/xenomai/lib" | sudo tee /etc/ld.so.conf.d/xenomai.conf > /dev/null
#sudo ldconfig

#uninstall:
#sudo make uninstall
#sudo rm -r /usr/xenomai/

#Cleanup-----------------------------------------------------
mkdir deb
mv *.deb deb
rm *.changes *.buildinfo *.tar.gz *.dsc

git -C xenomai3 clean -fxd
git -C xenomai3 checkout -- .

git -C linux-dovetail clean -fxd
git -C linux-dovetail checkout -- .

git add \
  deb/linux-headers-6.12.67-xenomai3-${XENOMAI_GIT_VERSION}_6.12.67-1_amd64.deb \
  deb/linux-image-6.12.67-xenomai3-${XENOMAI_GIT_VERSION}_6.12.67-1_amd64.deb
  
git add \
  deb/libxenomai1_3.3-1-${XENOMAI_GIT_VERSION}_amd64.deb \
  deb/libxenomai-dev_3.3-1-${XENOMAI_GIT_VERSION}_amd64.deb \
  deb/xenomai-runtime_3.3-1-${XENOMAI_GIT_VERSION}_amd64.deb \
  deb/xenomai-testsuite_3.3-1-${XENOMAI_GIT_VERSION}_amd64.deb

git clean -f deb/

#LinuxCNC------------------------------------------------------
#git clone https://github.com/LinuxCNC/linuxcnc.git linuxcnc-src
#cd inuxcnc-src/src
##export PATH=$PATH:/usr/xenomai/bin #Only for plain install
#./autogen.sh
#./configure --with-realtime=uspace
#make -j
#sudo make setuid

#configure should show:
#checking for rtai-config... none
#checking for xeno-config... /usr/xenomai/bin/xeno-config
#checking for realtime API(s) to use... uspace+xenomai

#LinuxCNC should show:
#Note: Using XENOMAI (posix-skin) realtime

#latency-histogram is broken and has to be started using:
#../scripts/rip-environment ../scripts/latency-histogram
