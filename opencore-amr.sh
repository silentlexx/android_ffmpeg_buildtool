#!/bin/bash

cd opencore-amr

make clean
rm Makefile
./autogen.sh

export LIBS="-lc -lgcc"

./configure --prefix=$PREFIX $HOST --disable-shared --with-sysroot=$SYSROOT

make V=1 -j8
make install