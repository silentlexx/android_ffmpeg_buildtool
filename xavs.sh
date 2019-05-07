#!/bin/bash

cd xavs


export LIBS="-lc"

build(){
make clean

./configure $HOST --enable-pic --prefix=$PREFIX 

make $J
#make install

cat ./libxavs.a > $PREFIX/lib/libxavs.a
cat ./xavs.pc > $PREFIX/lib/pkgconfig/xavs.pc
cat ./xavs.h > $PREFIX/include/xavs.h
}

if [ $CPU == "x86" ];
then 
  build
fi

if [ $CPU == "x86_64" ];
then 
 build
fi

