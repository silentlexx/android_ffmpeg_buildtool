#!/bin/bash

cd lame

make clean
rm Makefile

export LIBS="-lc -lgcc"

./configure --prefix=$PREFIX $HOST \
    --enable-static --disable-shared

make -j8
make install