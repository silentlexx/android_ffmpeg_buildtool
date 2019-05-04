#!/bin/bash

cd libxml2

make clean

export LIBS="-lc -lgcc"

autoreconf -f -i

./configure --prefix=$PREFIX $HOST --disable-shared --enable-static

make $J
make install

