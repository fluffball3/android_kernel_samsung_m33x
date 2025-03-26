#!/bin/bash

export PATH=$(pwd)/../clang-r416183b/bin:$PATH
export PATH=$(pwd)/../build-tools/path/linux-x86:$PATH
MODULES_OUTDIR="$(pwd)/modules_out"
MODULES_DIR="$MODULES_OUTDIR/lib/modules"
IMAGE="$(pwd)/out/arch/arm64/boot/Image"
KERNEL_HOME="$(pwd)"

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
    rm -r "$MODULES_OUTDIR"
    make $BUILD_ARGS PLATFORM_VERSION=12 ANDROID_MAJOR_VERSION=s LLVM=1 LLVM_IAS=1 ARCH=arm64 TARGET_SOC=s5e8825 CROSS_COMPILE="$KERNEL_HOME/../clang-r416183b/bin/aarch64-linux-gnu-" -C $(pwd) O=out INSTALL_MOD_STRIP="--strip-debug" INSTALL_MOD_PATH="$MODULES_OUTDIR" modules_install  -j$(nproc --all)

    mkdir -p "$MODULES_DIR/0.0"
    missing_modules=""

    for module in $(cat "$KERNEL_HOME/kernel_build/vboot_dlkm/modules.load"); do
        i=$(find "$MODULES_OUTDIR/lib/modules" -name $module);
        if [ -f "$i" ]; then
            cp -f "$i" "$MODULES_DIR/0.0/$module"
        else
        missing_modules="$missing_modules $module"
        fi
    done

    if [ "$missing_modules" != "" ]; then
        echo "ERROR: the following modules were not found: $missing_modules"
    fi

    depmod 0.0 -b "$MODULES_OUTDIR"
    sed -i 's/\([^ ]\+\)/\/lib\/modules\/\1/g' "$MODULES_DIR/0.0/modules.dep"
    cd "$MODULES_DIR/0.0"
    for i in $(find . -name "modules.*" -type f); do
        if [ $(basename "$i") != "modules.dep" ] && [ $(basename "$i") != "modules.softdep" ] && [ $(basename "$i") != "modules.alias" ]; then
            rm -f "$i"
        fi
    done

    cd "$KERNEL_HOME"
fi
