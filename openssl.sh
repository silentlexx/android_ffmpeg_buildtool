#!/bin/bash

cd openssl

make clean
rm Makefile

export LIBS="-lc -lgcc"

export ANDROID_NDK_HOME=$NDK

export CROSS_COMPILE="${target_host}-"
export AR="ar"
export AS="gcc"
export CC="gcc"
export CXX="g++"
export LD="ld"
export STRIP="strip"

./Configure android-$CPU no-shared --prefix=$PREFIX --sysroot=$SYSROOT 

#sed -i -e "s/CROSS_COMPILE=/#CROSS_COMPILE=/g" ./Makefile

make $J
make install