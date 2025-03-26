#!/bin/bash

export PATH=$(pwd)/../clang-r416183b/bin:$PATH
export PATH=$(pwd)/../build-tools/path/linux-x86:$PATH
KERNEL_HOME="$(pwd)"
BUILD_ARGS="LOCALVERSION=-Elite3XP-v3.0 KBUILD_BUILD_USER=fluffyball21 KBUILD_BUILD_HOST=Inudesu"

if [ ! -d "$KERNEL_HOME/build-tools" ]; then
echo "Please execute "build.sh" instead"
fi
if [ ! -d "$KERNEL_HOME/clang-r416183b" ]; then
    if [ -d "$KERNEL_HOME/build-tools" ]; then
    echo "!!"
    else
    echo "Please execute "build.sh" instead"
    fi
else
make O=out $BUILD_ARGS PLATFORM_VERSION=12 ANDROID_MAJOR_VERSION=s LLVM=1 LLVM_IAS=1 ARCH=arm64 TARGET_SOC=s5e8825 CROSS_COMPILE="$KERNEL_HOME/../clang-r416183b/bin/aarch64-linux-gnu-" m33x_defconfig
make O=out $BUILD_ARGS PLATFORM_VERSION=12 ANDROID_MAJOR_VERSION=s LLVM=1 LLVM_IAS=1 ARCH=arm64 TARGET_SOC=s5e8825 CROSS_COMPILE="$KERNEL_HOME/../clang-r416183b/bin/aarch64-linux-gnu-" -j$(nproc --all)
fi
