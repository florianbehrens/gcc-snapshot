#!/bin/bash

PACKAGES='curl build-essential file flex libz-dev'
BASEURL='https://ftp.mpi-inf.mpg.de/mirrors/gnu/mirror/gcc.gnu.org/pub/gcc/snapshots/LATEST-14'

apt-get update -y
apt-get install -y ${PACKAGES}

TMPDIR=$(mktemp -d)
pushd ${TMPDIR}

TARBALL=$(curl -s ${BASEURL}/sha512.sum | grep -oE 'gcc-[[:digit:]]+-[[:digit:]]+\.tar\.xz')
curl -sO ${BASEURL}/${TARBALL}
tar --strip-components=1 -xJf ${TARBALL}
rm ${TARBALL}

./contrib/download_prerequisites --no-isl
./configure --prefix=/opt/gcc-snapshot --enable-languages=c,c++ --enable-libstdcxx-debug --enable-libstdcxx-backtrace --disable-bootstrap --disable-multilib --disable-libvtv --with-system-zlib --without-isl --enable-multiarch
make -j$(nproc)
make install

popd
rm -rf ${TMPDIR}

apt-get remove -y ${PACKAGES}
apt autoremove -y && apt clean -y
