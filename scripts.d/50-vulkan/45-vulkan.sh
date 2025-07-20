#!/bin/bash

SCRIPT_REPO="https://github.com/KhronosGroup/Vulkan-Headers.git"
SCRIPT_COMMIT="v1.4.322"
SCRIPT_TAGFILTER="v?.*.*"

SCRIPT_REPO2="https://github.com/KhronosGroup/Vulkan-Headers.git"
SCRIPT_COMMIT2="v1.3.276"

ffbuild_enabled() {
    [[ $ADDINS_STR == *4.4* ]] && return -1
    return 0
}

ffbuild_dockerdl() {
    default_dl Vulkan-Headers
    echo "git-mini-clone \"$SCRIPT_REPO2\" \"$SCRIPT_COMMIT2\" Vulkan-Headers2"
}

ffbuild_dockerbuild() {
    if [[ $ADDINS_STR == *6.1-rk* ]]; then
        cd Vulkan-Headers2
        VULKAN_VERSION=$SCRIPT_COMMIT2
    else
        cd Vulkan-Headers
        VULKAN_VERSION=$SCRIPT_COMMIT
    fi

    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" \
        -DVULKAN_HEADERS_ENABLE_MODULE=NO -DVULKAN_HEADERS_ENABLE_TESTS=NO -DVULKAN_HEADERS_ENABLE_INSTALL=YES ..
    make -j$(nproc)
    make install

    cat >"$FFBUILD_PREFIX"/lib/pkgconfig/vulkan.pc <<EOF
prefix=$FFBUILD_PREFIX
includedir=\${prefix}/include

Name: vulkan
Version: ${VULKAN_VERSION:1}
Description: Vulkan (Headers Only)
Cflags: -I\${includedir}
EOF
}

ffbuild_configure() {
    echo --enable-vulkan
}

ffbuild_unconfigure() {
    echo --disable-vulkan
}
