#!/bin/bash

cd x264

make clean

export LIBS="-lm -lpthread -lc"


if [ $CPU == "arm" ];
then
   export CFLAGS="$CFLAGS_TOOLCHAIN -O3 -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__ --sysroot=$SYSROOT -O3"
   export AS=$CC
fi

if [ $CPU == "x86" ];
then   
    export CFLAGS="$CFLAGS_TOOLCHAIN -O3 --sysroot=$SYSROOT"
    export AS="nasm"
    FIX="--disable-asm"
fi

if [ $CPU == "x86_64" ];
then
    export CFLAGS="$CFLAGS_TOOLCHAIN -O3 -DARCH_X86_64=1 --sysroot=$SYSROOT"
    export AS="nasm"
fi

if [ $CPU == "arm64" ];
then
   export CFLAGS="$CFLAGS_TOOLCHAIN -O3 -D__ARM_ARCH_8__ -D__ARM_ARCH_8A__ --sysroot=$SYSROOT"
   export AS=$CC
fi


./configure --prefix=$PREFIX --exec-prefix=$PREFIX --host=$ABI-linux --sysroot=$SYSROOT --enable-static --enable-strip --enable-pic $FIX

make -j8 install