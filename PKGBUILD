# Maintainer: o.s.dv.f@seznam.cz
pkgname=deshader-git
pkgver=r8f64c14
pkgrel=1
pkgdesc="Shader debugging via GLSL code instrumentation"
arch=('i686' 'x86_64')
url="https://github.com/OSDVF/deshader"
depends=('gtk3'
         'webkit2gtk')
makedepends=('git'
             'zig'
             'binutils'
             'unzip'
             'curl'
             'zip'
             'tar'
             'pkgconf'
             )
options=('!lto')
provides=('deshader=$pkgver'
          'deshader-run=$pkgver')
conflicts=('deshader'
          'deshader-run')
source=('deshader-run.desktop'
        'deshader-run.svg'
        'git+https://github.com/OSDVF/deshader.git')
sha256sums=('SKIP'
            'SKIP'
            'SKIP')

pkgver() {
    cd "$srcdir/${pkgname%-git}"
    printf "r%s" "$(git describe --tags --always)"
}

build_deshader() {
    zig build deshader --release=safe # do not override build flags by makepkg
}

build() {
    # do not override build flags by makepkg -- will corrupt the build for use with Zig
    export CFLAGS=""
    export CXXFLAGS=""
    export CPPFLAGS=""
    export LDFLAGS=""

    cd "$srcdir/${pkgname%-git}"
    if ! build_deshader; then # must be ran twice to fix the C import
        chmod +x fix_c_import.sh
        ./fix_c_import.sh
        build_deshader
    fi
    zig build runner --release=safe
}

prepare() {
    export PATH="$srcdir/dep/bin:$srcdir/vcpkg:$PATH"
    export ZIG_GLOBAL_CACHE_DIR="$srcdir/dep/.zig-cache"
    export VCPKG_DEFAULT_BINARY_CACHE_DIR="$srcdir/dep/.vcpkg-cache"
    export VCPKG_DISABLE_METRICS=1

    # get the submodules
    cd "$srcdir/${pkgname%-git}"

    git submodule update --init --recursive

    cd "$srcdir"
    # check for bun in the path
    if ! command -v bun; then
        # download bun
        curl -fsSL https://bun.sh/install | BUN_INSTALL="$srcdir/dep" bash
    fi

    # check for VCPKG
    if ! command -v vcpkg; then
        # check for downloaded VCPKG repository
        if [ -d "$srcdir/vcpkg" ]; then
            # check if it is a git repository
            if [ -d "$srcdir/vcpkg/.git" ]; then
                # update VCPKG
                cd "$srcdir/vcpkg"
                git pull
            else
                # remove the directory
                rm -rf "$srcdir/vcpkg"
            fi
        
        else
            # download VCPKG
            git clone https://github.com/microsoft/vcpkg.git
        fi
        cd "$srcdir/vcpkg"
        chmod +x ./bootstrap-vcpkg.sh
        ./bootstrap-vcpkg.sh
    fi
}

package() {
    install -d "${pkgdir}/usr/bin"
    install -d "${pkgdir}/usr/lib"
    install -d "${pkgdir}/usr/share/applications"
    install -d "${pkgdir}/usr/share/icons"

    install -m755 "$srcdir/${pkgname%-git}/zig-out/bin/deshader-run" "$pkgdir/usr/bin/deshader-run"
    install -m755 "$srcdir/${pkgname%-git}/zig-out/lib/libdeshader.so" "$pkgdir/usr/lib/libdeshader.so"
    install -m644 "$srcdir/deshader-run.desktop" "$pkgdir/usr/share/applications/deshader-run.desktop"
    install -m644 "$srcdir/deshader-run.svg" "$pkgdir/usr/share/icons/deshader-run.svg"
}
