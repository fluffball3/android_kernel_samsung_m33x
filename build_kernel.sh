#!/bin/bash

KERNEL_HOME="$(pwd)"
export PATH="$(pwd)/../build-tools/path/linux-x86:$PATH"
export PATH="$(pwd)/../clang-r530567/bin:$PATH"
export CC="$(pwd)/../clang-r530567/bin/clang"

if [ ! -d "$KERNEL_HOME/../build-tools" ]; then
    echo "Please execute "build.sh" instead"
    if [ ! -d "$KERNEL_HOME/../clang-r530567" ]; then
        if [ -d "$KERNEL_HOME/../build-tools" ]; then
        echo "!!"
        else
        echo "Please execute "build.sh" instead"
        fi
    fi
else
    make O=out CROSS_COMPILE="$KERNEL_HOME/../clang-r530567/bin/aarch64-linux-gnu-" PLATFORM_VERSION=12 ANDROID_MAJOR_VERSION=s LLVM=1 LLVM_IAS=1 ARCH=arm64 TARGET_SOC=s5e8825 m33x_defconfig menuconfig
    #make O=out CROSS_COMPILE="$KERNEL_HOME/../clang-r530567/bin/aarch64-linux-gnu-" PLATFORM_VERSION=12 ANDROID_MAJOR_VERSION=s LLVM=1 LLVM_IAS=1 ARCH=arm64 TARGET_SOC=s5e8825 -j$(nproc --all)
fi
