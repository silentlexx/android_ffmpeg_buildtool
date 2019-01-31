#!/bin/bash

cd flac

make clean
rm Makefile

#../fixobj.sh $PLATFORM $(pwd)/src/test_libFLAC++

export LIBS="-lc -lgcc"

./configure --prefix=$PREFIX $HOST --with-sysroot=$SYSROOT --disable-shared --disable-oggtest --disable-thorough-tests

make -j8
make install