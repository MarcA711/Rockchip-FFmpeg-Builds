#!/bin/bash

# SCRIPT_REPO="https://github.com/rockchip-linux/mpp.git"
# SCRIPT_COMMIT="bebc9961103af2b53fb18175dd858b15a73c9ad8"

SCRIPT_REPO="https://github.com/nyanmisaka/mpp.git"
SCRIPT_COMMIT="42070d0658fa8ccdd7b0726a46edc518fd908e02"
SCRIPT_BRANCH="jellyfin-mpp"

ffbuild_enabled() {
    [[ $ADDINS_STR == *-rk ]] && return 0
    return -1
}

ffbuild_dockerbuild() {
    mkdir bld
    cd bld

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DBUILD_TEST=OFF ..
    make -j$(nproc)
    make install

    rm -rf $FFBUILD_PREFIX/lib/librockchip_mpp.so*
}

ffbuild_configure() {
    echo --enable-rkmpp
}

ffbuild_unconfigure() {
    echo --disable-rkmpp
}

ffbuild_libs() {
    echo -lstdc++
}
