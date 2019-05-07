#!/bin/bash

cd libwebp

make clean
rm Makefile

export LIBS="-lc"
export CFLAGS="$CFLAGS -std=c99"

autoreconf -f -i

./configure --prefix=$PREFIX $HOST --disable-shared  --enable-libwebpdecoder

make $J
make install