#!/bin/bash

cd xvidcore


cd build/generic

make clean

export LIBS="-lc -lm"


./bootstrap.sh

./configure --prefix=$PREFIX $HOST --disable-shared --enable-static

make -j8
make install

rm $PREFIX/lib/libxvidcore.so*