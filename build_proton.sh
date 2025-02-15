#!/bin/bash
unset CXX
export ARCH=arm64
export PLATFORM_VERSION=14
export ANDROID_MAJOR_VERSION=u
ln -s /usr/bin/python2.7 $HOME/python
export PATH=$HOME/:$HOME/toolchains/neutron-clang/bin:$PATH #path to proton
mkdir out
clear

ARGS="
CC=clang
CROSS_COMPILE=aarch64-linux-gnu-
ARCH=arm64
LD=ld.lld
AR=llvm-ar
NM=llvm-nm
OBJCOPY=llvm-objcopy
OBJDUMP=llvm-objdump
READELF=llvm-readelf
OBJSIZE=llvm-size
STRIP=llvm-strip
LLVM_AR=llvm-ar
LLVM_DIS=llvm-dis
CROSS_COMPILE_ARM32=arm-linux-gnueabi-
"
make -j$(nproc) -C $(pwd) O=$(pwd)/out ${ARGS} clean && make -j8 -C $(pwd) O=$(pwd)/out ${ARGS} mrproper
make -j$(nproc) -C $(pwd) O=$(pwd)/out ${ARGS} r9q_eur_openx_defconfig
make -j$(nproc) -C $(pwd) O=$(pwd)/out ${ARGS}
#to copy all the kernel modules (.ko) to "modules" folder.
mkdir -p modules
find . -type f -name "*.ko" -exec cp -n {} modules \;
echo "Module files copied to the 'modules' folder."
