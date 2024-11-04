#!/bin/bash

cp PKGBUILD PKGBUILD-deb
sed -i -E 's/pkgver=r(.*)/pkgver=0\.0\.0\.\1/' PKGBUILD-deb
sed -i 's/gtk3/libgtk-3-0/
s/webkit2gtk/libwebkit2gtk-4.0-dev/
s/'"'"'zig=.*'"'"'/libglx-dev/
' PKGBUILD-deb

sudo apt update
sudo apt install -y git

zigver=$(grep -oP "zig=\\K[^']+" PKGBUILD)
# download zig if the directory does not exist
zigname=zig-linux-$(arch)-$zigver
if [ ! -f $zigname ]; then
    # download zig archive if it does not exist
    [ -f $zigname.tar.xz ] || wget -O $zigname.tar.xz https://ziglang.org/download/0.13.0/$zigname.tar.xz
    tar -xf $zigname.tar.xz
fi
export PATH=$PWD/$zigname:$PATH
yes | tr '[:lower:]' '[:upper:]' | makedeb -s -F PKGBUILD-deb

# rm zig-$zigver.tar.xz
# rm -rf zig
# rm PKGBUILD-deb