#!/bin/bash
original_dir=$(pwd)
srcdir=$original_dir/src

# Create Deshader.app for macOS
echo "==> Loading PKGBUILD"
source ./PKGBUILD || exit 1

steps="fetch version prepare build check package"
if [[ "$@" != "" ]]; then steps="$@"; fi

for step in $steps; do
    case $step in
    fetch)
    cd $original_dir
    # Prepare sources
    echo "==> Fetching sources"
    mkdir -p src
    # Check for updates if already exists
    if [ -d src/deshader/.git ]; then
        cd src/deshader
        git fetch
        git reset --hard origin/main
        cd $original_dir
    else
        gitsource=${source[${#source[@]} - 1]}
        git clone ${gitsource#git+} src/deshader
    fi
    ;;

    version)
    # Fetch package version
    echo "==> Fetching package version"
    pkgver=$(pkgver)
    echo "==> Package version: $pkgver"
    ;;

    prepare)
    # Prepare dependencies
    echo "==> Preparing dependencies"
    prepare || exit 2
    cd $original_dir
    ;;

    build)
    # Build
    echo "==> Building"
    build || exit 3
    cd $original_dir
    ;;

    check)
    # Check
    echo "==> Checking"
    check || exit 4
    cd $original_dir
    ;;

    package)
    # Create app bundle
    echo "==> Creating app bundle"
    mkdir -p Deshader.app/Contents/MacOS
    cp Info.plist Deshader.app/Contents/Info.plist
    plutil -convert binary1 Deshader.app/Contents/Info.plist
    cp -r $srcdir/deshader/zig-out/* Deshader.app/Contents/
    if ! [ -L Deshader.app/Contents/MacOS/Deshader ] || ! [ $(readlink Deshader.app/Contents/MacOS/Deshader) = "../bin/deshader-run" ]; then
        unlink Deshader.app/Contents/MacOS/Deshader
        ln -s ../bin/deshader-run Deshader.app/Contents/MacOS/Deshader
    fi
    mkdir -p Deshader.app/Contents/Resources
    cp 256.png Deshader.app/Contents/Resources/icon.png
    ;;
    esac
done