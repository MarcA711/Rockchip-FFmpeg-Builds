#!/bin/bash

SCRIPT_REPO="https://github.com/MarcA711/rkrga-static.git"
SCRIPT_COMMIT="4db448af9bcac06d3b8a68bcac2aaaeee224b487"

ffbuild_enabled() {
    [[ $ADDINS_STR == *-rk ]] && return 0
    return -1
}

ffbuild_dockerbuild() {
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
