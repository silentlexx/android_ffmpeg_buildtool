#!/bin/bash

cd libvpx

make distclean
rm Makefile

TARGET=$CPU

ADDI_CFLAGS=""

if [ $CPU == "arm" ];
then 
  TARGET="armv7"
fi

if [ $CPU == "arm64" ];
then 
  TARGET="arm64"
fi

if [ $CPU == "x86" ];
then 
  export AS="nasm"
fi

if [ $CPU == "x86_64" ];
then 
  export AS="nasm"
fi

../fixobj.sh $PLATFORM $(pwd)

export LIBS="-lc -lgcc"

./configure --prefix=$PREFIX  --disable-install-bins  --disable-shared --enable-vp8 --enable-vp9 \
--enable-pic  --disable-sse4_1 \
--target=$TARGET-linux-gcc \
--disable-examples \
--extra-cflags="$ADDI_CFLAGS" 


make V=1 -j8
make install