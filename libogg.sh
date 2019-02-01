#!/bin/bash

cd libogg

make clean
rm Makefile

export LIBS="-lc -lgcc"

autoreconf -f -i

./configure --prefix=$PREFIX $HOST --disable-shared

make -j8
make install