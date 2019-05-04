#!/bin/bash

cd fontconfig

make clean
rm Makefile

autoreconf -f -i

export LIBS="-lc -lgcc -lpng"

./configure --prefix=$PREFIX $HOST --with-sysroot=$SYSROOT --disable-shared --enable-static --disable-docs --disable-nls --enable-libxml2

make $J
make install