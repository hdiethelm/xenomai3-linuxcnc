# Xenomai3 Kernel for LinuxCNC

<strong>Work in progress, things might not work or break your system!</strong>

<strong>Feedback is welcome, create an issue or pull request</strong>

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

All instuctions in here base on the documentation on https://v3.xenomai.org/ with some quirks resolved.

### Ethernet

For ethernet drivers, look in:
https://gitlab.com/Xenomai/xenomai3/xenomai/-/blob/master/kernel/drivers/net/drivers/Kconfig?ref_type=heads

Driver info from Intel: https://www.intel.com/content/www/us/en/support/articles/000005480/ethernet-products.html

The only two drivers are availabe up to now for Xenimai3 and Xenomai4 are:
- Intel igb
  - The RTNet driver is older: 2015 vs. upstream 2018
  - Cards still on sale:
    - 82576
    - I210
    - I350
- Intel e1000e
  - The RTNet driver is older: 2011 vs. upstream 2018
  - Works for tesing in qemu + virtmanager
  - The folling network cards probably work:
    - 82563/6/7
    - 82571/2/3/4/7/8/9
    - 82583
    - I217
  - The following network cards meight not work, there are only a few or no occurences of this name in the xenimai module compared to the stock module:
    - I218
    - I219

### Xenomai3 tools
- Xenomai latency test
  - Select an isolated CPU. For example for CPU3: <br>
  `sudo /usr/lib/xenomai/testsuite/latency -c 3`
- Check for Xenomai enabled threads
  - `cat /proc/xenomai/sched/threads`
  - rtapi_app should show up on the isolated CPU
  - `cat /proc/xenomai/sched/stat` shows the status MSW should stay constant (unwanted mode switches)

### Xenomai3 userspace tools plain install
For other operating systems or if you have issues with the debian packages
```
#make and install
cd xenomai3

./scripts/bootstrap
./configure --enable-smp --enable-pshared --enable-dlopen-libs
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
