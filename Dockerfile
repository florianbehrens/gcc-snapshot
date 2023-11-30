FROM ubuntu:22.04

ENV TARBALL=gcc-14-20231126.tar.xz
WORKDIR /tmp/gcc-build

RUN apt-get update -y && \
    apt-get install -y wget build-essential file flex libz-dev && \
    wget -nv https://ftp.mpi-inf.mpg.de/mirrors/gnu/mirror/gcc.gnu.org/pub/gcc/snapshots/14-20231126/${TARBALL} && \
    tar --strip-components=1 -xJf ${TARBALL} && \
    rm ${TARBALL} && \
    ./contrib/download_prerequisites --no-isl && \
    ./configure --prefix=/opt/gcc-latest --enable-languages=c,c++ --enable-libstdcxx-debug --enable-libstdcxx-backtrace --disable-bootstrap --disable-multilib --disable-libvtv --with-system-zlib --without-isl --enable-multiarch && \
    make -j$(nproc) && \
    make install && \
    apt-get remove -y wget build-essential file flex libz-dev && \
    rm -rf .

WORKDIR /
CMD /bin/bash
