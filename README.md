# Deshader AUR package

To create Arch package, run 
```bash
makepkg
```

To install the package, run
```bash
sudo pacman -U deshader*
```

To create debian package
```bash
git clone . deb && for release in debian-bullseye; do docker run -v "$PWD/deb:/home/makedeb" ghcr.io/makedeb/makedeb:$release bash makedeb.bash; done; rm -rf deb
```