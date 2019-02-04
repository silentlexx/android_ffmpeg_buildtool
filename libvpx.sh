#!/bin/bash

cd libvpx

make distclean
rm Makefile

TARGET=$CPU

ADDI_CFLAGS=""

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
  export ASFLAGS="-D__ANDROID__"
  export AS="nasm"
fi

if [ $CPU == "x86_64" ];
then 
  export ASFLAGS="-D__ANDROID__"
  export AS="nasm"
fi

../fixobj.sh $PLATFORM $(pwd)

export LIBS="-lc -lgcc"

./configure --prefix=$PREFIX  --disable-install-bins --cpu=$SO_CPU --disable-shared --enable-vp8 --enable-vp9 --enable-thumb  \
--enable-pic  --disable-sse4_1 \
--target=$TARGET-linux-gcc \
--disable-examples \
--extra-cflags="$ADDI_CFLAGS" 

#read

make V=1 -j8
make install