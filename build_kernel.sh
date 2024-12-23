#!/bin/bash

export PATH=$(pwd)/toolchain/clang/host/linux-x86/clang-r416183b/bin:$PATH
export PATH=$(pwd)/toolchain/build/build-tools/path/linux-x86:$(pwd)/toolchain/prebuilts/gas/linux-x86:$PATH
BUILD_ARGS="LOCALVERSION=-Elite3XP-v2.5 KBUILD_BUILD_USER=fluffyball21 KBUILD_BUILD_HOST=Inudesu"

make O=out $BUILD_ARGS PLATFORM_VERSION=13 ANDROID_MAJOR_VERSION=s LLVM=1 LLVM_IAS=1 ARCH=arm64 TARGET_SOC=s5e8825 CROSS_COMPILE=$(pwd)/toolchain/clang/host/linux-x86/clang-r416183b/bin/aarch64-linux-gnu- m33x_defconfig
make O=out $BUILD_ARGS PLATFORM_VERSION=13 ANDROID_MAJOR_VERSION=s LLVM=1 LLVM_IAS=1 ARCH=arm64 TARGET_SOC=s5e8825 CROSS_COMPILE=$(pwd)/toolchain/clang/host/linux-x86/clang-r416183b/bin/aarch64-linux-gnu- -j$(nproc --all)
