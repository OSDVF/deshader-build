#!/bin/bash

# Converts PKGBUILD to a format that can be accepted by makedeb to build a .deb package

cp PKGBUILD PKGBUILD-deb
sed -i -E 's/pkgver=r(.*)/pkgver=0\.0\.0\.\1/' PKGBUILD-deb # debian versions must start with a digit
sed -i 's/gtk3/libgtk-3-0/
s/webkit2gtk/libwebkit2gtk-4.0-37/
s/'"'"'zig=.*'"'"'/libglx-dev\n libwebkit2gtk-4.0-dev/
s/r%s/0.0.0.%s/
s/r$line/0.0.0.$line/
s/x86_64/amd64/
' PKGBUILD-deb # rename libraries and architecture

sudo apt update
sudo apt install -y git

if ! command -v zig; then # Download zig, as it is not available in the debian repositories
    zigver=$(grep -oP "zig=\\K[^']+" PKGBUILD)
    # download zig if the directory does not exist
    zigname=zig-linux-$(arch)-$zigver
    if [ ! -f $zigname ]; then
        # download zig archive if it does not exist
        [ -f $zigname.tar.xz ] || wget -O $zigname.tar.xz https://ziglang.org/download/0.13.0/$zigname.tar.xz
        tar -xf $zigname.tar.xz
    fi
    export PATH=$PWD/$zigname:$PATH
fi
yes | tr '[:lower:]' '[:upper:]' | makedeb -s -F PKGBUILD-deb

# add OS and architecture to the package name
name=$(grep -oP "pkgname=\\K[^']+" PKGBUILD-deb)
version=$(grep -oP "pkgver=\\K[^']+" PKGBUILD-deb)

mv $name*.deb $name-$version-$(lsb_release -cs)-$(arch).deb

# rm PKGBUILD-deb