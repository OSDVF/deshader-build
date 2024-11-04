# Deshader AUR package

To create Arch package, run 
```bash
makepkg
```

To install the package, run
```bash
sudo pacman -U deshader*
```

To create __debian__ package under Arch Linux and Docker, run
```bash
git clone . deb; for release in debian-bullseye; do docker run -v "$PWD/deb:/home/makedeb" ghcr.io/makedeb/makedeb:$release bash makedeb.bash; done && cp deb/deshader-git*.deb .
```

Or if you're on a Debian-based system, run
```bash
bash makedeb.bash
```