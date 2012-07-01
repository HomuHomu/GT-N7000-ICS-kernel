#!/bin/sh

KERNEL_NAME="HomuraNote-ICS"
export USE_SEC_FIPS_MODE=true
export LOCALVERSION="-$KERNEL_NAME"
export KBUILD_BUILD_VERSION="Alpha1"
export WHOAMI_MOD="Homura"
export HOSTNAME_MOD="Akemi"

echo "GT-N7000 KERNEL IMAGE BUILD START!!!"

read -p "build? [(a)ll/(u)pdate/(z)Image default:update] " ANS

echo "copy initramfs..."
if [ -d /tmp/N7000_ICS_initramfs ]; then
  rm -rf /tmp/N7000_ICS_initramfs
fi
cp -a ../N7000_ICS_initramfs /tmp/
rm -rf /tmp/N7000_ICS_initramfs/.git
find /tmp/N7000_ICS_initramfs -name .gitignore | xargs rm

# make start
if [ "$ANS" = 'all' -o "$ANS" = 'a' ]; then
  echo "cleaning..."
  make clean
  make mrproper
  make Homura_Note_defconfig
fi

if [ "$ANS" != 'zImage' -a "$ANS" != 'z' ]; then
  echo "build start..."
  if [ -e make.log ]; then
    mv make.log make_old.log
  fi
  make -j12 2>&1 | tee make.log
  if [ $? != 0 ]; then
    echo "NG make!!!"
    exit
  fi
  # *.ko replace
  find -name '*.ko' -exec cp -av {} /tmp/N7000_ICS_initramfs/lib/modules/ \;
fi

# build zImage
echo "make zImage..."
make zImage

# release zImage

cp arch/arm/boot/zImage ./

echo "copy zImage to ./out/zImage"
echo 'Please download and run command "sudo heimdall flash --kernel ./zImage --verbose"'

echo "GT-N7000 KERNEL IMAGE BUILD COMPLETE!!!"
