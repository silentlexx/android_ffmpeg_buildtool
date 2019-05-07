#!/bin/bash

cd wavpack

make clean
rm Makefile

export LIBS="-lc"

#autoreconf -f -i

./configure --prefix=$PREFIX $HOST --disable-shared --disable-apps

make $J
make install