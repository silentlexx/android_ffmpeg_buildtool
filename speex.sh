#!/bin/bash

cd speex

make clean
rm Makefile

export LIBS="-lc"

#autoreconf -f -i

./configure --prefix=$PREFIX $HOST --disable-shared

make $J
make install