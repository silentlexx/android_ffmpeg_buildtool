#!/bin/bash

#ONLY  FOR API21

cd xavs2/build/linux

export LIBS="-lc"

build(){

rm -rf config.mak
./configure --prefix=$PREFIX --sysroot=$SYSROOT  $HOST \
    --enable-pic --enable-static --enable-strip --disable-cli $FIX --extra-cflags="$EXTRA_CFLAGS"
make clean
make STRIP= $J
make install

}

if [ $CPU == "x86_64" ];
then
  export AS="nasm"
  build
fi

if [ $CPU == "arm64" ];
then
    export FIX="--disable-asm"
    export EXTRA_CFLAGS="-march=armv8-a -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__ -fPIE -pie"
    build
fi

