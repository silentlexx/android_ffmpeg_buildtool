#!/bin/bash

#git clone https://github.com/appunite/fribidi.git

cd fribidi

make clean
rm Makefile



export LIBS="-lc -lgcc"

./bootstrap

./configure --prefix=$PREFIX $HOST --enable-static --disable-shared --with-sysroot=$SYSROOT

make $J
make install