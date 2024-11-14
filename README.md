# Deshader build and package scripts
These scripts will download the last development version of Deshader, build it and create a package for macOS, Arch Linux or Debian-based systems. These scripts also include a [Desktop file](deshader.desktop), icons, and header files for using [Zig and C API](https://github.com/OSDVF/deshader/blob/main/guide/API.md).

## Arch Linux
To create Arch package, run 
```bash
makepkg
```

To install the package, run
```bash
sudo pacman -U deshader*
```

## Debian
If you're on a Debian-based system, run
```bash
bash makedeb.bash
```
Requirements for build on Debian:
- [makedeb](https://github.com/makedeb/makedeb)


### Debian package under different distro
To create __debian__ package under Arch Linux and Docker, run
```bash
bash makedeb_arch.bash
```
It will build the package in a Docker container. To build for multiple Debian and Ubuntu versions ([supported by makedeb](https://docs.makedeb.org/installing/docker/)), use
```bash
releases="debian-bullseye debian-bookworm ubuntu-focal ubuntu-jammy ubuntu-noble ubuntu-oracular" bash makedeb_arch.bash
```

## macOS
To create macOS package, run
```bash
bash makeapp.bash
```

## Prebuilt packages
Packages for several Linux distributions and Windows are available on [Deshader releases page](https://github.com/osdvf/deshader/releases).

## License
These build scripts are public domain. Deshader is licensed under GPL 3.