#!/bin/bash

cd vorbis

make clean
rm Makefile

export LIBS="-lc -lgcc -logg"

autoreconf -f -i

./configure --prefix=$PREFIX $HOST --disable-shared --with-sysroot=$SYSROOT

make -j8
make install