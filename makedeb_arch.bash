git clone --depth 1 . deb/deshader
if [ -z "$releases" ]; then
    releases="debian-bullseye"
fi
for release in $releases; do
    docker run -v "$PWD/deb/deshader:/home/makedeb" ghcr.io/makedeb/makedeb:$release bash makedeb.bash
    mkdir deb/$release
    mv deb/deshader/deshader-git*.deb deb/$release
done