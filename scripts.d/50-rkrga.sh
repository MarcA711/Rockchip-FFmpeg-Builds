#!/bin/bash

# this is the upstream repo of mpp
# SCRIPT_REPO="https://github.com/JeffyCN/mirrors.git"
# SCRIPT_COMMIT="d7a0a485ed6c201f882c20b3a8881e801f131385"
# SCRIPT_BRANCH="linux-rga-multi"

# this is a fork from nyanmisaka with some additional fixes
SCRIPT_REPO="https://github.com/nyanmisaka/rk-mirrors.git"
SCRIPT_COMMIT="a9fc19e6b906d7cecd6bcefbd45e5e151831d33f"
SCRIPT_BRANCH="jellyfin-rga"

ffbuild_enabled() {
    [[ $ADDINS_STR == *-rk ]] && return 0
    return -1
}

ffbuild_dockerbuild() {
    sed -i 's/shared_library/library/g' meson.build

    mkdir builddir && cd builddir

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --buildtype=release
        --default-library=static
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --cross-file=/cross.meson
        )
    else
        echo "Unknown target"
        return -1
    fi

    meson "${myconf[@]}" ..
    ninja -j$(nproc)
    ninja install
}

ffbuild_configure() {
    echo --enable-rkrga
}

ffbuild_unconfigure() {
    echo --enable-rkrga
}

ffbuild_libs() {
    echo -lstdc++
}
