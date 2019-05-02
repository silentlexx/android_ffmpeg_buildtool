#!/bin/bash

cd libvpx

make distclean
rm Makefile

TARGET=$CPU

ADDI_CFLAGS=""
ASFLAGS="-D__ANDROID__"

if [ $CPU == "arm" ];
then 
  TARGET="armv7"
  export AS=$AS_ORIG
fi

if [ $CPU == "arm64" ];
then 
  TARGET="arm64"
  export AS=$AS_ORIG
fi

if [ $CPU == "x86" ];
then 
  export CFLAGS="$CFLAGS -D__ANDROID__ -std=c11 -D__ANDROID_API__=15"
  export AS="yasm"
fi

if [ $CPU == "x86_64" ];
then 
  export CFLAGS="$CFLAGS -D__ANDROID__ -std=c11"
  export AS="yasm"
fi

../fixobj.sh $PLATFORM $(pwd)

export LIBS="-lc -lgcc -lm"

./configure --prefix=$PREFIX  --disable-install-bins --cpu=$SO_CPU $FIX \
--disable-shared --enable-vp8 --enable-vp9 --enable-thumb  \
--enable-pic \
--target=$TARGET-linux-gcc \
--disable-examples 


#read

make V=1 -j8
make install