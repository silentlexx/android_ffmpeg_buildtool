#!/bin/bash

#https://github.com/vault/libass.git

cd libass

make clean
rm Makefile

export LIBS="-lc -lpng"

autoreconf -f -i

./configure --prefix=$PREFIX $HOST  --disable-shared --enable--static  --disable-require-system-font-provider


make -j8
make install

