# Xenomai3 Kernel for LinuxCNC

<strong>Expected Distribution: Debian Trixie</strong>

## How To

- Clone repo
- If you trust my binary packages
  - `./xenomai3-install.sh`
- Build it from source
  - `git submodule init`
  - `git submodule update`
  - `xenomai3-prepare.sh`
  - `xenomai3-build.sh`
  - `xenomai3-install.sh`
- Reboot to xenomai kernel (You probably have to select it in grub)
- Check for xenomai
  - `sudo dmesg | grep -i xenomai`
- Build LinuxCNC
  - `git clone https://github.com/LinuxCNC/linuxcnc.git linuxcnc-src`
  - `cd inuxcnc-src/src`
  - `./debian/configure`
  - `sudo apt-get build-dep .`
  - `./autogen.sh`
  - `./configure --with-realtime=uspace`
    - configure should show:<br>
    `checking for rtai-config... none`<br>
    `checking for xeno-config... /usr/xenomai/bin/xeno-config`<br>
    `checking for realtime API(s) to use... uspace+xenomai`
  - `make -j`
  - `sudo make setuid`
- Run LinuxCNC
  - ../scripts/linuxcnc
  - LinuxCNC should show: `Note: Using XENOMAI (posix-skin) realtime`
  - latency-histogram is broken and has to be started using: <br>
  `../scripts/rip-environment ../scripts/latency-histogram`

## Notes

<strong>The target of this repo is to make it easy for others to use LinuxCNC with Xenomai3. No waranty can be given!</strong>

### Xenomai3 tools
- Xenomai latency test
  - Select an isolated CPU. For example for CPU3: <br>
  `sudo /usr/lib/xenomai/testsuite/latency -c 3`
- Check for Xenomai enabled threads
  - `cat /proc/xenomai/sched/threads`
  - rtapi_app should show up on the isolated CPU

### Xenomai3 userspace tools plain install
```
#make and install
cd xenomai3

patch -p1 < ../xenomai3-master.patch
./scripts/bootstrap
./configure --with-core=mercury --enable-smp --enable-pshared --enable-dlopen-libs
make
sudo make install
echo "/usr/xenomai/lib" | sudo tee /etc/ld.so.conf.d/xenomai.conf > /dev/null
sudo ldconfig

#before building linuxcnc:
export PATH=$PATH:/usr/xenomai/bin

#uninstall:
sudo make uninstall
sudo rm -r /usr/xenomai/
```