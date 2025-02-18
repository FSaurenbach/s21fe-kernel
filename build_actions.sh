#!/bin/bash

# ---- ENVIRONMENT ---- #
unset CXX
export ARCH=arm64
export PLATFORM_VERSION=14
export ANDROID_MAJOR_VERSION=u

# Enable ccache properly
export USE_CCACHE=1
export CCACHE_DIR=$HOME/.ccache
export CC="ccache clang"
export CXX="ccache clang++"

# Symlink python2 for older kernel scripts (remove if unnecessary)
ln -sf /usr/bin/python2.7 $HOME/python
export PATH=$HOME/:$HOME/toolchains/neutron-clang/proton-clang/bin:$PATH

mkdir -p out
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

# ---- BUILD KERNEL ---- #
make -j$(nproc) -C $(pwd) O=$(pwd)/out ${ARGS} vendor/r9q_eur_openx_defconfig
make -j$(nproc) -C $(pwd) O=$(pwd)/out ${ARGS}

# ---- INSTALL MODULES (STRIPPED) ---- #
make -j$(nproc) -C $(pwd) O=$(pwd)/out ${ARGS} INSTALL_MOD_PATH=$(pwd)/modules INSTALL_MOD_STRIP=1 modules_install DEPMOD=/bin/true


# ---- COLLECT MODULES ---- #
mkdir -p modules_flat
find ./modules -type f -name "*.ko" -exec cp {} modules_flat/ \;
echo "Module files copied to the 'modules_flat' folder."

# ---- ANYKERNEL3 ZIP CREATION ---- #
ZIP_DIR="$(pwd)/AnyKernel3"
MOD_DIR="$ZIP_DIR/modules/vendor/lib/modules"

# Clone AnyKernel3 if it doesn't exist
if [ ! -d "AnyKernel3" ]; then
    git clone https://github.com/glikched/AnyKernel3 -b r9q
fi

# Prepare AnyKernel3 modules folder
rm -rf $ZIP_DIR/modules/
mkdir -p $MOD_DIR

# Copy modules into AnyKernel3
cp -r modules_flat/* $MOD_DIR/

# Copy Kernel Image
cp ./out/arch/arm64/boot/Image $ZIP_DIR/

# Copy DTBO (use stock fallback if needed)
if [ -f ./out/arch/arm64/boot/dtbo.img ]; then
    cp ./out/arch/arm64/boot/dtbo.img $ZIP_DIR/
else
    echo "Using stock dtbo.img (make sure you have it!)"
    cp ./stock_dtbo.img $ZIP_DIR/
fi

# Create ZIP package
ZIP_NAME="sauronskernel_r9q_$(date +%d%m%y-%H%M).zip"
cd $ZIP_DIR
zip -r9 "../$ZIP_NAME" . -x '*.git*' '*patch*' '*ramdisk*' 'LICENSE' 'README.md'
cd ..

echo "Kernel package created: $ZIP_NAME"
