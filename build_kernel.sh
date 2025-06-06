#!/bin/bash

export PATH=$(pwd)/toolchain/clang/host/linux-x86/clang-r522817/bin:$PATH
export PATH=$(pwd)/toolchain/build/build-tools/path/linux-x86:$(pwd)/toolchain/prebuilts/gas/linux-x86:$PATH

BUILD_ARGS="LOCALVERSION=-Elite3XP-1.0 KBUILD_BUILD_USER=fluffyball21 KBUILD_BUILD_HOST=Inudesu"
export DTC_FLAGS="-@"
export PLATFORM_VERSION=13
export ANDROID_MAJOR_VERSION=t
export LLVM=1
export DEPMOD=depmod

make O=out $BUILD_ARGS ARCH=arm64 TARGET_SOC=s5e8825 CROSS_COMPILE=$(pwd)/toolchain/clang/host/linux-x86/clang-r522817/bin/aarch64-linux-gnu- m33x_defconfig
make O=out $BUILD_ARGS ARCH=arm64 TARGET_SOC=s5e8825 CROSS_COMPILE=$(pwd)/toolchain/clang/host/linux-x86/clang-r522817/bin/aarch64-linux-gnu- -j$(nproc --all)
