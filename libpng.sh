#!/bin/bash

cd libpng

make clean
rm Makefile

export LIBS="-lc -lgcc"

./configure --prefix=$PREFIX $HOST  --disable-shared --with-sysroot=$SYSROOT

make -j8
make install