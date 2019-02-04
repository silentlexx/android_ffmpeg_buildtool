#!/bin/bash

cd theora


make clean
rm Makefile

export LIBS="-lc -lgcc -logg -lvorbis"

autoreconf -f -i

./configure --prefix=$PREFIX $HOST --disable-examples --disable-doc --disable-shared # --disable-asm

make cleanmake -j8
make install