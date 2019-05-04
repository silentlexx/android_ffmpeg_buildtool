#!/bin/bash

cd libuuid

make clean

export LIBS="-lc"

autoreconf -f -i

./configure --prefix=$PREFIX $HOST --disable-shared --enable-static

make $J
make install

