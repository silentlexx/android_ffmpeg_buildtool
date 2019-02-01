#!/bin/bash

cd x264

make clean

export LIBS="-lc -lgcc -lm"

./configure --prefix=$PREFIX --exec-prefix=$PREFIX $HOST --sysroot=$SYSROOT --disable-asm \
    --enable-static  \
    --enable-pic --disable-opencl \
    --disable-cli
    
make -j8
make install